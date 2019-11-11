const common = require('./webpack.common.js')
const path = require('path')
const merge = require('webpack-merge')

module.exports = merge(common.webpack, {
    mode: 'development',
    output: {
        filename: 'js/[name].bundle.js',
    },
    module: {
        rules: [
            {
                test: /\.scss$/,
                exclude: common.EXCLUDES,
                loaders: [
                    'style-loader',
                    'css-loader',
                    'sass-loader',
                ],
            },
            {
                test: /\.elm$/,
                exclude: common.EXCLUDES,
                use: [
                    { loader: 'elm-hot-webpack-loader' },
                    {
                        loader: 'elm-webpack-loader',
                        options: {
                            cwd: __dirname,
                            debug: true,
                        },
                    },
                ],
            },
        ],
    },

    devServer: {
        inline: true,
        stats: 'errors-only',
        historyApiFallback: true,
        contentBase: path.join(__dirname, common.ASSETS),
    },
})
