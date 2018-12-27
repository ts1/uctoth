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
          Disc.disc(:color="disc" :will_flip="will_flip" :key="disc")
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
    props: ['user', 'level', 'guide', 'message', 'back', 'set_undo_btn']

    data: ->
      board: new Board
      turn: BLACK
      flips: []
      hover_at: null
      BLACK: BLACK
      undo_stack: []
      thinking: false
      user_moves: 0
      gameover: false

    mounted: ->
      worker.postMessage type:'set_level', level:@level
      if @turn == @user
        @message text:'Your turn.'
      else
        @worker_move()

    updated: -> @$el.classList.add 'animate'

    computed:
      can_undo: -> not @thinking and @user_moves and not @gameover

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
        @undo_stack.push [@turn, pos, flips]
        if @turn == @user
          @user_moves++
        @turn = -@turn
        if @board.any_moves @turn
          if @turn == @user
            @message text: 'Your turn.'
          else
            @worker_move()
        else
          @turn = -@turn
          if @board.any_moves(@turn)
            if @turn == @user
              @message text: 'I have no moves. Your turn.'
            else
              @message text: 'You have no moves.', pass: => @worker_move()
          else
            @gameover = true
            outcome = @board.outcome(@user)
            discs = "#{@board.count(@user)}:#{@board.count(-@user)}"
            if outcome > 0
              @message text: "You won by #{discs}!", back: @back
            else if outcome < 0
              @message text: "You lost by #{discs}!", back: @back
            else
              @message text: 'Draw!', back: @back

      worker_move: ->
        @message text:'Thinking...', spin: true
        t = Date.now()
        worker.onmessage = (e) =>
          worker.onmessage = null
          t = Date.now() - t
          console.log "#{t} msec"

          {move, value} = e.data
          console.log 'Estimated value', Math.round(100*value)/100 if value?
          setTimeout (=>
            @move move
            @thinking = false
          ), if t < 1000 then 1000 - t else 0
        @thinking = true
        worker.postMessage type:'move', board:@board.dump(), turn:@turn

      undo: ->
        throw new Error 'cannot undo' unless @can_undo
        loop
          [turn, pos, flips] = @undo_stack.pop()
          @board.undo turn, pos, flips
          break if turn == @user
        @user_moves--

        # BLACK MAGIC TO LET VUE UPDATE
        @board.board.push(0)
        @board.board.pop()

    watch:
      can_undo: -> @set_undo_btn(@can_undo, @undo)

    components: { Disc }
</script>

<style lang="stylus" scoped>
  .box
    display flex
    flex-direction column
  .row
    display flex
  .cell
    position relative
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
    position absolute
    top 0
    left 0
    width 100%
    height 100%

  .box:hover .move
    background-color: rgba(255, 255, 0, .1)
    animation flash 2s infinite

  @keyframes flash
    from
      opacity 0
    75%
      opacity 1
    to
      opacity 0

  svg.hover
    opacity .5
    cursor pointer

  .disc
    transform scale(1)
    transform-origin 50% 50%

  .animate
    .flip-enter, .flip-leave-to
      transform scale(0)
      opacity 0

    .flip-enter-active
      transition all .3s cubic-bezier(.0, 1, .7, 1.2)
    .flip-leave-active
      transition all .3s cubic-bezier(.7, 0, 1, .3)
</style>
