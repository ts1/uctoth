#ifndef bb_minimax_h
#define bb_minimax_h

#ifdef __cplusplus
extern "C" {
#endif

int bb_minimax(bboard b, int max_depth, int max_nodes, int *best_move,
        int lbound, int ubound);

#ifdef __cplusplus
} /* extern "C" */
#endif

#endif /* bb_minimax_h */
