import random
import string
import json
import cherrypy

class StringGeneratorWebService(object):
    exposed = True

    @cherrypy.tools.accept(media='application/json')
    def GET(self):
        # return cherrypy.session['mystring']
        return "get response"

    def POST(self, length=8):
        # some_string = ''.join(random.sample(string.hexdigits, int(length)))
        # cherrypy.session['mystring'] = some_string
        # return some_string
        cl = cherrypy.request.headers['Content-Length']
        rawbody = cherrypy.request.body.read(int(cl))
        body = json.dumps(rawbody)




        return "post response"

    # def PUT(self, another_string):
    #     cherrypy.session['mystring'] = another_string
    #
    # def DELETE(self):
    #     cherrypy.session.pop('mystring', None)

# if __name__ == '__main__':
#     conf = {
#         '/': {
#             'request.dispatch': cherrypy.dispatch.MethodDispatcher(),
# #            'tools.sessions.on': True,
#             'tools.response_headers.on': True,
#             'tools.response_headers.headers': [('Content-Type', 'application/json')],
#             }
#     }
#
#     cherrypy.config.update({'server.socket_host': '127.0.0.1',
#                             'server.socket_port': 8081,
#                             })
#
#     cherrypy.quickstart(StringGeneratorWebService(), '/proxy/', conf)