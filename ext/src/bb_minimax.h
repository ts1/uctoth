#ifndef bb_minimax_h
#define bb_minimax_h

#ifdef __cplusplus
extern "C" {
#endif

#ifndef CACHE_H
#include "cache.h"
#endif

int bb_minimax(bboard b, int max_depth, int max_nodes, int *best_move, u64 mask);
cache_t bb_minimax_create_cache(void);
void bb_minimax_set_cache(cache_t _cache);
void bb_minimax_delete_cache(cache_t _cache);

#ifdef __cplusplus
} /* extern "C" */
#endif

#endif /* bb_minimax_h */
