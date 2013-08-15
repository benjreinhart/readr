fs = require 'fs'
{isString} = require './utils'
getFriendlyPath = require './get_friendly_path'
{getFiles, getFile} = require './get_files'

module.exports = (path, options = {}) ->
  {extension} = options

  if fs.statSync(path).isFile()
    return addFriendlyPath getFile(path), options

  unless isString extension
    throw new Error 'Must provide an `extension` option if path argument is a directory'

  options.basePath = path

  getFiles(path, extension).map (file) ->
    addFriendlyPath file, options

addFriendlyPath = (file, options) ->
  file.friendlyPath = getFriendlyPath file.path, options
  file
