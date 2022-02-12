----------------------------------------------------------------------------------------------------
function GameCallback_HideLoadScreen()  -- should be called GameCallback_SingleplayerLoadFinished instead
    if Framework.GetLoadScreenNeedButton() == 1 then
        Framework.SetLoadScreenNeedButton(2)
	else
        XGUIEng.PopPage()
        Mouse.CursorShow()
        Input.GameMode()
        Input.KeyBindDown(Keys.ModifierAlt + Keys.F4, "g_MainMenu.OpenExitRequester()", 30)
        GUI_Window.CameFromLoad = 1
	end
end

----------------------------------------------------------------------------------------------------
function GameCallback_OpenLoadScreen()
	InitLoadScreen(nil, 666)
end

----------------------------------------------------------------------------------------------------
function HideLoadScreen()
    Sound.StopVoice("ImportantStuff")
    Game.GameTimeSetFactor(GUI.GetPlayerID(), 1)
    XGUIEng.PopPage()
    Input.GameMode()
    Input.KeyBindDown(Keys.ModifierAlt + Keys.F4, "g_MainMenu.OpenExitRequester()", 30)
    XGUIEng.SetText("/LoadScreen/LoadScreen/ButtonStart", XGUIEng.GetStringTableText("UI_Texts/MainMenuStartGame_center"))
    GUI_Window.CameFromLoad = 1
end

----------------------------------------------------------------------------------------------------
function GameCallback_InitLoadScreen()
	InitLoadScreen(nil, 666)
end

----------------------------------------------------------------------------------------------------
function HideLoadScreenIfNecessary()
    if Framework ~= nil then
        if Framework.GetLoadScreenNeedButton() == 2 then
            Framework.SetLoadScreenNeedButton(0)

            Game.GameTimeSetFactor(GUI.GetPlayerID(), 0)
            Sound.SetPause(0)
            
            local Image, D, R = Framework.GetLoadScreenProps()
            if Image == "loadscreens\\Throneroom.png" then
                XGUIEng.SetText("/LoadScreen/LoadScreen/ButtonStart", XGUIEng.GetStringTableText("UI_Texts/ThroneRoomBriefing_center"))
            end
            
	        XGUIEng.ShowAllSubWidgets("/LoadScreen/LoadScreen/LoadBar1", 0)
	        XGUIEng.ShowWidget("/LoadScreen/LoadScreen/ButtonStart", 1)
	        
            Mouse.CursorShow()

        end
        
        if Network ~= nil then
            if Framework.IsNetworkGame() == true and Network.SessionHaveAllPlayersFinishedLoading() == true then
                if Framework.GetLoadScreenNeedButton() == 0 then
                    Framework.SetLoadScreenNeedButton(3)
                else
                    Framework.SetLoadScreenNeedButton(0)
                    XGUIEng.PopPage()
                    Mouse.CursorShow()
                    Input.GameMode()
                    Input.KeyBindDown(Keys.ModifierAlt + Keys.F4, "g_MainMenu.OpenExitRequester()", 30)
          	    end
    	    end
    	end
	end
end

----------------------------------------------------------------------------------------------------

function RemapKnightID( _ID )
    return _ID
end

function InitLoadScreen(Throneroom, MapType, MapName, Campaign, KnightID)

	XGUIEng.PushPage("/LoadScreen/LoadScreen", true)
	XGUIEng.ShowAllSubWidgets("/LoadScreen/LoadScreen", 1)
	XGUIEng.ShowAllSubWidgets("/LoadScreen/LoadScreen/ContainerDescription", 1)
	XGUIEng.ShowAllSubWidgets("/LoadScreen/LoadScreen/LoadBar1", 1)
	XGUIEng.ShowWidget("/LoadScreen/LoadScreen/ButtonStart", 0)

    Input.NoneMode()
    Mouse.CursorHide()

    if Throneroom == nil or MapType == 666 then
        local Image, Description, RealMapName = Framework.GetLoadScreenProps()
        XGUIEng.SetMaterialTexture("/LoadScreen/LoadScreen/LoadScreenBgd", 0, Image)
        XGUIEng.SetText("/LoadScreen/LoadScreen/ContainerDescription/LoadScreenReadMe", Description)
        if Description == "" then
            XGUIEng.ShowWidget("/LoadScreen/LoadScreen/ContainerDescription/LoadScreenReadMe", 0)
            XGUIEng.ShowWidget("/LoadScreen/LoadScreen/ContainerDescription/LoadScreenReadmeBG", 0)
        else
            XGUIEng.ShowWidget("/LoadScreen/LoadScreen/ContainerDescription/LoadScreenReadMe", 1)
            XGUIEng.ShowWidget("/LoadScreen/LoadScreen/ContainerDescription/LoadScreenReadmeBG", 1)
            XGUIEng.SetText("/LoadScreen/LoadScreen/ContainerDescription/LoadScreenReadMe", Description)
        end
        if RealMapName == "" then
            XGUIEng.ShowWidget("/LoadScreen/LoadScreen/ContainerDescription/MapName", 0)
        else
            XGUIEng.ShowWidget("/LoadScreen/LoadScreen/ContainerDescription/MapName", 1)
            XGUIEng.ShowWidget("/LoadScreen/LoadScreen/ContainerDescription/LoadScreenReadmeBG", 1)
            XGUIEng.SetText("/LoadScreen/LoadScreen/ContainerDescription/MapName", RealMapName)
        end
        return
    end
    
    if Throneroom == true then
        if Framework.GetCampaignMap() == "c00_m01_Vestholm" then
            XGUIEng.SetMaterialTexture("/LoadScreen/LoadScreen/LoadScreenBgd", 0, "loadscreens\\Throneroom.png")
            XGUIEng.ShowWidget("/LoadScreen/LoadScreen/ContainerDescription/MapName", 0)        
            Sound.PlayVoice("ImportantStuff", "voices/judgment_father/intro_speech_campaignintro.mp3")
            XGUIEng.ShowWidget("/LoadScreen/LoadScreen/ContainerDescription/LoadScreenReadMe", 1)
            XGUIEng.ShowWidget("/LoadScreen/LoadScreen/ContainerDescription/LoadScreenReadmeBG", 1)
            XGUIEng.ShowWidget("/LoadScreen/LoadScreen/ContainerDescription/MapName", 1)
            local title = XGUIEng.GetStringTableText("Map_c00_m01_Vestholm/MapName")
            local text = XGUIEng.GetStringTableText("Intro_Speech/CampaignIntro")
            XGUIEng.SetText("/LoadScreen/LoadScreen/ContainerDescription/LoadScreenReadMe", text)
            XGUIEng.SetText("/LoadScreen/LoadScreen/ContainerDescription/MapName", title)
            Framework.SetLoadScreenProps("loadscreens\\Throneroom.png", text, title)
        elseif not Mission_TellStory or not Mission_TellStory() then        
            XGUIEng.SetMaterialTexture("/LoadScreen/LoadScreen/LoadScreenBgd", 0, "loadscreens\\Throneroom.png")
            XGUIEng.ShowWidget("/LoadScreen/LoadScreen/ContainerDescription/MapName", 0)        
            XGUIEng.ShowWidget("/LoadScreen/LoadScreen/ContainerDescription/MapName", 0)
            XGUIEng.ShowWidget("/LoadScreen/LoadScreen/ContainerDescription/LoadScreenReadMe", 0)
            XGUIEng.ShowWidget("/LoadScreen/LoadScreen/ContainerDescription/LoadScreenReadmeBG", 0)
            Framework.SetLoadScreenProps("loadscreens\\Throneroom.png", "", "")
        end
        return
    else
        XGUIEng.ShowWidget("/LoadScreen/LoadScreen/ContainerDescription/MapName", 1)
        XGUIEng.ShowWidget("/LoadScreen/LoadScreen/ContainerDescription/LoadScreenReadMe", 1)
        XGUIEng.ShowWidget("/LoadScreen/LoadScreen/ContainerDescription/LoadScreenReadmeBG", 1)
    end
    
    local ClimateZoneName = Framework.GetMapClimateZone(MapName, MapType, Campaign)

    if KnightID == nil then
        KnightID = 0
    end
    
    local Tex = "me"
    if ClimateZoneName == "Generic" or ClimateZoneName == "MiddleEurope" then
        Tex = "me"
    elseif ClimateZoneName == "NorthEurope" then
        Tex = "ne"
    elseif ClimateZoneName == "SouthEurope" then
        Tex = "se"
    elseif ClimateZoneName == "NorthAfrica" then
        Tex = "na"
    elseif ClimateZoneName == "Asia" then
        Tex = "as"        
    end

    local filename
    local remappedKnightId = RemapKnightID(KnightID)

    if remappedKnightId == 0 then
        filename = "loadscreens\\" .. Tex .. ".png"
    else
        filename = "loadscreens\\" .. Tex .. RemapKnightID(KnightID) .. ".png"
    end

    XGUIEng.SetMaterialTexture("/LoadScreen/LoadScreen/LoadScreenBgd", 0, filename)
    
    -- get map name
    local RealMapName = XGUIEng.GetStringTableText("Map_" .. MapName .. "/MapName")
	if RealMapName == "" then
	
	    local CustomMapName = Framework.GetMapNameAndDescription(MapName, MapType, Campaign)    	    
	    if (MapName ~= "") then
            RealMapName = CustomMapName
        else            
            RealMapName = MapName
        end
        
    end
    
    -- get map description
    XGUIEng.SetText("/LoadScreen/LoadScreen/ContainerDescription/MapName", RealMapName)

	local Description = XGUIEng.GetStringTableText("Map_" .. MapName .. "/MapDescription")
	if Description == "" then
        
	    local CustomMapName, CustomDescription = Framework.GetMapNameAndDescription(MapName, MapType, Campaign)    	    
	    if (MapName ~= "") then
            Description = CustomDescription
        else            
            Description = "Description for map " .. MapName .. " missing (" .. "Map_" .. MapName .. "/MapDescription )"
        end
        
    end
    
    XGUIEng.SetText("/LoadScreen/LoadScreen/ContainerDescription/LoadScreenReadMe", Description)

    Framework.SetLoadScreenProps(filename, Description, RealMapName)
    
end

function UpdateProgressBar(_SlotID)
    local Name = ""
    local CurrentWidgetID = XGUIEng.GetCurrentWidgetID()
    XGUIEng.ShowWidget(CurrentWidgetID, 1)
    local Progress = 0
    if Framework ~= nil then
        if Framework.IsNetworkGame() then
            if Network.IsNetworkSlotIDUsedByHumanPlayer(_SlotID) then
                Progress = Network.GetLoadProgressForNetworkSlot(_SlotID)
                Name = Network.GetNameForNetworkSlotID(_SlotID)

                if _SlotID == Network.GetLocalPlayerNetworkSlotID() then
                    _SlotID = 1
                elseif _SlotID == 1 then
                    _SlotID = Network.GetLocalPlayerNetworkSlotID()
                end

            else
                XGUIEng.ShowWidget(CurrentWidgetID, 0)
            end
        elseif _SlotID == 1 then
            Progress = Framework.GetLocalLoadingProgress()
        else
            XGUIEng.ShowWidget(CurrentWidgetID, 0)
        end
    elseif _SlotID == 1 then
        Progress = Framework.GetLocalLoadingProgress()
    else
        XGUIEng.ShowWidget(CurrentWidgetID, 0)
    end

    local widget = "/LoadScreen/LoadScreen/LoadBar" .. _SlotID .. "/ProgressBarWidget"
    XGUIEng.SetProgressBarValues(widget, Progress, 1)
    
    widget = "/LoadScreen/LoadScreen/LoadBar" .. _SlotID .. "/Name"
    if Name == "" then
        XGUIEng.ShowWidget(widget, 0)
    else
        XGUIEng.ShowWidget(widget, 1)
        XGUIEng.SetText(widget, "{center}" .. Name)
    end
end
