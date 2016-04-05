Encryption = require './encryption'
{ObjectId} = require 'mongojs'

class MeshbluOtpService
  constructor: ({privateKey, @keys}) ->
    @encryption = new Encryption {privateKey}

  generate: ({uuid, token, metadata}, callback) =>
    encryptedSecret = @encryption.encrypt({uuid, token})
    key = new ObjectId().toString()
    @keys.insert {key, encryptedSecret, metadata}, (error) =>
      return callback @_createError 500, error.message if error?
      callback null, {key}

  exchange: ({key}, callback) =>
    @keys.findOne {key}, (error, result) =>
      return callback @_createError 502, error.message if error?
      return callback @_createError 404, 'Missing record' unless result?
      {metadata, encryptedSecret} = result
      {uuid, token} = @encryption.decrypt(encryptedSecret)
      @keys.remove {key}, (error) =>
        return callback @_createError 502, error.message if error?
        callback null, {uuid, token, metadata}

  _createError: (code, message) =>
    error = new Error message
    error.code = code if code?
    return error

module.exports = MeshbluOtpService
