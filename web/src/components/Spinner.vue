<template lang="pug">
  svg.spinner(viewBox="0 0 100 100")
    circle(cx="50" cy="50" fill="none" stroke="currentColor" stroke-width="7" r="35" stroke-dasharray="200 20")
</template>

<style lang="stylus" scoped>
  @keyframes spin
    0%
      transform rotate(0deg)
    100%
      transform rotate(360deg)

  .spinner
    width 1em
    height 1em
    animation spin 0.5s linear 0s infinite
</style>

