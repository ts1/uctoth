#include <stdio.h>
#include <stdlib.h>
#include <assert.h>
#include <math.h>
#include "oth.h"
#include "bitboard.h"
#include "bitmap.h"
#include "bb_eval.h"
#include "bb_hash.h"
#include "bb_minimax.h"
#include "bb_uct.h"

#define USE_HASH 1
#define FASTEST_FIRST_DEPTH 8
#define PRE_SEARCH_DEPTH 13
#define PRE_SEARCH_2_DEPTH 20
#define PRE_SEARCH_3_DEPTH 25
#define USE_PARITY 1
#define USE_ETC (1 && USE_HASH)

#define MOBILITY_WEIGHT 64*SCORE_MULT
#define ALPHA_CUT_THRESHOLD 7000
#define ALPHA_CUT_BOOST 1500

#if !USE_HASH
#define bb_hash_get(b) NULL
#define bb_hash_set(b, value, flags, depth, move) ((void) 0)
#endif

static int quad_parity[4];

#define q0 &quad_parity[0]
#define q1 &quad_parity[1]
#define q2 &quad_parity[2]
#define q3 &quad_parity[3]
static int *parity_tbl[64] = {
    q0,q0,q0,q0,q1,q1,q1,q1,
    q0,q0,q0,q0,q1,q1,q1,q1,
    q0,q0,q0,q0,q1,q1,q1,q1,
    q0,q0,q0,q0,q1,q1,q1,q1,
    q2,q2,q2,q2,q3,q3,q3,q3,
    q2,q2,q2,q2,q3,q3,q3,q3,
    q2,q2,q2,q2,q3,q3,q3,q3,
    q2,q2,q2,q2,q3,q3,q3,q3,
};
#undef q0
#undef q1
#undef q2
#undef q3

typedef struct empty_node empty_node;
struct empty_node {
    empty_node *next, *prev;
    int square;
};

static const int empty_order[64] = {
    bA1, bA8, bH1, bH8, /* corner */
    bC1, bF1, bC8, bF8, bA3, bA6, bH3, bH6, /* A */
    bD1, bE1, bD8, bE8, bA4, bA5, bH4, bH5, /* B */
    bC3, bC6, bF3, bF6, /* D */
    bD3, bE3, bC4, bD4, bE4, bF4, /* box */
    bC5, bD5, bE5, bF5, bD6, bE6,
    bC2, bD2, bE2, bF2, bC7, bD7, bE7, bF7, /* middle edge */
    bB3, bB4, bB5, bB6, bG3, bG4, bG5, bG6,
    bB1, bG1, bA2, bH2, bA7, bB8, bG8, bH7, /* C */
    bB2, bG2, bB7, bG7, /* X */
};

static empty_node empty_node_tbl[64];
static empty_node empty_list;

u64 bb_nodes, bb_leaves, bb_hash_nodes;

static inline int max(int a, int b)
{
    return a > b ? a : b;
}

static void make_empty_list(bboard b)
{
    int i;
    u64 empty;
    empty_node *node = &empty_list;

    empty = ~(b.black|b.white);

    for (i = 0; i < 64; i++) {
        int square = empty_order[i];
        empty_node *next;

        if (!(empty & (1ull<<square)))
            continue;
        next = &empty_node_tbl[square];
        node->next = next;
        next->prev = node;
        next->square = square;
        node = next;
    }
    node->next = &empty_list;
    empty_list.prev = node;
}

inline
static void del_empty(empty_node *e)
{
    empty_node *next = e->next, *prev = e->prev;
    next->prev = prev;
    prev->next = next;
}

inline
static void restore_empty(empty_node *e)
{
    empty_node *next = e->next, *prev = e->prev;
    next->prev = e;
    prev->next = e;
}

static void make_parity_table(bboard b)
{
    int i;
    u64 empty;

    empty = ~(b.black|b.white);

    for (i = 0; i < 4; i++)
        quad_parity[i] = 0;
    for (i = 0; i < 64; i++) {
        if (empty & (1ull<<i))
            *parity_tbl[i] ^= 1;
    }
}

#if USE_PARITY
#define update_parity(m) (*parity_tbl[m] ^= 1)
#else
#define update_parity(m) ((void) 0)
#endif

static inline int calc_score(bboard b, int n_empty)
{
    int black = bm_count_bits(b.black);
    int white = 64 - n_empty - black;
    int score = black - white;
    if (score > 0)
        return score + n_empty;
    if (score < 0)
        return score - n_empty;
    return 0;
}

static inline int solve_0_empty(bboard b)
{
    return 2*bm_count_bits(b.black) - 64;
}

static inline int solve_1_empty(bboard b, int move)
{
    bb_leaves++;
    bb_nodes++;
    if (bb_try_move(b, move, &b))
        return solve_0_empty(b);
    b = bb_swap(b);
    if (bb_try_move(b, move, &b))
        return -solve_0_empty(b);
    return -calc_score(b, 1);
}

inline
static int solve_2_empties(bboard b, int alpha, int beta, int m1, int m2)
{
    bboard newb;
    int score;

    bb_nodes++;

    if (bb_try_move(b, m1, &newb)) {
        score = -solve_1_empty(bb_swap(newb), m2);
        if (score < beta && bb_try_move(b, m2, &newb))
            return max(score, -solve_1_empty(bb_swap(newb), m1));
        return score;
    } else if (bb_try_move(b, m2, &newb))
        return -solve_1_empty(bb_swap(newb), m1);

    b = bb_swap(b);
    beta = -alpha;

    bb_nodes++;

    if (bb_try_move(b, m1, &newb)) {
        score = -solve_1_empty(bb_swap(newb), m2);
        if (score < beta && bb_try_move(b, m2, &newb))
            return -max(score, -solve_1_empty(bb_swap(newb), m1));
        return -score;
    } else if (bb_try_move(b, m2, &newb))
        return solve_1_empty(bb_swap(newb), m1);
    bb_leaves++;
    return -calc_score(b, 2);
}

static int solve_3_empties(bboard b, int alpha, int beta, int m1, int m2, int m3, int pass)
{
    bboard newb;
    int score = -100;

    /*assert(bm_count_bits(~(b.black|b.white)) == 3);*/

    bb_nodes++;

    if (bb_try_move(b, m1, &newb)) {
        score = -solve_2_empties(bb_swap(newb), -beta, -alpha, m2, m3);
        alpha = max(alpha, score);
    }
    if (score < beta && bb_try_move(b, m2, &newb)) {
        score = max(score, -solve_2_empties(bb_swap(newb), -beta, -alpha, m1, m3));
        alpha = max(alpha, score);
    }
    if (score < beta && bb_try_move(b, m3, &newb))
        score = max(score, -solve_2_empties(bb_swap(newb), -beta, -alpha, m1, m2));
    if (score > -100) 
        return score;
    if (pass) {
        bb_leaves++;
        return calc_score(b, 3);
    }
    return -solve_3_empties(bb_swap(b), -beta, -alpha, m1, m2, m3, 1);
}

static int solve_4_empties(bboard b, int alpha, int beta, int pass)
{
    int m1, m2, m3, m4;
    bboard newb;
    int score = -100;

    /*assert(bm_count_bits(~(b.black|b.white)) == 4);*/

    bb_nodes++;

    m1 = empty_list.next->square;
    m2 = empty_list.next->next->square;
    m3 = empty_list.next->next->next->square;
    m4 = empty_list.next->next->next->next->square;

    if (bb_try_move(b, m1, &newb)) {
        score = -solve_3_empties(bb_swap(newb), -beta, -alpha, m2, m3, m4, 0);
        alpha = max(alpha, score);
    }
    if (score < beta && bb_try_move(b, m2, &newb)) {
        score = max(score, -solve_3_empties(bb_swap(newb), -beta, -alpha,
                    m1, m3, m4, 0));
        alpha = max(alpha, score);
    }
    if (score < beta && bb_try_move(b, m3, &newb)) {
        score = max(score, -solve_3_empties(bb_swap(newb), -beta, -alpha,
                    m1, m2, m4, 0));
        alpha = max(alpha, score);
    }
    if (score < beta && bb_try_move(b, m4, &newb))
        score = max(score, -solve_3_empties(bb_swap(newb), -beta, -alpha,
                    m1, m2, m3, 0));
    if (score > -100) 
        return score;
    if (pass) {
        bb_leaves++;
        return calc_score(b, 4);
    }
    return -solve_4_empties(bb_swap(b), -beta, -alpha, 1);
}

static int solve_parity(bboard b, int alpha, int beta, int n_empty, int pass)
{
    int done;
    u64 pmoves;
    empty_node *empty;
    int lower = -100;
    int parity;

    bb_nodes++;

    pmoves = bb_potential_moves(b);

    done = 0;
    for (parity = 1; parity >= 0; parity--) {
      u64 pm = pmoves;
      for (empty = empty_list.next; pm; empty = empty->next) {
        u64 flips;
        int score;
        bboard newb;
        int m;

        m = empty->square;

        if (!(pm & (1ull<<m)))
            continue;
        pm &= ~(1ull<<m);

        if (*parity_tbl[m] != parity)
            continue;

        flips = bb_flip_discs(b, m);
        if (!flips)
            continue;

        newb.black = (b.black ^ flips) | (1ull<<m);
        newb.white = b.white ^ flips;

        del_empty(empty);
        if (n_empty == 5)
            score = -solve_4_empties(bb_swap(newb), -beta, -alpha, 0);
        else {
            update_parity(m);
            score = -solve_parity(bb_swap(newb), -beta, -alpha, n_empty-1, 0);
            update_parity(m);
        }
        restore_empty(empty);
        if (score > lower) {
            if (score > alpha) {
                if (score >= beta)
                    return score;
                alpha = score;
            }
            lower = score;
        }
        done = 1;
      }
    }
    if (done)
        return lower;

    if (pass) {
        bb_leaves++;
        return calc_score(b, n_empty);
    } else
        return -solve_parity(bb_swap(b), -beta, -alpha, n_empty, 1);
}

struct move {
    int score, move;
    u64 flips;
};

static int
sort_moves_fastest_first(bboard b, struct move *moves, bb_hashnode *hash, int
        bestmove, int alpha, int beta, u64 mask)
{
    u64 pmoves;
    empty_node *empty;
    int n, i, j;
    int hash_best, hash_second;
    int n_empty = 64 - bm_count_bits(b.black|b.white) - 1;

    if (hash) {
        hash_best = hash->move[0];
        hash_second = hash->move[1];
    } else if (bestmove >= 0) {
        hash_best = bestmove;
        hash_second = -1;
    } else {
        hash_best = hash_second = -1;
    }

    pmoves = bb_potential_moves(b);
    pmoves &= ~mask;
    n = 0;
    for (empty = empty_list.next; pmoves; empty = empty->next) {
        int m;
        u64 flips;
        int score;

        m = empty->square;
        if (!(pmoves & (1ull<<m)))
            continue;
        pmoves &= ~(1ull<<m);
        flips = bb_flip_discs(b, m);
        if (!flips)
            continue;
        if (m == hash_best)
            score = 1<<30;
        else if (m == hash_second)
            score = 1<<29;
        else {
            bboard newb;
            int eval;
            newb.black = (b.black ^ flips) | (1ull<<m);
            newb.white = b.white ^ flips;
            score = -bb_mobility(bb_swap(newb));
            if (n_empty >= PRE_SEARCH_DEPTH) {
                if (n_empty >= PRE_SEARCH_3_DEPTH)
                    eval = -bb_minimax(bb_swap(newb), 2, 0, NULL);
                else if (n_empty >= PRE_SEARCH_2_DEPTH)
                    eval = -bb_minimax(bb_swap(newb), 1, 0, NULL);
                else
                    eval = -bb_eval(bb_swap(newb), n_empty);
                if (eval < (alpha<<10) - ALPHA_CUT_THRESHOLD)
                    score = score * (MOBILITY_WEIGHT + ALPHA_CUT_BOOST) + eval;
                else
                    score = score * MOBILITY_WEIGHT + eval;
            }
        }
        moves[n].move = m;
        moves[n].score = score;
        moves[n].flips = flips;
        n++;
    }
    for (i = 0; i < n; i++) {
        struct move *best = &moves[i];
        for (j = i+1; j < n; j++)
            if (best->score < moves[j].score)
                best = &moves[j];
        if (best != &moves[i]) {
            struct move tmp = moves[i];
            moves[i] = *best;
            *best = tmp;
        }
    }
    return n;
}

static int
solve_fastest_first(bboard b, int alpha, int beta, int n_empty, int pass)
{
    int n_moves;
    int i;
    struct move moves[32];
    int lower = -100;
    bb_hashnode *hash = NULL;
    int a = alpha;
    int best_move = -1;
    int hash_depth = n_empty + 1;

    bb_nodes++;

#if USE_HASH
    bb_hash_nodes++;
    hash = bb_hash_get(b);
    if (hash && hash->depth==hash_depth) {
        if (hash->flags & BB_HASH_EXACT)
            return hash->value;
        if (hash->flags & BB_HASH_LOWER) {
            if (hash->value >= beta)
                return hash->value;
            if (hash->value > alpha)
                alpha = hash->value;
        }
        if (hash->flags & BB_HASH_UPPER) {
            if (hash->value <= alpha)
                return hash->value;
            if (hash->value < beta)
                beta = hash->value;
        }
    }
#endif

    n_moves = sort_moves_fastest_first(b, moves, hash, -1, alpha, beta, 0);

#if USE_ETC
    for (i = 0; i < n_moves; i++) {
        u64 flips;
        bboard newb;
        int m;

        m = moves[i].move;
        flips = moves[i].flips;
        newb.white = (b.black ^ flips) | (1ull<<m);
        newb.black = b.white ^ flips;
        hash = bb_hash_get(newb);
        if (hash && hash->depth==hash_depth-1) {
            if ((hash->flags & (BB_HASH_UPPER|BB_HASH_EXACT))
                    && -hash->value >= beta) {
                bb_hash_set(b, -hash->value, BB_HASH_LOWER, hash_depth, -1);
                return -hash->value;
            }
        }
    }
#endif

    for (i = 0; i < n_moves; i++) {
        u64 flips;
        int score;
        bboard newb;
        int m;

        m = moves[i].move;
        flips = moves[i].flips;
        newb.black = (b.black ^ flips) | (1ull<<m);
        newb.white = b.white ^ flips;

        update_parity(m);
        del_empty(&empty_node_tbl[m]);
        if (n_empty <= FASTEST_FIRST_DEPTH)
            score = -solve_parity(bb_swap(newb), -beta, -alpha, n_empty-1, 0);
        else {
            if (i==0) {
                score = -solve_fastest_first(bb_swap(newb), -beta, -alpha,
                        n_empty-1, 0);
            } else {
                score = -solve_fastest_first(bb_swap(newb), -(alpha+1), -alpha,
                        n_empty-1, 0);
                if (score > alpha && score < beta)
                    score = -solve_fastest_first(bb_swap(newb), -beta, -score,
                            n_empty-1, 0);
            }
        }
        restore_empty(&empty_node_tbl[m]);
        update_parity(m);
        if (score > lower) {
            best_move = m;
            if (score >= beta) {
                bb_hash_set(b, score, BB_HASH_LOWER, hash_depth, best_move);
                return score;
            } 
            if (score > alpha)
                alpha = score;
            lower = score;
        }
    }
    if (n_moves) {
        if (lower > a)
            bb_hash_set(b, lower, BB_HASH_EXACT, hash_depth, best_move);
        else
            bb_hash_set(b, lower, BB_HASH_UPPER, hash_depth, best_move);
        return lower;
    }

    if (pass) {
        bb_leaves++;
        lower = calc_score(b, n_empty);
        bb_hash_set(b, lower, BB_HASH_EXACT, hash_depth, -1);
        return lower;
    } else {
        lower = -solve_fastest_first(bb_swap(b), -beta, -alpha, n_empty, 1);
        if (lower > a) {
            if (lower < beta)
                bb_hash_set(b, lower, BB_HASH_EXACT, hash_depth, -1);
            else
                bb_hash_set(b, lower, BB_HASH_LOWER, hash_depth, -1);
        } else
            bb_hash_set(b, lower, BB_HASH_UPPER, hash_depth, -1);
        return lower;
    }
}

static int mtdf(bboard b, int alpha, int beta, int n_empty, int guess)
{
    int score;
    int lower = alpha, upper = beta;
    int old_v = bb_verbosity;

    for (;;) {
        bb_debug("[%d,%d]", guess-1, guess+1);
        bb_verbosity = 0;
        score = solve_fastest_first(b, guess-1, guess+1, n_empty, 0);
        bb_verbosity = old_v;
        bb_debug("(%d)", score);
        if (score <= alpha || score >= beta)
            return score;
        if (score == guess)
            return score;
        if (score < guess) {
            guess -= 2;
            upper = score;
        } else {
            guess += 2;
            lower = score;
        }
        if (lower >= upper)
            return lower;
    }
}

static int solve_root(bboard b, int *score_p, int pass, int wld, u64 mask)
{
    int n_empty;
    int alpha, beta;
    int best_move = -1;
    struct move moves[64];
    int n_moves;
    int i;
    int init_guess;
    int ssbest;
    int n_search;

    make_parity_table(b);
    make_empty_list(b);
    n_empty = bm_count_bits(~(b.black|b.white));

    n_search = 20000;
    if (n_empty > 20)
        n_search <<= n_empty - 20;

    init_guess = bb_uct_search(b, n_search, &ssbest, DEFAULT_SCOPE, 0, 0);
    n_moves = sort_moves_fastest_first(b, moves, NULL, ssbest, -64, 64, mask);

    if (!n_moves) {
        if (!pass) {
            solve_root(bb_swap(b), &alpha, 1, wld, mask);
            alpha = -alpha;
        } else
            alpha = calc_score(b, n_empty);
        if (score_p)
            *score_p = alpha;
        return best_move;
    }

    init_guess = (int) round((double) init_guess / (SCORE_MULT * 2)) * 2;
    if (init_guess > 64) init_guess = 64;
    if (init_guess < -64) init_guess = -64;

    int old_v = bb_verbosity;
    if (wld) {
        alpha = -1;
        beta = 1;
        init_guess = 0;
    } else {
        alpha = -64;
        beta = 64;
    }
    for (i = 0; i < n_moves; i++) {
        u64 flips;
        int score;
        bboard newb;
        int m;

        m = moves[i].move;
        bb_debug("%s:", bb_square_to_ascii(m));
        flips = moves[i].flips;
        newb.black = (b.black ^ flips) | (1ull<<m);
        newb.white = b.white ^ flips;

        update_parity(m);
        del_empty(&empty_node_tbl[m]);
        score = -mtdf(bb_swap(newb), -beta, -alpha, n_empty-1, -init_guess);
        restore_empty(&empty_node_tbl[m]);
        update_parity(m);

        bb_debug("%d\n", score);

        if (score > alpha || best_move==-1) {
            best_move = m;
            alpha = score;
            if (score >= beta)
                break;
        }
        if (wld)
            init_guess = alpha + 1;
        else
            init_guess = alpha + 2;
    }
    init_guess = alpha;
    bb_verbosity = 0;
    sort_moves_fastest_first(b, moves, NULL, best_move, -64, 64, mask);
    bb_verbosity = old_v;

    if (score_p)
        *score_p = alpha;
    return best_move;
}

int bb_endgame(bboard b, int *score_p, int wld, u64 mask)
{
    return solve_root(b, score_p, 0, wld, mask);
}
