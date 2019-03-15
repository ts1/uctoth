LOG_MULT = 5000
to_probability = (value) -> 1 / (1 + Math.exp(-value / LOG_MULT))

module.exports = {
  LOG_MULT
  to_probability
}
