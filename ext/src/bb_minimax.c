#include <stdlib.h>
#include <assert.h>
#include "bitboard.h"
#include "bb_minimax.h"
#include "bb_eval.h"
#include "bb_hash.h"

static int minimax(bboard b, int depth, int *move_ptr, int n_discs,
        int lbound, int ubound, int pass)
{
    u64 pmoves = bb_potential_moves(b);
    int best_move = -1;
    for (int square = 0; pmoves; square++) {
        if ((pmoves & (1ull << square)) == 0)
            continue;
        pmoves &= ~(1ull << square);
        u64 flips = bb_flip_discs(b, square);
        if (!flips)
            continue;
        bboard newb = bb_swap(bb_apply_flips(b, flips, square));
        int eval;
        if (depth == 1)
            eval = -bb_eval(newb, n_discs+1);
        else
            eval = -minimax(newb, depth-1, NULL, n_discs+1, -ubound, -lbound,
                0);
        if (eval > lbound) {
            lbound = eval;
            best_move = square;
            if (eval >= ubound)
                break;
        }
    }
    if (best_move < 0) {
        if (pass)
            return bb_disc_diff(b);
        else
            return -minimax(bb_swap(b), depth, move_ptr, n_discs,
                    -ubound, -lbound, 1);
    }

    if (move_ptr)
        *move_ptr = best_move;
    return lbound;
}

int bb_minimax(bboard b, int depth, int *move_ptr)
{
    assert(depth >= 1);
    int n_discs = bm_count_bits(b.black | b.white);
    return minimax(b, depth, move_ptr, n_discs, -BB_INF, BB_INF, 0);
}
