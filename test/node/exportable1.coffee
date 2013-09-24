udefine = require '../../dist/udefine'
{expect} = require 'chai'

describe 'udefine commonjs exportable', ->
  it 'module.exports', ->
    
    udefine 'export1', ->
      a: 5
      b: 4
      c: 3
    
    expect(module.exports).to.be.a('object')
    expect(module.exports.a).to.be.a('number', 'Property "a" is not a number')
    expect(module.exports.b).to.be.a('number', 'Property "b" is not a number')
    expect(module.exports.c).to.be.a('number', 'Property "c" is not a number')
    expect(module.exports.a).to.equal(5)
    expect(module.exports.b).to.equal(4)
    expect(module.exports.c).to.equal(3)