{expect} = require 'chai'
getFriendlyPath = require '../lib/readr/friendly_path'

describe 'readr/friendly_path', ->
  describe '#getFriendlyPath', ->
    basePath = '/Users/ben/projects/todos/views'
    templatePath = basePath + '/users/show.haml'

    it 'strips away the basePath and extension', ->
      fp = getFriendlyPath templatePath, {basePath, extension: 'haml'}
      expect(fp).to.equal 'users/show'

    it 'is the `friendlyPath` option if the `friendlyPath` option is a string', ->
      fp = getFriendlyPath templatePath, {basePath, extension: 'haml', friendlyPath: 'poop/sauce'}
      expect(fp).to.equal 'poop/sauce'

    it 'is the result of invoking `friendlyPath` option if the `friendlyPath` option is a function', ->
      friendlyPath = (path, absolutePath) ->
        expect(path).to.equal 'users/show'
        expect(absolutePath).to.equal '/Users/ben/projects/todos/views/users/show.haml'

        'friendly/path'

      fp = getFriendlyPath templatePath, {basePath, friendlyPath, extension: 'haml'}
      expect(fp).to.equal 'friendly/path'
