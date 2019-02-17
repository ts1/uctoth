<template lang="pug">
  #app
    h1(v-if="mode=='setting'") UCTOTH
    Setting(v-if="mode=='setting'" :start="start")
    Game(v-if="mode=='game'" :user="color" :level="level" :guide="guide" :back="back")
    .link
      a(href="https://github.com/ts1/uctoth" target="_blank") Source code
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
    methods:
      start: (color, level, guide) ->
        @color = color
        @level = level
        @guide = guide
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
    font-feature-settings "palt"

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

  .link
    display flex
    justify-content center
    font-size 12px
    line-height 1
    margin-top 10px
    a
      color #ccc
      text-decoration none
      padding 15px
</style>
