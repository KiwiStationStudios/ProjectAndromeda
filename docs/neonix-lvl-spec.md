
This is just for the meta post
```json
{
    "title" : "Level title",
    "description" : "Simple description",
    "username" : "username",
    "gameversion" : 0,
    "requestedDifficulty" : 0, // float range 0.5 -> 5.0
    "songID" : "000000",     // used to download the song from newgrounds
    "textures" : {
        "tag" : {
            "data" : "[read the image data]->[encode to hex]->[gzip compress]->[encode to hex]",
        }
    }
}
```

level content
```json
{
    "meta" : {
        "title" : "Level title",
        "description" : "Simple description",
        "username" : "username",
        "gameversion" : 0,
        "requestedDifficulty" : 0, // int range 1 -> 5
        "songID" : "000000",     // used to download the song from newgrounds,
    },
    "level" : {
        "startPos" : [0, 0],
        "endPos" : [256, 0],
        "colorChannels" : {
            "reserved" : {
                "bg" : [128, 128, 128],
                "objs" : [255, 255, 255],
                "layer1" : [128, 128, 128],
                "layer2" : [96, 96, 96]
            }
        },
        "startGamemode" : "cube",
        "startSpeed" : 1,    // range from 0 to 4
        "startDirection" : "right",
        "gravityFlipped" : false
    },
    "objects" : [
        {
            "id" : 1,
            "position" : [0, 0, 0],
            "layer": 0,
            "rotation" : 0,
            "size" : [1, 1],
            "tagid" : null,
            "colorChannel" : "reserved:layer1",
            "collision" : true
        }
    ]
}
```


object composition (2D)
`id:0;x:0;y:0;r:0;sx:1;sy:1;tid:1;tag:""`

object composition (3D)
`mid:0;px:0;py:0;pz:0;rx:0;ry:0;rz:0;sx:0;sy:0;sz:0;actid:0;`