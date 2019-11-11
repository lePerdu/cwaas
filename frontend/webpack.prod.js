const common = require('./webpack.common.js')
const path = require('path')
const merge = require('webpack-merge')

const CopyWebpackPlugin = require('copy-webpack-plugin')
const { CleanWebpackPlugin } = require('clean-webpack-plugin')
const MiniCssExtractPlugin = require('mini-css-extract-plugin')
const OptimizeCssAssetsPlugin = require('optimize-css-assets-webpack-plugin')
const UglifyJsPlugin = require('uglifyjs-webpack-plugin')
const CreateFileWebpack = require('create-file-webpack')

module.exports = merge(common.webpack, {
    mode: 'production',
    output: {
        filename: 'js/[name]-[hash].bundle.js',
    },
    plugins: [
        new CleanWebpackPlugin({
            root: __dirname,
            exclude: [],
            verbose: true,
            dry: false,
        }),
        new CopyWebpackPlugin([{
            from: common.ASSETS,
        }]),
        new MiniCssExtractPlugin({
            filename: 'css/[name]-[hash].css',
            chunkFilename: 'css/[id]-[hash].css',
        }),
        new CreateFileWebpack({
            path: common.DIST,
            fileName: 'CNAME',
            content: common.DOMAIN,
        }),
    ],
    optimization: {
        minimizer: [
            new OptimizeCssAssetsPlugin({}),
            new UglifyJsPlugin({
                uglifyOptions: {
                    compress: {
                        pure_funcs: [
                            'F2', 'F3', 'F4', 'F5', 'F6', 'F7', 'F8', 'F9',
                            'A2', 'A3', 'A4', 'A5', 'A6', 'A7', 'A8', 'A9',
                        ],
                        pure_getters: true,
                        keep_fargs: false,
                        unsafe_comps: true,
                        unsafe: true,
                        passes: 3,
                    },
                    mangle: true,
                },
            }),
        ],
    },
    module: {
        rules: [
            {
                test: /\.scss$/,
                exclude: common.EXCLUDES,
                loaders: [
                    MiniCssExtractPlugin.loader,
                    'css-loader',
                    'sass-loader',
                ],
            },
            {
                test: /\.elm$/,
                exclude: common.EXCLUDES,
                use: {
                    loader: 'elm-webpack-loader',
                    options: {
                        cwd: __dirname,
                        optimize: true,
                    },
                },
            },

        ]
    }
})
