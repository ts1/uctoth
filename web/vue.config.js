module.exports = {
  configureWebpack: {
    resolve: {
      alias: {
        '@oth': __dirname + '/..',
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

