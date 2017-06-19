var path = require('path');
var oghliner = require('oghliner');
var through2 = require('through2');

function gulpServiceWorker(options) {
  var toOffline = [];
  var rootDir = options && options.rootDir || '.';

  return through2.obj(
    function(file, enc, cb) {
      var relativePath = path.relative(path.join(process.cwd(), rootDir), file.path);
      toOffline.push(relativePath);
      cb();
    },
    function(cb) {
      oghliner.offline({
        rootDir: rootDir,
        fileGlobs: toOffline,
      }).then(function() {
        cb();
      }, function(err) {
        cb(err);
      });
    }
  );
}

module.exports = gulpServiceWorker;
