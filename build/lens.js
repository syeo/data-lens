var Lens,
  bind = function(fn, me){ return function(){ return fn.apply(me, arguments); }; },
  slice = [].slice;

Lens = (function() {
  Lens.index = function(index) {
    return new Lens(function(arr) {
      return arr[index];
    }, function(val, arr) {
      var elem, i, j, len, results;
      results = [];
      for (i = j = 0, len = arr.length; j < len; i = ++j) {
        elem = arr[i];
        results.push(i === index ? val : elem);
      }
      return results;
    });
  };

  Lens.key = function(key) {
    return new Lens(function(obj) {
      return obj[key];
    }, function(val, obj) {
      var k, ret, v;
      ret = {};
      for (k in obj) {
        v = obj[k];
        ret[k] = (k === key ? val : v);
      }
      return ret;
    });
  };

  Lens.compose = function() {
    var j, len, lens, lenses, ret;
    lenses = 1 <= arguments.length ? slice.call(arguments, 0) : [];
    ret = new Lens(function(obj) {
      return obj;
    }, function(res) {
      return res;
    });
    for (j = 0, len = lenses.length; j < len; j++) {
      lens = lenses[j];
      ret = ret.then(lens);
    }
    return ret;
  };

  function Lens(getter, setter) {
    this.getter = getter;
    this.setter = setter;
    this.set = bind(this.set, this);
    this.get = bind(this.get, this);
    this.then = bind(this.then, this);
  }

  Lens.prototype.then = function(lens) {
    var that;
    that = this;
    return new Lens(function(obj) {
      return lens.get(that.get(obj));
    }, function(val, obj) {
      return that.set(lens.set(val, that.get(obj)), obj);
    });
  };

  Lens.prototype.get = function(obj) {
    return this.getter(obj);
  };

  Lens.prototype.set = function(val, obj) {
    return this.setter(val, obj);
  };

  return Lens;

})();

module.exports = Lens;
