{TextMessage} = require './message'
Log        = require 'log'

class Listener
  # Listeners receive every message from the chat source and decide if they
  # want to act on it.
  #
  # robot    - A Robot instance.
  # matcher  - A Function that determines if this listener should trigger the
  #            callback.
  # callback - A Function that is triggered if the incoming message matches.
  constructor: (@robot, @matcher, @callback) ->
    @logger       = new Log process.env.HUBOT_LOG_LEVEL or 'info'

  # Public: Determines if the listener likes the content of the message. If
  # so, a Response built from the given Message is passed to the Listener
  # callback.
  #
  # message - A Message instance.
  #
  # Returns a boolean of whether the matcher matched.
  call: (message) ->
    if match = @matcher message
      @logger.debug "Matched #{message}"
      @callback new @robot.Response(@robot, message, match)
      true
    else
      @logger.debug "Did not match #{message}"
      false

class TextListener extends Listener
  # TextListeners receive every message from the chat source and decide if they want
  # to act on it.
  #
  # robot    - A Robot instance.
  # regex    - A Regex that determines if this listener should trigger the
  #            callback.
  # callback - A Function that is triggered if the incoming message matches.
  constructor: (@robot, @regex, @callback) ->
    @matcher = (message) =>
      if message instanceof TextMessage
        message.match @regex

module.exports.Listener     = Listener
module.exports.TextListener = TextListener
