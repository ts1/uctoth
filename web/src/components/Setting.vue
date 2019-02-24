<template lang="pug">
.box
  Select.colors(v-model:value="prefs.user")
    SelectItem.color(:value="BLACK")
      Disc(color="black")
      span {{ i18n.t.first_move }}
    SelectItem.color(:value="WHITE")
      Disc(color="white")
      span {{ i18n.t.second_move}}

  Select.levels(v-model:value="prefs.level")
    SelectItem.level(
      v-for="l in levels"
      :key="l"
      :value="l"
    )
      | {{ i18n.t[l] }}

  Button.guide(:checked="prefs.guide" @click="prefs.guide = !prefs.guide")
    | {{ i18n.t.show_guide }}

  Button.moves(
    :checked="prefs.show_moves"
    @click="prefs.show_moves = !prefs.show_moves"
  )
    | {{ i18n.t.show_moves }}

  Select.langs(:value="i18n.lang" @input="(val) => i18n.set(val)")
    SelectItem.lang(value="en") English
    SelectItem.lang(value="ja") 日本語
  
  Button(@click="submit") {{ i18n.t.start }}
</template>

<script lang="coffee">
import { BLACK, WHITE } from '@oth/board'
import Disc from './Disc'
import Button from './Button'
import Select from './Select'
import SelectItem from './SelectItem'
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
  components: { Disc, Button, Select, SelectItem }
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
