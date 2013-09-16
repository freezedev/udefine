udefine
=======
[![Build Status](https://travis-ci.org/freezedev/udefine.png)](https://travis-ci.org/freezedev/udefine)
[![Dependency Status](https://david-dm.org/freezedev/udefine.png)](https://david-dm.org/freezedev/udefine)
[![devDependency Status](https://david-dm.org/freezedev/udefine/dev-status.png)](https://david-dm.org/freezedev/udefine#info=devDependencies)

Define a module as an AMD module and handle it as if it's an UMD module

**Features**  
* Provides a handy function wrapper for UMD modules
* Same fuction signature as AMD modules
* No need for boilerplate definitions
* Less than 0.6 kB minified and gzipped (might increase a bit, but I'll keep it under 1kb)

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
(function(root) {
  root.udefine.inject['myothermodule'] = {
    root: root,
    name: 'myOtherModule'
  };
})(this);

udefine('myothermodule', function() {
  return {
    a: function() { return 5; },
    b: 2
  };
});

// root.myOtherModule now is an object with the properties a and b.
// (In a non-AMD or non-CommonJS environment.)
```


udefine is not and does not replace a module loader. It is primarily intended for
developers who want their library to target AMD modules, CommonJS modules and/or
the classic way of binding object to the global window object.

For more examples, take a look at the *examples* folder.

**License**  
This is public domain. See *UNLICENSE.md* for more information.