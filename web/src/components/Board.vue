<template lang="pug">
  table
    tr(v-for='row in rows')
      td(
        v-for='{disc, can_move, is_hover, will_flip, move, enter, leave} in row'
        @mouseenter='enter'
        @mouseleave='leave'
        @click='move'
      )
        transition(name="flip" v-if="disc" mode='out-in' appear)
          Disc(color="black" :will_flip="will_flip" v-if="disc=='black'" key='black')
          Disc(color="white" :will_flip="will_flip" v-else key="white")
        .move(v-if='can_move && !hover_at')
        Disc(v-if="is_hover"
          :color='turn==BLACK ? "black" : "white"'
          class="hover"
        )
        
</template>

<script lang="coffee">
  import { Board, pos_from_xy, pos_to_str, BLACK, WHITE } from '@oth/board'
  import Disc from './Disc'
  import Player from '../player.worker'

  worker = new Player
  worker.postMessage type:'set_level', level:'hardest'

  export default
    data: ->
      board: new Board
      turn: BLACK
      user: WHITE
      flips: []
      hover_at: null
      BLACK: BLACK

    mounted: ->
      if @turn != @user
        @worker_move()

    updated: -> @$el.classList.add 'animate'

    computed:
      rows: ->
        for y in [0...8]
          row = []
          [0...8].forEach (x) =>
            pos = pos_from_xy x, y
            disc = @board.get(pos)

            row.push
              disc: if disc == BLACK
                      'black'
                    else if disc == WHITE
                      'white'
                    else
                      null
              can_move:
                if @turn == @user
                  @board.can_move(@turn, pos)
                else
                  false
              is_hover:
                if @turn == @user
                  @hover_at == pos and @board.can_move(@turn, pos)
                else
                  false
              will_flip: @flips.indexOf(pos) >= 0
              move: =>
                if @turn == @user
                  @move pos
              enter: =>
                if @turn == @user
                  @flips = @board.move(@turn, pos)
                  if @flips.length
                    @board.undo @turn, pos, @flips
                    @hover_at = pos
              leave: =>
                @hover_at = null
                @flips = []
          row

    methods:
      move: (pos) ->
        @flips = []
        @hover_at = null
        flips = @board.move @turn, pos
        return unless flips.length
        if @board.any_moves -@turn
          @turn = -@turn
        if @board.any_moves @turn
          if @turn != @user
            @worker_move()
        else
          console.log 'Game Over'
          outcome = @board.outcome(@user)
          if outcome > 0
            console.log 'You won by', outcome
          else if outcome < 0
            console.log 'You lost by', outcome
          else
            console.log 'Draw'

      worker_move: ->
        console.log 'Thinking...'
        worker.onmessage = (e) =>
          worker.onmessage = null
          {move, value} = e.data
          console.log 'Estimated value', value if value?
          @move move
        worker.postMessage type:'move', board:@board.dump(), turn:@turn

    components: { Disc }
</script>

<style lang="stylus" scoped>
  td
    background-color #444
    padding 0
    width 60px
    height 60px
    text-align center
    vertical-align: middle

  tr:nth-child(odd) td:nth-child(odd),
  tr:nth-child(even) td:nth-child(even)
    background-color #3e3e3e

  .move
    width 100%
    height 100%
    transition background-color .5s ease

  table:hover .move
    background-color: rgba(255, 255, 0, .1)

  svg.hover
    opacity .5
    cursor pointer

  .animate
    .flip-enter, .flip-leave-to
      transform scale(0)
      opacity 0

    .flip-enter-active
      transition all .2s cubic-bezier(.5, 0, .5, 1.5)
    .flip-leave-active
      transition all .1s ease
</style>
