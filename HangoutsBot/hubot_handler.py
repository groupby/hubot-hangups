import json
import cherrypy

host = '127.0.0.1'
port = 8081

class HubotHandler(object):

    def __init__(self, bot):
        self.bot = bot

    def listen(self, input_pipe):

        conf = {
            '/': {
                'request.dispatch': cherrypy.dispatch.MethodDispatcher(),
                'tools.response_headers.on': True,
                'tools.response_headers.headers': [('Content-Type', 'application/json')],
                }
        }

        cherrypy.config.update({'server.socket_host': host,
                            'server.socket_port': port,
                            })

        cherrypy.quickstart(HubotHandlerService(self.bot, input_pipe), '/proxy/', conf)


class HubotHandlerService(object):
    exposed = True

    def __init__(self, bot, input_pipe):
        self.bot = bot
        self.input_pipe = input_pipe

    @cherrypy.tools.accept(media='application/json')
    def POST(self, length=8):

        cl = cherrypy.request.headers['Content-Length']
        rawbody = cherrypy.request.body.read(int(cl))
        body = json.loads(rawbody.decode('utf-8'))

        print('in post')

        self.input_pipe.send(body)

