hasModule = module? and module.exports?

if hasModule
  udefine = require '../../dist/udefine'
  chai = require 'chai'
else
  {udefine, chai} = window

{expect} = chai

describe 'udefine.inject', ->

  objEmpty = {}
  obj1 = {}
  obj2 = {}
  obj3 = {}
  obj4 = {}
  
  it 'udefine.inject return value is a function', ->
    expect(udefine.inject()).to.be.a('function')
    
  it 'udefine.inject called without parameters does not do anything', ->
    expect(udefine.inject()()).to.not.throw(Error)
    
  it 'udefine.inject called without name does not modify the object', ->
    udefine.inject(objEmpty)()
    
    expect(objEmpty).to.be.empty
    
  it 'udefine.inject adding an undefined value', ->
    udefine.inject(obj1, '1')()
    
    expect(obj1).to.have.property('1')
    expect(obj1).to.have.ownProperty('1')
    expect(obj1['1']).to.be.undefined

  it 'udefine.inject adding a null value', ->
    udefine.inject(obj2, '2')(null)
    
    expect(obj2).to.have.property('2')
    expect(obj2).to.have.ownProperty('2')
    expect(obj2['2']).to.be.null
    
  it 'udefine.inject adding an string value', ->
    udefine.inject(obj3, '3')('test')
    
    expect(obj3).to.have.property('3')
    expect(obj3).to.have.ownProperty('3')
    expect(obj3['3']).to.be.a('string')
    expect(obj3['3']).to.equal('test')

  it 'udefine.inject adding a number value', ->
    udefine.inject(obj4, '4')(4)
    
    expect(obj4).to.have.property('4')
    expect(obj4).to.have.ownProperty('4')
    expect(obj4['4']).to.be.a('number')
    expect(obj4['4']).to.equal(4)
