<template lang="pug">
.box
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
  props: ['text', 'pass', 'back', 'spin']
  data: -> { i18n }
  components: { Spinner, Button }
</script>

<style lang="stylus" scoped>
.box
  width 480px
  max-width 100vw
  border-radius 10px
  background #ccc
  color #333
  font-size 24px
  padding 20px
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
