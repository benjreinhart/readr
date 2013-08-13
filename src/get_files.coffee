# Given the following directory tree:
#
# * Users/ben/projects/todos/views/
#   * users/
#     * index.mustache
#   * todos/
#     * todo.mustache
#
#
# getFiles('/Users/ben/projects/todos/views', 'mustache')
#
#    [
#      {
#        path: "/Users/ben/projects/todos/views/users/index.mustache",
#        contents: "<h1>There are {{users.count}} users!</h1>"
#      },
#      {
#        path: "/Users/ben/projects/todos/views/todos/todo.mustache",
#        contents: "<h1>{{todo.name}}</h1>"
#      }
#    ]
#
#
# getFile('/Users/ben/projects/todos/views/todos/todo.mustache')
#
#    {
#      path: "/Users/ben/projects/todos/views/todos/todo.mustache",
#      contents: "<h1>{{todo.name}}</h1>"
#    }

fs = require 'fs'
glob = require 'glob'
Path = require 'path'

getFiles = (basePath, extension) ->
  glob.sync(Path.normalize("#{basePath}/**/*.#{extension}")).map getFile

getFile = (path) ->
  unless isAbsolutePath path
    throw new Error 'Path argument must be an absolute path'

  unless fs.existsSync path
    throw new Error "#{path} does not exist"

  {path, contents: readFileSync(path)}

# Only a function for stubbing `process.version` in tests
getNodeVersion = ->
  +process.version[1..].split('.')[1]

readFileSync = (path) ->
  options = if getNodeVersion() < 10 then 'utf8' else {encoding: 'utf8'}
  fs.readFileSync path, options

isAbsolutePath = (path) ->
  /^\//.test path

module.exports = {getFiles, getFile}
