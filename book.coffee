sqlite3 = require('better-sqlite3')
{ encode_normalized, decode } = require './encode'
{
  BLACK
  WHITE
  EMPTY
  pos_to_str
  pos_from_str
  pos_array_to_str
  Board
} = require './board'
{
  PatternBoard
  SCORE_MULT
  N_MOVES_PER_PHASE
  code_to_single_indexes
} = require './pattern'
{ shuffle, INFINITY, unique_moves, int } = require './util'
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
  constructor: (filename, readonly=false) ->
    @db = sqlite3 filename, {readonly, timeout: 100000}
    process.on 'exit', => @db.close()
  run: (sql, params) -> @db.prepare(sql).run(params ? [])
  get: (sql, params) -> @db.prepare(sql).get(params ? [])
  all: (sql, params) -> @db.prepare(sql).all(params ? [])
  iterate: (sql, params) -> @db.prepare(sql).iterate(params ? [])
  each: (sql, params, cb) -> cb(row) for row from @iterate(sql, params)
  prepare: (sql) -> @db.prepare(sql)
  run_many: (sql, params_array) ->
    stmt = @db.prepare(sql)
    @run 'begin'
    for params from params_array
      stmt.run params
    @run 'commit'

defaults =
  readonly: false
  eval_depth: 10
  solve_wld: 21
  solve_full: 19
  verbose: false

module.exports = class Book
  constructor: (filename, options={}) ->
    @filename = filename
    opt = {defaults..., options...}
    @db = new Database filename, opt.readonly
    @db.run 'pragma journal_mode=WAL'
    @verbose = opt.verbose
    @stmt_get_game_node = @db.prepare(
      'select outcome from game_nodes where code=?'
    )

    @evaluate = do ->
      do_evaluate = null
      (board, me, moves) ->
        unless do_evaluate
          do_evaluate = do ->
            console.assert opt.evaluate?
            player1 = Player
              book: null
              strategy: minmax
                verbose: false
                max_depth: opt.eval_depth
                evaluate: opt.evaluate
                #cache_size: 0
              solve_wld: opt.solve_wld
              solve_full: opt.solve_full
              verbose: false
              endgame_eval: opt.evaluate

            player2 = Player
              book: null
              strategy: minmax
                verbose: false
                max_depth: opt.eval_depth - 1
                evaluate: opt.evaluate
                #cache_size: 0
              solve_wld: opt.solve_wld
              solve_full: opt.solve_full
              verbose: false
              endgame_eval: opt.evaluate

            (board, me, moves) ->
              ev = player1 board, me, moves
              unless ev.value?
                ev = player1 board, me, [ev.move]
              unless ev.solved
                ev2 = player2 board, me, [ev.move]
                ev.value = Math.round(ev.value + ev2.value / 2)
              ev
        do_evaluate(board, me, moves)


  init: ->
    # game nodes
    @db.run '''
      create table if not exists game_nodes (
        code text primary key,
        n_moves integer,
        outcome integer)
      '''
    @db.run '''
      create index if not exists game_nodes__n_moves on game_nodes (n_moves)
      '''

    # opening nodes
    @db.run '''
      create table if not exists op_nodes (
        code text primary key,
        n_moves integer,
        pub_value integer,
        pri_value integer,
        is_leaf integer,
        solved integer,
        n_visited integer)
      '''

    @db.run '''
      create table if not exists indexes (
        code text primary key,
        indexes text)
      '''

    @migrate()

  migrate: ->
    try
      @db.run '''
        insert into game_nodes (code, n_moves, outcome)
          select code, n_moves, outcome from nodes
        '''
      console.log 'migrating database'
      @db.run '''
        insert into op_nodes (
          code, n_moves, pub_value, pri_value, is_leaf, solved, n_visited
        ) select
          code, n_moves, pub_value, pri_value, is_leaf, solved, n_visited
        from nodes
        '''
      @db.run 'drop table nodes'
      @db.run 'vacuum'
    catch

  get_game_node: (board) ->
    code = encode_normalized(board)
    data = @stmt_get_game_node.get([code])
    data?.outcome

  get_op_node: (board) ->
    @db.get('select * from op_nodes where code=?', [encode_normalized(board)])

  put_game_node: (board, outcome) ->
    code = encode_normalized(board)
    n_moves = 60 - board.count(EMPTY)

    @db.run '''
      insert or replace into game_nodes (code, n_moves, outcome)
      values (:code, :n_moves, :outcome)
      ''', { code, n_moves, outcome }

  put_op_node: (board, data) ->
    code = encode_normalized(board)
    n_moves = 60 - board.count(EMPTY)
    is_leaf = int(data.is_leaf)

    @db.run '''
      insert or replace into op_nodes
        (code, n_moves, pub_value, pri_value, n_visited, is_leaf, solved)
      values
        (:code, :n_moves, :pub_value, :pri_value, :n_visited, :is_leaf, :solved)
      ''', { data..., code, n_moves, is_leaf }

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
        data = @get_op_node board
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

  add_game: (moves) ->
    @db.run 'begin immediate'
    board = new Board
    history = []
    for {move, turn} in moves
      flips = board.move turn, move
      throw new Error 'invalid move' unless flips.length
      history.push {move, turn, flips}
    if board.any_moves(BLACK) or board.any_moves(WHITE)
      throw new Error 'game not finished'
    outcome = board.outcome()

    unique = false

    s = pos_array_to_str(moves)
    unique = true unless @get_game_node(board)?
    @put_game_node board, outcome

    while history.length
      {move, turn, flips} = history.pop()
      board.undo turn, move, flips
      unique = true unless @get_game_node(board)?
      max_outcome = -INFINITY
      for m in board.list_moves(turn)
        flips = board.move turn, m
        outcome = @get_game_node(board)
        board.undo turn, m, flips
        if outcome?
          outcome *= turn
          if outcome > max_outcome
            max_outcome = outcome

      if max_outcome > -INFINITY
        @put_game_node board, max_outcome * turn
    @db.run 'commit'
    unique

  extend: (scope, opening=DEFAULT_OPENING) ->
    #@db.run 'begin immediate'
    {moves, value} = @find_opening(scope, opening)
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
    ev = @evaluate(board, turn)
    flips = board.move turn, ev.move
    throw new Error 'invalid move' unless flips.length
    process.stdout.write pos_to_str(ev.move, turn)
    history.push {move:ev.move, turn, flips, solved: ev.solved}

    data = @get_op_node(board)
    if data
      console.log ' transposition'
    else
      data = {n_visited:0, is_leaf:true}
      value = ev.value * turn
      if ev.solved
        if ev.solved == 'full' or (ev.solved == 'wld' and value == 0)
          data.pri_value = outcome_to_eval(value, turn)
        else
          data.pri_value = value * SCORE_MULT
        data.pub_value = value * SCORE_MULT
      else
        data.pri_value = value
        data.pub_value = value
      data.solved = ev.solved
      console.log ": #{data.pub_value}"
      @put_op_node board, data

    @add_to_tree board, history, true
    #@db.run 'commit'

  add_to_tree: (board, history) ->
    while history.length
      {move, turn, flips, solved} = history.pop()
      board.undo turn, move, flips
      max_pub = max_pri = -INFINITY
      have_leaf = false
      unevaled = []
      for m in board.list_moves(turn)
        flips = board.move turn, m
        data = @get_op_node(board)
        board.undo turn, m, flips
        if data
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

      if not solved and not have_leaf and unevaled.length
        ev = @evaluate(board, turn, unevaled)
        flips = board.move turn, ev.move
        throw new Error 'invalid move' unless flips.length
        data = @get_op_node(board) or {n_visited:0}
        value = ev.value * turn
        if ev.solved
          if ev.solved == 'full' or (ev.solved == 'wld' and value == 0)
            data.pri_value = outcome_to_eval(value, turn)
          else
            data.pri_value = value * SCORE_MULT
          data.pub_value = value * SCORE_MULT
        else
          data.pri_value = value
          data.pub_value = value
        data.is_leaf = true
        data.solved = ev.solved
        @put_op_node board, data
        if @verbose
          console.log 'leaf', pos_to_str(ev.move, turn), data.pri_value
        board.undo turn, ev.move, flips
        pri = data.pri_value * turn
        if pri > max_pri
          max_pri = pri
        pub = data.pub_value * turn
        if pub > max_pub
          max_pub = pub

      data = @get_op_node(board) or {n_visited:0, solved:solved}
      data.pub_value = max_pub * turn
      data.pri_value = max_pri * turn
      data.is_leaf = false
      data.n_visited++
      @put_op_node board, data

  sum_nodes_outcome: ->
    @db.get('select sum(outcome) as s from game_nodes').s or 0

  has_game: (moves) ->
    board = new Board
    for {turn, move} in moves
      flips = board.move turn, move
      throw new Error 'invalid move' unless flips.length
      return false unless @get_game_node(board)?
    true

  iterate_indexes: (phase) ->
    min_moves = 1 + (phase - 1) * N_MOVES_PER_PHASE
    max_moves = 1 + (phase + 1 + 1) * N_MOVES_PER_PHASE

    db2 = new Database @filename

    rows = @db.iterate '''
      select n.code, n.outcome, i.indexes
        from game_nodes n left join indexes i on n.code = i.code
        where n.outcome is not null
        and n.n_moves >= :min_moves
        and n.n_moves < :max_moves
      ''', {min_moves, max_moves}

    buf = []

    flush = ->
      db2.run_many '''
        insert or replace into indexes (code, indexes) values (?, ?)
        ''', buf
      buf = []

    for {code, outcome, indexes} from rows
      if indexes
        indexes = JSON.parse(indexes)
      else
        indexes = code_to_single_indexes(code)
        buf.push [code, JSON.stringify(indexes)]
        flush() if buf.length >= 10000
      yield [outcome, indexes...]

    flush() if buf.length
