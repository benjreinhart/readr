Path = require 'path'
globber = require 'globber'
getFriendlyPath = require './readr/friendly_path'
{getFiles, getFilesSync} = (File = require './readr/file')

module.exports = readr = (path, options, cb) ->
  if 'function' is typeof options then cb = options; options = {}

  options.includeDirectories = false
  getFiles path, options, (err, files) ->
    if err? then return cb(err)

    if options.friendlyPath is false
      return cb null, files

    cb null, files.map (file) ->
      addFriendlyPath file, options

readr.sync = (path, options = {}) ->
  options.includeDirectories = false
  files = getFilesSync(path, options)

  if options.friendlyPath is false
    return files

  files.map (file) ->
    addFriendlyPath file, options

readr.getPaths = (path, options, cb) ->
  if 'function' is typeof options then cb = options; options = {}

  options.includeDirectories = false
  File.glob path, options, (err, paths) ->
    if err? then return cb(err)

    if options.friendlyPath is false
      return cb null, (paths.map (path) -> {path})

    cb null, paths.map (path) ->
      addFriendlyPath {path}, options

readr.getPathsSync = (path, options = {}) ->
  options.includeDirectories = false
  paths = File.glob.sync path, options

  if options.friendlyPath is false
    return paths.map (path) -> {path}

  paths.map (path) ->
    addFriendlyPath {path}, options

addFriendlyPath = (file, options) ->
  file.friendlyPath = getFriendlyPath file.path, options
  file
