{sep} = require 'path'
{isString} = require './utils'

module.exports = (path, options = {}) ->
  {basePath, extension, friendlyPath} = options

  if isString friendlyPath
    return friendlyPath

  fp = path

  if isString extension
    fp = removeExtension path, extension

  if isString basePath
    fp = removeBasePath basePath, fp

  if 'function' is typeof friendlyPath
    fp = friendlyPath fp, path

  fp

removeBasePath = (basePath, path) ->
  if basePath[-1..] isnt sep
    basePath = basePath + sep
  path.replace (new RegExp "^#{basePath}"), ''

removeExtension = (path, extension) ->
  path.replace (new RegExp "\\.#{extension}$"), ''
