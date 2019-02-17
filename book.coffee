sqlite3 = require('sqlite3').verbose()
{ encode_normalized } = require './encode'
{ BLACK, WHITE, EMPTY, pos_to_str, pos_from_str, pos_array_to_str } = require './board'
{ PatternBoard, SCORE_MULT } = require './pattern'
{ shuffle, INFINITY, unique_moves } = require './util'
pattern_eval = require('./pattern_eval')('scores.json')
Player = require './player'
minmax = require './minmax'

DEFAULT_OPENING = [pos_from_str('F5')]

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

defaults =
  readonly: false
  eval_depth: 5
  solve_wld: 18
  solve_full: 16
  verbose: false

module.exports = class Book
  constructor: (filename, options={}) ->
    opt = {defaults..., options...}
    @db = new Database filename, opt.readonly

    @evaluate = do ->
      player1 = Player
        book: null
        strategy: minmax
          verbose: false
          max_depth: opt.eval_depth
          evaluate: pattern_eval
          #cache_size: 0
        solve_wld: opt.solve_wld
        solve_full: opt.solve_full
        verbose: false

      player2 = Player
        book: null
        strategy: minmax
          verbose: false
          max_depth: opt.eval_depth - 1
          evaluate: pattern_eval
          #cache_size: 0
        solve_wld: opt.solve_wld
        solve_full: opt.solve_full
        verbose: false

      (board, me, moves) ->
        ev = await player1 board, me, moves
        unless ev.value?
          ev = await player1 board, me, [ev.move]
        unless ev.solved
          ev2 = await player2 board, me, [ev.move]
          ev.value = Math.round(ev.value + ev2.value / 2)
        ev

    @verbose = opt.verbose

  init: ->
    await @db.run 'pragma busy_timeout=5000'
    await @db.run 'pragma journal_mode=WAL'
    await @db.run '''
      create table if not exists nodes (
        code text primary key,
        n_moves integer,
        outcome integer,
        pub_value integer,
        pri_value integer,
        is_leaf integer,
        solved integer,
        n_visited integer)
        '''

    await @db.run '''
      create table if not exists games (
        moves text primary key,
        outcome integer)
        '''

    # migration
    try
      await @db.run '''alter table nodes add column solved integer'''
    catch

  get_by_code: (code) -> @db.get 'select * from nodes where code=?', [code]

  get: (board) -> @get_by_code(encode_normalized(board))

  set: (board, data) ->
    code = encode_normalized(board)
    n_moves = 60 - board.count(EMPTY)
    @db.run '''
      insert or replace into nodes
        (code, n_moves, outcome, pub_value, pri_value, n_visited, is_leaf, solved)
        values (?, ?, ?, ?, ?, ?, ?, ?)
        ''',
        [code, n_moves, data.outcome, data.pub_value, data.pri_value,
          data.n_visited, data.is_leaf, data.solved]

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
      for move in unique_moves(board, turn)
        flips = board.move turn, move
        data = await @get board
        board.undo turn, move, flips
        #console.log pos_to_str(move, turn), data
        if data?.pri_value?
          if Math.abs(data.pri_value) != INFINITY # XXX
            nodes.push [move, data]
      break unless nodes.length

      n = 0
      n += data.n_visited for [move, data] in nodes

      max = -Infinity
      best = null
      if scope == 0
        nodes = shuffle nodes
      for [move, data] in nodes
        value = data.pri_value * turn

        bias = scope * Math.sqrt(n / (data.n_visited + 1))
        if @verbose
          console.log pos_to_str(move, turn), data.n_visited,
            Math.round(bias), value
        value += bias

        if value > max
          max = value
          best = {move, turn, solved: data.solved}
          last_value = Math.round((value - bias) * turn)

      if @verbose
        console.log '-->', pos_to_str(best.move, turn), Math.round(last_value)
      moves.push best
      board.move turn, best.move
      turn = -turn
    {board, moves, turn, value: last_value}

  add_game: (moves, learn=false) ->
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

    data = (await @get(board)) or {n_visited:0}
    data.outcome = outcome
    data.pub_value = outcome * SCORE_MULT
    data.pri_value = outcome_to_eval(outcome, turn)
    data.n_visited++
    await @set board, data
    await @add_to_tree board, history, learn

  add_to_tree: (board, history, learn) ->
    #await @db.run 'begin'
    while history.length
      {move, turn, flips, solved} = history.pop()
      board.undo turn, move, flips
      max_outcome = max_pub = max_pri = -INFINITY
      have_leaf = false
      unevaled = []
      for m in board.list_moves(turn)
        flips = board.move turn, m
        data = await @get(board)
        board.undo turn, m, flips
        if data
          if data.outcome?
            outcome = data.outcome * turn
            if outcome > max_outcome
              max_outcome = outcome
          pri = data.pri_value * turn
          if pri > max_pri
            max_pri = pri
          pub = data.pub_value * turn
          if pub > max_pub
            max_pub = pub
          if data.is_leaf
            have_leaf = true
        else
          unevaled.push m

      if learn and not solved and not have_leaf and unevaled.length
        ev = await @evaluate(board, turn, unevaled)
        flips = board.move turn, ev.move
        throw new Error 'invalid move' unless flips.length
        data = (await @get(board)) or {n_visited:0}
        value = ev.value * turn
        if ev.solved
          if ev.solved == 'full' or (ev.solved == 'wld' and value == 0)
            data.pri_value = outcome_to_eval(value, turn)
            data.outcome = value
          else
            data.pri_value = value * SCORE_MULT
          data.pub_value = value * SCORE_MULT
        else
          data.pri_value = value
          data.pub_value = value
        data.is_leaf = true
        await @set board, data
        #console.log 'leaf', pos_to_str(ev.move, turn), data.pri_value
        board.undo turn, ev.move, flips
        pri = data.pri_value * turn
        if pri > max_pri
          max_pri = pri
        pub = data.pub_value * turn
        if pub > max_pub
          max_pub = pub

      data = (await @get(board)) or {n_visited:0}
      if max_outcome > -INFINITY
        data.outcome = max_outcome * turn
      data.pub_value = max_pub * turn
      data.pri_value = max_pri * turn
      data.is_leaf = false
      data.n_visited++
      await @set board, data
    #await @db.run 'commit'

  extend: (scope, opening=DEFAULT_OPENING) ->
    {moves, value} = await @find_opening(scope, opening)
    board = new PatternBoard
    history = []
    for {move, turn, solved} in moves
      flips = board.move turn, move
      throw new Error 'invalid move' unless flips.length
      process.stdout.write pos_to_str(move, turn)
      history.push {move, turn, flips, solved}
    process.stdout.write ": #{value} "
    if board.any_moves(-turn)
      turn = -turn
    ev = await @evaluate(board, turn)
    flips = board.move turn, ev.move
    throw new Error 'invalid move' unless flips.length
    process.stdout.write pos_to_str(ev.move, turn)
    history.push {move:ev.move, turn, flips, solved: ev.solved}

    data = await @get(board)
    if data
      console.log ' transposition'
    else
      data = {n_visited:0, is_leaf:true}
      value = ev.value * turn
      if ev.solved
        if ev.solved == 'full' or (ev.solved == 'wld' and value == 0)
          data.pri_value = outcome_to_eval(value, turn)
          data.outcome = value
        else
          data.pri_value = value * SCORE_MULT
        data.pub_value = value * SCORE_MULT
      else
        data.pri_value = value
        data.pub_value = value
      data.solved = ev.solved
      console.log ": #{data.pub_value}"
      await @set board, data

    await @add_to_tree board, history, true

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
      select code from nodes where n_moves=? order by n_visited desc limit ?',
      ''', [n_moves, n]
    rows.map (row) -> row.code

  has_game: (moves_str) ->
    (await @db.get 'select count(*) as c from games where moves=?',
      [moves_str]).c

  dump_nodes: (cb) -> @db.each 'select * from nodes where outcome is not null', [], (row) -> cb(row)

  get_visited_nodes: (min_visited, cb) ->
    @db.each 'select * from nodes where n_visited >= ?', [min_visited], (row) ->
      cb row
