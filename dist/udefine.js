(function() {
  'use strict';
  var exportObject, hasModule, isObject;

  (function() {
    var _ref;

    return (_ref = Array.isArray) != null ? _ref : Array.isArray = function(a) {
      return a.push === Array.prototype.push && (a.length != null);
    };
  })();

  hasModule = (typeof module !== "undefined" && module !== null) && (module.exports != null);

  exportObject = {};

  isObject = function(obj) {
    return typeof obj === 'object' && !Array.isArray(obj);
  };

  (function(root) {
    var loadModule, resolveModule, rootExport, _base, _base1, _base2;

    rootExport = hasModule ? {} : root;
    resolveModule = function(factory, deps) {
      if (typeof factory === 'function') {
        return factory.apply(this, deps);
      } else {
        return factory;
      }
    };
    loadModule = function(name, type) {
      var path, prePath;

      if (hasModule && typeof root.udefine[type][name] === 'string') {
        path = require('path');
        prePath = (function() {
          if (root.udefine.paths[type].base) {
            return root.udefine.paths[type].base;
          } else {
            return '';
          }
        })();
        return require(path.join(process.cwd(), prePath, root.udefine[type][name]));
      } else {
        return root.udefine[type][name];
      }
    };
    root.udefine || (root.udefine = function(name, deps, factory) {
      var dep, depType, globalsArr, injectName, injectRoot, path, requireArr, result, _ref;

      if (name == null) {
        throw new Error('A udefine module needs to have a name');
      }
      if (typeof deps === 'function' || isObject(deps)) {
        _ref = [name, [], deps], name = _ref[0], deps = _ref[1], factory = _ref[2];
      }
      if (typeof define !== "undefined" && define !== null) {
        if (define.amd || define.umd) {
          result = define.apply(this, arguments);
        }
      } else {
        if (hasModule) {
          path = require('path');
          requireArr = (function() {
            var _i, _len, _results;

            _results = [];
            for (_i = 0, _len = deps.length; _i < _len; _i++) {
              dep = deps[_i];
              _results.push(loadModule(dep, 'commonjs'));
            }
            return _results;
          })();
          result = module.exports = resolveModule(factory, requireArr);
        } else {
          globalsArr = (function() {
            var _i, _len, _results;

            _results = [];
            for (_i = 0, _len = deps.length; _i < _len; _i++) {
              dep = deps[_i];
              _results.push(loadModule(dep, 'globals'));
            }
            return _results;
          })();
          result = resolveModule(factory, globalsArr);
        }
        depType = hasModule ? 'commonjs' : 'globals';
        if (!Object.hasOwnProperty.call(root.udefine[depType], name)) {
          root.udefine[depType][name] = result;
        }
      }
      if (Object.hasOwnProperty.call(root.udefine.inject.modules, name)) {
        injectName = root.udefine.inject.modules[name].name;
        injectRoot = root.udefine.inject.modules[name].root;
        root.udefine.inject(injectRoot, injectName)(result);
      }
      return result;
    });
    root.udefine.inject = function(obj, name) {
      return function(res) {
        if (!((obj != null) && (name != null))) {
          return;
        }
        return obj[name] = res;
      };
    };
    root.udefine.inject.modules = {};
    root.udefine.inject.add = function(name) {
      return root.udefine.inject.modules[name] = void 0;
    };
    root.udefine.inject.reset = function() {
      return root.udefine.inject.modules = {};
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
    root.udefine.paths = {
      commonjs: {
        base: void 0
      }
    };
    root.udefine.defaultConfig = function() {
      var _base3;

      (_base3 = root.udefine.globals).root || (_base3.root = rootExport);
      if (root.define != null) {
        return define('root', function() {
          return root;
        });
      }
    };
    root.udefine.defaultConfig();
    root.udefine.configure = function(configFunc) {
      return configFunc.apply(root.udefine, [rootExport]);
    };
    if (hasModule) {
      return module.exports = exportObject.udefine;
    }
  })(hasModule ? exportObject : this);

}).call(this);
