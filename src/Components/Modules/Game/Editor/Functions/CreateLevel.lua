return function(levelname)
    local levelMeta = {
        title = "Level title",
        description = "Simple description",
        username = "username",
        gameversion = 0,
        requestedDifficulty = 0, -- int range 1 -> 5
        song = {
            artist = "",
            trackname = "",
            bpm = 90,
        }
    }

    local editorMeta = {
        camPos = {0, 0},
        zoom = 1,
        workingLayer = 0,
        undoCache = {},
    }

    local levelData = {
        level = {
            startPos = {0, 0},
            endPos = 256,
            colorChannels = {
                reserved = {
                    bg = {128, 128, 128},
                    objs = {255, 255, 255},
                    black = {0, 0, 0},
                    finalObj = {191, 113, 216}
                },
                public = {
                    ["color1"] = {255, 255, 255}
                }
            },
            startGamemode = "cube",
            startSpeed = 0, -- range from 0 to 4
            directionFlipped = false,
            gravityFlipped = false,
        },
        objects = {
            layers = {}
        },
    }

    levelMeta.title = levelname
    
    if gamejolt.isLoggedIn then
        levelMeta.username = gamejolt.username
    end

    local rootFolder = "user/editor/" .. levelname
    love.filesystem.createDirectory(rootFolder)
    love.filesystem.createDirectory(rootFolder .. "/textures")
    love.filesystem.createDirectory(rootFolder .. "/sounds")
    
    -- meta files --
    local levelMetadataFile = love.filesystem.newFile(rootFolder .. "/meta.json", "w")
    levelMetadataFile:write(json.encode(levelMeta))
    levelMetadataFile:close()

    local levelEditorMeta = love.filesystem.newFile(rootFolder .. "/editor.json", "w")
    levelEditorMeta:write(json.encode(editorMeta))
    levelEditorMeta:close()

    local levelDataFile = love.filesystem.newFile(rootFolder .. "/level.json", "w")
    levelDataFile:write(json.encode(levelData))
    levelDataFile:close()
end