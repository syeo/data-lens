var Lens,
  bind = function(fn, me){ return function(){ return fn.apply(me, arguments); }; },
  slice = [].slice;

Lens = (function() {
  Lens.id = function() {
    return new Lens(function(obj) {
      return obj;
    }, function(res) {
      return res;
    });
  };

  Lens.index = function(index) {
    return new Lens(function(arr) {
      return arr[index];
    }, function(val, arr) {
      var elem, i, ret;
      ret = (function() {
        var j, len, results;
        results = [];
        for (i = j = 0, len = arr.length; j < len; i = ++j) {
          elem = arr[i];
          results.push(i === index ? val : elem);
        }
        return results;
      })();
      ret[index] || (ret[index] = val);
      return ret;
    });
  };

  Lens.path = function(path) {
    var j, key, len, ref, ret;
    ret = Lens.id();
    ref = path.split('.');
    for (j = 0, len = ref.length; j < len; j++) {
      key = ref[j];
      ret = ret.then(Lens.key(key));
    }
    return ret;
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
      ret[key] || (ret[key] = val);
      return ret;
    });
  };

  Lens.compose = function() {
    var j, len, lens, lenses, ret;
    lenses = 1 <= arguments.length ? slice.call(arguments, 0) : [];
    ret = Lens.id();
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
