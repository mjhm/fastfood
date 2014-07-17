

chai = require 'chai'
expect = chai.expect
sinon = require('sinon')
chai.use(require 'sinon-chai')
chai.use(require 'chai-as-promised')

process.chdir(__dirname)
console.log(process.cwd())

fsutil = require '../../util/fsutil.coffee'
savenum_module = require('../../services/savenum')
savenum = savenum_module.savenum
savenum2 = savenum_module.savenum2
savenum3 = savenum_module.savenum3

fs = require 'fs'
Q = require 'q'

describe.skip 'service/savenum -', ->

  beforeEach ->
    try
      fs.unlinkSync('/tmp/savenum_test/num')
    try
      fs.rmdirSync('/tmp/savenum_test')

  describe 'savenum mini integration tests -', ->

    it 'saves 5 in a new file in a new directory', (done) ->
      savenum '/tmp/savenum_test', ->
        num = fs.readFileSync('/tmp/savenum_test/num').toString()
        expect(num).to.equal('5')
        done()

    it 'tries to save 5 again', (done) ->
      savenum '/tmp/savenum_test', ->
        num = fs.readFileSync('/tmp/savenum_test/num').toString()
        expect(num).to.equal('5')
        done()

  describe 'savenum2 mini integration tests -', ->

    it 'saves 5 in a new file in a new directory', (done) ->
      savenum_module.resetCache()
      savenum2 '/tmp/savenum_test', ->
        num = fs.readFileSync('/tmp/savenum_test/num').toString()
        expect(num).to.equal('5')
        done()

    it 'tries to save 5 again', (done) ->
      savenum2 '/tmp/savenum_test', ->
        num = fs.readFileSync('/tmp/savenum_test/num').toString()
        expect(num).to.equal('5')
        done()

  describe 'savenum3 mini integration tests -', ->

    it 'saves 5 in a new file in a new directory', (done) ->
      savenum_module.resetCache()
      savenum3 '/tmp/savenum_test', ->
        num = fs.readFileSync('/tmp/savenum_test/num').toString()
        expect(num).to.equal('5')
        done()

    it 'tries to save 5 again', (done) ->
      savenum3 '/tmp/savenum_test', ->
        num = fs.readFileSync('/tmp/savenum_test/num').toString()
        expect(num).to.equal('5')
        done()



describe.skip 'Async stubbing for mkdir_chdirX -', ->

  beforeEach ->
    sinon.stub(fs, 'mkdir').callsArgAsync(1)
    sinon.stub(process, 'chdir')

  afterEach ->
    fs.mkdir.restore()
    process.chdir.restore()

  describe 'mkdir_chdir2 unit test -', ->
    
    it 'should call mkdir and chdir', (done) ->
      my_callback = sinon.spy()
      fsutil.mkdir_chdir2('/whatever', my_callback)
      expect(fs.mkdir).to.be.called
      expect(my_callback).not.to.be.called
      process.nextTick ->
        expect(my_callback).to.be.called
        done()


  describe 'mkdir_chdir3 unit test -', ->
    
    it 'should call mkdir and chdir', (done) ->
      my_callback = sinon.spy()
      fsutil.mkdir_chdir3('/whatever', my_callback)
      expect(fs.mkdir).to.be.called
      expect(my_callback).not.to.be.called
      process.nextTick ->
        expect(my_callback).to.be.called
        done()


describe.skip 'Promise stubbing for mkdir_chdirX -', ->

  asyncBlocker = null
  beforeEach ->
    asyncBlocker = Q.defer()
    sinon.stub fs, 'mkdir', (path, cb) ->
      asyncBlocker.promise.then () -> cb(null)
    sinon.stub(process, 'chdir')

  afterEach ->
    fs.mkdir.restore()
    process.chdir.restore()

  describe 'mkdir_chdir2 unit test -', ->
    
    it 'should call mkdir and chdir', (done) ->
      my_callback = sinon.spy()
      fsutil.mkdir_chdir2('/whatever', my_callback)
      expect(fs.mkdir).to.be.called
      expect(my_callback).not.to.be.called
      asyncBlocker.resolve()
      process.nextTick ->
        expect(my_callback).to.be.called
        done()


  describe 'mkdir_chdir3 unit test -', ->
    
    it 'should call mkdir and chdir', (done) ->
      my_callback = sinon.spy()
      fsutil.mkdir_chdir3('/whatever', my_callback)
      expect(fs.mkdir).to.be.called
      expect(my_callback).not.to.be.called
      asyncBlocker.resolve()
      process.nextTick ->
        expect(my_callback).to.be.called
        done()


