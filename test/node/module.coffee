udefine = require '../../dist/udefine'
{expect} = require 'chai'

# TODO: This test is not working yet
###
describe 'udefine commonjs dependencies', ->
  it 'multiple dependencies', (done) ->
    udefine.commonjs =
      dep1: './dep1'
      dep2: './dep2'
      
    udefine 'nodetest', ['dep1', 'dep2'], (dep1, dep2) ->
      console.log arguments
      
      expect(dep1).to.be.a('object')
      expect(dep1).to.have.property('number')
      
      expect(dep2).to.be.a('function')
      
      num = dep1.number + dep2()
      
      expect(num).to.be.a('number')
      
      done()
###