---------------------------------------------------------------------------------------------------
-- Globals
---------------------------------------------------------------------------------------------------
Script.Load("Script\\Shared\\SaveGameUtils.lua")

Script.Load("Script\\Local\\Interface\\LoadScreen.lua")

Script.Load("Script\\MainMenu\\MenuPage.lua" )
Script.Load("Script\\MainMenu\\SingleplayerMenu.lua" )
Script.Load("Script\\MainMenu\\OptionsMenu.lua" )

Script.Load("Script\\MainMenu\\VideoOptions.lua" )

Script.Load("Script\\MainMenu\\MapAndHeroPreview.lua" )

Script.Load("Script\\MainMenu\\Multiplayer.lua" )
Script.Load("Script\\MainMenu\\CoatOfArm.lua" )
Script.Load("Script\\MainMenu\\Profile.lua" )

Script.Load("Script\\MainMenu\\Fader.lua" )
Script.Load("Script\\MainMenu\\Campaign.lua" )

Script.Load("Script\\MainMenu\\LoadGame.lua" )
Script.Load("Script\\MainMenu\\Requester.lua" )
Script.Load("Script\\MainMenu\\CampaignMap.lua" )
Script.Load("Script\\MainMenu\\CampaignMenu.lua" )
Script.Load("Script\\MainMenu\\CustomGame.lua" )
Script.Load("Script\\MainMenu\\CreditsDialog.lua" )

--for different versions
Script.Load("Script\\MainMenu\\MainMenuDev.lua" )
Script.Load("Script\\MainMenu\\FingerPrint.lua" )

if Framework.CheckIDV() then
    Script.Load("Script\\MainMenu\\EndScreen.lua" )    
end


----------------------------------------------------------------------------------------------------
-- Main menu stuff
----------------------------------------------------------------------------------------------------

-- Table

g_MainMenu = {}

	g_MainMenu.CampaignStateSequence = 0
	g_MainMenu.VideoTimer = 0
	g_MainMenu.BackgroundImage = "MainMenu/masterBG.png"

----------------------------------------------------------------------------------------------------
-- Init functions
----------------------------------------------------------------------------------------------------

-- Called at program start

function g_MainMenu.ShowIntroVideos()

	if not Framework.IsDevM() then
	    Mouse.CursorHide()
		Sound.MusicPause()
		Sound.MusicTrigger()
		Framework.PlayVideo("videos\\Start01", -1, false, true)
	    Mouse.CursorHide()
		Framework.PlayVideo("videos\\ubisoft", -1, false, true)
	    Mouse.CursorHide()
		Framework.PlayVideo("videos\\bluebyte", -1, true, true)
	    Mouse.CursorHide()
		Framework.PlayVideo("videos\\ubipresents", -1, false, false)
	    Mouse.CursorHide()
		Framework.PlayVideo("videos\\c00_intro", -1, true, false)
		Sound.MusicResume()
	    Mouse.CursorShow()
	end

end

--------------------------------------------------------------------------------------------------
function g_MainMenu.OpenExitRequester()
    Input.KeyBindDown(Keys.ModifierAlt + Keys.F4, "", 30)
    OpenRequesterDialog(XGUIEng.GetStringTableText("UI_Texts/ConfirmQuitCurrentGame"), XGUIEng.GetStringTableText("UI_Texts/MainMenuExitGame_center"), "Framework.ExitGame()")
end

--------------------------------------------------------------------------------------------------
function g_MainMenu.InitShared()

    Input.GameMode()
    if Framework.CheckIDV() then
        Input.KeyBindDown(Keys.ModifierAlt + Keys.F4, "EndScreen_Show()", 30)
    else
        Input.KeyBindDown(Keys.ModifierAlt + Keys.F4, "g_MainMenu.OpenExitRequester()", 30)
    end

--	XGUIEng.ShowWidget("/InGame/Singleplayer/Campaign",0)

	XGUIEng.ShowWidget("/InGame/Singleplayer/Video", 0)

	if Framework.IsDevM() then

        --XGUIEng.SetTextFromFile("/InGame/Root/Screens/StartMenu/StartMenuReadMe", "00DevNews.txt", false)

		XGUIEng.ShowWidget("/InGame/Main/Debug",1)
		XGUIEng.ShowAllSubWidgets("/InGame/Main/Debug",1)

		XGUIEng.ShowWidget("/InGame/Main/TEMP_FastLaunch",1)


    else

		XGUIEng.ShowAllSubWidgets("/InGame/Main/Debug",0)
		XGUIEng.ShowWidget("/InGame/Main/TEMP_FastLaunch",0)

	end

	--for special versions
	MainMenu_SetFingerprintText()

	g_MainMenu.InitMainMenuKeyBindings()


    XGUIEng.ShowAllSubWidgets("/InGame/Background", 1)
    
    local curTime = tonumber(string.sub(Framework.GetSystemTimeDateString(),15,16))
    if curTime > 8 and curTime < 20 then
 		g_MainMenu.BackgroundImage = "MainMenu/masterBG.png"
    else
 		g_MainMenu.BackgroundImage = "MainMenu/limitedBG.png"
    end

 	--g_MainMenu.BackgroundImage = "Loadscreens/endscreen.png"
     --[[
    local randomBackground = XGUIEng.GetRandom(2)
    if randomBackground == 0 then
 		g_MainMenu.BackgroundImage = "MainMenu/masterBG.png"
    elseif randomBackground == 1 then
 		g_MainMenu.BackgroundImage = "Loadscreens/Throneroom.png"
    elseif randomBackground == 2 then
 		g_MainMenu.BackgroundImage = "Loadscreens/endscreen.png"
    else
 		g_MainMenu.BackgroundImage = "MainMenu/masterBG.png"
    end
    --]]

    XGUIEng.ShowWidget("/InGame/Background/TitleSmall", 0)

	XGUIEng.PopAllPages(false)

	XGUIEng.PushPage( "/InGame/Background", true )
	XGUIEng.PushPage( "/InGame/Main", false )

    if not Profile.IsKeyValid("Profile", "Name") then
        g_MainMenuProfile:Show(false, true)
        g_MainMenuProfile:FirstLaunch()
    end

	g_MainMenu.CampaignStateSequence = 0
	g_MainMenu.VideoTimer = 0

    -- show campaign map
	if Framework.GetCampaignMode() == 1 then
        g_MainMenuSingleplayer:Show(false, true)
        OpenCampaignMap()
        Framework.SetCampaignMode(0)
	end

	-- show credits if game is finished
	if Framework.GetCampaignMode() == 2 then
        OpenCreditsDialog()
        Framework.SetCampaignMode(0)
	end

    if Network ~= nil and Network.AccountServiceIsLoggedIn() then
        g_MainMenuMultiplayer:Show(false,true)
        g_OnlinePage.Show()
	end

end

function g_MainMenu.Init()

    Mouse.CursorSet(15) -- 15 is default cursor
    Mouse.CursorShow()
    
    VideoOptionsSetDefaultsIfNecessary()
    
	g_MainMenu.UpdateBackground()
    g_MainMenu.InitShared()

	MainMenuDev_Init()
    
	Sound.SetPause(false)

end

function g_MainMenu.HandleInvites()
    if Network.HasPendingInvites() == true then
		XGUIEng.SetAllButtonsDisabled()
        Framework.StartMultiplayer(false)
		g_MainMenuMultiplayer:Show(false, true)
	end
end

--------------------------------------------------------------------------------------------------
function g_MainMenu.Reinit()

    Mouse.CursorSet(15) -- 15 is default cursor
    Mouse.CursorShow()
    
    g_MainMenu.UpdateBackground()
	g_MainMenu.InitShared()
	
	MainMenuDev_Reinit()

    local NetworkError = Network.FetchQueuedMPError()

    if NetworkError:len() > 0 then
        MessageText = XGUIEng.GetStringTableText("UI_Texts/" .. "MultiplayerError_" .. NetworkError)
        g_ErrorPage.CreateError(MessageText)
    end

end
----------------------------------------------------------------------------------------------------
function g_MainMenu.ExitGame()

    if Framework.CheckIDV() then
        EndScreen_Show()
    else
        Framework.ExitGame()
    end
        
end
----------------------------------------------------------------------------------------------------
function g_MainMenu.InitMainMenuKeyBindings()
	if Framework.IsDevM() then
        Input.KeyBindDown(Keys.ModifierControl + Keys.ModifierShift + Keys.D, "LuaDebugger.Break()", 15)
        Input.KeyBindDown(Keys.ModifierControl + Keys.ModifierShift + Keys.C, "Framework.ResetCampaignProgress()", 15)
    end

    --Input.KeyBindDown(Keys.Enter, "g_MainMenuChat.ConfirmMessage()", 15)
end
----------------------------------------------------------------------------------------------------
function g_MainMenu.LoadMap(_MapName, _Type,_CampaignFlag)

    XGUIEng.PopAllPages()

    XGUIEng.ShowAllSubWidgets("/InGame/Background", 0)

    Framework.ResetProgressBar()
    InitLoadScreen(false, _Type, _MapName, _CampaignFlag, 0)

	--Hack so we can start the example campaign map via a button:
	if _CampaignFlag == nil then

        Framework.StartMap( _MapName, _Type, -1 )

    else

        Framework.StartMap( _MapName, -1, "c00" )

    end

end
----------------------------------------------------------------------------------------------------
function StopIntroVideo()

	g_MainMenu.CampaignStateSequence = 1

	g_MainMenu.VideoTimer = 0

end
----------------------------------------------------------------------------------------------------
function UpdateMainMenu()
	
end
----------------------------------------------------------------------------------------------------
function g_MainMenu.CancelLoad()

	CloseLoadDialog()

    XGUIEng.ShowAllSubWidgets("/InGame/Singleplayer",0)
    XGUIEng.ShowWidget("/InGame/Singleplayer/ContainerBottom",1)
    XGUIEng.ShowWidget("/InGame/Singleplayer/RightMenu",1)

    DisplayLoadBottomButtons("/InGame/Singleplayer/ContainerBottom/BackMenu")
end
----------------------------------------------------------------------------------------------------
function g_MainMenu.DbgPlaySkirmish()

    local MapName = "ME_ThreeWaterfalls"
    local SlotsAvail = Framework.GetMapMaxPlayers(MapName, 2, -1)
	Framework.OpenSkirmishMode(SlotsAvail)

    -- Framework.Skirmish* Function can be used here

    XGUIEng.PopAllPages()

    XGUIEng.ShowAllSubWidgets("/InGame/Background", 0)
    XGUIEng.ShowWidget("/InGame/Background/BG", 1)

    --XGUIEng.SetMaterialTexture("/InGame/Background/BG", 0, "graphics\\Textures\\gui\\bg_loadscreen01.dds")

    Framework.StartMap(MapName, 2, -1)
end

----------------------------------------------------------------------------------------------------
function RemoveInvalidChars(text) --use by many menus

	local result = ""

	local exclude = '|[]*?:\\/"<>'

	local n = string.len(text)

	for i=1,n do

		local char = string.sub(text,i,i)

		for j=1,string.len(exclude) do

			if char == string.sub(exclude,j,j) then

				char = ''

			end

		end

		result = result..char

	end

	return result

end
----------------------------------------------------------------------------------------------------

function g_MainMenu.UpdateBackground()
 
    if Framework.CheckIDV() == true then
 		XGUIEng.SetMaterialTexture( "/InGame/Background/BG",0,"graphics\\Textures\\GUI\\MainMenu\\demoBG.dds")
    	XGUIEng.ShowWidget("/InGame/Background/Bars/Demo", 1)
    else
    	XGUIEng.ShowWidget("/InGame/Background/Bars/Demo", 0)
        --[[
		if IsSpecialEdition() then
 			XGUIEng.SetMaterialTexture( "/InGame/Background/BG",0,"MainMenu/limitedBG.png")
    	    XGUIEng.ShowWidget("/InGame/Background/Bars/Limited", 1)
    	    XGUIEng.ShowWidget("/InGame/Background/Bars/BottomBarLimited", 1)
    	    XGUIEng.ShowWidget("/InGame/Background/Bars/BottomBar", 0)
		else
 			XGUIEng.SetMaterialTexture( "/InGame/Background/BG",0,"MainMenu/masterBG.png")
    	    XGUIEng.ShowWidget("/InGame/Background/Bars/Limited", 0)
    	    XGUIEng.ShowWidget("/InGame/Background/Bars/BottomBarLimited", 0)
    	    XGUIEng.ShowWidget("/InGame/Background/Bars/BottomBar", 1)
		end
        --]]
 		XGUIEng.SetMaterialTexture( "/InGame/Background/BG",0,g_MainMenu.BackgroundImage)
    	XGUIEng.ShowWidget("/InGame/Background/Bars/Limited", 0)
    	XGUIEng.ShowWidget("/InGame/Background/Bars/BottomBarLimited", 0)
    	XGUIEng.ShowWidget("/InGame/Background/Bars/BottomBar", 1)
			
	end
 			   
    local W,H = XGUIEng.GetWidgetScreenSize("/InGame/Background/WholeScreen")--whole screen size
    

    local sizeX = H * 16/9
    local sizeY = H --the image is at 16/9 format
    
    
    --can only set size in local coordinates 1600*1200
    sizeX = sizeX * 1600 / W
    sizeY = sizeY * 1200 / H
    
    XGUIEng.SetWidgetSize("/InGame/Background/BG",sizeX, sizeY)
    XGUIEng.SetWidgetScreenPosition("/InGame/Background/BG", 0, 0)    

end

function g_MainMenu.LoadTestmap()
    
    if Framework.GetGameExtraNo() == 1 then
        g_MainMenu.LoadMap("Z_ASTestMap",1)
    else
        g_MainMenu.LoadMap("Z_TestMap",1)
    end
    
    
    Sound.FXPlay2DSound( "ui\\menu_click")
    
    
end

function g_MainMenu.LoadAllbuildings()

    if Framework.GetGameExtraNo() == 1 then
        g_MainMenu.LoadMap("Z_AS_AllBuildings",1)
    else
        g_MainMenu.LoadMap("Z_AllBuildings",1)
    end
    
    
    Sound.FXPlay2DSound( "ui\\menu_click")
    
end
