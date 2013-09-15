'use strict'

# Module switch
hasModule = module? and module.exports?
exportObject = {}

# Root object hook
do (root = if hasModule then exportObject else this) ->
  rootExport = if hasModule then {} else root
  
  root.udefine or= (name, deps, factory) ->
    throw new Error 'A udefine module needs to have a name' unless name?
    
    [name, deps, factory] = [name, [], deps] if typeof deps is 'function'
      
    # Define, either AMD or UMD (if any?)
    if define?
      result = define.apply @, arguments if define.amd or define.umd
    else
      if hasModule
        requireArr = []
        
        for dep in deps
          if typeof root.udefine.node[dep] is 'string'
            requireArr.push require(root.udefine.node[dep])
          else
            requireArr.push root.udefine.node[dep]
        
        # Common JS
        result = module.exports = factory.apply @, requireArr
      else
        # Usual browser environment
        globalsArr = (root.udefine.globals[dep] for dep in deps)
        
        result = factory.apply @, globalsArr
        
        # Set dependency if it does not exist
        unless Object.hasOwnProperty.call root.udefine.globals, name
          root.udefine.globals[name] = result
        
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