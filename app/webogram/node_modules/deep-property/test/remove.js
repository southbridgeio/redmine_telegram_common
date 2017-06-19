
var test = require('tap').test
  , prop = require('../index.js');


test('invalid input', function (t) {
  var a = undefined
    , b = { }
    , c = { path: { to:'value', useless:'property' }};

  t.equal(prop.remove(a, 'sample'), false);
  t.equal(prop.remove(b, 'sample'), false);
  t.equal(prop.remove(b, 'sample.'), false);
  t.equal(prop.remove(c, 'path.to.'), false);
  t.equal(prop.remove(c, 'path.to..error'), false);
  t.end();
});


test('remove existing values', function (t) {
  var a = {
    name: {
      first:  'John',
      middle: 'C',
      last:   'Reilly'
    }
  };

  var result = prop.remove(a, 'name.middle');

  t.equal(result, true);
  t.equal(a.name.hasOwnProperty('middle'), false);
  t.end();
});


test('remove non-existing values', function (t) {
  var a = {
    name: {
      first:  'John',
      middle: 'C',
      last:   'Reilly'
    }
  };

  t.equal(prop.remove(a, 'name.suffix'), false);
  t.end();
});
