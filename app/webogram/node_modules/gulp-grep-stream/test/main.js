/* global describe, it */
'use strict';

delete require.cache[require.resolve('../')];
var grep = require('../'),
    es = require('event-stream'),
    readArray = es.readArray,
    toArray = es.writeArray,
    path = require('path'),
    should = require('chai').should();

describe('grep stream', function () {
    describe('options', function () {
        it('should throw, when pattern is missing', function () {
            should.throw(grep);
        });

        it('should not throw, when pattern is string', function () {
            should.not.throw(grep.bind(null, 'pattern'));
            should.not.throw(grep.bind(null, new String('pattern')));
        });

        it('should not throw, when pattern is array', function () {
            should.not.throw(grep.bind(null, []));
            should.not.throw(grep.bind(null, new Array()));
        });

        it('should not throw, when pattern is function', function () {
            should.not.throw(grep.bind(null, function () {}));
            should.not.throw(grep.bind(null, new Function('return false;')));
        });
    });

    it('should include files by pattern', function (done) {
        var expected = [ 'a.txt',
            '/a.txt',
            '/some/path/a.txt',
            '/another/some/path/a.txt'
        ];
        var gs = grep('**/a.txt');
        check(gs, 'text-files', expected, done);
    });

    it('should exclude files by pattern with invertMatch option', function (done) {
        var expected = [ '/home/with/b.txt' ];
        var gs = grep('**/a.txt', { invertMatch: true });
        check(gs, 'text-files', expected, done);
    });

    it('should support function as pattern', function (done) {
        var expected = [ '/another/some/path/a.txt' ];
        var gs = grep(function (f) { return (/another/g).test(f.path); });
        check(gs, 'text-files', expected, done);
    });

    function readAsset(name) {
        return require(path.join(__dirname, 'fixtures', name))
            .map(function (p) { return { path: p }; });
    }

    function toExpected(array) {
        return array.map(function (f) { return f.path; });
    }

    function check(gs, asset, expected, done) {
        readArray(readAsset(asset))
            .pipe(gs)
            .pipe(toArray(function (err, actual) {
                should.not.exist(err);
                toExpected(actual).should.be.deep.equal(expected);
                done();
            }));
    }
});
