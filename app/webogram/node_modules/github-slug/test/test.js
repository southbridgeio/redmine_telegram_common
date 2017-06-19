var test = require('tape')

var exec = require('child_process').execSync
var temp = require('temp')
temp.track()

var ghslug = require('../index.js')

test('github-slug', function (t) {
  t.test('returns the correct slug', function (t) {
    process.chdir(temp.mkdirSync())
    exec('git init')
    exec('git remote add origin https://github.com/marco-c/github-slug.git')

    ghslug('./', function (err, slug) {
      t.notOk(err)
      t.equal(slug, 'marco-c/github-slug')
      t.end()
    })
  })

  t.test('returns the correct slug with multiple remotes', function (t) {
    t.plan(4)
    process.chdir(temp.mkdirSync())
    exec('git init')
    exec('git remote add origin https://github.com/marco-c/github-slug.git')
    exec('git remote add upstream https://github.com/finnp/github-slug.git')

    ghslug('./', 'origin', function (err, slug) {
      t.notOk(err)
      t.equal(slug, 'marco-c/github-slug')
    })

    ghslug('./', 'upstream', function (err, slug) {
      t.notOk(err)
      t.equal(slug, 'finnp/github-slug')
    })
  })

  t.test('works with global .gitconfig', function (t) {
    process.chdir(temp.mkdirSync())
    exec('git init')
    exec('git remote add munter gh:greenkeeper/munter')
    process.env.HOME = __dirname // location of .gitconfig
    ghslug('./', 'munter', function (err, slug) {
      t.notOk(err)
      t.equal(slug, 'greenkeeper/munter')
      t.end()
    })
  })

  t.test('fails if the specified remote does not exist', function (t) {
    process.chdir(temp.mkdirSync())
    exec('git init')
    exec('git remote add origin https://github.com/marco-c/github-slug.git')
    ghslug('./', 'upstream', function (err, slug) {
      t.ok(err)
      t.notOk(slug)
      t.end()
    })
  })

  t.test('fails if the remote URL is not a GitHub URL', function (t) {
    process.chdir(temp.mkdirSync())
    exec('git init')
    exec('git remote add origin https://marco.it/marco-c/github-slug.git')

    ghslug('./', function (err, slug) {
      t.ok(err)
      t.notOk(slug)
      t.end()
    })
  })

  t.test('fails if outside of a git repository', function (t) {
    process.chdir(temp.mkdirSync())
    ghslug('./', function (err, slug) {
      t.ok(err)
      t.notOk(slug)
      t.end()
    })
  })

  t.test('returns the correct slug from .git/config when git command is not available', function (t) {
    process.chdir(temp.mkdirSync())
    exec('git init')
    exec('git remote add origin https://github.com/marco-c/github-slug.git')
    process.env.PATH = ''

    ghslug('./', function (err, slug) {
      t.notOk(err)
      t.equal(slug, 'marco-c/github-slug')
      t.end()
    })
  })
})
