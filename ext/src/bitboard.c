#include <stdio.h>
#include <stdlib.h>
#include "bitboard.h"
#include "bitmap.h"

#define HORZ_MASK 0x7e7e7e7e7e7e7e7eull
#define NO_MASK 0xffffffffffffffffull

static inline int min(int a, int b)
{
    return a < b ? a : b;
}

static inline u64 shift(u64 b, int n)
{
    if (n < 0)
        return b << (-n);
    else
        return b >> n;
}

static inline u64 flip_discs_left(u64 b, u64 w, int sq)
{
    w &= ~(w + (2ULL<<sq));
    return ((w<<1) & b) ? w : 0;
}

static inline u64 flip_discs_up(u64 b, u64 w, int sq)
{
    u64 mask = 0x0101010101010100ULL;
    w >>= sq;
    w |= ~mask;
    w &= ~(w + 0x100);
    w &= mask;
    w <<= sq;
    return ((w<<8) & b) ? w : 0;
}

static inline u64 flip_discs_up_left(u64 b, u64 w, int sq)
{
    u64 mask = 0x8040201008040200ULL;
    w >>= sq;
    w |= ~mask;
    w &= ~(w + 0x200);
    w &= mask;
    w <<= sq;
    return ((w<<9) & b) ? w : 0;
}

static inline u64 flip_discs_up_right(u64 b, u64 w, int sq)
{
    u64 mask = 0x0102040810204080ULL;
    w >>= sq;
    w |= ~mask;
    w &= ~(w + 0x80);
    w &= mask;
    w <<= sq;
    return ((w<<7) & b) ? w : 0;
}

static inline u64 flip_discs_dir(u64 b, u64 w, u64 move, int sh, int n)
{
    u64 f;

    if (n < 1)
        return 0;

    f = w & shift(move, sh);
    if (!f)
        return 0;
    switch (n) {
    case 6: f |= w & shift(f, sh); /* fallthrough */
    case 5: f |= w & shift(f, sh); /* fallthrough */
    case 4: f |= w & shift(f, sh); /* fallthrough */
    case 3: f |= w & shift(f, sh); /* fallthrough */
    case 2: f |= w & shift(f, sh);
    }
    return (shift(f, sh) & b) ? f : 0;
}

inline static u64 flip_discs_at(u64 b, u64 w, int move, int y, int x)
{
    u64 f, m, wm;

    m = 1ull << move;
    wm = w & HORZ_MASK;
    f = 0;

    if (x > 0 && y > 0)
        f |= flip_discs_up_left(b, wm, move);
    if (y > 0)
        f |= flip_discs_up(b, w, move);
    if (x < 3 && y > 0)
        f |= flip_discs_up_right(b, wm, move);
    if (x > 0)
        f |= flip_discs_left(b, wm, move);

    f |= flip_discs_dir(b, wm, m,  1, (3-x)*2); /* right */
    f |= flip_discs_dir(b, wm, m,  7, min(x, 3-y)*2); /* down left */
    f |= flip_discs_dir(b, w,  m,  8, (3-y)*2); /* down */
    f |= flip_discs_dir(b, wm, m,  9, min(3-x, 3-y)*2); /* down right */

    return f;
}

#define def_flip(y, x) \
static u64 flip##y##x(u64 b, u64 w, int move) \
{ \
    return flip_discs_at(b, w, move, y, x); \
}

def_flip(0,0) def_flip(0,1) def_flip(0,2) def_flip(0,3)
def_flip(1,0) def_flip(1,1) def_flip(1,2) def_flip(1,3)
def_flip(2,0) def_flip(2,1) def_flip(2,2) def_flip(2,3)
def_flip(3,0) def_flip(3,1) def_flip(3,2) def_flip(3,3)

typedef u64 (*flip_fn_t)(u64,u64,int);
static const flip_fn_t flip_fn_tbl[64] = {
    flip33,flip33,flip32,flip32,flip31,flip31,flip30,flip30,
    flip33,flip33,flip32,flip32,flip31,flip31,flip30,flip30,
    flip23,flip23,flip22,flip22,flip21,flip21,flip20,flip20,
    flip23,flip23,flip22,flip22,flip21,flip21,flip20,flip20,
    flip13,flip13,flip12,flip12,flip11,flip11,flip10,flip10,
    flip13,flip13,flip12,flip12,flip11,flip11,flip10,flip10,
    flip03,flip03,flip02,flip02,flip01,flip01,flip00,flip00,
    flip03,flip03,flip02,flip02,flip01,flip01,flip00,flip00,
};

u64 bb_flip_discs(bboard b, unsigned int move)
{
    return flip_fn_tbl[move](b.black, b.white, move);
}

bboard bb_move(bboard b, unsigned int move)
{
    u64 flip;
    u64 m;

    m = (u64) 1 << move;
    flip = bb_flip_discs(b, move);
    b.black ^= flip | m;
    b.white ^= flip;
    return b;
}

#if 0
#define ALL_MOVES(name, mask, shift) \
static inline u64 all_moves_##name(u64 black, u64 white, u64 empty) \
{ \
    u64 flip, w; \
    w = white & mask; \
    flip = w & (black shift); \
    flip |= w & (flip shift); \
    flip |= w & (flip shift); \
    flip |= w & (flip shift); \
    flip |= w & (flip shift); \
    flip |= w & (flip shift); \
    return (flip shift) & empty; \
}

ALL_MOVES(NW, HORZ_MASK, <<9)
ALL_MOVES(N,  NO_MASK,   <<8)
ALL_MOVES(NE, HORZ_MASK, <<7)
ALL_MOVES(W,  HORZ_MASK, <<1)
ALL_MOVES(E,  HORZ_MASK, >>1)
ALL_MOVES(SW, HORZ_MASK, >>7)
ALL_MOVES(S,  NO_MASK,   >>8)
ALL_MOVES(SE, HORZ_MASK, >>9)

u64 bb_all_moves(bboard b)
{
    u64 empty;

    empty = ~(b.black | b.white);
    
    return all_moves_N (b.black, b.white, empty)
         | all_moves_NE(b.black, b.white, empty)
         | all_moves_E (b.black, b.white, empty)
         | all_moves_SE(b.black, b.white, empty)
         | all_moves_S (b.black, b.white, empty)
         | all_moves_SW(b.black, b.white, empty)
         | all_moves_W (b.black, b.white, empty)
         | all_moves_NW(b.black, b.white, empty);
}
#else
u64 bb_all_moves(bboard b)
{
    u64 empty;
    u64 f, f0, f1, f2, f3;
    u64 wh, w;

    w = b.white;
    wh = w & HORZ_MASK;

    f0 = wh & (b.black >> 1);
    f1 = wh & (b.black >> 7);
    f2 = w  & (b.black >> 8);
    f3 = wh & (b.black >> 9);
    f0 |= wh & (f0 >> 1);
    f1 |= wh & (f1 >> 7);
    f2 |= w  & (f2 >> 8);
    f3 |= wh & (f3 >> 9);
    f0 |= wh & (f0 >> 1);
    f1 |= wh & (f1 >> 7);
    f2 |= w  & (f2 >> 8);
    f3 |= wh & (f3 >> 9);
    f0 |= wh & (f0 >> 1);
    f1 |= wh & (f1 >> 7);
    f2 |= w  & (f2 >> 8);
    f3 |= wh & (f3 >> 9);
    f0 |= wh & (f0 >> 1);
    f1 |= wh & (f1 >> 7);
    f2 |= w  & (f2 >> 8);
    f3 |= wh & (f3 >> 9);
    f0 |= wh & (f0 >> 1);
    f1 |= wh & (f1 >> 7);
    f2 |= w  & (f2 >> 8);
    f3 |= wh & (f3 >> 9);
    f0 = f0 >> 1;
    f1 = f1 >> 7;
    f2 = f2 >> 8;
    f3 = f3 >> 9;
    f = f0|f1|f2|f3;

    f0 = wh & (b.black << 1);
    f1 = wh & (b.black << 7);
    f2 = w  & (b.black << 8);
    f3 = wh & (b.black << 9);
    f0 |= wh & (f0 << 1);
    f1 |= wh & (f1 << 7);
    f2 |= w  & (f2 << 8);
    f3 |= wh & (f3 << 9);
    f0 |= wh & (f0 << 1);
    f1 |= wh & (f1 << 7);
    f2 |= w  & (f2 << 8);
    f3 |= wh & (f3 << 9);
    f0 |= wh & (f0 << 1);
    f1 |= wh & (f1 << 7);
    f2 |= w  & (f2 << 8);
    f3 |= wh & (f3 << 9);
    f0 |= wh & (f0 << 1);
    f1 |= wh & (f1 << 7);
    f2 |= w  & (f2 << 8);
    f3 |= wh & (f3 << 9);
    f0 |= wh & (f0 << 1);
    f1 |= wh & (f1 << 7);
    f2 |= w  & (f2 << 8);
    f3 |= wh & (f3 << 9);
    f0 = f0 << 1;
    f1 = f1 << 7;
    f2 = f2 << 8;
    f3 = f3 << 9;

    empty = ~(b.black | b.white);
    f |= f0|f1|f2|f3;
    f &= empty;
    return f;
}
#endif

int bb_mobility(bboard b)
{
    return bm_count_bits(bb_all_moves(b));
}

u64 bb_potential_moves(bboard b)
{
    u64 v, h, empty;

    v = (b.white<<8) | (b.white>>8);
    h = (b.white | v) & HORZ_MASK;
    h = (h<<1) | (h>>1);
    empty = ~(b.black | b.white);
    return (v | h) & empty;
}

int bb_potential_mobility(bboard b)
{
    return bm_count_bits(bb_potential_moves(b));
}

int bb_disc_diff(bboard bd)
{
    u64 a = bd.black;
    u64 b = bd.white;

    a = a - ((a>>1) & 0x5555555555555555ull);
    b = b - ((b>>1) & 0x5555555555555555ull);
    a = (a & 0x3333333333333333ull) + ((a>>2) & 0x3333333333333333ull);
    b = (b & 0x3333333333333333ull) + ((b>>2) & 0x3333333333333333ull);

    a += 0x4444444444444444ull;
    a -= b;

    a = (a & 0x0f0f0f0f0f0f0f0full) + ((a>>4) & 0x0f0f0f0f0f0f0f0full);
    a = (a * 0x0101010101010101ull) >> 56;
    return a - 64;
}

bboard bb_from_ascii(const char *s, int turn)
{
    int m;
    bboard b;
    int last;
    int swap;
    const char *orig_s = s;

    if (turn)
        last = -1;
    else
        last = 0;
    swap = 0;

    b.black = b.white = 0;
    for (m = 63; m >= last; m--) {
        while (1) {
            switch (*s) {
            case ' ': case '\t': case '\r': case '\n': case '\v':
                s++;
                break;
            default:
                goto out;
            }
        }
    out:
        switch (*s) {
        case 'O': case 'o': case 'w':
            if (m >= 0)
                b.white |= 1ull<<m;
            else
                swap = 1;
            break;
        case 'X': case 'x': case 'b':
            if (m >= 0)
                b.black |= 1ull<<m;
            else
                swap = 0;
            break;
        case '-': case '.': /* empty */
            break;
        default:
            fprintf(stderr, "Invalid character %#x in board data\n", *s);
            fprintf(stderr, "%s\n", orig_s);
            exit(1);
        }
        s++;
    }

    if (swap)
        b = bb_swap(b);

    return b;
}

void bb_print(bboard b)
{
    int x, y;

    puts("  a b c d e f g h");
    for (y = 0; y < 8; y++) {
        printf("%d ", y+1);
        for (x = 0; x < 8; x++) {
            u64 m = 1ull << (63 - (y*8 + x));
            if (b.black & m)
                putchar('X');
            else if (b.white & m)
                putchar('O');
            else
                putchar('-');
            putchar(' ');
        }
        printf("%d\n", y+1);
    }
    puts("  a b c d e f g h");
}

const char *bb_square_to_ascii(int move)
{
    static char buf[3];

    if (move & ~63)
        return "--";

    move = 63 - move;
    sprintf(buf, "%c%d", 'A' + (move&7), (move>>3)+1);
    return buf;
}

const char *bb_move_to_ascii(int move, int sign)
{
    static char buf[3];

    if (move & ~63)
        return "--";

    move = 63 - move;
    sprintf(buf, "%c%d", (sign==1 ? 'A' : 'a') + (move&7), (move>>3)+1);
    return buf;
}

int bb_score(bboard b)
{
    int black, white, bonus;

    black = bm_count_bits(b.black);
    white = bm_count_bits(b.white);
    bonus = 64 - (black + white);
    if (black == white)
        bonus = 0;
    if (black < white)
        bonus = -bonus;
    return black - white + bonus;
}

int bb_square_from_ascii(const char *s)
{
    int x, y;

    if (s[0] >= 'A' && s[0] <= 'H')
        x = s[0] - 'A';
    else if (s[0] >= 'a' && s[0] <= 'h')
        x = s[0] - 'a';
    else
        return -1;

    if (s[1] >= '1' && s[1] <= '8')
        y = s[1] - '1';
    else
        return -1;

    return 63 - (y*8 + x);
}
