Robot = require('hubot').Robot
Adapter = require('hubot').Adapter
TextMessage = require('hubot').TextMessage
request = require('request')
string = require("string")

# sendmessageURL domain.com/messages/new/channel/ + user.channel
sendMessageUrl = process.env.HUBOT_REST_SEND_URL

class WebAdapter extends Adapter
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

      console.log 'send'
#      request.post(sendMessageUrl+user.room).form({
#        message: message,
#        from: "#{@robot.name}"
#      })
      @send user, strings...

  reply: (user, strings...) ->
    console.log 'reply'
    @send user, strings.map((str) -> "#{user.user}: #{str}")...

  run: ->
    self = @

    options = {}

    @robot.router.post '/receive/:room', (req, res) ->
      req.setEncoding('utf8')
      req.on 'data', (rawData) ->
        data = JSON.parse(rawData)
        console.log data

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

    self.emit "connected"

exports.use = (robot) ->
  new WebAdapter robot