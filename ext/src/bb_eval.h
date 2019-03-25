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

void *bb_get_weights_ptr(int phase);
void bb_set_weights(int phase, const s16 *weights);
int bb_eval(bboard b, int n_discs);
int bb_eval_dump(bboard b, int n_discs);
void bb_nega_weight(void);

#ifdef __cplusplus
} /* extern "C" */
#endif

#endif /* bb_eval_h */
