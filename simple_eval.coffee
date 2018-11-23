{ pos_from_str } = require './board'

CORNERS = ['A1', 'A8', 'H1', 'H8'].map(pos_from_str)

module.exports = (board, me) ->
  mobility = board.list_moves_but_x(me).length -
             board.list_moves_but_x(-me).length
  corner = me * CORNERS.reduce(((sum, pos) -> sum + board.get(pos)), 0)
  mobility + 10*corner
