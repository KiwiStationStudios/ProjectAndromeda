EditorMenuState = {}

function EditorMenuState:init()
    clickzone = require 'src.Components.Modules.Game.Menu.SelectionClick'
    particleController = require 'src.Components.Modules.Game.Graphics.ParticleController'

    --editorHubParticles = require("src.Components.Modules.Game.Menu.EditorMenu.EditorMenuParticles")()
    
    userIconImage, userIconQuads = love.graphics.getHashedQuads("assets/images/menus/menuIcons")
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

    menuContent = {
        {
            icon = menuIcons.editorLevelList,
            name = "createLevel",
            title = languageService["menu_selection_editor_hub_create"],
            selected = false,
            sizeMulti = 0,
            textAlpha = 0,
            changeState = EditorLevelListState,
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
end

function EditorMenuState:draw()
    menuCam:attach()
        love.graphics.setBlendMode("add")
            --love.graphics.draw(editorHubParticles, love.graphics.getWidth(), 0)
            particleFX:draw()
        love.graphics.setBlendMode("alpha")

        --love.graphics.printf(languageService["menu_selection_editor_hub_title"], f_menuSelection, 0, 96, love.graphics.getWidth(), "center")

        for i = 1, #menuContent, 1 do
            local optionListBoxW = love.graphics.getWidth() - (256 / #menuContent)
            local fraction = optionListBoxW / #menuContent
            local optionBoxW = fraction - 16
            local optionBoxX = 256 + i * fraction - fraction / 2 - optionBoxW / 2
            if not menuContent[i].btn then
                menuContent[i].btn = clickzone(optionBoxX - 128, (love.graphics.getHeight() / 2) - 128, 256, 256)
            end
            menuContent[i].selected = false
            if menuContent[i].btn:hovered() then
                menuContent[i].sizeMulti = 0.04
                menuContent[i].textAlpha = 1
                menuContent[i].selected = true
            end
            love.graphics.setColor(menuContent[i].lock.color)
            love.graphics.draw(
                menuContent[i].icon, optionBoxX, love.graphics.getHeight() / 2, 0, 
                (256 / menuContent[i].icon:getWidth()) + menuContent[i].sizeMulti, (256 / menuContent[i].icon:getHeight())  + menuContent[i].sizeMulti, 
                menuContent[i].icon:getWidth() / 2, menuContent[i].icon:getHeight() / 2
            )
            love.graphics.setColor(1, 1, 1, 1)

            if menuContent[i].lock.locked then
                love.graphics.setBlendMode("add")
                    love.graphics.setColor(1, 1, 1, menuContent[i].lock.alpha)
                        local qx, qy, qw, qh = lockIcon:getViewport()
                        love.graphics.draw(userIconImage, lockIcon, optionBoxX, love.graphics.getHeight() / 2, 0, 0.6, 0.6, qw / 2, qh / 2)
                    love.graphics.setColor(1, 1, 1, 1)
                love.graphics.setBlendMode("alpha")
            end

            love.graphics.setColor(1, 1, 1, menuContent[i].textAlpha)
                love.graphics.printf(menuContent[i].title, f_optionDesc, optionBoxX - 128, (love.graphics.getHeight() / 2) + 148, 256, "center")
            love.graphics.setColor(1, 1, 1, 1)
        end
    menuCam:detach()
end

function EditorMenuState:update(elapsed)
    --editorHubParticles:update(elapsed)
    particleFX:update(elapsed)

    for i = 1, #menuContent, 1 do
        menuContent[i].sizeMulti = math.lerp(menuContent[i].sizeMulti, 0, 0.1)
        menuContent[i].textAlpha = math.lerp(menuContent[i].textAlpha, 0, 0.1)
        if menuContent[i].selected then
            menuContent[i].lock.alpha = math.lerp(menuContent[i].lock.alpha, 1, 0.3)

            if menuContent[i].lock.locked then
                menuContent[i].lock.color[1] = math.lerp(menuContent[i].lock.color[1], 0.5, 0.1)
                menuContent[i].lock.color[2] = math.lerp(menuContent[i].lock.color[2], 0.5, 0.1)
                menuContent[i].lock.color[3] = math.lerp(menuContent[i].lock.color[3], 0.5, 0.1)
            end
        else
            menuContent[i].lock.alpha = math.lerp(menuContent[i].lock.alpha, 0, 0.3)

            if menuContent[i].lock.locked then
                menuContent[i].lock.color[1] = math.lerp(menuContent[i].lock.color[1], 1, 0.1)
                menuContent[i].lock.color[2] = math.lerp(menuContent[i].lock.color[2], 1, 0.1)
                menuContent[i].lock.color[3] = math.lerp(menuContent[i].lock.color[3], 1, 0.1)
            end
        end
    end

    if enterCamAnimTransitionRunning then
        enterCamTweenGroup:update(elapsed)
    end
end

function EditorMenuState:mousepressed(x, y, button)
    for i = 1, #menuContent, 1 do
        if menuContent[i].btn:hovered() then
            if button == 1 then
                if not menuContent[i].lock.locked then
                    gamestate.switch(menuContent[i].changeState)
                end
            end
        end
    end
end

return EditorMenuState