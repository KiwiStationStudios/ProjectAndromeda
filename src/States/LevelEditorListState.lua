LevelEditorListState = {}

function LevelEditorListState.refreshLevelList()
    lume.clear(levelListPanels)
    local levelsListFiles = love.filesystem.getDirectoryItems("user/editor")

    for _, m in ipairs(levelsListFiles) do
        local typeF = love.filesystem.getInfo("user/editor/" .. m)
        if typeF.type == "directory" then
            table.insert(levelListPanels, {
                levelname = levelsListFiles[_],
                panel = patchPanel(
                    "assets/images/framestyles/frameStyle_linesmooth", 20, 
                    128 * _ * 1.1, -- <---- between the numbers, his name is joe --
                    love.graphics.getWidth() - 76, 96
                ),
                buttons = {
                    edit = buttonPatch("assets/images/framestyles/frameStyle_linesmooth", languageService["level_list_item_buttons_edit"], (100 * 1 * 1.5) + (love.graphics.getWidth() / 2), (128 * _ * 1.1) + 24, 96, 32, "comfortaa_regular", 16),
                    upload = buttonPatch("assets/images/framestyles/frameStyle_linesmooth", languageService["level_list_item_buttons_upload"], (100 * 2 * 1.5) + (love.graphics.getWidth() / 2), (128 * _ * 1.1) + 24, 96, 32, "comfortaa_regular", 16),
                    delete = buttonPatch("assets/images/framestyles/frameStyle_linesmooth", languageService["level_list_item_buttons_delete"], (100 * 3 * 1.5) + (love.graphics.getWidth() / 2), (128 * _ * 1.1) + 24, 96, 32, "comfortaa_regular", 16)
                } 
            })
        end
    end
end

function LevelEditorListState:init()
    buttonPatch = require 'src.Components.Modules.Game.Utils.PatchButton'
    patchPanel = require 'src.Components.Modules.Game.Utils.patchPanel'
    selectionClick = require 'src.Components.Modules.Game.Menu.SelectionClick'
    createLevelForm = require 'src.Components.Modules.Interface.CreateLevelForm'

    levelsList = {}

    menuIcons_sheet, menuIcons_quads = love.graphics.getHashedQuads("assets/images/menus/menuIcons")
    fnt_missionSelect = fontcache.getFont("comfortaa_semibold", 26)
    fnt_warnList = fontcache.getFont("comfortaa_bold", 36)

    listCam = camera()
    listCamScroll = love.graphics.getHeight() / 2
    listCamY = love.graphics.getHeight() / 2
end

function LevelEditorListState:enter()
    --Presence.largeImageKey = "map_select_rpc"
    --Presence.largeImageText = "Selection mission"
    Presence.state = "Editing level"
    Presence.details = "Selecting Level"
    Presence.update()

    if not crymsonEdgeMenuTheme then
        crymsonEdgeMenuTheme = love.audio.newSource("assets/sounds/Tracks/future_base.ogg", "static")
    end
    crymsonEdgeMenuTheme:setVolume(registers.system.settings.audio.music)
    crymsonEdgeMenuTheme:setLooping(true)
    if not crymsonEdgeMenuTheme:isPlaying() then
        crymsonEdgeMenuTheme:play()
    end

    levelListPanels = {}

    LevelEditorListState.refreshLevelList()
    createLevelPanelOpen = false

    listLevelCreate = buttonPatch("assets/images/framestyles/frameStyle_linesmooth", languageService["menu_level_list_create"], 0, 32, 128, 48, "comfortaa_regular", 20)
    listLevelCreate.x = (love.graphics.getWidth() - listLevelCreate.w) - 42
    backButton = buttonPatch("assets/images/framestyles/frameStyle_linesmooth", "<<<", 10, 32, 128, 48, "comfortaa_regular", 20)
end

function LevelEditorListState:draw()
    love.graphics.setColor(0.5, 0.5, 0.5, 1)
        love.graphics.printf(languageService["menu_level_list_title"], fnt_missionSelect, 0, 52, love.graphics.getWidth(), "center")
    love.graphics.setColor(1, 1, 1, 1)
    love.graphics.printf(languageService["menu_level_list_title"], fnt_missionSelect, 0, 48, love.graphics.getWidth(), "center")

    love.graphics.stencil(function()
        love.graphics.rectangle("fill", 10, 118, love.graphics.getWidth() - 20, love.graphics.getHeight() - 150, 5) 
    end, "replace", 1)

    love.graphics.setLineWidth(3)
    love.graphics.rectangle("line", 10, 118, love.graphics.getWidth() - 20, love.graphics.getHeight() - 150, 5) 
    love.graphics.setLineWidth(1)
    love.graphics.setStencilTest("greater", 0)
    listCam:attach()
        if #levelListPanels > 0 then
            for _, e in ipairs(levelListPanels) do
                e.panel:draw()

                love.graphics.printf(e.levelname, fnt_missionSelect, 40, (128 * _ * 1.1) + 54, love.graphics.getWidth() / 2, "left")

                for _, button in pairs(e.buttons) do
                    button:draw()
                end
            end
        else
            love.graphics.printf(languageService["menu_level_list_warn_list_empty"], fnt_warnList, 20, 350, love.graphics.getWidth() - 20, "center")
        end
    listCam:detach()
    love.graphics.setStencilTest()

    listLevelCreate:draw()
    backButton:draw()

    slab.Draw()
end

function LevelEditorListState:update(elapsed)
    slab.Update(elapsed)
    listCamY = listCamY - (listCamY - listCamScroll) * 0.05
    listCam.y = listCamY

    listLevelCreate.mx, listLevelCreate.my = love.mouse.getPosition()
    backButton.mx, backButton.my = love.mouse.getPosition()

    if #levelListPanels > 0 then
        for _, e in ipairs(levelListPanels) do
            for _, button in pairs(e.buttons) do
                button.mx, button.my = listCam:mousePosition()
            end
        end
    end

    if listCamScroll <= love.graphics.getHeight() / 2 then
        listCamScroll = love.graphics.getHeight() / 2
    end

    if #levelListPanels > 0 then
        if listCamScroll >= levelListPanels[#levelListPanels].panel.y - 214 then
            listCamScroll = levelListPanels[#levelListPanels].panel.y - 214
        end
    end

    if createLevelPanelOpen then
        createLevelForm()
    end
end

function LevelEditorListState:mousepressed(x, y, button)
    if listLevelCreate:clicked() then
        createLevelPanelOpen = true
        registers.system.editor.interface.createForm.levelname = ""
    end

    if backButton:clicked() then
        gamestate.switch(EditorMenuState)
    end

    if #levelListPanels > 0 then
        for _, e in ipairs(levelListPanels) do
            if e.buttons.edit:clicked() then
                crymsonEdgeMenuTheme:stop()
                EditorState.levelfolder = e.levelname
                gamestate.switch(EditorState)
            end
            if e.buttons.upload:clicked() then
                print("edit2")
            end
            if e.buttons.delete:clicked() then
                print("edit3")
            end
        end
    end
end

function LevelEditorListState:wheelmoved(x, y)
    if not createLevelPanelOpen then
        if y < 0 then
            listCamScroll = listCamScroll + 64
        end
        if y > 0 then
            listCamScroll = listCamScroll - 64
        end
    end
end

return LevelEditorListState