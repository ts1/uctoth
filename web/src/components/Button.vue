<template lang="pug">
  button(:class="className" @click="$emit('click')")
    slot
</template>

<script lang="coffee">
export default
  props: ['theme', 'border']
  computed:
    className: -> [
      @theme or 'dark'
      if @border ? true then 'border' else null
    ]
</script>

<style lang="stylus" scoped>
  button
    background-color transparent
    transition all .2s
    cursor pointer
    padding .25em 1em
    border-radius 3px
    outline none

    &.border
      border 1px solid

    &:not(.border)
      border none

    &.light
      border-color #333
      color #333
      &:hover
        background-color rgba(0, 0, 0, .1)
        border-color #000
        color #000
      &:active
        background-color transparent

    &.dark
      border-color #ccc
      color #ccc
      &:hover
        background-color rgba(255, 255, 255, .1)
        border-color #fff
        color #fff
      &:active
        background-color transparent

    &[disabled]
      cursor not-allowed
      opacity .3
      &:hover
        background-color transparent
</style>
