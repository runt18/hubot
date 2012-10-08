# Description:
#   Utility commands surrounding Hubot uptime.
#
# Commands:
#   hubot ping - Reply with pong
#   hubot echo <text> - Reply back with <text>
#   hubot time - Reply with current time
#   hubot die - End hubot process

Log                   = require 'log'

module.exports = (robot) ->
  robot.respond /PING$/i, (msg) ->
    @logger       = new Log process.env.HUBOT_LOG_LEVEL or 'info'
    @logger.debug "Received PING, Replying with PONG"
    msg.send "PONG"

  robot.respond /ECHO (.*)$/i, (msg) ->
    msg.send msg.match[1]

  robot.respond /TIME$/i, (msg) ->
    msg.send "Server time is: #{new Date()}"

  # robot.respond /DIE$/i, (msg) ->
  #   msg.send "Goodbye, cruel world."
  #   process.exit 0

