hasModule = module? and module.exports

if hasModule
  udefine = require '../../dist/udefine'
  chai = require 'chai'
else
  {udefine, chai} = window

{expect} = chai

describe 'udefine environment variables', ->
  
  envProp = udefine.env
  
  it 'udefine.env has commonjs property', ->
    expect(envProp).to.have.property('commonjs')
    
  it 'udefine.env has browser property', ->
    expect(envProp).to.have.property('browser')
    
  it 'udefine.env has amd property', ->
    expect(envProp).to.have.property('amd')
    
  it 'udefine.env.commonjs is a boolean', ->
    expect(envProp.commonjs).to.be.a('boolean')

  it 'udefine.env.browser is a boolean', ->
    expect(envProp.browser).to.be.a('boolean')
    
  it 'udefine.env.amd is a boolean', ->
    expect(envProp.amd).to.be.a('boolean')
    
  it 'udefine.env.commonjs is true on Node.js', ->
    if hasModule then expect(envProp.commonjs).to.be.true

  it 'udefine.env.commonjs is false on browser environments', ->
    unless hasModule then expect(envProp.commonjs).to.be.false

  it 'udefine.env.browser is false on Node.js', ->
    if hasModule then expect(envProp.browser).to.be.false
    
  it 'udefine.env.browser is true on browser environments', ->
    unless hasModule then expect(envProp.browser).to.be.true