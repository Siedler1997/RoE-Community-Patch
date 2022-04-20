CurrentMapIsCampaignMap = true

----------------------------------------------------------------------------------------------------------------------
function Mission_InitPlayers()
	    
end
----------------------------------------------------------------------------------------------------------------------
function Mission_SetStartingMonth()

    Logic.SetMonthOffset(1)

end
----------------------------------------------------------------------------------------------------------------------
function Mission_InitMerchants()

    -- Kurumdi
    local PlayerID = 2
	local TraderID = Logic.GetStoreHouse(PlayerID)
	AddOffer( TraderID, 2, Goods.G_Olibanum )

end


function Quest_CheckSoldiersNearP4()
    local X, Y = Logic.GetEntityPosition( Logic.GetEntityIDByName( "expedition_point_04" ) )
    if Logic.GetPlayerEntitiesInArea( 1, Entities.U_MilitarySword, X, Y, 2000, 16 ) >= 16 then
        return true
    end
end

function Quest_SpawnPraphatExpedition()
    SpawnExpeditionAt( "checkpoint_01" )
    
    -- Also keep the enemy expedition visible
    Logic.SetShareExplorationWithPlayerFlag( 1, 3, 1 )
end

function Quest_MovePraphatExpeditionTo2a()
    MoveExpeditionTo( "checkpoint_02a" )
end

function Quest_CheckExpeditionAt2a()
    if CheckExpeditionAt( "checkpoint_02a" ) then
        RemoveExpedition()
        return true
    end
end

function Quest_RespawnPraphatExpeditionAt2b()
    SpawnExpeditionAt( "checkpoint_02b" )
    MoveExpeditionTo( "checkpoint_03a" )
end

function Quest_CheckExpeditionAt3a()
    if CheckExpeditionAt( "checkpoint_03a" ) then
        RemoveExpedition()
        return true
    end
end

function Quest_RespawnPraphatExpeditionAt3b()
    SpawnExpeditionAt( "checkpoint_03b" )
    MoveExpeditionTo( "checkpoint_04" )
end

function Quest_CheckExpeditionAt4()
    if CheckExpeditionAt( "checkpoint_04" ) then
        return true
    end
end

function Quest_TriggerSnowSlide()
    -- Nah, its not that easy ;-)
    --Logic.ExecuteInLuaLocalState( (string.format( "GUI.ExecuteObjectInteraction(%d, 3)", Logic.GetEntityIDByName("snowslide") )) )
    
    local x,y = Avalanche.X, Avalanche.Y
    local type = EGL_Effects.E_NE_Avalanche_Anim
    local orientation = Avalanche.Orientation
    
    Avalanche.EffectID = Logic.CreateEffectWithOrientation(type, x,y,orientation,0)
    Avalanche.StartTime = Logic.GetTimeMs()
    
    StartSimpleJob("ReplaceObjectAfterEffect")
end

function Quest_MovePraphatExpeditionTo5()
    MoveExpeditionTo( "checkpoint_05" )
    
end


function ReplaceObjectAfterEffect()

    if Avalanche.Deleted == nil  and Logic.GetTimeMs() >= Avalanche.StartTime + 1 then
        Logic.DestroyEntity(Logic.GetEntityIDByName("snowslide"))
        Avalanche.Deleted = true
    end

    if Logic.GetTimeMs() >= Avalanche.StartTime + 5600 then
        
        Logic.DestroyEffect(Avalanche.EffectID )

        
        local Type = Entities.D_NE_Avalanche_Broken
        local CreatingPlayerID = 0
        local BeamToX, BeamToY = Logic.GetEntityPosition(Logic.GetEntityIDByName("behindAvalanche"))
        local BeamToX, BeamToY = 0,0

        Logic.OnAvalancheLaunched(Type, Avalanche.X, Avalanche.Y, Avalanche.Orientation, CreatingPlayerID, BeamToX, BeamToY)
        
        --kill the Job
        return true
        
    end
    
end

function Quest_CheckExpeditionAt5()
    if CheckExpeditionAt( "checkpoint_05" ) then
        return true
    end
end

function Quest_MovePraphatExpeditionToTreasure()
    MoveExpeditionTo( "treasure" )
end

function Quest_CheckExpeditionAtTreasure()
    if CheckExpeditionAt( "treasure" ) then
        return true
    end
end

function SpawnExpeditionAt( _Name )
    local SpawnID = assert( Logic.GetEntityIDByName( _Name ) )
    local X, Y = Logic.GetEntityPosition( SpawnID )
    if Logic.IsBuilding( SpawnID ) == 1 then
        X, Y = Logic.GetBuildingApproachPosition( SpawnID )
    end
    
    g_PraphatAdd = {}
    table.insert( g_PraphatAdd, Logic.CreateBattalionOnUnblockedLand( Entities.U_MilitarySword_Khana, X, Y, 0, 3, 0 ) )
    table.insert( g_PraphatAdd, Logic.CreateBattalionOnUnblockedLand( Entities.U_MilitarySword_Khana, X, Y, 0, 3, 0 ) )
    table.insert( g_PraphatAdd, Logic.CreateBattalionOnUnblockedLand( Entities.U_MilitaryBow_Khana, X, Y, 0, 3, 0 ) )
end

function MoveExpeditionTo( _Name )
    local ID = assert( Logic.GetEntityIDByName( _Name ) )
    local X, Y = Logic.GetEntityPosition( ID )
    if Logic.IsBuilding( ID ) == 1 then
        X, Y = Logic.GetBuildingApproachPosition( ID )
    end
    
    if g_PraphatAdd then
        for _, TroopID in ipairs( g_PraphatAdd ) do
            if Logic.IsEntityAlive( TroopID ) then    
                Logic.MoveSettler( TroopID, X, Y )
            end
        end
    end
end

function CheckExpeditionAt( _Name )
    local ID = assert( Logic.GetEntityIDByName( _Name ) )
    if g_PraphatAdd then
        for _, TroopID in ipairs( g_PraphatAdd ) do
            if Logic.IsEntityAlive( TroopID ) then    
                if IsNear( TroopID, ID, 400 ) then
                    return true
                end
            end
        end
    end
end

function RemoveExpedition()
    assert( g_PraphatAdd )
    for _, TroopID in ipairs( g_PraphatAdd ) do
        assert( Logic.IsEntityAlive( TroopID ) )
        Logic.DestroyEntity(TroopID)
    end
end

function Quest_CheckExpeditionTroopsDead()
    if g_PraphatAdd then
        for _, TroopID in ipairs( g_PraphatAdd ) do
            if Logic.IsEntityAlive( TroopID ) then    
                return
            end
        end
    end
    
    return true
end


function Quest_DetonatorBreakWall()
    for _, ID in ipairs{ Logic.GetEntitiesOfCategoryInTerritory( 11, -1, EntityCategories.Wall ) } do
        Logic.HurtEntity( ID, Logic.GetEntityHealth( ID ) )
        local Ex, Ey = Logic.GetEntityPosition( ID )
        Logic.CreateEffect(EGL_Effects.FXCrushBuildingFloor, Ex,Ey,0)
    end
end

function Quest_FoundGem1()
    SpawnGemCart(1)
end

function Quest_FoundGem2()
    SpawnGemCart(2)
end

function Quest_FoundGem3()
    SpawnGemCart(3)
end

function SpawnGemCart( _Nr )
    local SpawnID = Logic.GetEntityIDByName("SpawnGemCart" .. _Nr)
    assert( SpawnID and SpawnID > 0 )
    local SpawnX, SpawnY = Logic.GetEntityPosition(SpawnID)
    local CartID = Logic.CreateEntityOnUnblockedLand( Entities.U_ResourceMerchant, SpawnX, SpawnY, 0, 2 )
    Logic.HireMerchant( CartID, 2, Goods.G_Gems, 1, 2 )
end

function Quest_CheckSoldiersClimbedWall()
    local X, Y = Logic.GetEntityPosition( assert( Logic.GetEntityIDByName( "walltrigger_02" ) ) )
    if Logic.GetPlayerEntitiesInArea( 1, Entities.U_MilitarySword, X, Y, 1250, 1 ) > 0 then
        
        return true
    end
end

function Quest_UnlockSiegeTower()
--    EndJob( "g_LockSiegeWeaponsJob" )
    UnLockFeaturesForPlayer( 1, Technologies.R_SiegeEngineWorkshop )
end

function Mission_Callback_OverrideObjectInteraction( _ObjectID, _PlayerID, _Costs )
    assert( _PlayerID == 1 )
    assert( _ObjectID and _ObjectID > 0 and Logic.IsEntityAlive( _ObjectID ) )
    assert( _Costs and _Costs[1] and _Costs[2] )
    
    for i = 1, 3 do
        if _ObjectID == Logic.GetEntityIDByName( "expedition_point_0" .. i ) then
        
            local LastSupplierID = Logic.GetStoreHouse(1)   -- Default value, just in case...
            local AmountLeft = _Costs[2]

            for _, ID in ipairs{ Logic.GetPlayerEntitiesInCategory(_PlayerID, EntityCategories.CityBuilding) } do
                local NumberOfGoodTypes = Logic.GetNumberOfGoodTypesOnOutStock(ID)
                if NumberOfGoodTypes then
                    for i = 0, NumberOfGoodTypes-1 do        
                        local GoodType = Logic.GetGoodTypeOnOutStockByIndex(ID,i)
                        local Amount = Logic.GetAmountOnOutStockByIndex(ID, i)
                        if GoodType == _Costs[1] and Amount > 0 then
                            LastSupplierID = ID
                            
                            local AmountUsed = AmountLeft > Amount and Amount or AmountLeft
                            Logic.RemoveGoodFromStock(ID, GoodType, AmountUsed, false)
                            
                            AmountLeft = AmountLeft - AmountUsed
                            assert( AmountLeft >= 0 )
                            if AmountLeft == 0 then
                                break
                            end
                        end
                    end
                end
            end

        
            local CartX, CartY = Logic.GetBuildingApproachPosition( LastSupplierID )
            CartID = Logic.CreateEntity( Entities.U_ResourceMerchant, CartX, CartY, 0, 1 )
            Logic.HireMerchant( CartID, 1, _Costs[1], _Costs[2], 1, true )

            Logic.InteractiveObjectAttachDeliveryCart( _ObjectID, CartID )
            return true
            
        end
    end
end

function Quest_DeactivateSoldierMarker()
    Logic.DestroyEffect(g_Marker)
end

function Quest_DeactivateWeatherEvent()
    Logic.DeactivateWeatherEvent()
end

function LockSiegeWeapons()
    if Logic.TechnologyGetState( 1, Technologies.R_SiegeEngineWorkshop ) ~= TechnologyStates.Unlocked then
        Logic.TechnologySetState( 1, Technologies.R_SiegeEngineWorkshop, TechnologyStates.Unlocked )
    end
end

function Quest_ShareExplorationWithDario()
    -- Don't need to see that dario wall
    -- But there is an outpost, so it doesn't matter anyway
--    Logic.SetTerritoryPlayerID( 11, 0 )

    -- Share exploration with Dario
    Logic.SetShareExplorationWithPlayerFlag( 1, 4, 1 )
end

function Quest_FreezeWater()
    Logic.WeatherEventSetPrecipitationFalling(true)
    Logic.WeatherEventSetPrecipitationIsSnow(true)
    Logic.WeatherEventClearGoodTypesNotGrowing()
    Logic.WeatherEventAddGoodTypeNotGrowing(Goods.G_Grain)
    Logic.WeatherEventAddGoodTypeNotGrowing(Goods.G_Honeycomb)
    Logic.WeatherEventSetWaterFreezes(true)
    Logic.WeatherEventSetTemperature(-3)
    Logic.ActivateWeatherEvent()

end

----------------------------------------------------------------------------------------------------------------------
function Mission_FirstMapAction()

    -- init players in singleplayer games only
    if Framework.IsNetworkGame() ~= true then

        Startup_Player()
        Startup_StartGoods()
        Startup_Diplomacy()
        
        -- CP: Changed player colors to be more consistent
        Logic.PlayerSetPlayerColor(3 , 18, -1, -1)  --Kultisten: Hellgrün
        Logic.PlayerSetPlayerColor(4 , 17, -1, -1)  --Ruinen: Weiß
        Logic.PlayerSetPlayerColor(5 , 8, -1, -1)   --Kloster: Pink
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

    local TechologiesToLock = { Technologies.R_SiegeEngineWorkshop,
                                Technologies.R_BatteringRam,
                                Technologies.R_Catapult,
                                Technologies.R_Wealth,
                                Technologies.R_BarracksArchers,
                                Technologies.R_BowMaker,
                                Technologies.R_Ballista
                               }

    LockFeaturesForPlayer( 1, TechologiesToLock )
    
    
    LockTitleForPlayer(1, KnightTitles.Duke )
    
    for i = 1, 2 do
        local Name = "Catapult"..i
        local CartID = assert( Logic.GetEntityIDByName(Name) )
        local Orientation = Logic.GetEntityOrientation( CartID )
        local CartX, CartY = Logic.GetEntityPosition( CartID )
        Logic.DestroyEntity( CartID )
        CartID = Logic.CreateEntity( Entities.U_MilitaryCatapult, CartX, CartY, Orientation, 5 )
        Logic.SetEntityName( CartID, Name )
    end
    

    -- Set up expedition tents
    for _, Entry in ipairs{ { "expedition_point_01", Goods.G_Clothes }, { "expedition_point_02", Goods.G_Bread }, { "expedition_point_03", Goods.G_Sausage },} do
        local ID = assert(Logic.GetEntityIDByName(Entry[1]))
        Logic.InteractiveObjectClearCosts( ID )
        Logic.InteractiveObjectAddCosts( ID, Entry[2], 9 )
        Logic.InteractiveObjectSetCostResourceCartType( ID, Entities.U_ResourceMerchant )
        Logic.InteractiveObjectSetTimeToOpen( ID, 0 )
        Logic.InteractiveObjectSetDeactivateAfterUse( ID, true )
    end
    
    -- Redirect local callback to the logic callback to fake the good delivery to expedition tents
    Logic.ExecuteInLuaLocalState([[
    function Mission_Callback_OverrideObjectInteraction( _ObjectID, _PlayerID, _Costs )
        GUI.SendScriptCommand( string.format("Mission_Callback_OverrideObjectInteraction( %d, %d, { %d, %d } )", _ObjectID, _PlayerID, _Costs[1], _Costs[2] ), true )
    end
    ]])

    
    -- Other IOs
    local ID = assert(Logic.GetEntityIDByName("detonator"))
    Logic.InteractiveObjectClearCosts( ID )
    Logic.InteractiveObjectAddCosts( ID, Goods.G_Wood, 9 )
    Logic.InteractiveObjectSetCostResourceCartType( ID, Entities.U_ResourceMerchant )
    Logic.InteractiveObjectSetTimeToOpen( ID, 10 )
    Logic.InteractiveObjectSetInteractionDistance( ID, 1500 )
    Logic.InteractiveObjectSetDeactivateAfterUse( ID, true )
    
    local ID = assert(Logic.GetEntityIDByName("snowslide"))
    Logic.InteractiveObjectSetPlayerState( ID, 1, 2 )
    Logic.InteractiveObjectSetPlayerState( ID, 3, 1 )
    Logic.InteractiveObjectSetTimeToOpen( ID, 0 )
    Logic.InteractiveObjectClearCosts( ID )
    
    --save the data, to replace it later and to start an effect
    Avalanche ={}    
    Avalanche.X, Avalanche.Y = Logic.GetEntityPosition(ID)
    Avalanche.Orientation = Logic.GetEntityOrientation(ID)

    for i = 1, 3 do
        local ID = assert(Logic.GetEntityIDByName("hiddengem0"..i))
        Logic.InteractiveObjectClearCosts( ID )
        Logic.InteractiveObjectSetTimeToOpen( ID, 7 )
        Logic.InteractiveObjectSetInteractionDistance( ID, 2200 )
        Logic.InteractiveObjectSetDeactivateAfterUse( ID, true )
    end
    
    -- Highlight the soldier destination
    local X,Y = Logic.GetEntityPosition(assert(Logic.GetEntityIDByName("expedition_point_04")))
    g_Marker = Logic.CreateEffect( EGL_Effects.E_Questmarker_low, X, Y ,0 )
    
    -- Keep the river from freezing, so the player can't cross it early
    Logic.WeatherEventSetPrecipitationFalling(true)
    Logic.WeatherEventSetPrecipitationIsSnow(true)
    Logic.WeatherEventClearGoodTypesNotGrowing()
    Logic.WeatherEventAddGoodTypeNotGrowing(Goods.G_Grain)
    Logic.WeatherEventAddGoodTypeNotGrowing(Goods.G_Honeycomb)
    Logic.WeatherEventSetWaterFreezes(false)
    Logic.WeatherEventSetTemperature(0)
    Logic.ActivateWeatherEvent()
    
    Logic.DestroyEntity( Logic.GetEntityIDByName( "KnightDummy" ) )
    Logic.SetEntityName( Logic.GetKnightID(1), "KnightDummy" )

    -- Doesn't work - gui bug?
    --g_LockSiegeWeaponsJob = StartSimpleJob( "LockSiegeWeapons" )
    
    SetKnightTitle( 1, KnightTitles.Earl )
    
    --[[
    TODO:
    More dust when the wall is detonated?
    ]]
    
    --Mission_VictoryCutscene()
end


local MonkID = 2
local CultPriestID = 3

function Mission_VictoryCutscene()

    do
        local X, Y = Logic.GetEntityPosition(Logic.GetEntityIDByName( "KnightPos" ))        
        local Ori =Logic.GetEntityOrientation(Logic.GetEntityIDByName( "KnightPos" ))
        VictorySetEntityToPosition(Logic.GetKnightID(1), X, Y, Ori)
    end
 
    do
        local X, Y = Logic.GetEntityPosition(Logic.GetEntityIDByName( "MonkPos" ))
        local Ori =Logic.GetEntityOrientation(Logic.GetEntityIDByName( "MonkPos" ))
        Logic.CreateEntityOnUnblockedLand(Entities.U_NPC_Monk_NE, X, Y, Ori-90, MonkID)
    end
 
    do
        local X, Y = Logic.GetEntityPosition(Logic.GetEntityIDByName("TreasureCart" ))
        local Ori =Logic.GetEntityOrientation(Logic.GetEntityIDByName( "TreasureCart" ))
        Logic.CreateEntityOnUnblockedLand(Entities.U_ResourceMerchant, X, Y, Ori-90, 1)
    end
          
    GenerateVictoryDialog(
        {
            {CultPriestID, "Victory1_CultPriest"}, 
            {MonkID, "Victory2_Monk"},
            {1, "Victory3_Knight"},
        })
    
   Logic.ExecuteInLuaLocalState("Mission_LocalVictory()")

    
end

function Mission_DefeatCutscene_EstablishExpedition()

    GenerateDefeatDialog( {{ 1, "Defeat_EstablishExpedition" }} )

end

function Mission_DefeatCutscene_GetTreasureUnderPreasure()

     GenerateDefeatDialog( {{ CultPriestID, "Defeat_GetTreasureUnderPreasure" }} )

end

