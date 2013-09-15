'use strict'

# ES5 shims
do -> Array.isArray ?= (a) -> a.push is Array.prototype.push and a.length?

# Module switch
hasModule = module? and module.exports?
exportObject = {}

# Safe way to test against an object without array being a false positive
isObject = (obj) -> typeof obj is 'object' and not Array.isArray(obj)

# Root object hook
# TODO: Don't bind it directly to the root object
# Use udefine in a closure and then bind to the specific objects afterwards
do (root = if hasModule then exportObject else this) ->
  rootExport = if hasModule then {} else root
  
  # Helper function to resolve a module (either function or object)
  resolveModule = (factory, deps) ->
    if typeof factory is 'function'
      factory.apply @, deps
    else
      factory
  
  loadModule = (name, type) ->
    if hasModule and typeof root.udefine[type][name] is 'string'
      path = require 'path'
      prePath = do ->
        if root.udefine.paths[type].base
          root.udefine.paths[type].base
        else
          ''
      require path.join(process.cwd(), prePath, root.udefine[type][name])
    else
      root.udefine[type][name]
  
  # Main entry point
  root.udefine or= (name, deps, factory) ->
    throw new Error 'A udefine module needs to have a name' unless name?
    
    if typeof deps is 'function' or isObject(deps)
      [name, deps, factory] = [name, [], deps]
      
    # Define, either AMD or UMD (if any?)
    if define?
      result = define.apply @, arguments if define.amd or define.umd
    else
      if hasModule
        path = require 'path'
        
        requireArr = (loadModule(dep, 'commonjs') for dep in deps)
        
        # Common JS
        result = module.exports = resolveModule factory, requireArr
      else
        # Usual browser environment
        globalsArr = (loadModule(dep, 'globals') for dep in deps)
        
        result = resolveModule factory, globalsArr
                
      # Set dependency if it does not exist
      depType = if hasModule then 'commonjs' else 'globals'
      unless Object.hasOwnProperty.call root.udefine[depType], name
        root.udefine[depType][name] = result
        
        
    # Inject result into defined namespace
    if Object.hasOwnProperty.call root.udefine.inject.modules, name
      injectName = root.udefine.inject.modules[name].name
      injectRoot = root.udefine.inject.modules[name].root
      
      root.udefine.inject(injectRoot, injectName)(result)
        
    result
  
  # Helper function to inject function/object into any object
  root.udefine.inject = (obj, name) -> (res) ->
    return unless obj? and name?
    obj[name] = res
  
  root.udefine.inject.modules = {}
  
  root.udefine.inject.add = (name) ->
    root.udefine.inject.modules[name] = undefined
    
  root.udefine.inject.reset = -> root.udefine.inject.modules = {}
  
  # TODO: Reflect if these two object could and should be merged together
  # Dependencies for browser (global object)
  # Different idea:
  #   Provide udefine.modules
  #     with functions .add .remove .get .set
  #     where you could define the type and it will also export the
  #     commonjs and globals objects
  #     .get and .set would only get and set the dependency for the
  #     current platform
  root.udefine.globals or= {}
  
  # Dependencies for node.js or commonjs environments
  root.udefine.commonjs or= {}
  
  # Default settings for udefine environment
  root.udefine.env or=
    amd: do -> define? and (define.amd or define.umd)
    commonjs: hasModule
    browser: not hasModule
  
  # Paths
  root.udefine.paths =
    commonjs:
      base: undefined
  
  # Default configuration definition
  root.udefine.defaultConfig = ->
    root.udefine.globals.root or= rootExport
  
    define('root', -> root) if root.define?
  
  # Call default configuration
  root.udefine.defaultConfig()
  
  # Configuration helper function
  root.udefine.configure = (configFunc) ->
    configFunc.apply root.udefine, [rootExport]
  
  # Export udefine function on CommonJS environments
  module.exports = exportObject.udefine if hasModule