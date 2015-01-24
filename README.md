# Hubot Hangouts Adapter

An adapter for [Hubot](https://github.com/github/hubot) to work with Google Hangouts. This adapter uses a third-party client for google hangouts, [Hangups](https://github.com/tdryer/hangups), and a proxy, [HangoutsBot](https://github.com/wardellchandler/HangoutsBot), to connect to Hangouts.

## Setup

Soon this will be automated, but right now it's a bit of a manual process:

1. Install CherryPy (make sure it's going into your python 3.x location)
2. Install requests (make sure it's going into your python 3.x location)
3. Install pip and setuptools (if not already installed)
4. Install this branch of robobrowser with `pip install git+https://github.com/xxinfinityxx/robobrowser`
3. Set the `py` variable at the top of node_module/hubot-hangups/index.coffee to the python command that runs 3.3+
4. Run the `ssetup.py install` inside the hangups application folder in node_modules/hubot-hangups/hangups/
5. Go back up to your hubot folder and run the adpater. It should prompt you for email and password of the account.

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

## Credits

- [wardellchandler](https://github.com/wardellchandler/HangoutsBot) for his version of the HangoutsBot
- [tdryer](https://github.com/tdryer/hangups) for the wonderful Hangups API.  



This robot has been brought to you by [GroupBy](http://www.groupbyinc.com)
