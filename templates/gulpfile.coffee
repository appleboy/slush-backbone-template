'use strict'

gulp = require 'gulp'
rjs = require 'requirejs'
runs = require 'run-sequence'
$ = require('gulp-load-plugins')()
minifyCSS = require 'gulp-minify-css'
production = true if $.util.env.env is 'production'
filename = require('uuid').v4()
lazypipe = require 'lazypipe'
browserSync = require 'browser-sync'
reload = browserSync.reload

paths =
  src: 'app'
  script: 'app/assets/js'
  coffee: 'app/assets/coffee'
  sass: 'app/assets/sass'
  css: 'app/assets/css'
  images: 'app/assets/images'
  test: 'test'
  dist: 'dist'
  vendor: 'app/assets/vendor'
  hbs: 'app/assets/templates'

coffeelintTasks = lazypipe()
  .pipe $.coffeelint
  .pipe $.coffeelint.reporter
  .pipe $.coffee, bare: true

gulp.task 'coffee', ->
  gulp.src paths.coffee + '/**/*.coffee'
    .pipe $.if !production, $.changed paths.script,
      extension: '.js'
    .pipe coffeelintTasks()
    .pipe gulp.dest paths.script

gulp.task 'test_coffee', ->
  gulp.src paths.test + '/**/*.coffee'
    .pipe $.if !production, $.changed paths.test,
      extension: '.js'
    .pipe coffeelintTasks()
    .pipe gulp.dest paths.test

gulp.task 'html', ->
  gulp.src paths.src + '/*.html'
    .pipe $.changed paths.dist
    .pipe $.replace 'js/main', 'js/' + filename
    .pipe $.replace 'vendor/requirejs/require.js', 'js/require.js'
    .pipe $.htmlmin
      removeComments: true
      collapseWhitespace: true
    .pipe gulp.dest paths.dist

gulp.task 'styles', ->
  gulp.src <% if (includeCss) { %>paths.css + '/**/*.css'<% } else { %>paths.sass + '/**/*.scss'<% } %><% if (!includeCss) { %>
    .pipe $.plumber()
    .pipe $.if !production, $.changed paths.css,
      extension: '.css'<% if (includeCompass) { %>
    .pipe $.compass
      css: paths.css
      sass: paths.sass
      image: paths.image
    .on('error', ->)<% } else { %>
    .pipe $.rubySass
      style: 'expanded'
      precision: 10<% } %><% } %>
    .pipe $.if production, minifyCSS()<% if (!includeCss) { %>
    .pipe gulp.dest paths.css<% } %>
    .pipe $.if production, gulp.dest paths.dist + '/assets/css/'

gulp.task 'copy', ->
  gulp.src [
    paths.src + '/.htaccess'
    paths.src + '/favicon.ico'
    paths.src + '/robots.txt']
    .pipe gulp.dest paths.dist

# Clean
gulp.task 'clean', require('del').bind null, [
    paths.dist
    '.sass-cache'
    paths.script
    paths.css
  ]

# Images
gulp.task 'images', ->
  gulp.src paths.images + '/**/*.{jpg,jpeg,png,gif}'
    .pipe $.changed paths.dist + '/assets/images'
    .pipe $.cache $.imagemin
      progressive: true
      interlaced: true
    .pipe gulp.dest paths.dist + '/assets/images'

# Connect
gulp.task 'connect:app', ->
  browserSync
    notify: false
    server:
      baseDir: [paths.src]

  # run tasks automatically when files change
  gulp.watch paths.coffee + '/**/*.coffee', ['coffee']
  gulp.watch paths.test + '/**/*.coffee', ['test_coffee']
  gulp.watch paths.src + '/*.html', reload<% if (!includeCss) { %>
  gulp.watch paths.sass + '/**/*.scss', ['styles']<% } else { %>
  gulp.watch paths.css + '/**/*.css', ['styles']<% } %>
  gulp.watch paths.script + '/**/*.js', reload
  gulp.watch paths.hbs + '/**/*.hbs', reload
  gulp.watch paths.images + '/**/*.{jpg,jpeg,png,gif}', reload

gulp.task 'rjs', ['build'], (cb) ->
  rjs.optimize
    baseUrl: paths.script
    name: 'main'
    out: paths.script + '/main-built.js'
    mainConfigFile: paths.script + '/main.js'
    preserveLicenseComments: false
    , (buildResponse) ->
      cb()

gulp.task 'rename', ['rjs'], ->
  gulp.src paths.script + '/main-built.js'
    .pipe $.rename 'assets/js/' + filename + '.js'
    .pipe gulp.dest 'dist'
  gulp.src paths.vendor + '/requirejs/require.js'
    .pipe $.uglify()
    .pipe gulp.dest paths.dist + '/assets/js/'

# testing via $.mocha tool
gulp.task 'test', ->
  gulp.src paths.test + '/**/*.js'
    .pipe $.mocha
      reporter: 'spec'

# The default task (called when you run `gulp`)
gulp.task 'default', (cb) ->
  runs(
    ['coffee', 'compass']
    'connect:app'
    cb)

# Build
gulp.task 'build', [
  'coffee'
  'images'
  'compass'
  'html'
  'copy'
], ->
  gulp.src paths.dist + '/**/*'
    .pipe $.size
      showFiles: true,
      gzip: true

gulp.task 'release', (cb) ->
  runs(
    ['build', 'rjs', 'rename']
    cb)

module.exports = gulp
