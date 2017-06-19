# gulp-grep-stream 
[![NPM version][npm-image]][npm-url] [![Build Status][travis-image]][travis-url] [![Coveralls Status][coveralls-image]][coveralls-url] [![Dependency Status][depstat-image]][depstat-url]

> Stream grep plugin for [gulp](https://github.com/wearefractal/gulp)

This is grep for stream. It allows to include/exclude files from stream by patterns or custom `function`.

## Usage

### Basic

```javascript
var grep = require('gulp-grep-stream');

gulp.src(['./src/*.ext'])
    .pipe(grep('*magic*.ext'))
    .pipe(gulp.dest("./dist/magic"));
```

__Invert match__

```javascript
var grep = require('gulp-grep-stream');

gulp.src(['./src/*.ext'])
    .pipe(grep('*magic*.ext', { invert_match: true }))
    .pipe(gulp.dest("./dist/not_magic"));
```

## API

### grep(pattern, options)

#### pattern
Type: `String` / `Array` / `Function`

Patterns for using in minimatch.

 * `String` pattern
 * `Array` of patterns
 * `Function` returning `boolean` to determine grep file or not

#### options.invertMatch
Type: `Boolean`
Default: `false`

If file matches one of patterns, it will be excluded from stream.

## License

[MIT License](http://en.wikipedia.org/wiki/MIT_License)

[npm-url]: https://npmjs.org/package/gulp-grep-stream
[npm-image]: https://badge.fury.io/js/gulp-grep-stream.png

[travis-url]: http://travis-ci.org/floatdrop/gulp-grep-stream
[travis-image]: https://secure.travis-ci.org/floatdrop/gulp-grep-stream.png?branch=master

[coveralls-url]: https://coveralls.io/r/floatdrop/gulp-grep-stream
[coveralls-image]: https://coveralls.io/repos/floatdrop/gulp-grep-stream/badge.png

[depstat-url]: https://david-dm.org/floatdrop/gulp-grep-stream
[depstat-image]: https://david-dm.org/floatdrop/gulp-grep-stream.png?theme=shields.io
