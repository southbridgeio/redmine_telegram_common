
var test = require('tap').test
  , prop = require('../index.js');


test('invalid input', function (t) {
  var a = undefined
    , b = { }
    , c = { path: { to:'value' }}
    , d = { }
    , e = { };

  prop.set(a, 'sample', 'Example A');
  prop.set(b, undefined, 'Example B');
  prop.set(c, 'path.to.', 'Invalid');
  prop.set(d, 'undefined', 'Cheating');
  prop.set(e, 'path.to..error', 'Erroneous');

  t.equivalent(a, undefined);
  t.equivalent(b, { });
  t.equivalent(c, { path: { to:'value' }});
  t.equivalent(d, { 'undefined':'Cheating' });
  t.equivalent(e, { });
  t.end();
});


test('setting existing values', function (t) {
  var a = {
    name: {
      first:  'John',
      middle: 'C',
      last:   'McCloy'
    }
  };

  prop.set(a, 'name.last', 'Reilly');

  t.equal(a.name.last, 'Reilly');
  t.end();
});


test('setting non-existing values', function (t) {
  var a = {
    name: {
      first:  'John',
      middle: 'C',
      last:   'Reilly'
    }
  };

  prop.set(a, 'name.suffix', 'III');
  prop.set(a, 'job.title', 'Actor');

  t.equal(a.name.suffix, 'III');
  t.equal(a.job.title, 'Actor');
  t.end();
});
