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
    
    resProp = do ->
      if hasModule
        udefine.commonjs.abc
      else
        udefine.globals.abc
    
    expect(resProp).to.be.a('object')
    expect(resProp).to.have.property('a')
    expect(resProp).to.have.property('b')
    expect(resProp).to.have.property('c')
