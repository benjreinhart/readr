# readr

Flexible Node.js file reading library.

Readr is a library that abstracts reading files from disk. It supports recursively reading multiple files in a directory by extension or reading an individual file via a clean API. Readr's API provides both sync and async operations.

[http://benjreinhart.github.io/readr](http://benjreinhart.github.io/readr)

## What can readr do for you?

readr is a tool to read files by type (extension) and return a formatted object with the following properties:

* `path` - the absolute path of the file
* `contents` - the contents of the file
* `friendlyPath` (optional) a formatted string better suited for referencing the file

## Basic Example

Given the following directory tree:

```
/path/to/files/
  * some_directory/
    * file.txt
    * another_file.txt
    * csv_file.csv
```

find all .txt files

```javascript
var readr = require('readr');
readr('/path/to/files', {extension: 'txt'}, function(err, files) {
  console.log(files)
});
/*
  [
    {
      path: '/path/to/files/some_directory/file.txt',
      contents: 'Contents of file.txt',
      friendlyPath: 'some_directory/file'
    },
    {
      path: '/path/to/files/some_directory/another_file.txt',
      contents: 'Contents of another_file.txt',
      friendlyPath: 'some_directory/another_file'
    }
  ]
*/
```

## Installing

`npm install readr`

`var readr = require('readr');`


## API

#### readr(path[, options], callback)

Async.

`path` can be either a directory or a file. If it is a directory, then it will glob for files with an extension equal to the `extension` option and return an array of files found. If it is a file, it will return an array (for consistency) with one result (the file).

`options` can be the following:

* `extension` (string) - the type of files to read
* `friendlyPath` (string|function|bool)
  * string - any/all files will have a `friendlyPath` attribute equal to the `friendlyPath` option
  * function - will invoke the function for each file found, passing it `(path, absolutePath)` where `path` is the absolute path minus the extension and optionally minus the base directory. The result of this call will be the `friendlyPath` of the file object.
  * bool - if `false`, the resulting file objects will have no `friendlyPath` attribute


#### readr.sync(path[, options])

Synchronous version of `readr`.


## License

(The MIT License)

Copyright (c) 2013 Ben Reinhart

Permission is hereby granted, free of charge, to any person obtaining
a copy of this software and associated documentation files (the
'Software'), to deal in the Software without restriction, including
without limitation the rights to use, copy, modify, merge, publish,
distribute, sublicense, and/or sell copies of the Software, and to
permit persons to whom the Software is furnished to do so, subject to
the following conditions:

The above copyright notice and this permission notice shall be
included in all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED 'AS IS', WITHOUT WARRANTY OF ANY KIND,
EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF
MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT.
IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY
CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT,
TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE
SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.