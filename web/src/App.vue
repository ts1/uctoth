<template lang="pug">
  #app
    Setting(v-if="mode=='setting'" :start="start")
    Game(v-if="mode=='game'" :user="color" :level="level" :guide="guide" :back="back")
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
  #app
    font-family -apple-system,BlinkMacSystemFont,Helvetica Neue,Segoe UI,sans-serif;
    font-size 16px
    line-height 1.5
    -webkit-font-smoothing antialiased
    -moz-osx-font-smoothing grayscale
    background #333
    min-height 100vh
    display flex
    align-items center
    justify-content center
    color #ccc
</style>
