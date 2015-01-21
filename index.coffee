Robot = require('hubot').Robot
Adapter = require('hubot').Adapter
TextMessage = require('hubot').TextMessage
request = require('request')
string = require("string")

port = 8081

class HangoutsAdapter extends Adapter
  toHTML: (message) ->
    # message = string(message).escapeHTML().s
    message.replace(/\n/g, "<br>")

  createUser: (username, room) ->
    user = @robot.brain.userForName username
    unless user?
      id = new Date().getTime().toString()
      user = @robot.brain.userForId id
      user.name = username

    user.room = room

    user

  send: (user, strings...) ->
    if strings.length > 0

      message = if process.env.HUBOT_HTML_RESPONSE then @toHTML(strings.shift()) else strings.shift()

      response = {
        fullName:user.user.name,
        conversationId:user.user.options.conversationId,
        userId:user.user.options.userId,
        message:message
      }

      options = {
        url:"http://localhost:#{port}/proxy/",
        method:'POST',
        body:response,
        json:true
      }

      request(options)

      @send user, strings...

  reply: (user, strings...) ->
    @send user, strings.map((str) -> "#{user.user}: #{str}")...

  run: ->
    self = @
    options = {}
    hangoutsBotPath = __dirname+'/HangoutsBot/Main.py'
    py = 'python3.3'

    @hangoutsBot = require('child_process').spawn(py, [hangoutsBotPath])

    @robot.router.post '/receive/:room', (req, res) ->
      req.setEncoding('utf8')
      req.on 'data', (rawData) ->
        data = JSON.parse(rawData)

        user = self.createUser(data.fullName, req.params.room)

        if data.conversationId && data.userId
          user.options = {
            'conversationId' : data.conversationId,
            'userId' : data.userId
          }

          console.log "[#{req.params.room}] #{user.name} => #{data.message}"

          res.setHeader 'content-type', 'text/html'
          self.receive new TextMessage(user, data.message)
          res.end 'received'
        else
          console.log 'Invalid user options'
          res.setHeader 'content-type', 'text/html'
          res.end 'received'

    @hangoutsBot.on 'exit', (code) =>
      @robot.logger.error "Lost connection with HangoutsBot... Exiting"
      process.nextTick -> process.exit(1)
    @hangoutsBot.on "uncaughtException", (err) =>
      @robot.logger.error "#{err}"
    process.on "uncaughtException", (err) =>
      @robot.logger.error "#{err}"
    process.on "exit", =>
      @hangoutsBot.kill()

    self.emit "connected"

exports.use = (robot) ->
  new HangoutsAdapter robot