readr = require '../'
{expect} = require 'chai'

testDir = __dirname

csvLocation = testDir + '/csv'
mustacheLocation = testDir + '/mustache'

# Takes two arrays of template objects and does a deep comparison
deepInclude = (results, expectedResults) ->
  expectedResults.every (eR) ->
    results.some (r) ->
      r.path is eR.path and r.contents is eR.contents and r.friendlyPath is eR.friendlyPath


describe '#readr', ->
  it 'globs for files and adds the default friendlyPath', ->
    expect(readr testDir, {extension: 'csv'}).to.eql [
      {
        path: csvLocation + '/people.csv'
        contents: 'Name,Age\njohn,24'
        friendlyPath: 'csv/people'
      }
    ]

    results = readr testDir, {extension: 'mustache'}
    expect(results.length).to.equal 3

    expectedResults = [
      {
        path: mustacheLocation + '/index.mustache'
        contents: '<h1>Hello, {{name}}</h1>'
        friendlyPath: 'mustache/index'
      }
      {
        path: mustacheLocation + '/show.mustache'
        contents: '<h1>{{user.name}}</h1>'
        friendlyPath: 'mustache/show'
      }
      {
        path: mustacheLocation + '/nested_dir/nested_dir_2/nested_dir_3/nested_file.mustache'
        contents: '<header>NESTED DIR!!!!</header>'
        friendlyPath: 'mustache/nested_dir/nested_dir_2/nested_dir_3/nested_file'
      }
    ]

    expect(deepInclude results, expectedResults).to.be.true


  it 'returns a single file with only the extension removed when no `friendlyPath` option is provided', ->
    expect(readr csvLocation + '/people.csv', {extension: 'csv'}).to.eql
      path: csvLocation + '/people.csv'
      contents: 'Name,Age\njohn,24'
      friendlyPath: csvLocation + '/people'

  describe '`friendlyPath` option', ->
    it 'is the `friendlyPath` option if `friendlyPath` option is a string', ->
      options = {friendlyPath: 'peoplecsv', extension: 'csv'}

      expect(readr csvLocation + '/people.csv', options).to.eql
        path: csvLocation + '/people.csv'
        contents: 'Name,Age\njohn,24'
        friendlyPath: 'peoplecsv'

    it 'invokes the `friendlyPath` option if `friendlyPath` option is a function', ->
      friendlyPath = (path) -> 'dashboard/' + path

      results = readr mustacheLocation, {friendlyPath, extension: 'mustache'}

      expectedResults = [
        {
          path: mustacheLocation + '/index.mustache'
          contents: '<h1>Hello, {{name}}</h1>'
          friendlyPath: 'dashboard/index'
        }
        {
          path: mustacheLocation + '/show.mustache'
          contents: '<h1>{{user.name}}</h1>'
          friendlyPath: 'dashboard/show'
        }
        {
          path: mustacheLocation + '/nested_dir/nested_dir_2/nested_dir_3/nested_file.mustache'
          contents: '<header>NESTED DIR!!!!</header>'
          friendlyPath: 'dashboard/nested_dir/nested_dir_2/nested_dir_3/nested_file'
        }
      ]

      expect(deepInclude results, expectedResults).to.be.true
