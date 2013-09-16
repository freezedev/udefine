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
    expect(resProp.a).to.equal(5)
    expect(resProp.b).to.equal(4)
    expect(resProp.c).to.equal(3)

  it 'udefine without dependencies (function factory)', ->
    udefine 'def', -> 42
    
    resProp = udefine.modules.get 'def'
    
    expect(resProp).to.be.a('number')
    expect(resProp).to.equal(42)

  it 'udefine module (object) definition with injection', ->
    injectObj = {}
    
    udefine.inject.add 'ghi',
      root: injectObj
      name: 'ghi'
      
    udefine 'ghi',
      g: 7
      h: 8
      i: 9
    
    expect(injectObj).to.be.a('object')
    expect(injectObj.ghi).to.be.a('object')
    expect(injectObj.ghi).to.have.property('g')
    expect(injectObj.ghi).to.have.property('h')
    expect(injectObj.ghi).to.have.property('i')
    expect(injectObj.ghi.g).to.equal(7)
    expect(injectObj.ghi.h).to.equal(8)
    expect(injectObj.ghi.i).to.equal(9)

  it 'udefine module (function) definition with injection', ->
    injectObj = {}
    
    udefine.inject.add 'jkl',
      root: injectObj
      name: 'jkl'
      
    udefine 'jkl',
      j: true
      k: 'string'
      l: ->
    
    expect(injectObj).to.be.a('object')
    expect(injectObj.jkl).to.be.a('object')
    expect(injectObj.jkl).to.have.property('j')
    expect(injectObj.jkl).to.have.property('k')
    expect(injectObj.jkl).to.have.property('l')
    expect(injectObj.jkl.j).to.equal(true)
    expect(injectObj.jkl.k).to.equal('string')
    
  it 'udefine module definition with injection (module !== injection)', ->
    injectObj = {}
    
    udefine.inject.add 'mno',
      root: injectObj
      name: 'Universe'
      
    udefine 'mno', -> -> 42
    
    expect(injectObj).to.be.a('object')
    expect(injectObj.Universe).to.be.a('function')
    expect(injectObj.Universe()).to.equal(42)
    
  it 'udefine module definition with injection shorthand', ->
    injectObj = {}
    
    udefine.inject.add 'pqr',
      root: injectObj
      
    udefine 'pqr', -> -> 43
    
    expect(injectObj).to.be.a('object')
    expect(injectObj.pqr).to.be.a('function')
    expect(injectObj.pqr()).to.equal(43)
    
  unless hasModule
    it 'udefine module definition with injection shorthand (globals)', ->
    
    udefine.inject.add 'stu'
          
    udefine 'stu', -> -> 44
    
    expect(window.stu).to.be.a('function')
    expect(window.stu()).to.equal(44)
    
# TODO: Add tests for .clear and .remove