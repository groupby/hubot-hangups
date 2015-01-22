Robot = require('hubot').Robot
Adapter = require('hubot').Adapter
TextMessage = require('hubot').TextMessage
request = require('request')
string = require("string")

port = 8081
py = 'python3.3'

class HangoutsAdapter extends Adapter

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

    @hangoutsBot = require('child_process').spawn(py, [hangoutsBotPath])

    @hangoutsBot.stdout.pipe(process.stdout,{ end: false })
    process.stdin.resume()
    process.stdin.pipe(@hangoutsBot.stdin,{ end: false })

    @hangoutsBot.stdin.on 'end', ->
      process.stdout.write('Hangouts stream ended.')

    @hangoutsBot.on 'exit', (code) ->
      process.exit(code)


#    botStdin = @hangoutsBot.stdin
#    require('tty').setRawMode(true)
#    stdin.on 'keypress', (char) ->
#      botStdin.write char
#
#    @hangoutsBot.stdout.on 'data', (data) ->
#      if data != undefined
#        stdout.write data
##        if data.toString() == 'Email: '
##          botStdin.write 'data', (data) ->
##            if data != undefined
##              console.log data.toString()

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