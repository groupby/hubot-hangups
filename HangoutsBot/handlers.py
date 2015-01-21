import logging
import asyncio
import requests
import json

url = "http://localhost:8080/receive/engineering"

class MessageHandler(object):

    def __init__(self, bot, bot_command='/'):

        self.bot = bot
        self.bot_command = bot_command

    @asyncio.coroutine
    def handle(self, event):
        if event.conv_id not in self.bot.conv_settings:
            self.bot.conv_settings[event.conv_id] = {}

        """Handle conversation event"""
        if logging.root.level == logging.DEBUG:
            event.print_debug()

        if not event.user.is_self and event.text:
            yield from self.handle_command(event)

    @asyncio.coroutine
    def handle_command(self, event):
        """Handle command messages"""

        tempDict = {"fullName":"{}".format(event.user.full_name), "conversationId":"{}".format(event.conv_id),
                    "userId":"{}".format(event.user_id.chat_id), "message":"{}".format(event.text)}
        payload = json.dumps(tempDict)

        requests.post(url, data=payload)

