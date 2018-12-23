path = require('path')

module.exports = {
  configureWebpack: {
    resolve: {
      alias: {
        '@oth': path.resolve(__dirname, '..'),
        '@icons': path.resolve(__dirname, 'node_modules/vue-material-design-icons')
      }
    },
    node: {
      readline: 'empty'
    },
    devServer: {
      disableHostCheck: true
    }
  },
  chainWebpack: config => {
    config.module
      .rule('worker')
      .test(/\.worker\.(js|coffee)$/)
      .use('worker-loader')
      .loader('worker-loader')
      .options({name: 'js/worker.[hash].js'})
  }
}

