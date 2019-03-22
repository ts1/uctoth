#ifndef bitboard_h
#define bitboard_h

#ifndef oth_h
#include "oth.h"
#endif

#ifndef bitmap_h
#include "bitmap.h"
#endif

#ifdef __cplusplus
extern "C" {
#endif

typedef struct bboard {
    u64 black, white;
} bboard;

u64 bb_flip_discs(bboard b, unsigned int move);
bboard bb_move(bboard b, unsigned int move);
u64 bb_all_moves(bboard b);
u64 bb_potential_moves(bboard b);
int bb_mobility(bboard b);
int bb_potential_mobility(bboard b);
int bb_disc_diff(bboard b);
int bb_score(bboard b);

bboard bb_from_ascii(const char *s, int turn);
void bb_print(bboard b);
const char *bb_square_to_ascii(int square);
const char *bb_move_to_ascii(int move, int sign);
int bb_square_from_ascii(const char *s);

int bb_endgame(bboard b, int *score_p, int wld, u64 mask);

extern u64 bb_nodes, bb_leaves, bb_hash_nodes;

static inline bboard bb_swap(bboard b)
{
    u64 tmp = b.black;
    b.black = b.white;
    b.white = tmp;
    return b;
}

static inline bboard bb_apply_flips(bboard b, u64 flips, unsigned int move)
{
    bboard newb;

    newb.black = (b.black ^ flips) | (1ull << move);
    newb.white = (b.white ^ flips);
    return newb;
}

static inline u64 bb_try_move(bboard b, unsigned int move, bboard *newb)
{
    u64 flips;

    flips = bb_flip_discs(b, move);
    if (flips) {
        newb->black = (b.black ^ flips) | (1ull << move);
        newb->white = (b.white ^ flips);
    }
    return flips;

}

static inline int bb_equal(bboard a, bboard b)
{
    return ((a.black ^ b.black) | (a.white ^ b.white)) == 0;
}

static inline bboard bb_transpose(bboard b)
{
    b.black = bm_transpose(b.black);
    b.white = bm_transpose(b.white);
    return b;
}

static inline bboard bb_mirror(bboard b)
{
    b.black = bm_mirror(b.black);
    b.white = bm_mirror(b.white);
    return b;
}

static inline bboard bb_flip(bboard b)
{
    b.black = bm_flip(b.black);
    b.white = bm_flip(b.white);
    return b;
}

static inline bboard bb_diag(bboard b)
{
    b.black = bm_diag(b.black);
    b.white = bm_diag(b.white);
    return b;
}

#define BB_ALL_SYMMETRIC(b, f, m, mf, t, tf, tm, tmf) \
    ( \
      m = bb_mirror(b), \
      f = bb_flip(b), \
      mf = bb_flip(m), \
      t = bb_transpose(b), \
      tm = bb_transpose(m), \
      tf = bb_transpose(f), \
      tmf = bb_transpose(mf) \
    )

enum {
    bH8, bG8, bF8, bE8, bD8, bC8, bB8, bA8,
    bH7, bG7, bF7, bE7, bD7, bC7, bB7, bA7,
    bH6, bG6, bF6, bE6, bD6, bC6, bB6, bA6,
    bH5, bG5, bF5, bE5, bD5, bC5, bB5, bA5,
    bH4, bG4, bF4, bE4, bD4, bC4, bB4, bA4,
    bH3, bG3, bF3, bE3, bD3, bC3, bB3, bA3,
    bH2, bG2, bF2, bE2, bD2, bC2, bB2, bA2,
    bH1, bG1, bF1, bE1, bD1, bC1, bB1, bA1,
};

static inline bboard bb_init_board(void)
{
    bboard b;

    b.black = (1ull << bD5) | (1ull << bE4);
    b.white = (1ull << bE5) | (1ull << bD4);
    return b;
}

#ifdef __cplusplus
} /* extern "C" */
#endif

#endif /* bitboard_h */
