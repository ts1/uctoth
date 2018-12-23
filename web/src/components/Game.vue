<template lang="pug">
.screen
  header
    button(@click="back")
      ArrowLeft
  main
    Board(:user="user" :level="level" :guide="guide" :message="show_message" :back="back" class="board")
    transition(name='slide' mode="out-in")
      MessageBox(:text="msg.text" :pass="msg.pass" :back="msg.back" :key="msg_key" v-if="msg")
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
  methods:
    show_message: (params) ->
      @msg_key++
      @msg = params
  components: { ArrowLeft, Board, MessageBox }
</script>

<style lang="stylus" scoped>
  .screen
    width 100vw
    height 100vh
    display flex
    flex-direction column
  header
    display flex
    button
      background: transparent
      color: #ccc
      outline: none
      transition all .2s
      border none
      &:hover
        background rgba(255, 255, 255, .1)
      font-size 24px
      padding 5px
    margin-bottom 20px
  main
    display flex
    flex-direction column
    align-items center
  .board
    margin-bottom 20px

  .slide-enter
    transform translateY(30px)
    opacity 0
  .slide-leave-to
    opacity 0
  .slide-enter-active
    transition all .5s ease-out
  .slide-leave-active
    transition all .2s ease
    
    
</style>
