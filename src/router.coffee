MeshbluOtpController = require './controllers/meshblu-otp-controller'

class Router
  constructor: ({@meshbluOtpService}) ->
  route: (app) =>
    meshbluOtpController = new MeshbluOtpController {@meshbluOtpService}

    app.post '/generate', meshbluOtpController.generate

module.exports = Router
