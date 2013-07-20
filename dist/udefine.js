(function() {
  'use strict';
  var hasModule, _ref;

  Array.isArray || (Array.isArray = function(a) {
    return a.push === Array.prototype.push && (a.length != null);
  });

  hasModule = (typeof module !== "undefined" && module !== null) && module.exports;

  (function(root) {
    var _base, _base1;

    root.udefine || (root.udefine = function(name, deps, factory) {
      var dep, globalsArr, requireArr, result, _ref1, _ref2;

      if (Array.isArray(name)) {
        _ref1 = [void 0, [], deps], name = _ref1[0], deps = _ref1[1], factory = _ref1[2];
      } else {
        if (typeof name === 'function') {
          _ref2 = [void 0, [], name], name = _ref2[0], deps = _ref2[1], factory = _ref2[2];
        }
      }
      if (typeof define !== "undefined" && define !== null) {
        if (define.amd || define.umd) {
          result = define.apply(this, arguments);
        }
      } else {
        if (hasModule) {
          requireArr = (function() {
            var _i, _len, _results;

            _results = [];
            for (_i = 0, _len = deps.length; _i < _len; _i++) {
              dep = deps[_i];
              _results.push(require(root.udefine.node[dep]));
            }
            return _results;
          })();
          result = module.exports = factory.apply(this);
        } else {
          globalsArr = (function() {
            var _i, _len, _results;

            _results = [];
            for (_i = 0, _len = deps.length; _i < _len; _i++) {
              dep = deps[_i];
              _results.push(root.udefine.globals[dep]);
            }
            return _results;
          })();
          result = factory.apply(this, globalsArr);
        }
      }
      return result;
    });
    (_base = root.udefine).globals || (_base.globals = {});
    (_base1 = root.udefine).commonjs || (_base1.commonjs = {});
    return null;
  })((_ref = typeof module !== "undefined" && module !== null ? module.exports : void 0) != null ? _ref : this);

}).call(this);
