{toString} = Object.prototype

exports.isString = (obj) ->
  toString.call(obj) is '[object String]'
