# Hubot Hangouts Adapter

An adapter for [Hubot](https://github.com/github/hubot) to work with Google Hangouts. This adapter uses a third-party client for google hangouts, [Hangups](https://github.com/tdryer/hangups), and a proxy, [HangoutsBot](https://github.com/wardellchandler/HangoutsBot),to connect to Hangouts.

## Setup

In index.coffee and hubot_handler.py set your 'port' to whichever port you want to use between the two locally.
In handler.py set your 'url' to whatever url you want to use hubot to receive messages from.
In index.coffee set you 'py' to whatever command that uses Python 3.3 or higher (i.e. python, python3.3).

Start hubot with 'bin/hubot -a hangups' and it should connect to hangups on its own.

**Currently you need to run HangoutsBot in hubot-hangups in your node_modules folder to setup the gmail credentials that your hubot will use. Enter the command 'python Main.py' in the folder HangoutsBot or whatever your Python 3.3+ is assigned to and HangoutsBot will prompt for the email and password.
