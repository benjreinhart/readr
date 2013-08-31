glob = require 'glob'
Path = require 'path'
async = require 'async'
fsHelpers = require './fs_helpers'
{without} = require './utils'

exports.getPathsSync = (basePath, options = {}) ->
  {extension, filesOnly} = options
  options = without options, 'extension', 'filesOnly'

  globPath = getGlobPath basePath, extension
  paths = fsHelpers.globSync(globPath, options)

  if filesOnly and !extension
    paths = paths.filter(fsHelpers.isFile)

  paths

exports.getPaths = (basePath, options, cb) ->
  if 'function' is typeof options then cb = options; options = {}

  {extension, filesOnly} = options
  options = without options, 'extension', 'filesOnly'

  globPath = getGlobPath basePath, extension
  fsHelpers.glob globPath, options, (err, paths) ->
    return (cb err) if err?

    if filesOnly and !extension
      paths = paths.filter(fsHelpers.isFile)

    cb null, paths

getGlobPath = (basePath, extension) ->
  path = "#{basePath}/**/*"
  path += ".#{extension}" if extension?

  Path.normalize path
