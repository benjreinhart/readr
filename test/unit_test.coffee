File = require '../lib/readr/file'
readr = require '../'
sinon = require 'sinon'
{expect} = require 'chai'

describe 'readr unit tests', ->
  beforeEach ->
    sinon.stub File, 'glob', (args...) -> args.pop()(null, [])
    File.glob.sync = sinon.stub().returns []

  afterEach ->
    File.glob.restore()

  describe 'invoking readr', ->
    it 'passes all options to globber', (done) ->
      options =
        absolute: true
        extension: 'mustache'
        exclude: 'path/to/files/file.txt'
        recursive: false

      readr 'path/to/files', options, ->
        expect(File.glob.calledOnce).to.be.true
        expect(File.glob.args[0][0]).to.equal 'path/to/files'
        expect(File.glob.args[0][1]).to.eql
          absolute: true
          extension: 'mustache'
          exclude: 'path/to/files/file.txt'
          recursive: false
          includeDirectories: false
        done()

    it 'always passes `includeDirectories` option as false to globber', (done) ->
      readr 'path/to/files', {includeDirectories: true}, ->
        expect(File.glob.args[0][1]).to.eql {includeDirectories: false}
        done()

  describe '#sync', ->
    it 'passes all options to globber', ->
      readr.sync 'path/to/files',
        absolute: true
        extension: 'mustache'
        exclude: 'path/to/files/file.txt'
        recursive: false

      expect(File.glob.sync.calledOnce).to.be.true
      expect(File.glob.sync.args[0][0]).to.equal 'path/to/files'
      expect(File.glob.sync.args[0][1]).to.eql
        absolute: true
        extension: 'mustache'
        exclude: 'path/to/files/file.txt'
        recursive: false
        includeDirectories: false

    it 'always passes `includeDirectories` option as false to globber', ->
      readr.sync 'path/to/files', {includeDirectories: true}
      expect(File.glob.sync.args[0][1]).to.eql {includeDirectories: false}

  describe '#getPaths', ->
    it 'passes all options to globber', (done) ->
      options =
        absolute: true
        extension: 'mustache'
        exclude: 'path/to/files/file.txt'
        recursive: false

      readr.getPaths 'path/to/files', options, ->
        expect(File.glob.calledOnce).to.be.true
        expect(File.glob.args[0][0]).to.equal 'path/to/files'
        expect(File.glob.args[0][1]).to.eql
          absolute: true
          extension: 'mustache'
          exclude: 'path/to/files/file.txt'
          recursive: false
          includeDirectories: false
        done()

    it 'always passes `includeDirectories` option as false to globber', (done) ->
      readr.getPaths 'path/to/files', {includeDirectories: true}, ->
        expect(File.glob.args[0][1]).to.eql {includeDirectories: false}
        done()

  describe '#sync', ->
    it 'passes all options to globber', ->
      readr.getPathsSync 'path/to/files',
        absolute: true
        extension: 'mustache'
        exclude: 'path/to/files/file.txt'
        recursive: false

      expect(File.glob.sync.calledOnce).to.be.true
      expect(File.glob.sync.args[0][0]).to.equal 'path/to/files'
      expect(File.glob.sync.args[0][1]).to.eql
        absolute: true
        extension: 'mustache'
        exclude: 'path/to/files/file.txt'
        recursive: false
        includeDirectories: false

    it 'always passes `includeDirectories` option as false to globber', ->
      readr.getPathsSync 'path/to/files', {includeDirectories: true}
      expect(File.glob.sync.args[0][1]).to.eql {includeDirectories: false}
