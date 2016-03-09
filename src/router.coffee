MeshbluOtpController = require './controllers/meshblu-otp-controller'

class Router
  constructor: ({@meshbluOtpService}) ->
  route: (app) =>
    meshbluOtpController = new MeshbluOtpController {@meshbluOtpService}

    app.get '/hello', meshbluOtpController.hello
    # e.g. app.put '/resource/:id', someController.update

module.exports = Router
