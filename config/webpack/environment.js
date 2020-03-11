const { environment } = require('@rails/webpacker')

const webpack = require('webpack')

module.exports = environment

environment.plugins.prepend('Provide',
  new webpack.ProvidePlugin({
    $: 'jquery/src/jquery',
    jQuery: 'jquery/src/jquery'
  })
)