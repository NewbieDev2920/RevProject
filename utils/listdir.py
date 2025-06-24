import os
import json

config = open('config.json', 'r')
configinfo = config.read()
config.close()

conf = json.loads(configinfo)
PATH = conf["ASSETS_PATH"]

f = open("./assetslist.txt",'w')
info = ''

for root, dirs, files, rootfd in os.fwalk(PATH):
    info = info +'\n'+ root + '\n'  + str(dirs) + '\n' + str(files)+ '\n' + str(rootfd) + '\n'

f.write(info)
f.close()


