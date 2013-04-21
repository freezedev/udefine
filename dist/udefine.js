(function() {
  'use strict';
  var hasModule, udefine;

  hasModule = (typeof module !== "undefined" && module !== null) && module.exports;

  udefine = function(name, deps, factory) {
    var _ref, _ref1;

    if (Array.isArray(name)) {
      _ref = [void 0, name, deps], name = _ref[0], deps = _ref[1], factory = _ref[2];
    } else {
      if (typeof name === 'function') {
        _ref1 = [void 0, void 0, name], name = _ref1[0], deps = _ref1[1], factory = _ref1[2];
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

  udefine.globals = {};

}).call(this);
