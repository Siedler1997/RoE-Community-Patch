
----------------------------------------------------------------------------------------------------------------------
function Mission_InitPlayers()
	AddResourcesToPlayer(Goods.G_Gold,250,1)
	AddResourcesToPlayer(Goods.G_Wood,30,1)
	AddResourcesToPlayer(Goods.G_Stone,20,1)
	AddResourcesToPlayer(Goods.G_Carcass,20,1)
	AddResourcesToPlayer(Goods.G_Grain,20,1)
	AddResourcesToPlayer(Goods.G_RawFish,20,1)   
end
----------------------------------------------------------------------------------------------------------------------
function Mission_SetStartingMonth()

    Logic.SetMonthOffset(3)

end
----------------------------------------------------------------------------------------------------------------------
function Mission_InitMerchants()

 --player2
    local PlayerID = 2
	local TraderID = Logic.GetStoreHouse(PlayerID)      
    AddOffer( TraderID, 1, Goods.G_Sheep)
    AddOffer( TraderID, 1, Goods.G_Cow)    
    AddOffer( TraderID, 5, Goods.G_SmokedFish)


 --player3
    local PlayerID = 3
	local TraderID = Logic.GetStoreHouse(PlayerID)      
    AddOffer( TraderID, 2, Goods.G_Herb)
    AddOffer( TraderID, 5, Goods.G_Stone)
    AddOffer( TraderID, 4, Goods.G_RawFish)
    AddMercenaryOffer( TraderID, 2, Entities.U_MilitaryBandit_Ranged_AS)

    
    -- P4
    local PlayerID = 4
	local TraderID = Logic.GetStoreHouse(PlayerID)
      
    AddOffer(TraderID, 3, Goods.G_Iron)
    AddOffer(TraderID, 4, Goods.G_Stone)
    AddOffer(TraderID, 5, Goods.G_Sausage)
    AddOffer(TraderID, 5, Goods.G_Medicine)

    local _, TradepostID = Logic.GetPlayerEntities( PlayerID, Entities.I_X_TradePostConstructionSite, 1, 0 )
    assert( TradepostID and TradepostID ~= 0 )
    Logic.TradePost_SetTradePartnerGenerateGoodsFlag(TradepostID, true)
    Logic.TradePost_SetTradePartnerPlayerID(TradepostID, PlayerID)
    Logic.TradePost_SetTradeDefinition(TradepostID, 0, Goods.G_Wood, 8, Goods.G_Dye, 2)
    Logic.TradePost_SetTradeDefinition(TradepostID, 1, Goods.G_Carcass, 8, Goods.G_MusicalInstrument, 2)
    Logic.TradePost_SetTradeDefinition(TradepostID, 2, Goods.G_Grain, 8, Goods.G_Salt, 2)
    Logic.TradePost_SetTradeDefinition(TradepostID, 3, Goods.G_Herb, 8, Goods.G_Olibanum, 2)
    Logic.TradePost_SetActiveTradeSlot(TradepostID, 0)

    
    
    
    
    --player5
    local PlayerID = 5
	local TraderID = Logic.GetStoreHouse(PlayerID)    
  
    AddOffer(TraderID, 4, Goods.G_Stone)
    AddOffer(TraderID, 5, Goods.G_Sausage)
    AddMercenaryOffer( TraderID, 2, Entities.U_MilitaryBandit_Ranged_AS)
    AddMercenaryOffer( TraderID, 2, Entities.U_MilitaryBandit_Melee_AS)

    local _, TradepostID = Logic.GetPlayerEntities( PlayerID, Entities.I_X_TradePostConstructionSite, 1, 0 )
    assert( TradepostID and TradepostID ~= 0 )
    Logic.TradePost_SetTradePartnerGenerateGoodsFlag(TradepostID, true)
    Logic.TradePost_SetTradePartnerPlayerID(TradepostID, PlayerID)
    Logic.TradePost_SetTradeDefinition(TradepostID, 0, Goods.G_Carcass, 5, Goods.G_Herb, 4)
    Logic.TradePost_SetTradeDefinition(TradepostID, 1, Goods.G_RawFish, 5, Goods.G_Stone, 3)
    Logic.TradePost_SetTradeDefinition(TradepostID, 2, Goods.G_Grain, 8, Goods.G_MusicalInstrument, 2)
    Logic.TradePost_SetTradeDefinition(TradepostID, 3, Goods.G_Iron, 8, Goods.G_Salt, 2)
    Logic.TradePost_SetActiveTradeSlot(TradepostID, 0)

    --player6
    local PlayerID = 6
	local TraderID = Logic.GetStoreHouse(PlayerID)      

    AddOffer(TraderID, 4, Goods.G_Iron)
    AddOffer(TraderID, 5, Goods.G_SmokedFish)
    AddMercenaryOffer( TraderID, 2, Entities.U_MilitaryBandit_Ranged_AS)
    AddMercenaryOffer( TraderID, 2, Entities.U_MilitaryBandit_Melee_AS)       

    local _, TradepostID = Logic.GetPlayerEntities( PlayerID, Entities.I_X_TradePostConstructionSite, 1, 0 )
    assert( TradepostID and TradepostID ~= 0 )
    Logic.TradePost_SetTradePartnerGenerateGoodsFlag(TradepostID, true)
    Logic.TradePost_SetTradePartnerPlayerID(TradepostID, PlayerID)
    Logic.TradePost_SetTradeDefinition(TradepostID, 0, Goods.G_Wood, 2, Goods.G_Herb, 3)
    Logic.TradePost_SetTradeDefinition(TradepostID, 1, Goods.G_Stone, 3, Goods.G_Iron, 2)
    Logic.TradePost_SetTradeDefinition(TradepostID, 2, Goods.G_Grain, 8, Goods.G_Gems, 2)
    Logic.TradePost_SetTradeDefinition(TradepostID, 3, Goods.G_Iron, 8, Goods.G_Dye, 2)    
    Logic.TradePost_SetActiveTradeSlot(TradepostID, 0) 
 
    
    --player8
    local PlayerID = 8
	local TraderID = Logic.GetStoreHouse(PlayerID)      
    AddMercenaryOffer( TraderID, 2, Entities.U_MilitaryBandit_Ranged_AS)
    AddMercenaryOffer( TraderID, 2, Entities.U_MilitaryBandit_Melee_AS)       
    
    --player7
    --[[
    local PlayerID = 7
	local TraderID = Logic.GetStoreHouse(PlayerID)        
    AddMercenaryOffer( PlayerID, 3, Entities.U_MilitaryBandit_Melee_ME)       
]]
    
	    
end


function block_io()
--[[
    local stone_mine_ID = Logic.GetEntityIDByName("IO_Rockfall")
    Logic.InteractiveObjectSetPlayerState( stone_mine_ID, 1, 2 )
    Logic.InteractiveObjectSetAvailability( stone_mine_ID, false )    
    ]]
end

function unlock_io()
--[[
    local IO_ID = Logic.GetEntityIDByName("IO_Rockfall")
    Logic.InteractiveObjectSetPlayerState( IO_ID, 1, 0 )
    Logic.InteractiveObjectSetAvailability( IO_ID, false )  
    ]]
end

function GameCallback_AIWallBuildingOrder(_PlayerID)
    if _PlayerID == 3 then
        return 5
    end
end


function start_ceremony_Q02()
    Logic.DEBUG_ActivateSermon(1)
end

function start_festiwal_Q03()
    local FestivalIndex = 0
    AddResourcesToPlayer(Goods.G_Gold, 1, 1)
    Logic.StartFestival( 1 ,FestivalIndex )
end


function change_bulding_Order_Q10()

end


function build_temple1()
    local Name = "KhanaTemple_Ghangasar"
    local ID = assert( Logic.GetEntityIDByName(Name) )
    local Orientation = Logic.GetEntityOrientation( ID )
    local X, Y = Logic.GetEntityPosition( ID )
    local PlayerID = Logic.EntityGetPlayer( ID )
    Logic.DestroyEntity( ID )
    ID = Logic.CreateEntity( Entities.B_KhanaTemple, X, Y, Orientation, PlayerID )
    Logic.SetEntityName( ID, Name )
end

function build_temple2()
    local Name = "KhanaTemple_Bengasar"
    local ID = assert( Logic.GetEntityIDByName(Name) )
    local Orientation = Logic.GetEntityOrientation( ID )
    local X, Y = Logic.GetEntityPosition( ID )
    local PlayerID = Logic.EntityGetPlayer( ID )
    Logic.DestroyEntity( ID )
    ID = Logic.CreateEntity( Entities.B_KhanaTemple, X, Y, Orientation, PlayerID )
    Logic.SetEntityName( ID, Name )
end


function spawn_cart_Q21()
    SendMarketerToPlayer(Logic.GetStoreHouse(2), Goods.G_Clothes, 1)
    SendMarketerToPlayer(Logic.GetStoreHouse(2), Goods.G_Soap, 1)    
    SendResourceMerchantToPlayer(Logic.GetStoreHouse(2), Goods.G_Carcass, 1)    
end

function change_P6soldiersToP1()
    for _, ID in ipairs{ Logic.GetEntitiesOfCategoryInTerritory( 1, 6, EntityCategories.Leader, 0 )} do
        local NewID = Logic.ChangeEntityPlayerID( ID, 1 )
        Move( NewID, Logic.GetMarketplace(1) )
    end  
end

function change_P5soldiersToP1()
    for _, ID in ipairs{ Logic.GetEntitiesOfCategoryInTerritory( 1, 5, EntityCategories.Leader, 0 )} do
        local NewID = Logic.ChangeEntityPlayerID( ID, 1 )
        Move( NewID, Logic.GetMarketplace(1) )
    end  
end


function change_AllP1BuildingsToP2()
    for _, TerritoryID in ipairs{ 6,8,9 } do
        for _, ID in ipairs{ Logic.GetEntitiesOfCategoryInTerritory( TerritoryID, 1, EntityCategories.AttackableBuilding, 0 )} do
            local NewID = Logic.ChangeEntityPlayerID( ID, 2 )
        end
        Logic.SetTerritoryPlayerID( TerritoryID, 2 )        
    end
end

function remove_RockBarrier_after_victory()
    local _, ID = Logic.GetEntities( Entities.D_AS_RockBarrier_Final, 1 )
    if ID then
        Logic.DestroyEntity( ID )
    end
end


function count_territories()
    local count_t
    count_t = 0
    for i = 1 , 22 do
        if Logic.GetTerritoryPlayerID(i) == 1 then
        count_t = count_t + 1
        end
    end   
    
    MissionCounter.CurrentAmount = count_t -1
    
    if count_t > 2 then 
        MissionCounter.CurrentAmount = 4
            return true            
        end
end


function empty_Umardoli_Well()
    local well_ID = Logic.GetEntityIDByName("Well_Umardoli")
    Logic.Extra1_BreakWell(assert(well_ID))
end

function empty_iron_mine()
    Logic.Extra1_SetResourceAmount(assert(Logic.GetEntityIDByName("IronMine_Rajapatna")),0)       
end

function Quest_DestroyVillages()
    -- Do nothing, this is succeeded by another quest
end

function Quest_DestroyVillages_Icon()
    return "QuestTypes.DestroyPlayers"
end

----------------------------------------------------------------------------------------------------------------------
function Mission_FirstMapAction()
    -- init players in singleplayer games only
    if Framework.IsNetworkGame() ~= true then

        Startup_Player()
        Startup_StartGoods()
        Startup_Diplomacy()
        
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
    
    AICore.CreateAIPlayer( 3 )
    AICore.CreateAIPlayer( 4 )
    AICore.CreateAIPlayer( 5 )
    AICore.CreateAIPlayer( 6 )
    AICore.SetNumericalFact( 3, "BPMX", 0 )
    
    AICore.SetNumericalFact( 5, "FMSM", 5 )
    AICore.SetNumericalFact( 5, "FMBM", 5 )
    AICore.SetNumericalFact( 5, "FMCA", 5 )

    AICore.SetNumericalFact( 6, "FMSM", 5 )
    AICore.SetNumericalFact( 6, "FMBM", 5 )
    AICore.SetNumericalFact( 6, "FMCA", 5 )    
    --StartMissionEntityCounter(Entities.B_Outpost_SE, 3)
end


function damage_outpost()
    --special_outpost1 / special_outpost2
    -- Damage outpost, so its more easy to capture it
    local OutpostID = assert(Logic.GetEntityIDByName("special_outpost1"))
    Logic.HurtEntity( OutpostID, Logic.GetEntityMaxHealth(OutpostID) * 0.19 )
    StartSimpleJob( "KeepOutpostHealthLow1" )

    local OutpostID2 = assert(Logic.GetEntityIDByName("special_outpost2"))
    Logic.HurtEntity( OutpostID2, Logic.GetEntityMaxHealth(OutpostID2) * 0.19 )
    StartSimpleJob( "KeepOutpostHealthLow2" )    
end

--keep1
function KeepOutpostHealthLow1()
    if Logic.IsEntityDestroyed("special_outpost1") then
        return true
    end
    local OutpostID = assert(Logic.GetEntityIDByName("special_outpost1"))
    
    if Logic.EntityGetPlayer( OutpostID ) ~= 2 then
        return true
    end
    
    if Logic.GetEntityHealth( OutpostID ) > Logic.GetEntityMaxHealth(OutpostID) * 0.81 then
        Logic.HurtEntity( OutpostID, Logic.GetEntityHealth( OutpostID ) - (Logic.GetEntityMaxHealth(OutpostID) * 0.81) )
    end
end

--keep2
function KeepOutpostHealthLow2()
    if Logic.IsEntityDestroyed("special_outpost2") then
        return true
    end
    local OutpostID = assert(Logic.GetEntityIDByName("special_outpost2"))    
    if Logic.EntityGetPlayer( OutpostID ) ~= 2 then
        return true
    end   
    if Logic.GetEntityHealth( OutpostID ) > Logic.GetEntityMaxHealth(OutpostID) * 0.81 then
        Logic.HurtEntity( OutpostID, Logic.GetEntityHealth( OutpostID ) - (Logic.GetEntityMaxHealth(OutpostID) * 0.81) )
    end
end

function Quest_KillUnusedTroops()
    for _, Type in ipairs{ Entities.U_AmmunitionCart, Entities.U_CatapultCart, Entities.U_SiegeEngineCart} do
        for _, ID in ipairs( GetPlayerEntities( 6, Type ) ) do
            px,py = Logic.GetEntityPosition(ID )
            Logic.CreateEffect(EGL_Effects.FXCrushBuildingFloor, px,py,6)
            Logic.DestroyEntity( ID )
        end
    end
    for _, Type in ipairs{ Entities.U_AmmunitionCart, Entities.U_CatapultCart, Entities.U_SiegeEngineCart} do
        for _, ID in ipairs( GetPlayerEntities( 5, Type ) ) do
            px,py = Logic.GetEntityPosition(ID )
            Logic.CreateEffect(EGL_Effects.FXCrushBuildingFloor, px,py,6)
            Logic.DestroyEntity( ID )
        end
    end    
end

function Quest_KillUnusedMillitary()
    for _, Type in ipairs{Entities.U_MilitaryBow, Entities.U_MilitarySword} do
        local Units = GetPlayerEntities( 5, Type )
        if #Units > 4 then
            for i = 5, #Units do
                local ID = assert(Units[i])
                px,py = Logic.GetEntityPosition(ID )
                Logic.CreateEffect(EGL_Effects.FXCrushBuildingFloor, px,py,6)
                Logic.DestroyEntity( ID )
            end
        end
    end
    for _, Type in ipairs{Entities.U_MilitaryBow, Entities.U_MilitarySword} do
        local Units = GetPlayerEntities( 6, Type )
        if #Units > 4 then
            for i = 5, #Units do
                local ID = assert(Units[i])
                px,py = Logic.GetEntityPosition(ID )
                Logic.CreateEffect(EGL_Effects.FXCrushBuildingFloor, px,py,6)
                Logic.DestroyEntity( ID )
            end
        end
    end
   
end


function DoesPlayerHaveMilitaryUnits(_PlayerID)
    local Units  = { Logic.GetPlayerEntitiesInCategory(_PlayerID, EntityCategories.Military) }
    
    local PrunedUnits = {}
    
    for i = 1, #Units do
        local EntityID = Units[i]
        if Logic.IsEntityInCategory(EntityID, EntityCategories.Soldier) == 0 then
    
            return true
        end
    end
    
    return false
end

function CheckP6Units()
    return not DoesPlayerHaveMilitaryUnits(6)
end

function ModifyQ33aDestroyQuest()
    -- HACK to update the destroy quest with all remaining soldiers
    local QuestID = assert(g_QuestNameToID["Q33a_Bengasar_DestroySoldiers"])
    local Quest = assert(Quests[QuestID])
    local Goal = assert(Quest.Objectives[1])
    assert(Goal.Type == Objective.DestroyEntities)
    local Data = assert(Goal.Data)
    assert(Data[1] == 1)
    assert(type(Data[2]) == "table")
    assert(Data[2][0])

    local Units = { Logic.GetPlayerEntitiesInCategory(6, EntityCategories.Leader) }
    if not g_NoNeedToDestroyP5 then
        for _, ID in ipairs{ Logic.GetPlayerEntitiesInCategory(5, EntityCategories.Leader) } do
            table.insert( Units, ID )
        end
    end
    
    for i = 1, Data[2][0] do
        Data[2][i] = nil
    end
    
    for i, ID in ipairs( Units ) do
        Data[2][i] = ID
    end
    Data[2][0] = #Units
end


function Quest_CheckRockfallActivation()
    StartSimpleHiResJob("SpawnEffectWhenRockBarrierIsCreated")
end

function SpawnEffectWhenRockBarrierIsCreated()

    local RockBarrierID = Logic.GetEntityIDByName("IO_Rockfall")
    
    if RockBarrierID == nil or RockBarrierID == 0 then
        return true
    end    
    
    if g_RockBarrierEffect == nil then
    
        local EntityType = Logic.GetEntityType(RockBarrierID)
        
        if EntityType == Entities.D_AS_RockBarrier_Final then
            
            Logic.SetVisible(RockBarrierID, false)
            
            local X, Y = Logic.GetEntityPosition(RockBarrierID)
            local O    = Logic.GetEntityOrientation(RockBarrierID)
            
            g_RockBarrierEffect = Logic.CreateEffectWithOrientation(
                EGL_Effects.E_AS_RockBarrier_Anim, 
                X, Y, O * math.pi / 180,
                0)
        end                
        
    elseif g_RockBarrierEffect and Logic.IsEffectRegistered(g_RockBarrierEffect) == false then
        
        g_RockBarrierEffect = nil
        Logic.SetVisible(RockBarrierID, true)
        
        return true
    end
    
end

function Quest_DefendPlayer_Icon()
     return "QuestTypes.Protect"
end

function Quest_DefendPlayer()
    -- No change
end

function Quest_NoNeedToDestroyP5()
    g_NoNeedToDestroyP5 = true
end
