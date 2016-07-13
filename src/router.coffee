MeshbluOtpController = require './controllers/meshblu-otp-controller'
meshbluAuth        = require 'express-meshblu-auth'

class Router
  constructor: ({@meshbluConfig, @meshbluOtpService}) ->
    @meshbluOtpController = new MeshbluOtpController {@meshbluOtpService}

  route: (app) =>
    # V2 New Hotness
    app.post   '/v2/passwords', meshbluAuth(@meshbluConfig), @meshbluOtpController.generate
    app.get    '/v2/passwords/:password', @meshbluOtpController.get
    app.delete '/v2/passwords/:password', @meshbluOtpController.delete

    # V1 (deprecated)
    app.post '/generate', meshbluAuth(@meshbluConfig), @meshbluOtpController.generate
    app.post '/generate/:uuid/:token', @meshbluOtpController.generateDev
    app.get '/exchange/:key', @meshbluOtpController.exchange
    app.get '/retrieve/:key', @meshbluOtpController.retrieve
    app.get '/expire/:key', @meshbluOtpController.expire

module.exports = Router
