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
      return getFileAsync path, options, cb

    if !(isString extension)
      throw extensionError()

    options.basePath = path
    getFiles path, extension, (err, files) ->
      return (cb err) if err?

      {friendlyPath} = options
      cb null, files.map (file) ->
        return file if friendlyPath is false
        addFriendlyPath file, options


getFileAsync = (path, options, cb) ->
  getFile path, (err, file) ->
    return cb err if err?
    if options.friendlyPath is false
      cb null, [file]
    else
      cb null, [addFriendlyPath file, options]

readr.sync = (path, options = {}) ->
  {extension} = options

  if isFileSync path
    file = getFileSync(path)
    if options.friendlyPath isnt false
      file = addFriendlyPath getFileSync(path), options
    return [file]

  if !(isString extension)
    throw extensionError()

  options.basePath = path
  {friendlyPath} = options
  getFilesSync(path, extension).map (file) ->
    return file if friendlyPath is false
    addFriendlyPath file, options

addFriendlyPath = (file, options) ->
  file.friendlyPath = getFriendlyPath file.path, options
  file

extensionError = ->
  new Error 'Must provide an `extension` option if path argument is a directory'
