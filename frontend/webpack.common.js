const path = require('path')

const HTMLWebpackPlugin = require('html-webpack-plugin')

const EXCLUDES = [/elm-stuff/, /node_modules/]

module.exports = {
    webpack: {
        entry: path.join(__dirname, 'src/index.js'),
        output: {
            path: path.join(__dirname, 'dist'),
        },
        plugins: [
            new HTMLWebpackPlugin({
                template: 'src/index.html',
                inject: 'body',
            }),
        ],
        resolve: {
            modules: [path.join(__dirname, 'src'), 'node_modules'],
            extensions: ['.js', '.elm', '.scss'],
        },
        module: {
            rules: [
                {
                    test: /\.js$/,
                    exclude: EXCLUDES,
                    use: {
                        loader: 'babel-loader',
                        options: {
                            presets: ['@babel/preset-env'],
                        },
                    },
                },
                {
                    test: /\.(jpe?g|png|gif|svg)$/,
                    exclude: EXCLUDES,
                    loader: 'file-loader',
                },
                {
                    test: /\.(ttf|otf)$/,
                    exclude: EXCLUDES,
                    loader: 'file-loader',
                },
            ],
        },
    },
    EXCLUDES: EXCLUDES,
    ASSETS: 'assets',
}
