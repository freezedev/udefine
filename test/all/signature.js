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

  describe('udefine signature', function() {
    it('udefine is a function', function() {
      return expect(udefine).to.be.a('function');
    });
    it('udefine has a property .configure', function() {
      var configProp;

      configProp = udefine.configure;
      expect(udefine).to.have.property('configure');
      return expect(configProp).to.be.a('function');
    });
    it('udefine has a property .env', function() {
      var envProp;

      envProp = udefine.env;
      expect(udefine).to.have.property('env');
      return expect(envProp).to.be.a('object');
    });
    it('udefine has dependency properties', function() {
      expect(udefine).to.have.property('modules');
      expect(udefine.modules).to.have.property('commonjs');
      expect(udefine.modules).to.have.property('commonjs');
      expect(udefine.modules).to.be.a('object');
      expect(udefine.modules.commonjs).to.be.a('object');
      return expect(udefine.modules.globals).to.be.a('object');
    });
    it('udefine has a property .inject', function() {
      var injectProp;

      injectProp = udefine.inject;
      expect(udefine).to.have.property('inject');
      return expect(injectProp).to.be.a('function');
    });
    return it('udefine has a property .defaultConfig', function() {
      var defConProp;

      defConProp = udefine.defaultConfig;
      expect(udefine).to.have.property('defaultConfig');
      return expect(defConProp).to.be.a('function');
    });
  });

}).call(this);
