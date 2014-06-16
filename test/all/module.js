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
      resProp = udefine.modules.get('abc');
      expect(resProp).to.be.a('object');
      expect(resProp).to.have.property('a');
      expect(resProp).to.have.property('b');
      expect(resProp).to.have.property('c');
      expect(resProp.a).to.equal(5);
      expect(resProp.b).to.equal(4);
      return expect(resProp.c).to.equal(3);
    });
    it('udefine without dependencies (function factory)', function() {
      var resProp;
      udefine('def', function() {
        return 42;
      });
      resProp = udefine.modules.get('def');
      expect(resProp).to.be.a('number');
      return expect(resProp).to.equal(42);
    });
    it('udefine module (object) definition with injection', function() {
      var injectObj;
      injectObj = {};
      udefine.inject.add('ghi', {
        root: injectObj,
        name: 'ghi'
      });
      udefine('ghi', {
        g: 7,
        h: 8,
        i: 9
      });
      expect(injectObj).to.be.a('object');
      expect(injectObj.ghi).to.be.a('object');
      expect(injectObj.ghi).to.have.property('g');
      expect(injectObj.ghi).to.have.property('h');
      expect(injectObj.ghi).to.have.property('i');
      expect(injectObj.ghi.g).to.equal(7);
      expect(injectObj.ghi.h).to.equal(8);
      return expect(injectObj.ghi.i).to.equal(9);
    });
    it('udefine module (function) definition with injection', function() {
      var injectObj;
      injectObj = {};
      udefine.inject.add('jkl', {
        root: injectObj,
        name: 'jkl'
      });
      udefine('jkl', {
        j: true,
        k: 'string',
        l: function() {}
      });
      expect(injectObj).to.be.a('object');
      expect(injectObj.jkl).to.be.a('object');
      expect(injectObj.jkl).to.have.property('j');
      expect(injectObj.jkl).to.have.property('k');
      expect(injectObj.jkl).to.have.property('l');
      expect(injectObj.jkl.j).to.equal(true);
      return expect(injectObj.jkl.k).to.equal('string');
    });
    it('udefine module definition with injection (module !== injection)', function() {
      var injectObj;
      injectObj = {};
      udefine.inject.add('mno', {
        root: injectObj,
        name: 'Universe'
      });
      udefine('mno', function() {
        return function() {
          return 42;
        };
      });
      expect(injectObj).to.be.a('object');
      expect(injectObj.Universe).to.be.a('function');
      return expect(injectObj.Universe()).to.equal(42);
    });
    it('udefine module definition with injection shorthand', function() {
      var injectObj;
      injectObj = {};
      udefine.inject.add('pqr', {
        root: injectObj
      });
      udefine('pqr', function() {
        return function() {
          return 43;
        };
      });
      expect(injectObj).to.be.a('object');
      expect(injectObj.pqr).to.be.a('function');
      return expect(injectObj.pqr()).to.equal(43);
    });
    if (!hasModule) {
      it('udefine module definition with injection shorthand (globals)', function() {});
      udefine.inject.add('stu');
      udefine('stu', function() {
        return function() {
          return 44;
        };
      });
      expect(window.stu).to.be.a('function');
      return expect(window.stu()).to.equal(44);
    }
  });

}).call(this);
