# readr

Node.js file reading and formatting library

## Installing

`npm install readr`

```javascript
var readr = require('readr');

files = readr('/path/to/files', {extension: 'txt'})
/*
  [
    {
      path: '/path/to/files/some_directory/file.txt',
      contents: 'This is a file.',
      friendlyPath: 'some_directory/file'
    }
  ]
*/
```

## What can readr do for you?

readr is a tool to read files by type (extension) and return a formatted object with the following properties:

* `path` - the absolute path of the file
* `contents` - the contents of the file
* `friendlyPath` a formatted string representing the file location


## API

##### readr(baseDirectoryOrFilePath, options)

`options` can be the following:

* `extension` (string) - the type of files to read
* `friendlyPath` (string|function)
  * string - any/all files will have a `friendlyPath` attribute equal to the `friendlyPath` option passed in
  * function - will invoke the function for each file found, passing it `(path, absolutePath)` where `path` is the absolute path minus the extension and optionally minus the base directory. The result of this call will be the `friendlyPath` of the file object.

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