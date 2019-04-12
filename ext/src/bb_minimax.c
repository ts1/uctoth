#include <stdlib.h>
#include <assert.h>
#include "bitboard.h"
#include "bb_minimax.h"
#include "bb_eval.h"
#include "bb_hash.h"
#include "cache.h"

#define SORT_DEPTH 3
#define SORT_2_DEPTH 8
#define SORT_3_DEPTH 10
#define SORT_4_DEPTH 13
#define CACHE_DEPTH 0

#define MAX_MOVES 32

typedef struct {
    bboard b;
    int move;
    int value;
} move_t;

enum {
    cache_exact,
    cache_lbound,
    cache_ubound,
};

typedef struct {
    int value;
    char depth;
    char move;
    char type;
} entry_t;

static cache_t cache;

static int n_nodes;

static inline int endgame(bboard b)
{
    return bb_disc_diff(b) > 0 ? BB_INF : -BB_INF;
}

static int minimax(bboard b, int depth, int *move_ptr, int n_discs,
        int lbound, int ubound, int pass)
{
    u64 pmoves = bb_potential_moves(b);
    int best_move = -1;
    int max = -BB_INF;
    for (int square = 0; pmoves; square++) {
        if ((pmoves & (1ull << square)) == 0)
            continue;
        pmoves &= ~(1ull << square);
        u64 flips = bb_flip_discs(b, square);
        if (!flips)
            continue;
        bboard newb = bb_swap(bb_apply_flips(b, flips, square));
        int eval;
        if (depth == 1) {
            eval = -bb_eval(newb, n_discs+1);
            n_nodes++;
        } else
            eval = -minimax(newb, depth-1, NULL, n_discs+1, -ubound, -lbound,
                0);
        if (eval > max) {
            max = eval;
            best_move = square;
            if (eval > lbound) {
                lbound = eval;
                if (eval >= ubound)
                    break;
            }
        }
    }
    if (best_move < 0) {
        if (pass)
            return endgame(b);
        else
            return -minimax(bb_swap(b), depth, move_ptr, n_discs,
                    -ubound, -lbound, 1);
    }

    if (move_ptr)
        *move_ptr = best_move;
    return max;
}

static void sort_moves(move_t *moves[], int n_moves)
{
    for (int i = 0; i < n_moves - 1; i++) {
        int best = i;
        for (int j = i + 1; j < n_moves; j++)
            if (moves[j]->value > moves[best]->value)
                best = j;
        if (best != i) {
            move_t *tmp = moves[best];
            moves[best] = moves[i];
            moves[i] = tmp;
        }
    }
}

static int sorted_minimax(bboard b, int depth, int *move_ptr, int n_discs,
        int lbound, int ubound, int pass)
{
    if (depth < SORT_DEPTH)
        return minimax(b, depth, move_ptr, n_discs, lbound, ubound, pass);

    entry_t *entry = 0;
    if (depth >= CACHE_DEPTH) {
        if (!cache)
            cache = cache_create(22, sizeof(entry_t));
        entry = cache_get(cache, b);
        if (entry && entry->depth >= depth) {
            if (entry->type == cache_exact ||
                    (entry->type == cache_lbound && entry->value >= ubound) ||
                    (entry->type == cache_ubound && entry->value <= lbound)) {
                if (move_ptr)
                    *move_ptr = entry->move;
                return entry->value;
            }
        }
    }

    move_t *moves[MAX_MOVES], move_array[MAX_MOVES];
    int n_moves = 0;
    u64 pmoves = bb_potential_moves(b);
    for (int square = 0; pmoves; square++) {
        if ((pmoves & (1ull << square)) == 0)
            continue;
        pmoves &= ~(1ull << square);
        u64 flips = bb_flip_discs(b, square);
        if (!flips)
            continue;

        assert(n_moves < MAX_MOVES);
        moves[n_moves] = &move_array[n_moves];
        moves[n_moves]->move = square;
        moves[n_moves]->b = bb_swap(bb_apply_flips(b, flips, square));
        n_moves++;
    }

    if (!n_moves) {
        if (pass)
            return endgame(b);
        else
            return -sorted_minimax(bb_swap(b), depth, move_ptr, n_discs,
                    -ubound, -lbound, 1);
    }

    for (int i = 0; i < n_moves; i++) {
        if (entry && entry->move == moves[i]->move)
            moves[i]->value = BB_INF;
        else if (lbound > -BB_INF && ubound - lbound == 1)
            moves[i]->value = -bb_potential_mobility(moves[i]->b);
        else if (depth >= SORT_4_DEPTH) 
            moves[i]->value = -minimax(moves[i]->b, 3, 0, n_discs+1,
                    -BB_INF, BB_INF, 0);
        else if (depth >= SORT_3_DEPTH) 
            moves[i]->value = -minimax(moves[i]->b, 2, 0, n_discs+1,
                    -BB_INF, BB_INF, 0);
        else if (depth >= SORT_2_DEPTH) 
            moves[i]->value = -minimax(moves[i]->b, 1, 0, n_discs+1,
                    -BB_INF, BB_INF, 0);
        else
            moves[i]->value = -bb_eval(moves[i]->b, n_discs+1);
    }

    sort_moves(moves, n_moves);

    int orig_lbound = lbound;
    int best_move = -1;
    int max = -BB_INF;
    for (int i = 0; i < n_moves; i++) {
        int eval;
        if (lbound > -BB_INF && ubound - lbound > 1) {
            eval = -sorted_minimax(moves[i]->b, depth-1, NULL, n_discs+1,
                    -(lbound+1), -lbound, 0);
            if (eval > lbound)
                eval = -sorted_minimax(moves[i]->b, depth-1, NULL, n_discs+1,
                        -ubound, -eval, 0);
        } else
            eval = -sorted_minimax(moves[i]->b, depth-1, NULL, n_discs+1,
                    -ubound, -lbound, 0);
        if (eval > max) {
            max = eval;
            best_move = moves[i]->move;
            if (eval > lbound) {
                lbound = eval;
                if (eval >= ubound)
                    break;
            }
        }
    }

    if (depth >= CACHE_DEPTH) {
        entry = cache_put(cache, b);
        entry->value = max;
        entry->depth = depth;
        entry->move = best_move;
        if (max >= ubound)
            entry->type = cache_lbound;
        else if (max <= orig_lbound)
            entry->type = cache_ubound;
        else
            entry->type = cache_exact;
    }

    if (move_ptr)
        *move_ptr = best_move;
    return max;
}

static int
deepening(bboard b, int max_depth, int max_nodes, int *move_ptr, int n_discs)
{
    n_nodes = 0;

    move_t *moves[MAX_MOVES], move_array[MAX_MOVES];
    int n_moves = 0;
    u64 pmoves = bb_potential_moves(b);
    for (int square = 0; pmoves; square++) {
        if ((pmoves & (1ull << square)) == 0)
            continue;
        pmoves &= ~(1ull << square);
        u64 flips = bb_flip_discs(b, square);
        if (!flips)
            continue;

        assert(n_moves < MAX_MOVES);
        moves[n_moves] = &move_array[n_moves];
        moves[n_moves]->move = square;
        moves[n_moves]->b = bb_swap(bb_apply_flips(b, flips, square));
        n_moves++;
    }

    if (n_moves == 0) {
        if (move_ptr)
            *move_ptr = -1;
        return 0;
    }

    move_t *best = NULL;
    for (int depth = 1; depth < max_depth; depth++) {
        int max = -BB_INF;
        bb_debug("depth=%d:", depth+1);
        for (int i = 0; i < n_moves; i++) {
            bb_debug(" %s", bb_square_to_ascii(moves[i]->move));
            int value;
            if (max > -BB_INF) {
                value = -sorted_minimax(moves[i]->b, depth, 0, n_discs + 1,
                    -(max+1), -max, 0);
                if (value > max) {
                    bb_debug(">\b");
                    value = -sorted_minimax(moves[i]->b, depth, 0, n_discs + 1,
                        -BB_INF, -value, 0);
                }
            } else {
                value = -sorted_minimax(moves[i]->b, depth, 0, n_discs + 1,
                    -BB_INF, -max, 0);
            }
            if (value > max) {
                moves[i]->value = value;
                bb_debug("=%d", value);
                max = value;
                best = moves[i];
            } else
                moves[i]->value = -BB_INF;
            if (max_nodes && n_nodes >= max_nodes) {
                bb_debug("\n");
                goto double_break;
            }
        }
        bb_debug("\n");
        if (max_nodes && n_nodes > max_nodes - max_nodes/4)
            break;
        sort_moves(moves, n_moves);
    }
double_break:
    if (move_ptr)
        *move_ptr = best->move;
    return best->value;
}

int bb_minimax(bboard b, int max_depth, int max_nodes, int *move_ptr)
{
    assert(max_depth > 0 || max_nodes > 0);
    int n_discs = bm_count_bits(b.black | b.white);
    if (!max_depth || max_depth > 64 - n_discs)
        max_depth = 64 - n_discs;
    if (max_depth < SORT_DEPTH)
        return minimax(b, max_depth, move_ptr, n_discs, -BB_INF, BB_INF, 0);
    else
        return deepening(b, max_depth, max_nodes, move_ptr, n_discs);
}
