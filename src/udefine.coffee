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
  # TODO: Find a better wording than platform and platforms
  platforms = ['commonjs', 'globals']
  platform = if hasModule then 'commonjs' else 'globals'
  
  # Helper function to resolve a module (either function or object)
  resolveModule = (factory, deps) ->
    if typeof factory is 'function'
      factory.apply @, deps
    else
      factory
  
  loadModule = (name, type) ->
    if hasModule and typeof udefine.modules[type][name] is 'string'
      path = require 'path'
      prePath = do ->
        if udefine.paths[type].base
          udefine.paths[type].base
        else
          ''
      require path.join(process.cwd(), prePath, udefine.modules[type][name])
    else
      udefine.modules[type][name]
  
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
      unless Object.hasOwnProperty.call udefine.modules[platform], name
        udefine.modules[platform][name] = result
        
        
    # Inject result into defined namespace
    if Object.hasOwnProperty.call udefine.inject.modules, name
      injectObject = udefine.inject.modules[name]
      
      {root: injectRoot, name: injectName, exportable} = injectObject
      
      udefine.inject(injectRoot, injectName)(result)
      
      if hasModule
        if exportable or exportable is 'all' then module.exports = result
        if exportable is 'partial' then exports[injectName] = result
        
    result
  
  # Helper function to inject function/object into any object
  udefine.inject = (obj, name) -> (res) ->
    return unless obj? and name?
    obj[name] = res
  
  udefine.inject.modules = {}
  
  udefine.inject.add = (name, value) ->
    return unless name?
    value = {} unless value?
    value.root = root unless value.root?
    value.name = name unless value.name?
    
    udefine.inject.modules[name] = value
    @

  udefine.inject.remove = (name) ->
    delete udefine.inject.modules[name]
    @
    
  udefine.inject.clear = ->
    udefine.inject.modules = {}
    @
  
  # Dependencies
  udefine.modules =
    globals: {}
    commonjs: {}
  
    # TODO: Reflect if previously defined modules should be overwritten
    add: (name, value) ->
      if typeof name is 'object'
        @add key, val for key, val of name
      else
        if value
          if Array.isArray value
            udefine.modules[v][name] = undefined for v in value
          else
            udefine.modules.set name, value
        else
          udefine.modules[platform][name] = undefined
      @
      
    remove: (name) ->
      for p in platforms
        if Object.hasOwnProperty.call udefine.modules[p], name
          delete udefine.modules[p][name]
      @
    
    get: (name) -> udefine.modules[platform][name]
    set: (name, value) ->
      if typeof value is 'object'
        udefine.modules[k][name] = v for k, v of value
      else
        udefine.modules[platform][name] = value
      @
      
    clear: ->
      udefine.modules[p] = {} for p in platforms
      @
  
  # Default settings for udefine environment
  udefine.env or=
    amd: do -> define? and (define.amd or define.umd)
    commonjs: hasModule
    browser: not hasModule
    globals: not hasModule and not udefine.amd
  
  # Paths
  udefine.paths =
    commonjs:
      base: undefined
  
  # Default configuration definition
  udefine.defaultConfig = ->
    udefine.modules.commonjs.root = root
  
    define('root', -> root) if root.define?
  
  # Call default configuration
  udefine.defaultConfig()
  
  # Configuration helper function
  udefine.configure = (configFunc) ->
    configFunc.apply udefine, [root]
  
  # Export udefine function on CommonJS environments
  if hasModule then module.exports = udefine else root.udefine = udefine