try
  module.exports = require('./node-binding')
  module.exports.is_enabled = true
catch
  try
    module.exports = require('./wasm-glue')
  catch
    exports.is_enabled = false
