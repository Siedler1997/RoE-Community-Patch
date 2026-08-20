CurrentMapIsCampaignMap = true

--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
function Mission_InitPlayers()

end


--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
function Mission_SetStartingMonth()

    Logic.SetMonthOffset(2)
	
end
--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
function Mission_InitMerchants()

    -- Forswapur
    local PlayerID = 4
	local TraderID = Logic.GetStoreHouse(PlayerID)
	AddOffer( TraderID, 1, Goods.G_Herb )
	AddOffer( TraderID, 1, Goods.G_Wool )

    local _, TradepostID = Logic.GetPlayerEntities( PlayerID, Entities.I_X_TradePostConstructionSite, 1, 0 )
    assert( TradepostID and TradepostID ~= 0 )
    Logic.TradePost_SetTradePartnerGenerateGoodsFlag(TradepostID, true)
    Logic.TradePost_SetTradePartnerPlayerID(TradepostID, PlayerID)
    -- WARNING: Be sure to update CheckFoundCarts() when some values/goods the player has to deliver are changed
    Logic.TradePost_SetTradeDefinition(TradepostID, 0, Goods.G_Grain, 20, Goods.G_Wool, 10)
    Logic.TradePost_SetTradeDefinition(TradepostID, 1, Goods.G_Milk, 20, Goods.G_Herb, 20)
    Logic.TradePost_SetTradeDefinition(TradepostID, 2, Goods.G_Grain, 20, Goods.G_Wood, 20)
    Logic.TradePost_SetTradeDefinition(TradepostID, 3, Goods.G_Milk, 20, Goods.G_Gems, 8)
    g_ForswapurTradePostID = TradepostID
    
    -- Farehar
    local PlayerID = 5
	local TraderID = Logic.GetStoreHouse(PlayerID)
	AddOffer( TraderID, 2, Goods.G_Stone )
	AddOffer( TraderID, 1, Goods.G_Milk )
	AddOffer( TraderID, 1, Goods.G_Iron )

    local _, TradepostID = Logic.GetPlayerEntities( PlayerID, Entities.I_X_TradePostConstructionSite, 1, 0 )
    assert( TradepostID and TradepostID ~= 0 )
    Logic.TradePost_SetTradePartnerGenerateGoodsFlag(TradepostID, true)
    Logic.TradePost_SetTradePartnerPlayerID(TradepostID, PlayerID)
    Logic.TradePost_SetTradeDefinition(TradepostID, 0, Goods.G_Wool, 10, Goods.G_Stone, 10)
    Logic.TradePost_SetTradeDefinition(TradepostID, 1, Goods.G_Honeycomb, 15, Goods.G_Milk, 20)
    Logic.TradePost_SetTradeDefinition(TradepostID, 2, Goods.G_Herb, 20, Goods.G_Iron, 10)
    Logic.TradePost_SetTradeDefinition(TradepostID, 3, Goods.G_Honeycomb, 15, Goods.G_MusicalInstrument, 9)
    Logic.TradePost_SetActiveTradeSlot(TradepostID, 0)
    
    -- Noribat
    local PlayerID = 6
	local TraderID = Logic.GetStoreHouse(PlayerID)
	AddOffer( TraderID, 3, Goods.G_Iron )
    
    local _, TradepostID = Logic.GetPlayerEntities( PlayerID, Entities.I_X_TradePostConstructionSite, 1, 0 )
    assert( TradepostID and TradepostID ~= 0 )
    Logic.TradePost_SetTradePartnerGenerateGoodsFlag(TradepostID, true)
    Logic.TradePost_SetTradePartnerPlayerID(TradepostID, PlayerID)
    Logic.TradePost_SetTradeDefinition(TradepostID, 0, Goods.G_Stone, 12, Goods.G_Iron, 9)
    Logic.TradePost_SetTradeDefinition(TradepostID, 1, Goods.G_Stone, 17, Goods.G_Iron, 15)
    Logic.TradePost_SetTradeDefinition(TradepostID, 2, Goods.G_Gems, 2, Goods.G_Olibanum, 5)
    Logic.TradePost_SetActiveTradeSlot(TradepostID, 0)

end
--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
function Mission_FirstMapAction()
    
    if Framework.IsNetworkGame() ~= true then

        Startup_Player()
        Startup_StartGoods()
        Startup_Diplomacy()
        
        -- CP: Changed player colors to be more consistent
        Logic.PlayerSetPlayerColor(2 , g_ColorIndex["BanditsColor2"], -1, -1)  --Praphat-Militär: Banditen-Orange
        Logic.PlayerSetPlayerColor(3 , g_ColorIndex["CityColor6"], -1, -1)   --Praphat-Stadt: Orange
        Logic.PlayerSetPlayerColor(4 , g_ColorIndex["CloisterColor2"], -1, -1)  --Forswapur: Türkis
        Logic.PlayerSetPlayerColor(8 , g_ColorIndex["BanditsColor3"], -1, -1)  --Banditen: Braun
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
    
    -- TODO: Doesn't to anything atm
    AICore.CreateAIPlayer( 2 )
    
    --Replace catapult
    local CartID = assert( Logic.GetEntityIDByName("CatapultCart") )
    local Orientation = Logic.GetEntityOrientation( CartID )
    local CartX, CartY = Logic.GetEntityPosition( CartID )
    Logic.DestroyEntity( CartID )
    CartID = Logic.CreateEntity( Entities.U_MilitaryCatapult, CartX, CartY, Orientation, 2 )
    Logic.SetEntityName( CartID, "CatapultCart" )
    
    -- Hide units to be catpured from AI, so they will hold their position
    AICore.HideEntityFromAI( 2, CartID, true )
    AICore.HideEntityFromAI( 2, assert( Logic.GetEntityIDByName("AmmunitionCart") ), true )
    
    -- Disable elder prison & clear costs
    local ID = Logic.GetEntityIDByName("Prison")
    Logic.InteractiveObjectSetPlayerState( ID, 1, 2 )
    Logic.InteractiveObjectSetAvailability( ID, false )   
    Logic.InteractiveObjectClearCosts( ID )
    Logic.InteractiveObjectSetTimeToOpen( ID, 3 )
    Logic.InteractiveObjectSetDeactivateAfterUse( ID, true )
    
    -- Disable cultist camp & clear costs
    local ID = Logic.GetEntityIDByName("abandonedCultistCamp")
    Logic.InteractiveObjectSetPlayerState( ID, 1, 2 )
    Logic.InteractiveObjectSetAvailability( ID, false )   
    Logic.InteractiveObjectClearCosts( ID )
    Logic.InteractiveObjectSetTimeToOpen( ID, 3 )
    Logic.InteractiveObjectSetInteractionDistance( ID, 1500 )
    Logic.InteractiveObjectSetDeactivateAfterUse( ID, true )
    
    -- Disable Rockfall
    local ID = Logic.GetEntityIDByName("FallingRock")
    Logic.InteractiveObjectSetPlayerState( ID, 1, 2 )
    Logic.InteractiveObjectSetAvailability( ID, false )
    
    -- No need to use that prison - the thief does it
    local ID = Logic.GetEntityIDByName("PrisonTroops")
    Logic.InteractiveObjectSetPlayerState( ID, 1, 2 )
    Logic.InteractiveObjectSetAvailability( ID, false )   
    
    
    MountOutpostWithArchers( "PraphatOutpost1" )
    
    g_CartsCaptureCount = 0

    -- Store the wall segments that need to be destroyed (at least one)
    g_WallInfo = {}
    local TerritoryID = GetTerritoryIDByName("Territory 18")
    assert( TerritoryID and TerritoryID > 0 )
    local NearWallID = Logic.GetEntityIDByName("NearWall2500")
    assert( NearWallID and NearWallID > 0 )
    local x, y = Logic.GetEntityPosition( NearWallID )
    assert( x and y )
    
    for k, v in pairs( Entities ) do
        if string.find( k, "^B_Wall.+_AS$" ) then
            for i, WallID in ipairs{ Logic.GetPlayerEntitiesInArea( 2, v, x, y, 2500, 16 ) } do
                if i > 1 then
                    table.insert( g_WallInfo, WallID )
                end
            end
        end
    end   
    
    StartSimpleJob( "KeepTigerContented" )
    StartSimpleJob( "PraphatTrade" )
            
    -- TODO:
--    Set/Handle Praphats tradeposts
--    Need to Interrupt all spawn quests when military destroyed?
--    Make P2 and P3 the same color
--    Check if P2 builds soldiers
    
    --Mission_VictoryCutscene()
end
--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
function Mission_SetDiplomacy()

	
end
--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
function Mission_SetupQuests()


end
--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

function Quest_CheckRockfallActivation()
    StartSimpleHiResJob("SpawnEffectWhenRockBarrierIsCreated")
end

function SpawnEffectWhenRockBarrierIsCreated()

    local RockBarrierID = Logic.GetEntityIDByName("FallingRock")
    
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

function KeepTigerContented()
    Logic.MakeCarnivoresContented( GetID("Tiger") )
end

function HighlightElderPrison()
    -- Highlight the elder prison
    local X,Y = Logic.GetEntityPosition(assert(Logic.GetEntityIDByName("Prison")))
    g_Marker = Logic.CreateEffect( EGL_Effects.E_Questmarker_low, X, Y ,0 )
end


function Quest_DeactivatePrisonMarker()
    Logic.DestroyEffect(g_Marker)
end

function PraphatTrade()
    --  Trade with noribat once per month, trade with other villages every two months
    
    if Logic.GetMonthSeconds() == 0 then
        local Villages = {
            { ID = 6, GoodsPraphat = { { Goods.G_Gold, 250 } }, GoodsVillage = { { Goods.G_Iron, 9 } } },
        }
        if math.mod( Logic.GetCurrentMonth(), 2 ) == 0 then
            table.insert( Villages, { ID = 4, GoodsPraphat = { { Goods.G_Bread, 14 } },
                GoodsVillage = { { Goods.G_Wool, 9 }, { Goods.G_Herb, 9 }, { Goods.G_Wood, 9 } } } )
                
            table.insert( Villages, { ID = 5, GoodsPraphat = { { Goods.G_Gold, 250 }, { Goods.G_Wood, 9 } },
                GoodsVillage = { { Goods.G_Stone, 9 }, { Goods.G_Iron, 9 }, { Goods.G_Milk, 9 } } } )
        end
        
        PrepareTradeCarts( Villages )
    end
end

function PrepareTradeCarts( _VillageDefinition )
    local PraphatID = 3 --This is the non-hostile praphatstan
    
    g_DeliverList = { [PraphatID] = {} }
    for _, Village in ipairs( _VillageDefinition ) do
        if GetDiplomacyState( PraphatID, Village.ID ) == DiplomacyStates.TradeContact then
            for _, GoodAndCost in ipairs( Village.GoodsPraphat ) do
                table.insert( g_DeliverList[PraphatID], { Dest = Village.ID, Good = GoodAndCost[1], Amount = GoodAndCost[2] } )
            end
            if not g_DeliverList[Village.ID] then
                g_DeliverList[Village.ID] = {}
            end
            for _, GoodAndCost in ipairs( Village.GoodsVillage ) do
                table.insert( g_DeliverList[Village.ID], { Dest = PraphatID, Good = GoodAndCost[1], Amount = GoodAndCost[2] } )
            end
        end
    end
    
    StartSimpleJob( "SendAllTradeCarts" )
end

function SendAllTradeCarts()
    local PraphatstanID = 3
    local PraphatMilitaryID = 2
    g_CartDelay = g_CartDelay or 0

    g_CartDelay = g_CartDelay + 1
    if g_CartDelay > 5 then
        g_CartDelay = 0
        local DeliveredNothing = true
        for PlayerID, Deliver in pairs( g_DeliverList ) do
            if #Deliver > 0 then
                DeliveredNothing = false
                local Entry = Deliver[1]
                local Delivery = DeliveryTemplate:new()
                local NewDest = PlayerID == PraphatstanID and PraphatMilitaryID or Entry.Dest   -- If its from praphatstan, deliver to praphat, but change target after spawn
                
                local StoreHouseID
                if NewDest == PraphatMilitaryID and Logic.IsEntityAlive("PraphatOutpost1") then
                    -- Extra code to avoid HireTL asserts (simply spawn&remove a storehouse)
                    local SpawnID = Logic.GetEntityIDByName("PraphatOutpost1")
                    assert( SpawnID and SpawnID > 0 )
                    local SpawnX, SpawnY = Logic.GetEntityPosition(SpawnID)
                    StoreHouseID = Logic.CreateEntityOnUnblockedLand( Entities.B_Invisible_StoreHouse, SpawnX + 1, SpawnY + 1, 0, PraphatMilitaryID )

                end
                
                if Entry.Good == Goods.G_Gold then
                    local DeliverAmount = Entry.Amount > 250 and 250 or Entry.Amount
                    RemoveResourcesFromPlayer( Entry.Good, DeliverAmount, Entry.Dest )
                    
                    -- Praphat may escort gold carts
                    if PlayerID == PraphatstanID and g_CartsCaptureCount > 0 then
                        local CartGuard
                        local funcDelEnd = function()   -- No need to remove the guard if the cart didn't arrive - as the guard will be dead then
                            if Logic.IsEntityAlive(CartGuard) then
                                AICore.HideEntityFromAI( PraphatMilitaryID, CartGuard, false )
                            end
                        end
                        
                        Delivery:Initialize( Entry.Good, DeliverAmount, PlayerID, NewDest, funcDelEnd, funcDelEnd )
                        
                        -- Try to find an available guard on the Praphatstan/Military territory for the escort
                        local Soldiers = { Logic.GetEntitiesOfTypeInTerritory( 15, PraphatMilitaryID, Entities.U_MilitarySword, 0 ) }
                        for _, ID in ipairs{ Logic.GetEntitiesOfTypeInTerritory( 24, PraphatMilitaryID, Entities.U_MilitarySword, 0 ) } do
                            table.insert( Soldiers, ID )
                        end
                        for _, ID in ipairs(Soldiers) do
                            local TempGuard = Logic.SoldierGetLeaderEntityID(ID)
                            if Logic.GetGuardedEntityID( TempGuard ) == 0 then
                                CartGuard = TempGuard
                                break
                            end
                        end
                        
                        if not CartGuard then
                            -- None found, create a new one
                            local x, y = Logic.GetEntityPosition(Delivery.Unit)
                            CartGuard = Logic.CreateBattalionOnUnblockedLand( Entities.U_MilitarySword, x, y, 0, PraphatMilitaryID, 0 )    
                        end
                        
                        AICore.HideEntityFromAI( PraphatMilitaryID, CartGuard, true )
                        Logic.GroupGuard(CartGuard, Delivery.Unit)
                    else
                        Delivery:Initialize( Entry.Good, DeliverAmount, PlayerID, NewDest )
                    end
                    
                    Entry.Amount = Entry.Amount - DeliverAmount

                else
                    local ToMarketPlace = Logic.GetGoodCategoryForGoodType( Entry.Good ) ~= GoodCategories.GC_Resource
                    if not ToMarketPlace then
                        RemoveResourcesFromPlayer( Entry.Good, Entry.Amount, Entry.Dest )
                    end
                    Delivery:Initialize( Entry.Good, Entry.Amount > 9 and 9 or Entry.Amount, PlayerID, NewDest, nil, nil, ToMarketPlace )
                    Entry.Amount = Entry.Amount - 9
                end
                
                if Entry.Amount <= 0 then
                    table.remove( Deliver, 1 )
                end
                if NewDest ~= Entry.Dest then   -- Change dest if its from praphat
                    Logic.ResourceMerchant_OverrideTargetPlayerID( Delivery.Unit, Entry.Dest )
                end
                
                if StoreHouseID then
                    Logic.DestroyEntity(StoreHouseID)
                end
            end
        end
        return DeliveredNothing
    end
end

function Quest_OneCartCaptured()
    g_CartsCaptureCount = g_CartsCaptureCount + 1
end

function Quest_ImproveForswapurOffer1()
    local PlayerID = 4
	local TraderID = Logic.GetStoreHouse(PlayerID)
    Logic.RemoveAllOffers( TraderID )
	AddOffer( TraderID, 2, Goods.G_Herb )
	AddOffer( TraderID, 2, Goods.G_Wool )
	AddOffer( TraderID, 1, Goods.G_Gems )
    -- Hack to force a menu update
    Logic.ExecuteInLuaLocalState("GameCallback_CloseNPCInteraction(1, Logic.GetStoreHouse("..PlayerID.."))")
end

function Quest_ImproveForswapurOffer2()
    local PlayerID = 4
	local TraderID = Logic.GetStoreHouse(PlayerID)
    Logic.RemoveAllOffers( TraderID )
	AddOffer( TraderID, 3, Goods.G_Herb )
	AddOffer( TraderID, 3, Goods.G_Wool )
	AddOffer( TraderID, 2, Goods.G_Gems )
	AddOffer( TraderID, 1, Goods.G_Sheep )	
    -- Hack to force a menu update
    Logic.ExecuteInLuaLocalState("GameCallback_CloseNPCInteraction(1, Logic.GetStoreHouse("..PlayerID.."))")
end

function Quest_ImproveFareharOffer()
    local PlayerID = 5
	local TraderID = Logic.GetStoreHouse(PlayerID)
    Logic.RemoveAllOffers( TraderID )
	AddOffer( TraderID, 4, Goods.G_Stone )
	AddOffer( TraderID, 2, Goods.G_Milk )
	AddOffer( TraderID, 2, Goods.G_Iron )
	AddOffer( TraderID, 1, Goods.G_Cow )
    -- Hack to force a menu update
    Logic.ExecuteInLuaLocalState("GameCallback_CloseNPCInteraction(1, Logic.GetStoreHouse("..PlayerID.."))")
end

function Quest_ImproveNoribatOffer()
    local PlayerID = 6
	local TraderID = Logic.GetStoreHouse(PlayerID)
    Logic.RemoveAllOffers( TraderID )
	AddOffer( TraderID, 5, Goods.G_Iron )
	AddOffer( TraderID, 2, Goods.G_Olibanum )
    -- Hack to force a menu update
    Logic.ExecuteInLuaLocalState("GameCallback_CloseNPCInteraction(1, Logic.GetStoreHouse("..PlayerID.."))")
end

function MissionCallback_OnThiefStealBuilding(_ThiefID, _ThiefPlayerID, _BuildingID, _BuildingPlayerID)
    if _ThiefPlayerID == 1 and _BuildingPlayerID == 3 and _BuildingID == Logic.GetHeadquarters(3) then
        if not g_ThiefWithInformation then
            g_ThiefWithInformation = _ThiefID
        end
    end
end

function Quest_CheckThiefSteal()
    if g_ThiefWithInformation then
        return true
    end
end

function Quest_CheckThiefKilled()
    if g_ThiefWithInformation and Logic.IsEntityDestroyed( g_ThiefWithInformation ) then
        return false
    end
end

function Quest_CheckThiefCloseToPrison()
    return CheckThiefDistance( "Prison" )
end

function Quest_CheckThiefCloseToTroopPrison()
    return CheckThiefDistance( "PrisonTroops" )
end

function CheckThiefDistance( _Name )
    local PrisonID = Logic.GetEntityIDByName( _Name )
    assert( PrisonID and PrisonID ~= 0 )
    local Thieves = { Logic.GetPlayerEntities( 1, Entities.U_Thief, 48, 0 ) }
    table.remove( Thieves, 1 )
    for _, ID in ipairs( Thieves ) do
        if IsNear( ID, PrisonID, 1000 ) then
            return true
        end
    end
end

function Quest_FailIfNoCatapultAmmo()
    local Ammo = 0
    local Alive = false
    if Logic.IsEntityAlive("CatapultCart") then
        local ID = Logic.GetEntityIDByName("CatapultCart")
        Ammo = Ammo + Logic.GetAmmunitionAmount( ID )
        Alive = true
    end
    if Logic.IsEntityAlive("AmmunitionCart") then
        local ID = Logic.GetEntityIDByName("AmmunitionCart")
        Ammo = Ammo + Logic.GetAmmunitionAmount( ID )
        Alive = true
    end
    
    if Ammo == 0 then
        return false
    end
end

function Quest_CheckTroopsKilled()
    -- This doesn't check for the ammunition cart, as it will be destroyed when its empty
    if ( Logic.IsEntityDestroyed("TroopsFromPrison1") and Logic.IsEntityDestroyed("TroopsFromPrison2") ) or Logic.IsEntityDestroyed("CatapultCart") then
        return false
    end
end

function Quest_DestroyWall()
    assert( #g_WallInfo > 0 )
    
    for _, ID in ipairs( g_WallInfo ) do
        if Logic.IsEntityDestroyed( ID ) then
            return true
        end
    end
end

function Quest_FareharFestival()
    -- TODO
end

function Quest_ForswapurAbortRelationsToPraphat()
    -- TODO (Q21)
    SetDiplomacyState(4, 2, DiplomacyStates.EstablishedContact)
    SetDiplomacyState(4, 3, DiplomacyStates.EstablishedContact)
end

function Quest_FareharAbortRelationsToPraphat()
    -- TODO (Q17)
    SetDiplomacyState(5, 2, DiplomacyStates.EstablishedContact)
    SetDiplomacyState(5, 3, DiplomacyStates.EstablishedContact)
end

function Quest_NoribatAbortRelationsToPraphat()
    -- TODO (Q34)
    SetDiplomacyState(6, 2, DiplomacyStates.EstablishedContact)
    SetDiplomacyState(6, 3, DiplomacyStates.EstablishedContact)
end


g_TradeCarts = {}
function MapCallback_SettlerSpawned( _PlayerID, _EntityID )

    if _PlayerID == 4 and Logic.GetEntityType( _EntityID ) == Entities.U_ResourceMerchant then
        table.insert( g_TradeCarts, _EntityID )
    end

end

g_TradeCartsCheckArrival = {}
function CheckFoundCarts()
    for _, ID in ipairs( g_TradeCarts ) do
        if Logic.IsEntityAlive(ID) then
            local goodType, goodAmount = Logic.GetMerchantCargo(ID)
            if ( goodType == Goods.G_Grain or goodType == Goods.G_Milk ) then
               
                local TradeDef = Logic.TradePost_GetPlayerSpecificTradeDefinition( g_ForswapurTradePostID, 0, 1 )
                if TradeDef and goodAmount == TradeDef[2] then
                    g_TradeCartsCheckArrival[ID] = true
                end
            end
        end
    end
    g_TradeCarts = {}
    
    local Destroyed = {}
    local StorehouseID = Logic.GetStoreHouse(4)
    for ID in pairs( g_TradeCartsCheckArrival ) do
        if Logic.IsEntityDestroyed(ID) then
            -- Hmmm, maybe this was/is needed to clean up g_TradeCartsCheckArrival?
            table.insert( Destroyed, ID )
        end
        
        -- g_ArrivedResourceMerchants is filled in an extern callback function
        if g_ArrivedResourceMerchants[ID] and g_ArrivedResourceMerchants[ID] == StorehouseID then
            return true
        end
    end
end

function Quest_ForswapurStartTradingRoute()
    return CheckFoundCarts()
end

function Quest_ForswapurOnStrike()
    local PlayerID = 4
	local TraderID = Logic.GetStoreHouse(PlayerID)
    Logic.RemoveAllOffers( TraderID )
    
    if not g_ForswapurStrikeJob then
        g_ForswapurStrikeJob = StartSimpleJob("ForswapurStrike")
    end
end

function Quest_ForswapurStopFoodStrike()
    Quest_ImproveForswapurOffer2()

    if g_ForswapurStrikeJob then
        EndJob(g_ForswapurStrikeJob)
        g_ForswapurStrikeJob = nil
    end
end

function ForswapurStrike()
    local PlayerID = 4
    for _, ID in ipairs{ Logic.GetPlayerEntitiesInCategory(PlayerID, EntityCategories.CityBuilding) } do     
        Logic.SetNeedState(ID, Needs.Nutrition, 0)
    end
    for _, ID in ipairs{ Logic.GetPlayerEntitiesInCategory(PlayerID, EntityCategories.OuterRimBuilding) } do     
        Logic.SetNeedState(ID, Needs.Nutrition, 0)
    end
    for _, ID in ipairs{ Logic.GetPlayerEntitiesInCategory(PlayerID, EntityCategories.GC_Food_Supplier) } do
        local NumberOfGoodTypes = Logic.GetNumberOfGoodTypesOnOutStock(ID)
        -- Removes too much, but that doesn't matter here
        for i = 0, NumberOfGoodTypes-1 do        
            local GoodType = Logic.GetGoodTypeOnOutStockByIndex(ID,i)
            local Amount = Logic.GetAmountOnOutStockByIndex(ID, i)
            if Amount > 0 then
                Logic.RemoveGoodFromStock(ID, GoodType, Amount, false)
            end
        end
    end
    for _, ID in ipairs{ Logic.GetPlayerEntitiesInCategory(PlayerID, EntityCategories.G_Grain_Supplier) } do
        local NumberOfGoodTypes = Logic.GetNumberOfGoodTypesOnOutStock(ID)
        -- Removes too much, but that doesn't matter here
        for i = 0, NumberOfGoodTypes-1 do        
            local GoodType = Logic.GetGoodTypeOnOutStockByIndex(ID,i)
            local Amount = Logic.GetAmountOnOutStockByIndex(ID, i)
            if Amount > 0 then
                Logic.RemoveGoodFromStock(ID, GoodType, Amount, false)
            end
        end
    end
end

--[[
function Quest_Build4Deco()
    
    
    local tDeco = {
        Entities.B_SpecialEdition_Column,
        Entities.B_SpecialEdition_Pavilion,
        Entities.B_SpecialEdition_StatueDario,
        Entities.B_SpecialEdition_StatueFamily,
        Entities.B_SpecialEdition_StatueProduction,
        Entities.B_SpecialEdition_StatueSettler,
        
        Entities.B_Beautification_Brazier,
        Entities.B_Beautification_Flowerpot_Round,
        Entities.B_Beautification_Flowerpot_Square,
        Entities.B_Beautification_Lantern,
        Entities.B_Beautification_Pillar,
        Entities.B_Beautification_Shrine,
        Entities.B_Beautification_StoneBench,
        Entities.B_Beautification_Sundial,
        Entities.B_Beautification_TriumphalArch,
        Entities.B_Beautification_Vase,
        Entities.B_Beautification_VictoryColumn,
        Entities.B_Beautification_Waystone,
    }
    local Count = 0
    local NumToReach = 4
    
    for _, EntityType in ipairs( tDeco ) do
        local tIDs = { Logic.GetPlayerEntities( 1, EntityType, NumToReach, 0 ) }
        table.remove( tIDs, 1 )
        for _, ID in ipairs( tIDs ) do
            if Logic.IsConstructionComplete( ID ) == 1 then
                Count = Count + 1
            end
        end
    end
    
    if not g_DecoCounterShown then
        g_DecoCounterShown = true
        
        StartMissionGoodCounter(Goods.G_Regalia, 4)
    end
    
    MissionCounter.CurrentAmount = Count
    if Count >= NumToReach then
        MissionCounter.CurrentAmount = NumToReach + 1   -- Force hide
       return true
    end
    
end
]]

function Quest_Generate4DecoQuest()
    
    local ToBuild = {
        Entities.B_Beautification_Shrine,
        Entities.B_Beautification_Sundial,
        Entities.B_Beautification_TriumphalArch,
        Entities.B_Beautification_VictoryColumn,
    }
    
    local Alternatives = {
        Entities.B_Beautification_Brazier,
        Entities.B_Beautification_Pillar,
        Entities.B_Beautification_Vase,
        Entities.B_SpecialEdition_StatueDario,
        Entities.B_SpecialEdition_StatueSettler,
        Entities.B_SpecialEdition_StatueFamily,
        Entities.B_SpecialEdition_StatueProduction,
        Entities.B_SpecialEdition_Column,
        Entities.B_SpecialEdition_Pavilion,
    }
    
    local function PlayerHasBuildingOnMainTerritory( _Type )
        return Logic.GetEntitiesOfTypeInTerritory( 1, 1, _Type, 0 ) and true
    end
    
    -- Now check if the player already built one of the buildings and replace it by an alternate one if needed
    for i = #ToBuild, 1, -1 do
        local Type = ToBuild[i]
        if PlayerHasBuildingOnMainTerritory( Type ) then
            table.remove( ToBuild, i )
            
            local Alternative
            for j = #Alternatives, 1, -1 do
                Alternative = table.remove( Alternatives, j )
                if PlayerHasBuildingOnMainTerritory( Alternative ) then
                    Alternative = nil
                end
            end
            
            if Alternative then
                table.insert( ToBuild, i, Alternative )
            end
        end
    end
    
    local Subquests = {}
    for Num, EntityType in ipairs(ToBuild) do
        table.insert( Subquests, (QuestTemplate:New("", 1, 1,
            { { Objective.Create, EntityType, 1, 1 } },
            { { Triggers.Time, 0  } },
--            { Num == 1 and { Triggers.Time, 0  } or { Triggers.Quest, assert(Subquests[#Subquests]), QuestResult.Success } },
            0, { { Reward.FakeVictory } }, nil, nil, nil, false, false) ))
    end
        
    QuestTemplate:New("Q_39_cKnight_BuildBeautificationBuildings", 1, 1,
        { { Objective.Quest, Subquests } },
        { { Triggers.Time, 0  } },
        0,
        { { Reward.Custom,{nil, Mission_VictoryCutscene} } },
        nil, nil, nil, nil, true, true)
end

function Quest_DisableP2WallCatapults()
    AICore.SetNumericalFact( 2, "FMBA", 0 )
end

function Quest_EnableP2WallCatapults()
    AICore.SetNumericalFact( 2, "FMBA", 3 )
    --[[
    -- Wall is broken, set territory ID to neutral
    local TerritoryID = assert(GetTerritoryIDByName("Territory 18"))
    for _, ID in ipairs{ Logic.GetEntitiesOfCategoryInTerritory( TerritoryID, 2, EntityCategories.Wall ) } do
        Logic.HurtEntity( ID, Logic.GetEntityHealth( ID ) )
    end
    Logic.SetTerritoryPlayerID( TerritoryID, 0)    
    --]]
end

function MountOutpostWithArchers( _Outpost )
    local outpostID = assert( Logic.GetEntityIDByName(_Outpost) )
    local AIPlayerID = Logic.EntityGetPlayer(outpostID)

    local ax, ay = Logic.GetBuildingApproachPosition(outpostID)
    local TroopID = Logic.CreateBattalionOnUnblockedLand(
                      Entities.U_MilitaryBow, ax, ay, 0, AIPlayerID, 0 )
    AICore.HideEntityFromAI( AIPlayerID, TroopID, true ) 
    Logic.CommandEntityToMountBuilding( TroopID, outpostID )
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
    for _, Name in ipairs{ "Eldest" } do
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

--[[function Quest_SendIronToPlayer()
    SendResourceMerchantToPlayer( Logic.GetStoreHouse(6), "G_Iron", 18 )
end--]]

function change_TerritoryID()
 
     -- TerritorienID wird verändert und Mauern bleiben stehen :)
 
    Logic.SetTerritoryPlayerID(GetTerritoryIDByName("Territory 18"), 0)
     
end


function Mission_VictoryJubilate(_Number, _PlayerID)

    local PossibleSettlerTypes = {
    Entities.U_NPC_Monk_ME,    
    Entities.U_NPC_Villager01_ME,    
    Entities.U_Baker,
    Entities.U_BathWorker,
    Entities.U_Soapmaker,
    Entities.U_DairyWorker,
    Entities.U_HerbGatherer,
    Entities.U_GrainFarmer,
    Entities.U_CattleFarmer,
    Entities.U_Woodcutter,
    Entities.U_SheepFarmer,
    Entities.U_Weaver,
    Entities.U_BannerMaker,
    Entities.U_Beekeeper,
    Entities.U_Barkeeper,
    Entities.U_IronMiner,
    Entities.U_Stonecutter,
    Entities.U_Fisher,
    Entities.U_Hunter,
    Entities.U_SmokeHouseWorker,
    Entities.U_Butcher,
    Entities.U_Pharmacist,
    Entities.U_BroomMaker,
    Entities.U_Tanner,
    Entities.U_Priest,
    Entities.U_Blacksmith,
    Entities.U_CandleMaker,
    Entities.U_Carpenter,
    Entities.U_Actor_Nobleman,
    Entities.U_Actor_Bandit,
    Entities.U_Actor_Princess,
    Entities.U_TheatreWorker }


    for k=1, _Number do
        local ScriptEntityName = "V" .. k
        local VictorySettlerPos = Logic.GetEntityIDByName(ScriptEntityName)
        if (VictorySettlerPos == 0) then
            return
        end
        local x,y = Logic.GetEntityPosition(VictorySettlerPos)        
        local Orientation = Logic.GetEntityOrientation(VictorySettlerPos)                
        local SettlerType = PossibleSettlerTypes[1 + Logic.GetRandom(#PossibleSettlerTypes)]
        local SettlerID = Logic.CreateEntityOnUnblockedLand(SettlerType, x, y, Orientation-90, _PlayerID) 
        Logic.SetTaskList(SettlerID, TaskLists.TL_WORKER_FESTIVAL_APPLAUD_SPEECH)
    end


end

g_ForswapurPlayerID = 4

function Mission_VictoryCutscene()

    local PraphatID = 7
    local CastellanID = 8

    SetFriendly(1, 2)
    SetFriendly(1, 3)
    SetFriendly(1, PraphatID)
    SetFriendly(1, CastellanID)
    SetFriendly(PraphatID, 2)
    SetFriendly(PraphatID, 3)
    SetFriendly(PraphatID, CastellanID)
    SetFriendly(CastellanID, 2)
    SetFriendly(CastellanID, 3)
    
    do
        local X, Y = Logic.GetEntityPosition( Logic.GetEntityIDByName( "KnightPos" ) )        
        local Ori =Logic.GetEntityOrientation(Logic.GetEntityIDByName( "KnightPos" ))
        VictorySetEntityToPosition(Logic.GetKnightID(1), X, Y, Ori)
    end
 
    do               
        Logic.ExecuteInLuaLocalState([[SetupPlayer(8, "H_NPC_Castellan_AS", "Castellan")]])
    
        local X, Y = Logic.GetEntityPosition( Logic.GetEntityIDByName( "CastellanPos" ) )
        local Ori =Logic.GetEntityOrientation(Logic.GetEntityIDByName( "CastellanPos" ))
        Logic.CreateEntityOnUnblockedLand(Entities.U_NPC_Castellan_AS, X, Y, Ori-90, CastellanID)
    end

    do
        Logic.ExecuteInLuaLocalState([[SetupPlayer(7, "H_Knight_Praphat", "Praphat")]])        
    end
        
    
    Mission_VictoryJubilate(100, PraphatID)
     
    GenerateVictoryDialog(
        {
            {PraphatID, "Victory1_Praphat"},   
            {CastellanID, "Victory2_TownCitizen"},
            {1, "Victory3_Knight"},
        })
    
   Logic.ExecuteInLuaLocalState("Mission_LocalVictory()")

    
end



function Mission_DefeatCutscene_Forswapur_DeliverMoreBread_Failure()
    GenerateDefeatDialog( {{ g_ForswapurPlayerID, "Q_26_Forswapur_DeliverMoreBread_Failure" }} )
end

function Mission_DefeatCutscene_Forswapur_DeliverMoreCheese_Failure()
    GenerateDefeatDialog( {{ g_ForswapurPlayerID, "Q_27_Forswapur_DeliverMoreCheese_Failure" }} )
end




