import os
import sys
import random
import time
import json

def makeString(length) -> str:
    chars = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789"
    s = ""
    for c in range(length):
        s = s + chars[random.randint(1, len(chars) - 1)]
    return s

def main(args) -> None:
    if len(args) > 0:
        # hack :)
        identity = "com.kiwiworksinc.projectnx"
        appdata = os.getenv("appdata")
        path = appdata + "/LOVE/" + identity + "/user/editor/"

        templateJson = {
            "meta" : {
                "title" : "",
                "description" : "Simple description",
                "username" : "username",
                "gameversion" : 0,
                "requestedDifficulty" : 0, # int range 1 -> 5
                "songID" : "000000",     # used to download the song from newgrounds,
                "textures" : [
                    {
                        "tag" : "tag",
                        "data" : "[read the image data]->[encode to hex]->[gzip compress]->[encode to hex]",
                    }
                ]
            },
            "level" : {
                "startPos" : [0, 0],
                "endPos" : [256, 0],
                "bgID" : 1,
                "colorChannels" : {
                    "reserved" : {
                        "bg" : [128, 128, 128],
                        "objs" : [255, 255, 255]
                    }
                },
                "startGamemode" : "cube",
                "startSpeed" : 2,    # range from 1 to 4
                "startDirection" : "right",
                "startFlipped" : False
            },
            "objects" : [],
            "objectThird" : []
        }

        if args[0] == "create" or args[0] == "make":
            random.seed(int(time.time()))
            for f in range(int(args[1])):
                file = makeString(10) + ".lvl"
                epath = path + file
                print("[CREATED] : " + file)
                with open(epath, "w") as fsout:
                    templateJson["meta"]["title"] = makeString(random.randint(5, 15))
                    fsout.write(json.dumps(templateJson))
        elif args[0] == "clear" or args[0] == "delete":
            filenames = next(os.walk(path), (None, None, []))[2]
            for f in filenames:
                print("[REMOVED] : " + f)
                os.remove(path + f)
        print("[Task ended with sucess]")
    else:
        print("Please specify a valid mode -> [create, clear]")

if __name__ == "__main__":
    main(sys.argv[1:])