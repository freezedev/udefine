(function() {
  var expect, udefine;

  udefine = require('../../dist/udefine');

  expect = require('chai').expect;

  describe('udefine commonjs exportable', function() {
    return it('exports', function() {
      udefine.inject.add('halfling', {
        root: exports
      });
      udefine.inject.add('elf', {
        root: exports
      });
      udefine('halfling', function() {
        return {
          x: function() {
            return 'x';
          }
        };
      });
      udefine('elf', function() {
        return 'It\'s an elf';
      });
      expect(exports).to.be.a('object');
      expect(exports.halfling).to.be.a('object');
      expect(exports.halfling.x).to.be.a('function');
      expect(exports.halfling.x()).to.be.a('string');
      expect(exports.elf).to.be.a('string');
      return expect(exports.elf).to.equal('It\'s an elf');
    });
  });

}).call(this);
