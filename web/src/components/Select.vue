<template lang="pug">
.select
  slot
</template>

<script lang="coffee">
export default
  props:
    value:
      required: true
  data: ->
    is_select: true
  methods:
    click: (value) ->
      @$emit 'input', value
</script>
