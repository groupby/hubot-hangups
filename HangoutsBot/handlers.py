import logging
import asyncio
import requests
import json

from datetime import datetime
import traceback
LOG_FORMAT = '%(asctime)s - %(name)s - %(levelname)s - %(message)s'

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
        try:
            tempDict = {"fullName":"{}".format(event.user.full_name), "conversationId":"{}".format(event.conv_id),
                    "userId":"{}".format(event.user_id.chat_id), "message":"{}".format(event.text)}
            payload = json.dumps(tempDict)

            log = open('log.txt', 'a+')
            log.writelines(payload + "\n")
            log.flush()
            log.close()

            requests.post(url, data=payload)

        except Exception as e:
            log = open('log.txt', 'a+')
            log.writelines(str(datetime.now()) + ":\n " + traceback.format_exc() + "\n\n")
            log.flush()
            log.close()



