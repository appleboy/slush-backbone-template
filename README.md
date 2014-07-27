# [slush](https://github.com/slushjs/slush)-backbone-template

[![NPM version][npm-image]][npm-url] [![Downloads][downloads-image]][npm-url] [![Build Status](https://travis-ci.org/appleboy/slush-backbone-template.svg?branch=master)](https://travis-ci.org/appleboy/slush-backbone-template) [![Dependency Status](https://gemnasium.com/appleboy/slush-backbone-template.svg)](https://gemnasium.com/appleboy/slush-backbone-template)

[![NPM](https://nodei.co/npm/slush-backbone-template.png?downloads=true&stars=true)](https://nodei.co/npm/slush-backbone-template/)

> Slush generator backbone web apps

## Features

* The latest [html5boilerplate.com](http://html5boilerplate.com/) source code.
* Includes [Normalize.scss](https://github.com/appleboy/normalize.scss) v3.0.x and v1.1.x.
* The latest [jQuery](http://jquery.com/) and [Modernizr](http://modernizr.com/) via [Bower](http://bower.io/) package manager.
* Support [CoffeeScript](http://coffeescript.org/), [RequireJS](http://requirejs.org/), [Compass](http://compass-style.org/), html minification (via [html-minifier](http://kangax.github.io/html-minifier/)).
* Support [browser-sync](http://browsersync.io) Keep multiple browsers & devices in sync when building websites.
* Support JavaScript test framework [Mocha](http://visionmedia.github.io/mocha/).
* Support The streaming build system [GulpJS](http://gulpjs.com).
* Support [Backbone.js](http://backbonejs.org) MV* Framework.
* Support [Handlebars.js](http://handlebarsjs.com) Mustache templating language.

## Getting Started

### Installation

Install `slush-backbone-template` globally:

```bash
$ npm install -g slush-backbone-template
```

Remember to install `slush` globally as well, if you haven't already:

```bash
$ npm install -g slush
```

### Usage

Create a new folder for your project:

```bash
$ mkdir my-slush-backbone-template
```

Run the generator from within the new folder:

```bash
$ cd my-slush-backbone-template && slush backbone-template
```

## Quick start

### run application

To run the application

```bash
$ npm start
```

### Release application

To build application

```bash
$ npm release
```

### Testing application

To test the application

```bash
$ npm test
```

[npm-url]: https://www.npmjs.org/package/slush-backbone-template
[npm-image]: http://img.shields.io/npm/v/slush-backbone-template.svg
[downloads-image]: http://img.shields.io/npm/dm/slush-backbone-template.svg
