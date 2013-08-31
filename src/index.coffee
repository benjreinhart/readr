Path = require 'path'
Paths = require './readr/paths'
fsHelpers = require './readr/fs_helpers'
getFriendlyPath = require './readr/friendly_path'
{isString} = require './readr/utils'
{getFile, getFileSync, getFiles, getFilesSync} = require './readr/files'

module.exports = readr = (path, options, cb) ->
  if 'function' is typeof options then cb = options; options = {}

  unless isAbsolutePath path
    path = resolveRelative path

  if fsHelpers.isFile path
    return getFileAsync path, options, cb

  options.basePath = path
  getFiles path, options, (err, files) ->
    return (cb err) if err?
    return (cb null, files) if options.friendlyPath is false

    cb null, (files.map (file) -> addFriendlyPath file, options)
  undefined

readr.sync = (path, options = {}) ->
  unless isAbsolutePath path
    path = resolveRelative path

  if fsHelpers.isFile path
    file = getFileSync(path)
    if options.friendlyPath isnt false
      file = addFriendlyPath getFileSync(path), options
    return [file]

  files = getFilesSync path, options
  return files if options.friendlyPath is false

  options.basePath = path
  files.map (file) -> addFriendlyPath file, options


readr.getPaths = (path, options, cb) ->
  if 'function' is typeof options then cb = options; options = {}

  unless isAbsolutePath path
    path = resolveRelative path

  Paths.getPaths path, options, (err, paths) ->
    return (cb err) if err?

    if options.friendlyPath is false
      return cb null, (paths.map (path) -> {path})

    options.basePath = path
    cb null, paths.map (path) -> addFriendlyPath {path}, options
  undefined

readr.getPathsSync = (path, options = {}) ->
  unless isAbsolutePath path
    path = resolveRelative path

  paths = Paths.getPathsSync path, options

  if options.friendlyPath is false
    return paths.map (path) -> {path}

  options.basePath = path
  paths.map (path) -> addFriendlyPath {path}, options



###########
# PRIVATE #
###########

getFileAsync = (path, options, cb) ->
  getFile path, (err, file) ->
    return cb err if err?
    if options.friendlyPath is false
      cb null, [file]
    else
      cb null, [addFriendlyPath file, options]

resolveRelative = do (cwd = process.cwd()) ->
  (path) -> Path.resolve cwd, path

isAbsolutePath = (path) ->
  /^\//.test path

addFriendlyPath = (file, options) ->
  file.friendlyPath = getFriendlyPath file.path, options
  file
