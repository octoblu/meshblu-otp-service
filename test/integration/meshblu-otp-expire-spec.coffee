http              = require 'http'
request           = require 'request'
shmock            = require '@octoblu/shmock'
mongojs           = require 'mongojs'
Server            = require '../../src/server'
Encryption        = require '../../src/services/encryption'
MeshbluOtpService = require '../../src/services/meshblu-otp-service'
{privateKey}      = require './secrets'

describe 'Expire', ->
  beforeEach (done) ->
    @keys = mongojs('mongodb://localhost:27017/meshblu-otp-service-test').collection('keys')
    @keys.remove done

  beforeEach (done) ->
    serverOptions =
      port: undefined,
      disableLogging: true
      privateKey: privateKey

    @encryption = new Encryption {privateKey}

    meshbluConfig = {}
    @server = new Server serverOptions, {meshbluConfig, @keys}

    @server.run =>
      @serverPort = @server.address().port
      done()

  afterEach (done) ->
    @server.stop done

  describe 'On GET /expire/:key', ->
    beforeEach (done) ->
      otpService = new MeshbluOtpService {@keys, privateKey}
      otpService.generate {uuid: 'oh-sweet-uuid', token: 'oh-sweet-token', metadata: {something: true}}, (error, result) =>
        return done error if error?
        {@key} = result
        done()

    beforeEach (done) ->
      options =
        uri: "/expire/#{@key}"
        baseUrl: "http://localhost:#{@serverPort}"
        json: true

      request.get options, (error, @response, @body) =>
        done error

    it 'should return a 200', ->
      expect(@response.statusCode).to.equal 200

    it 'should create return the uuid and token', ->
      expect(@body).to.be.empty

    it 'should find the key', (done) ->
      @keys.find {@key}, (error, result) =>
        return done error if error?
        expect(result.length).to.equal 0
        done()
