import logging, shlex, unicodedata, asyncio
import hangups

import json
import cherrypy

class HubotHandler(object):

    def __init__(self, bot):
        self.bot = bot

    def listen(self, input_pipe):

        conf = {
            '/': {
                'request.dispatch': cherrypy.dispatch.MethodDispatcher(),
                #            'tools.sessions.on': True,
                'tools.response_headers.on': True,
                'tools.response_headers.headers': [('Content-Type', 'application/json')],
                }
        }

        cherrypy.config.update({'server.socket_host': '127.0.0.1',
                            'server.socket_port': 8081,
                            })

        cherrypy.quickstart(HubotHandlerService(self.bot, input_pipe), '/proxy/', conf)


class HubotHandlerService(object):
    exposed = True

    def __init__(self, bot, input_pipe):
        self.bot = bot
        self.input_pipe = input_pipe

    @cherrypy.tools.accept(media='application/json')
    def POST(self, length=8):
        # some_string = ''.join(random.sample(string.hexdigits, int(length)))
        # cherrypy.session['mystring'] = some_string
        # return some_string
        print('in POST')

        cl = cherrypy.request.headers['Content-Length']
        rawbody = cherrypy.request.body.read(int(cl))
        body = json.loads(rawbody.decode('utf-8'))

        print(body)

        self.input_pipe.send(body)



# test = HubotHandler()
# #asyncio.async(test.listen)
# loop = asyncio.get_event_loop()
# loop.run_until_complete(test.listen())
# loop.close()