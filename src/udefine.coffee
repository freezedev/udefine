'use strict'

# ES 5 compability functions
Array.isArray or= (a) -> a.push is Array.prototype.push and a.length?

# Module switch
hasModule = module? and module.exports

# Root object hook
do (root = module?.exports ? this) ->
  root.udefine or= (name, deps, factory) ->
    if Array.isArray name
      [name, deps, factory] = [undefined, [], deps]
    else
      if typeof name is 'function'
        [name, deps, factory] = [undefined, [], name]
      
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
  
  null
