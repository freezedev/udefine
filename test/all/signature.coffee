hasModule = module? and module.exports?

if hasModule
  udefine = require '../../dist/udefine'
  chai = require 'chai'
else
  {udefine, chai} = window

{expect} = chai

describe 'udefine signature', ->
  
  it 'udefine is a function', ->
    expect(udefine).to.be.a('function')
    
  it 'udefine has a property .configure', ->
    configProp = udefine.configure
    
    expect(udefine).to.have.property('configure')
    expect(configProp).to.be.a('function')
    
  it 'udefine has a property .env', ->
    envProp = udefine.env
    
    expect(udefine).to.have.property('env')
    expect(envProp).to.be.a('object')
  
  it 'udefine has a property .autoInject', ->
    expect(udefine).to.have.property('autoInject')
    expect(udefine.autoInject).to.be.a('boolean')
    
  it 'udefine has module property', ->
    expect(udefine).to.have.property('modules')
    
    expect(udefine.modules).to.be.a('object')
    

  it 'udefine.modules has dependency sub-properties', ->
    expect(udefine.modules).to.have.property('commonjs')
    expect(udefine.modules).to.have.property('globals')
    
    expect(udefine.modules.commonjs).to.be.a('object')
    expect(udefine.modules.globals).to.be.a('object')
  
  it 'udefine.modules has .add function', ->
    expect(udefine.modules).to.have.property('add')
    expect(udefine.modules.add).to.be.a('function')
  
  it 'udefine.modules has .remove function', ->
    expect(udefine.modules).to.have.property('remove')
    expect(udefine.modules.remove).to.be.a('function')
  
  it 'udefine.modules has .get function', ->
    expect(udefine.modules).to.have.property('get')
    expect(udefine.modules.get).to.be.a('function')
  
  it 'udefine.modules has .set function', ->
    expect(udefine.modules).to.have.property('set')
    expect(udefine.modules.set).to.be.a('function')
  
  it 'udefine.modules has .clear function', ->
    expect(udefine.modules).to.have.property('clear')
    expect(udefine.modules.clear).to.be.a('function')
    

  it 'udefine has a property .inject', ->
    injectProp = udefine.inject
    
    expect(udefine).to.have.property('inject')
    expect(injectProp).to.be.a('function')

  it 'udefine.modules has .add function', ->
    expect(udefine.inject).to.have.property('add')
    expect(udefine.inject.add).to.be.a('function')
  
  it 'udefine.modules has .remove function', ->
    expect(udefine.inject).to.have.property('remove')
    expect(udefine.inject.remove).to.be.a('function')
  
  it 'udefine.modules has .clear function', ->
    expect(udefine.inject).to.have.property('clear')
    expect(udefine.inject.clear).to.be.a('function')

  it 'udefine has a property .defaultConfig', ->
    defConProp = udefine.defaultConfig
    
    expect(udefine).to.have.property('defaultConfig')
    expect(defConProp).to.be.a('function')

  it 'udefine has property .export', ->
    expect(udefine).to.have.property 'export'
    expect(udefine.export).to.be.a 'function'
    expect(udefine.export({})).to.be.a 'function'
