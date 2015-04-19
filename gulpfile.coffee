gulp = require('gulp')
plugins = require('gulp-load-plugins')()

gulp.task('build', ->
  gulp
    .src('./src/lens.coffee')
    .pipe(plugins.coffee({bare: true}))
    .pipe(gulp.dest('./build/'))
)

gulp.task('watch', ->
  gulp.watch(['src/**.*@(coffee|js)'], ['build'])
)

gulp.task('default', ['watch', 'build'])