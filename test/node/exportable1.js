(function() {
  var expect, udefine, udefineExport;

  udefine = require('../../dist/udefine');

  udefineExport = udefine.exports(module.exports);

  expect = require('chai').expect;

  describe('udefine commonjs exportable', function() {
    return it('module.exports', function() {
      udefineExport('export1', function() {
        return {
          a: 5,
          b: 4,
          c: 3
        };
      });
      expect(module.exports).to.be.a('object');
      expect(module.exports.a).to.be.a('number', 'Property "a" is not a number');
      expect(module.exports.b).to.be.a('number', 'Property "b" is not a number');
      expect(module.exports.c).to.be.a('number', 'Property "c" is not a number');
      expect(module.exports.a).to.equal(5);
      expect(module.exports.b).to.equal(4);
      return expect(module.exports.c).to.equal(3);
    });
  });

}).call(this);
