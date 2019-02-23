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
</template>

<script lang="coffee">
  import 'sanitize.css'
  import Setting from './components/Setting'
  import Game from './components/Game'

  update_win_height = ->
    height = document.documentElement.clientHeight
    document.documentElement.style.setProperty '--win-height', "#{height}px"

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
    mounted: ->
      if document.documentElement?.style?.setProperty?
        window.addEventListener 'resize', update_win_height, passive: true
        @$nextTick update_win_height
    beforeDestroy:
      window.removeEventListener 'resize', update_win_height
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
    min-height 100vh // For IE
    min-height var(--win-height, 100vh) // Set by JS
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

  p.intro
    max-height 0
    overflow hidden
    margin 0

  #svg-defs
    height 0
    position absolute
</style>
