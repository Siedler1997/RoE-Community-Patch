CurrentMapIsFreeSettleModeMap = true
----------------------------------------------------------------------------------------------------------------------
function Mission_InitPlayers()

    -- set some resources for player 1
    AddResourcesToPlayer(Goods.G_Gold,300)
    AddResourcesToPlayer(Goods.G_Wood,30)
    AddResourcesToPlayer(Goods.G_Grain,10)
    AddResourcesToPlayer(Goods.G_Carcass,10)

    -- and for AIs
    AddResourcesToPlayer(Goods.G_Gold,1000, 2)    
    AddResourcesToPlayer(Goods.G_Iron,30, 2)
    AddResourcesToPlayer(Goods.G_Wood,30, 2)
    AddResourcesToPlayer(Goods.G_Grain,30, 2)
    AddResourcesToPlayer(Goods.G_Carcass,30, 2)
    AddResourcesToPlayer(Goods.G_Herb,30, 2)
    AddResourcesToPlayer(Goods.G_Wool,30, 2)
    AddResourcesToPlayer(Goods.G_Milk,30, 2)
    AddResourcesToPlayer(Goods.G_RawFish,30, 2)
    AddResourcesToPlayer(Goods.G_Honeycomb,30, 2)
	
    AddResourcesToPlayer(Goods.G_Gold,1000, 4)    
    AddResourcesToPlayer(Goods.G_Iron,30, 4)
    AddResourcesToPlayer(Goods.G_Wood,30, 4)
    AddResourcesToPlayer(Goods.G_Grain,30, 4)
    AddResourcesToPlayer(Goods.G_Carcass,30, 4)
    AddResourcesToPlayer(Goods.G_Herb,30, 4)
    AddResourcesToPlayer(Goods.G_Wool,30, 4)
    AddResourcesToPlayer(Goods.G_Milk,30, 4)
    AddResourcesToPlayer(Goods.G_RawFish,30, 4)
    AddResourcesToPlayer(Goods.G_Honeycomb,30, 4)

end

----------------------------------------------------------------------------------------------------------------------
function Mission_SetStartingMonth()

    Logic.SetMonthOffset(3)

end

----------------------------------------------------------------------------------------------------------------------
function Mission_InitMerchants()

	local TraderID = Logic.GetStoreHouse(2)
	AddOffer			(TraderID,	3, Goods.G_Leather)
	AddOffer			(TraderID,	3, Goods.G_Bread)
	AddOffer			(TraderID,	 3, Goods.G_Wood)
	AddOffer			(TraderID,	 3, Goods.G_Stone)

    local TraderID = Logic.GetStoreHouse(3)    
    AddOffer			(TraderID,	1, Goods.G_Sheep)
    AddOffer			(TraderID,	1, Goods.G_Cow)
    AddOffer			(TraderID, 3, Goods.G_Grain)
    AddOffer			(TraderID, 3, Goods.G_RawFish)

	local TraderID = Logic.GetStoreHouse(4)
	AddOffer			(TraderID,	 3, Goods.G_Clothes)
	AddOffer			(TraderID,	 3, Goods.G_Broom)
	AddOffer			(TraderID,	3, Goods.G_Stone)
	AddOffer			(TraderID,	3, Goods.G_Iron)

	local TraderID = Logic.GetStoreHouse(5)
	AddOffer			(TraderID,	 3, Goods.G_Beer)
	AddOffer			(TraderID,	 3, Goods.G_Medicine)
	AddOffer			(TraderID,	3, Goods.G_Clothes)
	AddOffer			(TraderID,	5, Goods.G_Herb)

    local _, TradepostID = Logic.GetPlayerEntities( 3, Entities.I_X_TradePostConstructionSite, 1, 0 )
    assert( TradepostID and TradepostID ~= 0 )
    Logic.TradePost_SetTradePartnerGenerateGoodsFlag(TradepostID, true)
    Logic.TradePost_SetTradePartnerPlayerID(TradepostID, 3)
    Logic.TradePost_SetTradeDefinition(TradepostID, 0, Goods.G_Herb, 9, Goods.G_Wool, 9)
    Logic.TradePost_SetTradeDefinition(TradepostID, 1, Goods.G_Carcass, 9, Goods.G_Milk, 9)
    Logic.TradePost_SetTradeDefinition(TradepostID, 2, Goods.G_Iron, 18, Goods.G_Salt, 5)
    Logic.TradePost_SetTradeDefinition(TradepostID, 3, Goods.G_Stone, 18, Goods.G_MusicalInstrument, 5)

    local _, TradepostID = Logic.GetPlayerEntities( 5, Entities.I_X_TradePostConstructionSite, 1, 0 )
    assert( TradepostID and TradepostID ~= 0 )
    Logic.TradePost_SetTradePartnerGenerateGoodsFlag(TradepostID, true)
    Logic.TradePost_SetTradePartnerPlayerID(TradepostID, 5)
    Logic.TradePost_SetTradeDefinition(TradepostID, 0, Goods.G_Wood, 9, Goods.G_Herb, 9)
    Logic.TradePost_SetTradeDefinition(TradepostID, 1, Goods.G_Grain, 9, Goods.G_Honeycomb, 9)
    Logic.TradePost_SetTradeDefinition(TradepostID, 2, Goods.G_Milk, 18, Goods.G_Dye, 5)
    Logic.TradePost_SetTradeDefinition(TradepostID, 3, Goods.G_Wool, 18, Goods.G_Olibanum, 5)

end

----------------------------------------------------------------------------------------------------------------------
function Mission_FirstMapAction()

    -- init players in singleplayer games only
    if Framework.IsNetworkGame() ~= true then

        Startup_Player()
        Startup_StartGoods()
        --Startup_Diplomacy()

		SetupPlayer(2, "H_NPC_Castellan_ME", "Narrilos", "CityColor4")  
		SetupPlayer(4, "H_NPC_Castellan_SE", "GranCastilla", "CityColor6")                  
		SetupPlayer(3, "H_NPC_Villager01_SE", "Harbor", "VillageColor1")
		SetupPlayer(5, "H_NPC_Monk_SE", "Monasterio", "CloisterColor1")        
		SetupPlayer(6, "H_NPC_Mercenary_SE", "Bandits1", "BanditsColor1")
		SetupPlayer(7, "H_NPC_Mercenary_SE", "Bandits1", "BanditsColor4")    
		SetupPlayer(8, "H_NPC_Mercenary_SE", "Bandits1", "BanditsColor3")

        SetKnightTitle(2, KnightTitles.Duke)
        SetKnightTitle(4, KnightTitles.Duke)

        --  Init AI's        
        AIPlayer:new(2, AIProfile_Skirmish, Entities.U_NPC_Castellan_ME)
        AIPlayer:new(4, AIProfile_Skirmish, Entities.U_NPC_Castellan_SE)

	    GenerateBribeCityQuestSP(2, 1)
        GenerateBribeCityQuestSP(4, 1)

        QuestTemplate:New("Quest_ExploreCities", 1, 1, 
                    { { Objective.KnightTitle, KnightTitles.Earl } },
                    { { Triggers.Time, 0 } }, 
                    0, 
                    nil,
                    nil, 
                    ExploreCities,
                    nil,
                    false,
                    false
                    )

        --Setting diplomacy doesn't work instantly, but after a dely
        QuestTemplate:New("Quest_SetCitiesNeutral", 1, 1, 
                    { { Objective.Dummy } },
                    { { Triggers.Time, 3 } }, 
                    0, 
                    nil,
                    nil, 
                    SetCitiesNeutral,
                    nil,
                    false,
                    false
                    )
    end        
	
    --MountOutposts()

    local castleId = assert(Logic.GetEntityIDByName("p1_castle"))
    Logic.HurtEntity(castleId, Logic.GetEntityHealth(castleId) - (Logic.GetEntityMaxHealth(castleId) * 0.25))

    local storehouseId = assert(Logic.GetEntityIDByName("p1_storehouse"))
    Logic.HurtEntity(storehouseId, Logic.GetEntityHealth(storehouseId) - (Logic.GetEntityMaxHealth(storehouseId) * 0.25))

    local cathedralId = assert(Logic.GetEntityIDByName("p1_cathedral"))
    Logic.HurtEntity(cathedralId, Logic.GetEntityHealth(cathedralId) - (Logic.GetEntityMaxHealth(cathedralId) * 0.25))
end

--Discover enemy cities without removing FOW
function ExploreCities()
    --By adding territories into internal DiscoveredTerritories table they count as discovered for triggers
    local x, y = Logic.GetEntityPosition(Logic.GetStoreHouse(2))
    table.insert(DiscoveredTerritories[1], Logic.GetTerritoryAtPosition(x,y))
    local x, y = Logic.GetEntityPosition(Logic.GetStoreHouse(4))
    table.insert(DiscoveredTerritories[1], Logic.GetTerritoryAtPosition(x,y))

    Logic.ExecuteInLuaLocalState("AddHiddenCitiesToPlayerDimplomacy()")
end

--Let enemy cities mount their outposts with archers
function MountOutposts()
    local p2troups, p2outposts = GetCityOutpostTroops(2)
    for i=1, #p2troups do
        local x, y = Logic.GetEntityPosition(p2troups[i])
        local territoryID = Logic.GetTerritoryAtPosition(x, y)
        for j=1, #p2outposts do
            local outpostID = p2outposts[j]
            x, y = Logic.GetEntityPosition(p2outposts[j])
            local outpostTerritoryID = Logic.GetTerritoryAtPosition(x, y)
            if outpostTerritoryID == territoryID then
                if Logic.IsLeader(p2troups[i]) == 1 then
                    AICore.HideEntityFromAI(2, p2troups[i], true) 
                    Logic.CommandEntityToMountBuilding(p2troups[i], p2outposts[j])
                end
            end
        end
    end
    
    local p4troups, p4outposts = GetCityOutpostTroops(4)
    for i=1, #p4troups do
        local x, y = Logic.GetEntityPosition(p4troups[i])
        local territoryID = Logic.GetTerritoryAtPosition(x, y)
        for j=1, #p4outposts do
            local outpostID = p4outposts[j]
            x, y = Logic.GetEntityPosition(p4outposts[j])
            local outpostTerritoryID = Logic.GetTerritoryAtPosition(x, y)
            if outpostTerritoryID == territoryID then
                if Logic.IsLeader(p4troups[i]) == 1 then
                    AICore.HideEntityFromAI(4, p4troups[i], true) 
                    Logic.CommandEntityToMountBuilding(p4troups[i], p4outposts[j])
                end
            end
        end
    end
end

function GetCityOutpostTroops(_playerId)
    local pxOutposts = { Logic.GetPlayerEntitiesInCategory(_playerId, EntityCategories.Outpost)}
    local pxOutpostsTerritories = { }
    for i = 1, #pxOutposts do
         local x, y = Logic.GetEntityPosition(pxOutposts[i])
         local territoryID = Logic.GetTerritoryAtPosition(x, y)
         pxOutpostsTerritories[i] = territoryID
    end

    local militaryUnits = { Logic.GetPlayerEntitiesInCategory(_playerId, EntityCategories.Military) }
    local targetUnits = {}
    local battalions = {}
    
    for j = 1, #pxOutpostsTerritories do
        local battalion = {}
        for i=1, #militaryUnits do
            local x, y = Logic.GetEntityPosition(militaryUnits[i])
            local territoryID = Logic.GetTerritoryAtPosition(x, y)
            if pxOutpostsTerritories[j] == territoryID then
                battalion[#battalion+1] = militaryUnits[i]
                targetUnits[#targetUnits+1] = militaryUnits[i]
            end
        end
        battalions[j] = battalion
    end
    return targetUnits, pxOutposts, battalions
end

--Change cities diplomacy state from enemy to undecided
function SetCitiesNeutral()
    SetDiplomacyState(1, 2, DiplomacyStates.Undecided)
    SetDiplomacyState(1, 4, DiplomacyStates.Undecided)
end

--Overwrite to change player color
do
	function PlayerChangePlayerColor2(_newColor)
		if _newColor > 0 then
			Logic.PlayerSetPlayerColor(1, 14, -1, -1)
			Logic.ExecuteInLuaLocalState("Display.UpdatePlayerColors()")
			Logic.ExecuteInLuaLocalState("GUI.RebuildMinimapTerrain()")
		end
	end
end