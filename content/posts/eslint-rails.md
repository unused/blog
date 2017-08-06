---
title: "Add eslint to rails 5.1"
date: 2017-08-06T12:47:15+02:00
---

JavaScript is trending and on its very fast paced run creating new projects,
concepts and ideas, best practices, throwing everything away again and start
from scratch. That is a very good thing and for good we have now pretty neat
tools that take away the very complex work of setting up a new project, keeping
us left with a few nuts and bolts to configure on a higher level. A great tool
handling a complex JavaScript projects is a module bundler named [webpack].
With the rails extension [webpacker], that magic thing is connected to rails,
with 5.1 shipped with the framework itself, and further containing
pre-configurations for widely used libraries like vue, react or elm.

As the hard work of finding a nice integration and structure was already done
by our community friends, all we've left to do is to extend the webpacker
configuration. Let's have a look into a quick step by step setup.

Create a demonstrational rails project, using [React] and add eslint to our
JavaScript packages. The loader package is the glue between webpack and eslint.

```sh
$ rails --version # Rails 5.1.3
$ rails new eslint-rails --webpack=react # Create a rails + react project
$ cd eslint-rails
$ yarn add -D eslint eslint-loader eslint-plugin-react # Add JS dev packages
$ yarn run eslint -- --init # Run the eslint setup
```

The setup is pretty fancy, I'll guess it should be fine if you simply choose to
make eslint inspect your files and use `app/javascript` as target path. For a
react setup I'd use ECMAScript 6 fetures, ES6 modules, run code in Browser, use
no CommonJS, use JSX and use React.

Lets now add a webpack loader by simply storing a new file in the rails config.

```JavaScript
// config/webpack/loaders/eslint.js
const { env } = require('../configuration.js')

module.exports = {
  enforce: 'pre',
  test: /\.(js|jsx)$/i,
  exclude: /node_modules/,
  loader: 'eslint-loader',
  options: {
    failOnError: env.NODE_ENV !== 'production'
  }
}
```

As a last step, add a run task in the `package.json` file, in order to provide
a way to run eslint with a simple call to provide a command for any CI running
your project, to be run with `yarn run lint`.

```json
// package.json
{
  // ...
  },
  "scripts": {
    "lint": "yarn run eslint -- --ext .js --ext .jsx app/javascript"
  }
}
```

Now start the webpack development server using the binary generated in the
rails setup process and you are ready to go.

```sh
$ ./bin/webpack-dev-server # start the webpack dev server
```


## Apply Fine Tuning to a React Eslint Configuration

And there it goes, the `app/javascript/packs/hello_react.jsx` is out-of-the-box
not fine for eslint. To fix the Syntax remove the obsolete second comma `,` in
the appendChild line. This will result in a lot of different other errors but
at least eslint considers the JavaScript now to be valid. Lets fix it tough.

Lets use the react recommended rules configuration by adapting the
.eslintrc.json file, and deactivate some not so useful rules there. Then
restart the server.

```JavaScript
// .eslintrc.json
module.exports = {
  // ...
  "extends": [
    "eslint:recommended",
    "plugin:react/recommended"
  ],
  // ...
  "arrow-parens": [
    "error",
    "as-needed"
  ],
  // ...
  "indent": "off",
  "indent-legacy": "off",
  // ...
  "sort-imports": "off",
  // ...
  "no-extra-parens": "off",
  // ...
  "object-curly-newline": "off",
  // ...
  "quote-props": "off",
  // ...
  "padded-blocks": "off",
  // ...
}
```


## About Linting your JavaScript

As you are using rails, I suppose you have a great understanding of testing and
probably also use a static analyzer for ruby (and rails) like [rubocop]. Eslint
is a great tool to analyze your code, avoid making common mistake, follow best
practices and sticking to coding standards. This will make your code cleaner
and improve readability especially to developers who follow the same rules.

The rules provided by eslint can be very helpful, but on another hand side very
restrictive. Ensure you feel comfortable and, read carefully through the
[extensive and very nice rules documentations](http://eslint.org/docs/rules/),
and deceide rules that often popup if it make sense to throw an error (should
never happen), should show a warning (okay if it stays temporary in
development, but has to be cleaned up at some time) or be deactivated
completly.


## Rails and JavaScript is Awesome

A good friend of mine and former colleague told me, he is happy about the step
forward that the rails community did with embracing JavaScript and binding it
that deep into the well known web frameworks core. Nothing to add there. On a
long view back in the history of web development, JavaScript was always
something nasty that required fallbacks, therefore redundancy, and widely
misused by frontend developers, not used by backend developers. For quite a
long time now this totally changed, even the gap between frontend and backend
is getting smaller and smaller. Good choice therefore sticking that close to
the cool new stuff, and making it a huge part in rails. I love ruby, ruby on
rails and JavaScript!


[webpack]: https://webpack.github.io/ "Webpack takes modules with dependencies and generates static assets representing those modules."
[webpacker]: https://github.com/rails/webpacker "JavaScript pre-processor for rails using webpack."
[rubocop]: https://github.com/bbatsov/rubocop "A Ruby static code analyzer, based on the community Ruby style guide."
[React]: "https://facebook.github.io/react/" "A JavaScript library for building user interfaces."
