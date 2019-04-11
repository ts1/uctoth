#ifndef CACHE_H
#define CACHE_H

#include <stdlib.h>

typedef struct _cache *cache_t;

typedef struct {
    size_t n_hit;
    size_t n_miss;
    size_t n_spill;
} cache_stats_t;

#ifdef __cplusplus
extern "C" {
#endif

cache_t cache_create(int bits, int data_size);
void cache_delete(cache_t cache);
void *cache_get(cache_t cache, bboard b);
void *cache_put(cache_t cache, bboard b);
const cache_stats_t *cache_stats(cache_t cache);

#ifdef __cplusplus
}
#endif

#endif
