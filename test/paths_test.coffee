sinon = require 'sinon'
{expect} = require 'chai'
fsHelpers = require '../lib/readr/fs_helpers'
{getPaths, getPathsSync} = require '../lib/readr/paths'

describe 'readr/paths', ->
  _paths = [
    '/path/to/directory'
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
    it 'asynchronously returns paths at a specified location', (done) ->
      getPaths '/path/to', (err, paths) ->
        expect(fsHelpers.glob.called).to.be.true
        expect(fsHelpers.glob.calledOnce).to.be.true
        expect(fsHelpers.glob.args[0][0]).to.equal '/path/to/**/*'

        expect(paths).to.eql [
          '/path/to/directory'
          '/path/to/directory/file.txt'
          '/path/to/directory/file2.txt'
        ]

        done()

    it 'asynchronously returns file paths only when `filesOnly` options is provided', (done) ->
      getPaths '/path/to', {filesOnly: true}, (err, paths) ->
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

    it 'passes all other options besides `filesOnly` and `extension` to glob', (done) ->
      getPaths '/path/to', {extension: 'txt', filesOnly: true, opt: true, opt2: false}, (err, paths) ->
        expect(fsHelpers.glob.called).to.be.true
        expect(fsHelpers.glob.calledOnce).to.be.true
        expect(fsHelpers.glob.args[0][1]).to.eql {opt: true, opt2: false}

        done()


  describe '#getPathsSync', ->
    it 'synchronously returns file paths at a specified location', ->
      paths = getPathsSync '/path/to/'

      expect(fsHelpers.globSync.called).to.be.true
      expect(fsHelpers.globSync.calledOnce).to.be.true
      expect(fsHelpers.globSync.args[0][0]).to.equal '/path/to/**/*'

      expect(paths).to.eql [
        '/path/to/directory'
        '/path/to/directory/file.txt'
        '/path/to/directory/file2.txt'
      ]

    it 'synchronously returns file paths only when `filesOnly` options is provided', ->
      paths = getPathsSync '/path/to/', {filesOnly: true}

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

    it 'passes all other options besides `filesOnly` and `extension` to glob', ->
      paths = getPathsSync '/path/to/', {extension: 'txt', filesOnly: true, opt: true, opt2: false}

      expect(fsHelpers.globSync.called).to.be.true
      expect(fsHelpers.globSync.calledOnce).to.be.true
      expect(fsHelpers.globSync.args[0][1]).to.eql {opt: true, opt2: false}
