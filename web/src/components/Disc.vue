<template lang="pug">
  .wrapper(:class="[will_flip && 'flip', color]")
    svg(viewBox="0 0 100 100" fill="currentColor")
      circle(cx=50 cy=50 r=50)
</template>

<script lang="coffee">
  export default
    props: [ 'color', 'will_flip' ]
</script>

<style lang="stylus" scoped>
  svg
    width 50px
    height 50px
    max-width (100/8/60*50)vw
    max-height (100/8/60*50)vw

  .black
    color #111
    &.flip
      animation-name flip-black

  .white
    color #ccc
    &.flip
      animation-name flip-white

  @keyframes flip-black
    from
      color #111
    to
      color #555

  @keyframes flip-white
    from
      color #ccc
    to
      color #555

  .wrapper
    transition color .2s cubic-bezier(.7, 0, .3, 1)
    animation-duration .5s
    animation-iteration-count infinite
    animation-direction alternate
    animation-timing-function cubic-bezier(.7, 0, .3, 1)
</style>
