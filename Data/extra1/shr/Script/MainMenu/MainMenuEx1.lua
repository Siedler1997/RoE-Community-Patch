---------------------------------------------------------------------------------------------------
-- Globals
---------------------------------------------------------------------------------------------------
Script.Load("Script\\MainMenu\\MainMenu.lua" )

-- CP
Script.Load("Script\\MainMenu\\MainMenuEx2.lua" )

----------------------------------------------------------------------------------------------------
-- Overrides
----------------------------------------------------------------------------------------------------

MPDefaultKnightNames = CustomGame.KnightTypes

function RemapKnightID( _ID )
    local Mapping = { [0] = 0, [1] = 7, [2] = 1, [3] = 3, [4] = 4, [5] = 2, [6] = 5, [7] = 6, [8] = 8, [9] = 9, [10] = 10, [11] = 11, [12] = 0, [13] = 0 , [14] = 0 , [15] = 0 , [16] = 0  }
    return Mapping[_ID]
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

function Mission_TellStory(_mapName)

    local StoryMaps = {
        ["c01_m01_basrima"] = { ["MapKey"] = "Map_c01_m01_Basrima", ["SpeechKey"] = "c01m01_Chapter1LoadScreen", ["LoadScreen"] = "chapter1" },
        ["c01_m04_almerabad"] = { ["MapKey"] = "Map_c01_m04_Almerabad", ["SpeechKey"] = "c01m04_Chapter2LoadScreen", ["LoadScreen"] = "chapter2" },
        ["c01_m06_praphatstan"] = { ["MapKey"] = "Map_c01_m06_Praphatstan", ["SpeechKey"] = "c01m06_Chapter3LoadScreen", ["LoadScreen"] = "chapter3" }
    }
    
    local MapName = string.lower(_mapName)    
    
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

function GetLoadScreen(_remappedKnightId, _tex)
    local filename
    if _remappedKnightId == 0 then
        filename = "loadscreens\\" .. _tex .. "_old.png"
    else
        filename = "loadscreens\\" .. _tex .. _remappedKnightId .. ".png"
    end
    return filename
end