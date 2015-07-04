cp = require 'child_process'
async = require 'async'
gulp = require 'gulp'

manifest = require '../src/package.json'

# Sign the darwin64 app
gulp.task 'sign:darwin64', ['build:darwin64'], (done) ->
  if process.platform isnt 'darwin'
    console.warn 'Skipping darwin64 app signing; This only works on darwin due to the `codesign` command.'
    return done()

  async.series [
    async.apply cp.exec, [
      'security'
      'unlock-keychain'
      '-p'
      process.env.SIGN_DARWIN_KEYCHAIN_PASSWORD
      process.env.SIGN_DARWIN_KEYCHAIN_NAME
    ].join(' ')

    async.apply cp.exec, [
      'codesign'
      '--deep'
      '--force'
      '--verbose'
      '--sign "' + process.env.SIGN_DARWIN_IDENTITY + '"'
      './build/darwin64/' + manifest.productName + '.app'
    ].join(' ')
  ], done

# Sign everything
gulp.task 'sign', [
  'sign:darwin64'
]
