
-----------------------------------------------------------------------------------------
-- Overwrites for LocalVictoryCondition
-----------------------------------------------------------------------------------------

function InitOverwriteLocalVictoryConditionEx2()

    do
        local OldVictory = Victory
        function Victory( _VictoryAndDefeatType)
            if g_Victory ~= nil then
                return
            end

            local PlayerID = 1
	        StartEventMusic(MusicSystem.GameWon, PlayerID)

            OldVictory()
        end
    end
    
    do
        local OldDefeated = Defeated
        function Defeated(_PlayerID)
            if _PlayerID == GUI.GetPlayerID() then
		        StartEventMusic(MusicSystem.GameLost, _PlayerID)
                OldDefeated()
            end
        end
    end

    do
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

            g_TotalPointsInAllMaps = 0
            
            for i=1, #KnightTypes do
                local KnightTypeName = KnightTypes[i]
                --get the sum titles and prestigepoints of knight in all maps
                for j=1,#CampaignMaps do
                    local MapName = string.lower(CampaignMaps[j])
                    
                    if Profile.PrestigeAndTitleExist(KnightTypeName, MapName) then
                        local PointsInMap, Title = Profile.GetPrestigeAndTitle(KnightTypeName, MapName)
                        g_TotalPointsInAllMaps = g_TotalPointsInAllMaps + PointsInMap
                    end
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
            
            Profile.SetTraitor(CalculateTraitor())

        end
    end

end