{lru_cache} = require './util'

make_key = (board) -> JSON.stringify board.board

module.exports = (size) ->
  cache = lru_cache(size)

  get: (board, turn, depth, lower, upper) ->
    item = cache.get(make_key board)
    return null unless item

    [t, d, l, u] = item
    return null if d < depth

    if t != turn
      [l, u] = [-u, -l]

    if l >= upper
      l
    else if u <= lower
      u
    else if u == l
      u
    else
      null

  get_lower: (board, turn, depth) ->
    item = cache.get(make_key board)
    return null unless item
    [t, d, l, u] = item
    return null if d < depth
    if t != turn then -u else l

  set: (board, turn, depth, lower, upper, value) ->
    key = make_key board
    item = cache.get(key)
    return if item and item[0] > depth
    if value >= upper
      item = [turn, depth, value, Infinity]
    else if value <= lower
      item = [turn, depth, -Infinity, value]
    else
      item = [turn, depth, value, value]
    cache.put key, item

  stats: ->
    {n, hit, miss, evict} = cache.stats()
    console.log 'cache entry:', n
    console.log 'cache hit:', hit
    console.log 'cache miss:', miss
    console.log 'cache evict:', evict
