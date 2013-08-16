fs = require 'fs'
sinon = require 'sinon'
{expect} = require 'chai'
fsHelpers = require '../lib/readr/fs_helpers'

testDir = __dirname

describe 'readr/fs_helpers', ->
  describe '#isFile', ->
    {isFile} = fsHelpers

    it 'asynchronously returns true if the path is a file', (done) ->
      isFile testDir + '/csv/people.csv', (err, file) ->
        expect(file).to.be.true
        done()

    it 'asynchronously returns false if the path is a directory', (done) ->
      isFile testDir + '/csv', (err, file) ->
        expect(file).to.be.false
        done()

    it 'asynchronously returns an error if path does not exist', (done) ->
      isFile testDir + '/not_existent_path', (err, file) ->
        expect(err).to.be.an.instanceof Error
        done()

  describe '#isFileSync', ->
    {isFileSync} = fsHelpers

    it 'synchronously returns true if the path is a file', ->
      expect(isFileSync testDir + '/csv/people.csv').to.be.true

    it 'synchronously returns false if the path is a file', ->
      expect(isFileSync testDir + '/csv').to.be.false

    it 'throws an error if path does not exist', ->
      nonExistentPath = -> isFileSync testDir + '/not_existent_path'
      expect(nonExistentPath).to.throw /ENOENT/

  describe '#readFile', ->
    {readFile} = fsHelpers

    beforeEach ->
      sinon.stub(fs, 'readFile')
      sinon.stub(fs, 'readFileSync')

    afterEach ->
      fs.readFile.restore()
      fs.readFileSync.restore()

    it 'reads a file synchronously when no callback argument is provided', ->
      readFile '/path/to/file.txt'

      expect(fs.readFile.called).to.be.false
      expect(fs.readFileSync.called).to.be.true
      expect(fs.readFileSync.firstCall.args[0]).to.equal '/path/to/file.txt'

    it 'reads a file asynchronously when a callback argument is provided', ->
      readFile '/path/to/file.txt', ->

      expect(fs.readFile.called).to.be.true
      expect(fs.readFileSync.called).to.be.false
      expect(fs.readFile.firstCall.args[0]).to.equal '/path/to/file.txt'

    describe 'fs#readFile and fs#readFileSync second argument', ->
      originalNodeVersion = process.version

      afterEach ->
        process.version = originalNodeVersion

      it 'is an object with an encoding attribute when node version is 10 or higher', ->
        process.version = 'v0.10.0'

        readFile '/path/to/file.txt'
        readFile '/path/to/file.txt', ->

        expect(fs.readFile.firstCall.args[0]).to.equal '/path/to/file.txt'
        expect(fs.readFile.firstCall.args[1]).to.eql {encoding: 'utf8'}

        expect(fs.readFileSync.firstCall.args[0]).to.equal '/path/to/file.txt'
        expect(fs.readFileSync.firstCall.args[1]).to.eql {encoding: 'utf8'}

        process.version = 'v0.11.13'

        readFile '/path/to/file.txt'
        readFile '/path/to/file.txt', ->

        expect(fs.readFile.secondCall.args[0]).to.equal '/path/to/file.txt'
        expect(fs.readFile.secondCall.args[1]).to.eql {encoding: 'utf8'}

        expect(fs.readFileSync.secondCall.args[0]).to.equal '/path/to/file.txt'
        expect(fs.readFileSync.secondCall.args[1]).to.eql {encoding: 'utf8'}


      it 'is the string "utf8" if the node version is less than 10', ->
        process.version = 'v0.8.0'

        readFile '/path/to/file.txt'
        readFile '/path/to/file.txt', ->

        expect(fs.readFile.firstCall.args[0]).to.equal '/path/to/file.txt'
        expect(fs.readFile.firstCall.args[1]).to.equal 'utf8'

        expect(fs.readFileSync.firstCall.args[0]).to.equal '/path/to/file.txt'
        expect(fs.readFileSync.firstCall.args[1]).to.equal 'utf8'

        process.version = 'v0.9.13'

        readFile '/path/to/file.txt'
        readFile '/path/to/file.txt', ->

        expect(fs.readFile.secondCall.args[0]).to.equal '/path/to/file.txt'
        expect(fs.readFile.secondCall.args[1]).to.equal 'utf8'

        expect(fs.readFileSync.secondCall.args[0]).to.equal '/path/to/file.txt'
        expect(fs.readFileSync.secondCall.args[1]).to.equal 'utf8'
