# github-slug
[![js-standard-style](https://cdn.rawgit.com/feross/standard/master/badge.svg)](https://github.com/feross/standard)
[![Build Status](https://travis-ci.org/finnp/github-slug.svg?branch=master)](https://travis-ci.org/finnp/github-slug)

Gets the github-slug for the given directory.

Install with `npm install github-slug`

```javascript
var ghslug = require('github-slug')
ghslug('./', function (err, slug) {
  console.log(slug)
  // evaluates to 'finnp/github-slug' in this directory
})
```

Optionally you can specify a specific remote as the second argument.
```javascript
ghslug('./', 'origin', function (err, slug) {
  console.log(slug)
})
```
