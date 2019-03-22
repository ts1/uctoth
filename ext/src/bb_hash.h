#ifndef bb_hash_h
#define bb_hash_h

#ifndef bitboard_h
#include "bitboard.h"
#endif

typedef struct bb_hashnode {
    bboard b;
    s32 value;
    u8 depth;
    u8 flags;
    s8 move[2];
} bb_hashnode;

#define BB_HASH_EXACT       (1<<0)
#define BB_HASH_LOWER       (1<<1)
#define BB_HASH_UPPER       (1<<2)
#define BB_HASH_SELECTIVE   (1<<3)
#define BB_HASH_PV          (1<<4)

#define BB_INF 0x7fffffff

#ifdef __cplusplus
extern "C" {
#endif

void bb_hash_init(int order);
void bb_hash_free(void);
void bb_hash_reset(void);
bb_hashnode *bb_hash_get(bboard);
void bb_hash_set(bboard, int value, int flags, int depth, int move);

#ifdef __cplusplus
}
#endif

#endif
