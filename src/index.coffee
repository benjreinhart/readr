fs = require 'fs'
{isString} = require './utils'
getFriendlyPath = require './get_friendly_path'
{getFiles, getFile} = require './get_files'

module.exports = (baseDir, options = {}) ->
  {extension} = options
  options = {baseDir, extension, friendlyPath: options.friendlyPath}

  if fs.statSync(baseDir).isFile()
    file = getFile baseDir
    file.friendlyPath = getFriendlyPath baseDir, options
    return file

  if !(isString extension)
    throw new Error 'Must provide an `extension` option if path is a directory'

  files = getFiles baseDir, extension
  files.map (file) ->
    file.friendlyPath = getFriendlyPath file.path, options
    file
