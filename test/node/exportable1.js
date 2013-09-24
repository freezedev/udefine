(function() {
  var expect, udefine;

  udefine = require('../../dist/udefine');

  expect = require('chai').expect;

  describe('udefine commonjs exportable', function() {
    return it('module.exports', function() {
      udefine('export1', function() {
        return {
          a: 5,
          b: 4,
          c: 3
        };
      });
      return expect(module.exports).to.be.a('object');
    });
  });

}).call(this);
