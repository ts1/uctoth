<template lang="pug">
.box
  .colors
    Button.color(:selected="prefs.user==BLACK" @click="prefs.user = BLACK")
      Disc(color="black")
      span {{ i18n.t.first_move }}
    Button.color(:selected="prefs.user==WHITE" @click="prefs.user = WHITE")
      Disc(color="white")
      span {{ i18n.t.second_move}}

  .levels
    Button.level(
      v-for="l in levels"
      :selected="prefs.level==l.toLowerCase()"
      @click="prefs.level = l.toLowerCase()"
    )
      | {{ i18n.t[l] }}

  Button.guide(:checked="prefs.guide" @click="prefs.guide = !prefs.guide")
    | {{ i18n.t.show_guide }}

  Button.moves(
    :checked="prefs.show_moves"
    @click="prefs.show_moves = !prefs.show_moves"
  )
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
import Button from './Button'
import i18n from '../i18n'
import { get_prefs, set_prefs } from '../prefs'

defaults =
  user: BLACK
  level: 'normal'
  guide: true
  show_moves: false

export default
  data: -> {
    levels: ['easiest', 'easy', 'normal', 'hard', 'hardest']
    prefs: {defaults..., get_prefs()...}
    BLACK
    WHITE
    i18n
  }
  methods:
    submit: ->
      set_prefs @prefs
      {user, level, guide, show_moves} = @prefs
      @$emit 'start', {user, level, guide, show_moves}
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
