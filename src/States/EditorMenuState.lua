EditorMenuState = {}

function EditorMenuState:init()
    buttonPatch = require 'src.Components.Modules.Game.Utils.PatchButton'
    clickzone = require 'src.Components.Modules.Game.Menu.SelectionClick'
    particleController = require 'src.Components.Modules.Game.Graphics.ParticleController'

    --editorHubParticles = require("src.Components.Modules.Game.Menu.EditorMenu.EditorMenuParticles")()
    
    userIconImage, userIconQuads = love.graphics.getHashedQuads("assets/images/menus/menuIcons")
    print(debug.formattable(userIconQuads))
    lockIcon = userIconQuads["lock"]

    menuCam = camera(love.graphics.getWidth() + 512)

    if not crymsonEdgeMenuTheme then
        crymsonEdgeMenuTheme = love.audio.newSource("assets/sounds/Tracks/crymson_edge.ogg", "static")
    end
    crymsonEdgeMenuTheme:setVolume(registers.system.settings.audio.music)

    particleFX = particleController("assets/data/particles/EditorListBGParticles.lua")
end

function EditorMenuState:enter()
    menuIcons = {
        editorBrowse = love.graphics.newImage("assets/images/menus/editorHubBrowse.png"),
        editorLevelList = love.graphics.newImage("assets/images/menus/editorHubEditor.png"),
        editorSavedList = love.graphics.newImage("assets/images/menus/editorHubSaved.png"),
    }

    mouseData = {x = 0, y = 0}
    mouseData.x, mouseData.y = love.mouse.getPosition()

    menuContent = {
        {
            icon = menuIcons.editorLevelList,
            name = "createLevel",
            title = languageService["menu_selection_editor_hub_create"],
            selected = false,
            sizeMulti = 0,
            textAlpha = 0,
            changeState = LevelEditorListState,
            lock = {
                locked = false,
                alpha = 0,
                color = {1, 1, 1}
            }
        },
        {
            icon = menuIcons.editorBrowse,
            name = "browseLevels",
            title = languageService["menu_selection_editor_hub_browse"],
            selected = false,
            sizeMulti = 0,
            textAlpha = 0,
            changeState = LevelBrowserState,
            lock = {
                locked = false,
                alpha = 0,
                color = {1, 1, 1}
            }
        },
        {
            icon = menuIcons.editorSavedList,
            name = "saveLevel",
            title = languageService["menu_selection_editor_hub_saved"],
            selected = false,
            sizeMulti = 0,
            textAlpha = 0,
            changeState = SavedListState,
            lock = {
                locked = false,
                alpha = 0,
                color = {1, 1, 1}
            }
        }
    }

    optionSelected = 0

    f_menuSelection = fontcache.getFont("quicksand_regular", 32)
    f_optionDesc = fontcache.getFont("quicksand_light", 24)

    enterCamAnimTransitionRunning = true

    enterCamTweenGroup = flux.group()
    enterCamTween = enterCamTweenGroup:to(menuCam, 0.5, {x = love.graphics.getWidth() / 2})
    enterCamTween:ease("backout")
    enterCamTween:oncomplete(function()
        enterCamAnimTransitionRunning = false
    end)

    backButtonClick = buttonPatch("assets/images/framestyles/frameStyle_linesmooth", "<<<", 20, 20, 128, 48, "comfortaa_regular", 20)
end

function EditorMenuState:draw()
    menuCam:attach()
        love.graphics.setBlendMode("add")
            --love.graphics.draw(editorHubParticles, love.graphics.getWidth(), 0)
            particleFX:draw()
        love.graphics.setBlendMode("alpha")

        --love.graphics.printf(languageService["menu_selection_editor_hub_title"], f_menuSelection, 0, 96, love.graphics.getWidth(), "center")

        for _, b in pairs(menuContent) do
            local optionListBoxW = love.graphics.getWidth() - (256 / #menuContent)
            local fraction = optionListBoxW / #menuContent
            local optionBoxW = fraction - 16
            local optionBoxX = 256 + _ * fraction - fraction / 2 - optionBoxW / 2
            if not b.btn then
                b.btn = clickzone(optionBoxX - 128, (love.graphics.getHeight() / 2) - 128, 256, 256)
            end
            b.selected = false
            if b.btn:hovered() then
                b.sizeMulti = 0.04
                b.textAlpha = 1
                b.selected = true
            end
            love.graphics.setColor(b.lock.color)
            love.graphics.draw(
                b.icon, optionBoxX, love.graphics.getHeight() / 2, 0, 
                (256 / b.icon:getWidth()) + b.sizeMulti, (256 / b.icon:getHeight())  + b.sizeMulti, 
                b.icon:getWidth() / 2, b.icon:getHeight() / 2
            )
            love.graphics.setColor(1, 1, 1, 1)

            if b.lock.locked then
                love.graphics.setBlendMode("add")
                    love.graphics.setColor(1, 1, 1, b.lock.alpha)
                        local qx, qy, qw, qh = lockIcon:getViewport()
                        love.graphics.draw(userIconImage, lockIcon, optionBoxX, love.graphics.getHeight() / 2, 0, 0.6, 0.6, qw / 2, qh / 2)
                    love.graphics.setColor(1, 1, 1, 1)
                love.graphics.setBlendMode("alpha")
            end

            love.graphics.setColor(1, 1, 1, b.textAlpha)
                love.graphics.printf(b.title, f_optionDesc, optionBoxX - 128, (love.graphics.getHeight() / 2) + 148, 256, "center")
            love.graphics.setColor(1, 1, 1, 1)
        end
        backButtonClick:draw()
    menuCam:detach()
end

function EditorMenuState:update(elapsed)
    mouseData.x, mouseData.y = love.mouse.getPosition()
    --editorHubParticles:update(elapsed)
    particleFX:update(elapsed)
    backButtonClick.mx, backButtonClick.my = love.mouse.getPosition()

    for _, b in pairs(menuContent) do
        --print(b.mx, b.my)
        b.sizeMulti = math.lerp(b.sizeMulti, 0, 0.1)
        b.textAlpha = math.lerp(b.textAlpha, 0, 0.1)
        if b.selected then
            b.lock.alpha = math.lerp(b.lock.alpha, 1, 0.3)

            if b.lock.locked then
                b.lock.color[1] = math.lerp(b.lock.color[1], 0.5, 0.1)
                b.lock.color[2] = math.lerp(b.lock.color[2], 0.5, 0.1)
                b.lock.color[3] = math.lerp(b.lock.color[3], 0.5, 0.1)
            end
        else
            b.lock.alpha = math.lerp(b.lock.alpha, 0, 0.3)

            if b.lock.locked then
                b.lock.color[1] = math.lerp(b.lock.color[1], 1, 0.1)
                b.lock.color[2] = math.lerp(b.lock.color[2], 1, 0.1)
                b.lock.color[3] = math.lerp(b.lock.color[3], 1, 0.1)
            end
        end
    end

    if enterCamAnimTransitionRunning then
        enterCamTweenGroup:update(elapsed)
    end
end

function EditorMenuState:mousepressed(x, y, button)
    if backButtonClick:clicked() then
        gamestate.switch(MenuState)
    end

    for _, b in pairs(menuContent) do
        if button == 1 then
            if b.btn then
                if collision.pointRect(mouseData, b.btn) then
                    if not b.lock.locked then
                        gamestate.switch(b.changeState)
                    end
                end
            end
        end
    end
end

return EditorMenuState