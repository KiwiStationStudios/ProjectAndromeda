return function(data)
    slab.BeginWindow("mainMenuGamejoltAccountWindow", {
        Title = languageService["menu_gamejolt_login_panel_title"],
        X = love.graphics.getWidth() / 2,
        Y = love.graphics.getHeight() / 2
    })
        -- this window may be splitted in other files since it maybe can hold more states than just login --
        if gamejolt.isLoggedIn then
            slab.Text(languageService["menu_gamejolt_state_connected"] .. " " .. gameslot.save.game.user.settings.misc.gamejolt.username)
            slab.NewLine()
            slab.BeginLayout("mainMenuGamejoltAccountWindowLoginLayout", {AlignX = "center"})
                if slab.Button(languageService["menu_gamejolt_login_panel_account_settings_create_backup"]) then
                    if gamejolt.isLoggedIn then
                        io.printf(string.format("{bgGreen}{brightWhite}{bold}[Gamejolt]{reset}{brightWhite} : Creating backup for client (%s, %s){reset}\n", gamejolt.username, gamejolt.userToken))
                        local clientID = "nxuser_client_" .. love.data.encode("string", "hex", love.data.hash("sha1", 1))
                        local slotID = v
                        local sucess = gamejolt.setBigData(clientID, love.filesystem.read("slots/" .. slotID .. ".dat"), true)
                        if not sucess then
                            io.printf(string.format("{bgGreen}{brightWhite}{bold}[Gamejolt]{bgRed}{brightWhite}[ERROR]{reset} : Failed to upload data{reset}\n"))
                        end
                    end
                end
                if slab.Button(languageService["menu_gamejolt_login_panel_account_settings_load_backup"]) then
                    
                end
                if slab.Button(languageService["menu_gamejolt_login_panel_account_settings_sign_off"]) then
                    
                end
                if slab.Button(languageService["menu_gamejolt_login_panel_cancel_button"]) then
                    data.uiActive = false
                end
            slab.EndLayout()
        else
            slab.BeginLayout("mainMenuGamejoltAccountWindowLoginLayout", {AlignX = "center"})
                slab.Text(languageService["menu_gamejolt_state_not_connected"])
                slab.Text(languageService["menu_gamejolt_login_panel_desc"])
                slab.NewLine()
                slab.Text(languageService["menu_gamejolt_login_panel_login_text_username"])
                slab.SameLine()
                if slab.Input("mainMenuGamejoltAccountWindowLoginLayoutUsernameInput", {Text = data.sysDetails.username}) then
                    data.sysDetails.username = slab.GetInputText()
                end

                slab.Text(languageService["menu_gamejolt_login_panel_login_text_token"])
                slab.SameLine()
                if slab.Input("mainMenuGamejoltAccountWindowLoginLayoutTokenInput", {Text = data.sysDetails.token}) then
                    data.sysDetails.token = slab.GetInputText()
                end

                if slab.Button(languageService["menu_gamejolt_login_panel_login_button"]) then
                    local connected = gamejolt.authUser(data.sysDetails.username, data.sysDetails.token)
                    data.dialogStatusOpen = true
                    if connected then
                        if data.dialogStatusOpen then
                            local rst = slab.MessageBox(languageService["menu_gamejolt_login_panel_state_sucess_title"], languageService["menu_gamejolt_login_panel_state_sucess"])
                            if rst ~= "" then
                                data.dialogStatusOpen = false
                            end
                        end
                        gameslot.save.game.user.settings.misc.gamejolt.username = data.sysDetails.username
                        gameslot.save.game.user.settings.misc.gamejolt.usertoken = data.sysDetails.token

                        gameslot:saveSlot()
                    else
                        if data.dialogStatusOpen then
                            local rst = slab.MessageBox(languageService["menu_gamejolt_login_panel_state_fail_title"], languageService["menu_gamejolt_login_panel_state_fail"])
                            if rst ~= "" then
                                data.dialogStatusOpen = false
                            end
                        end
                    end
                end
                if slab.Button(languageService["menu_gamejolt_login_panel_cancel_button"]) then
                    data.sysDetails.username = ""
                    data.sysDetails.token = ""
                    data.uiActive = false
                end
            slab.EndLayout()
        end
    slab.EndWindow()
end