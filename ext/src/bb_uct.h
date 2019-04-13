#ifndef bb_uct_h
#define bb_uct_h

#include <stdbool.h>

#ifndef bitboard_h
#include "bitboard.h"
#endif

#ifdef __cplusplus
extern "C" {
#endif

#define DEFAULT_SCOPE (0.56 * SCORE_MULT)
#define DEFAULT_LOGISTIC_SCOPE (0.17 * LOG_MULT)

void bb_uct_set_options(
        int n_search,
        double scope,
        double randomness,
        bool tenacious,
        bool by_value);

int bb_uct_search(bboard b, int *move_ptr, u64 mask);

#ifdef __cplusplus
} /* extern "C" */
#endif

#endif /* bb_uct_h */
