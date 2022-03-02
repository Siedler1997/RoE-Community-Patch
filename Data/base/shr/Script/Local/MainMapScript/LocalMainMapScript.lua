Script.Load("Script\\Shared\\ScriptTools\\SharedPresentationTools.lua" )

g_FrameCounter = 0

function ShowUiUpate()

	g_FrameCounter = g_FrameCounter +1

	if g_FrameCounter > 5 and not g_IsInSpectatorMode and not CameraAnimation.IsRunning() then

		ShowInGameUi(1)

    else

 		ShowInGameUi(0)       

	end

end

function ShowInGameUi(flag)

	XGUIEng.ShowWidget("/InGame/Root/Normal/AlignTopLeft",flag)

end


function GameCallback_LocalOnMPGameStart()

	g_FrameCounter = 0

 	ShowInGameUi(0)

    -- Init the multiplayer victory table
    InitLocalVictoryConditionMP()

    GUI_Goods.MenusUpdate()

end

function GameCallback_LocalOnGameStart()


    g_FrameCounter = 0

 	ShowInGameUi(0)

    Display.StopUsingExplicitEnvironmentSettings()

   -- INIT CoA
   DisplayCoA()


    -- INIT MUSIC
	do

	    -- init tables
	    InitMusicSystem()

    end


    -- INIT GUI AND SYSTEM RELEVANT TABLES
    do
         -- for local Taxation. Knight Titles, City Development, etc
        InitLocalTables() -- before, because needed by InitTexturePosition for KnightTitles

        -- Init Texture Positions
        InitTexturePositions()

        -- Init Tooltips Icons
        InitTooltips()

        -- Init Multiselection
    	InitMultiselection()

        -- Init Feedback Speech
        InitFeedbackSpeech()

        -- Init Feedback Gold
        InitFeedbackWidgets()

        -- Init Minimap
        InitMinimap()

        -- Init Buff positions
        InitBuffs()

        -- Init shared constants
        InitSharedConstants()

        -- Init interaction GUI
    	InitInteraction()

    	-- Load trade table
        InitPlayersTrade()

        -- Init SP quest system
        InitLocalVictoryCondition()

        -- Enable rights by default
        EnableRights = true

        -- Init camera settings for all FaceFX Heads
        FaceFXCameraSettings()

        -- Set some player heads (has to be overwriten in map)
        InitPlayerHeads()

        if Mission_LocalOnMapStart ~= nil then
           Mission_LocalOnMapStart()
        end

        -- Set the knight picture
        LocalSetKnightPicture()

        local PlayerName = Profile.GetString("Profile", "Name")
        local PlayerID = GUI.GetPlayerID()

        if PlayerName == "" then
            PlayerName = "Player" .. PlayerID
        end

        if Game.IsPlayingReplay() == false then
            GUI.SetPlayerName(PlayerID, PlayerName)
        end
    end

    if g_OnGameStartPresentationMode == true then
        ActivatePresentationMode()
    end

	InitMinimapColors()

	GUI.RebuildMinimapTerrain()	

    GUI_Goods.MenusUpdate()

    -- only call if not in throneroom
    if g_Throneroom == nil then
        GUI_Construction.Init()
        GUI_MissionStatistic.Init()
    end
end


function InitMinimapColors()

	-- 	minimap colors

	-- 	water
		GUI.SetMiniMapPixelColor(1,0,0,100,255,128)
		GUI.SetMiniMapPixelColor(2,0,0,100,255,128)

	-- 	landscape
		GUI.SetMiniMapPixelColor(1,1,0,255,0,0)
		GUI.SetMiniMapPixelColor(2,1,0,255,0,0)

	-- 	blocking
		GUI.SetMiniMapPixelColor(1,2,0,0,0,170)
		GUI.SetMiniMapPixelColor(2,2,64,69,48,0)

	-- 	shore
		GUI.SetMiniMapPixelColor(1,3,200,240,255,200)
		GUI.SetMiniMapPixelColor(2,3,44,110,161,128)    -- currently unused!

	-- 	fertile
		GUI.SetMiniMapPixelColor(1,4,46,84,9,120)
		GUI.SetMiniMapPixelColor(2,4,0,255,0,0)

	-- 	barren
		GUI.SetMiniMapPixelColor(1,5,204,195,102,128)
		GUI.SetMiniMapPixelColor(2,5,110,110,110,0)     -- currently unused!

	-- 	wood
		GUI.SetMiniMapPixelColor(1,6,46,84,9,255)
		GUI.SetMiniMapPixelColor(2,6,0,110,0,0)

end


function FaceFXCameraSettings()
    g_FaceFXCamera = {}

    g_FaceFXCamera.H_Knight_Chivalry = {}
    g_FaceFXCamera.H_Knight_Chivalry.FOV = 12.8
    g_FaceFXCamera.H_Knight_Chivalry.PosX = -150
    g_FaceFXCamera.H_Knight_Chivalry.PosY = -220
    g_FaceFXCamera.H_Knight_Chivalry.PosZ = -10
    g_FaceFXCamera.H_Knight_Chivalry.LookAtX = -53
    g_FaceFXCamera.H_Knight_Chivalry.LookAtY = -80
    g_FaceFXCamera.H_Knight_Chivalry.LookAtZ = -18

    g_FaceFXCamera.H_Knight_Healing = {}
    g_FaceFXCamera.H_Knight_Healing.FOV = 14.5
    g_FaceFXCamera.H_Knight_Healing.PosX = -155
    g_FaceFXCamera.H_Knight_Healing.PosY = -190
    g_FaceFXCamera.H_Knight_Healing.PosZ = 0
    g_FaceFXCamera.H_Knight_Healing.LookAtX = -68
    g_FaceFXCamera.H_Knight_Healing.LookAtY = -90
    g_FaceFXCamera.H_Knight_Healing.LookAtZ = -10

    g_FaceFXCamera.H_Knight_Trading = {}
    g_FaceFXCamera.H_Knight_Trading.FOV = 12
    g_FaceFXCamera.H_Knight_Trading.PosX = -130
    g_FaceFXCamera.H_Knight_Trading.PosY = -250
    g_FaceFXCamera.H_Knight_Trading.PosZ = 20
    g_FaceFXCamera.H_Knight_Trading.LookAtX = -40
    g_FaceFXCamera.H_Knight_Trading.LookAtY = -80
    g_FaceFXCamera.H_Knight_Trading.LookAtZ = 0

    g_FaceFXCamera.H_Knight_Wisdom = {}
    g_FaceFXCamera.H_Knight_Wisdom.FOV = 12
    g_FaceFXCamera.H_Knight_Wisdom.PosX = -195
    g_FaceFXCamera.H_Knight_Wisdom.PosY = -230
    g_FaceFXCamera.H_Knight_Wisdom.PosZ = 55
    g_FaceFXCamera.H_Knight_Wisdom.LookAtX = -67
    g_FaceFXCamera.H_Knight_Wisdom.LookAtY = -80
    g_FaceFXCamera.H_Knight_Wisdom.LookAtZ = 0

    g_FaceFXCamera.H_Knight_Plunder = {}
    g_FaceFXCamera.H_Knight_Plunder.FOV = 13.5
    g_FaceFXCamera.H_Knight_Plunder.PosX = -145
    g_FaceFXCamera.H_Knight_Plunder.PosY = -190
    g_FaceFXCamera.H_Knight_Plunder.PosZ = 40
    g_FaceFXCamera.H_Knight_Plunder.LookAtX = -58
    g_FaceFXCamera.H_Knight_Plunder.LookAtY = -80
    g_FaceFXCamera.H_Knight_Plunder.LookAtZ = 5

    g_FaceFXCamera.H_Knight_Song = {}
    g_FaceFXCamera.H_Knight_Song.FOV = 17
    g_FaceFXCamera.H_Knight_Song.PosX = -130
    g_FaceFXCamera.H_Knight_Song.PosY = -250
    g_FaceFXCamera.H_Knight_Song.PosZ = 40
    g_FaceFXCamera.H_Knight_Song.LookAtX = -62
    g_FaceFXCamera.H_Knight_Song.LookAtY = -125
    g_FaceFXCamera.H_Knight_Song.LookAtZ = -6

    g_FaceFXCamera.H_Knight_RedPrince = {}
    g_FaceFXCamera.H_Knight_RedPrince.FOV = 13
    g_FaceFXCamera.H_Knight_RedPrince.PosX = -120
    g_FaceFXCamera.H_Knight_RedPrince.PosY = -190
    g_FaceFXCamera.H_Knight_RedPrince.PosZ = 40
    g_FaceFXCamera.H_Knight_RedPrince.LookAtX = -47
    g_FaceFXCamera.H_Knight_RedPrince.LookAtY = -80
    g_FaceFXCamera.H_Knight_RedPrince.LookAtZ = 0

    g_FaceFXCamera.H_Knight_Sabatt = {}
    g_FaceFXCamera.H_Knight_Sabatt.FOV = 12.5
    g_FaceFXCamera.H_Knight_Sabatt.PosX = -145
    g_FaceFXCamera.H_Knight_Sabatt.PosY = -190
    g_FaceFXCamera.H_Knight_Sabatt.PosZ = 20
    g_FaceFXCamera.H_Knight_Sabatt.LookAtX = -58
    g_FaceFXCamera.H_Knight_Sabatt.LookAtY = -80
    g_FaceFXCamera.H_Knight_Sabatt.LookAtZ = -17

    g_FaceFXCamera.H_NPC_Mercenary_NA = {}
    g_FaceFXCamera.H_NPC_Mercenary_NA.FOV = 17.5
    g_FaceFXCamera.H_NPC_Mercenary_NA.PosX = -138
    g_FaceFXCamera.H_NPC_Mercenary_NA.PosY = -190
    g_FaceFXCamera.H_NPC_Mercenary_NA.PosZ = 25
    g_FaceFXCamera.H_NPC_Mercenary_NA.LookAtX = -58
    g_FaceFXCamera.H_NPC_Mercenary_NA.LookAtY = -80
    g_FaceFXCamera.H_NPC_Mercenary_NA.LookAtZ = -15

    g_FaceFXCamera.H_NPC_Mercenary_SE = {}
    g_FaceFXCamera.H_NPC_Mercenary_SE.FOV = 14.5
    g_FaceFXCamera.H_NPC_Mercenary_SE.PosX = -148
    g_FaceFXCamera.H_NPC_Mercenary_SE.PosY = -190
    g_FaceFXCamera.H_NPC_Mercenary_SE.PosZ = 83
    g_FaceFXCamera.H_NPC_Mercenary_SE.LookAtX = -58
    g_FaceFXCamera.H_NPC_Mercenary_SE.LookAtY = -80
    g_FaceFXCamera.H_NPC_Mercenary_SE.LookAtZ = 30

    g_FaceFXCamera.H_NPC_Mercenary_NE = {}
    g_FaceFXCamera.H_NPC_Mercenary_NE.FOV = 15.9
    g_FaceFXCamera.H_NPC_Mercenary_NE.PosX = -155
    g_FaceFXCamera.H_NPC_Mercenary_NE.PosY = -196
    g_FaceFXCamera.H_NPC_Mercenary_NE.PosZ = 77
    g_FaceFXCamera.H_NPC_Mercenary_NE.LookAtX = -58
    g_FaceFXCamera.H_NPC_Mercenary_NE.LookAtY = -80
    g_FaceFXCamera.H_NPC_Mercenary_NE.LookAtZ = 30

    g_FaceFXCamera.H_NPC_Mercenary_ME = {}
    g_FaceFXCamera.H_NPC_Mercenary_ME.FOV = 14
    g_FaceFXCamera.H_NPC_Mercenary_ME.PosX = -148
    g_FaceFXCamera.H_NPC_Mercenary_ME.PosY = -190
    g_FaceFXCamera.H_NPC_Mercenary_ME.PosZ = 12
    g_FaceFXCamera.H_NPC_Mercenary_ME.LookAtX = -58
    g_FaceFXCamera.H_NPC_Mercenary_ME.LookAtY = -80
    g_FaceFXCamera.H_NPC_Mercenary_ME.LookAtZ = -15

    g_FaceFXCamera.H_NPC_Generic_Trader = {}
    g_FaceFXCamera.H_NPC_Generic_Trader.FOV = 13
    g_FaceFXCamera.H_NPC_Generic_Trader.PosX = -145
    g_FaceFXCamera.H_NPC_Generic_Trader.PosY = -190
    g_FaceFXCamera.H_NPC_Generic_Trader.PosZ = 65
    g_FaceFXCamera.H_NPC_Generic_Trader.LookAtX = -58
    g_FaceFXCamera.H_NPC_Generic_Trader.LookAtY = -80
    g_FaceFXCamera.H_NPC_Generic_Trader.LookAtZ = 20

    g_FaceFXCamera.H_NPC_Castellan_SE = {}
    g_FaceFXCamera.H_NPC_Castellan_SE.FOV = 13
    g_FaceFXCamera.H_NPC_Castellan_SE.PosX = -145
    g_FaceFXCamera.H_NPC_Castellan_SE.PosY = -190
    g_FaceFXCamera.H_NPC_Castellan_SE.PosZ = 65
    g_FaceFXCamera.H_NPC_Castellan_SE.LookAtX = -58
    g_FaceFXCamera.H_NPC_Castellan_SE.LookAtY = -80
    g_FaceFXCamera.H_NPC_Castellan_SE.LookAtZ = 20

    g_FaceFXCamera.H_NPC_Castellan_ME = {}
    g_FaceFXCamera.H_NPC_Castellan_ME.FOV = 13
    g_FaceFXCamera.H_NPC_Castellan_ME.PosX = -145
    g_FaceFXCamera.H_NPC_Castellan_ME.PosY = -190
    g_FaceFXCamera.H_NPC_Castellan_ME.PosZ = 65
    g_FaceFXCamera.H_NPC_Castellan_ME.LookAtX = -58
    g_FaceFXCamera.H_NPC_Castellan_ME.LookAtY = -80
    g_FaceFXCamera.H_NPC_Castellan_ME.LookAtZ = 20

    g_FaceFXCamera.H_NPC_Castellan_NE = {}
    g_FaceFXCamera.H_NPC_Castellan_NE.FOV = 13
    g_FaceFXCamera.H_NPC_Castellan_NE.PosX = -145
    g_FaceFXCamera.H_NPC_Castellan_NE.PosY = -190
    g_FaceFXCamera.H_NPC_Castellan_NE.PosZ = 65
    g_FaceFXCamera.H_NPC_Castellan_NE.LookAtX = -58
    g_FaceFXCamera.H_NPC_Castellan_NE.LookAtY = -80
    g_FaceFXCamera.H_NPC_Castellan_NE.LookAtZ = 20

    g_FaceFXCamera.H_NPC_Castellan_NA = {}
    g_FaceFXCamera.H_NPC_Castellan_NA.FOV = 14
    g_FaceFXCamera.H_NPC_Castellan_NA.PosX = -145
    g_FaceFXCamera.H_NPC_Castellan_NA.PosY = -190
    g_FaceFXCamera.H_NPC_Castellan_NA.PosZ = 65
    g_FaceFXCamera.H_NPC_Castellan_NA.LookAtX = -58
    g_FaceFXCamera.H_NPC_Castellan_NA.LookAtY = -80
    g_FaceFXCamera.H_NPC_Castellan_NA.LookAtZ = 15

    g_FaceFXCamera.H_NPC_Amma = {}
    g_FaceFXCamera.H_NPC_Amma.FOV = 16
    g_FaceFXCamera.H_NPC_Amma.PosX = -148
    g_FaceFXCamera.H_NPC_Amma.PosY = -190
    g_FaceFXCamera.H_NPC_Amma.PosZ = 65
    g_FaceFXCamera.H_NPC_Amma.LookAtX = -58
    g_FaceFXCamera.H_NPC_Amma.LookAtY = -80
    g_FaceFXCamera.H_NPC_Amma.LookAtZ = 13

    g_FaceFXCamera.H_NPC_Monk_ME = {}
    g_FaceFXCamera.H_NPC_Monk_ME.FOV = 11.5
    g_FaceFXCamera.H_NPC_Monk_ME.PosX = -142
    g_FaceFXCamera.H_NPC_Monk_ME.PosY = -190
    g_FaceFXCamera.H_NPC_Monk_ME.PosZ = 40
    g_FaceFXCamera.H_NPC_Monk_ME.LookAtX = -58
    g_FaceFXCamera.H_NPC_Monk_ME.LookAtY = -80
    g_FaceFXCamera.H_NPC_Monk_ME.LookAtZ = 15

    g_FaceFXCamera.H_NPC_Monk_NA = {}
    g_FaceFXCamera.H_NPC_Monk_NA.FOV = 14.8
    g_FaceFXCamera.H_NPC_Monk_NA.PosX = -143
    g_FaceFXCamera.H_NPC_Monk_NA.PosY = -190
    g_FaceFXCamera.H_NPC_Monk_NA.PosZ = 50
    g_FaceFXCamera.H_NPC_Monk_NA.LookAtX = -58
    g_FaceFXCamera.H_NPC_Monk_NA.LookAtY = -80
    g_FaceFXCamera.H_NPC_Monk_NA.LookAtZ = 6

    g_FaceFXCamera.H_NPC_Monk_NE = {}
    g_FaceFXCamera.H_NPC_Monk_NE.FOV = 13
    g_FaceFXCamera.H_NPC_Monk_NE.PosX = -145
    g_FaceFXCamera.H_NPC_Monk_NE.PosY = -190
    g_FaceFXCamera.H_NPC_Monk_NE.PosZ = 50
    g_FaceFXCamera.H_NPC_Monk_NE.LookAtX = -58
    g_FaceFXCamera.H_NPC_Monk_NE.LookAtY = -80
    g_FaceFXCamera.H_NPC_Monk_NE.LookAtZ = 15

    g_FaceFXCamera.H_NPC_Monk_SE = {}
    g_FaceFXCamera.H_NPC_Monk_SE.FOV = 13.9
    g_FaceFXCamera.H_NPC_Monk_SE.PosX = -141
    g_FaceFXCamera.H_NPC_Monk_SE.PosY = -190
    g_FaceFXCamera.H_NPC_Monk_SE.PosZ = 37
    g_FaceFXCamera.H_NPC_Monk_SE.LookAtX = -58
    g_FaceFXCamera.H_NPC_Monk_SE.LookAtY = -80
    g_FaceFXCamera.H_NPC_Monk_SE.LookAtZ = 0

    g_FaceFXCamera.H_NPC_Villager01_SE = {}
    g_FaceFXCamera.H_NPC_Villager01_SE.FOV = 13
    g_FaceFXCamera.H_NPC_Villager01_SE.PosX = -145
    g_FaceFXCamera.H_NPC_Villager01_SE.PosY = -190
    g_FaceFXCamera.H_NPC_Villager01_SE.PosZ = 56
    g_FaceFXCamera.H_NPC_Villager01_SE.LookAtX = -58
    g_FaceFXCamera.H_NPC_Villager01_SE.LookAtY = -80
    g_FaceFXCamera.H_NPC_Villager01_SE.LookAtZ = 10

    g_FaceFXCamera.H_NPC_Villager01_ME = {}
    g_FaceFXCamera.H_NPC_Villager01_ME.FOV = 12
    g_FaceFXCamera.H_NPC_Villager01_ME.PosX = -142
    g_FaceFXCamera.H_NPC_Villager01_ME.PosY = -190
    g_FaceFXCamera.H_NPC_Villager01_ME.PosZ = 46
    g_FaceFXCamera.H_NPC_Villager01_ME.LookAtX = -58
    g_FaceFXCamera.H_NPC_Villager01_ME.LookAtY = -80
    g_FaceFXCamera.H_NPC_Villager01_ME.LookAtZ = 10

    g_FaceFXCamera.H_NPC_Villager01_NA = {}
    g_FaceFXCamera.H_NPC_Villager01_NA.FOV = 15
    g_FaceFXCamera.H_NPC_Villager01_NA.PosX = -148
    g_FaceFXCamera.H_NPC_Villager01_NA.PosY = -190
    g_FaceFXCamera.H_NPC_Villager01_NA.PosZ = 46
    g_FaceFXCamera.H_NPC_Villager01_NA.LookAtX = -58
    g_FaceFXCamera.H_NPC_Villager01_NA.LookAtY = -80
    g_FaceFXCamera.H_NPC_Villager01_NA.LookAtZ = 10

    g_FaceFXCamera.H_NPC_Villager01_NE = {}
    g_FaceFXCamera.H_NPC_Villager01_NE.FOV = 13
    g_FaceFXCamera.H_NPC_Villager01_NE.PosX = -145
    g_FaceFXCamera.H_NPC_Villager01_NE.PosY = -190
    g_FaceFXCamera.H_NPC_Villager01_NE.PosZ = 46
    g_FaceFXCamera.H_NPC_Villager01_NE.LookAtX = -58
    g_FaceFXCamera.H_NPC_Villager01_NE.LookAtY = -80
    g_FaceFXCamera.H_NPC_Villager01_NE.LookAtZ = 10


    -- insert camera settings for remaining heads here
end


function InitPlayerHeads()

    g_PlayerPortrait = {}
    g_PlayerPortrait[1] = "H_Knight_RedPrince"
    g_PlayerPortrait[2] = "H_Knight_Sabatt"
    g_PlayerPortrait[3] = "H_NPC_Villager01_ME"
    g_PlayerPortrait[4] = "H_NPC_Villager01_SE"
    g_PlayerPortrait[5] = "H_NPC_Villager01_NA"
    g_PlayerPortrait[6] = "H_NPC_Villager01_ME"
    g_PlayerPortrait[7] = "H_Knight_RedPrince"
    g_PlayerPortrait[8] = "H_Knight_Sabatt"

end


function StartStorm(_withoutLightnig, _useBlizzard, _duration)
    if StormHasBeenStarted == nil or Logic.GetTime() > StormHasBeenStarted + 90 then
        local MapName = Framework.GetCurrentMapName()
        local MapType, Campaign = Framework.GetCurrentMapTypeAndCampaignName()
    
        local ClimateZoneName = Framework.GetMapClimateZone(MapName, MapType, Campaign)
       
        local Setting = "ME_Storm.xml"
        local LigthningSetting = "ME_Storm_Lightning.xml"
    
        if ClimateZoneName == "NorthEurope" then
            Setting = "NE_Storm.xml"
            LigthningSetting = "NE_Storm_Lightning.xml"
        elseif ClimateZoneName == "SouthEurope" then
            Setting = "SE_Storm.xml"
            LigthningSetting = "SE_Storm_Lightning.xml"
        elseif ClimateZoneName == "NorthAfrica" then
            Setting = "NA_Storm.xml"
            LigthningSetting = "NA_Storm_Lightning.xml"
        end

        local StormSequenceID = Display.AddEnvironmentSettingsSequence(Setting)

        LightingSequenceID = Display.AddEnvironmentSettingsSequence(LigthningSetting)

        Display.PlayEnvironmentSettingsSequence(StormSequenceID ,80 )

        StartEventMusic(MusicSystem.EventStorm, GUI.GetPlayerID())
        --GUI.AddNote("A Storm is raising")
        StormHasBeenStarted = Logic.GetTime()

        if _withoutLightnig ~= true then
            StartSimpleJob("LightingNearTheCamera")
        end

    end
end


function LightingNearTheCamera()

    if Logic.GetTime() > StormHasBeenStarted + 60 then
        --GUI.AddNote("The weather is getting better now" )
        StopEventMusic(nil, GUI.GetPlayerID())
        MusicSystem.LastMusicPlayed = 0
        return true
    end

    if Logic.GetTime() > StormHasBeenStarted + 15 then

        if math.mod(Logic.GetTime(), 7 ) == 0 then

            local x,y = Camera.RTS_GetLookAtPosition()
            local z = 400

            --Sound.FXPlay3DSound("Atmo\\amb_storm", x,y,z)
            Sound.FXPlay2DSound("Atmo\\amb_storm")
        end

        if math.mod(Logic.GetTimeMs(), 10 + XGUIEng.GetRandom(70)) == 0 then

            local x,y = Camera.RTS_GetLookAtPosition()
            local z = 400
            Display.PlayEnvironmentSettingsSequence(LightingSequenceID ,1 )

            -- ToDo: Blitz Sound needed
            Sound.FXPlay3DSound("Misc\\amb_thunder", x,y,z)
            Sound.FXPlay2DSound("Misc\\amb_thunder")
            --Logic.ExecuteInLuaLocalState( [[Sound.FXPlay2DSound( "Misc\\earth_quake" )]] )
        end
    end
end


function LocalSetKnightPicture()

    local KnightID = Logic.GetKnightID(GUI.GetPlayerID())

    if KnightID == nil or KnightID == 0 then
        return
    end

    local KnightEntityType = Logic.GetEntityType(KnightID)
    local KnightButtonWidget = "/InGame/Root/Normal/AlignBottomRight/MapFrame/KnightButton"

    SetIcon(KnightButtonWidget, g_TexturePositions.Entities[KnightEntityType])
end


function SetPortraitWithCameraSettings(_PortraitWidget, _Actor)

    local Portrait = "Heads\\" .. _Actor

    GUI.PortraitWidgetSetActor(_PortraitWidget, Portrait, _Actor, "Idle")

    if g_FaceFXCamera[_Actor] == nil then
        _Actor = "H_Knight_Chivalry"
    end

    -- camera settings
    GUI.ModelViewSetCameraFOV(_PortraitWidget, g_FaceFXCamera[_Actor].FOV)
    GUI.ModelViewSetCamera(_PortraitWidget, g_FaceFXCamera[_Actor].PosX, g_FaceFXCamera[_Actor].PosY, g_FaceFXCamera[_Actor].PosZ, g_FaceFXCamera[_Actor].LookAtX, g_FaceFXCamera[_Actor].LookAtY, g_FaceFXCamera[_Actor].LookAtZ)
end


function GetKnightActor(_KnightEntityType)
    local Actor = nil

    if _KnightEntityType == Entities.U_KnightTrading then
        Actor = "H_Knight_Trading"
    elseif _KnightEntityType == Entities.U_KnightHealing then
        Actor = "H_Knight_Healing"
    elseif _KnightEntityType == Entities.U_KnightChivalry then
        Actor = "H_Knight_Chivalry"
    elseif _KnightEntityType == Entities.U_KnightWisdom then
        Actor = "H_Knight_Wisdom"
    elseif _KnightEntityType == Entities.U_KnightPlunder then
        Actor = "H_Knight_Plunder"
    elseif _KnightEntityType == Entities.U_KnightSong then
        Actor = "H_Knight_Song"
    elseif _KnightEntityType == Entities.U_KnightSabatta then
        Actor = "H_Knight_Sabatt"
    elseif _KnightEntityType == Entities.U_KnightRedPrince then
        Actor = "H_Knight_RedPrince"
    elseif _KnightEntityType == Entities.U_NPC_Castellan_ME then
        Actor = "H_NPC_Castellan_ME"
    elseif _KnightEntityType == Entities.U_NPC_Castellan_NE then
        Actor = "H_NPC_Castellan_NE"
    elseif _KnightEntityType == Entities.U_NPC_Castellan_NA then
        Actor = "H_NPC_Castellan_NA"
    elseif _KnightEntityType == Entities.U_NPC_Castellan_SE then
        Actor = "H_NPC_Castellan_SE"
    end

    return Actor
end


function DisplayCoA()

    local LogoTexture = Profile.GetInteger("Profile", "LogoTexture", 0)
    local PatternTexture = Profile.GetInteger("Profile", "PatternTexture", 0)
    local IsMultiplayer = Framework.IsNetworkGame()
    local IsPlayingReplay = Game.IsPlayingReplay()

    if IsMultiplayer == false and IsPlayingReplay == false then
        GUI.SetPlayerColorData(GUI.GetPlayerID(), -1, LogoTexture, PatternTexture)
    end
end


function SetupPlayer(_PlayerID, _Head, _Name, _ForceName )

    -- save head
    g_PlayerPortrait[_PlayerID] = _Head

   local PlayerName = ""

    local MapType, Campaign = Framework.GetCurrentMapTypeAndCampaignName()
    
    if MapType == 3 then -- external map
    
        PlayerName = _Name
    
    elseif CurrentMapIsCampaignMap ~= true then

        local PlayerCategory = GetPlayerCategoryType(_PlayerID)
        local PlayerCategoryName = GetNameOfKeyInTable(PlayerCategories, PlayerCategory)

        local StringTable = "UI_ObjectNames"


        if PlayerCategory == PlayerCategories.BanditsCamp then

            local MapName = Framework.GetCurrentMapName()
            local ClimateZoneName = Framework.GetMapClimateZone(MapName, MapType, Campaign)
            PlayerName = XGUIEng.GetStringTableText(StringTable .. "/" .. PlayerCategoryName .."_".. ClimateZoneName)

        else
        
            local TerritoryName
            local StoreHouseID = Logic.GetStoreHouse(_PlayerID)
            if StoreHouseID == 0 then
                TerritoryName = _Name
            else
                local TerritoryID = GetTerritoryUnderEntity(StoreHouseID)
                TerritoryName = GetTerritoryName(TerritoryID)
            end
            
            if PlayerCategoryName and TerritoryName then
                PlayerName = XGUIEng.GetStringTableText(StringTable .. "/PlayerCategory_" .. PlayerCategoryName) .." ".. TerritoryName
            else
                PlayerName = XGUIEng.GetStringTableText(StringTable .. "/PlayerCategory_Unknown")
            end

        end

    else
        -- get name from string table
        local MapName = Framework.GetCurrentMapName()
        local StringTable = "Map_" .. MapName

        PlayerName = string.gsub(_Name, " ", "")

        PlayerName = XGUIEng.GetStringTableText(StringTable .. "/PlayerName_" .. PlayerName)

    end

    if PlayerName == "" and Logic.GetKnightID(_PlayerID) ~= 0 then
        local KnightType = Logic.GetEntityType(Logic.GetKnightID(_PlayerID))
        PlayerName = XGUIEng.GetStringTableText("Names/" .. Logic.GetEntityTypeName(KnightType))
    end


    if PlayerName == "" and GetPlayerCategoryType(_PlayerID) == PlayerCategories.Harbour then
        PlayerName = XGUIEng.GetStringTableText("UI_ObjectNames/B_NPC_ShipsStorehouse")
    end


    -- AnSu: ToDo: Add check if map is a user map here
    if PlayerName == "" then
        PlayerName = _Name .. "(key?)"
    end
    
    if _ForceName and _Name then
        PlayerName = _Name
    end

    if Game.IsPlayingReplay() ~= true then
        
        GUI.SetPlayerName(_PlayerID, PlayerName)
        
    end
end
