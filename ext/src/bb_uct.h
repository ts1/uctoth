#ifndef bb_uct_h
#define bb_uct_h

#ifndef bitboard_h
#include "bitboard.h"
#endif

#ifdef __cplusplus
extern "C" {
#endif

#define DEFAULT_SCOPE ((int) (1.0 * SCORE_MULT))
#define DEFAULT_LOGISTIC_SCOPE ((int) (0.17 * LOG_MULT))

int bb_uct_search(bboard b, int n_search, int *move_ptr, int scope, double randomness, int tenacious);

#ifdef __cplusplus
} /* extern "C" */
#endif

#endif /* bb_uct_h */
