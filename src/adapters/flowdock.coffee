{Adapter,TextMessage} = require 'hubot'
flowdock              = require 'flowdock'
Log                   = require 'log'

class Flowdock extends Adapter
  send: (user, strings...) ->
    @bot.message user.flow, str for str in strings

  reply: (user, strings...) ->
    strings.forEach (str) =>
      @send user, "@#{user.name}: #{str}"

  connect: ->
    ids = (flow.id for flow in @flows)
    @stream = @bot.stream(ids, active: 'idle')
    @stream.on 'message', (message) =>
      @logger.debug "Message: #{message.event}"
      return unless message.event == 'message'
      author =
        name: @userForId(message.user).name
        flow: message.flow
      return if @robot.name == author.name
      @receive new TextMessage(author, message.content)

  run: ->
    @logger       = new Log process.env.HUBOT_LOG_LEVEL or 'info'
    @login_email    = process.env.HUBOT_FLOWDOCK_LOGIN_EMAIL
    @login_password = process.env.HUBOT_FLOWDOCK_LOGIN_PASSWORD
	
    @logger.debug "Connecting with #{@login_email}"
	
    unless @login_email && @login_password
      console.error "ERROR: No credentials in environment variables HUBOT_FLOWDOCK_LOGIN_EMAIL and HUBOT_FLOWDOCK_LOGIN_PASSWORD"
      @emit "error", "No credentials"

    @bot = new flowdock.Session(@login_email, @login_password)
    @bot.flows (flows) =>
      @flows = flows
      for flow in flows
        @logger.debug "Flow: #{flow}"
        for user in flow.users
          @logger.debug "-- User: #{user.nick}"
          data =
            id: user.id
            name: user.nick
          @userForId user.id, data
      @connect()

    @bot

    @logger.debug "Connected"
    @emit 'connected'

exports.use = (robot) ->
  new Flowdock robot