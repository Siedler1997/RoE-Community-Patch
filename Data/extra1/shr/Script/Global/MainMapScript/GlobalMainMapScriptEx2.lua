
-----------------------------------------------------------------------------------------
-- New funcs for GlobalMainMapScript
-----------------------------------------------------------------------------------------

function PlayerChangePlayerColor()
	Logic.ExecuteInLuaLocalState("SetPreferredPlayerColor()")
    return true
end

function PlayerChangePlayerColor2(_newColor)
    if _newColor > 0 then
        Logic.PlayerSetPlayerColor(1, _newColor, -1, -1)
	    Logic.ExecuteInLuaLocalState("Display.UpdatePlayerColors()")
	    Logic.ExecuteInLuaLocalState("GUI.RebuildMinimapTerrain()")
    end
end

-----------------------------------------------------------------------------------------
-- Overwrites for GlobalMainMapScript
-----------------------------------------------------------------------------------------

function InitOverwriteGlobalMainMapScriptEx2()

    --------------------------------------------------------------------------
    --  calback executed on game start
    --------------------------------------------------------------------------
    do 
        function GameCallback_OnGameStart() 

	        -- INIT GUI AND SYSTEM RELEVANT TABLES
            do 
                -- Init shared constants
                InitSharedConstants()

                -- Init the merchant update for all AI Players
                InitGlobalMerchantSystem()
        
                 --Init global table to track the current taxation of the players
                InitGlobalTaxationTables()
        
                --Init the city development 
                InitGlobalCityDevelopment()
        
                -- init diplomacy system
                InitializeDiplomaticEntities()
        
                -- init the event system
                EventSystem_Launch()
        
                NPCDialog_Launch()
        
                SpawnMilitaryEntities()
                -- gets all S_ShipPath entities and make paths out of it
                InitAllShipPaths()
        
                InitPlayerColorIndex()
        
                CreateTreasures()
        
                InitEndStatistic()
            end
           
            -- INIT MAP DEFINED STUFF
            do
        
                -- INIT PLAYERS
                if Mission_InitPlayers ~= nil then
                    Mission_InitPlayers()

                    if Framework.IsNetworkGame() then
                        for i=1,8 do
                            Logic.PlayerSetPlayerColor(i , 18, -1, -1)
                        end  
                    end
                else
                    for i=1,8 do
                        AddResourcesToPlayer(Goods.G_Gold,30, i)
                        AddResourcesToPlayer(Goods.G_Wood,20, i)
                    end    
                end
        
                -- INIT CLIMATE 
                if Mission_SetStartingMonth ~= nil then
                    Mission_SetStartingMonth()
                else
                    Logic.SetMonthOffset(1)
                end
            
                local MapName = Framework.GetCurrentMapName()
                local MapType, Campaign = Framework.GetCurrentMapTypeAndCampaignName()
    
                local ClimateZoneName = Framework.GetMapClimateZone(MapName, MapType, Campaign)
                local ClimateZoneID = ClimateZones[ClimateZoneName] 
        
                if ClimateZoneID == nil then
                    ClimateZoneID = ClimateZones.MiddleEurope
                end
        
                Logic.SetClimateZone(ClimateZoneID)
        
                -- INIT MERCHANTS, MERCENARIES etc
                if Mission_InitMerchants ~= nil then
                    Mission_InitMerchants()
                end
            end
    
            -- CALL FIRST MAP ACTION
	        if Mission_FirstMapAction ~= nil then
		        Mission_FirstMapAction()
	        end
	
	        -- GENERATE PLAYER NAMES AND HEADS IF IT IS NOT A CAMPAIGN MAP
	        local MapType, Campaign = Framework.GetCurrentMapTypeAndCampaignName()
	        if (CurrentMapIsCampaignMap ~= true) and (MapType ~= 3) and not g_PlayersWereSetUp then
                SetupNPCPlayerHeadsAndName()
	        end
	
	        -- GENERATE SRUFF FRO FREE SETTLE MODE
	        if IsCurrentMapInFreeSettleMode() then
                InitFreeSettleMode()
            end
    
            --INIT AIs IF NOT DONE IN MAPSCRIPT
            --if Framework.IsNetworkGame() ~= true then
                InitGenericAIProfiles()
            --end
    
            --INIT NEEDS AND RIGHTS
            do
        
                for PlayerID =1,8 do
            
                    --HACK: SET THRESHOLDS AT MAP START
                    local Buildings = {Logic.GetPlayerEntitiesInCategory(PlayerID,EntityCategories.CityBuilding)}
            
                    for i=1,table.getn(Buildings) do
                        local BuildingID = Buildings[i]                
                        SetThresholdsForCityBuildingID(BuildingID)
                    end
            
            
                    local KnightTitle = Logic.GetKnightTitle(PlayerID)
                    ActivateNeedsAndRightsForPlayerByKnightTitle(PlayerID, KnightTitle)
            
                    local MarketplaceID = Logic.GetMarketplace(PlayerID)
            
                    if MarketplaceID ~= 0 then
                        Logic.AddGoodToStock(MarketplaceID, Goods.G_Water, 50)
                    end
            
                end
            
            end
    
	

	        -- now assign properly startup states	
	        SetupDiplomacyStatesFromLogic()
	
	        --setup the outlaws 
	        -- has to be done after all map scripts, because there you can exclude players with outlaws from generic script
            SetupOutlaws()
    
            --init the victory condition
            InitGlobalVictoryCondition()

            -- Alternate player color (yellow)
	        StartSimpleJob("PlayerChangePlayerColor")
        end
    end
    
    --------------------------------------------------------------------------
    --  Create knight for player
    --------------------------------------------------------------------------
    do
        function GameCallback_CreateKnightByTypeOrIndex(_KnightType, _PlayerID)
            if Logic.GetKnightID(_PlayerID) == 0 then
    
                local MapType, CampaignName = Framework.GetCurrentMapTypeAndCampaignName()
    
                if (Logic.PlayerGetIsHumanFlag(_PlayerID) )then
        
                    if (MapType == 3 or MapType == 2 or MapType == 0)then  -- Multiplayer, Singleplayer, Custom 
                        local KnightIndex = _KnightType
                        _KnightType = GetKnightTypeIDForMPGame(KnightIndex, _PlayerID)
                    end
		        --[[
                else
                    _KnightType = nil
		        --]]
                end
        
                if (_KnightType == nil) or (_KnightType <= 1) then
        	        _KnightType = Entities.U_KnightChivalry
                end
        
        
                if Framework.CheckIDV() then
        
        	        if _KnightType ~= Entities.U_KnightChivalry and _KnightType ~= Entities.U_KnightHealing then
        
        		        _KnightType = Entities.U_KnightChivalry
        		
        	        end
        
                end
        
        
                -- Get Startposition
                local Amount, StartID = Logic.GetPlayerEntities(_PlayerID, Entities.XD_StartPosition, 1)
        
                local x,y,Orientation
        
                if StartID ~= nil then            
                    x,y = Logic.GetEntityPosition(StartID)
                    Orientation = Logic.GetEntityOrientation(StartID) - 90
                end
        
                -- Get Castle, if no startposition has been set
                if StartID ==  nil then
            
                    StartID = Logic.GetHeadquarters(_PlayerID)
                end
        
                -- Get Storehouse, if no startposition and no castle has been set
                if StartID ==  nil then
            
                    StartID = Logic.GetStoreHouse(_PlayerID)
            
                end
        
        
                if StartID ~= nil and StartID ~= 0 then
        
                    local KnightID
            
                    if x == nil then

                        KnightID = Logic.CreateEntityAtBuilding(_KnightType, StartID, Orientation, _PlayerID)
            
                    else
                
                        KnightID = Logic.CreateEntityOnUnblockedLand( _KnightType, x, y, Orientation, _PlayerID)
                
                    end
            
                    Logic.SetEntityName(KnightID, "Player" .. _PlayerID .. "Knight")
        
                else
                    Logic.DEBUG_AddNote("DEBUG: Knight could not placed for player " .. _PlayerID .. "No XD_StartPosition, Castle or Storhouse")
                end

            end
        end
    end

    --------------------------------------------------------------------------
    --  Player colors
    --------------------------------------------------------------------------
    do 
        local OldInitPlayerColorIndex = InitPlayerColorIndex
        
        InitPlayerColorIndex = function()
        
            -- call old initializeer
            OldInitPlayerColorIndex()
        
            --Normally unused
            g_ColorIndex["VillageColor4"] = 16  --Light Blue
            g_ColorIndex["CityColor8"] = 17     --Pink

            -- CP-Colors
            g_ColorIndex["CityColor5"] = 18     --Yellow
            g_ColorIndex["CityColor6"] = 19     --Orange
            g_ColorIndex["CityColor7"] = 20     --Purple
            g_ColorIndex["CloisterColor4"] = 21 --White
            g_ColorIndex["CloisterColor5"] = 22 --Light Green
            g_ColorIndex["BanditsColor4"] = 23  --Black
            g_ColorIndex["BanditsColor5"] = 24  --Dark Grey

        end
    end

end