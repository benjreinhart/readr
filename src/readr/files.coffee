fs = require 'fs'
Path = require 'path'
async = require 'async'
{readFile} = require './fs_helpers'
{getPaths, getPathsSync} = require './paths'

getFilesSync = (path, options = {}) ->
  getPathsSync(path, options).map getFileSync

getFileSync = (path) ->
  unless fs.existsSync path
    throw pathDoesNotExistError(path)

  {path, contents: readFile(path)}

getFiles = (basePath, options, cb) ->
  if 'function' is typeof options then cb = options; options = {}

  getPaths basePath, options, (err, paths) ->
    return (cb err) if err?
    async.map paths, getFile, (err, files) ->
      return (cb err) if err?
      cb null, files

getFile = (path, cb) ->
  fs.exists path, (pathExists) ->
    return cb(pathDoesNotExistError path) unless pathExists
    readFile path, (err, contents) ->
      return (cb err) if err?
      cb null, {path, contents}

pathDoesNotExistError = (path) ->
  new Error "#{path} does not exist"

module.exports = {getFiles, getFilesSync, getFile, getFileSync}
