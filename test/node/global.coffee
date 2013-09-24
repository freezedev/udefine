udefineFunction = require '../../dist/udefine'
udefineGlobal = require '../../dist/global'
{expect} = require 'chai'

describe 'udefine global function', ->
  
  it 'udefine is bound to global', ->
    expect(global.udefine).to.be.a('function')

  it 'return value of required global udefine is undefined', ->
    expect(udefineGlobal).to.be('undefined')

  it 'udefine can be called without global prefix', ->
    expect(udefine).to.be.a('function')

  it 'Global udefine is the same required udefine', ->
    expect(global.udefine).to.equal(udefineFunction)
