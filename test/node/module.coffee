udefine = require '../../dist/udefine'
{expect} = require 'chai'

describe 'udefine commonjs dependencies', ->
  it 'multiple dependencies', (done) ->
    udefine.paths.commonjs.base = 'test/node'
    
    udefine.modules.add
      dep1: './dep1'
      dep2: './dep2'
    
    udefine 'nodetest', ['dep1', 'dep2'], (dep1, dep2) ->
      expect(dep1).to.be.a('object')
      expect(dep1).to.have.property('number')
      
      expect(dep2).to.be.a('function')
      
      num = dep1.number + dep2()
      
      expect(num).to.be.a('number')
      
      done()