'use strict'

# ES5 shims
do -> Array.isArray ?= (a) -> a.push is Array.prototype.push and a.length?

# Module switch
hasModule = module? and module.exports?
exportObject = {}

# Safe way to test against an object without array being a false positive
isObject = (obj) -> typeof obj is 'object' and not Array.isArray(obj)

# Root object hook
# Use udefine in the closure and then bind to the specific objects afterwards
do (root = if hasModule then {} else this) ->
  platform = if hasModule then 'commonjs' else 'globals'
  
  # Helper function to resolve a module (either function or object)
  resolveModule = (factory, deps) ->
    if typeof factory is 'function'
      factory.apply @, deps
    else
      factory
  
  loadModule = (name, type) ->
    if hasModule and typeof udefine[type][name] is 'string'
      path = require 'path'
      prePath = do ->
        if udefine.paths[type].base
          udefine.paths[type].base
        else
          ''
      require path.join(process.cwd(), prePath, udefine[type][name])
    else
      udefine[type][name]
  
  # Main entry point
  udefine = (name, deps, factory) ->
    throw new Error 'A udefine module needs to have a name' unless name?
    
    if typeof deps is 'function' or isObject(deps)
      [name, deps, factory] = [name, [], deps]
      
    # Define, either AMD or UMD (if any?)
    if define?
      result = define.apply @, arguments if define.amd or define.umd
    else
      depArr = (loadModule(dep, platform) for dep in deps)
      
      result = resolveModule factory, depArr
      module.exports = result if hasModule
      
      # Set dependency if it does not exist
      unless Object.hasOwnProperty.call udefine[platform], name
        udefine[platform][name] = result
        
        
    # Inject result into defined namespace
    if Object.hasOwnProperty.call udefine.inject.modules, name
      injectName = udefine.inject.modules[name].name
      injectRoot = udefine.inject.modules[name].root
      
      udefine.inject(injectRoot, injectName)(result)
        
    result
  
  # Helper function to inject function/object into any object
  udefine.inject = (obj, name) -> (res) ->
    return unless obj? and name?
    obj[name] = res
  
  udefine.inject.modules = {}
  
  udefine.inject.add = (name) -> udefine.inject.modules[name] = undefined
  udefine.inject.remove = (name) -> delete udefine.inject.modules[name]
    
  udefine.inject.clear = -> udefine.inject.modules = {}
  
  # TODO: Reflect if these two object could and should be merged together
  # Dependencies for browser (global object)
  # Different idea:
  #   Provide udefine.modules
  #     with functions .add .remove .get .set
  #     where you could define the type and it will also export the
  #     commonjs and globals objects
  #     .get and .set would only get and set the dependency for the
  #     current platform
  udefine.modules =
    globals: {}
    commonjs: {}
  
    add: (name) -> 
      if typeof name is 'object'
      udefine.modules[platform][name] = undefined
    remove: (name) -> 
      if Object.hasOwnProperty.call udefine.modules.globals, name
        delete udefine.modules['globals'][name]
        
      if Object.hasOwnProperty.call udefine.modules.commonjs, name
        delete udefine.modules['commonjs'][name]
    
    get: ->
    set: ->
  
  udefine.globals or= {}
  
  # Dependencies for node.js or commonjs environments
  udefine.commonjs or= {}
  
  # Default settings for udefine environment
  udefine.env or=
    amd: do -> define? and (define.amd or define.umd)
    commonjs: hasModule
    browser: not hasModule
  
  # Paths
  udefine.paths =
    commonjs:
      base: undefined
  
  # Default configuration definition
  udefine.defaultConfig = ->
    udefine.globals.root or= root
  
    define('root', -> root) if root.define?
  
  # Call default configuration
  udefine.defaultConfig()
  
  # Configuration helper function
  udefine.configure = (configFunc) ->
    configFunc.apply udefine, [root]
  
  # Export udefine function on CommonJS environments
  if hasModule then module.exports = udefine else root.udefine = udefine