class MeshbluOtpController
  constructor: ({@meshbluOtpService}) ->

  hello: (request, response) =>
    {hasError} = request.query
    @meshbluOtpService.doHello {hasError}, (error) =>
      return response.status(error.code || 500).send(error: error.message) if error?
      response.sendStatus(200)

module.exports = MeshbluOtpController
