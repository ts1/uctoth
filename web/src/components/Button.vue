<template lang="pug">
  button(:class="className" @click="$emit('click')")
    span.content
      span.check(v-if="checked != null")
        CheckboxMarked(v-show="checked")
        CheckboxBlankOutline(v-show="checked==false")
      slot
</template>

<script lang="coffee">
  import CheckboxMarked from '@icons/CheckboxMarked'
  import CheckboxBlankOutline from '@icons/CheckboxBlankOutline'
  import CheckboxIntermediate from '@icons/CheckboxIntermediate'
  export default
    props: ['theme', 'border', 'selected', 'checked']
    computed:
      className: -> [
        @theme or 'dark'
        (@border ? true and not @checked? and @selected != false) and 'border'
        @checked? and 'left'
        @selected and 'selected'
      ]
    components: {
      CheckboxMarked
      CheckboxBlankOutline
      CheckboxIntermediate
    }
</script>

<style lang="stylus" scoped>
  button
    background-color transparent
    transition all .2s
    cursor pointer
    padding .25em 1em
    border-radius 3px
    outline none
    border 1px solid transparent

    &.light
      &.border
        border-color #333
      color #333
      &:active:not([disabled])
        background-color rgba(0, 0, 0, .15)
        color #000
        &.border
          border-color #000

    &.dark
      &.border
        border-color #ccc
      color #ccc
      &:active:not([disabled])
        background-color rgba(255, 255, 255, .15)
        color #fff
        &.border
          border-color #fff

    &[disabled]
      cursor not-allowed
      opacity .3

    &.left
      text-align left

    .content
      position relative // Fix for IE

    .check
      margin-right 5px

  .in-touch
    button:hover:not(:active):not([disabled])
      &.light
        background-color rgba(0, 0, 0, .075)
      &.dark
        background-color rgba(255, 255, 255, .075)

  .selected
    pointer-events none
</style>
