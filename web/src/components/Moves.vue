<template lang="pug">
  div
    label {{ i18n.t.moves }}
    input(
      spellcheck="false"
      :value="moves"
      @keypress.enter="$emit('enter-moves', $event.target.value)"
      ref="input"
    )
</template>

<script lang="coffee">
  module.exports =
    props:
      moves: required: true
    data: ->
      i18n: require '../i18n'
    watch:
      moves: -> @$nextTick => @$refs.input.scrollLeft = 9999

</script>

<style lang="stylus" scoped>
  div
    width 100%
    max-width 95vw
    margin 0 auto
    padding-bottom 5px
    display flex
    align-items center
    label
      color #999
      margin-right 5px
    input
      flex-grow 1
      background rgba(0, 0, 0, .1)
      border none
      outline none
      box-shadow inset 1px 1px 5px rgba(0, 0, 0, .5)
      border-radius 4px
      color #999
      padding 5px 10px
      font-size 14px
      word-break keep-all
      &::-ms-clear
        display none
</style>
