CreditsState = {}

function CreditsState:enter()
    Conductor = require 'src.Components.Modules.Game.Conductor'
    SpectrumVisualizer = require 'src.Components.Modules.Game.Graphics.SpecVisualizer'
    Expander = require 'src.Components.Modules.Game.Graphics.Expander'
    Fog = require 'src.Components.Modules.Game.Graphics.Fog'
    
    logoBumpSize = 0.2

    nxLogo = love.graphics.newImage("assets/images/menus/logo_thingy.png")
    nxLogoFX = love.graphics.newImage("assets/images/menus/logo_fx.png")
    
    neonCodeCreditsSoundtrack = love.audio.newSource("assets/sounds/Tracks/neon_code.ogg", "static")
    neonCodeCreditsSoundtrack:setVolume(registers.system.settings.audio.music)

    gradientFade = love.graphics.newGradient("vertical", {255, 255, 255, 255}, {0, 0, 0, 0})

    Conductor.bpm = 87

    knifeevent.hook(Conductor, { "beatHit" })

    yText = love.graphics.getHeight() - 20
    creditsText = love.filesystem.read("assets/data/Credits.txt")
    f_credits = fontcache.getFont("quicksand_light", 25)

    textW, textLines = f_credits:getWrap(creditsText, love.graphics.getWidth())
    textH = f_credits:getHeight() * #textLines

    spvz = SpectrumVisualizer("assets/sounds/Tracks/neon_code.ogg", 1024, 32)

    fogFx = Fog(love.graphics.newImage("assets/images/menus/glow.png"))

    knifeevent.on("beatHit", function()
        logoBumpSize = 0.23
        Expander.add(nxLogoFX, 0.2, 0.2, 1.66, 0.03, 0.3)
    end)
end

function CreditsState:draw()
    love.graphics.printf(creditsText, f_credits, 0, yText, love.graphics.getWidth(), "center")

    love.graphics.draw(fogFx, 0, love.graphics.getHeight())

    spvz:draw(0, love.graphics.getHeight() - 128, 64, 0.3)

    love.graphics.setHexColor("#000000ff")
    love.graphics.rectangle("fill", 0, 0, love.graphics.getWidth(), 130)
    love.graphics.draw(gradientFade, 0, 130, 0, love.graphics.getWidth(), 128)
    
    love.graphics.rectangle("fill", 0, love.graphics.getHeight() - 130, love.graphics.getWidth(), 130)
    love.graphics.draw(gradientFade, 0, love.graphics.getHeight() - 130, 0, love.graphics.getWidth(), -128)
    love.graphics.setHexColor("#ffffffff")

    Expander.draw(love.graphics.getWidth() / 2, 84, 0)

    love.graphics.draw(nxLogo, love.graphics.getWidth() / 2, 84, 0, logoBumpSize, logoBumpSize, nxLogo:getWidth() / 2 , nxLogo:getHeight() / 2)
end

function CreditsState:update(elapsed)
    Conductor.songPos = (neonCodeCreditsSoundtrack:tell() * 1000)
    Conductor.update(elapsed)

    if not neonCodeCreditsSoundtrack:isPlaying() then
        neonCodeCreditsSoundtrack:play()
    end

    if neonCodeCreditsSoundtrack:isPlaying() then
        spvz:update(elapsed, neonCodeCreditsSoundtrack)
    end

    yText = yText - 90 * elapsed

    logoBumpSize = math.lerp(logoBumpSize, 0.2, 0.3)

    Expander.update(elapsed)

    if yText <= -textH then
        yText = love.graphics.getHeight() - 20
    end

    if love.keyboard.isDown("escape") then
        
    end

    fogFx:update(elapsed)
end

return CreditsState