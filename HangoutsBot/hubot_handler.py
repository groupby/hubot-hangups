import logging, shlex, unicodedata, asyncio
from cleverbot import ChatterBotFactory, ChatterBotType
import hangups
import socket
import json
import sys

from commands import command


class HubotHandler(object):

    def __init__(self, bot):
        self.bot = bot
        self._cancel = False

#     @asyncio.coroutine
#     def receive(self, num):
#         data = self.s.recv(num)
#         return data
#
#     @asyncio.coroutine
#     def listen(self):
#         while not self._cancel:
#             num = 4
#             data = yield from self.receive(num)
#             length = int.from_bytes(data, byteorder='big', signed=True)
#             data = yield from self.receive(length)
#             text = json.loads(data.decode("utf-8"))
#             print(text)
#     #
#     #         user_name = text['username']
#     #         conv_id = text['convID']
#     #         user_id = text['userID']
#     #         message = text['message']
#     #
#     #         if conv_id == None:
#     #             conv_id = self.get_conv_id(user_name)
#     #
#     #         if conv_id == None:
#     #             self.bot.send_message(ADMIN_CONVO, message)
#     #         else:
#     #             conversation = self.bot._conv_list.get(conv_id)
#     #             self.bot.send_message(conversation, message)
#
#     #
#     # def get_conv_id(self, user_name):
#     #     min = sys.maxint
#     #     conv_id = None
#     #     for id, convo in self.bot._conv_list._conv_dict:
#     #         if (user_name in convo._user_list) and (min > len(convo._user_list)):
#     #             min = len(convo._user_list)
#     #             conv_id = id
#     #     return conv_id
#     #
#     # def stop(self):
#     #     self._cancel = True
#
#
# s = socket.socket(socket.AF_INET, socket.SOCK_STREAM)
# s.connect((TCP_IP, TCP_PORT))
# test = HubotHandler(s)
#
# # asyncio.async(test.listen)
# loop = asyncio.get_event_loop()
# loop.run_until_complete(test.listen())
# loop.close()