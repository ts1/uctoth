<template lang="pug">
.screen
  header
    .icons
      Button(@click="back" :border="false")
        BackIcon
      Button(v-if="sound_supported" @click="mute" :border="false")
        SoundIcon(v-if="!muted")
        MuteIcon(v-if="muted")
    .level {{ level_title }}
    Button.undo(:disabled="!undo_enabled" @click="undo") {{ i18n.undo }}
  main
    Board.board(
      :user="user"
      :level="level"
      :guide="guide"
      :message="show_message"
      :back="back"
      :set_undo_btn="set_undo_btn"
    )
    .msg-box-wrapper
      transition(name='msg')
        MessageBox(v-bind="msg" :key="msg_key" v-if="msg" class="msg-box")
</template>

<script lang="coffee">
import BackIcon from '@icons/ArrowLeftThick'
import SoundIcon from '@icons/VolumeHigh'
import MuteIcon from '@icons/VolumeOff'
import Board from './Board'
import MessageBox from './MessageBox'
import Button from './Button'
import i18n from '../i18n'
import * as sound from '../sound.coffee'

export default
  props: ['user', 'level', 'guide', 'back']
  data: -> {
    msg: null
    msg_key: 0
    undo_enabled: false
    undo: ->
    muted: sound.is_muted()
    sound_supported: sound.is_supported()
    i18n
  }
  mounted: -> window.scrollTo 0, 0
  computed:
    level_title: ->
      mode = i18n[@level]
      i18n.expand('mode', {mode})
  methods:
    show_message: (params) ->
      @msg_key++
      @msg = params
    set_undo_btn: (enabled, undo) ->
      @undo_enabled = enabled
      @undo = undo
    mute: ->
      @muted = not @muted
      sound.mute(@muted)
  components: { BackIcon, SoundIcon, MuteIcon, Board, MessageBox, Button }
</script>

<style lang="stylus" scoped>
  .screen
    width 100vw
    height 100vh
    max-width: 480px
    display flex
    flex-direction column

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
    margin-bottom 20px

  .msg-box-wrapper
    position relative
    width: 100%
    display flex
    justify-content center

  .msg-box
    position absolute
    left: 0
    top: 0

  .msg-enter
    transform translateY(80px)
    opacity 0
  .msg-leave-to
    transform translateY(-80px)
    opacity 0
  .msg-enter-active, .msg-leave-active
    transition all .7s cubic-bezier(.7,0,.3,1)
</style>
