cors               = require 'cors'
morgan             = require 'morgan'
express            = require 'express'
bodyParser         = require 'body-parser'
errorHandler       = require 'errorhandler'
meshbluHealthcheck = require 'express-meshblu-healthcheck'
packageVersion     = require 'express-package-version'
SendError          = require 'express-send-error'
Router             = require './router'
MeshbluOtpService  = require './services/meshblu-otp-service'

class Server
  constructor: ({@disableLogging, @port, @privateKey}, {@meshbluConfig, @keys})->

  address: =>
    @server.address()

  run: (callback) =>
    app = express()
    app.use packageVersion()
    app.use meshbluHealthcheck()
    app.use morgan 'dev', immediate: false unless @disableLogging
    app.use cors()
    app.use errorHandler()
    app.use SendError()
    app.use bodyParser.urlencoded limit: '1mb', extended : true
    app.use bodyParser.json limit : '1mb'

    app.options '*', cors()

    meshbluOtpService = new MeshbluOtpService {@privateKey, @keys}
    router = new Router {@meshbluConfig, meshbluOtpService}

    router.route app

    @server = app.listen @port, callback

  stop: (callback) =>
    @server.close callback

module.exports = Server
