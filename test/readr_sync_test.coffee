readr = require '../'
{expect} = require 'chai'

testDir = __dirname
csvLocation = testDir + '/csv'
mustacheLocation = testDir + '/mustache'

describe 'readr#sync', ->
  it 'globs for files and adds the default friendlyPath', ->
    expect(readr.sync testDir, {extension: 'csv'}).to.eql [
      {
        path: csvLocation + '/people.csv'
        contents: 'Name,Age\njohn,24'
        friendlyPath: 'csv/people'
      }
    ]

    files = readr.sync testDir, {extension: 'mustache'}
    files = files.sort (file) -> file.path

    expect(files).to.eql [
      {
        path: mustacheLocation + '/index.mustache'
        contents: '<h1>Hello, {{name}}</h1>'
        friendlyPath: 'mustache/index'
      }
      {
        path: mustacheLocation + '/nested_dir/nested_dir_2/nested_dir_3/nested_file.mustache'
        contents: '<header>NESTED DIR!!!!</header>'
        friendlyPath: 'mustache/nested_dir/nested_dir_2/nested_dir_3/nested_file'
      }
      {
        path: mustacheLocation + '/show.mustache'
        contents: '<h1>{{user.name}}</h1>'
        friendlyPath: 'mustache/show'
      }
    ]


  it 'returns a single file with only the extension removed when no `friendlyPath` option is provided', ->
    files = readr.sync csvLocation + '/people.csv', {extension: 'csv'}

    expect(files.length).to.equal 1
    expect(files[0]).to.eql
      path: csvLocation + '/people.csv'
      contents: 'Name,Age\njohn,24'
      friendlyPath: csvLocation + '/people'

  it "doesn't choke on a path with a trailing slash", ->
    files = readr.sync testDir + '/', {extension: 'csv'}

    expect(files.length).to.equal 1
    expect(files[0]).to.eql
      path: csvLocation + '/people.csv'
      contents: 'Name,Age\njohn,24'
      friendlyPath: 'csv/people'

  describe '`friendlyPath` option', ->
    it 'is the `friendlyPath` option if `friendlyPath` option is a string', ->
      options = {friendlyPath: 'peoplecsv', extension: 'csv'}
      files = readr.sync csvLocation + '/people.csv', options

      expect(files.length).to.equal 1
      expect(files[0]).to.eql
        path: csvLocation + '/people.csv'
        contents: 'Name,Age\njohn,24'
        friendlyPath: 'peoplecsv'

    it 'is the absolute path if no friendly option is provided and path argument is a file', ->
      files = readr.sync csvLocation + '/people.csv'

      expect(files.length).to.equal 1
      expect(files[0]).to.eql
        path: csvLocation + '/people.csv'
        contents: 'Name,Age\njohn,24'
        friendlyPath: csvLocation + '/people.csv'

    it 'invokes the `friendlyPath` option if `friendlyPath` option is a function', ->
      friendlyPath = (path) -> 'dashboard/' + path

      files = readr.sync mustacheLocation, {friendlyPath, extension: 'mustache'}
      files = files.sort (file) -> file.path

      expect(files).to.eql [
        {
          path: mustacheLocation + '/index.mustache'
          contents: '<h1>Hello, {{name}}</h1>'
          friendlyPath: 'dashboard/index'
        }
        {
          path: mustacheLocation + '/nested_dir/nested_dir_2/nested_dir_3/nested_file.mustache'
          contents: '<header>NESTED DIR!!!!</header>'
          friendlyPath: 'dashboard/nested_dir/nested_dir_2/nested_dir_3/nested_file'
        }
        {
          path: mustacheLocation + '/show.mustache'
          contents: '<h1>{{user.name}}</h1>'
          friendlyPath: 'dashboard/show'
        }
      ]

    it 'does not add a `friendlyPath` to the resulting object if the `friendlyPath` option is false for an individual file', ->
      files = readr.sync csvLocation + '/people.csv', {friendlyPath: false, extension: 'csv'}

      expect(files.length).to.equal 1
      expect(files[0]).to.eql
        path: csvLocation + '/people.csv'
        contents: 'Name,Age\njohn,24'

    it 'does not add a `friendlyPath` to the resulting object if the `friendlyPath` option is false for a glob of files', ->
      files = readr.sync mustacheLocation, {friendlyPath: false, extension: 'mustache'}
      files = files.sort (file) -> file.path

      expect(files).to.eql [
        {
          path: mustacheLocation + '/index.mustache'
          contents: '<h1>Hello, {{name}}</h1>'
        }
        {
          path: mustacheLocation + '/nested_dir/nested_dir_2/nested_dir_3/nested_file.mustache'
          contents: '<header>NESTED DIR!!!!</header>'
        }
        {
          path: mustacheLocation + '/show.mustache'
          contents: '<h1>{{user.name}}</h1>'
        }
      ]
