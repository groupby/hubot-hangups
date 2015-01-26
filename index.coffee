Robot = require('hubot').Robot
Adapter = require('hubot').Adapter
TextMessage = require('hubot').TextMessage
request = require('request')
string = require("string")
exec = require('sync-exec')
path = require('path')

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
      response.message = response.fullName + ': ' + response.message

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
    pythonPath = process.env.HUBOT_HANGUPS_PYTHON
    if pythonPath && pythonPath.length > 0
      console.log "Python path is " + process.env.HUBOT_PYTHON
    else
      console.log 'ERROR: Set the HUBOT_HANGUPS_PYTHON env variable to your version of python 3.3 (eg python, python3, python3.3, etc'
      process.exit(1)

    checkInstallScript = path.resolve(__dirname, 'checkInstall.py')
    installScript = path.resolve(__dirname, 'setup.py')

    result = exec(pythonPath + " " + checkInstallScript)

    if (result.stderr.length > 0)
      console.log "ERROR: Some python modules missing, see errors above. Attempting automated install."
      installCmd = pythonPath + " " + installScript + " install"
      result = exec(installCmd)

      if (result.stderr.length > 0)
        console.error "Could not automatically run " + installCmd
        process.exit(1)


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

    @robot.router.post '/receive/:room', (req, res) ->
      req.setEncoding('utf8')

      rawData = ''
      req.on 'data', (data) ->
        rawData += data

      req.on 'end', () ->
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