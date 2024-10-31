TitleState = {}

function TitleState:init()
    Conductor = require 'src.Components.Modules.Game.Conductor'
    SpectrumVisualizer = require 'src.Components.Modules.Game.Graphics.SpecVisualizer'
    Expander = require 'src.Components.Modules.Game.Graphics.Expander'
    Fog = require 'src.Components.Modules.Game.Graphics.Fog'

    nxLogo = love.graphics.newImage("assets/images/menus/logo_thingy.png")
    nxLogoFX = love.graphics.newImage("assets/images/menus/logo_fx.png")
    sun = love.graphics.newImage("assets/images/menus/sun.png")
    hills = love.graphics.newImage("assets/images/menus/hills.png")
    grid = love.graphics.newImage("assets/images/menus/grid.png")
    titleText = love.graphics.newImage("assets/images/menus/menuText.png")
    gradientBG = love.graphics.newGradient("vertical", {11, 11, 11, 255}, {11, 11, 11, 255}, {100, 100, 100, 255}, {11, 11, 11, 255}, {11, 11, 11, 255})
    gridGradientBG = love.graphics.newGradient("horizontal", {11, 11, 11, 255}, {45, 45, 45, 255}, {100, 100, 100, 255}, {45, 45, 45, 255}, {11, 11, 11, 255})

    gridGradient = love.graphics.newGradient("vertical", {255, 255, 255, 255}, {0, 0, 0, 0})

    Conductor.bpm = 91 / 2

    if not crymsonEdgeMenuTheme then
        crymsonEdgeMenuTheme = love.audio.newSource("assets/sounds/Tracks/future_base.ogg", "static")
    end
    crymsonEdgeMenuTheme:setVolume(registers.system.settings.audio.music)
    
    spvzmenu = SpectrumVisualizer("assets/sounds/Tracks/future_base.ogg", 1024, 32)
    
    fogGlowFx = Fog(love.graphics.newImage("assets/images/menus/glow.png"))

    menuCam = camera()
    menuCam.y = menuCam.y - 96

    knifeevent.hook(Conductor, { "beatHit" })

    glowSize = 0
    logoBumpSize = 0.3

    alphaText = 1
    enterPressed = false
    flash = 0

    camTween = flux.to(menuCam, 3, {y = menuCam.y + love.graphics.getHeight()})
    camTween:delay(1.8)
    camTween:ease("backin")
    camTween:oncomplete(function()
        gamestate.switch(MenuState)
    end)

    time = 0

    knifeevent.on("beatHit", function()
        logoBumpSize = 0.35
        glowSize = 512
        Expander.add(nxLogoFX, 0.3, 0.3, 1.66, 0.03, 0.5)
    end)
end

function TitleState:draw()
    menuCam:attach()
        love.graphics.draw(gradientBG, 0, -256, 0, 1280, 768 + 512)
        love.graphics.draw(sun, love.graphics.getWidth() / 2, 256, 0, 1, 1, sun:getWidth() / 2, sun:getHeight() / 2)

        love.graphics.draw(fogGlowFx, 0, love.graphics.getHeight() / 2)

        love.graphics.setColor(1, 1, 1, 0.5)
        love.graphics.setBlendMode("add")
        love.graphics.draw(gridGradient, 0, 376, 0, 1280, -glowSize)
        love.graphics.setBlendMode("alpha")
        love.graphics.setColor(1, 1, 1, 1)

        spvzmenu:draw(0, love.graphics.getHeight() / 2, 64, 0.3)
        love.graphics.draw(hills, love.graphics.getWidth() / 2, 64, 0, 0.6, 0.7, hills:getWidth() / 2)
        love.graphics.draw(hills, -love.graphics.getWidth() / 2 + 96, 64, 0, 0.6, 0.7, hills:getWidth() / 2)
        love.graphics.draw(gridGradientBG, 0, 376, 0, 1280, 460)
        love.graphics.setColor(1, 1, 1, 0.5)
        love.graphics.setBlendMode("add")
        love.graphics.draw(gridGradient, 0, 376, 0, 1280, 256)
        love.graphics.setBlendMode("alpha")
        love.graphics.setColor(1, 1, 1, 1)
        love.graphics.draw(grid, 0, 376, 0, 1280 / grid:getWidth(), 0.9)

        love.graphics.draw(nxLogo, love.graphics.getWidth() / 2, 128, 0, logoBumpSize, logoBumpSize, nxLogo:getWidth() / 2 , nxLogo:getHeight() / 2)
        Expander.draw(love.graphics.getWidth() / 2, 128, 0)

        love.graphics.setColor(0, 0, 0, 1)
        love.graphics.rectangle("fill", 0, love.graphics.getHeight() - 128, love.graphics.getWidth(), 512)
        love.graphics.draw(gridGradient, 0, love.graphics.getHeight() - 128, 0, 1280, -128)
        love.graphics.setColor(1, 1, 1, 1)
    menuCam:detach()
    love.graphics.setColor(1, 1, 1, alphaText)
    love.graphics.draw(titleText, love.graphics.getWidth() / 2, 600, 0, 0.45, 0.45, titleText:getWidth() / 2, titleText:getHeight() / 2)
    love.graphics.setColor(1, 1, 1, 1)
    love.graphics.setColor(1, 1, 1, flash)
    love.graphics.rectangle("fill", 0, 0, love.graphics.getWidth(), love.graphics.getHeight())
    love.graphics.setColor(1, 1, 1, 1)
end

function TitleState:update(elapsed)
    time = time + elapsed
    Conductor.songPos = (crymsonEdgeMenuTheme:tell() * 1000)
    Conductor:update(elapsed)

    if not crymsonEdgeMenuTheme:isPlaying() then
        crymsonEdgeMenuTheme:play()
    end

    if crymsonEdgeMenuTheme:isPlaying() then
        spvzmenu:update(elapsed, crymsonEdgeMenuTheme)
    end

    menuCam.y = menuCam.y + math.cos(time) / 1.5 + 0.07 * elapsed
    --menuCam.y = math.cos(time) / 1.5 + 0.07 * elapsed

    glowSize = math.lerp(glowSize, 0, 0.1)
    logoBumpSize = math.lerp(logoBumpSize, 0.3, 0.3)

    if flash > 0 then
        flash = flash - 1.5 * elapsed
    end

    Expander.update(elapsed)

    if enterPressed then        
        flux.update(elapsed)
        if flash <= 0 then
            if alphaText > 0 then
                alphaText = alphaText - 3.2 * elapsed
            end
        end
    end

    fogGlowFx:update(elapsed)
end

function TitleState:keypressed(k)
    if k == "return" then
        if not enterPressed then
            enterPressed = true
            flash = 1
        end
    end
end

return TitleState