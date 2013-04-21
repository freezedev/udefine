'use strict'

# ES 5 compability functions
Array.isArray or= (a) -> a.push is Array.prototype.push and a.length?

hasModule = module? and module.exports

do (root = module?.exports ? this) ->
  root.udefine = (name, deps, factory) ->
    if Array.isArray name
      [name, deps, factory] = [undefined, name, deps]
    else
      [name, deps, factory] = [undefined, undefined, name] if typeof name is 'function'
      
    do (factory) ->
      # Define, either AMD or UMD (if any?)
      if define?
        if define.amd or define.umd
          define.apply @, arguments
      else
        if hasModule
          # Common JS
        
        else
          # Ususal browser environment
          globalsArr = []
          
          globalsArr.push(root.udefine.globals[dep]) for dep in deps
          factory.apply @, globalsArr
  
  root.udefine.globals = {}
