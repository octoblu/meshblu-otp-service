cors               = require 'cors'
morgan             = require 'morgan'
express            = require 'express'
bodyParser         = require 'body-parser'
errorHandler       = require 'errorhandler'
meshbluHealthcheck = require 'express-meshblu-healthcheck'
meshbluAuth        = require 'express-meshblu-auth'
SendError          = require 'express-send-error'
MeshbluConfig      = require 'meshblu-config'
debug              = require('debug')('meshblu-otp-service:server')
Router             = require './router'
MeshbluOtpService  = require './services/meshblu-otp-service'

class Server
  constructor: ({@disableLogging, @port, @secret}, {@meshbluConfig})->
    @meshbluConfig ?= new MeshbluConfig().toJSON()

  address: =>
    @server.address()

  run: (callback) =>
    app = express()
    app.use morgan 'dev', immediate: false unless @disableLogging
    app.use cors()
    app.use errorHandler()
    app.use SendError()
    app.use meshbluHealthcheck()
    app.use meshbluAuth(@meshbluConfig)
    app.use bodyParser.urlencoded limit: '1mb', extended : true
    app.use bodyParser.json limit : '1mb'

    app.options '*', cors()

    meshbluOtpService = new MeshbluOtpService {@secret}
    router = new Router {@meshbluConfig, meshbluOtpService}

    router.route app

    @server = app.listen @port, callback

  stop: (callback) =>
    @server.close callback

module.exports = Server
