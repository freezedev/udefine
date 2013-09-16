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
    it('udefine has module property', function() {
      expect(udefine).to.have.property('modules');
      return expect(udefine.modules).to.be.a('object');
    });
    it('udefine.modules has dependency sub-properties', function() {
      expect(udefine.modules).to.have.property('commonjs');
      expect(udefine.modules).to.have.property('globals');
      expect(udefine.modules.commonjs).to.be.a('object');
      return expect(udefine.modules.globals).to.be.a('object');
    });
    it('udefine.modules has .add function', function() {
      expect(udefine.modules).to.have.property('add');
      return expect(udefine.modules.add).to.be.a('function');
    });
    it('udefine.modules has .remove function', function() {
      expect(udefine.modules).to.have.property('remove');
      return expect(udefine.modules.remove).to.be.a('function');
    });
    it('udefine.modules has .get function', function() {
      expect(udefine.modules).to.have.property('get');
      return expect(udefine.modules.get).to.be.a('function');
    });
    it('udefine.modules has .set function', function() {
      expect(udefine.modules).to.have.property('set');
      return expect(udefine.modules.set).to.be.a('function');
    });
    it('udefine.modules has .clear function', function() {
      expect(udefine.modules).to.have.property('clear');
      return expect(udefine.modules.clear).to.be.a('function');
    });
    it('udefine has a property .inject', function() {
      var injectProp;

      injectProp = udefine.inject;
      expect(udefine).to.have.property('inject');
      return expect(injectProp).to.be.a('function');
    });
    it('udefine.modules has .add function', function() {
      expect(udefine.inject).to.have.property('add');
      return expect(udefine.inject.add).to.be.a('function');
    });
    it('udefine.modules has .remove function', function() {
      expect(udefine.inject).to.have.property('remove');
      return expect(udefine.inject.remove).to.be.a('function');
    });
    it('udefine.modules has .clear function', function() {
      expect(udefine.inject).to.have.property('clear');
      return expect(udefine.inject.clear).to.be.a('function');
    });
    return it('udefine has a property .defaultConfig', function() {
      var defConProp;

      defConProp = udefine.defaultConfig;
      expect(udefine).to.have.property('defaultConfig');
      return expect(defConProp).to.be.a('function');
    });
  });

}).call(this);
