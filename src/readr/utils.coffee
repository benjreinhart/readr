{toString} = Object.prototype

exports.isString = (obj) ->
  toString.call(obj) is '[object String]'

exports.without = (obj, keys...) ->
  result = {}
  result[k] = v for own k, v of obj when (keys.some (key) -> k is key) is false
  result
