'use strict'

hasModule = module? and module.exports

udefine = (name, deps, factory) ->
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

udefine.globals = {}
