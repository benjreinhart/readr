sinon = require 'sinon'
{expect} = require 'chai'
getFriendlyPath = require '../lib/get_friendly_path'

describe '#getFriendlyPath', ->
  baseDir = '/Users/ben/projects/todos/views'
  templatePath = baseDir + '/users/show.haml'

  it 'strips away the baseDir and extension', ->
    fp = getFriendlyPath templatePath, {baseDir, extension: 'haml'}
    expect(fp).to.equal 'users/show'

  it 'is the `friendlyPath` option if the `friendlyPath` option is a string', ->
    fp = getFriendlyPath templatePath, {baseDir, extension: 'haml', friendlyPath: 'poop/sauce'}
    expect(fp).to.equal 'poop/sauce'

  it 'is the result of invoking `friendlyPath` option if the `friendlyPath` option is a function', ->
    friendlyPath = (path, absolutePath) ->
      expect(path).to.equal 'users/show'
      expect(absolutePath).to.equal '/Users/ben/projects/todos/views/users/show.haml'

      'friendly/path'

    fp = getFriendlyPath templatePath, {baseDir, friendlyPath, extension: 'haml'}
    expect(fp).to.equal 'friendly/path'
