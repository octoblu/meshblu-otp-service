class MeshbluOtpController
  constructor: ({@meshbluOtpService}) ->

  generate: (request, response) =>
    {uuid, token} = request.meshbluAuth
    metadata = request.body
    @meshbluOtpService.generate {uuid, token, metadata}, (error, result) =>
      return response.sendError(error) if error?
      response.status(201).send result

  generateDev: (request, response) =>
    {uuid, token} = request.params
    metadata = request.body
    @meshbluOtpService.generate {uuid, token, metadata}, (error, result) =>
      return response.sendError(error) if error?
      response.status(201).send result

  exchange: (request, response) =>
    {key} = request.params
    @meshbluOtpService.exchange {key}, (error, result) =>
      return response.sendError(error) if error?
      response.status(200).send result

  retrieve: (request, response) =>
    {key} = request.params
    @meshbluOtpService.retrieve {key}, (error, result) =>
      return response.sendError(error) if error?
      response.status(200).send result

  expire: (request, response) =>
    {key} = request.params
    @meshbluOtpService.expire {key}, (error, result) =>
      return response.sendError(error) if error?
      response.status(200).send result

module.exports = MeshbluOtpController
