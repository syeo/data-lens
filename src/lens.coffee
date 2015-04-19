# get: a -> b
# set: b -> a -> a

class Lens
  @index: (index) ->
    new Lens(
      (arr) -> arr[index]
      (val, arr) -> ((if i is index then val else elem) for elem, i in arr)
    )

  @key: (key) ->
    new Lens(
      (obj) -> obj[key]
      (val, obj) ->
        ret = {}
        (ret[k] = (if k is key then val else v) for k, v of obj)
        return ret
    )

  @compose: (lenses...) ->
    ret = new Lens(
      (obj) -> obj
      (res) -> res
    )

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

  get: (obj) => @getter(obj)
  set: (val, obj) => @setter(val, obj)

module.exports = Lens