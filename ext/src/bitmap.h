#ifndef bitmap_h
#define bitmap_h

#ifndef oth_h
#include "oth.h"
#endif

#ifdef __cplusplus
extern "C" {
#endif

static inline int bm_count_bits(u64 b)
{
#if 1
    b = b - ((b>>1) & 0x5555555555555555ull);
    b = (b & 0x3333333333333333ull) + ((b>>2) & 0x3333333333333333ull);
    b = (b + (b>>4)) & 0x0f0f0f0f0f0f0f0full;
    return (b * 0x0101010101010101ull) >> 56;
#else
    u64 n;

    n = (b >> 1) & 0x7777777777777777ull;
    b -= n;
    n = (n >> 1) & 0x7777777777777777ull;
    b -= n;
    n = (n >> 1) & 0x7777777777777777ull;
    b -= n;
    b = (b + (b>>4)) & 0x0f0f0f0f0f0f0f0full;
    return (b * 0x0101010101010101ull) >> 56;
#endif
}

static inline u64 bm_transpose(u64 b)
{
    u64 t;

    /*
     * A A A A B B B B     A A A A C C C C
     * A A A A B B B B     A A A A C C C C
     * A A A A B B B B     A A A A C C C C
     * A A A A B B B B     A A A A C C C C
     * C C C C D D D D --> B B B B D D D D 
     * C C C C D D D D     B B B B D D D D
     * C C C C D D D D     B B B B D D D D
     * C C C C D D D D     B B B B D D D D
     */
    t = (b ^ (b >> 28)) & 0x00000000f0f0f0f0ull;
    b ^= t | (t << 28);

    /*
     * A A B B A A B B     A A C C A A C C
     * A A B B A A B B     A A C C A A C C
     * C C D D C C D D     B B D D B B D D
     * C C D D C C D D     B B D D B B D D
     * A A B B A A B B --> A A C C A A C C
     * A A B B A A B B     A A C C A A C C
     * C C D D C C D D     B B D D B B D D
     * C C D D C C D D     B B D D B B D D
     */
    t = (b ^ (b >> 14)) & 0x0000cccc0000ccccull;
    b ^= t | (t << 14);

    /*
     * A B A B A B A B     A C A C A C A C
     * C D C D C D C D     B D B D B D B D
     * A B A B A B A B     A C A C A C A C
     * C D C D C D C D     B D B D B D B D
     * A B A B A B A B --> A C A C A C A C
     * C D C D C D C D     B D B D B D B D
     * A B A B A B A B     A C A C A C A C
     * C D C D C D C D     B D B D B D B D
     */
    t = (b ^ (b >> 7)) & 0x00aa00aa00aa00aaull;
    b ^= t | (t << 7);

    return b;
}

static inline u64 bm_mirror(u64 b)
{
    /* ABABABAB --> BABABABA */
    b = ((b & 0x5555555555555555ull) << 1) | ((b >> 1) & 0x5555555555555555ull);

    /* AABBAABB --> BBAABBAA */
    b = ((b & 0x3333333333333333ull) << 2) | ((b >> 2) & 0x3333333333333333ull);

    /* AAAABBBB --> BBBBAAAA */
    b = ((b & 0x0f0f0f0f0f0f0f0full) << 4) | ((b >> 4) & 0x0f0f0f0f0f0f0f0full);

    return b;
}

#if defined(__GNUC__) && defined(__x86_64__)
static inline u64 bm_flip(u64 b)
{
    asm ("bswapq %0" : "=r" (b) : "0" (b));
    return b;
}
#elif defined(__GNUC__) && defined(__i486__)
static inline u64 bm_flip(u64 b)
{
    u32 hi, lo;
    asm ("bswapl %0" : "=r" (lo) : "0" (b));
    asm ("bswapl %0" : "=r" (hi) : "0" (b>>32));
    return ((u64) lo << 32) | hi;
}
#else
static inline u64 bm_flip(u64 b)
{
    /* ABABABAB --> BABABABA */
    b = ((b & 0x00ff00ff00ff00ffull) << 8) | ((b>>8) & 0x00ff00ff00ff00ffull);

    /* AABBAABB --> BBAABBAA */
    b = ((b & 0x0000ffff0000ffffull) << 16) | ((b>>16) & 0x0000ffff0000ffffull);

    /* AAAABBBB --> BBBBAAAA */
    b = (b << 32) | (b >> 32);

    return b;
}
#endif

static inline u64 bm_reverse(u64 b)
{
    return bm_flip(bm_mirror(b));
}

u64 bm_corner_stable_discs(u64 b);
int bm_corner_stability(u64 b);
u64 bm_edge_stable_discs(u64 b);
int bm_edge_stability(u64 b);

static inline u64 bm_diag(u64 x)
{
    /*
     * a b c d e f g h
     * - a b c d e f g
     * - - a b c d e f
     * - - - a b c d e
     * - - - - a b c d
     * - - - - - a b c
     * - - - - - - a b
     * - - - - - - - a
     */
    x = (x & 0x0f0f0f0f0f0f0f0fULL) | ((x>>32) & 0xf0f0f0f0);
    /*
     * - - - - e f g h
     * - - - - d e f g
     * - - - - c d e f
     * - - - - b c d e
     * a b c d a b c d
     * - a b c - a b c
     * - - a b - - a b
     * - - - a - - - a
     */
    x = (x & 0x3333333333333333ULL) | ((x>>16) & 0x0000ccccccccccccULL);
    /*
     * - - - - - - g h
     * - - - - - - f g
     * - - - - e f e f
     * - - - - d e d e
     * - - c d c d c d
     * - - b c b c b c
     * a b a b a b a b
     * - a - a - a - a
     */
    x = (x & 0x5555555555555555ULL) | ((x>>8) & 0x00aaaaaaaaaaaaaaULL);
    /*
     * - - - - - - - h
     * - - - - - - g g
     * - - - - - f f f
     * - - - - e e e e
     * - - - d d d d d
     * - - c c c c c c
     * - b b b b b b b
     * a a a a a a a a
     */
    return x;
}

#ifdef __cplusplus
} /* extern "C" */
#endif

#endif /* bitmap_h */
