fs = require 'fs'
{isString} = require './readr/utils'
getFriendlyPath = require './readr/get_friendly_path'

{getFile, getFileSync, getFiles, getFilesSync} = require './readr/get_files'
{isFile, isFileSync} = require './readr/fs_helpers'

module.exports = readr = (path, options, cb) ->
  if 'function' is typeof options then cb = options; options = {}
  {extension} = options

  isFile path, (err, file) ->
    return (cb err) if err?

    if file
      return getSingleFileAsync path, options, cb

    if !(isString extension)
      throw extensionError()

    options.basePath = path
    getFiles path, extension, (err, files) ->
      return (cb err) if err?
      cb null, (files.map (file) -> addFriendlyPath file, options)


getSingleFileAsync = (path, options, cb) ->
  getFile path, (err, file) ->
    return cb err if err?
    cb null, [addFriendlyPath file, options]

readr.sync = (path, options = {}) ->
  {extension} = options

  if isFileSync path
    return [addFriendlyPath getFileSync(path), options]

  if !(isString extension)
    throw extensionError()

  options.basePath = path
  getFilesSync(path, extension).map (file) ->
    addFriendlyPath file, options

addFriendlyPath = (file, options) ->
  file.friendlyPath = getFriendlyPath file.path, options
  file

extensionError = ->
  new Error 'Must provide an `extension` option if path argument is a directory'
