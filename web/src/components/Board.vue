<template lang="pug">
  .box
    .row(v-for='row in rows')
      .cell(
        v-for='{disc, can_move, is_hover, will_flip, move, enter, leave} in row'
        @mouseenter='enter'
        @mouseleave='leave'
        @click='move'
      )
        transition(name="flip" v-if="disc" mode='out-in' appear)
          Disc(color="black" :will_flip="will_flip" v-if="disc=='black'" key='black')
          Disc(color="white" :will_flip="will_flip" v-else key="white")
        .move(v-if='guide && can_move && !hover_at')
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

  export default
    props: ['user', 'level', 'guide', 'message', 'back']

    data: ->
      board: new Board
      turn: BLACK
      flips: []
      hover_at: null
      BLACK: BLACK

    mounted: ->
      worker.postMessage type:'set_level', level:@level
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
        else if -@turn == @user and @board.any_moves(@turn)
          @message text: 'You have no moves', pass: => @worker_move()
          return
        if @board.any_moves @turn
          if @turn == @user
            @message text: 'Your turn'
            @$forceUpdate()
          else
            @worker_move()
        else
          outcome = @board.outcome(@user)
          discs = "#{@board.count(@user)}:#{@board.count(-@user)}"
          if outcome > 0
            @message text: "You won by #{discs}!", back: @back
          else if outcome < 0
            @message text: "You lost by #{discs}", back: @back
          else
            @message text: 'Draw', back: @back

      worker_move: ->
        @message text:'Thinking...'
        worker.onmessage = (e) =>
          worker.onmessage = null
          {move, value} = e.data
          console.log 'Estimated value', value if value?
          @move move
        worker.postMessage type:'move', board:@board.dump(), turn:@turn

    components: { Disc }
</script>

<style lang="stylus" scoped>
  .box
    display flex
    flex-direction column
  .row
    display flex
  .cell
    display flex
    background-color #444
    width 60px
    height 60px
    max-width (100/8)vw
    max-height (100/8)vw
    justify-content center
    align-items center

  .row:nth-child(odd) .cell:nth-child(odd),
  .row:nth-child(even) .cell:nth-child(even)
    background-color #3e3e3e

  .move
    width 100%
    height 100%
    transition background-color .5s ease

  .box:hover .move
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
