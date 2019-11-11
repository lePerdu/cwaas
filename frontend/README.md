# CWaaS Website

This is the code for the miniature web-app for the CWaaS project, made with
[Elm](https://elm-lang.org).


## Building

This requires the following to build the project:
- [NPM](https://nodejs.org) (usually bundled with NodeJS)
- [Elm compiler](https://guide.elm-lang.org/install/elm.html)

### Development Build

For development, it is usually easier to run Webpack's development server, which
supports hot reloading, and the Elm debugger overlay. This can be done by
running
```
npm install
npm start
```

### Production Build

For deploying the site, it is best to turn on optimizations and minify the
artiifacts. This can be done by running
```
npm run build
```

The generated site will then be at `dist`. It can be served by any local static
server, such as [serve](https://github.com/zeit/serve), or by some static
hosting service like [Surge](https://surge.sh).

