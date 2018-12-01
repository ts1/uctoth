sqlite3 = require('sqlite3').verbose()
{ encode_normalized, decode } = require './encode'
{ BLACK, WHITE, pos_to_str, pos_from_str, pos_array_to_str } = require './board'
{ PatternBoard } = require './pattern'
{ shuffle } = require './util'

module.exports = class Book
  constructor: (filename) ->
    @db = new sqlite3.Database filename
    @db.run 'pragma busy_timeout=5000'
    @db.run 'pragma journal_mode=WAL'

  init: ->
    await new Promise (resolve, reject) =>
      @db.run '''
        create table if not exists book (
          code text primary key,
          empty integer,
          value float,
          solved text,
          n integer)
        ''', (err) ->
          if err
            reject err
          else
            resolve()
    await new Promise (resolve, reject) =>
      @db.run '''
        create table if not exists games (
          moves text primary key,
          outcome integer
        )
        ''',
        (err) ->
          if err
            reject err
          else
            resolve()

  get_by_code: (code) -> new Promise (resolve, reject) =>
    @db.get 'select * from book where code=?', [code], (err, row)->
      if err
        reject err
      else
        resolve row

  set_by_code: (code, value, solved, n) ->
    new Promise (resolve, reject) =>
      empty = 0
      (empty += 1 if c == '1') for c from code
      @db.run 'insert or replace into book (code, empty, value, solved, n)' +
        ' values (?, ?, ?, ?, ?)', [code, empty,value, solved, n],
        (err) ->
          if err
            reject err
          else
            resolve()

  get: (board) -> @get_by_code(encode_normalized(board))

  set: (board, value, solved, n) ->
    @set_by_code(encode_normalized(board), value, solved, n)

  find_opening: (c) ->
    board = new PatternBoard
    f5 = pos_from_str('f5')
    moves = [{move:f5, solved:null}]
    board.move BLACK, f5
    turn = WHITE
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
        if data
          nodes.push [move, data]
      break unless nodes.length

      n = 0
      n += data.n for [move, data] in nodes
      #log_n = Math.log(n)
      log_n = n

      max = -Infinity
      best = null
      if c == 0
        nodes = shuffle nodes
      for [move, data] in nodes
        value = data.value * turn

        bias = c * Math.sqrt(log_n / (data.n + 1))
        console.log pos_to_str(move), data.n, bias, value if c
        value += bias

        if value > max
          max = value
          best = {move, solved: data.solved}
          last_value = (value - bias) * turn

      console.log 'best', pos_to_str(best.move), last_value if c
      moves.push best
      board.move turn, best.move
      turn = -turn
    {board, moves, turn, value: last_value}

  find_unplayed_opening: (c) ->
    opening = await @find_opening(c)
    moves = pos_array_to_str(move for {move} in opening.moves)
    data = await new Promise (resolve, reject) =>
      @db.get 'select count(*) as played from games where moves like ?',
        ["#{moves}%"],
        (err, data) ->
          if err
            reject err
          else
            resolve data
    if data.played
      null
    else
      opening

  save_game: (moves, outcome) ->
    moves = pos_array_to_str(move for {move} in moves)
    await new Promise (resolve, reject) =>
      @db.run 'insert or replace into games values (?, ?)', [moves, outcome],
        (err) ->
          if err
            reject err
          else
            resolve()
      turn = -turn

  count_games: ->
    data = await new Promise (resolve, reject) =>
      @db.get 'select count(*) as played from games', [],
        (err, data) ->
          if err
            reject err
          else
            resolve data
    data.played

  get_neutral_positions: (n_moves, n) -> new Promise (resolve, reject) =>
    @db.all 'select code from book where empty=? order by n desc limit ?',
      [60-n_moves, n], (err, rows) ->
        reject err if err
        unless rows
          throw new Error 'no positions'
        resolve rows.map (row) -> decode(row.code)

  learn: (moves, evaluator) ->
    board = new PatternBoard
    turn = BLACK
    history = []
    for {move, solved} in moves
      flips = board.move turn, move
      if flips.length == 0
        turn = -turn
        flips = board.move turn, move
        if flips.length == 0
          throw new Error "invalid move #{pos_to_str(move)}"
      history.push [turn, move, flips, solved]
      turn = -turn

    if board.any_moves(BLACK) or board.any_moves(WHITE)
      unless board.any_moves(turn)
        turn = -turn
      e = await evaluator board, turn
      value = e.value * turn
      if e.solved
        if value == 0
          value = -100*turn
        else
          value *= 100
      flips = board.move turn, e.move
      unless flips.length
        throw new Error 'invalid move from evaluator'
      console.log 'new move', pos_to_str(e.move), 'value', value
      await @set board, value, e.solved, 1
      history.push [turn, e.move, flips, e.solved]
      outcome = null
    else
      outcome = board.outcome(BLACK)
      await @set board, outcome*100, 'full', 1

    while (h = history.pop())
      [turn, move_, flips, solved] = h
      board.undo turn, move_, flips

      max = -Infinity
      unchecked = []
      n = 0
      have_leaf = false
      codes = {}
      for move in board.list_moves(turn)
        flips = board.move turn, move
        code = encode_normalized(board)
        if codes[code]
          #console.log 'found symmetric move', pos_to_str(move), pos_to_str(codes[code]), pos_to_str(move_)
          board.undo turn, move, flips
          continue
        codes[code] = move
        data = await @get board
        board.undo turn, move, flips
        if data
          if data.n == 1 and move != move_
            have_leaf = true
          n += data.n
          value = data.value * turn
          if value > max
            max = value
          unless data.solved
            solved = null
        else
          unchecked.push move

      if unchecked.length and not have_leaf and solved != 'full'
        ev = await evaluator board, turn, unchecked
        value = ev.value
        if value > max
          max = value
        value *= turn
        console.log 'leaf', value, ev.solved or 'eval'
        flips = board.move turn, ev.move
        if ev.solved
          if value == 0
            value = -100*turn
          else
            value = 100*value
        await @set board, value, ev.solved, 1
        board.undo turn, ev.move, flips
        unless ev.solved
          solved = null
        n += 1

      if max == -Infinity
        if outcome == null
          throw new Error 'no children in unfinished game'
        if outcome == 0
          value = -100*turn
        else
          value = outcome*100
      else
        value = max * turn

      await @set board, value, solved, n
