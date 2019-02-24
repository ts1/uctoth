<template lang="pug">
.box
  .colors
    Button.color(:selected="color==BLACK" @click="color = BLACK")
      Disc(color="black")
      span {{ i18n.t.first_move }}
    Button.color(:selected="color==WHITE" @click="color = WHITE")
      Disc(color="white")
      span {{ i18n.t.second_move}}

  .levels
    Button.level(
      v-for="l in levels"
      :selected="level==l.toLowerCase()"
      @click="level = l.toLowerCase()"
    )
      | {{ i18n.t[l] }}

  Button.guide(:checked="guide" @click="guide = !guide")
    | {{ i18n.t.show_guide }}

  Button.moves(:checked="moves" @click="moves = !moves")
    | {{ i18n.t.show_moves }}

  .langs
    Button.lang(
      :selected="i18n.lang=='en'"
      @click="i18n.set('en')"
    )
      | English
    Button.lang(
      :selected="i18n.lang=='ja'"
      @click="i18n.set('ja')"
    )
      | 日本語
  
  Button(@click="submit") {{ i18n.t.start }}
</template>

<script lang="coffee">
import { BLACK, WHITE } from '@oth/board'
import Disc from './Disc'
import '@icons/styles.css'
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
  components: { Disc, Button }
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
  display flex
  flex-direction column

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

.moves
  margin-bottom 25px
</style>
