<template lang="pug">
.box
  .colors
    .color.select(:class="color==BLACK && 'is-active'" @click="color = BLACK")
      Disc(color="black")
      span {{ i18n.t.first_move }}
    .color.select(:class="color==WHITE && 'is-active'" @click="color = WHITE")
      Disc(color="white")
      span {{ i18n.t.second_move}}

  .levels
    .level.select(
      v-for="l in levels"
      :class="level==l.toLowerCase() && 'is-active'"
      @click="level = l.toLowerCase()"
    ) {{ i18n.t[l] }}

  .guide.checkbox.select(@click="guide = !guide")
    CheckboxMarked(v-if="guide")
    CheckboxBlankOutline(v-if="!guide")
    span.label {{ i18n.t.show_guide }}

  .moves.checkbox.select(@click="moves = !moves")
    CheckboxMarked(v-if="moves")
    CheckboxBlankOutline(v-if="!moves")
    span.label {{ i18n.t.show_moves }}

  .langs
    a.lang.select(
      href="en.html"
      :class="i18n.lang=='en' && 'is-active'"
      @click.prevent="i18n.set('en')"
    )
      | English
    a.lang.select(
      href="ja.html"
      :class="i18n.lang=='ja' && 'is-active'"
      @click.prevent="i18n.set('ja')"
    )
      | 日本語
  
  Button(@click="submit") {{ i18n.t.start }}
</template>

<script lang="coffee">
import { BLACK, WHITE } from '@oth/board'
import Disc from './Disc'
import '@icons/styles.css'
import CheckboxMarked from '@icons/CheckboxMarked'
import CheckboxBlankOutline from '@icons/CheckboxBlankOutline'
import Button from './Button'
import i18n from '../i18n'
import { get_pref, set_pref } from '../prefs'

export default
  props: ['start']
  data: -> {
    levels: ['easiest', 'easy', 'normal', 'hard', 'hardest']
    color: get_pref('color', BLACK)
    level: get_pref('level', 'normal')
    guide: get_pref('guide', true)
    moves: get_pref('moves', false)
    BLACK
    WHITE
    i18n
  }
  methods:
    submit: ->
      set_pref 'color', @color
      set_pref 'level', @level
      set_pref 'guide', @guide
      set_pref 'moves', @moves
      @start @color, @level, @guide, @moves
  components: { Disc, CheckboxMarked, CheckboxBlankOutline, Button }
</script>

<style lang="stylus" scoped>
.box
  display flex
  flex-direction column

.colors
  display flex
  justify-content space-around
  .color
    flex-grow 1
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

.langs
  display flex
  justify-content space-around
  margin-bottom 20px
  .lang
    text-decoration none
    color #ccc
    padding 5px 10px
    flex-grow 1
    text-align center

.select
  border 1px solid transparent
  border-radius 3px
  cursor pointer
  transition all .2s ease-in-out
  &:hover
    background rgba(255, 255, 255, 0.1)
    color #fff
  &:active
    background none
    &:not(.checkbox)
      border-color #fff


.is-active
  border-color #ccc

.checkbox
  padding 5px
  .label
    margin-left 5px
.moves
  margin-bottom 25px
</style>
