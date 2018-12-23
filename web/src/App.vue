<template lang="pug">
  #app
    Board
</template>

<script lang="coffee">
  import 'sanitize.css'
  import Board from './components/Board'

  export default
    name: 'app'
    components: {
      Board
    }
</script>
<style lang="stylus">
  #app
    font-family sans-serif
    -webkit-font-smoothing antialiased
    -moz-osx-font-smoothing grayscale
    background #333
    min-height 100vh
    display flex
    align-items center
    justify-content center
</style>
