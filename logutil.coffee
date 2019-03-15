LOG_MULT = 3000
to_probability = (value) -> 1 / (1 + Math.exp(-value / LOG_MULT))

module.exports = {
  LOG_MULT
  to_probability
}
