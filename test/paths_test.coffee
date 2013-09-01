sinon = require 'sinon'
{expect} = require 'chai'
fsHelpers = require '../lib/readr/fs_helpers'
{getPaths, getPathsSync} = require '../lib/readr/paths'

describe 'readr/paths', ->
  _paths = [
    '/path/to/directory/file.txt'
    '/path/to/directory/file2.txt'
  ]

  beforeEach ->
    sinon.stub(fsHelpers, 'glob', ((args...) -> args[args.length - 1] null, _paths))
    sinon.stub(fsHelpers, 'globSync', (-> _paths))
    sinon.stub(fsHelpers, 'isFile', ((path) -> path isnt '/path/to/directory'))

  afterEach ->
    fsHelpers.glob.restore()
    fsHelpers.globSync.restore()
    fsHelpers.isFile.restore()

  describe '#getPaths', ->
    it 'asynchronously returns all file paths', (done) ->
      getPaths '/path/to', (err, paths) ->
        expect(fsHelpers.glob.called).to.be.true
        expect(fsHelpers.glob.calledOnce).to.be.true
        expect(fsHelpers.glob.args[0][0]).to.equal '/path/to/**/*'

        expect(paths).to.eql [
          '/path/to/directory/file.txt'
          '/path/to/directory/file2.txt'
        ]

        done()

    it 'asynchronously globs only for files with the extension specified in the options', (done) ->
      getPaths '/path/to', {extension: 'txt'}, (err, paths) ->
        expect(fsHelpers.glob.called).to.be.true
        expect(fsHelpers.glob.calledOnce).to.be.true
        expect(fsHelpers.glob.args[0][0]).to.equal '/path/to/**/*.txt'

        done()


  describe '#getPathsSync', ->
    it 'synchronously returns all file paths', ->
      paths = getPathsSync '/path/to/'

      expect(fsHelpers.globSync.called).to.be.true
      expect(fsHelpers.globSync.calledOnce).to.be.true
      expect(fsHelpers.globSync.args[0][0]).to.equal '/path/to/**/*'

      expect(paths).to.eql [
        '/path/to/directory/file.txt'
        '/path/to/directory/file2.txt'
      ]

    it 'synchronously globs only for files with the extension specified in the options', ->
      paths = getPathsSync '/path/to/', {extension: 'txt'}

      expect(fsHelpers.globSync.called).to.be.true
      expect(fsHelpers.globSync.calledOnce).to.be.true
      expect(fsHelpers.globSync.args[0][0]).to.equal '/path/to/**/*.txt'
