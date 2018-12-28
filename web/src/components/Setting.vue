<template lang="pug">
.box
  .colors
    .color.select(:class="color==BLACK && 'is-active'" @click="color = BLACK")
      Disc(color="black")
      span {{ i18n.first_move }}
    .color.select(:class="color==WHITE && 'is-active'" @click="color = WHITE")
      Disc(color="white")
      span {{ i18n.second_move}}

  .levels
    .level.select(
      v-for="l in levels"
      :class="level==l.toLowerCase() && 'is-active'"
      @click="level = l.toLowerCase()"
    ) {{ i18n[l] }}

  .guide.select(@click="guide = !guide")
    CheckboxMarked(v-if="guide")
    CheckboxBlankOutline(v-if="!guide")
    span.label {{ i18n.show_guide }}

  .langs
    a.lang.select(href="?lang=en" :class="i18n.lang=='en' && 'is-active'")
      | English
    a.lang.select(href="?lang=ja" :class="i18n.lang=='ja' && 'is-active'")
      | 日本語
  
  Button(@click="submit") {{ i18n.start }}
</template>

<script lang="coffee">
import { BLACK, WHITE } from '@oth/board'
import Disc from './Disc'
import '@icons/styles.css'
import CheckboxMarked from '@icons/CheckboxMarked'
import CheckboxBlankOutline from '@icons/CheckboxBlankOutline'
import Button from './Button'
import i18n from '../i18n'

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
  data: -> {
    levels: ['easiest', 'easy', 'normal', 'hard', 'hardest']
    color: get_pref('color', BLACK)
    level: get_pref('level', 'normal')
    guide: get_pref('guide', true)
    BLACK
    WHITE
    i18n
  }
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
  justify-content space-around
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

.langs
  display flex
  justify-content space-around
  margin-bottom 20px
  .lang
    text-decoration none
    color #ccc
    padding 5px 10px

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
