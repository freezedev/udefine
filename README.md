udefine
=======
[![Build Status](https://travis-ci.org/freezedev/udefine.png)](https://travis-ci.org/freezedev/udefine)
[![Dependency Status](https://david-dm.org/freezedev/udefine.png)](https://david-dm.org/freezedev/udefine)
[![devDependency Status](https://david-dm.org/freezedev/udefine/dev-status.png)](https://david-dm.org/freezedev/udefine#info=devDependencies)

This library is _deprecated_. For alternatives, please use a bundler like [Webpack](https://github.com/webpack/webpack) or [http://browserify.org/](browserify).

Define an UMD module like an AMD module and use it (almost) anywhere

This repository is deprecated and will not be updated any more. While it may have been a valid option three years ago (and we used it in production), you may want to use Webpack or rollup today.
If you wish to maintain it further, contact me and I'll happily transfer the repository over to your account.

**Why would you need it?**  
- You are writing that needs to available in Node.js, AMD and/or as global objects  
- You need some kind of basic dependency resolution for your modules  


**Features**  
- Provides a handy function wrapper for UMD modules  
- Same fuction signature as AMD modules  
- No need for boilerplate definitions  
- Less than 0.6 kB minified and gzipped (might increase a bit, but I'll keep it under 1kb)  

**Usage**  
```javascript
(function(root) {
  // This definition only needs to be done once, not per module
  root.udefine.globals.jquery = this.jQuery;
})(this);

udefine('mymodule', ['jquery'], function($) {
  $.fn.myModule = function() { /* ... */ };
});
```

If an AMD module loader like RequireJS has been integrated and configured, 
it will resolve through the AMD loader.


Alright, that's really great for jQuery modules. But what if you want to bind
a module the global namespace if there is no AMD or CommonJS?
Just define where the module should be injected to and udefine will do the rest:

```javascript
udefine.configure(function(root) {
  udefine.inject['myothermodule'] = {
    root: root,
    name: 'myOtherModule'
  };  
});

udefine('myothermodule', function() {
  return {
    a: function() { return 5; },
    b: 2
  };
});

// root.myOtherModule now is an object with the properties a and b.
// (In a non-AMD or non-CommonJS environment.)
```

**CommonJS pitfalls**  
If using `module.exports` for exporting your modules on CommonJS, it does not
export correctly on udefine 0.8.x.
(Exporting with `exports` using the injection API works though.)
To counteract this behavior, you would need a bit of boilerplate code:
```javascript
(function() {
  udefine.configure(function(root) {
    this.globals(function() {
      udefine.inject['mycoolmodule'] = {
        root: root,
        name: 'myCoolModule'
      };  
    });
  });


  udefine('mycoolmodule', function() {
    return {
      a: function() { return 5; },
      b: 2
    };
  });

  if (udefine.env.commonjs) {
    udefine.require('mycoolmodule', function(myCoolModule) {
      module.exports = myCoolModule;
    });
  }

}).call(this);

// root.myOtherModule now is an object with the properties a and b.
// (In a non-AMD or non-CommonJS environment.)
```

udefine is not and does not replace a module loader. It is primarily intended for
developers who want their library to target AMD modules, CommonJS modules and/or
the classic way of binding object to the global window object.

For more examples, take a look at the *examples* folder.

**License**  
This is public domain. See *UNLICENSE.md* for more information.

[![Bitdeli Badge](https://d2weczhvl823v0.cloudfront.net/freezedev/udefine/trend.png)](https://bitdeli.com/free "Bitdeli Badge")

