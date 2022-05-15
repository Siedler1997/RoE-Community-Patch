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

    -- Imapha
    local PlayerID = 2
	local TraderID = Logic.GetStoreHouse(PlayerID)
	AddOffer( TraderID, 1, Goods.G_Cow )
	AddOffer( TraderID, 2, Goods.G_Milk )
	AddOffer( TraderID, 3, Goods.G_Sheep )

    -- Basrima
    local PlayerID = 3
	local TraderID = Logic.GetStoreHouse(PlayerID)
	AddOffer( TraderID, 2, Goods.G_Carcass )
	AddOffer( TraderID, 1, Goods.G_Sausage )

    -- Baklash
    local PlayerID = 7
	local TraderID = Logic.GetStoreHouse(PlayerID)
	AddOffer( TraderID, 1, Goods.G_Medicine )
	AddOffer( TraderID, 2, Goods.G_RawFish )

end

function setup_interactive_obj()
    Logic.Extra1_SetResourceAmount(assert(Logic.GetEntityIDByName("Eshneija_iron_mine")),0)
    Logic.Extra1_SetResourceAmount(assert(Logic.GetEntityIDByName("Basrima_stone_mine")),0)     
end

----------------------------------------------------------------------------------------------------------------------
function Mission_FirstMapAction()

    -- init players in singleplayer games only
    if Framework.IsNetworkGame() ~= true then

        Startup_Player()
        Startup_StartGoods()
        Startup_Diplomacy()
        
        -- CP: Changed player colors to be more consistent
        Logic.PlayerSetPlayerColor(4 , 22, -1, -1)  --Banditen: schwarz
        Logic.PlayerSetPlayerColor(5 , 23, -1, -1)  --RP-Dudes: dark grey
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

    for i = 1, 2 do
        local TroopID = Logic.GetEntityIDByName("RPTroops"..i)
        assert( TroopID and TroopID ~= 0 )
        AICore.HideEntityFromAI( 5, TroopID, true )
    end
    
    -- Disable mines, so they can't be refilled yet
    for _, Name in ipairs{ "Eshneija_iron_mine", "Basrima_stone_mine", "100/150", "200/200", "210/210" } do
        local ID = assert( Logic.GetEntityIDByName(Name) )
        Logic.InteractiveObjectSetPlayerState( ID, 1, 2 )
        Logic.InteractiveObjectSetAvailability( ID, false )    
    end
    
    --das Zelt sperren - damit man es wirklich ganz am Ende aktivieren kann
    local Qtent_ID = Logic.GetEntityIDByName("RP_tent")
    Logic.InteractiveObjectSetPlayerState( Qtent_ID, 1, 2 )
    Logic.InteractiveObjectSetAvailability( Qtent_ID, false )   
    Logic.InteractiveObjectClearCosts( Qtent_ID )
    Logic.InteractiveObjectSetTimeToOpen( Qtent_ID, 0 )
    
    AICore.SetNumericalFact( 3, "BARB", 0 )
    StartSimpleJob( "RemoveBasrimaWall" )
    
    -- Allow guard AI to work without storehouse
    AICore.CreateAIPlayer(5)
    -- AI must not try to rebuild anything, since it has no storehouse
    AICore.SetNumericalFact( 5, "BARB", 0 )
    
    -- Damage outpost, so its more easy to capture it
    -- CP: Don't do that! It's already easy enough.
    --[[
    local OutpostID = assert(Logic.GetEntityIDByName("P5Outpost"))
    Logic.HurtEntity( OutpostID, Logic.GetEntityMaxHealth(OutpostID) * 0.19 )
    StartSimpleJob( "KeepOutpostHealthLow" )
    --]]
    
    -- And break the well, so the camp walls won't be extinguished
    local well_ID = Logic.GetEntityIDByName("Guards_MP")
    Logic.Extra1_BreakWell(assert(well_ID))
    
    --[[ TODO:
        Make settlers sick? (geologist camp)
        ]]
    
    --Mission_VictoryCutscene()
end

function KeepOutpostHealthLow()
    if Logic.IsEntityDestroyed("P5Outpost") then
        return true
    end
    local OutpostID = assert(Logic.GetEntityIDByName("P5Outpost"))
    
    if Logic.EntityGetPlayer( OutpostID ) ~= 5 then
        return true
    end
    
    if Logic.GetEntityHealth( OutpostID ) > Logic.GetEntityMaxHealth(OutpostID) * 0.81 then
        Logic.HurtEntity( OutpostID, Logic.GetEntityHealth( OutpostID ) - (Logic.GetEntityMaxHealth(OutpostID) * 0.81) )
    end
end

function RemoveBasrimaWall()
    -- Kill Basrima walls (rebuild later)
    local NoChange = true
    for _, ID in ipairs{ Logic.GetEntitiesOfCategoryInTerritory( 3, 3, EntityCategories.CityWallSegment, 0 ) } do
        Logic.HurtEntity( ID, Logic.GetEntityHealth( ID ) )
        NoChange = false
    end
    for _, ID in ipairs{ Logic.GetEntitiesOfCategoryInTerritory( 3, 3, EntityCategories.CityWallGate, 0 ) } do
        if Logic.GetEntityType( ID ) ~= Entities.B_PalisadeGate then
            Logic.HurtEntity( ID, Logic.GetEntityHealth( ID ) )
            NoChange = false
        end
    end
    return NoChange
end

function Quest_AddMurdishOffers()

    -- Murdish
    local PlayerID = 4
	local TraderID = Logic.GetStoreHouse(PlayerID)
	AddMercenaryOffer( TraderID, 2, Entities.U_MilitaryBandit_Melee_NA )
	AddMercenaryOffer( TraderID, 2, Entities.U_MilitaryBandit_Ranged_NA )
    
end

function Quest_AddBasrimaOffer()

    -- Basrima
    local PlayerID = 3
	local TraderID = Logic.GetStoreHouse(PlayerID)
	AddOffer( TraderID, 2, Goods.G_Stone )
    -- Hack to force a menu update
    Logic.ExecuteInLuaLocalState("GameCallback_CloseNPCInteraction(1, Logic.GetStoreHouse("..PlayerID.."))")
    
    -- Rebuild wall
    AICore.SetNumericalFact( 3, "BARB", 1 )
    
end

function Quest_BasrimaRPHostile()
    SetDiplomacyState( 3, 5, DiplomacyStates.Enemy )
    
    Logic.SetShareExplorationWithPlayerFlag( 1, 5, 1 )
end

function Quest_SarayaRPHostile()
    SetDiplomacyState( 6, 5, DiplomacyStates.Enemy )
    local SarayaID = Logic.GetEntityIDByName( "saraya_entry" )
    Logic.SetEntityInvulnerabilityFlag( SarayaID, 1 )
end

function Quest_BaklashSendMedicine()
    local Deliver = DeliveryTemplate:new()
    Deliver:Initialize(Goods.G_Medicine, 6, 7, 2, function() g_MedicineDelivered = true end, Quest_BaklashSendMedicine, true)
end

function Quest_CheckMedicineArrival()
   return g_MedicineDelivered
end

function Quest_SpawnAndEscortStolenFood()
    local CartID = Logic.GetEntityIDByName("StolenCart")
    assert( CartID and CartID > 0 )
    assert( Logic.GetEntityType( CartID ) == Entities.U_Marketer )
    local x, y = Logic.GetEntityPosition(CartID)
    Logic.HireMerchant( CartID, 5, Goods.G_Sausage, 9, 2 )
    g_TroopIDs = {}
    for i = 1, 1 do -- 3 troops were too strong
        local TroopID = Logic.CreateBattalionOnUnblockedLand( Entities.U_MilitarySword_RedPrince, x, y, 0, 5, 0 )
        Logic.GroupGuard( TroopID, CartID )
        AICore.HideEntityFromAI( 5, TroopID, true )
        table.insert( g_TroopIDs, TroopID )
    end
    
--    StartSimpleJob( "MultiEscort" )
end
--[[
function MultiEscort()
    if not Logic.IsEntityAlive("StolenCart") then
        return true
    end
    
    local CartID = Logic.GetEntityIDByName("StolenCart")
    local x, y = Logic.GetEntityPosition(CartID)
    local AllDead = true
    for i = 2, 3 do
        local ID = g_TroopIDs[i]
        if Logic.IsEntityAlive(ID) then
            Logic.GroupAttackMove( ID, x, y, -1 )
            AllDead = false
        end
    end
    
    return AllDead
end
]]
function Quest_OverrideStolenCartDest()
    local CartID = Logic.GetEntityIDByName("StolenCart")
    assert( CartID and CartID > 0 )
    
    local Guards = Logic.GetGuardianEntityID( CartID )
    if Guards and Guards > 0 then
        Logic.GroupDefend( Guards )
    end
    
    local Orientation = Logic.GetEntityOrientation( CartID )
    local CartX, CartY = Logic.GetEntityPosition( CartID )
    Logic.DestroyEntity( CartID )
    CartID = Logic.CreateEntity( Entities.U_Marketer, CartX, CartY, Orientation, 2 )
    Logic.SetEntityName( CartID, "StolenCart" )
    Logic.HireMerchant( CartID, 2, Goods.G_Sausage, 9, 2 )
    
    if Guards and Guards > 0 then
        Logic.GroupGuard(Guards, CartID)
    end
end

function Quest_ReenableRegularMines()
    for _, Name in ipairs{ "100/150", "200/200", "210/210" } do
        local ID = assert( Logic.GetEntityIDByName(Name) )
        Logic.InteractiveObjectSetPlayerState( ID, 1, 0 )
        Logic.InteractiveObjectSetAvailability( ID, true )    
    end
end

function Quest_AddSupportTroops()
    local CastleX, CastleY = Logic.GetEntityPosition( Logic.GetEntityIDByName("SarayaQ18DestTemp") )
    local X, Y = Logic.GetEntityPosition( Logic.GetEntityIDByName( "saraya_entry" ) )
    for i = 1, 2 do
        local EntityID = Logic.CreateBattalionOnUnblockedLand( Entities.U_MilitarySword, X, Y, 0, 1 );
        Logic.GroupAttackMove( EntityID, CastleX, CastleY, -1 )
    end
    for i = 1, 2 do
        local EntityID = Logic.CreateBattalionOnUnblockedLand( Entities.U_MilitaryBow, X, Y, 0, 1 );
        Logic.GroupAttackMove( EntityID, CastleX, CastleY, -1 )
    end
end

function Mission_Callback_AIOnArmyDisbanded(_PlayerID, _ArmyID)
    if _PlayerID == 5 then
        g_TroopRetreatFlag = true
    end
end

function Quest_CheckTroopRetreatFlag()
    if g_TroopRetreatFlag then
        return true
    end
end

function Quest_ClearTroopRetreatFlag()
    g_TroopRetreatFlag = false
end

function Mission_VictoryCutscene()

    local SarayaPlayerID = 6

    SetFriendly(1, 5)
    SetFriendly(SarayaPlayerID, 5)

    if Logic.GetKnightID(SarayaPlayerID) == 0 then
        local X, Y = Logic.GetEntityPosition( Logic.GetKnightID(1) )

        Logic.CreateEntityOnUnblockedLand(Entities.U_KnightSaraya, X, Y, 0, SarayaPlayerID)
    end
        
    local LeftID   = Logic.GetEntityIDByName("v1")
    assert(LeftID)
    local RightID  = Logic.GetEntityIDByName("v2")
    assert(RightID)
    local SarayaID = Logic.GetKnightID(SarayaPlayerID) 
    local KnightID = Logic.GetKnightID(1)
    
    local X, Y = Logic.GetEntityPosition(LeftID)
    local O = Logic.GetEntityOrientation(LeftID)
    
    KnightID = VictorySetEntityToPosition(KnightID, X, Y, O)
    
    X, Y = Logic.GetEntityPosition(RightID)
    O    = Logic.GetEntityOrientation(RightID)
    
    SarayaID = VictorySetEntityToPosition(SarayaID, X, Y, O)
    
    GenerateVictoryDialog(
        {
            {SarayaPlayerID, "Victory1_SarayaJoins"}, 
            {1, "Victory2_Knight"},
        })
    
   Logic.ExecuteInLuaLocalState("Mission_LocalVictory()")

    
end

function Mission_DefeatCutscene()

    local BasrimaPlayerID = 3

    if Logic.GetMarketplace(BasrimaPlayerID) == 0 then    
        GenerateDefeatDialog( {{ BasrimaPlayerID, "Defeat_Basrima" }} )
    else
        GenerateDefeatDialog( {{ 1, "Defeat_Saraya" }} )
    end
end
