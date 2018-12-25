<template lang="pug">
.box
  .colors
    .color.select(:class="color==BLACK && 'is-active'" @click="color = BLACK")
      Disc(color="black")
      span First move
    .color.select(:class="color==WHITE && 'is-active'" @click="color = WHITE")
      Disc(color="white")
      span Second move

  .levels
    .level.select(
      v-for="l in levels"
      :class="level==l.toLowerCase() && 'is-active'"
      @click="level = l.toLowerCase()"
    ) {{ l }}

  .guide.select(@click="guide = !guide")
    CheckboxMarked(v-if="guide")
    CheckboxBlankOutline(v-if="!guide")
    span.label Show guide
  
  Button(@click="submit") Start
</template>

<script lang="coffee">
import { BLACK, WHITE } from '@oth/board'
import Disc from './Disc'
import '@icons/styles.css'
import CheckboxMarked from '@icons/CheckboxMarked'
import CheckboxBlankOutline from '@icons/CheckboxBlankOutline'
import Button from './Button'

set_pref = (key, value) ->
  localStorage['_oth_'+key] = JSON.stringify(value)

get_pref = (key, fallback) ->
  value = localStorage['_oth_'+key]
  if value?
    JSON.parse(value)
  else
    fallback

export default
  props: ['start']
  data: ->
    levels: ['Easiest', 'Easy', 'Normal', 'Hard', 'Hardest']
    color: get_pref('color', BLACK)
    level: get_pref('level', 'normal')
    guide: get_pref('guide', true)
    BLACK: BLACK
    WHITE: WHITE
  methods:
    submit: ->
      set_pref 'color', @color
      set_pref 'level', @level
      set_pref 'guide', @guide
      @start @color, @level, @guide
  components: { Disc, CheckboxMarked, CheckboxBlankOutline, Button }
</script>

<style lang="stylus" scoped>
.box
  display flex
  flex-direction column

.colors
  display flex
  .color
    display flex
    flex-direction column
    align-items center
    padding 10px
    span
      margin-top 5px
  margin-bottom 25px

.level
  padding 5px 10px

.levels
  margin-bottom 20px

.select
  border 1px solid transparent
  border-radius 3px
  cursor pointer
  transition all .2s ease-in-out
  &:hover
    background rgba(255, 255, 255, 0.1)

.is-active
  border-color #ccc

.guide
  padding 5px
  .label
    margin-left 5px
  margin-bottom 25px
</style>
