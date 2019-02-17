<template lang="pug">
.box(:class="error && 'error'")
  .text
    Spinner.spinner(v-if="spin")
    | {{ text }}
  .action(v-if="pass || back")
    Button(v-if="pass" theme="light" @click="pass") {{i18n.pass}}
    Button(v-if="back" theme="light" @click="back") {{i18n.play_again}}
</template>

<script lang="coffee">
import Spinner from './Spinner'
import Button from './Button'
import i18n from '../i18n'
export default
  props: ['text', 'pass', 'back', 'spin', 'error']
  data: -> { i18n }
  components: { Spinner, Button }
</script>

<style lang="stylus" scoped>
.box
  width 100%
  max-width 95vw
  border-radius 10px
  background #ccc
  color #333
  font-size 24px
  padding 20px
  box-shadow 0 5px 30px rgba(0, 0, 0, .5)
  &.error
    background #933
    color #ccc
.text
  display flex
  justify-content center
  align-items center
  .spinner
    margin-right 5px
.action
  margin-top 15px
  display flex
  justify-content center
  align-items center
  font-size 18px
</style>
