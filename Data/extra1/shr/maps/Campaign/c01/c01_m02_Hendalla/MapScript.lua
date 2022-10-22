CurrentMapIsCampaignMap = true

----------------------------------------------------------------------------------------------------------------------
function Mission_InitPlayers()
	    
end
----------------------------------------------------------------------------------------------------------------------
function Mission_SetStartingMonth()

    Logic.SetMonthOffset(3)

end
----------------------------------------------------------------------------------------------------------------------
function Mission_InitMerchants()

    -- Haoshia
    local PlayerID = 3
	local TraderID = Logic.GetStoreHouse(PlayerID)
	AddOffer( TraderID, 2, Goods.G_Iron )
	AddOffer( TraderID, 2, Goods.G_Carcass )

    -- Konglish
    local PlayerID = 4
	local TraderID = Logic.GetStoreHouse(PlayerID)
	AddOffer( TraderID, 2, Goods.G_Wool )

    -- Hendalla
    local PlayerID = 5
	local TraderID = Logic.GetStoreHouse(PlayerID)
	AddOffer( TraderID, 2, Goods.G_Medicine )

end


function setup_well()
    local well_ID = Logic.GetEntityIDByName("Empty_Well")
    Logic.Extra1_BreakWell(assert(well_ID))
--    Logic.InteractiveObjectSetPlayerState( well_ID, 1, 2 )
--    Logic.InteractiveObjectSetAvailability( well_ID, false )    

end

function GameCallback_AIWallBuildingOrder(_PlayerID)
    if _PlayerID == 4 then
        return 3
    end
end

function dump_stone_mine()
    Logic.Extra1_SetResourceAmount(assert(Logic.GetEntityIDByName("empty_Stone_Mine")),0)     
    local stone_mine_ID = Logic.GetEntityIDByName("empty_Stone_Mine")
    Logic.InteractiveObjectSetPlayerState( stone_mine_ID, 1, 2 )
    Logic.InteractiveObjectSetAvailability( stone_mine_ID, false )    
end

function QuitEventWeatherInNonMonsoonMonth()

    local CurrentMonth = Logic.GetCurrentMonth()    
    local NextMonth    = CurrentMonth + 1
    
    if NextMonth > 12 then
        NextMonth = 1
    end
    
    -- This tests the normal weather
    if Logic.GetWeatherDoesShallowWaterFloodByMonth(CurrentMonth) == false then
    
        local EndEventWeather = false
        
        if Logic.GetWeatherDoesShallowWaterFloodByMonth(NextMonth) == false then
            EndEventWeather = true
        else  
            local MonthDurationInSeconds = Logic.GetMonthDurationInSeconds()
            local SecondsIntoCurrentMonth = Logic.GetMonthSeconds()
    
            -- plenty time left for change
            if SecondsIntoCurrentMonth / MonthDurationInSeconds < .3 then
                 EndEventWeather = true
            end
        end
        
        if EndEventWeather then
        
            Logic.ExecuteInLuaLocalState("EndEventSpring()")

            Logic.DeactivateWeatherEvent()
    
            return true
        end
    end
end

function unlock_stone_mine()
    
    local well_ID = Logic.GetEntityIDByName("Empty_Well")
    Logic.Extra1_RepairWell(assert(well_ID))

    local IO_ID = Logic.GetEntityIDByName("empty_Stone_Mine")
    Logic.InteractiveObjectSetPlayerState( IO_ID, 1, 0 )
    Logic.InteractiveObjectSetAvailability( IO_ID, false )  
end

function Quest_ReenableMonsoon()
    StartSimpleJob( "QuitEventWeatherInNonMonsoonMonth" )
end

function Q7_building_order()
    AICore.SetNumericalFact( 3, "BARB", 1 )
end

function Quest_DeactivateBARBHaoshia()
    AICore.SetNumericalFact( 3, "BARB", 0 )
end

function Quest_AddKonglishOffer()

    -- Konglish
    local PlayerID = 4
	local TraderID = Logic.GetStoreHouse(PlayerID)
	AddOffer( TraderID, 3, Goods.G_Stone )
    -- Hack to force a menu update
    Logic.ExecuteInLuaLocalState("GameCallback_CloseNPCInteraction(1, Logic.GetStoreHouse("..PlayerID.."))")
    
end

function Mission_CallBack_BuildingDestroyed( _BuildingID, _PlayerID, _KnockedDown )
    if _PlayerID == 3 and _KnockedDown == 0 then
        g_HaoshiaBuildingDestroyed = Logic.GetEntityType( _BuildingID )
    end
end

function Quest_ResetHaoshiaDestroyedBuildingsMarker()
    g_HaoshiaBuildingDestroyed = false
end

function Quest_CheckHaoshiaBuildingDestroyed()
    if g_HaoshiaBuildingDestroyed then
        g_HaoshiaBuildingDestroyed = false
        return true
    end
end

function Quest_CheckHaoshiaRealBuildingDestroyed()
    if g_HaoshiaBuildingDestroyed and g_HaoshiaBuildingDestroyed ~= 0 and Logic.IsEntityTypeInCategory( g_HaoshiaBuildingDestroyed, EntityCategories.Wall ) == 0 then
        g_HaoshiaBuildingDestroyed = false
        return true
    end
end


function Quest_EarthquakeHaoshia()
    Event_AddEarthquake( {1, 3}, 12, { [1] = true, [3] = true }, {} )
end

function Quest_KillUnusedBanditTroops()
    for _, Type in ipairs{ Entities.U_MilitaryBow_Khana, Entities.U_MilitarySword_Khana } do
        local IDs = { Logic.GetPlayerEntities( 6, Type, 16, 0 ) }
        table.remove( IDs, 1 )
        for _, ID in ipairs( IDs ) do
            Logic.DestroyEntity( ID )
        end
    end
end

----------------------------------------------------------------------------------------------------------------------
function Mission_FirstMapAction()
    if Framework.IsNetworkGame() ~= true then
        Startup_Player()
        Startup_StartGoods()
        Startup_Diplomacy()  
        
        -- CP: Changed player colors to be more consistent
        Logic.PlayerSetPlayerColor(3 , g_ColorIndex["VillageColor3"], -1, -1)  --Haoshia: Dorf-Grün
        Logic.PlayerSetPlayerColor(6 , g_ColorIndex["CloisterColor5"], -1, -1)  --Kultisten: Hellgrün
        Logic.PlayerSetPlayerColor(7 , g_ColorIndex["BanditsColor2"], -1, -1)  --Praphat: Banditen-Orange
    end        
    do
        local MapName = Framework.GetCurrentMapName()
        local ScriptName = "mapeditor\\QuestSystemBehavior.lua"
        Script.Load(ScriptName)
        -- Script was loaded
        assert( RegisterBehaviors )
        CreateQuests()
    end
    
    -- Haoshia doesn't rebuild before Q7
    AICore.SetNumericalFact( 3, "BARB", 0 )
    AddResourcesToPlayer( Goods.G_Stone, 30, 3 )    
    
    -- Konglish doesn't start building before Q3
    AICore.SetNumericalFact( 4, "BPMX", 0 )
    
    -- No rain until Q9
    Logic.WeatherEventSetPrecipitationFalling(false)
    Logic.ActivateWeatherEvent()
    
    -- Destroy some haoshia buildings/palisades for later rebuild
    for i = 1, 3 do
        local EntityID = assert(Logic.GetEntityIDByName("DestroyOnStart"..i))
        local Orientation = Logic.GetEntityOrientation( EntityID )
        local X, Y = Logic.GetEntityPosition( EntityID )
        Logic.HurtEntity( EntityID, Logic.GetEntityMaxHealth( EntityID ) )
        
        Logic.CreateEntity( Entities.B_Rubble_8x8, X + 1, Y + 1, Orientation, 0 )
    end
    local Walls = { Logic.GetEntitiesOfCategoryInTerritory( 3, 3, EntityCategories.PalisadeSegment, 0 ) }
    assert(#Walls >= 4)
    for _ = 1, 4 do
        local Index = Logic.GetRandom(#Walls) + 1
        local ID = table.remove( Walls, Index )
        Logic.HurtEntity( ID, Logic.GetEntityHealth( ID ) )
    end
    
    local ID = assert( Logic.GetEntityIDByName( "Holy_Cow" ) )

    Logic.InteractiveObjectSetPlayerState( ID, 1, 2 )
    Logic.InteractiveObjectSetAvailability( ID, false )
    Logic.InteractiveObjectSetInteractionDistance( ID, 1500 )
    Logic.InteractiveObjectClearCosts( ID )
    Logic.InteractiveObjectClearRewards( ID )
    Logic.InteractiveObjectSetTimeToOpen( ID, 0 )
    Logic.InteractiveObjectSetDeactivateAfterUse( ID, true )
    
    --Mission_VictoryCutscene()
end

-- Force destruction of burning Haoshia walls
g_DestroyBuildings = {}
function Mission_CallBack_OnBuildingBurning(_PlayerID, _EntityID)
    if _PlayerID == _PlayerID and Logic.IsEntityTypeInCategory( Logic.GetEntityType( _EntityID ), EntityCategories.Wall ) == 1 then
        table.insert( g_DestroyBuildings, _EntityID )
        if not g_DestroyJob then
            g_DestroyJob = StartSimpleJob( "DestroyJob" )
            return true
        end
    end
end

function DestroyJob()
    for i = #g_DestroyBuildings, 1, -1 do
        if Logic.IsEntityDestroyed( g_DestroyBuildings[i] ) or not Logic.IsBurning( g_DestroyBuildings[i] ) then
            table.remove( g_DestroyBuildings, i )
        else
            Logic.HurtEntity( g_DestroyBuildings[i], Logic.GetEntityMaxHealth(g_DestroyBuildings[i]) / 24 )
        end
    end
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
    local Name = "Holy_Cow"
    if Logic.IsEntityAlive( Name ) then
        local X, Y = Logic.GetEntityPosition(GetEntityId(Name))
        return Logic.WaterIsPositionShallow(X, Y)
    else
        return false
    end
end

function CheckNoImportantEntityOnShallowWater()
    if not IsImportantEntityOnShallowWater() then
        Logic.SetShallowWaterFloodFlag(true)
        return true
    end
end

function Quest_AddSupportTroops()
    local CastleX, CastleY = Logic.GetEntityPosition( Logic.GetEntityIDByName("Holy_Cow") )
    local X, Y = Logic.GetBuildingApproachPosition( Logic.GetHeadquarters(1) )
    for i = 1, 1 do
        local EntityID = Logic.CreateBattalionOnUnblockedLand( Entities.U_MilitarySword, X, Y, 0, 1 );
        Logic.GroupAttackMove( EntityID, CastleX, CastleY, -1 )
    end
    for i = 1, 1 do
        local EntityID = Logic.CreateBattalionOnUnblockedLand( Entities.U_MilitaryBow, X, Y, 0, 1 );
        Logic.GroupAttackMove( EntityID, CastleX, CastleY, -1 )
    end
end

function Quest_AttackHolyCow()

    AIScript_SpawnAndAttackMovingUnit(6, GetID("Holy_Cow"), GetID("Cultist_barracks"), 0, 1, 3, false)        

end

function Quest_HaoshiaRepairStoreHouse()
    StartSimpleJob( "RepairHaoshiaStoreHouse" )
end

function RepairHaoshiaStoreHouse()
    local EntityID = Logic.GetStoreHouse(3)
    if EntityID and EntityID ~= 0 then
        local Health = Logic.GetEntityHealth(EntityID)
        local HealthMax = Logic.GetEntityMaxHealth(EntityID)
        Logic.HealEntity( EntityID, HealthMax / 15 )
        return Health == HealthMax
    end

    return true
end

function Quest_CancelAIAttacks()
    AICore.CancelAllAttacks()
end

function Quest_CheckMonsoonActiveOrImminent()
    local CurrentMonth = Logic.GetCurrentMonth()    
    local NextMonth    = CurrentMonth + 1
    
    if NextMonth > 12 then
        NextMonth = 1
    end
    
    if Logic.GetWeatherDoesShallowWaterFloodByMonth(CurrentMonth) or ( Logic.GetWeatherDoesShallowWaterFloodByMonth(NextMonth) 
        and Logic.GetMonthSeconds() / Logic.GetMonthDurationInSeconds() > 0.6 ) then
        return true
    end

end

function Quest_StartFestivalAtKonglish()
    Logic.StartFestival( 4, 1 )
end

function Quest_StartFestivalAtHaoshia()
    Logic.StartFestival( 3, 1 )
end

-- If the knight gets too close to the camp when protecting the cow: Attack him
function Quest_StartCheckingForKnightNearCamp()
    g_WaitForNewKnightAttack = 0
    StartSimpleJob( "CheckKnightNearCamp" )
end

function CheckKnightNearCamp()
    if g_WaitForNewKnightAttack > 0 then
        g_WaitForNewKnightAttack = g_WaitForNewKnightAttack - 1
    else
        local KnightID = Logic.GetKnightID(1)
        if Logic.IsEntityAlive(KnightID) then
            local CheckID = assert(Logic.GetEntityIDByName( "CheckKnight" ))
            if Logic.GetDistanceBetweenEntities( KnightID, CheckID ) < 2700 then
                AIScript_SpawnAndAttackMovingUnit(6, KnightID, GetID("Cultist_barracks"), 2, 3, 3, true)
                g_WaitForNewKnightAttack = 40
            end
        end
    end
end

g_PraphatPlayerID = 7
g_HaoshiaPlayerID = 3
g_CultistsPlayerID = 6
g_PraphatMoved = false


function Mission_VictoryCutscene()

    local OtherKnightPlayerID = 8
    
    SetFriendly(1,OtherKnightPlayerID)
    SetFriendly(1,g_PraphatPlayerID)
    SetFriendly(g_HaoshiaPlayerID,g_PraphatPlayerID)
    SetFriendly(g_HaoshiaPlayerID,OtherKnightPlayerID)
    SetFriendly(g_HaoshiaPlayerID,1)
    
    
    local PlayerKnightID = Logic.GetKnightID(1)
    
    local X, Y =  Logic.GetEntityPosition(PlayerKnightID)
    
    local SarayaID, OtherKnightID
    
    if Logic.GetEntityType(PlayerKnightID) == Entities.U_KnightSaraya then    
        SarayaID = PlayerKnightID        
        OtherKnightID = Logic.CreateEntityOnUnblockedLand(Entities.U_KnightChivalry, X, Y, 0, OtherKnightPlayerID)
        Logic.ExecuteInLuaLocalState("SetupPlayer(" .. OtherKnightPlayerID .. ", 'H_Knight_Chivalry', 'Marcus', true)")
    else
        OtherKnightID = PlayerKnightID        
        SarayaID = Logic.CreateEntityOnUnblockedLand(Entities.U_KnightSaraya, X, Y, 0, OtherKnightPlayerID)
        Logic.ExecuteInLuaLocalState("SetupPlayer(" .. OtherKnightPlayerID .. ", 'H_Knight_Saraya', 'Saraya', true)")
    end
    
    Logic.ExecuteInLuaLocalState("SetupPlayer(" .. g_PraphatPlayerID .. ", 'H_Knight_Praphat', 'Praphat', true)")
    
    do -- Position holy cow
        
        local Pos = Logic.GetEntityIDByName("v_hc_pos")        
        local X, Y = Logic.GetEntityPosition(Pos)        
        local O = Logic.GetEntityOrientation(Pos)
       
        local HolyCowID = Logic.GetEntityIDByName("Holy_Cow")
        
        local HolyCowID = VictorySetEntityToPosition(HolyCowID, X, Y, O)
                
        Logic.InteractiveObjectSetAvailability(HolyCowID, false)
        Logic.InteractiveObjectSetInteractionDistance(HolyCowID, 0)
    end
    
    do -- Position Saraya
        local Pos = Logic.GetEntityIDByName("v_k1")
        local X, Y = Logic.GetEntityPosition(Pos)
        local O = Logic.GetEntityOrientation(Pos)
        
        SarayaID = VictorySetEntityToPosition(SarayaID, X, Y, O)
    end
    
    do -- Position other knight
        local Pos = Logic.GetEntityIDByName("v_k2")
        local X, Y = Logic.GetEntityPosition(Pos)
        local O = Logic.GetEntityOrientation(Pos)
        
        OtherKnightID = VictorySetEntityToPosition(OtherKnightID, X, Y, O)
    end
    
    GenerateVictoryDialog(
        {
            {g_HaoshiaPlayerID, "Victory1_HaoshiaNews"}, 
            {g_CultistsPlayerID, "Victory2_CultistsLeaving"},
            {g_PraphatPlayerID, "Victory3_Praphat"},
            {Logic.EntityGetPlayer(SarayaID), "Victory4_Saraya"},
            {Logic.EntityGetPlayer(OtherKnightID), "Victory5_Knight"}
        })
    
    g_VictoryCutscene_StartTurn = Logic.GetCurrentTurn()
    
    StartSimpleJob("VictoryCutscene_Loop")
    
    VictoryCutscene_GenerateApplause()
        
    Logic.ExecuteInLuaLocalState("Mission_LocalVictory()")    
    
end

function VictoryCutscene_Loop()

    local SecondsToWait = 10
    local CurrentTurn = Logic.GetCurrentTurn()
    
    if g_VictoryCutscene_StartTurn + (SecondsToWait * 10) <= CurrentTurn then
    
        if not g_PraphatMoved then
            
            g_PraphatMoved = true
            
            local PraphatSpawnPos   = Logic.GetEntityIDByName("v_pra_spawn_pos")
            assert(PraphatSpawnPos)
            
            local X, Y =  Logic.GetEntityPosition(PraphatSpawnPos)
            
            local PraphatID = Logic.CreateEntityOnUnblockedLand(Entities.U_KnightPraphat, X, Y, 0, g_PraphatPlayerID)
            
            Move(PraphatID, "v_pra_pos")
            
            local PraphatBattalion = CreateBattalion(g_PraphatPlayerID, Entities.U_MilitarySword, X, Y)
            
            Move(PraphatBattalion, "v_pra_bat_pos")
            
        end
            
    end
end

function VictoryCutscene_GenerateApplause()
    
    local PossibleSettlerTypes = {
        Entities.U_NPC_Baker_AS,
        Entities.U_NPC_Butcher_AS,
        Entities.U_NPC_DairyWorker_AS,
        Entities.U_NPC_Monk_AS,
        Entities.U_NPC_Pharmacist_AS,
        Entities.U_NPC_SmokeHouseWorker_AS 
    }

    local PlayerID = g_HaoshiaPlayerID
    
    for k=1,16 do
        local ScriptEntityName = "v_jub_pos" .. k
        local Pos = Logic.GetEntityIDByName(ScriptEntityName)
        
        if Pos then
            local X, Y = Logic.GetEntityPosition(Pos)
            local Orientation = Logic.GetEntityOrientation(Pos)  
            local SettlerType = PossibleSettlerTypes[1 + Logic.GetRandom(#PossibleSettlerTypes)]
            local SettlerID = Logic.CreateEntityOnUnblockedLand(SettlerType, X, Y, Orientation-90, PlayerID) 
            Logic.SetTaskList(SettlerID, TaskLists.TL_WORKER_FESTIVAL_APPLAUD_SPEECH)
        end
    end
end

function Mission_DefeatCutscene_HolyCowDead()
    GenerateDefeatDialog( {{ g_CultistsPlayerID, "Defeat_HolyCowDead" }} )
end

function Mission_DefeatCutscene_Haoshia()
    GenerateDefeatDialog( {{ g_HaoshiaPlayerID, "Defeat_Haoshia" }} )
end

