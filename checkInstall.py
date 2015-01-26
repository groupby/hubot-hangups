import importlib
import sys

loader = importlib.find_loader('hangups')

def printErrorAndExit(module_name):
    print(module_name + " not found.")
    sys.exit(1)

if loader is None:
    printErrorAndExit("hangups")

loader = importlib.find_loader('requests')

if loader is None:
    printErrorAndExit("requests")

loader = importlib.find_loader('cherrypy')

if loader is None:
    printErrorAndExit("cherrypy")

sys.exit()