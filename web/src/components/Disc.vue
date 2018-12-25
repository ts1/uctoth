<template lang="pug">
  svg(viewBox="0 0 100 100", :class="will_flip ? 'gray' : color")
    circle(cx=50, cy=50, r=50)
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
  .black circle
    fill #111
  .white circle
    fill #ccc
  .gray circle
    fill #555
  circle
    transition fill .2s cubic-bezier(.7, 0, .3, 1)
</style>
