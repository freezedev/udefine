(function() {
  'use strict';
  var hasModule;

  hasModule = (typeof module !== "undefined" && module !== null) && module.exports;

  (function(root) {
    var _base, _base1, _base2;

    root.udefine || (root.udefine = function(name, deps, factory) {
      var dep, globalsArr, injectName, injectRoot, requireArr, result, _ref;

      if (name == null) {
        throw new Error('A udefine module needs to have a name');
      }
      if (typeof deps === 'function') {
        _ref = [name, [], deps], name = _ref[0], deps = _ref[1], factory = _ref[2];
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
          result = module.exports = factory.apply(this, requireArr);
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
          if (Object.hasOwnProperty.call(root.udefine.globals, name)) {
            root.udefine.globals[name] = result;
          }
          if (Object.hasOwnProperty.call(root.udefine.inject, name)) {
            injectName = root.udefine.inject[name].name;
            injectRoot = root.udefine.inject[name].root;
            root.udefine.inject(injectRoot, injectName)(result);
          }
        }
      }
      return result;
    });
    root.udefine.inject = function(obj, name) {
      return function(res) {
        return obj[name] = res;
      };
    };
    (_base = root.udefine).globals || (_base.globals = {});
    (_base1 = root.udefine).commonjs || (_base1.commonjs = {});
    (_base2 = root.udefine).env || (_base2.env = {
      amd: (function() {
        return (typeof define !== "undefined" && define !== null) && (define.amd || define.umd);
      })(),
      commonjs: hasModule,
      browser: !hasModule
    });
    root.udefine.defaultConfig = function() {
      var _base3;

      (_base3 = root.udefine.globals).root || (_base3.root = root);
      if (root.define != null) {
        return define('root', function() {
          return root;
        });
      }
    };
    root.udefine.defaultConfig();
    return null;
  })(hasModule ? global : this);

}).call(this);
