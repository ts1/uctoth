<template lang="pug">
  Button(@click="select.click(value)" :selected="select ? value==select.value : false")
    slot
</template>

<script lang="coffee">
import Button from './Button'
export default
  props:
    value:
      required: true
  data: ->
    select: null
  mounted: ->
    parent = @$parent
    while parent
      if parent.is_select
        break
      parent = parent.parent
    throw new Error 'Parent Select not found' unless parent
    @select = parent
  components: { Button }
</script>
