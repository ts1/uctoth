sqlite3 = require('sqlite3').verbose()
{ encode_normalized } = require './encode'
{ BLACK, WHITE, EMPTY, pos_to_str, pos_from_str, pos_array_to_str } = require './board'
{ PatternBoard, SCORE_MULT } = require './pattern'
{ shuffle, INFINITY } = require './util'
pattern_eval = require('./pattern_eval')('scores.json')
Player = require './player'
minmax = require './minmax'

DEFAULT_OPENING = [pos_from_str('F5')]
EVAL_DEPTH = 5

evaluate = do ->
  player1 = Player
    book: null
    strategy: minmax
      verbose: false
      max_depth: EVAL_DEPTH
      evaluate: pattern_eval
      cache_size: 0
    solve_wld: 18
    solve_full: 16
    verbose: false

  player2 = Player
    book: null
    strategy: minmax
      verbose: false
      max_depth: EVAL_DEPTH - 1
      evaluate: pattern_eval
      cache_size: 0
    solve_wld: 18
    solve_full: 16
    verbose: false

  (board, me, moves) ->
    ev = await player1 board, me, moves
    unless ev.solved
      ev2 = await player2 board, me, [ev.move]
      ev.value = Math.round(ev.value + ev2.value / 2)
    ev

outcome_to_eval = (outcome, me) ->
  if outcome > 0
    INFINITY
  else if outcome < 0
    -INFINITY
  else
    -INFINITY * me

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
      create table if not exists nodes (
        code text primary key,
        n_moves integer,
        outcome integer,
        eval integer,
        is_leaf integer,
        n_played integer)
        '''
    await @db.run '''
      create table if not exists games (
        moves text primary key,
        outcome integer)
        '''

    # migration
    try
      await @db.run 'select * from book limit 1'
    catch
      return

    @migrate()

  migrate: ->
    process.stdout.write 'Running db migration: '
    await @db.run '''
      insert into nodes (code, n_moves, outcome, n_played)
      select code, n_moves, value, n_played from book
      '''
    await @db.run 'drop table book'
    await @db.run 'vacuum'
    process.stdout.write 'done\n'

  get_by_code: (code) -> @db.get 'select * from nodes where code=?', [code]

  get: (board) -> @get_by_code(encode_normalized(board))

  set: (board, data) ->
    code = encode_normalized(board)
    n_moves = 60 - board.count(EMPTY)
    @db.run '''
      insert or replace into nodes
        (code, n_moves, outcome, eval, n_played, is_leaf)
        values (?, ?, ?, ?, ?, ?)
        ''',
        [code, n_moves, data.outcome, data.eval, data.n_played, data.is_leaf]

  find_opening: (scope, opening=DEFAULT_OPENING) ->
    scope *= SCORE_MULT
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
      for move in board.list_moves(turn)
        flips = board.move turn, move
        data = await @get board
        board.undo turn, move, flips
        #console.log pos_to_str(move, turn), data
        if data?.eval?
          nodes.push [move, data]
      break unless nodes.length

      n = 0
      n += data.n_played for [move, data] in nodes

      max = -Infinity
      best = null
      if scope == 0
        nodes = shuffle nodes
      for [move, data] in nodes
        value = data.eval * turn

        bias = scope * Math.sqrt(n / (data.n_played + 1))
        if scope
          console.log pos_to_str(move, turn), data.n_played, Math.round(bias), value
        value += bias

        if value > max
          max = value
          best = {move, turn}
          last_value = (value - bias) * turn

      if scope
        console.log '-->', pos_to_str(best.move, turn), Math.round(last_value)
      moves.push best
      board.move turn, best.move
      turn = -turn
    {board, moves, turn, value: last_value}

  add_game: (moves) ->
    @db.run 'begin'

    board = new PatternBoard
    history = []
    for {move, turn, solved} in moves
      flips = board.move turn, move
      throw new Error 'invalid move' unless flips.length
      history.push {move, turn, flips, solved}
    if board.any_moves(BLACK) or board.any_moves(WHITE)
      throw new Error 'game not finished'
    outcome = board.outcome()

    s = pos_array_to_str(moves)
    @db.run 'insert or replace into games values (?, ?)', [s, outcome]

    data = (await @get(board)) or {n_played:0}
    data.outcome = outcome
    data.eval = outcome_to_eval(outcome, turn)
    data.n_played++
    await @set board, data

    while history.length
      {move, turn, flips, solved} = history.pop()
      board.undo turn, move, flips
      max_outcome = max_eval = -INFINITY
      have_leaf = false
      unevaled = []
      for m in board.list_moves(turn)
        flips = board.move turn, m
        data = await @get(board)
        board.undo turn, m, flips
        if data
          if data.n_played
            outcome = data.outcome * turn
            if outcome > max_outcome
              max_outcome = outcome
          if data.eval?
            ev = data.eval * turn
            if ev > max_eval
              max_eval = ev
            if data.is_leaf
              have_leaf = true
          else
            unevaled.push m
        else
          unevaled.push m

      if not solved and not have_leaf and unevaled.length
        ev = await evaluate(board, turn, unevaled)
        flips = board.move turn, ev.move
        throw new Error 'invalid move' unless flips.length
        data = (await @get(board)) or {n_played:0}
        if ev.solved
          data.eval = outcome_to_eval(ev.value * turn, turn)
        else
          data.eval = ev.value * turn
        data.is_leaf = true
        await @set board, data
        #console.log 'leaf', pos_to_str(ev.move, turn), data.eval
        board.undo turn, ev.move, flips
        ev = data.eval * turn
        if ev > max_eval
          max_eval = ev

      data = (await @get(board)) or {n_played:0}
      data.outcome = max_outcome * turn
      data.eval = max_eval * turn
      data.is_leaf = false
      data.n_played++
      await @set board, data
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
      select code from nodes where n_moves=? order by n_played desc limit ?',
      ''', [n_moves, n]
    rows.map (row) -> row.code

  has_game: (moves_str) ->
    (await @db.get 'select count(*) as c from games where moves=?',
      [moves_str]).c

  dump_nodes: (cb) -> @db.each 'select * from nodes', [], (row) -> cb(row)
