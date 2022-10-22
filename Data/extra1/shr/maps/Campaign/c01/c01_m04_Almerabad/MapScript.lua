CurrentMapIsCampaignMap = true

--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
function Mission_InitPlayers()

end


--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
function Mission_SetStartingMonth()

    Logic.SetMonthOffset(7)
	
end
--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
function Mission_InitMerchants()

    -- Parnai
    local PlayerID = 2
	local TraderID = Logic.GetStoreHouse(PlayerID)
	AddOffer( TraderID, 3, Goods.G_Iron )
	AddOffer( TraderID, 2, Goods.G_Milk )
	AddOffer( TraderID, 1, Goods.G_Cow )

    local _, TradepostID = Logic.GetPlayerEntities( PlayerID, Entities.I_X_TradePostConstructionSite, 1, 0 )
    assert( TradepostID and TradepostID ~= 0 )
    Logic.TradePost_SetTradePartnerGenerateGoodsFlag(TradepostID, true)
    Logic.TradePost_SetTradePartnerPlayerID(TradepostID, PlayerID)
    Logic.TradePost_SetTradeDefinition(TradepostID, 0, Goods.G_Wool, 9, Goods.G_Gems, 9)
    Logic.TradePost_SetTradeDefinition(TradepostID, 1, Goods.G_Grain, 9, Goods.G_Gems, 9)
    Logic.TradePost_SetTradeDefinition(TradepostID, 0, Goods.G_RawFish, 9, Goods.G_Iron, 9)
    Logic.TradePost_SetActiveTradeSlot(TradepostID, 0)
    
    -- Nandur
    local PlayerID = 3
	local TraderID = Logic.GetStoreHouse(PlayerID)
	AddOffer( TraderID, 3, Goods.G_Wood )
	AddOffer( TraderID, 3, Goods.G_Wool )
	AddOffer( TraderID, 1, Goods.G_Sheep )

    local _, TradepostID = Logic.GetPlayerEntities( PlayerID, Entities.I_X_TradePostConstructionSite, 1, 0 )
    assert( TradepostID and TradepostID ~= 0 )
    Logic.TradePost_SetTradePartnerGenerateGoodsFlag(TradepostID, true)
    Logic.TradePost_SetTradePartnerPlayerID(TradepostID, PlayerID)
    Logic.TradePost_SetTradeDefinition(TradepostID, 0, Goods.G_Milk, 9, Goods.G_Wool, 9)
    Logic.TradePost_SetTradeDefinition(TradepostID, 1, Goods.G_Carcass, 9, Goods.G_Gems, 9)
    Logic.TradePost_SetActiveTradeSlot(TradepostID, 0)
    

end
--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
function Mission_FirstMapAction()
    
    if Framework.IsNetworkGame() ~= true then

        Startup_Player()
        Startup_StartGoods()
        Startup_Diplomacy()
        
        -- CP: Changed player colors to be more consistent
        Logic.PlayerSetPlayerColor(4 , g_ColorIndex["VillageColor4"], -1, -1)  --Letztes Kloster: Hellblau
        Logic.PlayerSetPlayerColor(7 , g_ColorIndex["CityColor3"], -1, -1)   --Khana: Grün
    end    

    -- create quests
    do
        local MapName = Framework.GetCurrentMapName()
--        local ScriptName = "Maps\\Singleplayer\\"..MapName.."\\QuestSystemBehavior.lua"
        local ScriptName = "mapeditor\\QuestSystemBehavior.lua"
        Script.Load(ScriptName)
        -- Script was loaded
        assert( RegisterBehaviors )

        CreateQuests()
    end
    
    -- Emchi doesn't build the gem polisher before Q4 succeeds
	AICore.SetNumericalFact( 5, "BPMX", 0 )
    
    -- Hidden temple usable
    local ID = assert( Logic.GetEntityIDByName( "HiddenTemple" ) )
    Logic.InteractiveObjectSetInteractionDistance( ID, 1500 )
    Logic.InteractiveObjectClearCosts( ID )
    Logic.InteractiveObjectSetDeactivateAfterUse( ID, true )
    
    -- Saraya prison usable
    local ID = assert( Logic.GetEntityIDByName( "SarayaPrison" ) )
    Logic.InteractiveObjectSetInteractionDistance( ID, 1500 )
    Logic.InteractiveObjectClearCosts( ID )
    Logic.InteractiveObjectSetDeactivateAfterUse( ID, true )
    
    -- Prison cage can't be used
    local ID = assert(Logic.GetEntityIDByName("prisoncage"));
    Logic.InteractiveObjectSetPlayerState(ID, 1, 2);
    Logic.InteractiveObjectSetAvailability(ID, false);
    
    -- Rain until Q3    
    
    Logic.WeatherEventSetPrecipitationFalling(true)
    Logic.WeatherEventSetPrecipitationIsSnow(false)
    Logic.WeatherEventSetShallowWaterFloods(true)
    Logic.WeatherEventClearGoodTypesNotGrowing()
    Logic.WeatherEventAddGoodTypeNotGrowing(Goods.G_Grain)
    Logic.ActivateWeatherEvent()
--    Logic.ExecuteInLuaLocalState( "Display.WeatherOverride_SetRainSnowIce(true, false, false)" )
    
    -- Set up storehouses for prophecy
    for i = 1, 3 do
        Logic.AddGoodToStock( Logic.GetStoreHouse(i), Goods.G_Information, 0, true, true )
    end
    Logic.AddGoodToStock( Logic.GetStoreHouse(7), Goods.G_Information, 0, true, true )
    
    -- Add two prophecies to the players storehouse to compensate for the "random prophecy loss" thats occuring sometimes
    Logic.AddGoodToStock( Logic.GetStoreHouse(1), Goods.G_Information, 2, true )

    --Mission_VictoryCutscene()
end
--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
function Mission_SetDiplomacy()

	
end
--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
function Mission_SetupQuests()


end
--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

function Quest_EmptyParnaiWell()
    Logic.Extra1_BreakWell(assert(Logic.GetEntityIDByName("ParnaiWell")))
end

function Quest_EndRainingSeason()
    
    Logic.ExecuteInLuaLocalState("EndEventMonsoon()")
    
    Logic.DeactivateWeatherEvent()
--    Logic.ExecuteInLuaLocalState( "Display.WeatherOverride_Deactivate()" )
    
    -- Also re-enable the auto-refill (since the well has been repaired)
    Logic.Extra1_RepairWell(assert(Logic.GetEntityIDByName("ParnaiWell")))
end

function Quest_ActivateTravelingSalesman()
    ActivateTravelingSalesman(5,
        { 
            {1,
                {  
                    {Goods.G_RawFish, 4},
                    {Goods.G_Iron, 2},
                    {Goods.G_Olibanum, 3},
                }     
            },
            {5,     
                {  
                    {Goods.G_RawFish, 4},
                    {Goods.G_Iron, 2},
                    {Goods.G_Olibanum, 3},
                }     
            },
            {9,
                {  
                    {Goods.G_RawFish, 4},
                    {Goods.G_Iron, 2},
                    {Goods.G_Olibanum, 3},
                }     
            },
        } 
    )
end

function Quest_AddEmchiOffer1()
    --modify offer tables, add gems
    for Month, Offer in pairs( g_TravelingSalesman.MonthOfferTable ) do
        table.insert( Offer, {Goods.G_Gems, 1} )
    end
end

function Quest_AddEmchiOffer2()
    IncreaseEmchiOffer()
end

function Quest_AddEmchiOffer3()
    IncreaseEmchiOffer()
end

function IncreaseEmchiOffer()
    local _, GemBuildingID = Logic.GetPlayerEntities( 5, Entities.B_NPC_Jewelry, 1, 0 )
    assert( GemBuildingID and GemBuildingID ~= 0 )
    Logic.UpgradeBuilding(GemBuildingID, 2)

    --modify offer tables, increase gem amount by 1
    local bFound = false
    for Month, Offer in pairs( g_TravelingSalesman.MonthOfferTable ) do
        for _, GoodTable in ipairs( Offer ) do
            if GoodTable[1] == Goods.G_Gems then
                GoodTable[2] = GoodTable[2] + 1
                bFound = true
            end
        end
    end
    assert( bFound )
end

function Quest_MoveProphecyCartAfterSpawn()
    -- Set the (no longer existing) bandits to allied, so the ID can be reused for saraya
    SetDiplomacyState(1, 6, DiplomacyStates.Allied)
    SetDiplomacyState(2, 6, DiplomacyStates.Allied)
    SetDiplomacyState(3, 6, DiplomacyStates.Allied)
    SetDiplomacyState(4, 6, DiplomacyStates.Allied)
    SetDiplomacyState(5, 6, DiplomacyStates.Allied)
    SetDiplomacyState(7, 6, DiplomacyStates.Enemy)
    Logic.PlayerSetPlayerColor(6 , 6, -1, -1)
    
    PreventFullStoreHouse(1)
    Logic.HireMerchant(Logic.GetEntityIDByName("BanditCampProphecyCart"), 1, Goods.G_Information, 1, 1)
end

function Quest_SendProphecyBackToPlayer()
    -- TODO: Set scriptname, restart protect quest
    -- Hmm, no need to protect the cart if the enemy retreats :-)
    AICore.CancelAllAttacks()
    
    PreventFullStoreHouse(1)
    SendResourceMerchantToPlayer( Logic.GetStoreHouse(2), "G_Information", 1 )
end

function MapCallback_CartFreed(_OldEntityID, _OldEntityPlayerID, _NewEntityID, _NewEntityPlayerID)
    if Logic.IsEntityAlive( "BanditCampProphecyCart" ) and  _NewEntityID == Logic.GetEntityIDByName( "BanditCampProphecyCart" ) then
        g_ProphecyCartFreed = true
    end
end

function MapCallback_DeliverCartSpawned( _Quest, _CartID, _GoodType )

    if _Quest.Identifier == "Q_14_Namawili_SendProphecyToParnai" or _Quest.Identifier == "Q_18_Namawili_SendProphecyToNandur" then
        g_QuestCartSpawned = true
        g_ProphecyCartFreed = false
        
        -- HACK to replace the resource merchant with the namawili cart
        local PlayerID = Logic.EntityGetPlayer( _CartID )
        Logic.DestroyEntity( _CartID )
        _Quest.Objectives[1].Data[3] = Logic.CreateEntityAtBuilding(Entities.U_NPC_Resource_Monk_AS, Logic.GetStoreHouse(1), 0, PlayerID)
        Logic.HireMerchant(_Quest.Objectives[1].Data[3], PlayerID, _GoodType, 1, PlayerID)
        
        -- This one is needed so the protect quest focuses on this cart
        Logic.SetEntityName( _Quest.Objectives[1].Data[3], "BanditCampProphecyCart" )
    end

end

function Quest_CartNeedsProtection()
    if g_QuestCartSpawned then
        g_QuestCartSpawned = false
        return true
    end
end

function Quest_CheckCartFreed()
    if g_ProphecyCartFreed then
        g_ProphecyCartFreed = false
        return true
    end
end

function Quest_Almerabad_Parnai_Hostile()
    SetDiplomacyState(7, 2, DiplomacyStates.Enemy)
end

function Quest_Almerabad_Parnai_EstablishedContact()
    SetDiplomacyState(7, 2, DiplomacyStates.EstablishedContact)
end

function Quest_Almerabad_Nandur_Hostile()
    SetDiplomacyState(7, 3, DiplomacyStates.Enemy)
end

function Quest_Almerabad_Nandur_EstablishedContact()
    SetDiplomacyState(7, 3, DiplomacyStates.EstablishedContact)
end


--This check keeps important entities that must not die from drowning in the monsoon.
-- Player-controlled entities must never be checked, as he could then simply delay the monsoon forever,
-- or use it to drown attacking enemies
function MissionCallback_IsShallowWaterFloodingAllowed()
    if IsImportantEntityOnShallowWater() then
        StartSimpleJob( "CheckNoImportantEntityOnShallowWater" )
        return false
    end
    
    return true
end

function IsImportantEntityOnShallowWater()
    for _, Name in ipairs{"BanditCampProphecyCart", "SarayaDummy"} do
        if Logic.IsEntityAlive( Name ) then
            local X, Y = Logic.GetEntityPosition(GetEntityId(Name))
            if Logic.WaterIsPositionShallow(X, Y) then
                return true
            end
        end
    end
    
    return false
end

function CheckNoImportantEntityOnShallowWater()
    if not IsImportantEntityOnShallowWater() then
        Logic.SetShallowWaterFloodFlag(true)
        return true
    end
end

-- If the storehouse if full the prophecy will simply disappear. This must not happen.
function PreventFullStoreHouse( _PlayerID )
    if Logic.GetPlayerUnreservedStorehouseSpace(_PlayerID) == 0 then
        local ID = Logic.GetStoreHouse(_PlayerID)
        local NumberOfGoodTypes = assert( Logic.GetNumberOfGoodTypesOnOutStock(ID) )
        for i = 0, NumberOfGoodTypes-1 do        
            local GoodType = Logic.GetGoodTypeOnOutStockByIndex(ID,i)
            local Amount = Logic.GetAmountOnOutStockByIndex(ID, i)
            if Amount > 0 then
                Logic.RemoveGoodFromStock(ID, GoodType, 1, false)
                break
            end
        end
    end
    assert( Logic.GetPlayerUnreservedStorehouseSpace(_PlayerID) > 0 )
end

function Quest_DeactivateFlame1()
    Logic.EntitySwitchDecorationalEffect( assert( Logic.GetEntityIDByName( "KhanaTemple1" ) ), false )
end

function Quest_DeactivateFlame2()
    Logic.EntitySwitchDecorationalEffect( assert( Logic.GetEntityIDByName( "KhanaTemple2" ) ), false )
end

function Quest_MoveSaraya()
    g_SarayaWP = 1
    g_SarayaWaitTime = false
    StartSimpleJob( "MoveSarayaToCastle" )
end

function MoveSarayaToCastle()

    if Logic.IsEntityDestroyed( "SarayaDummy" ) then
        return true
    end

    local Waypoints = {
        {"TarungaGateKeeper", 2},
        {"SarayaWP1", 5},
        {"TroopSpawnInterceptCloisterCartDest", 10},
        {"LonpaiCastle", 2008},
    }
    
    local SarayaID = Logic.GetEntityIDByName( "SarayaDummy" )
    local WPEntry = assert(Waypoints[g_SarayaWP])
    
    if g_SarayaWaitTime then
        -- Currently waiting at a waypoint
        g_SarayaWaitTime = g_SarayaWaitTime + 1
        if g_SarayaWaitTime >= WPEntry[2] then
            g_SarayaWaitTime = false
            g_SarayaWP = g_SarayaWP + 1
            if not Waypoints[g_SarayaWP] then
                -- End of path
                return true
            end
        end
    
    else
        local WaypointID = assert(Logic.GetEntityIDByName(WPEntry[1]))
        if Logic.GetDistanceBetweenEntities( SarayaID, WaypointID ) < 500 then
            -- Arrived at a WP
            g_SarayaWaitTime = 1
            Logic.GroupDefend(SarayaID)

        elseif not Logic.IsEntityMoving( SarayaID ) then
            -- Probably blocked, or the waypoint pause ended
            Move( SarayaID, WaypointID )
            
        end
    end
    
    
end

function Quest_HuntSaraya()
    AIScript_SpawnAndAttackMovingUnit(7, assert(GetID("SarayaDummy")), assert(GetID("AlmerabadOutpostGate")), 3, 4, 3, false)        
end

function Quest_DeactivateMonsoon()
    Logic.WeatherEventClearGoodTypesNotGrowing()
    Logic.WeatherEventSetShallowWaterFloods(false)
    Logic.WeatherEventSetTemperature(23)
    Logic.WeatherEventSetPrecipitationFalling(false)
    Logic.ActivateWeatherEvent()
    Logic.ExecuteInLuaLocalState( "StartFakedSpring()" )
end

g_NamawiliPlayerID = 8
g_KhanaPlayerID = 7

function Mission_VictoryCutscene()

    local SarayaPlayerID = 6

    local v1   = Logic.GetEntityIDByName("v1")
    assert(v1)
    local v2  = Logic.GetEntityIDByName("v2")
    assert(v2)
   
    local KnightID       = Logic.GetKnightID(1)
    
    local SarayaID       = Logic.GetKnightID(SarayaPlayerID)
    
    if SarayaID == 0 then
        local X, Y = Logic.GetEntityPosition( Logic.GetKnightID(1) )

        Logic.CreateEntityOnUnblockedLand(Entities.U_KnightSaraya, X, Y, 0, SarayaPlayerID)
        
        SarayaID       = Logic.GetKnightID(6)
    end
    
    Logic.ExecuteInLuaLocalState("SetupPlayer(" .. SarayaPlayerID .. ", 'H_Knight_Saraya', 'Saraya', true)")
    
    local X, Y = Logic.GetEntityPosition(v1)
    local O = Logic.GetEntityOrientation(v1)
    
    KnightID = VictorySetEntityToPosition(KnightID, X, Y, O)
    
    X, Y = Logic.GetEntityPosition(v2)
    O    = Logic.GetEntityOrientation(v2)
    
    SarayaID = VictorySetEntityToPosition(SarayaID, X, Y, O)
  
    
    GenerateVictoryDialog(
        {
--            {g_NamawiliPlayerID, "Victory1_ProphecyCartDestroyed"}, 
            {SarayaPlayerID, "Victory2_SarayaRescued"},
            {g_NamawiliPlayerID, "Victory3_HidunPriest"},
            {1, "Victory4_Knight"}
        })
    
   Logic.ExecuteInLuaLocalState("Mission_LocalVictory()")
end


function Mission_DefeatCutscene_ProphecyLost()
    GenerateDefeatDialog( {{ g_KhanaPlayerID, "Defeat_ProphecyLost" }} )
end

function Mission_DefeatCutscene_SarayaNotFreed()
    GenerateDefeatDialog( {{ g_KhanaPlayerID, "Defeat_SarayaNotFreed" }} )
end

function Mission_DefeatCutscene_SarayaKilled()
    GenerateDefeatDialog( {{ g_KhanaPlayerID, "Defeat_SarayaKilled" }} )
end



