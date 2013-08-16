# Takes two arrays of template objects and does a deep comparison
exports.deepInclude = (results, expectedResults) ->
  expectedResults.every (eR) ->
    results.some (r) ->
      r.path is eR.path and r.contents is eR.contents and r.friendlyPath is eR.friendlyPath
