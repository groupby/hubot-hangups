# Hubot Hangouts Adapter

An adapter for [Hubot](https://github.com/github/hubot) to work with Google Hangouts. This adapter uses a third-party client for google hangouts, [Hangups](https://github.com/tdryer/hangups), and a proxy, [HangoutsBot](https://github.com/wardellchandler/HangoutsBot), to connect to Hangouts.

## Setup

You will need Python 3.3 or higher since the hangups api only works with 3.3+.
After getting python you will need to install [CherryPy](http://cherrypy.readthedocs.org/en/latest/install.html) and [requests](http://docs.python-requests.org/en/latest/user/install/#install).

In index.coffee and hubot_handler.py set your 'port' to whichever port you want to use between the two locally.
In handler.py set your 'url' to whatever url you want to use hubot to receive messages from.
In index.coffee set you 'py' to whatever command that uses Python 3.3 or higher (i.e. python, python3.3).

Start hubot with 'bin/hubot -a hangups' and it should connect to hangups on its own.
After it prompts and accepted it's credentials, it will automatically start.

## Community

This is a work in progress and we encourage the community to point out bugs, suggest changes, etc. Obviously we will focus on the things that we need it to do first, but new ideas are always welcome.

We plan on making using this adapter as part of our daily workflow in the future so it will be stable and reliable as we can make it.
