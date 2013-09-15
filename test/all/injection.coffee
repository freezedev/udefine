hasModule = module? and module.exports?

if hasModule
  udefine = require '../../dist/udefine'
  chai = require 'chai'
else
  {udefine, chai} = window

{expect} = chai

describe 'udefine.inject', ->
 
  it 'udefine.inject return value is a function', ->
    expect(udefine.inject()).to.be.a('function')
    
  it 'udefine.inject called without parameters does not do anything', ->
    expect(-> udefine.inject()()).to.not.throw(Error)
    
  it 'udefine.inject called without name does not modify the object', ->
    obj = {}
    
    udefine.inject(obj)()
    
    expect(obj).to.be.empty
    
  it 'udefine.inject adding an undefined value', ->
    obj = {}
    
    udefine.inject(obj, '1')()
    
    expect(obj).to.have.ownProperty('1')
    expect(obj['1']).to.be.undefined

  it 'udefine.inject adding a null value', ->
    obj = {}
    
    udefine.inject(obj, '2')(null)
    
    expect(obj).to.have.property('2')
    expect(obj).to.have.ownProperty('2')
    expect(obj['2']).to.be.null
    
  it 'udefine.inject adding an string value', ->
    obj = {}
    
    udefine.inject(obj, '3')('test')
    
    expect(obj).to.have.property('3')
    expect(obj).to.have.ownProperty('3')
    expect(obj['3']).to.be.a('string')
    expect(obj['3']).to.equal('test')

  it 'udefine.inject adding a number value', ->
    obj = {}
    
    udefine.inject(obj, '4')(4)
    
    expect(obj).to.have.property('4')
    expect(obj).to.have.ownProperty('4')
    expect(obj['4']).to.be.a('number')
    expect(obj['4']).to.equal(4)

  it 'udefine.inject adding a boolean value', ->
    obj = {}
    
    udefine.inject(obj, '5')(true)
    
    expect(obj).to.have.property('5')
    expect(obj).to.have.ownProperty('5')
    expect(obj['5']).to.be.true
    
  it 'udefine.inject adding an object', ->
    obj = {}
    
    udefine.inject(obj, '6')({})
    
    expect(obj).to.have.property('6')
    expect(obj).to.have.ownProperty('6')
    expect(obj['6']).to.be.a('object')
    expect(obj['6']).to.be.empty

  it 'udefine.inject adding an array', ->
    obj = {}
    
    udefine.inject(obj, '7')([])
    
    expect(obj).to.have.property('7')
    expect(obj).to.have.ownProperty('7')
    expect(obj['7']).to.be.a('array')
    expect(obj['7']).to.be.empty
    
  it 'udefine.inject adding a function', ->
    obj = {}
    
    udefine.inject(obj, '8')(->)
    
    expect(obj).to.have.property('8')
    expect(obj).to.have.ownProperty('8')
    expect(obj['8']).to.be.a('function')