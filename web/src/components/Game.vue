<template lang="pug">
.screen
  header
    Button.back(@click="back" :border="false")
      ArrowLeftThick
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
import ArrowLeftThick from '@icons/ArrowLeftThick'
import Board from './Board'
import MessageBox from './MessageBox'
import Button from './Button'
import i18n from '../i18n'

export default
  props: ['user', 'level', 'guide', 'back']
  data: -> {
    msg: null
    msg_key: 0
    undo_enabled: false
    undo: ->
    i18n
  }
  computed:
    level_title: ->
      mode = i18n[@level]
      eval '`' + i18n.mode + '`'
  methods:
    show_message: (params) ->
      @msg_key++
      @msg = params
    set_undo_btn: (enabled, undo) ->
      @undo_enabled = enabled
      @undo = undo
  components: { ArrowLeftThick, Board, MessageBox, Button }
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

    .back
      font-size 20px
      padding 5px 10px

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
