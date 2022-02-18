CurrentMapIsCampaignMap = true

--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
function Mission_InitPlayers()

end


--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
function Mission_SetStartingMonth()

    Logic.SetMonthOffset(3)
	
end
--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
function Mission_InitMerchants()

    -- Jambai
    local PlayerID = 4
	local TraderID = Logic.GetStoreHouse(PlayerID)
	g_JambaiWoodOffer = AddOffer( TraderID, 3, Goods.G_Wood )

    local _, TradepostID = Logic.GetPlayerEntities( PlayerID, Entities.I_X_TradePostConstructionSite, 1, 0 )
    assert( TradepostID and TradepostID ~= 0 )
    Logic.TradePost_SetTradePartnerGenerateGoodsFlag(TradepostID, true)
    Logic.TradePost_SetTradePartnerPlayerID(TradepostID, PlayerID)
    Logic.TradePost_SetTradeDefinition(TradepostID, 0, Goods.G_RawFish, 9, Goods.G_Stone, 32)
    Logic.TradePost_SetTradeDefinition(TradepostID, 1, Goods.G_Wool, 9, Goods.G_Stone, 32)
    Logic.TradePost_SetTradeDefinition(TradepostID, 2, Goods.G_Milk, 9, Goods.G_Stone, 32)
    --Logic.TradePost_SetTradeDefinition(TradepostID, 3, Goods.G_Gold, 2.95, Goods.G_Ringtones, 3)
    Logic.TradePost_SetActiveTradeSlot(TradepostID, 0)
    
end
--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
function Mission_FirstMapAction()
    
    if Framework.IsNetworkGame() ~= true then

        Startup_Player()
        Startup_StartGoods()
        Startup_Diplomacy()
        
        -- CP: Changed player colors to be more consistent
        Logic.PlayerSetPlayerColor(2 , 3, -1, -1)
        Logic.PlayerSetPlayerColor(3 , 7, -1, -1)
        Logic.PlayerSetPlayerColor(7 , 12, -1, -1)
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
    
    -- Jambai doesn't build grain farms before Q5 succeeds
	AICore.SetNumericalFact( 4, "BPMX", 0 )
	-- TODO: Check if "don't rebuild" conflicts with Q5
    AICore.SetNumericalFact( 4, "BARB", 0 )
    
    LockFeaturesForPlayer( 1, Technologies.R_Pallisade )

    g_ChosenKnightType = Logic.GetEntityType( Logic.GetKnightID(1) )
    local ReinforcementKnight = g_ChosenKnightType == Entities.U_KnightSaraya and Entities.U_KnightChivalry or Entities.U_KnightSaraya
    
    DoNotStartAIForPlayer(7)
    local KnightTypeName = Logic.GetEntityTypeName(ReinforcementKnight)
    Logic.ExecuteInLuaLocalState( string.format([===[
        SetupPlayer(7, assert(GetKnightActor(%d)), "Temp", "CityColor4")
        local KnightName = XGUIEng.GetStringTableText("UI_ObjectNames/%s")
        GUI.SetPlayerName(7, KnightName )
    ]===], ReinforcementKnight, KnightTypeName) )
    
    for _, Player in ipairs{ 2, 5, 6 } do
        Logic.AddGoodToStock( Logic.GetStoreHouse(Player), Goods.G_Information, 0, true, true )
    end

    -- Remove grain fields (built later on)
    g_GrainFields = {}
    for _, ID in ipairs{ Logic.GetEntitiesOfCategoryInTerritory( 4, 4, EntityCategories.GrainField, 0 ) } do
        local Orientation = Logic.GetEntityOrientation( ID )
        local X, Y = Logic.GetEntityPosition( ID )
        table.insert( g_GrainFields, { Orientation = Orientation, X = X, Y = Y } )
        Logic.DestroyEntity(ID)
    end
    
    MakeInvulnerable( Logic.GetStoreHouse(3) )
    
    --Mission_VictoryCutscene()
end
--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
function Mission_SetDiplomacy()

	
end
--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
function Mission_SetupQuests()


end
--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

function GameCallback_AIWallBuildingOrder(_PlayerID)
    if _PlayerID == 4 then
        return 10
    end
end

function Quest_AttackTradePostAndWoodcutter()
    local EntityID = Logic.GetEntitiesOfCategoryInTerritory( 4, 1, EntityCategories.AttackableBuilding , 0 )
    local SpawnID = Logic.GetEntityIDByName( "spawnpoint_amesthan" )
    AIScript_SpawnAndAttackCity( 2, EntityID, SpawnID, 6, 2, 2, 0, 0, 2, 3, false )
    
    AIScript_SpawnAndAttackCity( 2, Logic.GetEntityIDByName("P4Woodcutter"), SpawnID, 6, 1, 0, 0, 0, 0, 3, false )
end

function Quest_ReactivatePalisade()
    UnLockFeaturesForPlayer( 1, Technologies.R_Pallisade )
end

function MapCallback_DeliverCartSpawned( _Quest, _CartID, _GoodType )

    if _Quest.Identifier == "Q_19_cKnight_SendHelpMessagesToHarbor" then
        g_QuestCartSpawned = true
    end

end

function Quest_CheckQuestCartSpawned()
    if g_QuestCartSpawned then
        g_QuestCartSpawned = false
        return true
    end
end

function Quest_ActivateTravellingSalesman()
    --Assambai
    ActivateTravelingSalesman(5,
    { 
        {1,
            {  
                {Goods.G_Gems, 4},
                {Goods.G_Salt, 4},
                {Entities.U_MilitaryBandit_Melee_AS, 3},
            }     
        },
        {4,     
            {  
                {Goods.G_Gems, 3},
                {Goods.G_Salt, 3},
                {Entities.U_MilitaryBandit_Melee_AS, 3},
            }     
        },
        {7,
            {  
                {Goods.G_Gems, 3},
                {Goods.G_Salt, 3},
                {Entities.U_MilitaryBandit_Ranged_AS, 3},
            }     
        },
    })
end

function Quest_CampBihuratAttackPlayer()
    local PlayerHQ = Logic.GetHeadquarters(1)
    local PraphatID = 3
    local Spawn = assert( Logic.GetEntityIDByName( "spawnpoint_bihurat" ) )
    
    -- Check Wall
    local ID1 = Logic.GetHeadquarters(1)
    local ID2 = Spawn
    local Sector1 = Logic.GetPlayerSectorAtPosition( PraphatID, Logic.GetBuildingApproachPosition( ID1 ) )
    local Sector2 = Logic.GetPlayerSectorAtPosition( PraphatID, Logic.GetBuildingApproachPosition( ID2 ) )
    local HasWall = Sector1 ~= Sector2
    g_HadWall = g_HadWall or HasWall
    
    
    local NumPlayerSoldiers = Logic.GetCurrentSoldierCount(1) / 6
    local NumSword, NumBow, NumTower, NumRam, NumCatapult
    if NumPlayerSoldiers < 5 then
        NumSword    = 1
        NumBow      = 1
        NumTower    = Logic.GetRandom(2) == 0 and 1 or 0
        NumRam      = 1
        NumCatapult = Logic.GetRandom(3) == 0 and 1 or 0
    elseif NumPlayerSoldiers <= 8 then
        NumSword    = 2
        NumBow      = 3
        NumTower    = Logic.GetRandom(2) == 0 and 1 or 0
        NumRam      = 1
        NumCatapult = Logic.GetRandom(2) == 0 and 1 or 0
    else
        NumSword    = 4
        NumBow      = 4
        NumTower    = 1
        NumRam      = 1
        NumCatapult = 2
    end

    
    if HasWall then
        --Wall, focus on destroying wall/castle, but also attack the settlement a bit
        AIScript_SpawnAndAttackCity( PraphatID, PlayerHQ, Spawn, NumSword, NumBow, NumCatapult, NumTower, NumRam, NumCatapult > 0 and 1 or 0, false, true )
    else
        -- No wall, focus on destroying regular buildings, but also attack his castle a bit
        AIScript_SpawnAndRaidSettlement( PraphatID, PlayerHQ, Spawn, 15000, NumSword - 1, NumBow, false, true )
        if g_HadWall then
            AIScript_SpawnAndAttackCity( PraphatID, PlayerHQ, Spawn, 1, 0, NumCatapult, 0, 0, 0, false, true )
        end
    end

end

function Quest_IncreaseHarborOffer()
    --modify offer tables, add iron
    for Month, Offer in pairs( g_TravelingSalesman.MonthOfferTable ) do
        table.insert( Offer, {Goods.G_Iron, 4} )
    end
    
    --modify offer tables, increase merc amount to 5
    local bFound = false
    for Month, Offer in pairs( g_TravelingSalesman.MonthOfferTable ) do
        for _, GoodTable in ipairs( Offer ) do
            if GoodTable[1] == Entities.U_MilitaryBandit_Melee_AS or GoodTable[1] == Entities.U_MilitaryBandit_Ranged_AS then
                GoodTable[2] = 5
                bFound = true
            end
        end
    end
    assert( bFound )
end

function Quest_RemoveJambaiWoodOffer()
    local PlayerID = 4
    Logic.RemoveOffer( Logic.GetStoreHouse(PlayerID), 0, g_JambaiWoodOffer )
    -- Hack to force a menu update
    Logic.ExecuteInLuaLocalState("GameCallback_CloseNPCInteraction(1, Logic.GetStoreHouse("..PlayerID.."))")
end

function Quest_AddJambaiWoodOffer()
    local PlayerID = 4
	AddOffer( Logic.GetStoreHouse(PlayerID), 3, Goods.G_Wood )
    -- Hack to force a menu update
    Logic.ExecuteInLuaLocalState("GameCallback_CloseNPCInteraction(1, Logic.GetStoreHouse("..PlayerID.."))")
end

function Quest_JambaiVillage_ActivateRebuild()
    AICore.SetNumericalFact( 4, "BARB", 1 )
end

function Quest_CheckNoShipInHarbor()
    local Amount = Logic.GetPlayerEntities( 5, Entities.D_X_TradeShip, 1, 0 )
    if not Amount or Amount == 0 then
        return true
    end
end

function Quest_TrebuchetFire()
    local AllTrebuchets = GetPlayerEntities(3, Entities.U_Trebuchet)
    if (#AllTrebuchets <= 0) then
        return
    end
    
    local Targets = { Logic.GetPlayerEntitiesInCategory( 1, EntityCategories.OuterRimBuilding ) }
    if #Targets == 0 then
        if Logic.GetRandom(2) == 0 then
            Targets = { Logic.GetPlayerEntitiesInCategory( 1, EntityCategories.Wall ) }
        else
            Targets = { Logic.GetPlayerEntitiesInCategory( 1, EntityCategories.CityBuilding ) }
        end
        if Targets[1] == 0 then
            Targets = { Logic.GetPlayerEntitiesInCategory( 1, EntityCategories.Wall ) }
        end
        if Targets[1] == 0 then
            Targets = { Logic.GetPlayerEntitiesInCategory( 1, EntityCategories.CityBuilding ) }
        end
    end
    
    -- attack if we have some targets
    if (#Targets > 0) then
        for _, ID in ipairs(AllTrebuchets) do
            local AttackBuilding = Targets[Logic.GetRandom(#Targets) + 1]
            Logic.RefillAmmunitions(ID)                 
            Logic.GroupAttack(ID, AttackBuilding)
        end
    
        g_HaltCount = 0
        StartSimpleJob( "HaltTrebuchet" )
    end                
end

function HaltTrebuchet()
    g_HaltCount = g_HaltCount + 1
    if g_HaltCount > 5 then
        local AllTrebuchets = GetPlayerEntities(3, Entities.U_Trebuchet)
        for _, ID in ipairs(AllTrebuchets) do
            Logic.GroupDefend(ID)
        end
        
        return true
    end
end

function Quest_SendHelpMsgCartToHarbor()
    g_HelpMsgDelivered = nil
    local Delivery = DeliveryTemplate:new()
    Delivery:Initialize( Goods.G_Information, 1, 1, 5, function() g_HelpMsgDelivered = true end, function() g_HelpMsgDelivered = false end, false, true )
end

function Quest_CheckHelpMsgCartArrival()
    local Result = g_HelpMsgDelivered
    g_HelpMsgDelivered = nil
    return Result
end

function Quest_RespawnTigerIfNeeded()
    local ID = Logic.GetEntityIDByName( "TigerSpawn" )
    if Logic.RespawnResourceGetCurrentAmount( ID ) == 0 then
        Logic.RespawnResourceEntity_Spawn( ID )
    end
    
    local TigerID = Logic.GetSpawnedEntities( ID )
    assert( TigerID and TigerID > 0 )
    
    -- (Make the destroy quest target the right tiger (replace dummy with real tiger)
    local DummyID = Logic.GetEntityIDByName( "SpawnedTiger" )
    assert( DummyID )
    Logic.DestroyEntity( DummyID )

    Logic.SetEntityName( TigerID, "SpawnedTiger" )    
end

function Quest_DestroyCart1()
    local ID = assert( Logic.GetEntityIDByName( "SpawnCart1" ) )
    Logic.HurtEntity( ID, Logic.GetEntityHealth( ID ) )
end

function Quest_DestroyCart2()
    local ID = assert( Logic.GetEntityIDByName( "SpawnCart2" ) )
    Logic.HurtEntity( ID, Logic.GetEntityHealth( ID ) )
end

function Quest_DestroyCart3()
    local ID = assert( Logic.GetEntityIDByName( "SpawnCart3" ) )
    Logic.HurtEntity( ID, Logic.GetEntityHealth( ID ) )
end

function Quest_IsKnightSaraya()
    return g_ChosenKnightType == Entities.U_KnightSaraya
end

function SendAllRemainingUnitsToAttackPlayer( _AIPlayerID, _ArmyID )

    local ArmyID = _ArmyID or AICore.CreateArmy(_AIPlayerID)
    
    AICore.AddSwordsmenToArmy( _AIPlayerID, ArmyID, 0, 99, 0 )
    AICore.AddBowmenToArmy( _AIPlayerID, ArmyID, 0, 99, 0 )
    AICore.AddTowerToArmy( _AIPlayerID, ArmyID, 0, 99, 0 )
    AICore.AddRamToArmy( _AIPlayerID, ArmyID, 0, 99, 0 )
    AICore.AddCatapultToArmy( _AIPlayerID, ArmyID, 0, 99, 0 )
    
    AICore.StartAttackWithPlanDestroyHomebase(_AIPlayerID, ArmyID, Logic.GetStoreHouse(1))
    
    return ArmyID
end

g_FinalAttackArmiesDestroyed = {}
function Quest_BihuratFinalAttackOnPlayer()
    g_BihuratFinalAttackOnPlayerArmyID = AIScript_SpawnAndCreateArmy( 3, Logic.GetEntityIDByName("spawnpoint_bihurat"), 5, 3, 0, 0, 1, 0 )
    SendAllRemainingUnitsToAttackPlayer(3, g_BihuratFinalAttackOnPlayerArmyID)
end

function Quest_KhanaFinalAttack()
    g_KhanaFinalAttackOnPlayerArmyID = AIScript_SpawnAndCreateArmy( 2, Logic.GetEntityIDByName("spawnpoint_amesthan"), 6, 6, 3, 1, 2, 3, 3 )
    g_KhanaFinalAttackOnPlayerArmyID2 = AIScript_SpawnAndCreateArmy( 2, Logic.GetEntityIDByName("spawnpoint_amesthan"), 4, 3, 0, 0, 0, 0, 3 )
    SendAllRemainingUnitsToAttackPlayer(2, g_KhanaFinalAttackOnPlayerArmyID2)
    g_KhanaFinalAttackOnVillageArmyID = AIScript_SpawnAndAttackCity( 2, Logic.GetStoreHouse(4), Logic.GetEntityIDByName("spawnpoint_amesthan"), 3, 3, 0, 0, 1, 0, 3 )
end

function Mission_Callback_AIOnArmyDisbanded(_PlayerID, _ArmyID)
    if _PlayerID == 3 and g_BihuratFinalAttackOnPlayerArmyID and _ArmyID == g_BihuratFinalAttackOnPlayerArmyID then
        g_FinalAttackArmiesDestroyed[g_BihuratFinalAttackOnPlayerArmyID] = true
        
    elseif _PlayerID == 2 and g_KhanaFinalAttackOnPlayerArmyID and _ArmyID == g_KhanaFinalAttackOnPlayerArmyID then
        g_FinalAttackArmiesDestroyed[g_KhanaFinalAttackOnPlayerArmyID] = true
        
    elseif _PlayerID == 2 and g_KhanaFinalAttackOnPlayerArmyID2 and _ArmyID == g_KhanaFinalAttackOnPlayerArmyID2 then
        g_FinalAttackArmiesDestroyed[g_KhanaFinalAttackOnPlayerArmyID2] = true
        
    elseif _PlayerID == 2 and g_KhanaFinalAttackOnVillageArmyID and _ArmyID == g_KhanaFinalAttackOnVillageArmyID then
        g_FinalAttackArmiesDestroyed[g_KhanaFinalAttackOnVillageArmyID] = true
        
    end
end

function Quest_CheckBihuratFinalAttackOnPlayerEnded()
    if g_FinalAttackArmiesDestroyed[g_BihuratFinalAttackOnPlayerArmyID] then
        if not g_DontAttackAgain and Logic.GetCurrentSoldierCount(3) > 12 and Logic.GetCurrentSoldierCount(1) > 12 then
            g_BihuratFinalAttackOnPlayerArmyID = SendAllRemainingUnitsToAttackPlayer(3)
        elseif #{ Logic.GetEntitiesOfCategoryInTerritory( 1, 3, EntityCategories.Military, 0 ) } < 6 and not Logic.IsBurning(Logic.GetStoreHouse(1)) then
            return true
        end
    end
end

function Quest_CheckKhanaFinalAttackOnPlayerEnded()
    if g_FinalAttackArmiesDestroyed[g_KhanaFinalAttackOnPlayerArmyID] and g_FinalAttackArmiesDestroyed[g_KhanaFinalAttackOnPlayerArmyID2] then
        if not g_DontAttackAgain and Logic.GetCurrentSoldierCount(2) > 12 and Logic.GetCurrentSoldierCount(1) > 12 then
            g_KhanaFinalAttackOnPlayerArmyID = SendAllRemainingUnitsToAttackPlayer(2)
        elseif #{ Logic.GetEntitiesOfCategoryInTerritory( 1, 2, EntityCategories.Military, 0 ) } < 6 and not Logic.IsBurning(Logic.GetStoreHouse(1)) then
            return true
        end
    end
end

function Quest_CheckKhanaFinalAttackOnVillageEnded()
    if g_FinalAttackArmiesDestroyed[g_KhanaFinalAttackOnVillageArmyID] then
        return true
    end
end

function Quest_DontAttackAgainOnFinalAttack()
    g_DontAttackAgain = true
end

function Quest_SendStoneToPlayer()
    SendResourceMerchantToPlayer( Logic.GetStoreHouse(4), "G_Stone", 18 )
end

function Quest_BuildGrainFields()
    assert( g_GrainFields )
    for _, Entry in ipairs( g_GrainFields ) do
        Logic.CreateEntity( Entities.B_GrainField_AS, Entry.X, Entry.Y, Entry.Orientation, 4 )
    end
    g_GrainFields = nil
end

function Quest_MakeP3StorehouseVulnerable()
    MakeVulnerable( Logic.GetStoreHouse(3) )
end

function Quest_CheckRockfallActivation()
    StartSimpleHiResJob("SpawnEffectWhenRockBarrierIsCreated")
end

function SpawnEffectWhenRockBarrierIsCreated()

    local RockBarrierID = Logic.GetEntityIDByName("rockfall")
    
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

g_JambaiPlayerID  = 4
g_PraphatPlayerID = 7
g_OtherKnightPlayerID = 8
g_JambaiVillagerID = nil
g_OtherKnightID = nil
g_SarayaID = nil
g_PraphatID = nil
g_StageOneComplete1 = false
g_StageOneComplete2 = false


function Mission_VictoryCutscene()

    SetFriendly(1, g_JambaiPlayerID)
    SetFriendly(1, g_PraphatPlayerID)
    SetFriendly(1, g_OtherKnightPlayerID)

    local PlayerKnightID = Logic.GetKnightID(1)
    
    
    local X, Y =  Logic.GetEntityPosition(PlayerKnightID)
    
    if Logic.GetEntityType(PlayerKnightID) == Entities.U_KnightSaraya then    
        g_SarayaID = PlayerKnightID        
        g_OtherKnightID = Logic.CreateEntityOnUnblockedLand(Entities.U_KnightChivalry, X, Y, 0, g_OtherKnightPlayerID)
        Logic.ExecuteInLuaLocalState("SetupPlayer(" .. g_OtherKnightPlayerID .. ", 'H_Knight_Chivalry', 'Marcus', true)")
    else
        g_OtherKnightID = PlayerKnightID        
        g_SarayaID = Logic.CreateEntityOnUnblockedLand(Entities.U_KnightSaraya, X, Y, 0, g_OtherKnightPlayerID)
        Logic.ExecuteInLuaLocalState("SetupPlayer(" .. g_OtherKnightPlayerID .. ", 'H_Knight_Saraya', 'Saraya', true)")
    end
    
    Logic.ExecuteInLuaLocalState("SetupPlayer(" .. g_PraphatPlayerID .. ", 'H_Knight_Praphat', 'Praphat', true)")
    
    do -- Position Villager
        local Pos = Logic.GetEntityIDByName("v_villlager_pos")        
        local X, Y = Logic.GetEntityPosition(Pos)        
        local O = Logic.GetEntityOrientation(Pos)
       
        g_JambaiVillagerID = Logic.CreateEntityOnUnblockedLand(Entities.U_NPC_Villager01_AS, X, Y, O-90, g_JambaiPlayerID)        
    end
    
    do -- Position Saraya
        local Pos = Logic.GetEntityIDByName("v_saraya_pos")
        local X, Y = Logic.GetEntityPosition(Pos)
        local O = Logic.GetEntityOrientation(Pos)
        
        g_SarayaID = VictorySetEntityToPosition(g_SarayaID, X, Y, O)
    end
    
    do -- Position other knight
        local Pos = Logic.GetEntityIDByName("v_knight_pos")
        local X, Y = Logic.GetEntityPosition(Pos)
        local O = Logic.GetEntityOrientation(Pos)
        
        g_OtherKnightID = VictorySetEntityToPosition(g_OtherKnightID, X, Y, O)
    end
    
    GenerateVictoryDialog(
        {
            {g_JambaiPlayerID, "Victory1_Jambai"}, 
            {Logic.EntityGetPlayer(g_OtherKnightID), "Victory2_Knight"},
            {Logic.EntityGetPlayer(g_SarayaID), "Victory3_Saraya"},
            {g_PraphatPlayerID, "Victory4_Praphat"},
            {Logic.EntityGetPlayer(g_SarayaID), "Victory5_Saraya2"},
        })
        
    g_VictoryCutscene_StartTurn = Logic.GetCurrentTurn()
    
    StartSimpleJob("VictoryCutscene_Loop")
    
    Logic.ExecuteInLuaLocalState("Mission_LocalVictory()")
end

function VictoryCutscene_Loop()

    local SecondsToWaitForStage1 = 35
    local SecondsToWaitForStage2 = 55
    local CurrentTurn = Logic.GetCurrentTurn()
    
    
    if g_VictoryCutscene_StartTurn + (SecondsToWaitForStage1 * 10) <= CurrentTurn then
    
        if not g_StageOneComplete1 then
        
            g_StageOneComplete1 = true
            
            MoveToPosition(g_JambaiVillagerID, Logic.GetBuildingApproachPosition( Logic.GetStoreHouse(g_JambaiPlayerID) ))
            Move(g_OtherKnightID, "v_escort_to_pos")
            
            local PraphatSpawnPos   = Logic.GetEntityIDByName("v_pra_spawn_pos")
            assert(PraphatSpawnPos)
            
            local X, Y =  Logic.GetEntityPosition(PraphatSpawnPos)
            
            g_PraphatID = Logic.CreateEntityOnUnblockedLand(Entities.U_KnightPraphat, X, Y, 0, g_PraphatPlayerID)
            
            Move(g_PraphatID, "v_pra_pos")
            
            g_PraphatBattalion = CreateBattalion(g_PraphatPlayerID, Entities.U_MilitaryBow, X, Y)
            
            Logic.GroupGuard(g_PraphatBattalion, g_SarayaID)
        end
    
    end
    
    if g_VictoryCutscene_StartTurn + (SecondsToWaitForStage2 * 10) <= CurrentTurn then
    
        if not g_StageOneComplete2 then
        
            g_StageOneComplete2 = true
            
            Move(g_SarayaID, "v_escort_to_pos")
            Move(g_PraphatID, "v_escort_to_pos")            
        end
    
    end

end

function Mission_DefeatCutscene_JambaiVillageDestroyed()
    GenerateDefeatDialog( {{ g_JambaiPlayerID, "DefeatJambaiVillageDestroyed" }} )
end




