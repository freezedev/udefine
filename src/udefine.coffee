'use strict'

# ES5 shims
do -> Array.isArray ?= (a) -> a.push is Array.prototype.push and a.length?

# Module switch
hasModule = module? and module.exports?
exportObject = {}

# Safe way to test against an object without array being a false positive
isObject = (obj) -> typeof obj is 'object' and not Array.isArray(obj)

# Root object hook
do (root = if hasModule then exportObject else this) ->
  rootExport = if hasModule then {} else root
  
  # Helper function to resolve a module (either function or object)
  resolveModule = (factory, deps) ->
    if typeof factory is 'function'
      factory.apply @, deps
    else
      factory
  
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
        requireArr = []
        
        for dep in deps
          if typeof root.udefine.commonjs[dep] is 'string'
            try
              requireArr.push require(root.udefine.commonjs[dep])
              
            catch e
              console.error "Error while loading #{dep}: #{e}"
              requireArr.push undefined
          else
            requireArr.push root.udefine.commonjs[dep]
        
        # Common JS
        result = module.exports = resolveModule factory, requireArr
      else
        # Usual browser environment
        globalsArr = (root.udefine.globals[dep] for dep in deps)
        
        result = resolveModule factory, globalsArr
                
      # Set dependency if it does not exist
      depType = if hasModule then 'commonjs' else 'globals'
      unless Object.hasOwnProperty.call root.udefine[depType], name
        root.udefine[depType][name] = result
        
        
    # Inject result into defined namespace
    if Object.hasOwnProperty.call root.udefine.inject, name
      injectName = root.udefine.inject[name].name
      injectRoot = root.udefine.inject[name].root
      
      root.udefine.inject(injectRoot, injectName)(result)
        
    result
  
  # Helper function to inject function/object into any object
  root.udefine.inject = (obj, name) -> (res) ->
    return unless obj? and name?
    obj[name] = res
  
  root.udefine.inject.add = (name) -> root.udefine.inject[name] = undefined
  
  # Dependencies for browser (global object)
  root.udefine.globals or= {}
  
  # Dependencies for node.js or commonjs environments
  root.udefine.commonjs or= {}
  
  # Default settings for udefine environment
  root.udefine.env or=
    amd: do -> define? and (define.amd or define.umd)
    commonjs: hasModule
    browser: not hasModule
  
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