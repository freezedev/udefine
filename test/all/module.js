(function() {
  var chai, expect, hasModule, udefine;

  hasModule = (typeof module !== "undefined" && module !== null) && (module.exports != null);

  if (hasModule) {
    udefine = require('../../dist/udefine');
    chai = require('chai');
  } else {
    udefine = window.udefine, chai = window.chai;
  }

  expect = chai.expect;

  describe('udefine module definition', function() {
    it('udefine without dependencies (object factory)', function() {
      var resProp;

      udefine('abc', {
        a: 5,
        b: 4,
        c: 3
      });
      resProp = (function() {
        if (hasModule) {
          return udefine.commonjs.abc;
        } else {
          return udefine.globals.abc;
        }
      })();
      expect(resProp).to.be.a('object');
      expect(resProp).to.have.property('a');
      expect(resProp).to.have.property('b');
      return expect(resProp).to.have.property('c');
    });
    return it('udefine without dependencies (function factory)', function() {
      var resProp;

      udefine('def', function() {
        return 42;
      });
      resProp = (function() {
        if (hasModule) {
          return udefine.commonjs.def;
        } else {
          return udefine.globals.def;
        }
      })();
      expect(resProp).to.be.a('number');
      return expect(resProp).to.equal(42);
    });
  });

}).call(this);
