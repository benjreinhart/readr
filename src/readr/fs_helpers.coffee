fs = require 'fs'

exports.isFile = (path, cb) ->
  fs.stat path, (err, stats) ->
    return (cb err) if err?
    cb null, stats.isFile()

exports.isFileSync = (path) ->
  fs.statSync(path).isFile()

exports.readFile = (path, cb) ->
  options = if getNodeVersion() < 10 then 'utf8' else {encoding: 'utf8'}
  method = if 'function' is typeof cb then 'readFile' else 'readFileSync'
  fs[method] path, options, cb

# Only a function for stubbing `process.version` in tests
getNodeVersion = ->
  +process.version[1..].split('.')[1]
