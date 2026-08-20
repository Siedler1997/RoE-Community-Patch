
g_CPVersion = "CP 0.1";

--Script.Load("Script\\MainMenu\\CampaignEx2.lua" )
Script.Load("Script\\MainMenu\\CampaignMapEx2.lua" )
Script.Load("Script\\MainMenu\\CampaignMenuEx2.lua" )
Script.Load("Script\\MainMenu\\CoatOfArmEx2.lua" )
Script.Load("Script\\MainMenu\\CustomGameEx2.lua" )
Script.Load("Script\\MainMenu\\MapAndHeroPreviewEx2.lua" )
Script.Load("Script\\MainMenu\\ProfileEx2.lua" )
Script.Load("Script\\MainMenu\\SingleplayerMenuEx2.lua" )
Script.Load("Script\\MainMenu\\Multiplayer\\AspectGameConfigEx2.lua" )
Script.Load("Script\\MainMenu\\Multiplayer\\CreateGamePageEx2.lua" )
Script.Load("Script\\Shared\\OverwriteSharedEx2.lua" )
Script.Load("Script\\Shared\\ScriptSystems\\SharedMultiplayerEx2.lua" )

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
 		g_MainMenu.BackgroundImage = "MainMenu/masterBG_old.png"
    else
 		g_MainMenu.BackgroundImage = "MainMenu/limitedBG.png"
    end

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

function g_MainMenu.UpdateBackground()
 
    XGUIEng.ShowWidget("/InGame/Background/Bars/Demo", 0)
	XGUIEng.SetMaterialTexture( "/InGame/Background/BG",0,g_MainMenu.BackgroundImage)
    XGUIEng.ShowWidget("/InGame/Background/Bars/Limited", 0)
    XGUIEng.ShowWidget("/InGame/Background/Bars/BottomBarLimited", 0)
    XGUIEng.ShowWidget("/InGame/Background/Bars/BottomBar", 1)
 			   
    local W,H = XGUIEng.GetWidgetScreenSize("/InGame/Background/WholeScreen")--whole screen size
    

    local sizeX = H * 16/9
    local sizeY = H --the image is at 16/9 format
    
    
    --can only set size in local coordinates 1600*1200
    sizeX = sizeX * 1600 / W
    sizeY = sizeY * 1200 / H
    
    XGUIEng.SetWidgetSize("/InGame/Background/BG",sizeX, sizeY)
    XGUIEng.SetWidgetScreenPosition("/InGame/Background/BG", 0, 0)    

end