NodeRSA = require 'node-rsa'
_       = require 'lodash'

class Encryption
  constructor: ({privateKey}) ->
    throw new Error('Private key not found!') unless privateKey?
    @key = @createNodeRSA privateKey

  createNodeRSA: (keyString) =>
    return new NodeRSA keyString  if _.startsWith keyString, '-----'

    return new NodeRSA new Buffer(keyString, 'base64')

  getPublicKey: =>
    return @key.exportKey 'public'

  encrypt: ({uuid, token}) =>
    return @key.encrypt("#{uuid}:#{token}", 'base64')

  decrypt: (base64Str) =>
    decryptedStr = @key.decrypt(base64Str).toString()
    [uuid, token] = decryptedStr.split(':')
    return {uuid, token}

module.exports = Encryption
