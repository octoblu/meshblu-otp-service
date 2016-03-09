class MeshbluOtpService
  constructor: ({secret}) ->

  generate: ({uuid, token}, callback) =>
    callback null, token: 'sweet'

  _createError: (code, message) =>
    error = new Error message
    error.code = code if code?
    return error

module.exports = MeshbluOtpService
