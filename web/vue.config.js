path = require('path')

module.exports = {
  publicPath: '/uctoth/',
  outputDir: path.resolve(__dirname, '..', 'docs'),
  configureWebpack: {
    resolve: {
      extensions: [ '.coffee' ],
      alias: {
        '@oth': path.resolve(__dirname, '..'),
        '@icons': path.resolve(__dirname, 'node_modules/vue-material-design-icons')
      }
    },
    node: {
      readline: 'empty',
      zlib: 'empty'
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
    config.module
      .rule('coffeescript')
      .test(/\.coffee$/)
      .use('coffee-loader')
        .loader('coffee-loader')
        .options(
          {
            transpile: {
              presets: [
                [
                  '@babel/preset-env',
                  { useBuiltIns: 'usage' }
                ]
              ]
            }
          }
        )
  }
}

