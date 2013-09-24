(function() {
  var expect, udefineFunction, udefineGlobal;

  udefineFunction = require('../../dist/udefine');

  udefineGlobal = require('../../dist/global');

  expect = require('chai').expect;

  describe('udefine global function', function() {
    it('udefine is bound to global', function() {
      return expect(global.udefine).to.be.a('function');
    });
    it('return value of required global udefine is empty oject', function() {
      expect(udefineGlobal).to.be.a('object');
      return expect(udefineGlobal).to.be.empty;
    });
    it('udefine can be called without global prefix', function() {
      return expect(udefine).to.be.a('function');
    });
    return it('Global udefine is the same required udefine', function() {
      return expect(global.udefine).to.equal(udefineFunction);
    });
  });

}).call(this);
