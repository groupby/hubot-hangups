# Hubot Hangouts Adapter

An adapter for [Hubot](https://github.com/github/hubot) to work with Google Hangouts. This adapter uses a third-party client for google hangouts, [Hangups](https://github.com/tdryer/hangups), and a proxy, [HangoutsBot](https://github.com/wardellchandler/HangoutsBot), to connect to Hangouts.

## Requirements

- Python 3.3+ (including pip and setuptools)
- Existing hubot instance to attach it to (including node and npm)

## Setup

Now with easier, automated setup!

1. In your hubot instance directory run `npm install hubot-hangups --save`
    This will download the adapter and save it into your package.json
2. Setup an environment variable that so the adapter can use your installation of python 3.3+. 
    This should be something like `python`, `python3`, `python3.3`, or something similar. The entire path to your installed python 3.3+ instance will work as well.
3. Run the adapter with `bin/hubot -a hangups'.
    - If you have not set the environment variable in step 2, it will warn you and quit.
    - Assuming you've set the environment variable correctly it will attempt to automatically install and run the python scripts necessary for this adapter. It might take awhile, and there is no output at the moment. If this fails, it will say so.
    - If it passes the python script install, it will prompt you for a username, password, and possibly two-factor PIN for the account to be used for Google Hangouts. You'll only have to enter this once, it's cached in the cookies.txt.
4. That's it! It should respond to `hubot ping` if you send that to the Hangouts account you've linked to the adapter.

### ToDo:

- Create env variables for ports. It's currently hardcoded to using 8081 for hubot -> hangoutsBot, and 8080 for hangoutsBot -> hubot. 
- Optional, basic, whitelist-based security
- Move cookie cache to a better place, and add env variable for it's definition
- Move all these env variables to a config file

## Community

This is a work in progress and we encourage the community to point out bugs, suggest changes, etc. Obviously we will focus on the things that we need it to do first, but new ideas are always welcome.

We plan on making using this adapter as part of our daily workflow in the future so it will be stable and reliable as we can make it.

## Credits

- [wardellchandler](https://github.com/wardellchandler/HangoutsBot) for his version of the HangoutsBot
- [tdryer](https://github.com/tdryer/hangups) for the wonderful Hangups API.  



This robot has been brought to you by [GroupBy](http://www.groupbyinc.com)
