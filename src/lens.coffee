# get: a -> b
# set: b -> a -> a

class Lens
  @id: () ->
    new Lens(
      (obj) -> obj
      (res) -> res
    )

  @index: (index) ->
    new Lens(
      (arr) -> if arr? then arr[index] else undefined
      (val, arr) ->
        ret = (elem for elem, i in arr)
        ret[index] = val

        return ret
    )

  @path: (path) ->
    ret = Lens.id()

    for key in path.split('.')
      ret = ret.then(Lens.key(key))

    return ret

  @key: (key) ->
    new Lens(
      (obj) -> if obj? then obj[key] else undefined
      (val, obj) ->
        ret = {}

        for k, v of obj
          ret[k] = v
        ret[key] = val

        return ret
    )

  @compose: (lenses...) ->
    ret = Lens.id()

    for lens in lenses
      ret = ret.then(lens)

    return ret

  constructor: (@getter, @setter) ->

  then: (lens) =>
    that = @
    new Lens(
      (obj) -> lens.get(that.get(obj))
      (val, obj) -> that.set(lens.set(val, that.get(obj)), obj)
    )

  key: (key) => @then(Lens.key(key))

  index: (index) => @then(Lens.index(index))

  path: (path) => @then(Lens.path(path))

  get: (obj) => @getter(obj)
  set: (val, obj) => @setter(val, obj)

module.exports = Lens