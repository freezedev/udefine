'use strict'

# Module switch
hasModule = module? and module.exports

# Root object hook
# TODO: Binding to global on Node.js is not the best idea (I know it's bad
#  practice), but what are the alternatives? (Putting it into a requirable 
#  module is not really an option for small-scale projects)
do (root = if hasModule then global else this) ->
  root.udefine or= (name, deps, factory) ->
    throw new Error 'A udefine module needs to have a name' unless name?
    
    [name, deps, factory] = [name, [], deps] if typeof deps is 'function'
      
    # Define, either AMD or UMD (if any?)
    if define?
      result = define.apply @, arguments if define.amd or define.umd
    else
      if hasModule
        requireArr = (require(root.udefine.node[dep]) for dep in deps)
        
        # Common JS
        result = module.exports = factory.apply @, requireArr
      else
        # Usual browser environment
        globalsArr = (root.udefine.globals[dep] for dep in deps)
        
        result = factory.apply @, globalsArr
        
        if Object.hasOwnProperty.call root.udefine.globals, name
          root.udefine.globals[name] = result
    result
  
  root.udefine.globals or= {}
  root.udefine.commonjs or= {}
  root.udefine.env or= 
    amd: do -> define? and (define.amd or define.umd)
    commonjs: hasModule
    browser: not hasModule
  
  # Default configuration definition
  root.udefine.defaultConfig = ->
    root.udefine.globals.root or= root;
  
    define('root', -> root) if root.define?
  
  # Call default configuration
  root.udefine.defaultConfig()
  
  null
