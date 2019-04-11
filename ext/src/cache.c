#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <assert.h>
#include "bitboard.h"
#include "cache.h"

/* #define VALIDATE */

typedef struct _entry entry_t;

struct _entry {
    bboard b;
    entry_t *hash_next, *hash_prev;
    entry_t *lru_next, *lru_prev;
};

struct _cache {
    entry_t *lru_first;
    entry_t *lru_last;
    u32 hash_bits;
    int n_entries;
    int capacity;
    int data_size;
    cache_stats_t stats;
    entry_t *hash_tbl[];
};

#ifdef VALIDATE
static void validate_cache(cache_t cache);
static void validate_entry(cache_t cache, entry_t *entry);
#else
# define validate_cache(a) ((void) 0)
# define validate_entry(a, b) ((void) 0)
#endif

cache_t cache_create(int bits, int data_size)
{
    int capacity = 1 << bits;
    cache_t cache = calloc(1, sizeof(*cache) + capacity * sizeof(entry_t *));
    cache->hash_bits = bits;
    cache->capacity = capacity;
    cache->data_size = data_size;
    validate_cache(cache);
    return cache;
}

void cache_delete(cache_t cache)
{
    validate_cache(cache);

    entry_t *next;
    for (entry_t *entry = cache->lru_first; entry; entry = next) {
        next = entry->lru_next;
        free(entry);
    }
    free(cache->hash_tbl);
    free(cache);
}

static void lru_remove(cache_t cache, entry_t *entry)
{
    entry_t *next = entry->lru_next;
    if (next) {
        assert(next->lru_prev == entry);
        next->lru_prev = entry->lru_prev;
    } else {
        assert(cache->lru_last == entry);
        cache->lru_last = entry->lru_prev;
    }

    entry_t *prev = entry->lru_prev;
    if (prev) {
        assert(prev->lru_next == entry);
        prev->lru_next = entry->lru_next;
    } else {
        assert(cache->lru_first == entry);
        cache->lru_first = entry->lru_next;
    }
}

static void lru_put(cache_t cache, entry_t *entry)
{
    entry_t *old = cache->lru_first;
    if (old) {
        old->lru_prev = entry;
        entry->lru_next = old;
    }
    entry->lru_prev = NULL;
    cache->lru_first = entry;
    if (!cache->lru_last)
        cache->lru_last = entry;
}

static void lru_move_to_top(cache_t cache, entry_t *entry)
{
    lru_remove(cache, entry);
    lru_put(cache, entry);
}

static u32 calc_hash(bboard b, u32 hash_bits)
{
    u64 hash = b.black*0x38803e18c702c595ull + b.white*0xeaae1752e8140f06ull;
    return (u32) (hash >> (64 - hash_bits));
}

static entry_t **find_hash_slot(cache_t cache, bboard b)
{
    u32 hash = calc_hash(b, cache->hash_bits);
    return &cache->hash_tbl[hash];
}

static entry_t *find(cache_t cache, bboard b)
{
    entry_t *entry = *find_hash_slot(cache, b);
    for (; entry; entry = entry->hash_next) {
        if (bb_equal(entry->b, b))
            return entry;
    }
    return NULL;
}

static void hash_remove(cache_t cache, entry_t *entry)
{
    if (entry->hash_prev) {
        assert(entry->hash_prev->hash_next = entry);
        entry->hash_prev->hash_next = entry->hash_next;
    } else {
        entry_t **slot = find_hash_slot(cache, entry->b);
        assert(*slot == entry);
        *slot = entry->hash_next;
    }

    if (entry->hash_next) {
        assert(entry->hash_next->hash_prev == entry);
        entry->hash_next->hash_prev = entry->hash_prev;
    }
}

static void remove_entry(cache_t cache, entry_t *entry)
{
    lru_remove(cache, entry);
    hash_remove(cache, entry);

    free(entry);
    cache->n_entries--;

    validate_cache(cache);
}

static void lru_spill(cache_t cache)
{
    remove_entry(cache, cache->lru_last);
    cache->stats.n_spill++;
}

static entry_t *put_new(cache_t cache, bboard b)
{
    entry_t *entry = calloc(1, sizeof(entry_t) + cache->data_size);
    entry->b = b;

    entry_t **slot = find_hash_slot(cache, b);
    entry_t *old_entry = *slot;
    if (old_entry) {
        old_entry->hash_prev = entry;
        entry->hash_next = old_entry;
    }
    *slot = entry;

    lru_put(cache, entry);

    cache->n_entries++;
    if (cache->n_entries > cache->capacity)
        lru_spill(cache);

    validate_entry(cache, entry);
    return entry;
}

static entry_t *
put_or_rewrite(cache_t cache, bboard b)
{
    entry_t *entry = find(cache, b);
    if (entry)
        lru_move_to_top(cache, entry);
    else
        entry = put_new(cache, b);
    return entry;
}

void *cache_get(cache_t cache, bboard b)
{
    entry_t *entry = find(cache, b);
    if (entry) {
        cache->stats.n_hit++;
        lru_move_to_top(cache, entry);
        validate_cache(cache);
        return entry + 1;
    } else {
        cache->stats.n_miss++;
        return NULL;
    }
}

void *cache_put(cache_t cache, bboard b)
{
    entry_t *entry = put_or_rewrite(cache, b);
    validate_cache(cache);
    return entry + 1;
}

const cache_stats_t *cache_stats(cache_t cache)
{
    return &cache->stats;
}

#ifdef VALIDATE
static void validate_entry(cache_t cache, entry_t *entry)
{
    if (entry->hash_next)
        assert(entry->hash_next->hash_prev == entry);

    if (entry->hash_prev)
        assert(entry->hash_prev->hash_next == entry);
    else
        assert(*find_hash_slot(cache, entry->b) == entry);

    if (entry->lru_next)
        assert(entry->lru_next->lru_prev == entry);
    else
        assert(cache->lru_last == entry);

    if (entry->lru_prev)
        assert(entry->lru_prev->lru_next == entry);
    else
        assert(cache->lru_first = entry);

    assert(find(cache, entry->b) == entry);
}

static void validate_cache(cache_t cache)
{
    assert(cache);
    assert(cache->hash_tbl);
    assert(cache->n_entries <= cache->capacity);
    int n = 0;
    for (entry_t *entry = cache->lru_first; entry; entry = entry->lru_next) {
        validate_entry(cache, entry);
        n++;
    }
    assert(n == cache->n_entries);
}
#endif
