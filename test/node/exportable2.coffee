udefine = require '../../dist/udefine'
{expect} = require 'chai'

describe 'udefine commonjs exportable', ->
  it 'exports', ->
    udefine.inject.add 'halfling', {root: exports}
    udefine.inject.add 'elf', {root: exports}
    
    udefine 'halfling', ->
      x: -> 'x'

    udefine 'elf', -> 'It\'s an elf'
    
    expect(exports).to.be.a('object')
    expect(exports.halfling).to.be.a('object')
    expect(exports.halfling.x).to.be.a('function')
    expect(exports.halfling.x()).to.be.a('string')
    expect(exports.elf).to.be.a('string')
    expect(exports.elf).to.equal('It\'s an elf')