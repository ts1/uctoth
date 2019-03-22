<template lang="pug">
  #app(
    @touchstart="in_touch = true"
    @touchend="in_touch = false"
    @touchcancel="in_touch = false"
    :class="in_touch && 'in-touch'"
  )
    h1(v-show="mode=='setting'") UCTOTH
    Setting.setting(v-show="mode=='setting'" @start="start")
    Game(v-if="mode=='game'" v-bind="prefs" @back="back")
    .link
      a(href="https://github.com/ts1/uctoth" target="_blank")
        GithubIcon.icon
        | Source code
</template>

<script lang="coffee">
  import 'sanitize.css'
  import '@icons/styles.css'
  import './no_bounce'
  import Setting from './components/Setting'
  import Game from './components/Game'
  import GithubIcon from '@icons/GithubCircle'

  update_win_height = ->
    height = document.documentElement.clientHeight
    document.documentElement.style.setProperty '--win-height', "#{height}px"

  export default
    name: 'app'
    data: ->
      mode: 'setting'
      in_touch: true
      prefs: {}
    methods:
      start: (prefs) ->
        @prefs = prefs
        @mode = 'game'
      back: ->
        @mode = 'setting'
    components: {
      Setting
      Game
      GithubIcon
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
    -webkit-tap-highlight-color transparent

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
      .icon
        font-size 16px
        margin-right 5px
        vertical-align -1px

  p.intro
    max-height 0
    overflow hidden
    margin 0

  #svg-defs
    height 0
    position absolute
</style>
