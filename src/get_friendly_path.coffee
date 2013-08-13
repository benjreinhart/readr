Path = require 'path'
{isString} = require './utils'

module.exports = (path, options = {}) ->
  {baseDir, extension, friendlyPath} = options

  return friendlyPath if isString friendlyPath

  fp = removeExtension path, extension

  if isString baseDir
    fp = removeBasePath baseDir, fp

  if 'function' is typeof friendlyPath
    fp = friendlyPath fp, path

  fp

removeBasePath = (baseDir, path) ->
  path.replace (new RegExp "^#{baseDir}#{Path.sep}"), ''

removeExtension = (path, extension) ->
  path.replace (new RegExp "\\.#{extension}$"), ''
