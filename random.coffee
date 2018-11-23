{ int } = require './util'
module.exports = (board, me) ->
  moves = board.list_moves(me)
  moves[int(Math.random() * moves.length)]
