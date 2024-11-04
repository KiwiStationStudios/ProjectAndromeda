local createLevelFunction = require 'src.Components.Modules.Game.Editor.Functions.CreateLevel'

return function()
    slab.BeginWindow("createLevelWindow", { Title = languageService["menu_level_list_window_title"], X = love.graphics.getWidth() / 2, Y = love.graphics.getHeight() / 2 })
        slab.Textf(languageService["menu_level_list_window_text"], {Align = "center"})
        if slab.Input('createLevelWindowLevelNameInput', { Text = registers.system.editor.interface.createForm.levelname }) then
            registers.system.editor.interface.createForm.levelname = slab.GetInputText()
        end
        slab.Separator()
        if slab.Button(languageService["menu_level_list_window_button_cancel"]) then
            createLevelPanelOpen = false
            registers.system.editor.interface.createForm.levelname = ""
        end
        slab.SameLine()
        if slab.Button(languageService["menu_level_list_window_button_create"]) then
            createLevelFunction(registers.system.editor.interface.createForm.levelname)
            createLevelPanelOpen = false
            registers.system.editor.interface.createForm.levelname = ""
            LevelEditorListState.refreshLevelList()
        end
    slab.EndWindow()
end