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

  describe('udefine environment variables', function() {
    var envProp;

    envProp = udefine.env;
    it('udefine.env has commonjs property', function() {
      return expect(envProp).to.have.property('commonjs');
    });
    it('udefine.env has browser property', function() {
      return expect(envProp).to.have.property('browser');
    });
    it('udefine.env has amd property', function() {
      return expect(envProp).to.have.property('amd');
    });
    it('udefine.env.commonjs is a boolean', function() {
      return expect(envProp.commonjs).to.be.a('boolean');
    });
    it('udefine.env.browser is a boolean', function() {
      return expect(envProp.browser).to.be.a('boolean');
    });
    it('udefine.env.amd is a boolean', function() {
      return expect(envProp.amd).to.be.a('boolean');
    });
    it('udefine.env.commonjs is true on Node.js', function() {
      if (hasModule) {
        return expect(envProp.commonjs).to.be["true"];
      }
    });
    it('udefine.env.commonjs is false on browser environments', function() {
      if (!hasModule) {
        return expect(envProp.commonjs).to.be["false"];
      }
    });
    it('udefine.env.browser is false on Node.js', function() {
      if (hasModule) {
        return expect(envProp.browser).to.be["false"];
      }
    });
    return it('udefine.env.browser is true on browser environments', function() {
      if (!hasModule) {
        return expect(envProp.browser).to.be["true"];
      }
    });
  });

}).call(this);
