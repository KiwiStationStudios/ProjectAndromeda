MenuState = {}

local function loadingPopup(t, progress)
    t:setCursorBackColor(t.schemes.basic["white"])
    t:setCursorColor(t.schemes.basic["black"])
    t:fill("halfgrid", math.floor(t.width / 2 - 24 / 2) + 1, math.floor(t.height / 2 - 3) + 1, 24, 5)
    t:setCursorBackColor(t.schemes.basic["brightWhite"])
    t:clear(math.floor(t.width / 2 - 24 / 2), math.floor(t.height / 2 - 3), 24, 5)
    t:frame("line", math.floor(t.width / 2 - 24 / 2), math.floor(t.height / 2 - 3), 24, 5)
    t:print(math.floor(t.width / 2 - 24 / 2) + 1, math.floor(t.height / 2 - 3) + 1, string.justify("Loading application...", math.floor(t.width / 2 - 24 / 2), nil, "center"))
end

function MenuState:enter()
    --menuComposer = require 'src.Components.Modules.Game.Menus.MenuComposer'
    menuList = require 'src.Components.Modules.Game.Menus.MenuListController'

    effect = moonshine(moonshine.effects.crt)
    .chain(moonshine.effects.glow)
    .chain(moonshine.effects.scanlines)
    effect.scanlines.opacity = 0.6
    effect.glow.min_luma = 0.2

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

    local termFont = fontcache.getFont("compaqthin", 22)
    termview = terminal(love.graphics.getWidth(), love.graphics.getHeight(), termFont)
    termview.speed = 5000

    print(termview.width, termview.height)

    scrTimer = timer.new()

    termview:hideCursor()

    termview:frame("line", 1, 1, termview.width, termview.height)
    termview:print(math.floor(termview.width / 2 - #("NX-DOS v0.0.1") / 2), 1, "NX-DOS v0.0.1")
    termview:blitSprite("assets/data/rpd/doslogo.rpd", math.floor(termview.width / 2 - 49 / 2), 2)

    menu = menuList(termview, "center", 18, 10, "double")

    menu:addItems({
        {
            label = languageService["main_menu_options_story_mode"],
            action = function()
                --gamestate.switch(LevelSelectState)
                -- display popup --
            end
        },
        {
            label = languageService["main_menu_options_freeplay_mode"],
            action = function()
                scrTimer:script(function(sleep)
                    loadingPopup(termview)
                    sleep(250 / 1000)
                    gamestate.switch(LevelSelectState)
                end)
            end
        },
        {
            label = languageService["main_menu_options_editor_mode"],
            action = function()
                scrTimer:script(function(sleep)
                    loadingPopup(termview)
                    sleep(250 / 1000)
                    gamestate.switch(EditorMenuState)
                end)
            end
        },
        {
            label = languageService["main_menu_options_community_mode"],
            action = function()
                scrTimer:script(function(sleep)
                    loadingPopup(termview)
                    sleep(250 / 1000)
                    gamestate.switch(CommunityMenuState)
                end)
            end
        },
        {
            label = languageService["main_menu_options_customization_mode"],
            action = function()
                scrTimer:script(function(sleep)
                    loadingPopup(termview)
                    sleep(250 / 1000)
                    gamestate.switch(PlayerCustomizationState)
                end)
            end
        },
        {
            label = languageService["main_menu_options_settings_mode"],
            action = function()
                scrTimer:script(function(sleep)
                    loadingPopup(termview)
                    sleep(250 / 1000)
                    gamestate.switch(SettingsState)
                end)
            end
        },
        {
            label = languageService["main_menu_options_shutdown"],
            action = function()
                scrTimer:script(function(sleep)
                    termview:clear(1, 1, termview.width, termview.height)
                    sleep(40 / 60)
                    termview:print("Shutting down.")
                    sleep(60 / 60)
                    love.event.quit()
                end)
            end
        }
    })

    menu:compose()

    --termview:fill("grid", 2, 13, termview.width - 2, termview.height - 13)
end

function MenuState:draw()
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

function MenuState:update(elapsed)
    termview:update(elapsed)
    scrTimer:update(elapsed)
end

function MenuState:keypressed(k)
    menu:updateKeyboard(k)
end

return MenuState