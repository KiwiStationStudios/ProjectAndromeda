EditorState = {}
EditorState.levelfolder = ""

function EditorState:init()
    editorGrid = require 'src.Components.Modules.Game.Editor.Grid'

    gameAssets = {
        tiles = {
            img = nil,
            quads = {}
        },
        portals = {
            speed = {
                img = nil,
                quads = {}
            },
            gravity = {
                img = nil,
                quads = {}
            },
            vehicle = {
                img = nil,
                quads = {}
            }
        },
        hazards = {
            img = nil,
            quads = {}
        },
        triggers = {
            img = nil,
            quads = {}
        }
    }

    gameAssets.tiles.img, gameAssets.tiles.quads = love.graphics.getHashedQuads("assets/images/game/tiles")
    gameAssets.hazards.img, gameAssets.hazards.quads = love.graphics.getHashedQuads("assets/images/game/hazards")
    gameAssets.triggers.img, gameAssets.triggers.quads = love.graphics.getHashedQuads("assets/images/game/triggers")
    gameAssets.portals.speed.img, gameAssets.portals.speed.img = love.graphics.getHashedQuads("assets/images/game/speedPortals")
    gameAssets.portals.gravity.img, gameAssets.portals.gravity.img = love.graphics.getHashedQuads("assets/images/game/gravity_portal")
    gameAssets.portals.vehicle.img, gameAssets.portals.vehicle.img = love.graphics.getHashedQuads("assets/images/game/portal_vehicle")
end

function EditorState:enter()
    -- do level loading thingie --
end

function EditorState:draw()
    editorGrid()
end

function EditorState:update(elapsed)

end

return EditorState