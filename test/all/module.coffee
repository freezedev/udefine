hasModule = module? and module.exports?

if hasModule
  udefine = require '../../dist/udefine'
  chai = require 'chai'
else
  {udefine, chai} = window

{expect} = chai

describe 'udefine module definition', ->
    
  it 'udefine without dependencies (object factory)', ->
    udefine 'abc',
      a: 5
      b: 4
      c: 3
    
    resProp = udefine.modules.get 'abc'
    
    expect(resProp).to.be.a('object')
    expect(resProp).to.have.property('a')
    expect(resProp).to.have.property('b')
    expect(resProp).to.have.property('c')

  it 'udefine without dependencies (function factory)', ->
    udefine 'def', -> 42
    
    resProp = udefine.modules.get 'def'
    
    expect(resProp).to.be.a('number')
    expect(resProp).to.equal(42)
