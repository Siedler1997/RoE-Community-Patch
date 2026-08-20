CurrentMapIsCampaignMap = true

--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
function Mission_InitPlayers()

end


--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
function Mission_SetStartingMonth()

    Logic.SetMonthOffset(9)
	
end
--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
function Mission_InitMerchants()

    -- Amethi
    local PlayerID = 2
	local TraderID = Logic.GetStoreHouse(PlayerID)
	AddOffer( TraderID, 2, Goods.G_Carcass )
	AddOffer( TraderID, 2, Goods.G_Wood )

    local _, TradepostID = Logic.GetPlayerEntities( PlayerID, Entities.I_X_TradePostConstructionSite, 1, 0 )
    assert( TradepostID and TradepostID ~= 0 )
    Logic.TradePost_SetTradePartnerGenerateGoodsFlag(TradepostID, true)
    Logic.TradePost_SetTradePartnerPlayerID(TradepostID, PlayerID)
    Logic.TradePost_SetTradeDefinition(TradepostID, 0, Goods.G_RawFish, 9, Goods.G_Iron, 9)
    Logic.TradePost_SetTradeDefinition(TradepostID, 1, Goods.G_Wool, 9, Goods.G_Gems, 9)
    Logic.TradePost_SetActiveTradeSlot(TradepostID, 0)
    
    Logic.InteractiveObjectSetPlayerState( TradepostID, 1, 2 )
    Logic.InteractiveObjectSetAvailability( TradepostID, false )   


end
--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
function Mission_FirstMapAction()
    
    if Framework.IsNetworkGame() ~= true then

        Startup_Player()
        Startup_StartGoods()
        Startup_Diplomacy()
        
        -- CP: Changed player colors to be more consistent
        Logic.PlayerSetPlayerColor(2 , g_ColorIndex["VillageColor3"], -1, -1)  --Amethi: Blaugrün
        Logic.PlayerSetPlayerColor(3 , g_ColorIndex["BanditsColor2"], -1, -1)  --Praphat: Banditen-Orange
        Logic.PlayerSetPlayerColor(4 , g_ColorIndex["CityColor3"], -1, -1)   --Khana: Grün
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
    
    g_ChosenKnightType = Logic.GetEntityType( Logic.GetKnightID(1) )

    -- Amethi doesn't repair/rebuild until Q17 finished
  	AICore.SetNumericalFact( 2, "BARB", 0 )

    g_FiresActivatedTotal = 0
    g_FiresBurning = 3  -- will be decremented to 0 by the following loop
    for i = 1, 3 do SetSignalFireUsableByKhana( "SignalFire" .. i ) end
    
    g_KhanaWave = 0
    
    StartSimpleJob( "CheckFoundCarts" )
    
    g_UnusedKnights = {
        { Type = Entities.U_KnightChivalry },
        { Type = Entities.U_KnightWisdom },
        { Type = Entities.U_KnightSaraya },
        { Type = Entities.U_KnightTrading },
    }
    for i, Entry in ipairs( g_UnusedKnights ) do
        if Entry.Type == g_ChosenKnightType then
            table.remove( g_UnusedKnights, i )
            break
        end
    end
    
    for i = 1, #g_UnusedKnights do
        local PlayerID = i + 4
        DoNotStartAIForPlayer(i)
        local KnightTypeName = Logic.GetEntityTypeName(g_UnusedKnights[i].Type)
        Logic.ExecuteInLuaLocalState( string.format([===[
            SetupPlayer(%d, assert(GetKnightActor(%d)), "Temp", "CityColor4")
            local KnightName = XGUIEng.GetStringTableText("UI_ObjectNames/%s")
            GUI.SetPlayerName(%d, KnightName )
        ]===], PlayerID, g_UnusedKnights[i].Type, KnightTypeName, PlayerID) )
    end
    
    -- Redirect local callback to the logic callback to fake the water delivery to the signal fires
    Logic.ExecuteInLuaLocalState([[
    function Mission_Callback_OverrideObjectInteraction( _ObjectID, _PlayerID, _Costs )
        GUI.SendScriptCommand( string.format("Mission_Callback_OverrideObjectInteraction( %d, %d, { %d, %d } )", _ObjectID, _PlayerID, _Costs[1], _Costs[2] ), true )
    end
    ]])
    
    --Mission_VictoryCutscene()
end
--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
function Mission_SetDiplomacy()

	
end
--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
function Mission_SetupQuests()


end
--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

function Mission_Callback_OverrideObjectInteraction( _ObjectID, _PlayerID, _Costs )
    assert( _PlayerID == 1 )
    assert( _ObjectID and _ObjectID > 0 and Logic.IsEntityAlive( _ObjectID ) )
    assert( _Costs and _Costs[1] and _Costs[2] )
    
    for i = 1, 3 do
        if _ObjectID == Logic.GetEntityIDByName( "SignalFire" .. i ) then
        
            local LastSupplierID = Logic.GetStoreHouse(1)   -- Default value, just in case...
            local LastSupplierAmount = 0
            local AmountLeft = _Costs[2]
            
            local Wells = GetPlayerEntities( _PlayerID, Entities.B_Cistern )
            table.insert( Wells, 1, Logic.GetMarketplace(_PlayerID) )
            for _, ID in ipairs( Wells ) do
                local NumberOfGoodTypes = Logic.GetNumberOfGoodTypesOnOutStock(ID)
                if NumberOfGoodTypes then
                    for i = 0, NumberOfGoodTypes-1 do        
                        local GoodType = Logic.GetGoodTypeOnOutStockByIndex(ID,i)
                        local Amount = Logic.GetAmountOnOutStockByIndex(ID, i)
                        if GoodType == _Costs[1] and Amount > 0 then
                            
                            local AmountUsed = AmountLeft > Amount and Amount or AmountLeft
                            Logic.RemoveGoodFromStock(ID, GoodType, AmountUsed, false)
                            
                            AmountLeft = AmountLeft - AmountUsed
                            assert( AmountLeft >= 0 )
                            
                            if AmountUsed > LastSupplierAmount then
                                LastSupplierID = ID
                                LastSupplierAmount = Amount
                            end

                            if AmountLeft == 0 then
                                break
                            end
                        end
                    end
                end
            end

            local CartX, CartY = Logic.GetBuildingApproachPosition( LastSupplierID )
            CartID = Logic.CreateEntityAtBuilding( Entities.U_ResourceMerchant, LastSupplierID, 0, 1 )
            Logic.HireMerchant( CartID, 1, _Costs[1], _Costs[2], 1, true )

            Logic.InteractiveObjectAttachDeliveryCart( _ObjectID, CartID )
            return true
            
        end
    end
end

function Quest_IsKnightSaraya()
    return g_ChosenKnightType == Entities.U_KnightSaraya
end

function Quest_EarthquakeAmethi()
    local AmethiWalls = {}
    for i = 1, 3 do
        for _, ID in ipairs{ Logic.GetEntitiesOfCategoryInTerritory( 13, 2, EntityCategories.Wall, #AmethiWalls ) } do
            table.insert( AmethiWalls, ID )
        end
    end
    Event_AddEarthquake( {2}, 12, {}, { [2] = AmethiWalls } )
end

function Quest_ActivateAmethiRebuild()
  	AICore.SetNumericalFact( 2, "BARB", 1 )
end

function Quest_AddMercsToAmethi()
    local PlayerID = 2
	local TraderID = Logic.GetStoreHouse(PlayerID)
	AddMercenaryOffer( TraderID, 2, Entities.U_MilitaryBandit_Melee_AS )
	AddMercenaryOffer( TraderID, 2, Entities.U_MilitaryBandit_Ranged_AS )
    -- Hack to force a menu update
    Logic.ExecuteInLuaLocalState("GameCallback_CloseNPCInteraction(1, Logic.GetStoreHouse("..PlayerID.."))")
    
    local x, y = Logic.GetBuildingApproachPosition( TraderID )
    
    for _ = 1, 3 do Logic.CreateBattalionOnUnblockedLand(Entities.U_MilitaryBandit_Melee_AS, x, y, 0, 1, 3) end
    for _ = 1, 3 do Logic.CreateBattalionOnUnblockedLand(Entities.U_MilitaryBandit_Ranged_AS, x, y, 0, 1, 2) end
end

function Quest_PreventSignalFiresBurning()
    if #GetNonBurningSignalsTable() == 0 then
        return false
    end
end

function Quest_TryToLightSignalFire()
    local IDs = GetNonBurningSignalsTable()

    if #IDs > 0 then
--        local Rnd = GetRandom( #IDs ) + 1
        local Rnd = 1   -- Fixed order
        assert( Rnd > 0 and Rnd <= #IDs )
     
        AddResourcesToPlayer( Goods.G_Wood, 9, 4 )
        Logic.ExecuteInLuaLocalState( (string.format( "GUI.ExecuteObjectInteraction(%d, 4)", IDs[Rnd] )) )
        g_SignalCartSpawned = true
    end
end

g_SignalCarts = {}
function MapCallback_SettlerSpawned( _PlayerID, _EntityID )

    if g_SignalCartSpawned and _PlayerID == 4 and Logic.GetEntityType( _EntityID ) == Entities.U_ResourceMerchant then
        table.insert( g_SignalCarts, _EntityID )
    end

end

function CheckFoundCarts()
    for _, ID in ipairs( g_SignalCarts ) do
        -- Might be a cart for the signal fires
        if Logic.IsEntityAlive(ID) then
            local goodType, goodAmount = Logic.GetMerchantCargo(ID)
            if goodType == Goods.G_Wood and goodAmount == 9 then
                -- Ok, this should be it.
                g_SignalCartSpawned = false
                local x, y = Logic.GetEntityPosition(ID)
           
                g_CartGuard = Logic.CreateBattalionOnUnblockedLand( Entities.U_MilitarySword, x, y, 0, 4, 0 )    
                Logic.GroupGuard(g_CartGuard, ID)

                AICore.HideEntityFromAI( 4, g_CartGuard, true )
                
                g_CurrentSignalCart = ID
            end
        end
    end
    g_SignalCarts = {}
end

function MapCallback_EntityCaptured( _OldEntityID, _OldEntityPlayerID, _NewEntityID, _NewEntityPlayerID )
    if g_CurrentSignalCart and _OldEntityID == g_CurrentSignalCart then
    --[[
        local Guards = Logic.GetGuardianEntityID( g_CurrentSignalCart )
        if Guards and Guards > 0 then
            Logic.GroupDefend( Guards )
        end
        ]]
        Logic.HurtEntity( _NewEntityID, Logic.GetEntityHealth( _NewEntityID ) )
    end
end


function GetNonBurningSignalsTable()
    local IDs = {}
    for i = 1, 3 do
        local ID = Logic.GetEntityIDByName( "SignalFire" .. i )
        local Type = Logic.GetEntityType( ID )
        local TypeName = Logic.GetEntityTypeName( Type )
        if TypeName == "I_X_SignalFire_Base" then
            table.insert( IDs, ID )
        end
    end
    return IDs
end

function SetSignalFireUsableByKhana( _Name )
    g_FiresBurning = g_FiresBurning - 1

    local ID = assert( Logic.GetEntityIDByName( _Name ) )

    Logic.InteractiveObjectSetAvailability( ID, true )
    Logic.InteractiveObjectSetPlayerState( ID, 1, 2 )
    Logic.InteractiveObjectSetPlayerState( ID, 4, 1 )
    Logic.InteractiveObjectSetTimeToOpen( ID, 0 )

    Logic.InteractiveObjectClearCosts( ID )
    Logic.InteractiveObjectAddCosts( ID, Goods.G_Wood, 9 )
    Logic.InteractiveObjectSetCostResourceCartType( ID, Entities.U_ResourceMerchant )
    
    Logic.InteractiveObjectClearRewards( ID )
    
    Logic.InteractiveObjectSetReplacingEntityType( ID, Entities.I_X_SignalFire_Fire )
    Logic.InteractiveObjectSetReplacingEntityName( ID, _Name )
end

function SetSignalFireUsableByPlayer( _Name )
    g_FiresActivatedTotal = g_FiresActivatedTotal + 1
    g_FiresBurning = g_FiresBurning + 1


    local ID = assert( Logic.GetEntityIDByName( _Name ) )

    Logic.InteractiveObjectSetAvailability( ID, true )
    Logic.InteractiveObjectSetPlayerState( ID, 1, 0 )
    Logic.InteractiveObjectSetPlayerState( ID, 4, 2 )
    Logic.InteractiveObjectSetTimeToOpen( ID, 0 )

    Logic.InteractiveObjectClearCosts( ID )
    Logic.InteractiveObjectAddCosts( ID, Goods.G_Water, 10 )
    Logic.InteractiveObjectSetCostResourceCartType( ID, Entities.U_ResourceMerchant )
    
    Logic.InteractiveObjectClearRewards( ID )
    
    Logic.InteractiveObjectSetReplacingEntityType( ID, Entities.I_X_SignalFire_Base )
    Logic.InteractiveObjectSetReplacingEntityName( ID, _Name )
    
    -- Set the cart guardians to defend mode and capture other carts
    if g_CartGuard and Logic.IsEntityAlive( g_CartGuard ) then
        Logic.GroupDefend( g_CartGuard )
         
        local AIPlayerID = Logic.EntityGetPlayer( g_CartGuard )
        local ArmyID = AICore.CreateArmy(AIPlayerID)
        AICore.AddEntityToArmy(AIPlayerID, ArmyID, g_CartGuard)
        local AreaID = AICore.CreateAD()
        AICore.AD_AddEntity(AreaID, g_CartGuard, 3000)
        AICore.StartAttackWithPlanProtectArea( AIPlayerID, ArmyID, AreaID, -1, true )
        
        g_CartGuard = nil
    end
end

function Quest_KhanaActivatedFire1()
    SetSignalFireUsableByPlayer( "SignalFire1" )
end

function Quest_KhanaActivatedFire2()
    SetSignalFireUsableByPlayer( "SignalFire2" )
end

function Quest_KhanaActivatedFire3()
    SetSignalFireUsableByPlayer( "SignalFire3" )
end

function Quest_PlayerQuenchedFire1()
    SetSignalFireUsableByKhana( "SignalFire1" )
end

function Quest_PlayerQuenchedFire2()
    SetSignalFireUsableByKhana( "SignalFire2" )
end

function Quest_PlayerQuenchedFire3()
    SetSignalFireUsableByKhana( "SignalFire3" )
end

function Quest_SpawnKnight1()
    g_SupportKnights = {}
    
    SpawnAndMoveKnight(1)
    SpawnSupportTroops( 4, 1 )
    
    StartSimpleJob( "CheckDeadKnights" )
end

function Quest_SpawnKnight2()
    SpawnAndMoveKnight(2)
    SpawnSupportTroops( 2, 2 )
end

function Quest_SpawnKnight3()
    SpawnAndMoveKnight(3)
    -- TODO: Make adaptive
    SpawnSupportTroops( 3, 3 )
end

function Quest_SpawnKnight4()
    --SpawnAndMoveKnight(4) -- Ooops, no knight left
    -- TODO: Make adaptive
    SpawnSupportTroops( 2, 2 )
end

function SpawnAndMoveKnight( _Number )
    assert( _Number > 0 )
    assert( _Number <= #g_UnusedKnights )
    
    local Entry = g_UnusedKnights[_Number]
    local SpawnX, SpawnY = Logic.GetEntityPosition( Logic.GetEntityIDByName( "Knight1Spawn" ) )
    local KnightID = Logic.CreateEntityOnUnblockedLand( Entry.Type, SpawnX, SpawnY, 0, _Number + 4 )
    
    local CastleX, CastleY = Logic.GetBuildingApproachPosition( Logic.GetMarketplace( 1 ) )
    Logic.GroupAttackMove( KnightID, CastleX - 1000 + Logic.GetRandom(2000), CastleY - 1000 + Logic.GetRandom(2000), -1 )
    
    g_SupportKnights[KnightID] = true
end

function SpawnSupportTroops( _Sword, _Bow )
    local CastleX, CastleY = Logic.GetBuildingApproachPosition( Logic.GetHeadquarters( 1 ) )
    local X, Y = Logic.GetEntityPosition( Logic.GetEntityIDByName( "Knight1Spawn" ) )
    for i = 1, _Sword do
        local EntityID = Logic.CreateBattalionOnUnblockedLand( Entities.U_MilitarySword, X, Y, 0, 1 );
        Logic.GroupAttackMove( EntityID, CastleX, CastleY, -1 )
    end
    for i = 1, _Bow do
        local EntityID = Logic.CreateBattalionOnUnblockedLand( Entities.U_MilitaryBow, X, Y, 0, 1 );
        Logic.GroupAttackMove( EntityID, CastleX, CastleY, -1 )
    end
    
    -- Send gold support, so the soldiers won't deplete the players gold reserves
    -- Needs support for 5 months, 6 soldiers per squad, each soldier requires 2 gold on normal payment mode
--    local Payment = 5 * ( _Sword + _Bow ) * 6 * 2
    -- Actually this doesn't seem to be enough, so pay *all* soldiers the player has for 4 months
    local Payment = math.floor( 4 * (Logic.GetCurrentSoldierCount(1) / 6) * 2 )
    local CartID = Logic.CreateEntity( Entities.U_GoldCart, X, Y, 0, 1 )
    Logic.HireMerchant( CartID, 1, Goods.G_Gold, Payment, 1 )
        
end

function CheckDeadKnights()
    for KnightID, Status in pairs( g_SupportKnights ) do
        if Status then
            if Logic.KnightGetResurrectionProgress(KnightID) ~= 1 then
                -- Was alive and died
                g_SupportKnights[KnightID] = false
            end
        else
            -- Dead
            if Logic.KnightGetResurrectionProgress(KnightID) == 1 then
                -- Back to live
                g_SupportKnights[KnightID] = true
                
                -- Get back to the players city
                local CastleX, CastleY = Logic.GetBuildingApproachPosition( Logic.GetMarketplace( 1 ) )
                Logic.GroupAttackMove( KnightID, CastleX - 1000 + Logic.GetRandom(2000), CastleY - 1000 + Logic.GetRandom(2000), -1 )
            end
        end
    end
end

function Quest_KhanaAttackWaves()
    
    g_KhanaWave = g_KhanaWave + 1
    -- Calc troops
    local NumSword, NumBow
    if g_KhanaWave == 1 then
        NumSword, NumBow = 3, 2
    elseif g_KhanaWave == 2 then
        NumSword, NumBow = 4, 2
    elseif g_KhanaWave == 3 then
        NumSword, NumBow = 3, 3
    elseif g_KhanaWave == 4 then
        NumSword, NumBow = 5, 4
    else
        local NumPlayerSoldiers = Logic.GetCurrentSoldierCount(1) / 6
        NumSword = math.floor( NumPlayerSoldiers * 0.2 )
        NumBow = math.floor( NumPlayerSoldiers * 0.3 )
        if NumSword + NumBow < 6 then
            NumSword, NumBow = 4, 2
        end
    end
    
    -- Check Wall
    local ID1 = Logic.GetHeadquarters(1)
    local ID2 = Logic.GetHeadquarters(4)
    local Sector1 = Logic.GetPlayerSectorAtPosition( 4, Logic.GetBuildingApproachPosition( ID1 ) )
    local Sector2 = Logic.GetPlayerSectorAtPosition( 4, Logic.GetBuildingApproachPosition( ID2 ) )
    local HasWall = Sector1 ~= Sector2
    
    -- Spawn troops and attack
    assert( NumSword and NumSword > 0 )
    assert( NumBow and NumBow > 0 )
    AIScript_SpawnAndAttackCity( 4, ID1, ID2, NumSword, NumBow, HasWall and 1 or 0, 0, HasWall and 1 or 0, 0, 3, true)
        
end

function Mission_Callback_AIOnArmyDisbanded(_PlayerID, _ArmyID)
    if _PlayerID == 4 then
        if g_KhanaFinalAttackOnPlayerArmyID and _ArmyID == g_KhanaFinalAttackOnPlayerArmyID then
            g_KhanaFinalAttackOnPlayerFailed = true

        elseif g_AmethiArmy1 and _ArmyID == g_AmethiArmy1 then
            g_AmethiAttackFailed1 = true
            
        elseif g_AmethiArmy2 and _ArmyID == g_AmethiArmy2 then
            g_AmethiAttackFailed2 = true
            
        end
    end
end


function Quest_KhanaFinalAttack()
    local SpawnID = assert(Logic.GetEntityIDByName("SpawnAmethiAttack"))
    g_KhanaFinalAttackOnPlayerArmyID, Troops = AIScript_SpawnAndAttackCity(4, Logic.GetHeadquarters(1), SpawnID, 6, 6, 1, 1, 1, 1, 3, true)
    
    -- Khana joins the attack
    local SpawnX, SpawnY = Logic.GetEntityPosition(SpawnID)
    g_KhanaID = Logic.CreateEntityOnUnblockedLand( Entities.U_KnightKhana, SpawnX, SpawnY, 0, 4 )
    AICore.HideEntityFromAI( 4, g_KhanaID, true )
    local GuardID = Logic.CreateBattalionOnUnblockedLand( Entities.U_MilitarySword_Khana, SpawnX, SpawnY, 0, 4 )
    AICore.HideEntityFromAI( 4, GuardID, true )
    Logic.GroupGuard( GuardID, g_KhanaID )
    
    g_KhanaTroops = Troops
    StartSimpleJob( "KhanaFollowTroops" )
end

function KhanaFollowTroops()

    if Logic.IsEntityDestroyed( g_KhanaID ) then
        return true
    end
    
    if not g_CurrentTroopKhanaFollows or Logic.IsEntityDestroyed( g_CurrentTroopKhanaFollows ) then
        for _, ID in ipairs( g_KhanaTroops ) do
            if Logic.IsEntityAlive( ID ) then
                g_CurrentTroopKhanaFollows = ID
                break
            end
        end
    end
    
    if not g_CurrentTroopKhanaFollows or Logic.IsEntityDestroyed( g_CurrentTroopKhanaFollows ) or Logic.GetEntityHealth(g_KhanaID) < Logic.GetEntityMaxHealth(g_KhanaID)/2 then
        Move( g_KhanaID, Logic.GetHeadquarters(4) )    -- Army is gone or health is low, retreat to HQ
        AICore.HideEntityFromAI( 4, g_KhanaID, false )
        return true
    end
    
    Move( g_KhanaID, g_CurrentTroopKhanaFollows )
    
end

function Quest_CheckKhanaFinalAttackFailed()
    return g_KhanaFinalAttackOnPlayerFailed
end

function Quest_AmethiAttack()
    g_AmethiArmy1 = AIScript_SpawnAndAttackCity(4, Logic.GetStoreHouse(2), assert(Logic.GetEntityIDByName("SpawnAmethiAttack")), 2, 1, 1, 0, 0, 1, 3, true)
    g_AmethiArmy2 = AIScript_SpawnAndRaidSettlement(4, Logic.GetStoreHouse(2), assert(Logic.GetEntityIDByName("SpawnAmethiAttack")), 8000, 1, 1, 3, true )
end

function Quest_CheckAmethiAttackFailed()
    if g_AmethiAttackFailed1 and g_AmethiAttackFailed2 then
        return true
    end
end

function Mission_Callback_AIShouldRebuild(_PlayerID, _BuildingType, _X, _Y)
    return _BuildingType ~= Entities.B_KhanaTemple
end

function Quest_MoveOutPraphat()

    local PraphatPlayerID = 3
    local DestID = Logic.GetEntityIDByName("PraphatDest")
    assert( DestID and DestID > 0 )
    local X, Y = Logic.GetEntityPosition( DestID )
    
    g_PraphatSoldiers = { Logic.GetPlayerEntitiesInCategory( PraphatPlayerID, EntityCategories.Military ) }
    for _, ID in ipairs( g_PraphatSoldiers ) do
        AICore.HideEntityFromAI( PraphatPlayerID, ID, true )
        Logic.MoveSettler( ID, X, Y )
    end
    
    StartSimpleJob( "CheckPraphatMovedOut" )
end

function CheckPraphatMovedOut()
    for i = #g_PraphatSoldiers, 1, -1 do
        local ID = g_PraphatSoldiers[i]
        if Logic.IsEntityDestroyed( ID ) then
            table.remove( g_PraphatSoldiers, i )
        elseif IsNear( ID, "PraphatDest", 500 ) then
            Logic.DestroyEntity( ID )
        end
    end
    
    return #g_PraphatSoldiers == 0
end

function Quest_CheckFirstFireBurning()
    if g_FiresActivatedTotal == 1 then
        return true
    end
end

function Quest_CheckAnotherFireBurningAlone()
    -- True if a single fire is burning that is not the first fire
    if g_FiresActivatedTotal > 1 and g_FiresBurning == 1 then
        return true
    end
end

function Quest_CheckTwoFiresBurning()
    -- True if two fires are burning at the same time
    if g_FiresBurning == 2 then
        return true
    end
end

function Quest_CheckIfNoFireIsBurning()
    -- True if no fire is burning
    if g_FiresBurning == 0 then
        return true
    end
end

function Quest_CheckMonsoonNextMonth()
    local CurrentMonth = Logic.GetCurrentMonth()    
    local NextMonth    = CurrentMonth + 1
    
    if NextMonth > 12 then
        NextMonth = 1
    end
    
    if not Logic.GetWeatherDoesShallowWaterFloodByMonth(NextMonth) and ( not Logic.GetWeatherDoesShallowWaterFloodByMonth(CurrentMonth)
        or Logic.GetMonthSeconds() / Logic.GetMonthDurationInSeconds() > 0.7 ) then
        return true
    end
end

function Quest_AdaptFinalAttackToMonsoon()

    -- HACK to update the quest timer so the attacks won't occur during monsoon
    local QuestID = assert(g_QuestNameToID["Q_20_Khana_KhanaWarning"])
    local Quest = assert(Quests[QuestID])
    local QuestDelay = assert(Quest.Duration)
    assert(QuestDelay > 0)
    
    -- The attack should usually occur in 20 minutes
    local CurrentMonth = Logic.GetCurrentMonth()
    local MonthDuration = Logic.GetMonthDurationInSeconds()

    local CurrentTime = CurrentMonth * MonthDuration + Logic.GetMonthSeconds()
    assert( CurrentTime >= 0 )

    local function AddSeconds( _Current, _Add )
        local MonthDuration = Logic.GetMonthDurationInSeconds()
        
        local CalcTime = _Current + _Add
        while CalcTime > 12 * MonthDuration do
            CalcTime = CalcTime - ( 12 * MonthDuration )
        end
        assert( CalcTime >= 0 )
        
        return CalcTime
    end

    local AttackTime = AddSeconds( CurrentTime, QuestDelay )
    local SecondsDiffAbsolute = QuestDelay
    
    local AbortCounter = 0
    while Logic.GetWeatherDoesShallowWaterFloodByMonth(math.floor(AttackTime / MonthDuration)) 
        or Logic.GetWeatherDoesShallowWaterFloodByMonth(math.floor((AttackTime + MonthDuration) / MonthDuration))
        or Logic.GetWeatherDoesShallowWaterFloodByMonth(math.floor((AttackTime + (MonthDuration * 2)) / MonthDuration)) do
        AttackTime = AddSeconds( AttackTime, 30 )
        SecondsDiffAbsolute = SecondsDiffAbsolute + 30
        AbortCounter = AbortCounter + 1
        if AbortCounter > 13 then
            -- This should never happen
            SecondsDiffAbsolute = QuestDelay
            break
        end
    end
    
    Quest.Duration = SecondsDiffAbsolute

--    Logic.DEBUG_AddNote( string.format( "Current time %d, month %2.1f. Attack time %d, month %2.1f. Total Seconds: %d", CurrentTime, CurrentTime / MonthDuration, AttackTime, AttackTime / MonthDuration, SecondsDiffAbsolute ) )

end

function Quest_LimitKhanasMilitary()

    AICore.SetNumericalFact( 4, "BPMX", 0 )
    AICore.SetNumericalFact( 4, "FMSM", 5 )
    AICore.SetNumericalFact( 4, "FMBM", 5 )
    AICore.SetNumericalFact( 4, "FMCA", 1 )
    AICore.SetNumericalFact( 4, "FMRA", 1 )
    AICore.SetNumericalFact( 4, "FMST", 1 )
    AICore.SetNumericalFact( 4, "FMAC", 2 )

end

g_ArrivedCounter = 0
function FrogmarchKhana()

    if (g_KhanaEntityID == nil) then
        return
    end
    
    if (Logic.GetGuardianEntityID(g_KhanaEntityID) > 0) then    
        g_ArrivedCounter = g_ArrivedCounter + 1
    end

    if (g_ArrivedCounter == 30) then
        Move(g_KhanaEntityID, "BattalionPos")
    end
    
end

function Mission_VictoryCutscene()

    local AmethiID = 2
    local KahnaID = 4
    local SecondKnightID = 8    

    SetFriendly(1, KahnaID)
    SetFriendly(AmethiID, KahnaID)
    SetFriendly(SecondKnightID, KahnaID)
    
    do
        local X, Y = Logic.GetEntityPosition(Logic.GetEntityIDByName( "KnightPos" ))        
        local Ori =Logic.GetEntityOrientation(Logic.GetEntityIDByName( "KnightPos" ))
        VictorySetEntityToPosition(Logic.GetKnightID(1), X, Y, Ori)
    end

    do
        local X, Y = Logic.GetEntityPosition(Logic.GetEntityIDByName( "KahnaPos" ))        
        local Ori =Logic.GetEntityOrientation(Logic.GetEntityIDByName( "KahnaPos" ))
        g_KhanaEntityID = Logic.CreateEntityOnUnblockedLand(Entities.U_KnightKhana, X, Y, Ori-90, KahnaID)
        AICore.HideEntityFromAI( KahnaID, g_KhanaEntityID, true )
    end
 
    do        
        local SecondKnight = Entities.U_KnightSaraya
        SarayaPlayerID = SecondKnightID
        KnightID = 1
        Logic.ExecuteInLuaLocalState([[SetupPlayer(8, "H_Knight_Saraya", "Saraya")]])

        if (Logic.GetEntityType(Logic.GetKnightID(1)) == SecondKnight) then
            SecondKnight = Entities.U_KnightChivalry  
            Logic.ExecuteInLuaLocalState([[SetupPlayer(8, "H_Knight_Chivalry", "Marcus")]])
            SarayaPlayerID = 1
            KnightID = SecondKnightID
        end
                
        local X, Y = Logic.GetEntityPosition(Logic.GetEntityIDByName( "SecondKnight" ))
        local Ori =Logic.GetEntityOrientation(Logic.GetEntityIDByName( "SecondKnight" ))
        Logic.CreateEntityOnUnblockedLand(SecondKnight, X, Y, Ori-90, SecondKnightID)
    end
 
    do
        local X, Y = Logic.GetEntityPosition(Logic.GetEntityIDByName("VillagerPos" ))
        local Ori =Logic.GetEntityOrientation(Logic.GetEntityIDByName( "VillagerPos" ))
        Logic.CreateEntityOnUnblockedLand(Entities.U_NPC_Villager01_AS, X, Y, Ori-90, AmethiID)
    end

    -- it is difficult to time when the battalion has to leave with kahna because you dont know when a text has been spoken
    do        
        local X, Y = Logic.GetEntityPosition(Logic.GetEntityIDByName( "BattalionPos" ))                
        local Battalion = Logic.CreateBattalionOnUnblockedLand(Entities.U_MilitarySword, X, Y, 0, 1, 9)                       
        Logic.GroupGuard(Battalion, g_KhanaEntityID)    

        StartSimpleJob("FrogmarchKhana")
    end
          
          
    GenerateVictoryDialog(
        {
            {KahnaID,           "Victory1_KhanaDefeated"}, 
            {KnightID,          "Victory2_Knight"}, 
            {SarayaPlayerID,    "Victory3_Saraya"}, 
            {KahnaID,           "Victory4_KhanaLeaves"}, 
            {AmethiID,          "Victory5_AmethiAntidote"}, 
        })
    
   Logic.ExecuteInLuaLocalState("Mission_LocalVictory()")

    
end


function Mission_DefeatCutscene_MahpurDestroyed()

    GenerateDefeatDialog( {{ 1, "Defeat_MahpurDestroyed" }} )

end

function Mission_DefeatCutscene_AmethiDestroyed()

     GenerateDefeatDialog( {{ 1, "Defeat_AmethiDestroyed" }} )

end
