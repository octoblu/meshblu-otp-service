_             = require 'lodash'
MeshbluConfig = require 'meshblu-config'
Server        = require './src/server'

class Command
  constructor: ->
    @serverOptions =
      port:           process.env.PORT || 80
      disableLogging: process.env.DISABLE_LOGGING == "true"
      secret:         process.env.MESHBLU_CTP_SECRET

  panic: (error) =>
    console.error error.stack
    process.exit 1

  run: =>
    @panic new Error('Missing required environment variable: MESHBLU_CTP_SECRET') if _.isEmpty @serverOptions.secret

    server = new Server @serverOptions, {meshbluConfig:  new MeshbluConfig().toJSON()}
    server.run (error) =>
      return @panic error if error?

      {address,port} = server.address()
      console.log "Server listening on #{address}:#{port}"

command = new Command()
command.run()
