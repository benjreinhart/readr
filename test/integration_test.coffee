run = (require 'child_process').execFile

describe 'readr integration tests', ->
  describe 'readr & #sync', ->
    it 'basic file reading', (done) ->
      run 'test/tests/readr_and_readr_sync/basic_file_reading', done

    it 'read all files within a directory', (done) ->
      run 'test/tests/readr_and_readr_sync/read_all_files', done

    it 'reads a single file', (done) ->
      run 'test/tests/readr_and_readr_sync/read_single_file', done

    it '`friendlyPath` is the result of calling the `friendlyPath` option if it is a function', (done) ->
      run 'test/tests/readr_and_readr_sync/friendly_path_function', done

    it 'resulting file objects do not have a `friendlyPath` attribute if `friendlyPath` option is false', (done) ->
      run 'test/tests/readr_and_readr_sync/without_friendly_path', done

    it 'accepts an array of paths as first argument', (done) ->
      run 'test/tests/readr_and_readr_sync/array_of_paths', done

    it 'returns file objects with absolute paths when `absolute` option is true', (done) ->
      run 'test/tests/readr_and_readr_sync/absolute_paths', done

    it 'accepts an `encoding` option with value of "buffer" to return a raw buffer', (done) ->
      run 'test/tests/readr_and_readr_sync/accepts_buffer_encoding_option', done

  describe '#getPaths & #getPathsSync', ->
    it 'basic path globbing', (done) ->
      run 'test/tests/get_paths_and_get_paths_sync/basic_path_globbing', done

    it '`friendlyPath` is the result of calling the `friendlyPath` option if it is a function', (done) ->
      run 'test/tests/get_paths_and_get_paths_sync/friendly_path_function', done

    it 'resulting path objects do not have a `friendlyPath` attribute if `friendlyPath` option is false', (done) ->
      run 'test/tests/get_paths_and_get_paths_sync/without_friendly_path', done

    it 'get all paths within a directory', (done) ->
      run 'test/tests/get_paths_and_get_paths_sync/get_all_paths', done

    it 'get a single path', (done) ->
      run 'test/tests/get_paths_and_get_paths_sync/get_single_file_path', done

    it 'returns path objects with absolute paths when `absolute` option is true', (done) ->
      run 'test/tests/get_paths_and_get_paths_sync/absolute_paths', done

    it 'accepts an array of paths as first argument', (done) ->
      run 'test/tests/get_paths_and_get_paths_sync/array_of_paths', done