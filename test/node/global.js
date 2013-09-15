(function() {
  var expect, udefineFunction;

  udefineFunction = require('../../dist/udefine');

  require('../../dist/global');

  expect = require('chai').expect;

  describe('udefine global function', function() {
    it('udefine is bound to global', function() {
      return expect(global.udefine).to.be.a('function');
    });
    it('udefine can be called without global prefix', function() {
      return expect(udefine).to.be.a('function');
    });
    return it('Global udefine is the same required udefine', function() {
      return expect(global.udefine).to.equal(udefineFunction);
    });
  });

}).call(this);
