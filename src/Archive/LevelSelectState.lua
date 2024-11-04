LevelSelectState = {}

local function _drawLevelName(_name, _diff, _locked)
    termview:clear()

    termview:frame("block", 4, 8, termview.width - 8, math.floor(termview.height / 2))
    termview:frame("block", 6, 10, termview.width - 12, math.floor(termview.height / 2) - 4)

    terminalblit.write(_name, termview.width / 2 - (#_name * 16) / 2, 36, "big")
    terminalblit.write("rate:", 1, math.floor(termview.height / 2) + 32, "small")

    --termview:blitSprite("assets/data/rpd/stars")
    local sx = 42
    for s = 1, 5, 1 do
        if s <= _diff then
            termview:blitSprite("assets/data/rpd/star_full.rpd", sx, (math.floor(termview.height / 2) + 32) - 5)
        else
            termview:blitSprite("assets/data/rpd/star_empty.rpd", sx, (math.floor(termview.height / 2) + 32) - 5)
        end
        sx = sx + 18
    end

    if _locked then
        termview:blitSprite("assets/data/rpd/lock.rpd", 8, 10)
    end
end

function LevelSelectState:enter()
    terminalblit = require 'src.Components.Modules.Game.Graphics.TerminalBlit'

    effect = moonshine(moonshine.effects.crt)
    .chain(moonshine.effects.glow)
    .chain(moonshine.effects.scanlines)

    levels = json.decode(love.filesystem.read("assets/data/maps/Maps.json"))
    currentLevel = 1

    bootsfx = love.audio.newSource("assets/sounds/bootsfx.ogg", "static")
    bootbeep = love.audio.newSource("assets/sounds/beepBoot.ogg", "static")
    
    if not menumain then
        menumain = love.audio.newSource("assets/sounds/tracks/future_base.ogg", "static")
        menumain:setLooping(true)
        menumain:play()
    else
        if not menumain:isPlaying() then
            menumain:setLooping(true)
            menumain:play()
        end
    end
    menumain:setVolume(registers.system.settings.audio.music)

    local termFont = fontcache.getFont("compaqthin", 4)
    termview = terminal(love.graphics.getWidth(), love.graphics.getHeight(), termFont)
    termview.speed = 50000

    print(termview.width, termview.height)
    _drawLevelName(levels[currentLevel].name, levels[currentLevel].difficulty, levels[currentLevel].locked)

    termview:hideCursor()
end

function LevelSelectState:draw()
    effect(function()
        do
            local scale = 1
            local scaleX, scaleY = (love.graphics.getWidth() / termview.canvas:getWidth()) * scale, (love.graphics.getHeight() / termview.canvas:getHeight()) * scale
            love.graphics.push()
                love.graphics.translate((love.graphics.getWidth() * (1 - scale)) / 2, (love.graphics.getHeight() * (1 - scale)) / 2)
                love.graphics.scale(scaleX, scaleY)
                termview:draw()
            love.graphics.pop()
        end
    end)
end

function LevelSelectState:update(elapsed)
    termview:update(elapsed)
end

function LevelSelectState:keypressed(k)
    if k == "a" or k == "left" then
        if currentLevel > 1 then
            currentLevel = currentLevel - 1
            _drawLevelName(levels[currentLevel].name, levels[currentLevel].difficulty, levels[currentLevel].locked)
        end
    end
    if k == "d" or k == "right" then
        if currentLevel < #levels then
            currentLevel = currentLevel + 1
            _drawLevelName(levels[currentLevel].name, levels[currentLevel].difficulty, levels[currentLevel].locked)
        end
    end
    if k == "return" then
        local mapFile = love.filesystem.getInfo("assets/data/maps/" .. levels[currentLevel].filename)

        if mapFile then
            -- init --
        else
            -- draw error dialog --
        end
    end
end

return LevelSelectState