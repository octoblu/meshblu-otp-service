http         = require 'http'
request      = require 'request'
shmock       = require '@octoblu/shmock'
mongojs      = require 'mongojs'
Server       = require '../../src/server'
Encryption   = require '../../src/services/encryption'
{privateKey} = require './secrets'

describe 'Generate', ->
  beforeEach (done) ->
    @keys = mongojs('mongodb://localhost:27017/meshblu-otp-service-test').collection('keys')
    @keys.remove done

  beforeEach (done) ->
    @meshblu = shmock 0xd00d

    serverOptions =
      port: undefined,
      disableLogging: true
      privateKey: privateKey

    @encryption = new Encryption {privateKey: privateKey}

    meshbluConfig =
      server: 'localhost'
      port: 0xd00d

    @server = new Server serverOptions, {meshbluConfig, @keys}

    @server.run =>
      @serverPort = @server.address().port
      done()

  afterEach (done) ->
    @server.stop done

  afterEach (done) ->
    @meshblu.close done

  describe 'On POST /generate', ->
    beforeEach (done) ->
      userAuth = new Buffer('some-uuid:some-token').toString 'base64'

      @authDevice = @meshblu
        .get '/v2/whoami'
        .set 'Authorization', "Basic #{userAuth}"
        .reply 200, uuid: 'some-uuid', token: 'some-token'

      options =
        uri: '/generate'
        baseUrl: "http://localhost:#{@serverPort}"
        auth:
          username: 'some-uuid'
          password: 'some-token'
        json:
          something: true

      request.post options, (error, @response, @body) =>
        done error

    it 'should auth handler', ->
      @authDevice.done()

    it 'should return a 201', ->
      expect(@response.statusCode).to.equal 201

    it 'should find one result', (done) ->
      @keys.find {}, (error, result) =>
        return done error if error?
        expect(result.length).to.equal 1
        done()

    it 'should return a key', (done) ->
      @keys.findOne {key: @body.key}, (error, result) =>
        return done error if error?
        return done new Error 'Missing record' unless result?
        expect(@encryption.decrypt(result.encryptedSecret)).to.deep.equal {
          uuid: 'some-uuid'
          token: 'some-token'
        }
        expect(result.metadata).to.deep.equal something: true
        done()
