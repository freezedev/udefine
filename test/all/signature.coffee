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
    
  it 'udefine has dependency properties', ->
    expect(udefine).to.have.property('modules')
    expect(udefine.modules).to.have.property('commonjs')
    expect(udefine.modules).to.have.property('commonjs')
    
    expect(udefine.modules).to.be.a('object')
    expect(udefine.modules.commonjs).to.be.a('object')
    expect(udefine.modules.globals).to.be.a('object')

  it 'udefine has a property .inject', ->
    injectProp = udefine.inject
    
    expect(udefine).to.have.property('inject')
    expect(injectProp).to.be.a('function')

  it 'udefine has a property .defaultConfig', ->
    defConProp = udefine.defaultConfig
    
    expect(udefine).to.have.property('defaultConfig')
    expect(defConProp).to.be.a('function')
