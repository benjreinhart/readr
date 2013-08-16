fs = require 'fs'
glob = require 'glob'
Path = require 'path'
async = require 'async'
{readFile} = require './fs_helpers'

getFilesSync = (basePath, extension) ->
  glob.sync(Path.normalize("#{basePath}/**/*.#{extension}")).map getFileSync

getFileSync = (path) ->
  unless isAbsolutePath path
    throw absolutePathError()

  unless fs.existsSync path
    throw pathDoesNotExistError(path)

  {path, contents: readFile(path)}

getFiles = (basePath, extension, cb) ->
  glob Path.normalize("#{basePath}/**/*.#{extension}"), (err, paths) ->
    return (cb err) if err?
    async.map paths, getFile, (err, files) ->
      return (cb err) if err?
      cb null, files

getFile = (path, cb) ->
  unless isAbsolutePath path
    return cb absolutePathError()

  fs.exists path, (pathExists) ->
    return cb(pathDoesNotExistError path) unless pathExists
    readFile path, (err, contents) ->
      return (cb err) if err?
      cb null, {path, contents}

absolutePathError = ->
  new Error 'Path argument must be an absolute path'

pathDoesNotExistError = (path) ->
  new Error "#{path} does not exist"

isAbsolutePath = (path) ->
  /^\//.test path

module.exports = {getFiles, getFilesSync, getFile, getFileSync}
