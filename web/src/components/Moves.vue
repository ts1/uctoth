<template lang="pug">
  div
    label {{ i18n.moves }}
    input(
      spellcheck="false"
      :value="moves"
      @input="moves_ = $event.target.value"
      @keypress.enter="$emit('enter-moves', moves_)"
    )
</template>

<script lang="coffee">
  module.exports =
    props:
      moves: required: true
    data: ->
      moves_: ''
      i18n: require '../i18n'

</script>

<style lang="stylus" scoped>
  div
    width 100%
    max-width 95vw
    margin 0 auto
    display flex
    align-items center
    label
      margin-right 5px
    input
      flex-grow 1
      background rgba(0, 0, 0, .1)
      border none
      outline none
      box-shadow inset 1px 1px 5px rgba(0, 0, 0, .5)
      border-radius 4px
      color #ccc
      padding 10px
      font-size 14px
</style>
