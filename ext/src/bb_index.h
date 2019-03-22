#ifndef bb_index_h
#define bb_index_h

#ifndef bitmap_h
#include "bitmap.h"
#endif

#ifndef bitboard_h
#include "bitboard.h"
#endif

#ifdef __cplusplus
extern "C" {
#endif

extern int bb_index_tbl[];

void bb_index_init(void);

#define BB_INDEX_FN_32(name, expr) \
inline static int bm_pattern_##name(u32 b) { return expr; } \
inline static int bb_index_##name(bboard b) \
{ \
    return bb_index_tbl[bm_pattern_##name(b.black)] \
       + 2*bb_index_tbl[bm_pattern_##name(b.white)]; \
}

#define BB_INDEX_FN_DIAG_32(name, expr) \
inline static int bm_pattern_diag##name(u32 b) { return expr; } \
inline static int bb_index_diag##name(bboard b) \
{ \
    return bb_index_tbl[bm_pattern_diag##name(bm_diag(b.black))] \
       + 2*bb_index_tbl[bm_pattern_diag##name(bm_diag(b.white))]; \
} \
inline static int bb_index_diag##name##_d(bboard b) \
{ \
    return bb_index_tbl[bm_pattern_diag##name(b.black)] \
       + 2*bb_index_tbl[bm_pattern_diag##name(b.white)]; \
}

#define BB_INDEX_FN_DIAG(name, expr) \
inline static int bm_pattern_diag##name(u64 b) { return expr; } \
inline static int bb_index_diag##name(bboard b) \
{ \
    return bb_index_tbl[bm_pattern_diag##name(bm_diag(b.black))] \
       + 2*bb_index_tbl[bm_pattern_diag##name(bm_diag(b.white))]; \
} \
inline static int bb_index_diag##name##_d(bboard b) \
{ \
    return bb_index_tbl[bm_pattern_diag##name(b.black)] \
       + 2*bb_index_tbl[bm_pattern_diag##name(b.white)]; \
}

BB_INDEX_FN_32(corner9, (b & 7) | ((b>>(8-3)) & 0x38) | ((b>>(16-6)) & 0x1c0))
BB_INDEX_FN_32(corner10, (b & 0x1f) | ((b>>(8-5)) & 0x3e0))
BB_INDEX_FN_32(edge2x, ((b>>9) & 1) | ((b<<1) & 0x1fe) | ((b>>(14-9)) & 0x200))
BB_INDEX_FN_32(row1, (b>>8) & 0xff)
BB_INDEX_FN_32(row2, (b>>16) & 0xff)
BB_INDEX_FN_32(row3, b>>24)
BB_INDEX_FN_DIAG_32(8, b & 0xff)
BB_INDEX_FN_DIAG_32(7, (b>>8) & 0x7f)
BB_INDEX_FN_DIAG_32(6, (b>>16) & 0x3f)
BB_INDEX_FN_DIAG_32(5, b>>24)
BB_INDEX_FN_DIAG(4, (b>>32) & 0x0f)

#ifdef __cplusplus
} /* extern "C" */
#endif

#endif /* bb_index_h */
