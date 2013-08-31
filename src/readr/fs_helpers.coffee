fs = require 'fs'
glob = require 'glob'

exports.isFile = (path) ->
  fs.statSync(path).isFile()

# Mostly for easy stubbing in tests
exports.glob = glob
exports.globSync = glob.sync.bind glob

exports.readFile = (path, cb) ->
  options = if getNodeVersion() < 10 then 'utf8' else {encoding: 'utf8'}
  method = if 'function' is typeof cb then 'readFile' else 'readFileSync'
  fs[method] path, options, cb

# Only a function for stubbing `process.version` in tests
getNodeVersion = ->
  +process.version[1..].split('.')[1]
