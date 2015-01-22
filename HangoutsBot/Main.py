import sys
import inspect, os

from hangupsbot import HangupsBot

dir = os.path.dirname(os.path.abspath(inspect.getfile(inspect.currentframe())))

class Main:
    bot = None

    @staticmethod
    def start():

        run = True
        index = -1
        for x in range(0, len(sys.argv)):
            if isinstance(sys.argv[x], dict):
                if sys.argv[x]["isSettings"]:
                    index = x

        if index != -1:
            settings = sys.argv[index]
        else:
            settings = {}
            sys.argv.append(settings)
            index = len(sys.argv) - 1
            settings["isSettings"] = True
            settings["bot"] = None
            settings["event"] = None

        if settings["bot"] is None:
            Main.bot = HangupsBot("{}/cookies.txt".format(dir), "{}/config.json".format(dir))
            settings["bot"] = Main.bot
        else:
            Main.bot = settings["bot"]
            run = False
            if settings["event"] is not None:
                Main.bot.send_message(settings["event"].conv, "Reconnected.")

        sys.argv[index] = settings
        if run:
            Main.bot.run()

Main().start()