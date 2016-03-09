http    = require 'http'
request = require 'request'
shmock  = require '@octoblu/shmock'
Server  = require '../../src/server'

describe 'Generate', ->
  beforeEach (done) ->
    @meshblu = shmock 0xd00d

    serverOptions =
      port: undefined,
      disableLogging: true
      secret: 'oh-boy'

    meshbluConfig =
      server: 'localhost'
      port: 0xd00d

    @server = new Server serverOptions, {meshbluConfig}

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
        json: true

      request.post options, (error, @response, @body) =>
        done error

    it 'should auth handler', ->
      @authDevice.done()

    it 'should return a 200', ->
      expect(@response.statusCode).to.equal 201

    it 'should return a token', ->
      expect(@body.token).to.equal 'sweet'
