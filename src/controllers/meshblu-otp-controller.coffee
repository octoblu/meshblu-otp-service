class MeshbluOtpController
  constructor: ({@meshbluOtpService}) ->

  generate: (request, response) =>
    @meshbluOtpService.generate request.meshbluAuth, (error, result) =>
      return response.sendError(error) if error?
      response.status(201).send result

  exchange: (request, response) =>
    {key} = request.params
    @meshbluOtpService.exchange {key}, (error, result) =>
      return response.sendError(error) if error?
      response.status(200).send result

module.exports = MeshbluOtpController
