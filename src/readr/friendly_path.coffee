Path = require 'path'

module.exports = (path, options = {}) ->
  {friendlyPath} = options

  extension = Path.extname(path)
  path = path.replace (new RegExp "\\#{extension}$"), ''

  if 'function' is typeof friendlyPath
    path = friendlyPath path

  path
