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

  describe('udefine.inject', function() {
    it('udefine.inject return value is a function', function() {
      return expect(udefine.inject()).to.be.a('function');
    });
    it('udefine.inject called without parameters does not do anything', function() {
      return expect(function() {
        return udefine.inject()();
      }).to.not["throw"](Error);
    });
    it('udefine.inject called without name does not modify the object', function() {
      var obj;
      obj = {};
      udefine.inject(obj)();
      return expect(obj).to.be.empty;
    });
    it('udefine.inject adding an undefined value', function() {
      var obj;
      obj = {};
      udefine.inject(obj, '1')();
      expect(obj).to.have.ownProperty('1');
      return expect(obj['1']).to.be.undefined;
    });
    it('udefine.inject adding a null value', function() {
      var obj;
      obj = {};
      udefine.inject(obj, '2')(null);
      expect(obj).to.have.property('2');
      expect(obj).to.have.ownProperty('2');
      return expect(obj['2']).to.be["null"];
    });
    it('udefine.inject adding an string value', function() {
      var obj;
      obj = {};
      udefine.inject(obj, '3')('test');
      expect(obj).to.have.property('3');
      expect(obj).to.have.ownProperty('3');
      expect(obj['3']).to.be.a('string');
      return expect(obj['3']).to.equal('test');
    });
    it('udefine.inject adding a number value', function() {
      var obj;
      obj = {};
      udefine.inject(obj, '4')(4);
      expect(obj).to.have.property('4');
      expect(obj).to.have.ownProperty('4');
      expect(obj['4']).to.be.a('number');
      return expect(obj['4']).to.equal(4);
    });
    it('udefine.inject adding a boolean value', function() {
      var obj;
      obj = {};
      udefine.inject(obj, '5')(true);
      expect(obj).to.have.property('5');
      expect(obj).to.have.ownProperty('5');
      return expect(obj['5']).to.be["true"];
    });
    it('udefine.inject adding an object', function() {
      var obj;
      obj = {};
      udefine.inject(obj, '6')({});
      expect(obj).to.have.property('6');
      expect(obj).to.have.ownProperty('6');
      expect(obj['6']).to.be.a('object');
      return expect(obj['6']).to.be.empty;
    });
    it('udefine.inject adding an array', function() {
      var obj;
      obj = {};
      udefine.inject(obj, '7')([]);
      expect(obj).to.have.property('7');
      expect(obj).to.have.ownProperty('7');
      expect(obj['7']).to.be.a('array');
      return expect(obj['7']).to.be.empty;
    });
    return it('udefine.inject adding a function', function() {
      var obj;
      obj = {};
      udefine.inject(obj, '8')(function() {});
      expect(obj).to.have.property('8');
      expect(obj).to.have.ownProperty('8');
      return expect(obj['8']).to.be.a('function');
    });
  });

}).call(this);
