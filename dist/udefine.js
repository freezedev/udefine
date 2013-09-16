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
    var loadModule, platform, resolveModule, udefine;

    platform = hasModule ? 'commonjs' : 'globals';
    resolveModule = function(factory, deps) {
      if (typeof factory === 'function') {
        return factory.apply(this, deps);
      } else {
        return factory;
      }
    };
    loadModule = function(name, type) {
      var path, prePath;

      if (hasModule && typeof udefine[type][name] === 'string') {
        path = require('path');
        prePath = (function() {
          if (udefine.paths[type].base) {
            return udefine.paths[type].base;
          } else {
            return '';
          }
        })();
        return require(path.join(process.cwd(), prePath, udefine[type][name]));
      } else {
        return udefine[type][name];
      }
    };
    udefine = function(name, deps, factory) {
      var dep, depArr, injectName, injectRoot, result, _ref;

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
        depArr = (function() {
          var _i, _len, _results;

          _results = [];
          for (_i = 0, _len = deps.length; _i < _len; _i++) {
            dep = deps[_i];
            _results.push(loadModule(dep, platform));
          }
          return _results;
        })();
        result = resolveModule(factory, depArr);
        if (hasModule) {
          module.exports = result;
        }
        if (!Object.hasOwnProperty.call(udefine[platform], name)) {
          udefine[platform][name] = result;
        }
      }
      if (Object.hasOwnProperty.call(udefine.inject.modules, name)) {
        injectName = udefine.inject.modules[name].name;
        injectRoot = udefine.inject.modules[name].root;
        udefine.inject(injectRoot, injectName)(result);
      }
      return result;
    };
    udefine.inject = function(obj, name) {
      return function(res) {
        if (!((obj != null) && (name != null))) {
          return;
        }
        return obj[name] = res;
      };
    };
    udefine.inject.modules = {};
    udefine.inject.add = function(name) {
      return udefine.inject.modules[name] = void 0;
    };
    udefine.inject.reset = function() {
      return udefine.inject.modules = {};
    };
    udefine.modules = {
      globals: {},
      commonjs: {},
      add: function(name) {},
      remove: function(name) {},
      get: function() {},
      set: function() {}
    };
    udefine.globals || (udefine.globals = {});
    udefine.commonjs || (udefine.commonjs = {});
    udefine.env || (udefine.env = {
      amd: (function() {
        return (typeof define !== "undefined" && define !== null) && (define.amd || define.umd);
      })(),
      commonjs: hasModule,
      browser: !hasModule
    });
    udefine.paths = {
      commonjs: {
        base: void 0
      }
    };
    udefine.defaultConfig = function() {
      var _base;

      (_base = udefine.globals).root || (_base.root = root);
      if (root.define != null) {
        return define('root', function() {
          return root;
        });
      }
    };
    udefine.defaultConfig();
    udefine.configure = function(configFunc) {
      return configFunc.apply(udefine, [root]);
    };
    if (hasModule) {
      return module.exports = udefine;
    } else {
      return root.udefine = udefine;
    }
  })(hasModule ? {} : this);

}).call(this);
