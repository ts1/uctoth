<template lang="pug">
.screen
  header
    button.back(@click="back")
      ArrowLeft
    .level {{ level_name }} mode
    button.undo(:disabled="!undo_enabled" @click="undo") Undo
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
import ArrowLeft from '@icons/ArrowLeft'
import Board from './Board'
import MessageBox from './MessageBox'

export default
  props: ['user', 'level', 'guide', 'back']
  data: ->
    msg: null
    msg_key: 0
    undo_enabled: false
    undo: ->
  methods:
    show_message: (params) ->
      @msg_key++
      @msg = params
    set_undo_btn: (enabled, undo) ->
      @undo_enabled = enabled
      @undo = undo
  computed:
    level_name: -> @level[0].toUpperCase() + @level.slice(1)
  components: { ArrowLeft, Board, MessageBox }
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
    button
      background: transparent
      color: #ccc
      outline: none
      transition all .2s
      border none
      padding 5px 10px
      border-radius 3px
      &:hover
        background rgba(255, 255, 255, .1)
        border-color #ccc
      &.back
        font-size 24px
      &.undo
        font-size 14px
        border 1px solid #ccc
        margin-right 5px
        &[disabled]
          opacity .5
          &:hover
            background inherit
            border-color inherit
    margin 5px 0

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

  .msg-enter
    transform translateY(80px)
    opacity 0
  .msg-leave-to
    transform translateY(-80px)
    opacity 0
  .msg-enter-active
    transition all .4s ease-in-out
  .msg-leave-active
    transition all .4s ease-in-out
</style>
