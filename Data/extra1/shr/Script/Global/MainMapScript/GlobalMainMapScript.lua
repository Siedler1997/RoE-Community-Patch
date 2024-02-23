Script.Load("Script\\Shared\\ScriptTools\\SharedPresentationTools.lua" )

function GameCallback_SetTraitorType(_TraitorType)
    g_Traitor = _TraitorType
end


-- This function exists b/c our boot up structure
-- is a royal pain. At some point during the initialization
-- of an MP replay, Framework.IsNetworkGame() will return false.
-- However, by the time this function is called from GameCallback_OnGameStart
-- The game will reliably -- and correctly -- report the running game
-- to be an MP game
function IsCurrentMapInFreeSettleMode()
    
    
    -- This variable must be set per map in MapScript.lua    
    if not CurrentMapIsFreeSettleModeMap then
        return false
    end
    
    if Framework.IsNetworkGame() then
        return false
    end
    
    return true
end

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

function CreateKnightForPlayer(_PlayerID, _KnightType)
    GameCallback_CreateKnightByTypeOrIndex(_KnightType, _PlayerID)
end


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

--------------------------------------------------------------------------
-- Called when logic is re-created after loading a save game. 
function Mission_OnSaveGameLoaded()
    

end

--------------------------------------------------------------------------
-- spawns military troops from special scriptentities ( S_* ) <- not a smiley
function SpawnMilitaryEntities()

    function SpawnFromType(entityTypeToLookFor, entityTypeToSpawn)
        for i=1, 8 do
            local results = { Logic.GetPlayerEntities(i, entityTypeToLookFor, 15, 0) }
            for j=1, results[1] do
            
                local x, y = Logic.GetEntityPosition(results[j+1])
                local orientation = Logic.GetEntityOrientation(results[j+1]) - 90
                local name = Logic.GetEntityName(results[j+1])
                Logic.DestroyEntity( results[j+1] )
                
                local ID
                if Logic.IsEntityTypeInCategory(entityTypeToSpawn,EntityCategories.Soldier) == 1 then
                    ID = Logic.CreateBattalionOnUnblockedLand(entityTypeToSpawn, x, y, orientation, i)
                else
                    ID = Logic.CreateEntityOnUnblockedLand(entityTypeToSpawn, x, y, orientation, i)
                end
                
                if name and ID and ID ~= 0 then
                    Logic.SetEntityName( ID, name )
                end                
            end
        end
    end

    SpawnFromType(Entities.S_MilitaryBow, Entities.U_MilitaryBow)
    SpawnFromType(Entities.S_MilitarySword, Entities.U_MilitarySword)
    SpawnFromType(Entities.S_CatapultCart, Entities.U_CatapultCart)
    SpawnFromType(Entities.S_AmmunitionCart, Entities.U_AmmunitionCart)
    SpawnFromType(Entities.S_BatteringRamCart, Entities.U_BatteringRamCart)
    SpawnFromType(Entities.S_SiegeTowerCart, Entities.U_SiegeTowerCart)
    SpawnFromType(Entities.S_Trebuchet, Entities.U_Trebuchet)
    SpawnFromType(Entities.S_MilitaryBandit_Melee_NE, Entities.U_MilitaryBandit_Melee_NE)
    SpawnFromType(Entities.S_MilitarySword_RedPrince, Entities.U_MilitarySword_RedPrince)
    SpawnFromType(Entities.S_MilitaryBow_RedPrince, Entities.U_MilitaryBow_RedPrince)
--    SpawnFromType(Entities.S_BallistaCart, Entities.U_SiegeEngineCart)
    
end


function InitPlayerColorIndex()
    g_ColorIndex = {}
    --[[
    g_ColorIndex["CityColor1"] = 1
    g_ColorIndex["CityColor2"] = 2
    g_ColorIndex["CityColor3"] = 3
    g_ColorIndex["CityColor4"] = 4

    g_ColorIndex["CityColor5"] = 5      --Yellow
    g_ColorIndex["CityColor6"] = 6      --Orange
    g_ColorIndex["CityColor7"] = 7      --Purple
    g_ColorIndex["CityColor8"] = 8      --Pink
    g_ColorIndex["RedPrinceColor"] = 9
    
    g_ColorIndex["VillageColor1"] = 10
    g_ColorIndex["VillageColor2"] = 11
    g_ColorIndex["VillageColor3"] = 12
    g_ColorIndex["VillageColor4"] = 13  --Light Blue
    
    g_ColorIndex["CloisterColor1"] = 14
    g_ColorIndex["CloisterColor2"] = 15
    g_ColorIndex["CloisterColor3"] = 16
    g_ColorIndex["CloisterColor4"] = 17 --White
    g_ColorIndex["CloisterColor5"] = 18 --Light Green
    
    g_ColorIndex["BanditsColor1"] = 19
    g_ColorIndex["BanditsColor2"] = 20
    g_ColorIndex["BanditsColor3"] = 21
    g_ColorIndex["BanditsColor4"] = 22  --Black
    g_ColorIndex["BanditsColor5"] = 23  --Dark Grey
    
    g_ColorIndex["TravelingSalesmanColor"] = 24
    --]]
    
    g_ColorIndex["CityColor1"] = 1
    g_ColorIndex["CityColor2"] = 2
    g_ColorIndex["CityColor3"] = 3
    g_ColorIndex["CityColor4"] = 4
    
    g_ColorIndex["VillageColor1"] = 5
    g_ColorIndex["VillageColor2"] = 6
    g_ColorIndex["VillageColor3"] = 7
    
    g_ColorIndex["CloisterColor1"] = 8
    g_ColorIndex["CloisterColor2"] = 9
    g_ColorIndex["CloisterColor3"] = 10
    
    g_ColorIndex["BanditsColor1"] = 11
    g_ColorIndex["BanditsColor2"] = 12
    g_ColorIndex["BanditsColor3"] = 13
    
    g_ColorIndex["RedPrinceColor"] = 14
    
    g_ColorIndex["TravelingSalesmanColor"] = 15
    
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

function SetupPlayer(_PlayerID, _Head, _Name, _ColorName, _Logo, _Pattern)


    local ColorIndex = 1
    
    if _ColorName ~= nil then    
        ColorIndex = g_ColorIndex[_ColorName]        
    end
    
    if _Logo == nil then
        _Logo = -1
    end
    
    if _Pattern == nil then
        _Pattern = -1
    end
        
    --set color, logo and pattern
    Logic.PlayerSetPlayerColor( _PlayerID , ColorIndex ,  _Logo , _Pattern)
    
    --save head and set player name (is set in global state but sringtable can only be checked in local state
    Logic.ExecuteInLuaLocalState("SetupPlayer(" .. _PlayerID ..",'" .. _Head .. "','" .. _Name .. "')")
    
    return _PlayerID
        

end

function GlobalGetTraitor()
    
    local Traitor = g_Traitor
    
    if Traitor == nil then
        Traitor = Entities.U_KnightChivalry
    end
       
    return Traitor
    
end


function SaveTraitorToGlobalValue(_Traitor)
    --the traitor is saved in the Profile, which can only be accessed through the local state
    --the traitor is also needed in the global state, so we save it in a global value in the global state
    
--    g_Traitor = _Traitor
    
end



function SetupNPCPlayerHeadsAndName()
    
    local BanditColorCounter = 1
    local VillageColorCounter = 1
    local CloisterColorCounter = 1
    local CityColorCounter = 2
    
    
    for PlayerID = 1, 8 do
        
        if  Logic.PlayerGetIsHumanFlag(PlayerID) ~= true 
        and Logic.GetStoreHouse(PlayerID) ~= 0 then
        
            local PlayerName = ""
            local Head = "H_NPC_"
            local IndexColor = ""
            
            local PlayerCategory = GetPlayerCategoryType(PlayerID)
            
            local MapName = Framework.GetCurrentMapName()
            local MapType, Campaign = Framework.GetCurrentMapTypeAndCampaignName()
            local ClimateZoneName = Framework.GetMapClimateZone(MapName, MapType, Campaign)
            
            local Suffix = ""

            if ClimateZoneName == "Generic"
            or ClimateZoneName == "MiddleEurope" then
                Suffix = "_ME"
            elseif ClimateZoneName == "NorthEurope" then
                Suffix = "_NE"
            elseif ClimateZoneName == "SouthEurope" then
                Suffix = "_SE"
            elseif ClimateZoneName == "NorthAfrica" then
                Suffix = "_NA"
            end
            
            if PlayerCategory == PlayerCategories.BanditsCamp then
                
                Head = Head .. "Mercenary" ..Suffix
                IndexColor  = "BanditsColor" .. BanditColorCounter
                BanditColorCounter = BanditColorCounter + 1
                
            elseif PlayerCategory == PlayerCategories.Cloister then
                
                Head = Head .. "Monk" ..Suffix                
                IndexColor  = "CloisterColor" .. CloisterColorCounter
                CloisterColorCounter = CloisterColorCounter + 1
                
            elseif PlayerCategory == PlayerCategories.Village then
                
                Head = Head .. "Villager01" ..Suffix         
                IndexColor  = "VillageColor" .. VillageColorCounter   
                VillageColorCounter = VillageColorCounter + 1

            elseif PlayerCategory == PlayerCategories.City then
                
                Head = Head .. "Castellan" ..Suffix         
                IndexColor  = "CityColor" .. CityColorCounter   
                CityColorCounter = CityColorCounter + 1
            
            elseif PlayerCategory == PlayerCategories.Harbour then
                
                Head = Head .. "Generic_Trader"
                IndexColor  = "TravelingSalesmanColor"
                
            end            
            
            SetupPlayer(PlayerID, Head, "NPC Player has no name", IndexColor)
            
        end
    end
end


function InitGenericAIProfiles()

    for PlayerID=1, 8 do    
        
        if Logic.PlayerGetIsHumanFlag(PlayerID) ~= true 
        and AIPlayer[PlayerID] == nil 
        and AIPlayerBlackList ~= nil 
        and AIPlayerBlackList[PlayerID] ~= true then
            
            local PlayerCategory = GetPlayerCategoryType(PlayerID)
            
            if PlayerCategory == PlayerCategories.City then
                
                AIPlayer:new(PlayerID, AIPlayerProfile_City)
                --Logic.DEBUG_AddNote("P:" .. PlayerID .. " CITY AI STARTED")
                
            elseif  PlayerCategory == PlayerCategories.Village 
            or      PlayerCategory == PlayerCategories.Cloister
            or      PlayerCategory == PlayerCategories.Harbour then
                
                AIPlayer:new(PlayerID, AIPlayerProfile_Village)
                
                --Logic.DEBUG_AddNote("P:" .. PlayerID .. " VILLAGE AI STARTED")
            
            end
        end
        
    end
    
end

function DoNotStartAIForPlayer( _PlayerID )

    AIPlayerBlackList[_PlayerID] = true

end
