_             = require 'lodash'
MeshbluConfig = require 'meshblu-config'
mongojs       = require 'mongojs'
Server        = require './src/server'

class Command
  constructor: ->
    @serverOptions =
      port:           process.env.PORT || 80
      disableLogging: process.env.DISABLE_LOGGING == "true"
      privateKey:     process.env.MESHBLU_OTP_PRIVATE_KEY_BASE64

    @mongoDBUri = process.env.MONGODB_URI

  panic: (error) =>
    console.error error.stack
    process.exit 1

  run: =>
    @panic new Error('Missing required environment variable: MESHBLU_OTP_PRIVATE_KEY_BASE64') if _.isEmpty @serverOptions.privateKey
    @panic new Error('Missing required environment variable: MONGODB_URI') if _.isEmpty @mongoDBUri

    keys = mongojs(@mongoDBUri).collection('keys')

    meshbluConfig = new MeshbluConfig().toJSON()
    server = new Server @serverOptions, {meshbluConfig, keys}
    server.run (error) =>
      return @panic error if error?

      {address,port} = server.address()
      console.log "Server listening on #{address}:#{port}"

command = new Command()
command.run()
