Encryption = requrie 'meshblu-encryption'

class MeshbluOtpService
  constructor: ({privateKey}) ->
    @encryption = new Encryption {privateKey}
    
  generate: ({uuid, token}, callback) =>
    callback null, token: 'sweet'

  _createError: (code, message) =>
    error = new Error message
    error.code = code if code?
    return error

module.exports = MeshbluOtpService
