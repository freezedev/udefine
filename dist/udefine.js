(function() {
  'use strict';
  var hasModule, _ref;

  Array.isArray || (Array.isArray = function(a) {
    return a.push === Array.prototype.push && (a.length != null);
  });

  hasModule = (typeof module !== "undefined" && module !== null) && module.exports;

  (function(root) {
    root.udefine = function(name, deps, factory) {
      var _ref1, _ref2;

      if (Array.isArray(name)) {
        _ref1 = [void 0, name, deps], name = _ref1[0], deps = _ref1[1], factory = _ref1[2];
      } else {
        if (typeof name === 'function') {
          _ref2 = [void 0, void 0, name], name = _ref2[0], deps = _ref2[1], factory = _ref2[2];
        }
      }
      return (function(factory) {
        if (typeof define !== "undefined" && define !== null) {
          if (define.amd || define.umd) {
            return define.apply(this, arguments);
          }
        } else {
          if (hasModule) {

          } else {

          }
        }
      })(factory);
    };
    return root.udefine.globals = {};
  })((_ref = typeof module !== "undefined" && module !== null ? module.exports : void 0) != null ? _ref : this);

}).call(this);
