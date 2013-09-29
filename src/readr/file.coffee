fs = require 'fs'
async = require 'async'

(File = exports).glob = require 'globber'

File.getFiles = (args...) ->
  cb = args.pop()
  File.glob args..., (err, paths) ->
    return (cb err) if err?
    async.map paths, getFile, (err, files) ->
      return (cb err) if err?
      cb null, files

File.getFilesSync = (path, options = {}) ->
  File.glob.sync(path, options).map getFileSync

getFile = (path, cb) ->
  fs.exists path, (pathExists) ->
    return cb(pathDoesNotExistError path) unless pathExists
    readFile path, (err, contents) ->
      return (cb err) if err?
      cb null, {path, contents}

getFileSync = (path) ->
  if fs.existsSync path
    {path, contents: readFile(path)}
  else
    throw pathDoesNotExistError(path)

pathDoesNotExistError = (path) ->
  new Error "#{path} does not exist"

readFile = (path, cb) ->
  options = if getNodeVersion() < 10 then 'utf8' else {encoding: 'utf8'}
  method = if 'function' is typeof cb then 'readFile' else 'readFileSync'
  fs[method] path, options, cb

getNodeVersion = ->
  +process.version[1..].split('.')[1]
