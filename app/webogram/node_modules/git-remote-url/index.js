'use strict';

var gitconfiglocal = require('gitconfiglocal');

module.exports = function(dir, remote) {
  return new Promise(function(resolve, reject) {
    gitconfiglocal(dir, function(error, config) {
      if (error) {
        reject(error);
        return;
      }

      if ('remote' in config && remote in config.remote && 'url' in config.remote[remote]) {
        resolve(config.remote[remote].url);
      } else {
        reject(new Error(remote + ' remote doesn\'t exist.'));
      }
    });
  });
};
