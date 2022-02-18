----------------------------------------------------------------------------------------------------------------------
function Mission_InitPlayers()
	    
end
----------------------------------------------------------------------------------------------------------------------
function Mission_SetStartingMonth()

    Logic.SetMonthOffset(3)

end

function Quest_CheckPraphatResign()

    if Logic.IsEntityAlive(g_Pr.PraphatID) then
        if Logic.GetEntityHealth(g_Pr.PraphatID) < Logic.GetEntityMaxHealth(g_Pr.PraphatID)/5 then
            if JobIsRunning( g_Pr.RetreatJob ) then
                EndJob( g_Pr.RetreatJob )
            end
            Move( g_Pr.PraphatID, Logic.GetHeadquarters(1) )
            g_Pr.PraphatResigned = true
            return true
        end
    end
  
end

-- Praphat may get killed within a single second, so his health needs to be monitored
function Mission_Callback_EntityHurt(_AttackedEntityID, _AttackedPlayerID, _AttackingEntityID, _AttackingPlayerID)
    if g_Pr.PraphatID and g_Pr.PraphatID == _AttackedEntityID then
        -- Ok, someone hit Praphat
        local MinimumHealth = Logic.GetEntityMaxHealth(g_Pr.PraphatID)/5 - 1
        local CurrentHealth = Logic.GetEntityHealth(g_Pr.PraphatID)
        if CurrentHealth < MinimumHealth then
            -- Keep him alive
            Logic.HealEntity( g_Pr.PraphatID, MinimumHealth - CurrentHealth )
        end
    end
end

function Quest_PraphatResigns()
    assert( Logic.IsEntityAlive(g_Pr.PraphatID) )
    
    -- Heal him to keep him alive
    Logic.HealEntity( g_Pr.PraphatID, Logic.GetEntityMaxHealth(g_Pr.PraphatID) )
    
    -- Friendly now
    for i = 1, 6 do
        SetDiplomacyState( 8, i, DiplomacyStates.EstablishedContact )
    end
    
    -- All soldiers switch to player (thats going to be expensive)
    for _, ID in ipairs( GetPlayerEntities( 8, Entities.U_MilitaryLeader ) ) do
        Logic.ChangeEntityPlayerID( ID, 1 )
    end
    
    -- Praphat doesn't switch playerid, but simply moves to the player sHQ
    g_MovePraphatToHQID = StartSimpleJob( "MovePraphatToHQ" )
end

function MovePraphatToHQ()
    assert( Logic.IsEntityAlive(g_Pr.PraphatID) )
    
    -- Heal him to keep him alive (just in case)
    if Logic.GetEntityHealth( g_Pr.PraphatID ) ~= Logic.GetEntityMaxHealth(g_Pr.PraphatID) then
        Logic.HealEntity( g_Pr.PraphatID, Logic.GetEntityMaxHealth(g_Pr.PraphatID) )
    end
    
--    if not Logic.IsEntityMoving( g_Pr.PraphatID ) then
    -- Force move - don't care if he runs to another location
        Logic.MoveSettler( g_Pr.PraphatID, Logic.GetEntityPosition( Logic.GetHeadquarters(1) ) )
--    end
end

function Quest_CheckPraphatArrivesAtHQ()
    assert( Logic.IsEntityAlive(g_Pr.PraphatID) )
    
    if Logic.GetDistanceBetweenEntities( g_Pr.PraphatID, Logic.GetHeadquarters(1) ) < 2000 then
        EndJob( g_MovePraphatToHQID )
        g_MovePraphatToHQID = nil
        
        return true
    end
end

function Quest_PraphatCanJoinAttacksNow()
    g_Pr.PraphatJoinsAttack = true
end

g_CartSpawnDirection = "Nope"
function Quest_ChooseCartArrival()
    local Directions = { "North", "East", "South", "West" }
    local DirectionsMonsoon = { "North", "East" }
    local UsedDirections = Directions
    
    -- Check the monsoon, so the cart won't get stuck
    local CurrentMonth = Logic.GetCurrentMonth()    
    local NextMonth    = CurrentMonth + 1
    
    if NextMonth > 12 then
        NextMonth = 1
    end
    
    -- If there is monsoon in the current month, or monsoon will start soon, use the reachable spawnpoints only
    if Logic.GetWeatherDoesShallowWaterFloodByMonth(CurrentMonth) or Logic.GetWeatherDoesShallowWaterFloodByMonth(NextMonth) then
        UsedDirections = DirectionsMonsoon
    end
    
    g_CartSpawnDirection = UsedDirections[GetRandom( #UsedDirections ) + 1]
end

-- TODO: We could have multiple spawned carts on the map now.
g_SpawnedCartCount = 0
g_CartCaptureCount = 0
g_ExistingCarts = {}
g_ExistingStoreHouses = {}

function Quest_SpawnCartToThela()

    local Goods = { Goods.G_Olibanum, Goods.G_MusicalInstrument, Goods.G_Gems, Goods.G_Dye, Goods.G_Salt }
    local Good = Goods[GetRandom( #Goods ) + 1]

    local SpawnID = Logic.GetEntityIDByName("CartSpawn" .. g_CartSpawnDirection)
    assert( SpawnID and SpawnID > 0 )
    local SpawnX, SpawnY = Logic.GetEntityPosition(SpawnID)
    local ThelaCartID = Logic.CreateEntityOnUnblockedLand( Entities.U_ResourceMerchant, SpawnX, SpawnY, 0, 1 )
    Logic.SetSpeedFactor( ThelaCartID, 0.9 ) 
    local CartName = "ThelaCart" .. ThelaCartID
    Logic.SetEntityName( ThelaCartID, CartName )
    assert( not Logic.IsEntityDestroyed( CartName ) )
    Logic.HireMerchant( ThelaCartID, 1, Good, 2, 1 )
    table.insert( g_ExistingCarts, { CartName = CartName, SpawnDirection = g_CartSpawnDirection, ArrivedAtPlayer = false, PraphatTroopID = nil } )
    g_SpawnedCartCount = g_SpawnedCartCount + 1

    g_CartSpawnDirection = "Nope"
    g_PraphatCartWait = 0

    assert( not Logic.IsEntityDestroyed( CartName ) )
    
    -- Start intercepting the carts after the first cart got through
    if g_SpawnedCartCount > 1 then
        StartSimpleJob( "PraphatInterceptCart" )
    else
        -- First spawn - doesn't spawn a storehouse as praphat does not attack yet
        g_ExistingCarts[1].NoStoreHouse = true
        g_CheckTroopsJobID = StartSimpleJob( "CheckTroopsAndCarts" )
    end
    
end

function PraphatInterceptCart()
    g_PraphatCartWait = g_PraphatCartWait + 1
    if g_PraphatCartWait > 5 then
        if #g_ExistingCarts > 0 then    -- Hmm, should always exist
            local Entry = g_ExistingCarts[#g_ExistingCarts]
            if not Entry.PraphatTroopID and Logic.IsEntityAlive( Entry.CartName ) then
                local SpawnID = Logic.GetEntityIDByName("PraphatTroops" .. Entry.SpawnDirection)
                assert( SpawnID and SpawnID > 0 )
                AddCartStoreHouse( Entry.SpawnDirection )
--[[      
                -- Didn't work reliable - troops actually killed carts sometimes
                local SpawnX, SpawnY = Logic.GetEntityPosition(SpawnID)
                local TroopID = Logic.CreateBattalionOnUnblockedLand( Entities.U_MilitarySword, SpawnX, SpawnY, 0, 8, 0 )
                Entry.PraphatTroopID = TroopID
                AICore.HideEntityFromAI( 8, TroopID, true )
                Logic.GroupAttack( TroopID, Logic.GetEntityIDByName( Entry.CartName ) )
       ]]         
                local _, SpawnedTroops = AIScript_SpawnAndAttackMovingUnit(8, Logic.GetEntityIDByName( Entry.CartName ), SpawnID, 1, 0)
                Entry.PraphatTroopID = assert( SpawnedTroops[1] )
                
                if not g_CheckTroopsJobID then
                    g_CheckTroopsJobID = StartSimpleJob( "CheckTroopsAndCarts" )
                end
            end
        end
        
        return true
    end
end

function AddCartStoreHouse( _SpawnDirection )
    local Entry = g_ExistingStoreHouses[_SpawnDirection]
    assert( not Entry or Entry.Ref >= 0 )

    if Entry and Entry.Ref > 0 then
        -- Just increase ref count, no need to spawn another storehouse
        Entry.Ref = Entry.Ref + 1
        return
    end
    
    if not Entry or Entry.Ref == 0 then
        if not Entry then
            Entry = { Ref = 0 }
            g_ExistingStoreHouses[_SpawnDirection] = Entry
        end
    
        assert( not Entry.StoreHouseID )
        Entry.Ref = Entry.Ref + 1
        
        local SpawnID = Logic.GetEntityIDByName("PraphatTroops" .. _SpawnDirection)
        assert( SpawnID and SpawnID > 0 )
        local SpawnX, SpawnY = Logic.GetEntityPosition(SpawnID)
        Entry.StoreHouseID = Logic.CreateEntityOnUnblockedLand( Entities.B_Invisible_StoreHouse, SpawnX, SpawnY, 0, 8 )
    end
end

function DelCartStoreHouse( _SpawnDirection )
    local Entry = g_ExistingStoreHouses[_SpawnDirection]
    assert( Entry and Entry.Ref > 0 )
    
    Entry.Ref = Entry.Ref - 1
    
    if Entry.Ref == 0 then
        assert( Entry.StoreHouseID and Logic.IsEntityAlive( Entry.StoreHouseID ) )
        
        Logic.DestroyEntity( Entry.StoreHouseID )
        Entry.StoreHouseID = nil
    end
end

function CheckTroopsAndCarts()
    for i = #g_ExistingCarts, 1, -1 do
        local Entry = g_ExistingCarts[i]
        if Entry.TroopRetreats then
            if Logic.IsEntityDestroyed( Entry.PraphatTroopID ) then
                table.remove( g_ExistingCarts, i )
            else
                if Logic.GetDistanceBetweenEntities( Entry.PraphatTroopID, Logic.GetEntityIDByName("PraphatTroops" .. Entry.SpawnDirection) ) < 600 then
                    Logic.DestroyEntity( Entry.PraphatTroopID )
                end
            end
        else
            if Logic.IsEntityDestroyed( Entry.CartName ) then
                if not Entry.NoStoreHouse then
                    DelCartStoreHouse( Entry.SpawnDirection )
                end
                if Logic.IsEntityAlive( Entry.PraphatTroopID ) then
                    AICore.HideEntityFromAI( 8, Entry.PraphatTroopID, true )
                    Move( Entry.PraphatTroopID, Logic.GetEntityIDByName("PraphatTroops" .. Entry.SpawnDirection) )
                end
                if not Entry.ArrivedAtPlayer then
                    g_CartCaptureCount = g_CartCaptureCount + 1
                    MissionCounter.CurrentAmount = g_CartCaptureCount
                end
                Entry.TroopRetreats = true
            else
                if Logic.CheckEntitiesDistance( Logic.GetStoreHouse(1), Logic.GetEntityIDByName( Entry.CartName ), 700 ) then
                    Entry.ArrivedAtPlayer = true
                end
            end
        end
    end
    
    if #g_ExistingCarts == 0 then
        g_CheckTroopsJobID = nil
        return true
    end
end

function Quest_DisplayCartCounter()
    StartMissionEntityCounter(Entities.U_ResourceMerchant, 5)
end

function Quest_HideCartCounter()
    MissionCounter.CurrentAmount = 6
end

function Quest_HandlePraphatCapturedCart()
    -- Don't need to do anything here.
    -- Cart moves to the storehouse automatically
end

function Quest_CheckThreeCartsCaptured()
    if g_CartCaptureCount >= 3 then
        return true
    end
end

function Quest_CheckFourCartsCaptured()
    if g_CartCaptureCount >= 4 then
        return true
    end
end

function Quest_CheckFiveCartsCaptured()
    if g_CartCaptureCount >= 5 then
        return true
    end
end

function Quest_CheckCartSpawnNorth()
    if g_CartSpawnDirection == "North" then
        return true
    end
end

function Quest_CheckCartSpawnEast()
    if g_CartSpawnDirection == "East" then
        return true
    end
end

function Quest_CheckCartSpawnSouth()
    if g_CartSpawnDirection == "South" then
        return true
    end
end

function Quest_CheckCartSpawnWest()
    if g_CartSpawnDirection == "West" then
        return true
    end
end

-- This function doesn't handle multiple carts correctly
-- But it doesn't matter since it is used for the first cart only
function Quest_CheckThelaCartArrival()
    for _, Entry in ipairs( g_ExistingCarts ) do
        if Logic.IsEntityAlive( Entry.CartName ) and Logic.CheckEntitiesDistance( Logic.GetStoreHouse(1), Logic.GetEntityIDByName( Entry.CartName ), 700 ) then
            -- Hack for the first cart (isn't attacked by praphat)
            assert( #g_ExistingCarts == 1 )
            table.remove( g_ExistingCarts, 1 )
            
            return true
        end
    end
end

function Quest_SendAntidoteCart()
    local Deliver = DeliveryTemplate:new()
    Deliver:Initialize( Goods.G_None, 1, 6, 1 )
end

function Quest_CheckEnoughAttacksPassed()
    if g_Pr.AttackCount >= 4 then
        return true
    end
end

function Quest_PraphatAttack()
    g_Pr.AttackCount = g_Pr.AttackCount + 1

    -- Decide whether to attack a village or a players outer rim building
    -- In case praphat hasn't joined yet, attack villages only
    local CurrentTarget, RequireSpecialAttack
    if g_Pr.PraphatJoinsAttack and Logic.GetRandom(3) == 0 then
        -- Attack the player
        -- Find an outer rim building on a territory other than Thela
        local PotentialTargets = {}
        for _, TerritoryID in ipairs{ Logic.GetTerritories() } do
            if Logic.GetTerritoryPlayerID(TerritoryID) == 1 then
                if Logic.GetTerritoryName( TerritoryID ) ~= "Thela" then
                    for _, ID in ipairs{ Logic.GetEntitiesOfCategoryInTerritory( TerritoryID, 1, EntityCategories.OuterRimBuilding, 0 ) } do
                        table.insert( PotentialTargets, ID )
                    end
                end
            end
        end
        
        if #PotentialTargets > 0 then
            -- TODO: Could do something smart here, like always attack buildings not protected by a wall, or never attack the same territory two times in a row
            CurrentTarget = PotentialTargets[Logic.GetRandom(#PotentialTargets) + 1]
        end
    end
    
    if not CurrentTarget then
        -- There is no target yet, so either the omniscient GetRandom function decided not to attack the player, or the player doesn't have any suitable outer rim buildings
        
        -- Decide whether to attack a village or a players TP
        if g_Pr.PraphatJoinsAttack and Logic.GetRandom(2) == 0 then
            -- Find a suitable tradepost
            local IDs = { Logic.GetPlayerEntities( 1, Entities.B_TradePost, 10, 0 ) }
            table.remove( IDs, 1 )
            
            -- Don't attack the Mitrashmir TP (in case it exists)
            for _, TerritoryID in ipairs{ Logic.GetTerritories() } do
                if Logic.GetTerritoryPlayerID(TerritoryID) == 6 then
                    local _, MitrashmirTPID = Logic.GetEntitiesOfTypeInTerritory( TerritoryID, 1, Entities.B_TradePost, 0 )
                    if MitrashmirTPID then
                        for i = #IDs, 1, -1 do
                            if IDs[i] == MitrashmirTPID then
                                table.remove( IDs, i )
                                break
                            end
                        end
                    end
                end
            end

            if #IDs > 0 then
                -- TODO: Could do something smart here, like never attack the same territory two times in a row
                CurrentTarget = IDs[Logic.GetRandom(#IDs) + 1]
                -- The AI doesn't attack tradeposts the normal way
                RequireSpecialAttack = true
            end

        end
        
        -- Still no target? Ok, lets attack a village then
        if not CurrentTarget then
            -- Hmm, could be mean and attack villages that haven't been rebuilt yet :)
            -- If a village has been attacked by the last attack: Don't attack it again this time
            -- If a village was attacked two attacks ago (and hasn't been rebuilt yet) - attack it!

            local VillageID
            for i = 2, 5 do
                if GetDiplomacyState( 1, i ) == DiplomacyStates.TradeContact and ( not g_Pr.LastVillageID or g_Pr.LastVillageID ~= i ) then
                    -- This village is still tradecontact -> hasn't been rebuilt, and it wasn't attacked during the last attack. So attack this village.
                    VillageID = i
                    break
                end
            end
            assert( not g_Pr.LastVillageID or VillageID ~= g_Pr.LastVillageID )
            
            if not VillageID then   -- No mean target? Choose random village
                repeat
                    VillageID = Logic.GetRandom(4) + 2    -- Village IDs start at 2, Random returns 0 to 3.
                until not g_Pr.LastVillageID or g_Pr.LastVillageID ~= VillageID
            end
            
            
            g_Pr.LastVillageID = VillageID
            local IDs = {Logic.GetPlayerEntitiesInCategory( VillageID, EntityCategories.OuterRimBuilding )}
            if #IDs == 0 then
                IDs = {Logic.GetPlayerEntitiesInCategory( VillageID, EntityCategories.CityBuilding )}
            end
            
            if #IDs > 0 then
                CurrentTarget = IDs[Logic.GetRandom(#IDs) + 1]
            else
                -- This shouldn't happen. But if it does, raze the storehouse :-)
                CurrentTarget = Logic.GetStoreHouse(VillageID)
                RequireSpecialAttack = true
            end
        end
    end
    
    assert( CurrentTarget )
    
    local SpawnID, Distance
    local Directions = { "North", "East", "South", "West", "SouthEast" }
    local x2, y2 = Logic.GetEntityPosition( CurrentTarget )
    local Sector2 = Logic.GetPlayerSectorAtPosition( 8, x2, y2 )
    for _, v in ipairs( Directions ) do
        local TempID = assert( Logic.GetEntityIDByName( "PraphatTroops" .. v ) )
        
        -- Check if the target can be reached from that point before checking the distance
        local x1, y1 = Logic.GetBuildingApproachPosition( TempID )
        local Sector1 = Logic.GetPlayerSectorAtPosition( 8, x1, y1 )
        if Sector1 == Sector2 then
            local TempDistance = AICore.GetPlayerTroopWalkDistance( 8, TempID, CurrentTarget )
            if TempDistance and ( not Distance or Distance > TempDistance ) then
                SpawnID = TempID
                Distance = TempDistance
            end
        end
    end
    if not SpawnID then
        -- Hum, what now? This shouldn't happen. Well, lets spawn troops and let them do something...
        SpawnID = assert( Logic.GetEntityIDByName( "PraphatTroops" .. Directions[GetRandom( #Directions ) + 1] ) )
    end
     
    -- Set the current spawn as home location, so the AI will retreat to that position
    AICore.SetHomeEntityID( 8, SpawnID )
     
    g_Pr.SpawnID = SpawnID
    assert( SpawnID and SpawnID > 0 )
    local SpawnX, SpawnY = Logic.GetEntityPosition(SpawnID)
    
    g_Pr.TroopIDs = {}
    if g_Pr.PraphatJoinsAttack then
        -- Spawn Praphat + bodyguard
        local PraphatID = Logic.CreateEntityOnUnblockedLand( Entities.U_KnightPraphat, SpawnX, SpawnY, 0, 8 )
        g_Pr.PraphatID = PraphatID
        AICore.HideEntityFromAI( 8, g_Pr.PraphatID, true )
        local GuardID = Logic.CreateBattalionOnUnblockedLand( Entities.U_MilitarySword, SpawnX, SpawnY, 0, 8 )
        AICore.HideEntityFromAI( 8, GuardID, true )
        Logic.GroupGuard( GuardID, g_Pr.PraphatID )
    end
    
    local ArmyID = AICore.CreateArmy(8)
    g_Pr.ArmyID = ArmyID
    
    -- Amount based on player troop count on territory and in total
    local TargetTerritory = GetTerritoryUnderEntity( CurrentTarget )
    local MilitaryInTotal = Logic.GetCurrentSoldierCount( 1 )
    local MilitaryOnTerritory = 0
    local LastAmount = 0
    repeat
        LastAmount = #{Logic.GetEntitiesOfCategoryInTerritory( TargetTerritory, 1, EntityCategories.Military, MilitaryOnTerritory )}
        MilitaryOnTerritory = MilitaryOnTerritory + LastAmount
    until LastAmount == 0
    
    local SoldierSpawnCount = MilitaryOnTerritory
    if MilitaryInTotal / 2 > SoldierSpawnCount then
        SoldierSpawnCount = MilitaryInTotal / 2
    end

    local Sword = 1
    local Bow = 1
    SoldierSpawnCount = SoldierSpawnCount / 6   -- Soldiers -> Squads
    Sword = math.floor( SoldierSpawnCount * 0.5 )
    Bow = math.floor( SoldierSpawnCount * 0.5 )
    if Sword < 1 then
        Sword = 1
    elseif Sword > 5 then
        Sword = 5
    end
    if Bow < 1 then
        Bow = 2
    elseif Bow > 5 then
        Bow = 5
    end
    
    if not g_Pr.PraphatJoinsAttack then
        -- Stronger troops to force the destruction of a building
        Sword = math.floor(Sword * 1.5) + 1
        Bow = math.floor(Bow * 1.5) + 1
    end

    -- Spawn and attack
    for i = 1, Sword do
        local ID = Logic.CreateBattalionOnUnblockedLand( Entities.U_MilitarySword, SpawnX, SpawnY, 0, 8 )
        table.insert( g_Pr.TroopIDs, ID )
        AICore.AddEntityToArmy( 8, ArmyID, ID )        
    end
    for i = 1, Bow do
        local ID = Logic.CreateBattalionOnUnblockedLand( Entities.U_MilitaryBow, SpawnX, SpawnY, 0, 8 )
        table.insert( g_Pr.TroopIDs, ID )
        AICore.AddEntityToArmy( 8, ArmyID, ID )        
    end

--    AICore.AddEntityToArmy( 8, ArmyID, PraphatID )        

    -- Don't care about regular attacks, as they'll cause too much collateral damage and won't guarantee that a building gets destroyed
    -- So all attacks target a single building only now.
--    if RequireSpecialAttack then
    g_Pr.CurrentTarget = CurrentTarget
    AICore.StartAttackWithPlanDestroyHomebase( 8, ArmyID, CurrentTarget )
--    else
--        local AreaID = AICore.CreateAD()
--        AICore.AD_AddEntity( AreaID, CurrentTarget, 1000 )
--        AICore.StartAttackWithPlanRaidSettlement( 8, ArmyID, AreaID, 0 )
--    end
    
    --Praphat might want to stick to his army
    g_Pr.PraphatJob = StartSimpleJob( "PraphatFollowTroops" )
    
    -- Start retreating if the target is destroyed
    if not g_Pr.CheckTargetDestroyedJob or not JobIsRunning( g_Pr.CheckTargetDestroyedJob ) then
        g_Pr.CheckTargetDestroyedJob = StartSimpleJob( "CheckTargetDestroyed" )
    end
end

function PraphatFollowTroops()

    if Logic.IsEntityDestroyed( g_Pr.PraphatID ) or g_Pr.PraphatResigned then
        return true
    end
    
    if not g_Pr.CurrentTroopPraphatFollows or Logic.IsEntityDestroyed( g_Pr.CurrentTroopPraphatFollows ) then
        for _, ID in ipairs( g_Pr.TroopIDs ) do
            if Logic.IsEntityAlive( ID ) then
                g_Pr.CurrentTroopPraphatFollows = ID
                break
            end
        end
    end
    
    if not g_Pr.CurrentTroopPraphatFollows or Logic.IsEntityDestroyed( g_Pr.CurrentTroopPraphatFollows ) then
        Move( g_Pr.PraphatID, g_Pr.SpawnID )    -- Army is gone, move to exit
        return true
    end
    
    Move( g_Pr.PraphatID, g_Pr.CurrentTroopPraphatFollows )
    
end

function CheckTargetDestroyed()
    if Logic.IsEntityDestroyed( g_Pr.CurrentTarget ) then
        Quest_PraphatRetreat()
        return true
        
    -- Force burndown if badly damaged
    elseif Logic.GetEntityHealth( g_Pr.CurrentTarget ) / Logic.GetEntityMaxHealth( g_Pr.CurrentTarget ) < 0.5 and not Logic.IsBurning( g_Pr.CurrentTarget ) then
        Logic.HurtEntity( Logic.GetEntityHealth( g_Pr.CurrentTarget ) )
    end
end

function Mission_Callback_AIOnArmyDisbanded(_PlayerID, _ArmyID)
    if _PlayerID == 8 and g_Pr.ArmyID and _ArmyID == g_Pr.ArmyID then
        AICore.CancelAllAttacks()   -- Just to be sure
        if not g_Pr.RetreatJob or not JobIsRunning( g_Pr.RetreatJob ) then
            g_Pr.RetreatJob = StartSimpleJob( "PraphatCheckRetreat" )
        end
    end
end

-- This will get called by the quest timer, no matter if the army started retreating already
function Quest_PraphatRetreat()
    -- Don't remember any destroyed buildings from the previous attack to avoid an instant-loss on attack
    for i = 2, 5 do
        g_DestroyedBuildings[i] = nil
    end
    
    AICore.CancelAllAttacks()   -- Stop running attacks
    
    if not g_Pr.PraphatResigned and ( not g_Pr.RetreatJob or not JobIsRunning( g_Pr.RetreatJob ) ) then
        g_Pr.RetreatJob = StartSimpleJob( "PraphatCheckRetreat" )
    end
end

function PraphatCheckRetreat()
    assert( g_Pr.SpawnID )
    
    if g_Pr.PraphatResigned then
        -- Do not retreat if resigned
        g_Pr.RetreatJob = nil
        return true
    end

    if Logic.IsEntityAlive( g_Pr.PraphatID ) and Logic.GetDistanceBetweenEntities( g_Pr.PraphatID, g_Pr.SpawnID ) < 900 then
        local Guards = Logic.GetGuardianEntityID( g_Pr.PraphatID )
        if Guards and Guards > 0 then
            Logic.DestroyEntity( Guards )
        end
        Logic.DestroyEntity( g_Pr.PraphatID )
    end
    
    local Remove = {}
    for Index, ID in ipairs( g_Pr.TroopIDs ) do
        if Logic.IsEntityAlive( ID ) then
            if Logic.GetDistanceBetweenEntities( ID, g_Pr.SpawnID ) < 900 then
                Logic.DestroyEntity( ID )
                table.insert( Remove, Index )
            end
        else
            table.insert( Remove, Index )
        end
    end
    
    for i = #Remove, 1, -1 do
        table.remove( g_Pr.TroopIDs, Remove[i] )
    end
    
    if #g_Pr.TroopIDs == 0 and Logic.IsEntityAlive( g_Pr.PraphatID ) then
        Move( g_Pr.PraphatID, g_Pr.SpawnID )    -- Army is gone, move to exit
    end
    
    if #g_Pr.TroopIDs == 0 and Logic.IsEntityDestroyed( g_Pr.PraphatID ) then
        g_Pr.RetreatJob = nil
        return true
    end
end


function Quest_CanPraphatAttackAgain()
    if not g_Pr.PraphatID or Logic.IsEntityDestroyed( g_Pr.PraphatID ) then
        return true
    end
end

g_DestroyedBuildings = {}
function Mission_CallBack_BuildingDestroyed( _BuildingID, _PlayerID, _KnockedDown )
    if _PlayerID >= 2 and _PlayerID <= 5 and _KnockedDown == 0
        and Logic.IsEntityTypeInCategory( Logic.GetEntityType( _BuildingID ), EntityCategories.Wall ) == 0 then
        
        g_DestroyedBuildings[_PlayerID] = true
    end
end

function SetVillageTPState( _VillageID, _Status )

    local _, TradepostConstrID = Logic.GetPlayerEntities( _VillageID, Entities.I_X_TradePostConstructionSite, 1, 0 )
    local TerritoryID = Logic.GetTerritoryAtPosition( Logic.GetEntityPosition(TradepostConstrID) )
    local _, TradepostID = Logic.GetEntitiesOfTypeInTerritory( TerritoryID, 1, Entities.B_TradePost, 0 )
    if TradepostID and TradepostID > 0 then
        Logic.TradePost_SetActiveFlag( TradepostID, _Status )
    end
    
end

function CheckLostBuilding( _PlayerID )

    if g_DestroyedBuildings[_PlayerID] then
        g_DestroyedBuildings[_PlayerID] = nil
        
        -- Don't rebuild it
        AICore.SetNumericalFact( _PlayerID, "BARB", 0 )
        
        -- No  more TP trading
        SetDiplomacyState( 1, _PlayerID, DiplomacyStates.TradeContact )
        SetVillageTPState( _PlayerID, false )
        
        return true
    end
    
end

function RepairBuilding( _PlayerID )

    AICore.SetNumericalFact( _PlayerID, "BARB", 1 )
    SetDiplomacyState( 1, _PlayerID, DiplomacyStates.Allied )
    SetVillageTPState( _PlayerID, true )
    
end

-- Check/Repairfunctions for the villages
for i = 2, 5 do
    _G["Quest_CheckP"..i.."LostBuilding"] = function()
            return CheckLostBuilding(i)
        end
    _G["Quest_P"..i.."RepairBuilding"] = function()
            RepairBuilding(i)
        end
end

function Quest_CheckReputationHigh()
    if Logic.GetCityReputation(1) >= 0.95 then
        return true
    end
end

function Quest_ChangeMitraniForestID()
    for _, ID in ipairs{ Logic.GetEntitiesOfCategoryInTerritory( 11, 7, EntityCategories.Wall ) } do
        Logic.HurtEntity( ID, Logic.GetEntityHealth( ID ) )
    end
    
    Logic.SetTerritoryPlayerID( 11, 0 )
end

function Quest_ReenablePallisades()
    UnLockFeaturesForPlayer( 1, Technologies.R_Pallisade )
end

function Quest_PulajabDeliverRawFish()
    SendResourceMerchantToPlayer( Logic.GetStoreHouse(2), "G_RawFish", 27 )
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
    for _, Name in ipairs{ "Namawili", "TigerCaveReward", "OldHutReward", g_Pr.PraphatID } do
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

function Quest_SendIronToPlayer()
    SendResourceMerchantToPlayer( Logic.GetStoreHouse(6), "G_Iron", 18 )
end

function Quest_ChangeP6Namawili()
    Logic.ExecuteInLuaLocalState( "ChangeP6Namawili()" )
end

function Quest_CheckIfPlayerHasMilitaryStuff()
    local MilitaryStuff = GetPlayerGoodsInSettlement( Goods.G_Iron, 1, true)
        + GetPlayerGoodsInSettlement( Goods.G_Bow, 1, true)
        + GetPlayerGoodsInSettlement( Goods.G_Sword, 1, true)
        + Logic.GetCurrentSoldierCount( 1 )
        
    if MilitaryStuff > 18 then
        return true
    end

end

function Quest_Generate5DecoQuest()
    
    local ToBuild = {
        Entities.B_Beautification_Brazier,
        Entities.B_Beautification_Sundial,
        Entities.B_Beautification_TriumphalArch,
        Entities.B_Beautification_VictoryColumn,
        Entities.B_SpecialEdition_StatueSettler,
    }
    
    local Alternatives = {
        Entities.B_Beautification_Pillar,
        Entities.B_Beautification_Vase,
        Entities.B_Beautification_Shrine,
        Entities.B_SpecialEdition_StatueDario,
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
        
    QuestTemplate:New("Quest_BeautifyCity", 1, 1,
        { { Objective.Quest, Subquests } },
        { { Triggers.Time, 0  } },
        0,
        { { Reward.Custom,{nil, function() g_BeautificationBuilt = true end} } },
        nil, nil, nil, nil, true, true)
end

function Quest_CheckDecoBuilt()
    if g_BeautificationBuilt then
        return true
    end
end

----------------------------------------------------------------------------------------------------------------------
function Mission_InitMerchants()

    -- Pulajab
    local PlayerID = 2
	local TraderID = Logic.GetStoreHouse(PlayerID)
	AddOffer( TraderID, 3, Goods.G_RawFish )
	AddOffer( TraderID, 3, Goods.G_Wool )
	AddOffer( TraderID, 1, Goods.G_Sheep )
	AddOffer( TraderID, 1, Goods.G_Dye )

    local _, TradepostID = Logic.GetPlayerEntities( PlayerID, Entities.I_X_TradePostConstructionSite, 1, 0 )
    assert( TradepostID and TradepostID ~= 0 )
    Logic.TradePost_SetTradePartnerGenerateGoodsFlag(TradepostID, true)
    Logic.TradePost_SetTradePartnerPlayerID(TradepostID, PlayerID)
    Logic.TradePost_SetTradeDefinition(TradepostID, 0, Goods.G_Carcass, 5, Goods.G_RawFish, 9)
    Logic.TradePost_SetTradeDefinition(TradepostID, 1, Goods.G_Wood, 9, Goods.G_Wool, 5)
    Logic.TradePost_SetTradeDefinition(TradepostID, 2, Goods.G_Herb, 8, Goods.G_Dye, 6)
    Logic.TradePost_SetTradeDefinition(TradepostID, 3, Goods.G_Milk, 6, Goods.G_Dye, 5)
    Logic.TradePost_SetActiveTradeSlot(TradepostID, 0)

    -- Akhnapur
    local PlayerID = 3
	local TraderID = Logic.GetStoreHouse(PlayerID)
	AddOffer( TraderID, 3, Goods.G_Stone )
	AddOffer( TraderID, 3, Goods.G_Carcass )
	AddOffer( TraderID, 1, Goods.G_Salt )

    local _, TradepostID = Logic.GetPlayerEntities( PlayerID, Entities.I_X_TradePostConstructionSite, 1, 0 )
    assert( TradepostID and TradepostID ~= 0 )
    Logic.TradePost_SetTradePartnerGenerateGoodsFlag(TradepostID, true)
    Logic.TradePost_SetTradePartnerPlayerID(TradepostID, PlayerID)
    Logic.TradePost_SetTradeDefinition(TradepostID, 0, Goods.G_Herb, 6, Goods.G_Stone, 9)
    Logic.TradePost_SetTradeDefinition(TradepostID, 1, Goods.G_Milk, 4, Goods.G_Carcass, 9)
    Logic.TradePost_SetTradeDefinition(TradepostID, 2, Goods.G_RawFish, 5, Goods.G_Salt, 6)
    Logic.TradePost_SetTradeDefinition(TradepostID, 3, Goods.G_Iron, 4, Goods.G_Salt, 5)
    Logic.TradePost_SetActiveTradeSlot(TradepostID, 0)

    -- Ghulabai
    local PlayerID = 4
	local TraderID = Logic.GetStoreHouse(PlayerID)
	AddOffer( TraderID, 5, Goods.G_Grain )
	AddOffer( TraderID, 4, Goods.G_Carcass )
	AddOffer( TraderID, 1, Goods.G_MusicalInstrument )

    local _, TradepostID = Logic.GetPlayerEntities( PlayerID, Entities.I_X_TradePostConstructionSite, 1, 0 )
    assert( TradepostID and TradepostID ~= 0 )
    Logic.TradePost_SetTradePartnerGenerateGoodsFlag(TradepostID, true)
    Logic.TradePost_SetTradePartnerPlayerID(TradepostID, PlayerID)
    Logic.TradePost_SetTradeDefinition(TradepostID, 0, Goods.G_Stone, 4, Goods.G_Grain, 9)
    Logic.TradePost_SetTradeDefinition(TradepostID, 1, Goods.G_Milk, 3, Goods.G_Carcass, 9)
    Logic.TradePost_SetTradeDefinition(TradepostID, 2, Goods.G_Iron, 3, Goods.G_MusicalInstrument, 6)
    Logic.TradePost_SetTradeDefinition(TradepostID, 3, Goods.G_RawFish, 6, Goods.G_MusicalInstrument, 5)
    Logic.TradePost_SetActiveTradeSlot(TradepostID, 0)

    -- Khistangra
    local PlayerID = 5
	local TraderID = Logic.GetStoreHouse(PlayerID)
	AddOffer( TraderID, 2, Goods.G_Iron )
	AddOffer( TraderID, 3, Goods.G_Wood )
	AddOffer( TraderID, 1, Goods.G_Gems )

    local _, TradepostID = Logic.GetPlayerEntities( PlayerID, Entities.I_X_TradePostConstructionSite, 1, 0 )
    assert( TradepostID and TradepostID ~= 0 )
    Logic.TradePost_SetTradePartnerGenerateGoodsFlag(TradepostID, true)
    Logic.TradePost_SetTradePartnerPlayerID(TradepostID, PlayerID)
    Logic.TradePost_SetTradeDefinition(TradepostID, 0, Goods.G_Grain, 5, Goods.G_Iron, 9)
    Logic.TradePost_SetTradeDefinition(TradepostID, 1, Goods.G_Carcass, 6, Goods.G_Iron, 9)
    Logic.TradePost_SetTradeDefinition(TradepostID, 2, Goods.G_RawFish, 4, Goods.G_Gems, 6)
    Logic.TradePost_SetTradeDefinition(TradepostID, 3, Goods.G_Stone, 5, Goods.G_Gems, 5)
    Logic.TradePost_SetActiveTradeSlot(TradepostID, 0)

    -- Mitrashmir
    local PlayerID = 6
	local TraderID = Logic.GetStoreHouse(PlayerID)
	AddOffer( TraderID, 3, Goods.G_Iron )
	AddOffer( TraderID, 3, Goods.G_Herb )
	AddOffer( TraderID, 1, Goods.G_Cow )
	AddOffer( TraderID, 1, Goods.G_Olibanum )

    local _, TradepostID = Logic.GetPlayerEntities( PlayerID, Entities.I_X_TradePostConstructionSite, 1, 0 )
    assert( TradepostID and TradepostID ~= 0 )
    Logic.TradePost_SetTradePartnerGenerateGoodsFlag(TradepostID, true)
    Logic.TradePost_SetTradePartnerPlayerID(TradepostID, PlayerID)
    Logic.TradePost_SetTradeDefinition(TradepostID, 0, Goods.G_Wood, 5, Goods.G_Milk, 7)
    Logic.TradePost_SetTradeDefinition(TradepostID, 1, Goods.G_Grain, 7, Goods.G_Iron, 9)
    Logic.TradePost_SetTradeDefinition(TradepostID, 2, Goods.G_RawFish, 8, Goods.G_Olibanum, 6)
    Logic.TradePost_SetTradeDefinition(TradepostID, 3, Goods.G_Stone, 5, Goods.G_Olibanum, 5)
    Logic.TradePost_SetActiveTradeSlot(TradepostID, 0)



end

----------------------------------------------------------------------------------------------------------------------
function Mission_FirstMapAction()

    -- init players in singleplayer games only
    if Framework.IsNetworkGame() ~= true then

        Startup_Player()
        Startup_StartGoods()
        Startup_Diplomacy()
        
        -- CP: Changed player colors to be more consistent
        Logic.PlayerSetPlayerColor(5 , 15, -1, -1)
        Logic.PlayerSetPlayerColor(8 , 12, -1, -1)
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

    -- Praphat (without any buildings/territory)
    AICore.CreateAIPlayer(8)
    g_Pr = { AttackCount = 0 }

    -- No pallisades until Q1 completed
    LockFeaturesForPlayer( 1, Technologies.R_Pallisade )

    local ID = Logic.GetEntityIDByName("TigerCave")
    Logic.InteractiveObjectSetPlayerState( ID, 1, 2 )
    Logic.InteractiveObjectSetAvailability( ID, false )   
    Logic.InteractiveObjectClearCosts( ID )
    Logic.InteractiveObjectSetTimeToOpen( ID, 5 )
    Logic.InteractiveObjectSetInteractionDistance( ID, 2500 )
    Logic.InteractiveObjectSetDeactivateAfterUse( ID, true )
    
    local ID = Logic.GetEntityIDByName("OldHuntersHut")
    Logic.InteractiveObjectSetPlayerState( ID, 1, 2 )
    Logic.InteractiveObjectSetAvailability( ID, false )   
    Logic.InteractiveObjectClearCosts( ID )
    Logic.InteractiveObjectSetDeactivateAfterUse( ID, true )
    
    for _, Name in ipairs{ "Pulajab_TP", "Ghulabai_TP", "Aknahpur_TP", "Mitrashmir_TP", "Khistangra_TP" } do
        local ID = Logic.GetEntityIDByName(Name)
        Logic.InteractiveObjectSetPlayerState( ID, 1, 2 )
        Logic.InteractiveObjectSetAvailability( ID, false )
    end
    
    --[[
            TODO
            
            Maybe praphats soldiers are too weak due to a lack of reputation (no city)?
            Hmm, could use an existing squad as new bodyguard for praphat if his existing bodyguards died
    ]]
    
end

function CreateCart(_PosName, _PlayerID)

    local X, Y = Logic.GetEntityPosition(Logic.GetEntityIDByName( _PosName ))        
    local Ori = Logic.GetEntityOrientation(Logic.GetEntityIDByName( _PosName ))
    return Logic.CreateEntityOnUnblockedLand(Entities.U_ResourceMerchant, X, Y, Ori-90, _PlayerID);
        
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

PulajabID = 2
SecondKnightID = 6    
PrapahtID = 8 

function Mission_VictoryCutscene_HandleCarts()

    local X, Y = Logic.GetEntityPosition(Logic.GetEntityIDByName( "CartDestination" ))        

    if (g_HandleCarts == 5) then       
        Logic.HireMerchant( Cart1, PulajabID, Goods.G_Gems, 1, PulajabID )
    end

    if (g_HandleCarts == 6) then       
       Logic.HireMerchant( Cart2, PulajabID, Goods.G_Gems, 1, PulajabID )
    end

    if (g_HandleCarts == 8) then       
       Logic.HireMerchant( Cart3, PulajabID, Goods.G_Gems, 1, PulajabID )
    end

    if (g_HandleCarts == 9) then       
       Logic.HireMerchant( Cart4, PulajabID, Goods.G_Gems, 1, PulajabID )
    end

    if (g_HandleCarts > 12) then      
        EnableRights = true
       Logic.StartFestival( 1, 1 )
    end

    g_HandleCarts = g_HandleCarts + 1 

end


function Mission_VictoryCutscene()

    g_HandleCarts = 0
    Cart1 = CreateCart("Cart1", PulajabID)
    Cart2 = CreateCart("Cart2", PulajabID)
    Cart3 = CreateCart("Cart3", PulajabID)
    Cart4 = CreateCart("Cart4", PulajabID)
    StartSimpleJob("Mission_VictoryCutscene_HandleCarts")

    SetFriendly(1, PulajabID)
    SetFriendly(1, SecondKnightID)
    SetFriendly(1, PrapahtID)    
    SetFriendly(SecondKnightID, PulajabID)
    SetFriendly(SecondKnightID, PrapahtID)    
    SetFriendly(SecondKnightID, PulajabID)
        
    do
        local X, Y = Logic.GetEntityPosition(Logic.GetEntityIDByName( "KnightPos" ))        
        local Ori =Logic.GetEntityOrientation(Logic.GetEntityIDByName( "KnightPos" ))
        VictorySetEntityToPosition(Logic.GetKnightID(1), X, Y, Ori)
    end

    do
        local SecondKnight = Entities.U_KnightSaraya
        Logic.ExecuteInLuaLocalState([[SetupPlayer(6, "H_Knight_Saraya", "Saraya")]])
        SarayaID = SecondKnightID
        KnightID = 1
        
        if (Logic.GetEntityType(Logic.GetKnightID(1)) == SecondKnight) then
           SecondKnight = Entities.U_KnightChivalry             
           Logic.ExecuteInLuaLocalState([[SetupPlayer(6, "H_Knight_Chivalry", "Marcus")]])
           SarayaID = 1
           KnightID = SecondKnightID
        end
                
        local X, Y = Logic.GetEntityPosition(Logic.GetEntityIDByName( "SecondKnightPos" ))        
        local Ori =Logic.GetEntityOrientation(Logic.GetEntityIDByName( "SecondKnightPos" ))
        local SecondKnightEntityID = Logic.CreateEntityOnUnblockedLand(SecondKnight, X, Y, Ori-90, SecondKnightID)
        AICore.HideEntityFromAI( SecondKnightID, SecondKnightEntityID, true )
    end
  
    do            
        local X, Y = Logic.GetEntityPosition(Logic.GetEntityIDByName("PraphatPos" ))
        local Ori =Logic.GetEntityOrientation(Logic.GetEntityIDByName( "PraphatPos" ))
        local PraphatEntityID = Logic.CreateEntityOnUnblockedLand(Entities.U_KnightPraphat, X, Y, Ori-90, PrapahtID)
        AICore.HideEntityFromAI( PrapahtID, PraphatEntityID, true )

        Logic.ExecuteInLuaLocalState([[SetupPlayer(8, "H_Knight_Praphat", "Praphat")]])
        
    end

          
    Mission_VictoryJubilate(7, 1)
          
    GenerateVictoryDialog(
        {
            {SarayaID,  "Victory1_SarayaRealmRestored"}, 
            {PrapahtID, "Victory2_Praphat"},
            {KnightID,  "Victory3_Knight"},
        })
    
   Logic.ExecuteInLuaLocalState("Mission_LocalVictory()")

    
end

function Mission_DefeatCutscene_DoNotLoose5Carts()

     GenerateDefeatDialog( {{ PrapahtID, "Defeat_DoNotLoose5Carts" }} )

end

function Mission_DefeatCutscene_NamawiliDied()

    GenerateDefeatDialog( {{ PrapahtID, "Defeat_NamawiliDied" }} )

end

function Mission_DefeatCutscene_VillagesSurrender()

    GenerateDefeatDialog( {{ PrapahtID, "Defeat_VillagesSurrender" }} )

end
