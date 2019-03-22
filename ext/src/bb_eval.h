#ifndef bb_eval_h
#define bb_eval_h

#ifndef oth_h
#include "oth.h"
#endif
#ifndef bitboard_h
#include "bitboard.h"
#endif

#define N_PHASES 10
#define N_MOVES_PER_PHASE 6

#ifdef __cplusplus
extern "C" {
#endif

void bb_set_weights(int phase, const s16 *weights);
int bb_eval(bboard b, int n_discs);

#ifdef __cplusplus
} /* extern "C" */
#endif

#define BB_SELECTIVE (1<<0)
#define BB_DEEPENING (1<<1)
#define BB_AVERAGE   (1<<2)

#endif /* bb_eval_h */
