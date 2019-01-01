sqlite3 = require('sqlite3').verbose()
{ encode_normalized } = require './encode'
{ BLACK, WHITE, EMPTY, pos_to_str, pos_from_str, pos_array_to_str } = require './board'
{ PatternBoard } = require './pattern'
{ shuffle, round_value } = require './util'

DEFAULT_OPENING = [pos_from_str('F5')]

class Database
  constructor: (filename, readonly) ->
    mode = if readonly then sqlite3.OPEN_READONLY else undefined
    @db = new sqlite3.Database filename, mode
    process.on 'exit', => @db.close()
  run: (sql, params) ->
    new Promise (resolve, reject) =>
      @db.run sql, params, (err, result) ->
        if err
          reject err
        else
          resolve result
  get: (sql, params) ->
    new Promise (resolve, reject) =>
      @db.get sql, params, (err, result) ->
        if err
          reject err
        else
          resolve result
  all: (sql, params) ->
    new Promise (resolve, reject) =>
      @db.all sql, params, (err, result) ->
        if err
          reject err
        else
          resolve result
  each: (sql, params, cb) ->
    new Promise (resolve, reject) =>
      @db.each sql, params, ((err, result) ->
        if err
          reject err
        else
          cb result
      ), ((err, result) ->
        if err
          reject err
        else
          resolve result
      )

module.exports = class Book
  constructor: (filename, {readonly}={}) ->
    @db = new Database filename, readonly

  init: ->
    await @db.run 'pragma busy_timeout=5000'
    await @db.run 'pragma journal_mode=WAL'
    await @db.run '''
      create table if not exists book (
        code text primary key,
        n_moves integer,
        value float,
        n_played integer)
        '''
    await @db.run '''
      create table if not exists games (
        moves text primary key,
        outcome integer)
        '''

  get_by_code: (code) -> @db.get 'select * from book where code=?', [code]

  get: (board) -> @get_by_code(encode_normalized(board))

  set: (board, data) ->
    code = encode_normalized(board)
    n_moves = 60 - board.count(EMPTY)
    @db.run '''
      insert or replace into book (code, n_moves, value, n_played)
        values (?, ?, ?, ?)
        ''', [code, n_moves, data.value, data.n_played]

  find_opening: (scope, evaluator, opening=DEFAULT_OPENING) ->
    board = new PatternBoard
    moves = []
    turn = BLACK
    for move in opening
      flips = board.move turn, move
      unless flips.length
        throw new Error 'invalid move'
      moves.push {move, turn}
      turn = -turn
    last_value = 0
    loop
      unless board.any_moves turn
        turn = -turn
        unless board.any_moves turn
          break
      nodes = []
      has_leaf = false
      unplayed = []
      for move in board.list_moves(turn)
        flips = board.move turn, move
        data = await @get board
        board.undo turn, move, flips
        if data
          nodes.push [move, data]
          if data.n_played == 0
            has_leaf = true
        else
          unplayed.push move
      break unless nodes.length

      if not has_leaf and unplayed.length
        ev = await evaluator(board, turn, unplayed)
        flips = board.move turn, ev.move
        throw new Error 'invalid move' unless flips.length
        value = ev.value * turn
        data = { value, n_played:0 }
        await @set board, data
        board.undo turn, ev.move, flips
        nodes.push [ev.move, data]
        console.log 'leaf', pos_to_str(ev.move, turn), round_value(value)

      n = 0
      n += data.n_played for [move, data] in nodes

      max = -Infinity
      best = null
      if scope == 0
        nodes = shuffle nodes
      for [move, data] in nodes
        if data.value == 0
          value = -1
        else
          value = data.value * turn

        bias = scope * Math.sqrt(n / (data.n_played + 1))
        console.log pos_to_str(move, turn), data.n_played, round_value(bias),
          round_value(value)
        value += bias

        if value > max
          max = value
          best = {move, turn}
          last_value = (value - bias) * turn

      console.log '-->', pos_to_str(best.move, turn), round_value(last_value)
      moves.push best
      board.move turn, best.move
      turn = -turn
    {board, moves, turn, value: last_value}

  add_game: (moves) ->
    @db.run 'begin'

    board = new PatternBoard
    history = []
    for {move, turn} in moves
      flips = board.move turn, move
      throw new Error 'invalid move' unless flips.length
      history.push {move, turn, flips}
    if board.any_moves(BLACK) or board.any_moves(WHITE)
      throw new Error 'game not finished'
    outcome = board.outcome()

    s = pos_array_to_str(moves)
    @db.run 'insert or replace into games values (?, ?)', [s, outcome]

    data = await @get(board)
    n_played = if data then data.n_played + 1 else 1
    await @set board, {n_played, value:outcome}

    while history.length
      {move, turn, flips} = history.pop()
      board.undo turn, move, flips
      max = -Infinity
      for m in board.list_moves(turn)
        flips = board.move turn, m
        data = await @get(board)
        board.undo turn, m, flips
        if data and data.n_played
          value = data.value * turn
          if value > max
            max = value
      value = max * turn
      data = await @get(board)
      n_played = if data then data.n_played + 1 else 1
      await @set board, {n_played, value}
    @db.run 'commit'

  count_games: (me=null) ->
    sql = 'select count(*) as c from games'
    if me?
      if me > 0
        sql += ' where outcome > 0'
      else if me < 0
        sql += ' where outcome < 0'
      else
        sql += ' where outcome = 0'
    (await @db.get sql).c

  sum_outcome: -> (await @db.get 'select sum(outcome) as s from games', []).s

  get_neutral_positions: (n_moves, n) ->
    rows = await @db.all '''
      select code from book where n_moves=? order by n_played desc limit ?',
      ''', [n_moves, n]
    rows.map (row) -> row.code

  has_game: (moves_str) ->
    (await @db.get 'select count(*) as c from games where moves=?',
      [moves_str]).c
