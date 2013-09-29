fs = require 'fs'
async = require 'async'
(File = exports).glob = require 'globber'

File.getFiles = (path, options, cb) ->
  if 'function' is typeof options then cb = options; options = {}

  File.glob path, options, (err, paths) ->
    return (cb err) if err?

    iterator = partiallyApply(getFile, options.encoding)
    async.map paths, iterator, (err, files) ->
      return (cb err) if err?
      cb null, files

File.getFilesSync = (path, options = {}) ->
  File.glob.sync(path, options).map(partiallyApply getFileSync, options.encoding)

getFile = (encoding, path, cb) ->
  fs.exists path, (pathExists) ->
    return cb(pathDoesNotExistError path) unless pathExists
    readFile path, encoding, (err, contents) ->
      return (cb err) if err?
      cb null, {path, contents}

getFileSync = (encoding, path) ->
  if fs.existsSync path
    {path, contents: readFile(path, encoding)}
  else
    throw pathDoesNotExistError(path)

readFile = (path, encoding = 'utf8', cb) ->
  if encoding is 'buffer'
    encoding = null

  options = if getNodeVersion() < 10 then encoding else {encoding}
  method = if 'function' is typeof cb then 'readFile' else 'readFileSync'
  fs[method] path, options, cb

partiallyApply = (fn, args...) ->
  fn.bind null, args...

pathDoesNotExistError = (path) ->
  new Error "#{path} does not exist"

getNodeVersion = ->
  +process.version[1..].split('.')[1]
