MeshbluOtpController = require './controllers/meshblu-otp-controller'
meshbluAuth        = require 'express-meshblu-auth'

class Router
  constructor: ({@meshbluConfig, @meshbluOtpService}) ->
    @meshbluOtpController = new MeshbluOtpController {@meshbluOtpService}

  route: (app) =>
    app.post '/generate', meshbluAuth(@meshbluConfig), @meshbluOtpController.generate
    app.get '/exchange/:key', @meshbluOtpController.exchange

module.exports = Router
