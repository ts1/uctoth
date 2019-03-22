#include <stdlib.h>
#include <assert.h>
#include "bb_hash.h"

static int hash_size;
static int hash_shift;
static bb_hashnode *hash_tbl;

inline
static u64 calc_hash(bboard b)
{
    u64 hash;
    hash = b.black*0xf17755938f04bf32ULL + b.white*0x87dd526fac3f8d7fULL;
    hash >>= hash_shift;
    assert(hash < (u64) hash_size);
    return hash;
}

void bb_hash_init(int order)
{
    hash_size = 1 << order;
    hash_shift = 64 - order;
    bb_hash_reset();
}

void bb_hash_free(void)
{
    if (hash_tbl)
        free(hash_tbl);
    hash_tbl = NULL;
}

void bb_hash_reset(void)
{
    assert(hash_size);
    bb_hash_free();
    hash_tbl = calloc(hash_size, sizeof *hash_tbl);
    if (!hash_tbl)
        bb_error("Out of memory allocating hash table\n");
}

bb_hashnode *bb_hash_get(bboard b)
{
    bb_hashnode *p;
    u64 hash;

    hash = calc_hash(b);
    p = hash_tbl + hash;
    if (bb_equal(p->b, b))
        return p;

    hash ^= 1;
    p = hash_tbl + hash;
    if (bb_equal(p->b, b))
        return p;

    return NULL;
}

static void
update_hash(bb_hashnode *p, int value, int flags, int depth, int move)
{
    if (p->depth > depth)
        return;
    if (move >= 0 && p->move[0] != move) {
        p->move[1] = p->move[0];
        p->move[0] = move;
    }
    p->value = value;
    p->flags = flags;
    p->depth = depth;
}

static void
replace_hash(bb_hashnode *p, bboard b, int value, int flags, int depth, int move)
{
    if (p->depth > depth)
        return;
    p->b = b;
    p->move[0] = move;
    p->move[1] = -1;
    p->value = value;
    p->flags = flags;
    p->depth = depth;
}

void bb_hash_set(bboard b, int value, int flags, int depth, int move)
{
    bb_hashnode *p1, *p2;
    u64 hash;

    hash = calc_hash(b);

    p1 = hash_tbl + hash;
    p2 = hash_tbl + (hash ^ 1);

    if (bb_equal(p1->b, b))
        update_hash(p1, value, flags, depth, move);
    else if (bb_equal(p2->b, b))
        update_hash(p2, value, flags, depth, move);
    else if (p1->depth <= p2->depth)
        replace_hash(p1, b, value, flags, depth, move);
    else
        replace_hash(p2, b, value, flags, depth, move);
}
