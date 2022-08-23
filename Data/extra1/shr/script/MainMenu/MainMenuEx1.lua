---------------------------------------------------------------------------------------------------
-- Globals
---------------------------------------------------------------------------------------------------
Script.Load("Script\\MainMenu\\MainMenu.lua" )


----------------------------------------------------------------------------------------------------
-- Overrides
----------------------------------------------------------------------------------------------------

CustomGame.KnightTypes = {
    "U_KnightSaraya",
    "U_KnightTrading",
    "U_KnightChivalry",
    "U_KnightWisdom",
    "U_KnightHealing",
    "U_KnightPlunder",
    "U_KnightSong",
    "U_KnightSabatta",
    "U_KnightRedPrince",
    "U_KnightPraphat",
    "U_KnightKhana"
    }
    
g_MapAndHeroPreview.KnightTypes = CustomGame.KnightTypes


MPDefaultKnightNames = CustomGame.KnightTypes

function RemapKnightID( _ID )
    local Mapping = { [0] = 0, [1] = 7, [2] = 1, [3] = 3, [4] = 4, [5] = 2, [6] = 5, [7] = 6, [8] = 8, [9] = 9, [10] = 10, [11] = 11, [12] = 0, [13] = 0 , [14] = 0 , [15] = 0 , [16] = 0  }
    return Mapping[_ID]
end

function GetLoadScreen(_remappedKnightId, _tex)
    local filename
    if _remappedKnightId == 0 then
        filename = "loadscreens\\" .. _tex .. "_old.png"
    else
        if _remappedKnightId >= 8 then
            if _remappedKnightId == 11 then  --Khana
                filename = "loadscreens\\chapter3.png"
            elseif _tex == "as" then
                filename = "loadscreens\\Endscreen.png"
            else
                filename = "loadscreens\\" .. _tex .. "_old.png"
            end
        else
            filename = "loadscreens\\" .. _tex .. _remappedKnightId .. ".png"
        end
    end
    return filename
end

function g_MainMenu.ShowIntroVideos()

	if not Framework.IsDevM() then
	    Mouse.CursorHide()
		Sound.MusicPause()
		Sound.MusicTrigger()
		Framework.PlayVideo("videos\\Start01", -1, false, true)
	    Mouse.CursorHide()
		Framework.PlayVideo("videos\\ubisoft", -1, false, true)
		Sound.MusicResume()
	    Mouse.CursorShow()
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

function g_MainMenu.Init()

    Mouse.CursorSet(15) -- 15 is default cursor
    Mouse.CursorShow()
    
    VideoOptionsSetDefaultsIfNecessary()
    
	g_MainMenu.UpdateBackground()
    g_MainMenu.InitShared()

	MainMenuDev_Init()
    
	Sound.SetPause(false)

end

do
    g_VideoOptions.Old_OnShow = g_VideoOptions.OnShow
    function g_VideoOptions:OnShow()
        XGUIEng.ShowWidget("/InGame/VideoOptionsMain/OptionFrame/NVLogo", 0)
        g_VideoOptions:Old_OnShow()
    end
end

function Mission_TellStory()

    local StoryMaps = {
        ["c01_m01_basrima"] = { ["MapKey"] = "Map_c01_m01_Basrima", ["SpeechKey"] = "c01m01_Chapter1LoadScreen", ["LoadScreen"] = "chapter1" },
        ["c01_m04_almerabad"] = { ["MapKey"] = "Map_c01_m04_Almerabad", ["SpeechKey"] = "c01m04_Chapter2LoadScreen", ["LoadScreen"] = "chapter2" },
        ["c01_m06_praphatstan"] = { ["MapKey"] = "Map_c01_m06_Praphatstan", ["SpeechKey"] = "c01m06_Chapter3LoadScreen", ["LoadScreen"] = "chapter3" }
    }
    
    local MapName = string.lower(Framework.GetCampaignMap())    
    
    local StoryMapTable = StoryMaps[MapName]

    if StoryMapTable then
        XGUIEng.SetMaterialTexture("/LoadScreen/LoadScreen/LoadScreenBgd", 0, "loadscreens\\" .. StoryMapTable["LoadScreen"] .. ".png")
        Sound.PlayVoice("ImportantStuff", "Voices/H_NPC_Narrator/" .. StoryMapTable["MapKey"] ..  "_speech_" .. StoryMapTable["SpeechKey"] .. ".mp3")
        XGUIEng.ShowWidget("/LoadScreen/LoadScreen/ContainerDescription/LoadScreenReadMe", 1)
        XGUIEng.ShowWidget("/LoadScreen/LoadScreen/ContainerDescription/LoadScreenReadmeBG", 1)
        XGUIEng.ShowWidget("/LoadScreen/LoadScreen/ContainerDescription/MapName", 1)
        local title = XGUIEng.GetStringTableText(StoryMapTable["MapKey"] .. "/MapName")
        local text = XGUIEng.GetStringTableText(StoryMapTable["MapKey"] .. "_speech/" .. StoryMapTable["SpeechKey"] )
        XGUIEng.SetText("/LoadScreen/LoadScreen/ContainerDescription/LoadScreenReadMe", text)
        XGUIEng.SetText("/LoadScreen/LoadScreen/ContainerDescription/MapName", title)
        Framework.SetLoadScreenProps("loadscreens\\" .. StoryMapTable["LoadScreen"] .. ".png", text, title)
        
        return true
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