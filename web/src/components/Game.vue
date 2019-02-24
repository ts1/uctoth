<template lang="pug">
.screen
  header
    .icons
      Button(@click="() => $emit('back')" :border="false")
        BackIcon
      Button(v-if="sound_supported" @click="mute" :border="false")
        SoundIcon(v-if="!muted")
        MuteIcon(v-if="muted")
    .level {{ level_title }}
    Button.undo(:disabled="!undo_enabled" @click="undo") {{ i18n.t.undo }}
  main
    Board.board(
      :user="user"
      :level="level"
      :guide="guide"
      :entered_moves="entered_moves"
      @message="show_message"
      @set-undo-btn="set_undo_btn"
      @add-move="add_move($event)"
      @undo="undo_move"
      @reset-moves="moves = ''"
      @back="$emit('back')"
    )
    Moves.moves(
      :moves="moves"
      @enter-moves="entered_moves = $event"
      v-if="show_moves"
    )
    .msg-box-wrapper
      transition(name='msg')
        MessageBox(v-bind="msg" :key="msg_key" v-if="msg" class="msg-box")
  .filler
</template>

<script lang="coffee">
import BackIcon from '@icons/ArrowLeftThick'
import SoundIcon from '@icons/VolumeHigh'
import MuteIcon from '@icons/VolumeOff'
import Board from './Board'
import MessageBox from './MessageBox'
import Button from './Button'
import Moves from './Moves'
import i18n from '../i18n'
import * as sound from '../sound.coffee'

export default
  props: ['user', 'level', 'guide', 'show_moves']
  data: -> {
    msg: null
    msg_key: 0
    undo_enabled: false
    undo: ->
    muted: sound.is_muted()
    sound_supported: sound.is_supported()
    moves: ''
    entered_moves: ''
    i18n
  }
  mounted: -> window.scrollTo 0, 0
  computed:
    level_title: ->
      mode = i18n.t[@level]
      i18n.expand('mode', {mode})
  methods:
    show_message: (params) ->
      @msg_key++
      @msg = params
    set_undo_btn: (e) ->
      @undo_enabled = e.enabled
      @undo = e.undo
    mute: ->
      @muted = not @muted
      sound.mute(@muted)
    add_move: (move) -> @moves += move
    undo_move: -> @moves = @moves.substr(0, @moves.length-2)

  components: {
    BackIcon
    SoundIcon
    MuteIcon
    Board
    MessageBox
    Button
    Moves
  }
</script>

<style lang="stylus" scoped>
  .screen
    width 100vw
    max-width: 480px
    display flex
    flex-direction column
    flex-grow 1

  header
    display flex
    justify-content space-between
    align-items center
    margin 5px 0

    .icons button
      font-size 20px
      line-height 20px
      padding 10px

    .undo
      font-size 14px
      margin-right 5px

  main
    display flex
    flex-direction column
    align-items center

  .board
    margin-bottom 10px

  .moves
    margin-bottom 10px

  .msg-box-wrapper
    position relative
    width: 100%
    display flex
    justify-content center

  .msg-box
    position absolute
    left 0
    right 0
    margin auto
    top 0

  .msg-enter
    transform translateY(80px)
    opacity 0
  .msg-leave-to
    transform translateY(-80px)
    opacity 0
  .msg-enter-active, .msg-leave-active
    transition all .7s cubic-bezier(.7,0,.3,1)

  .filler
    flex-grow 1
    min-height 100px
</style>
