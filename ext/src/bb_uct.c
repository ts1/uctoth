#include <stdlib.h>
#include <assert.h>
#include <math.h>
#include "bitboard.h"
#include "bb_uct.h"
#include "bb_eval.h"
#include "bb_hash.h"

typedef struct node node_t;
struct node {
    int move, value, n_visited;
    node_t *first_child, *sibling, *pass;
};

static int max_discs, n_nodes, n_search;
static bool grew, outcome_mode, tenacious, by_value;
static double orig_scope, scope, randomness;

#define PER_POOL 1000

typedef struct node_pool node_pool_t;
struct node_pool {
    node_pool_t *prev;
    int n_used;
    node_t nodes[PER_POOL];
};

static node_pool_t *pool;

static node_t *alloc_node(void)
{
    if (!pool || pool->n_used >= PER_POOL) {
        node_pool_t *new_pool = calloc(1, sizeof(node_pool_t));
        new_pool->prev = pool;
        pool = new_pool;
    }
    return &pool->nodes[pool->n_used++];
}

static void free_pools(node_pool_t *pool)
{
    if (pool) {
        free_pools(pool->prev);
        free(pool);
    }
}

static inline int eval_endgame(bboard b)
{
    if (outcome_mode)
        return bb_score(b) * SCORE_MULT;
    else
        return bm_count_bits(b.black) > bm_count_bits(b.white) ?
           (BB_INF/2) : -(BB_INF/2);
}

static void uct_search(bboard b, node_t *node, int n_discs, int pass, u64 mask)
{
    node->n_visited++;
    if (n_discs > max_discs)
        max_discs = n_discs;

    if (node->pass) {
        uct_search(bb_swap(b), node->pass, n_discs, 1, 0);
        node->value = -node->pass->value;
    } else if (node->first_child) {
        double max = -INFINITY;
        node_t *best = NULL;
        for (node_t *child = node->first_child; child; child = child->sibling) {
            double bias = scope *
                sqrt((node->n_visited + 1)/ (child->n_visited + 2));
            double value = child->value + bias;
            if (value > max) {
                max = value;
                best = child;
            }
        }
        u64 flips = bb_flip_discs(b, best->move);
        assert(flips);
        bboard newb = bb_swap(bb_apply_flips(b, flips, best->move));

        uct_search(newb, best, n_discs+1, 0, 0);

        int maxval = -BB_INF;
        for (node_t *child = node->first_child; child; child = child->sibling) {
            if (child->value > maxval)
                maxval = child->value;
        }
        node->value = -maxval;
    } else if (n_discs < 64) {
        node_t **child_slot = &node->first_child;
        u64 pmoves = bb_potential_moves(b);
        if (mask)
            pmoves &= mask;
        int max = -BB_INF;
        for (int move = 0; pmoves; move++) {
            if ((pmoves & (1ull << move)) == 0)
                continue;
            pmoves &= ~(1ull << move);
            u64 flips = bb_flip_discs(b, move);
            if (!flips)
                continue;
            node_t *child = alloc_node();
            *child_slot = child;
            child_slot = &child->sibling;
            bboard newb = bb_apply_flips(b, flips, move);
            if (n_discs == 63)
                child->value = eval_endgame(newb);
            else
                child->value = bb_eval(newb, n_discs+1);
            child->move = move;
            if (child->value > max)
                max = child->value;
            n_nodes++;
            grew = true;
        }
        if (node->first_child)
            node->value = -max;
        else {
            if (pass) {
               if (node->n_visited == 1) {
                   node->value = -eval_endgame(b);
                   grew = true;
               }
            } else {
                node_t *child = alloc_node();
                node->pass = child;
                child->value = -node->value;
                n_nodes++;
                grew = true;
            }
        }
    }
}

static node_t *find_best_child(node_t *node)
{
    node_t *best = node->first_child;
    for (node_t *child = best->sibling; child; child = child->sibling) {
        if (child->n_visited > best->n_visited ||
             (child->n_visited == best->n_visited &&
                  child->value > best->value))
            best = child;
    }
    return best;
}

static node_t *find_best_child_by_value(node_t *node)
{
    node_t *best = node->first_child;
    for (node_t *child = best->sibling; child; child = child->sibling)
        if (child->value > best->value)
            best = child;
    return best;
}

static node_t *find_stochastic_child(node_t *node)
{
    double inv_rand = 1 / randomness;
    double avg = 0;
    int n = 0;
    for (node_t *child = node->first_child; child; child = child->sibling) {
        avg += child->n_visited;
        n++;
    }
    avg /= n;
    bb_debug("avg=%g\n", avg);

    double sum = 0;
    for (node_t *child = node->first_child; child; child = child->sibling)
        sum += pow(child->n_visited / avg, inv_rand);

    double r = ((double) rand() / RAND_MAX) * sum;

    double s = 0;
    for (node_t *child = node->first_child; child; child = child->sibling) {
        s += pow(child->n_visited / avg, inv_rand);
        if (s >= r)
            return child;
    }
    return NULL;
}

void bb_uct_set_options(
        int _n_search,
        double _scope,
        double _randomness,
        bool _tenacious,
        bool _by_value)
{
    n_search = _n_search;
    orig_scope = _scope;
    randomness = _randomness;
    tenacious = _tenacious;
    by_value = _by_value;
}

int bb_uct_search(bboard b, int *move_ptr, u64 mask)
{
    int n_discs = bm_count_bits(b.black | b.white);
    node_t *root = alloc_node();
    scope = orig_scope;
    outcome_mode = !tenacious;
    max_discs = 0;
    n_nodes = 1;
    for (int i = 0; i < n_search; i++) {
        grew = false;
        uct_search(b, root, n_discs, 0, mask);
        if (!grew) {
            if (!tenacious)
                break;
            if (scope > orig_scope * 100)
                break;
            scope *= 1.1;
        }
    }
    bb_debug("max depth %d\n", max_discs - n_discs);
    bb_debug("%d nodes\n", n_nodes);

    if (!root->first_child) {
        if (move_ptr)
            *move_ptr = -1;
        return 0;
    }

    node_t *best =
        randomness? find_stochastic_child(root) :
        by_value? find_best_child_by_value(root) :
        find_best_child(root);

    int retval = best->value;
    if (move_ptr)
        *move_ptr = best->move;
    free_pools(pool);
    pool = NULL;
    return retval;
}
