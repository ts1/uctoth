<template lang="pug">
  #app
    h1(v-if="mode=='setting'") UCTOTH
    Setting(v-if="mode=='setting'" :start="start" class="setting")
    Game(
      v-if="mode=='game'"
      :user="color"
      :level="level"
      :guide="guide"
      :show_moves="moves"
      :back="back"
    )
    .link
      a(href="https://github.com/ts1/uctoth" target="_blank") Source code

    svg#svg-defs
      defs
        linearGradient#disc-black(x1="0" y1="0" x2="0" y2="1")
          stop(offset="0" stop-color="#181818")
          stop(offset="1" stop-color="#080808")
        linearGradient#disc-white(x1="0" y1="0" x2="0" y2="1")
          stop(offset="0" stop-color="#ddd")
          stop(offset="1" stop-color="#bbb")
</template>

<script lang="coffee">
  import 'sanitize.css'
  import Setting from './components/Setting'
  import Game from './components/Game'

  export default
    name: 'app'
    data: ->
      mode: 'setting'
      color: null
      level: null
      guide: null
      moves: null
    methods:
      start: (color, level, guide, moves) ->
        @color = color
        @level = level
        @guide = guide
        @moves = moves
        @mode = 'game'
      back: ->
        @mode = 'setting'
    components: {
      Setting
      Game
    }
</script>

<style lang="stylus">
  body
    background #333
    font-family Lato, 'Noto Sans JP', sans-serif;
    font-size 16px
    line-height 1.5
    -webkit-font-smoothing antialiased
    -moz-osx-font-smoothing grayscale

  #app
    min-height 100vh
    display flex
    align-items center
    justify-content space-between
    flex-direction column
    color #ccc
    user-select none

  h1
    font-weight lighter
    letter-spacing .35em
    font-family 'Lato', sans-serif

  .setting
    margin-bottom 10px

  .link
    display flex
    justify-content center
    font-size 12px
    line-height 1
    a
      color #ccc
      text-decoration none
      padding 15px

  #svg-defs
    height 0
</style>
