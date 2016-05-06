MeshbluOtpController = require './controllers/meshblu-otp-controller'
meshbluAuth        = require 'express-meshblu-auth'

class Router
  constructor: ({@meshbluConfig, @meshbluOtpService}) ->
    @meshbluOtpController = new MeshbluOtpController {@meshbluOtpService}

  route: (app) =>
    app.post '/generate', meshbluAuth(@meshbluConfig), @meshbluOtpController.generate
    app.post '/generate/:uuid/:token', @meshbluOtpController.generateDev
    app.get '/exchange/:key', @meshbluOtpController.exchange
    app.get '/retrieve/:key', @meshbluOtpController.retrieve
    app.get '/expire/:key', @meshbluOtpController.expire

module.exports = Router
