MenuState = {}

function MenuState:enter()
    MenuBGParticles = require 'src.Components.Modules.Game.Menu.MenuParticleSystem'
    clickzone = require 'src.Components.Modules.Game.Menu.SelectionClick'
    logonUI = require 'src.Components.Modules.Interface.GamejoltLoginUI'

    slab.SetINIStatePath(nil)
    slab.Initialize({"NoDocks"})

    MenuBGP = MenuBGParticles()

    if not crymsonEdgeMenuTheme then
        crymsonEdgeMenuTheme = love.audio.newSource("assets/sounds/Tracks/crymson_edge.ogg", "static")
    end
    crymsonEdgeMenuTheme:setVolume(registers.system.settings.audio.music)

    userIconImage, userIconQuads = love.graphics.getHashedQuads("assets/images/menus/menuIcons")

    sunBG = love.graphics.newImage("assets/images/menus/sun.png")
    sunGlow = love.graphics.newImage("assets/images/menus/lightDot.png")
    lockIcon = userIconQuads["lock"]

    userUI = {
        userIcon = userIconQuads["userIcon"],
        error = userIconQuads["errorIcon"],
        sucess = userIconQuads["sucessIcon"],
        sizeMulti = 0,
        textAlpha = 0,
        hovered = false,
        uiActive = false,
        bgUIAlpha = 0,
        sysDetails = {
            username = "",
            token = ""
        },
        clickzone = clickzone(32, 32, 64, 64),
        dialogStatusOpen = false,
        panel = {
            signOffConfirmDialog = false,
            backupRunning = false,
            loadingRunning = false,
        }
    }

    menuCam = camera(love.graphics.getWidth() / 2, -love.graphics.getHeight() - 512)

    menuIcons = {
        normal = love.graphics.newImage("assets/images/menus/selectionNormal.png"),
        editor = love.graphics.newImage("assets/images/menus/selectionEditor.png"),
        customize = love.graphics.newImage("assets/images/menus/selectionPlayerEditor.png")
    }

    menuContent = {
        {
            icon = menuIcons.editor,
            name = "editor",
            title = languageService["menu_selection_editor_title"],
            selected = false,
            sizeMulti = 0,
            textAlpha = 0,
            changeState = EditorMenuState,
            lock = {
                locked = false,
                alpha = 0,
                color = {1, 1, 1}
            }
        },
        {
            icon = menuIcons.normal,
            name = "freeplay",
            title = languageService["menu_selection_normal_title"],
            selected = false,
            sizeMulti = 0,
            textAlpha = 0,
            changeState = FreeplayState,
            lock = {
                locked = false,
                alpha = 0,
                color = {1, 1, 1}
            }
        },
        {
            icon = menuIcons.customize,
            name = "customize",
            title = languageService["menu_selection_char_editor_title"],
            selected = false,
            sizeMulti = 0,
            textAlpha = 0,
            changeState = CharEditorState,
            lock = {
                locked = false,
                alpha = 0,
                color = {1, 1, 1}
            }
        }
    }

    sunRotation = 0
    optionSelected = 0
    --MenuController.addItem()

    f_menuSelection = fontcache.getFont("quicksand_regular", 32)
    f_optionDesc = fontcache.getFont("quicksand_light", 24)

    enterCamAnimTransitionRunning = true
    leaveCamAnimTransitionRunning = false

    enterCamTweenGroup = flux.group()
    enterCamTween = enterCamTweenGroup:to(menuCam, 3, {y = love.graphics.getHeight() / 2})
    enterCamTween:ease("backout")
    enterCamTween:oncomplete(function()
        enterCamAnimTransitionRunning = false
    end)


    leaveCamTweenGroup = flux.group()
    leaveCamTween= leaveCamTweenGroup:to(menuCam, 1.6, {x = -(love.graphics.getWidth() + 512)})
    leaveCamTween:ease("backin")
    leaveCamTween:oncomplete(function()
        leaveCamAnimTransitionRunning = false
        gamestate.switch(menuContent[optionSelected].changeState)
    end)
end

function MenuState:draw()
    menuCam:attach()
        love.graphics.setBlendMode("add")
        love.graphics.draw(MenuBGP, love.graphics.getWidth() / 2, love.graphics.getHeight() / 2)
        love.graphics.draw(sunGlow, love.graphics.getWidth() / 2, love.graphics.getHeight() / 2, 0, sunBG:getWidth() / sunGlow:getWidth(), sunBG:getHeight() / sunGlow:getHeight(), sunGlow:getWidth() / 2, sunGlow:getHeight() / 2)
        love.graphics.setBlendMode("alpha")
        love.graphics.draw(sunBG, love.graphics.getWidth() / 2, love.graphics.getHeight() / 2, 0, 0.55, 0.55, sunBG:getWidth() / 2, sunBG:getHeight() / 2)

        love.graphics.printf(languageService["menu_selection_title"], f_menuSelection, 0, 96, love.graphics.getWidth(), "center")

        --love.graphics.rectangle("fill", optionBoxX, love.graphics.getHeight() / 2 - 256 / 2, 256, 256, 15)
        for i = 1, #menuContent, 1 do
            local optionListBoxW = love.graphics.getWidth() - (256 / #menuContent)
            local fraction = optionListBoxW / #menuContent
            local optionBoxW = fraction - 16
            local optionBoxX = 256 + i * fraction - fraction / 2 - optionBoxW / 2
            --love.graphics.rectangle("fill", optionBoxX, love.graphics.getHeight() / 2 - 256 / 2, 256, 256, 15)
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
                        --love.graphics.draw(menuContent[i].lock.icon, optionBoxX, love.graphics.getHeight() / 2, 0, 0.7, 0.7, lockIcon:getWidth() / 2, lockIcon:getHeight() / 2)
                        local qx, qy, qw, qh = lockIcon:getViewport()
                        love.graphics.draw(userIconImage, lockIcon, optionBoxX, love.graphics.getHeight() / 2, 0, 0.6, 0.6, qw / 2, qh / 2)
                    love.graphics.setColor(1, 1, 1, 1)
                love.graphics.setBlendMode("alpha")
            end

            love.graphics.setColor(1, 1, 1, menuContent[i].textAlpha)
                love.graphics.printf(menuContent[i].title, f_optionDesc, optionBoxX - 128, (love.graphics.getHeight() / 2) + 148, 256, "center")
            love.graphics.setColor(1, 1, 1, 1)
        end

        --love.graphics.draw(userUI.userIcon, 64, 64, 0, 0.12 + userUI.sizeMulti, 0.12 + userUI.sizeMulti, userUI.userIcon:getWidth() / 2, userUI.userIcon:getHeight() / 2)
        local uqx, uqy, uqw, uqh = userUI.userIcon:getViewport()
        love.graphics.draw(userIconImage, userUI.userIcon, 64, 64, 0, 0.12 + userUI.sizeMulti, 0.12 + userUI.sizeMulti, uqw / 2, uqh / 2)
        if not gamejolt.isLoggedIn then
            love.graphics.draw(userIconImage, userUI.error, 120, 120, 0, 0.18 + userUI.sizeMulti, 0.18 + userUI.sizeMulti, uqw / 2, uqh / 2)
        else
            love.graphics.draw(userIconImage, userUI.sucess, 120, 120, 0, 0.18 + userUI.sizeMulti, 0.18 + userUI.sizeMulti, uqw / 2, uqh / 2)
        end
    menuCam:detach()

    if userUI.uiActive then
        love.graphics.setColor(0, 0, 0, userUI.bgUIAlpha)
        love.graphics.rectangle("fill", 0, 0, love.graphics.getWidth(), love.graphics.getHeight())
        love.graphics.setColor(1, 1, 1, 1)
    end

    slab.Draw()
    love.graphics.setColor(1, 1, 1, 1)
end

function MenuState:update(elapsed)
    MenuBGP:update(elapsed)

    slab.Update(elapsed)
    if userUI.uiActive then
        logonUI(userUI)
    end

    if not userUI.uiActive then
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
    end

    if userUI.clickzone:hovered() then
        userUI.hovered = true
    else
        userUI.hovered = false
    end

    if userUI.hovered then
        userUI.sizeMulti = math.lerp(userUI.sizeMulti, 0.05, 0.05)
    else
        userUI.sizeMulti = math.lerp(userUI.sizeMulti, 0, 0.05)
    end

    if userUI.uiActive then
        userUI.bgUIAlpha = math.lerp(userUI.bgUIAlpha, 0.85, 0.1)
    else
        userUI.bgUIAlpha = math.lerp(userUI.bgUIAlpha, 0, 0.3)
    end

    if enterCamAnimTransitionRunning then
        enterCamTweenGroup:update(elapsed)
    end

    if leaveCamAnimTransitionRunning then
        leaveCamTweenGroup:update(elapsed)
    end
end

function MenuState:mousepressed(x, y, button)
    if not userUI.uiActive then
        for i = 1, #menuContent, 1 do
            if menuContent[i].btn:hovered() then
                if button == 1 then
                    if not menuContent[i].lock.locked then
                        leaveCamAnimTransitionRunning = true
                        optionSelected = i
                    end
                end
            end
        end
    
        if userUI.clickzone:hovered() then
            if button == 1 then
                userUI.uiActive = true
            end
        end
    end
end

return MenuState