#include "bitmap.h"

static inline u64 corner_stable_discs_N(u64 b)
{
    u64 s;

    s = b & 0x8100000000000000ull;
    s |= b & (s >> 8);
    s |= b & (s >> 8);
    return s;
}

static inline u64 corner_stable_discs_W(u64 b)
{
    u64 s;

    s = b & 0x8000000000000080ull;
    s |= b & (s >> 1);
    s |= b & (s >> 1);
    return s;
}

static inline u64 corner_stable_discs_E(u64 b)
{
    u64 s;

    s = b & 0x0100000000000001ull;
    s |= b & (s << 1);
    s |= b & (s << 1);
    return s;
}

static inline u64 corner_stable_discs_S(u64 b)
{
    u64 s;

    s = b & 0x0000000000000081ull;
    s |= b & (s << 8);
    s |= b & (s << 8);
    return s;
}

static inline u64 corner_stable_discs_NW(u64 b, u64 s)
{
    b &= 0xfefefefefefefefeull;
    s |= b & (s >> 9);
    return s;
}

static inline u64 corner_stable_discs_NE(u64 b, u64 s)
{
    b &= 0x7f7f7f7f7f7f7f7full;
    s |= b & (s >> 7);
    return s;
}

static inline u64 corner_stable_discs_SW(u64 b, u64 s)
{
    b &= 0xfefefefefefefefeull;
    s |= b & (s << 7);
    return s;
}

static inline u64 corner_stable_discs_SE(u64 b, u64 s)
{
    b &= 0x7f7f7f7f7f7f7f7full;
    s |= b & (s << 9);
    return s;
}

u64 bm_corner_stable_discs(u64 b)
{
    u64 n = corner_stable_discs_N(b);
    u64 w = corner_stable_discs_W(b);
    u64 e = corner_stable_discs_E(b);
    u64 s = corner_stable_discs_S(b);
    return corner_stable_discs_NW(b, s|e)
         | corner_stable_discs_NE(b, s|w)
         | corner_stable_discs_SW(b, n|e)
         | corner_stable_discs_SE(b, n|w);
}

int bm_corner_stability(u64 b)
{
    return bm_count_bits(bm_corner_stable_discs(b));
}

static inline u64 edge_stable_discs_N(u64 b)
{
    u64 s;

    s = b & 0x8100000000000000ull;
    s |= b & (s >> 8);
    s |= b & (s >> 8);
    s |= b & (s >> 8);
    s |= b & (s >> 8);
    s |= b & (s >> 8);
    s |= b & (s >> 8);
    s |= b & (s >> 8);
    return s;
}

static inline u64 edge_stable_discs_W(u64 b)
{
    u64 s;

    s = b & 0x8000000000000080ull;
    s |= b & (s >> 1);
    s |= b & (s >> 1);
    s |= b & (s >> 1);
    s |= b & (s >> 1);
    s |= b & (s >> 1);
    s |= b & (s >> 1);
    s |= b & (s >> 1);
    return s;
}

static inline u64 edge_stable_discs_E(u64 b)
{
    u64 s;

    s = b & 0x0100000000000001ull;
    s |= b & (s << 1);
    s |= b & (s << 1);
    s |= b & (s << 1);
    s |= b & (s << 1);
    s |= b & (s << 1);
    s |= b & (s << 1);
    s |= b & (s << 1);
    return s;
}

static inline u64 edge_stable_discs_S(u64 b)
{
    u64 s;

    s = b & 0x0000000000000081ull;
    s |= b & (s << 8);
    s |= b & (s << 8);
    s |= b & (s << 8);
    s |= b & (s << 8);
    s |= b & (s << 8);
    s |= b & (s << 8);
    s |= b & (s << 8);
    return s;
}

u64 bm_edge_stable_discs(u64 b)
{
    return edge_stable_discs_N(b)
         | edge_stable_discs_W(b)
         | edge_stable_discs_E(b)
         | edge_stable_discs_S(b);
}

int bm_edge_stability(u64 b)
{
    return bm_count_bits(bm_edge_stable_discs(b));
}
