<template lang="pug">
.box
  .text {{ text }}
  .action(v-if="pass || back")
    button(v-if="pass" @click="pass") Pass
    button(v-if="back" @click="back") Play again
</template>

<script lang="coffee">
export default
  props: ['text', 'pass', 'back']
</script>

<style lang="stylus" scoped>
.box
  width 480px
  max-width 90vw
  border-radius 10px
  background #ccc
  color #333
  font-size 32px
  padding 20px
.text
  display flex
  justify-content center
  align-items center
.action
  margin-top 20px
  display flex
  justify-content center
  align-items center
  button
    border 1px solid #000
    padding 10px 20px
    background-color #333
    color #ccc
    border-radius 5px
    font-size 24px
    cursor pointer
    outline none
    transition all .2s
    &:hover
      background-color #000
</style>
