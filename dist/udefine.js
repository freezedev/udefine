(function() {
  'use strict';
  var exportObject, hasModule, isObject,
    __hasProp = {}.hasOwnProperty;

  (function() {
    var _ref;

    return (_ref = Array.isArray) != null ? _ref : Array.isArray = function(a) {
      return a.push === Array.prototype.push && (a.length != null);
    };
  })();

  hasModule = !!((typeof module !== "undefined" && module !== null) && module.exports);

  exportObject = {};

  isObject = function(obj) {
    return typeof obj === 'object' && !Array.isArray(obj);
  };

  (function(root) {
    var loadModule, platform, platforms, resolveModule, udefinable, udefine;

    platforms = ['commonjs', 'globals'];
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

      if (hasModule && typeof udefine.modules[type][name] === 'string') {
        path = require('path');
        prePath = (function() {
          if (udefine.paths[type].base) {
            return udefine.paths[type].base;
          } else {
            return '';
          }
        })();
        return require(path.join(process.cwd(), prePath, udefine.modules[type][name]));
      } else {
        return udefine.modules[type][name];
      }
    };
    udefinable = function(name, deps, factory, exportable) {
      var dep, depArr, ignoreName, injectName, injectObject, injectRoot, result, _ref;

      if (name == null) {
        throw new Error('A udefine module needs to have a name');
      }
      if (Array.isArray(name)) {
        throw new Error('Anonymous module are not allowed');
      }
      if (name !== name.toLowerCase()) {
        console.warn('A module should be all lowercase');
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
        if (!Object.hasOwnProperty.call(udefine.modules[platform], name)) {
          udefine.modules[platform][name] = result;
        }
      }
      if (!Object.hasOwnProperty.call(udefine.inject.modules, name)) {
        if (exportable) {
          udefine.inject.add(name, {
            root: exportable,
            name: name,
            ignoreName: true
          });
        } else {
          if (udefine.autoInject) {
            if (udefine.env.globals) {
              udefine.inject.add(name, {
                root: root,
                name: name
              });
            }
            if (udefine.env.commonjs) {
              udefine.inject.add(name, {
                root: exports,
                name: name,
                ignoreName: true
              });
            }
          }
        }
      }
      if (Object.hasOwnProperty.call(udefine.inject.modules, name)) {
        injectObject = udefine.inject.modules[name];
        injectRoot = injectObject.root, injectName = injectObject.name, ignoreName = injectObject.ignoreName;
        udefine.inject(injectRoot, injectName, ignoreName)(result);
      }
      return result;
    };
    udefine = function(name, deps, factory) {
      return udefinable(name, deps, factory);
    };
    udefine.autoInject = true;
    udefine.inject = function(obj, name, ignoreName) {
      return function(res) {
        if (!((obj != null) && (name != null))) {
          return;
        }
        if (ignoreName) {
          return obj || (obj = res);
        } else {
          return obj[name] || (obj[name] = res);
        }
      };
    };
    udefine.inject.modules = {};
    udefine.inject.add = function(name, value) {
      if (name == null) {
        return;
      }
      if (value == null) {
        value = {};
      }
      if (value.root == null) {
        value.root = root;
      }
      if (value.name == null) {
        value.name = name;
      }
      udefine.inject.modules[name] = value;
      return this;
    };
    udefine.inject.remove = function(name) {
      delete udefine.inject.modules[name];
      return this;
    };
    udefine.inject.clear = function() {
      udefine.inject.modules = {};
      return this;
    };
    udefine.modules = {
      globals: {},
      commonjs: {},
      add: function(name, value) {
        var key, v, val, _i, _len;

        if (typeof name === 'object') {
          for (key in name) {
            val = name[key];
            this.add(key, val);
          }
        } else {
          if (value) {
            if (Array.isArray(value)) {
              for (_i = 0, _len = value.length; _i < _len; _i++) {
                v = value[_i];
                udefine.modules[v][name] = void 0;
              }
            } else {
              udefine.modules.set(name, value);
            }
          } else {
            udefine.modules[platform][name] = void 0;
          }
        }
        return this;
      },
      remove: function(name) {
        var p, _i, _len;

        for (_i = 0, _len = platforms.length; _i < _len; _i++) {
          p = platforms[_i];
          if (Object.hasOwnProperty.call(udefine.modules[p], name)) {
            delete udefine.modules[p][name];
          }
        }
        return this;
      },
      get: function(name) {
        return udefine.modules[platform][name];
      },
      set: function(name, value) {
        var k, v;

        if (typeof value === 'object') {
          for (k in value) {
            v = value[k];
            udefine.modules[k][name] = v;
          }
        } else {
          udefine.modules[platform][name] = value;
        }
        return this;
      },
      clear: function() {
        var p, _i, _len;

        for (_i = 0, _len = platforms.length; _i < _len; _i++) {
          p = platforms[_i];
          udefine.modules[p] = {};
        }
        return this;
      }
    };
    udefine.env || (udefine.env = {
      amd: (function() {
        return (typeof define !== "undefined" && define !== null) && (define.amd || define.umd);
      })(),
      commonjs: hasModule,
      browser: !hasModule,
      globals: !hasModule && !udefine.amd
    });
    udefine.paths = {
      commonjs: {
        base: void 0
      }
    };
    udefine.require = function(name, callback) {
      var n, reqDeps;

      if (!Array.isArray(name)) {
        name = [name];
      }
      reqDeps = (function() {
        var _i, _len, _results;

        _results = [];
        for (_i = 0, _len = name.length; _i < _len; _i++) {
          n = name[_i];
          _results.push(udefine.modules.get(n));
        }
        return _results;
      })();
      return callback.apply(this, reqDeps);
    };
    udefine.defaultConfig = function() {
      udefine.modules.commonjs.root = root;
      udefine.modules.globals.root = root;
      if (root.define != null) {
        return define('root', function() {
          return root;
        });
      }
    };
    udefine.defaultConfig();
    udefine.configure = function(configFunc) {
      var context, e, _ref,
        _this = this;

      context = {};
      _ref = udefine.env;
      for (e in _ref) {
        if (!__hasProp.call(_ref, e)) continue;
        context[e] = function(platformDef) {
          if (udefine.env[e]) {
            return platformDef.call(_this);
          }
        };
      }
      return configFunc.apply(context, [root, udefine]);
    };
    udefine.exports = function(exportable) {
      return function(name, deps, factory) {
        return udefinable(name, deps, factory, exportable);
      };
    };
    if (hasModule) {
      return module.exports = udefine;
    } else {
      return root.udefine = udefine;
    }
  })(hasModule ? {} : this);

}).call(this);
