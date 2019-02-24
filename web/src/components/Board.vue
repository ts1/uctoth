<template lang="pug">
  .box
    .label-row
      .label(v-for="label in 'ABCDEFGH'.split('')") {{ label }}
    .row(v-for='(row, i) in rows')
      .label {{ i+1 }}
      .cell(
        v-for='{disc, can_move, is_hover, will_flip, move, enter, leave} in row'
        @mouseenter='enter'
        @mouseleave='leave'
        @click='move'
      )
        transition(name="flip" v-if="disc" mode='out-in' appear)
          Disc.disc(:color="disc" :will_flip="will_flip" :key="disc")
        .guide(v-if='guide && can_move && !hover_at')
        Disc(v-if="is_hover"
          :color='turn==BLACK ? "black" : "white"'
          class="hover"
        )
      .label {{ i+1 }}
    .label-row
      .label(v-for="label in 'ABCDEFGH'.split('')") {{ label }}
        
</template>

<script lang="coffee">
  import {
    Board
    pos_from_xy
    pos_to_str
    pos_from_str
    pos_array_from_str
    BLACK
    WHITE
  } from '@oth/board'
  import Disc from './Disc'
  import Player from '../player.worker'
  import i18n from '../i18n'
  import sound from '../sound'

  worker = new Player

  export default
    props: ['user', 'level', 'guide', 'message', 'back', 'set_undo_btn',
      'entered_moves']

    data: -> {
      board: new Board
      turn: BLACK
      flips: []
      hover_at: null
      undo_stack: []
      thinking: false
      user_moves: 0
      gameover: false
      will_flip_enabled: false
      keys: []
      BLACK
      i18n
    }

    mounted: ->
      worker.postMessage type:'set_level', level:@level
      @proceed()
      gtag 'event', 'start',
        event_category: 'game'
        event_label: @level

      @key_listener = (e) => @keypress(e)
      window.addEventListener 'keypress', @key_listener

    beforeDestroy: ->
      window.removeEventListener 'keypress', @key_listener

    updated: -> @$el.classList.add 'animate'

    computed:
      can_undo: -> not @thinking and @user_moves and not @gameover

      rows: ->
        rows = for y in [0...8]
          row = []
          [0...8].forEach (x) =>
            pos = pos_from_xy x, y
            disc = @board.get(pos)

            row.push
              pos: pos
              disc:
                if disc == BLACK
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
              will_flip: @will_flip_enabled and @flips.indexOf(pos) >= 0
              move: =>
                if @turn == @user
                  @move pos
              enter: =>
                if @turn == @user
                  @flips = @board.move(@turn, pos)
                  if @flips.length
                    @board.undo @turn, pos, @flips
                    @hover_at = pos
                  @will_flip_enabled = false
              leave: =>
                @hover_at = null
                @flips = []
                @will_flip_enabled = false
          row

        setTimeout (=> @will_flip_enabled = true), 50 # XXX

        rows

    methods:
      move: (pos, move_only=false) ->
        @flips = []
        @hover_at = null
        flips = @board.move @turn, pos
        return false unless flips.length
        sound 'move' unless move_only
        @$emit 'add-move', pos_to_str(pos, @turn)
        @undo_stack.push [@turn, pos, flips]
        if @turn == @user
          @user_moves++
        @turn = -@turn
        unless move_only
          @proceed()
        true

      proceed: ->
        if @board.any_moves @turn
          if @turn == @user
            @message text:  @i18n.t.your_turn
          else
            @worker_move()
        else
          @turn = -@turn
          if @board.any_moves(@turn)
            if @turn == @user
              @message text: @i18n.t.i_pass
            else
              @message text: @i18n.t.you_pass, pass: => @worker_move()
          else
            @gameover = true
            outcome = @board.outcome(@user)
            discs = "#{@board.count(@user)}:#{@board.count(-@user)}"
            if outcome > 0
              @message text: i18n.expand('win', {discs}), back: @back
              gtag 'event', 'win',
                event_category: 'game'
                event_label: @level
                value: outcome
            else if outcome < 0
              @message text: i18n.expand('lose', {discs}), back: @back
              gtag 'event', 'lose',
                event_category: 'game'
                event_label: @level
                value: outcome
            else
              @message text: @i18n.t.draw, back: @back
              gtag 'event', 'draw',
                event_category: 'game'
                event_label: @level
                value: outcome

      worker_move: ->
        @message text: @i18n.t.thinking, spin: true
        t = Date.now()
        worker.onmessage = (e) =>
          worker.onmessage = null
          t = Date.now() - t
          console.log "#{t} msec"

          {move, value} = e.data
          console.log 'Move', pos_to_str(move)
          console.log 'Estimated value', Math.round(100*value)/100 if value?
          setTimeout (=>
            @move move
            @thinking = false
          ), if t < 2000 then 2000 - t else 0
        @thinking = true
        worker.postMessage type:'move', board:@board.dump(), turn:@turn

      undo: ->
        throw new Error 'cannot undo' unless @can_undo
        loop
          [turn, pos, flips] = @undo_stack.pop()
          @board.undo turn, pos, flips
          @$emit 'undo'
          break if turn == @user
        @user_moves--
        if @turn != @user
          @turn = @user
          @message text:  @i18n.t.your_turn

        sound 'undo'

        # BLACK MAGIC TO LET VUE UPDATE
        @board.board.push(0)
        @board.board.pop()

      keypress: (e) ->
        return if e.target.nodeName == 'INPUT'

        if e.key == 'u'
          if @can_undo
            @undo()
          else
            sound 'alert'
          return

        @keys.push(e.key)
        @keys = @keys.slice(-2)
        str = @keys.join('')
        try
          move = pos_from_str(str)
        catch
          move = 0

        if move
          if @turn==@user and @board.can_move(@user, move)
            @move move
          else
            sound 'alert'

    watch:
      can_undo: -> @set_undo_btn(@can_undo, @undo)

      entered_moves: ->
        @undo_stack = []
        @user_moves = 0
        @$emit 'reset-moves'
        @board = new Board
        success = true
        @turn = BLACK
        @gameover = false

        for move in pos_array_from_str(@entered_moves)
          unless @move move, true
            success = false
            break
          @turn = -@turn unless @board.any_moves(@turn)

        if success
          @proceed()
        else
          @message text: @i18n.t.invalid_moves, error: true
          sound 'alert'
          setTimeout (=> @proceed()), 2000

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

  .guide
    position absolute
    top 0
    left 0
    width 100%
    height 100%

  .in-touch .box:hover .guide,
  #app:not(.in-touch) .guide
    background-image: radial-gradient(
      closest-side,
      rgba(255, 255, 0, .15) 0%,
      rgba(255, 255, 0, .15) 50%,
      transparent 100%
    )
    animation flash 2s infinite

  @keyframes flash
    from
      opacity 0
    75%
      opacity 1
    to
      opacity 0

  .hover
    opacity .4
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

  .label-row
    display flex
    justify-content center
    &:first-child
      margin-bottom 5px
    &:last-child
      margin-top 5px
    .label
      width 60px
      height 15px

  .row
    .label
      display flex
      justify-content center
      align-items center
      width 15px
      height 60px
      margin 0 5px
  .label
    color #666
    font-size 12px
    line-height 15px
    text-align center

  @media screen and (max-width: 600px)
    .label-row
      display none
    .row, .label-row
      .label
        display none
</style>
