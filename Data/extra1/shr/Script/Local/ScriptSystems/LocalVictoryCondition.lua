--------------------------------------------------------------------------
--        ***************** Victory Condition SYSTEMS *****************
--  This script decides, if a player has lost or won in SP
--------------------------------------------------------------------------


function InitLocalVictoryCondition()

    VictoryCondition = Logic.CreateReferenceToTableInGlobaLuaState("VictoryCondition")

end


function OnLastQuestInCampaignMapFinished()

    StartEventMusic(MusicSystem.GameWon)
        
    XGUIEng.ShowWidget("/InGame/Root/Normal/MissionGoodOrEntityCounter", 0)
    XGUIEng.ShowWidget("/InGame/Root/Normal/MissionTimer", 0)

    if Mission_LocalVictory ~= nil then
        Mission_LocalVictory()
    else
    
        local MarketplaceID = Logic.GetMarketplace(1)
    
        if MarketplaceID ~= 0 then
            CameraAnimation.AllowAbort = false
            CameraAnimation.QueueAnimation( CameraAnimation.SetCameraToEntity, MarketplaceID)
            CameraAnimation.QueueAnimation( CameraAnimation.ZoomCameraToFactor,  0.4 )
            CameraAnimation.QueueAnimation( CameraAnimation.StartCameraRotation,  5 )
            CameraAnimation.QueueAnimation( CameraAnimation.Stay ,  9999 )
    
        end
        
    end
    
end

------ local victory function for single player-----------

function Victory( _VictoryAndDefeatType)
    
    if g_Victory ~= nil then
        return
    end

    local PlayerID = 1
	StartEventMusic(MusicSystem.GameWon, PlayerID)

    local MapType, CampaignName = Framework.GetCurrentMapTypeAndCampaignName()
    
    if CurrentMapIsCampaignMap then

        --save knight title and prestige points
        local KnightID = Logic.GetKnightID(1)
        local KnightType = Logic.GetEntityType(KnightID)
        local KnightTypeName = Logic.GetEntityTypeName(KnightType)

        local Title = Logic.GetKnightTitle(1)
        
        --AnSu: Using the total sum of points may be not the best idea. so I chose the prestige points, that can hae a max
        --Maybe also a problem: We do not have many optional quests
        local Points = EndStatisticGetPrestigePoints(PlayerID)

        local MapName = Framework.GetCurrentMapName()

        local PreviousTitle = Title
        local PreviousPoints = Points
        local Nothing
            
        if Profile.PrestigeAndTitleExist(KnightTypeName, MapName) then    
            PreviousPoints, PreviousTitle = Profile.GetPrestigeAndTitle(KnightTypeName, MapName)
        end
        
        --take the better title
        if PreviousTitle > Title then
            Title = PreviousTitle
        end

        --take the better prestige points
        if PreviousPoints > Points then
            Points = PreviousPoints
        end

        --DO NOT COMMENT THIS FUNCTION! IT IS VERY IMPORTANT
		Profile.SetPrestigeAndTitle(KnightTypeName, MapName, Points, Title)
        
        CalculateTraitorAndPoints()
        
        local TotalPointsOnMap = Quest_GetMaxPrestigePoints(PlayerID)        
        Profile.SetInteger(MapName,"MaxPoints", TotalPointsOnMap)
        
        
    end
    
    local Marketplace = Logic.GetMarketplace(PlayerID)

    StartEventMusic(MusicSystem.GameWon)

    if Marketplace ~= 0 then

        --local x,y = Logic.GetEntityPosition(Marketplace)

        --Camera.RTS_SetLookAtPosition(x,y)
        --Camera.RTS_SetZoomFactor(0.5)


        --GUI.StartFestival(PlayerID, 1)

    end

    g_Victory = true
    GUI_Window.MissionEndScreenSetVictoryText(g_Victory, _VictoryAndDefeatType)
    GUI_Window.Toggle("MissionEndScreen")
end


------ local defeat function for single player-----------
function Defeated(_PlayerID)
    if _PlayerID == GUI.GetPlayerID() then
		StartEventMusic(MusicSystem.GameLost, _PlayerID)
    
        local MapType, Campaign = Framework.GetCurrentMapTypeAndCampaignName()
        
        if MapType < 2 then --not multiplayer
            local x,y = Camera.RTS_GetLookAtPosition()
            
            CameraAnimation.AllowAbort = false
            CameraAnimation.QueueAnimation( CameraAnimation.MoveCameraToPosition, x,y)
            CameraAnimation.QueueAnimation( CameraAnimation.ZoomCameraToFactor,  0.4 )
            CameraAnimation.QueueAnimation( CameraAnimation.StartCameraRotation,  5 )
            CameraAnimation.QueueAnimation( CameraAnimation.Stay ,  9999 )
        end
    
        g_Victory = false
        GUI_Window.MissionEndScreenSetVictoryText(g_Victory)
        GUI_Window.Toggle("MissionEndScreen")
    end
end

function CalculateTraitorAndPoints()

--get Title and prestige points of each knight and take the knight with the lowest as traitor
-- save traitor in GBD

    --I do not like this, but I have no other idea how to get this data:
    local KnightTypes = {"U_KnightChivalry",
                        "U_KnightHealing",
                        "U_KnightSong",
                        "U_KnightTrading",
                        "U_KnightPlunder",
                        "U_KnightWisdom"}

    local CampaignMaps = {"c00_m01_Vestholm",
                            "c00_m02_Challia",
                            "c00_m03_Gallos",
                            "c00_m04_Narfang",
                            "c00_m05_Drengir",
                            "c00_m06_Rekkyr",
                            "c00_m07_Geth",
                            "c00_m08_Seydiir",
                            "c00_m09_Husran",
                            "c00_m10_Juahar",
                            "c00_m11_Tios",
                            "c00_m12_Sahir",
                            "c00_m13_Montecito",
                            "c00_m14_Gueranna",
                            "c00_m15_Vestholm",
                            "c00_m16_Rossotorres" }

    local Traitor

    local LowestTitle = 1000
    
    g_TotalPointsInAllMaps = 0
    
    for i=1, #KnightTypes do

        local KnightTypeName = KnightTypes[i]

        local SumOfTitle = 0  

        --get the sum titles and prestigepoints of knight in all maps
        for j=1,#CampaignMaps do

            local MapName = string.lower(CampaignMaps[j])
            
			if Profile.PrestigeAndTitleExist(KnightTypeName, MapName) then
            
				local PointsInMap, Title = Profile.GetPrestigeAndTitle(KnightTypeName, MapName)
	            
	            g_TotalPointsInAllMaps = g_TotalPointsInAllMaps + PointsInMap

                SumOfTitle = SumOfTitle + Title

		    end
		    
        end

        if SumOfTitle < LowestTitle then
            Traitor = KnightTypeName
            LowestTitle = SumOfTitle
        end
    end
    
     --get the sum of max points on all played maps
     g_MaxPointsOnAllMaps = 0
     for j=1,#CampaignMaps do
        local MapName = string.lower(CampaignMaps[j])
        if Profile.IsKeyValid(MapName,"MaxPoints") then
            g_MaxPointsOnAllMaps = g_MaxPointsOnAllMaps + Profile.GetInteger(MapName,"MaxPoints",0)
        end
    end
    
    Profile.SetTraitor(Traitor)

end


function HasVideoToPlay(_MapName)
    if  _MapName == "c00_m04_narfang" or
        _MapName == "c00_m08_seydiir" or
        _MapName == "c00_m12_sahir"   or
        _MapName == "c00_m16_rossotorres" then
        
        return true
        
    else
        return false
    end

end

function PlayVideo(_MapName) -- called in GUI_Window.NextMapClicked()

    if not HasVideoToPlay(_MapName) then
        return
    end

    Sound.SetPause(1)

	local gendername = Profile.GetString("Profile", "Gender")

    local Gender = 0
	if gendername == "female" then
		Gender = 1
	end
    
    if _MapName == "c00_m04_narfang" then

		Framework.PlayVideo("videos\\c00_endofact1", Gender, false, false)
		
    elseif _MapName == "c00_m08_seydiir" then
		
		Framework.PlayVideo("videos\\c00_endofact2", Gender, false, false)

    elseif _MapName == "c00_m12_sahir" then
		
		local Traitor = Profile.GetTraitor()
		
		if Traitor == "U_KnightTrading" then
			Framework.PlayVideos("videos\\c00_endofact3", "videos\\c00_endofact3_elias", Gender)
		elseif Traitor == "U_KnightHealing" then
			Framework.PlayVideos("videos\\c00_endofact3", "videos\\c00_endofact3_alandra", Gender)
		elseif Traitor == "U_KnightChivalry" then
			Framework.PlayVideos("videos\\c00_endofact3", "videos\\c00_endofact3_marcus", Gender)
		elseif Traitor == "U_KnightPlunder" then
			Framework.PlayVideos("videos\\c00_endofact3", "videos\\c00_endofact3_kestral", Gender)
		elseif Traitor == "U_KnightSong" then
			Framework.PlayVideos("videos\\c00_endofact3", "videos\\c00_endofact3_thordal", Gender)
		elseif Traitor == "U_KnightWisdom" then
			Framework.PlayVideos("videos\\c00_endofact3", "videos\\c00_endofact3_hakim", Gender)
		end
		
    elseif _MapName == "c00_m16_rossotorres" then
		
		local PlayerPoints = g_TotalPointsInAllMaps
		local SumOfPoints = g_MaxPointsOnAllMaps
		
		local BadGameThreshold = 0.2 * SumOfPoints
		local SuperbGameThreshold = 0.8 * SumOfPoints
		
		if  PlayerPoints < BadGameThreshold then
		    -- the "normal" version has "no gender"
		    Profile.SetInteger("Profile", "Success", 1278560)
			Framework.PlayVideos("videos\\c00_endofact4", "videos\\c00_endofact4_final1", 0)
			
		elseif PlayerPoints >= SuperbGameThreshold then
			Framework.PlayVideos("videos\\c00_endofact4", "videos\\c00_endofact4_final3", Gender)			
		else
		    Profile.SetInteger("Profile", "Success", 3491245)
		    Framework.PlayVideos("videos\\c00_endofact4", "videos\\c00_endofact4_final2", Gender)
		end

    end

end
