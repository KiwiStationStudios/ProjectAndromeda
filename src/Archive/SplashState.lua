SplashState = {}

function SplashState:enter()
    effect = moonshine(moonshine.effects.crt)
    .chain(moonshine.effects.glow)
    .chain(moonshine.effects.scanlines)
    effect.scanlines.opacity = 0.6
    effect.glow.min_luma = 0.2

    --love.graphics.setBackgroundColor(0.3, 0.1, 0.5)

    --effect.disable("glow", "crt")

    bootsfx = love.audio.newSource("assets/sounds/bootsfx.ogg", "static")
    bootbeep = love.audio.newSource("assets/sounds/beepBoot.ogg", "static")
    if not menumain then
        menumain = love.audio.newSource("assets/sounds/tracks/future_base.ogg", "static")
    end
    menumain:setVolume(registers.system.settings.audio.music)

    local termFont = fontcache.getFont("compaqthin", 24)

    termview = terminal(love.graphics.getWidth(), love.graphics.getHeight(), termFont)

    termview:setCursorBackColor(terminal.schemes.basic["black"])
    termview:setCursorColor(terminal.schemes.basic["white"])
    termview:clear(1, 1, termview.width, termview.height)

    termview:hideCursor()

    bootDelayTimer = timer.new()
    act = timer.new()

    bootDelayTimer:after(2, function()
        bootsfx:play()
        act:script(function(sleep)
                termview:showCursor()
            sleep(34 / 60)
                menumain:setLooping(true)
                menumain:play()
                termview:print("Initialization begin...\n")
                termview:hideCursor()
            sleep(54 / 60)
                termview:clear(1, 1, termview.width, termview.height)
            sleep(59 / 60)
                bootsfx:play()

                termview:setCursorColor(terminal.schemes.basic["brightYellow"])
                termview:print(1, 5, string.justify(languageService["splash_menu_warning"], termview.width, nil, "center"))
                termview:setCursorColor(terminal.schemes.basic["white"])
                termview:print(1, 8, languageService["splash_menu_warning_text"])
            sleep(190 / 60)
                termview:clear(1, 1, termview.width, termview.height)
                termview.speed = 5000
            sleep(20 / 60)
                bootbeep:play()
                termview:blitSprite("assets/data/rpd/nxtest.rpd", 15, 3)

                termview:print(1, termview.height - 1, "Powered by ")

                termview:setCursorColor(terminal.schemes.basic["brightMagenta"])
                termview:print(#("Powered by ") + 1, termview.height - 1, "LÖVE")
                termview:setCursorColor(terminal.schemes.basic["white"])
            sleep(190 / 60)
                termview:clear(1, 1, termview.width, termview.height)
            sleep(20 / 60)
                --gamestate.switch(MenuState)
                bootsfx:play()
                termview:blitSprite("assets/data/rpd/nxlogo.rpd", 7, 12)
                termview:setCursorBackColor(terminal.schemes.basic["black"])
                termview:setCursorColor(terminal.schemes.basic["white"])
            sleep(140 / 60)
                termview:clear(1, 1, termview.width, termview.height)
            sleep(30 / 60)
                gamestate.switch(MenuState)
        end)
    end)

    --termview:print("Lorem ipsum dolor sit amet, consectetur adipiscing elit. Proin sed ex justo. Phasellus pretium maximus ex, at condimentum ex hendrerit vitae. Nulla lorem urna, ultricies in urna id, mattis sollicitudin lacus. Ut vestibulum et velit in euismod. Aliquam eget velit placerat, finibus nisi dapibus, pulvinar odio. Quisque sit amet tellus facilisis eros porttitor maximus quis id sapien. Sed tempus eros turpis, eget ullamcorper dui hendrerit id. Aliquam tristique sed ante eu tempus. Duis a libero vel lacus ultrices gravida quis a nulla. Pellentesque quis elit at odio fermentum vehicula. Nunc ut aliquet metus. In ac lectus convallis, suscipit leo quis, mollis justo. Aenean aliquet a quam a fringilla. Nunc condimentum consectetur sodales. ")
    --termview:blitSprite("assets/data/rpd/nxtest.rpd", 15, 3)
end

function SplashState:draw()
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

function SplashState:update(elapsed)
    termview:update(elapsed)
    bootDelayTimer:update(elapsed)
    act:update(elapsed)
end

return SplashState