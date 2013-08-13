readr = require '../'
{expect} = require 'chai'

csvLocation = __dirname + '/csv'
mustacheLocation = __dirname + '/mustache'

describe '#readr', ->
  it 'globs for files and adds the default friendlyPath', ->
    expect(readr csvLocation, {extension: 'csv'}).to.eql [
      {
        path: csvLocation + '/people.csv'
        contents: 'Name,Age\njohn,24'
        friendlyPath: 'people'
      }
    ]

    expect(readr mustacheLocation, {extension: 'mustache'}).to.eql [
      {
        path: mustacheLocation + '/index.mustache'
        contents: '<h1>Hello, {{name}}</h1>'
        friendlyPath: 'index'
      }
      {
        path: mustacheLocation + '/show.mustache'
        contents: '<h1>{{user.name}}</h1>'
        friendlyPath: 'show'
      }
    ]

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

      expect(readr mustacheLocation, {friendlyPath, extension: 'mustache'}).to.eql [
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
      ]