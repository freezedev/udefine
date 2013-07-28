'use strict'

# Module switch
hasModule = module? and module.exports

# Root object hook
# TODO: Binding to global on Node.js is not the best idea (I know it's bad
#  practice), but what are the alternatives? (Putting it into a requirable 
#  module is not really an for small-scale projects)
do (root = if hasModule then global else this) ->
  root.udefine or= (name, deps, factory) ->
    throw new Error 'A udefine module needs to have a name' unless name?
    
    [name, deps, factory] = [name, [], deps] if typeof deps is 'function'
      
    # Define, either AMD or UMD (if any?)
    if define?
      if define.amd or define.umd
        udefine.env.amd = true
        result = define.apply @, arguments
    else
      if hasModule
        requireArr = (require(root.udefine.node[dep]) for dep in deps)
        
        # Common JS
        udefine.env.commonjs = true
        result = module.exports = factory.apply @
      else
        # Usual browser environment
        globalsArr = (root.udefine.globals[dep] for dep in deps)
        
        udefine.env.browser = true
        result = factory.apply @, globalsArr
    result
  
  root.udefine.globals or= {}
  root.udefine.commonjs or= {}
  root.udefine.env or= 
    amd: false
    commonjs: false
    browser: false
  
  null
