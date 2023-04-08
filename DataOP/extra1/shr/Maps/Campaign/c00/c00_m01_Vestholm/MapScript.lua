CurrentMapIsCampaignMap = true

----------------------------------------------------------------------------------------------------------------------
function Mission_InitPlayers()

    GlobalTutorial = {}

    GlobalTutorial.VestholmKnight = "Chivalry"
    
    --Other knight speakes for Vestholm
    local Head = "H_Knight_Chivalry"
    
    local KnightType = Logic.GetEntityType(Logic.GetKnightID(1))
    
    if KnightType == Entities.U_KnightChivalry then
        Head = "H_Knight_Healing"
        GlobalTutorial.VestholmKnight = "Healing"
    end
    
    
    VestholmPlayerID = SetupPlayer(2, Head, "", "CityColor4")
    MonkPlayerID = SetupPlayer(3, "H_NPC_Monk_ME", "Monk", "VillageColor1")
    BanditsPlayerID = SetupPlayer(5, "H_Mercenary_ME", "Bandits", "BanditsColor1")
    HarbourPlayerID = SetupPlayer( 4 , "H_NPC_Generic_Trader", "XTradeShipX", "TravelingSalesmanColor")

    -- set some resources for player 2
    AddResourcesToPlayer(Goods.G_Gold,250,2)
    AddResourcesToPlayer(Goods.G_Stone,50,2)
    AddResourcesToPlayer(Goods.G_Wood,50,2)
    AddResourcesToPlayer(Goods.G_Grain,100,2)
    AddResourcesToPlayer(Goods.G_Carcass,100,2)
    AddResourcesToPlayer(Goods.G_RawFish,100,2)
    AddResourcesToPlayer(Goods.G_Milk,100,2)
    AddResourcesToPlayer(Goods.G_Wool,100,2)
    AddResourcesToPlayer(Goods.G_Honeycomb,50,2)
    AddResourcesToPlayer(Goods.G_Iron,50,2)
    AddResourcesToPlayer(Goods.G_Iron,50,2)


    local Gold = 300 + 250

    AddResourcesToPlayer(Goods.G_Gold,Gold,1)
    AddResourcesToPlayer(Goods.G_Wood,28,1)
    AddResourcesToPlayer(Goods.G_Stone,19,1)    
    AddResourcesToPlayer(Goods.G_Carcass,5,1)

    SetDiplomacyState(1,5, DiplomacyStates.Enemy)
    SetDiplomacyState(1,6, DiplomacyStates.Enemy)
    SetDiplomacyState(2,5, DiplomacyStates.Enemy)
    SetDiplomacyState(2,6, DiplomacyStates.Enemy)
    
    SetDiplomacyState(1, 2, DiplomacyStates.Allied)
    
    local TechologiesToLock = NeedsAndRightsByKnightTitle[KnightTitles.Knight][4]
    LockFeaturesForPlayer( 1, TechologiesToLock)
    
    local TechologiesToLock = NeedsAndRightsByKnightTitle[KnightTitles.Mayor][4]
    LockFeaturesForPlayer( 1, TechologiesToLock)
    
    
    local TechologiesToLock = { Technologies.R_Castle_Upgrade_2,
                                Technologies.R_Cathedral_Upgrade_1,
                                Technologies.R_Storehouse_Upgrade_2,
                                Technologies.R_BuildingUpgrade,
                                Technologies.R_KnockDown
                                }
    
    LockFeaturesForPlayer( 1, TechologiesToLock)
    
    LockTitleForPlayer(1, KnightTitles.Baron)
    
    SetKnightTitle(VestholmPlayerID, KnightTitles.Marquees)
    
    FillInStocksOfBigCity(VestholmPlayerID,true)
    

end
----------------------------------------------------------------------------------------------------------------------
function Mission_SetStartingMonth()

    Logic.SetMonthOffset(3)

end
----------------------------------------------------------------------------------------------------------------------
function Mission_InitMerchants()

    local traderId = Logic.GetStoreHouse(3)

    local playerId = 1

    local traderId = Logic.GetStoreHouse(3)
    AddOffer			(traderId,	 5,Goods.G_Wood)
    AddOffer			(traderId,	10,Goods.G_Cheese)
    AddEntertainerOffer	(traderId,	Entities.U_FireEater)
	AddMercenaryOffer	(traderId	, 3, Entities.U_MilitaryBandit_Meelee_ME)


	local traderId = Logic.GetStoreHouse(4)
	AddOffer			(traderId,	 5,Goods.G_Stone)
	AddOffer			(traderId,	 5,Goods.G_Wood)

	DeActivateMerchantForPlayer( traderId, playerId )

    SetPlayerDoesNotBuyGoodsFlag( VestholmPlayerID, true)
    SetPlayerDoesNotBuyGoodsFlag( MonkPlayerID, true)
    SetPlayerDoesNotBuyGoodsFlag( HarbourPlayerID, true)


end
----------------------------------------------------------------------------------------------------------------------
function Mission_FirstMapAction()

    local Deer = Logic.GetEntityIDByName("Deer")
    Logic.RespawnResourceSetMaxSpawn(Deer, 0.1)
    Logic.RespawnResourceSetMinSpawn(Deer, 0.1)

    
    for i=1, 2 do
        local RuinID = Logic.GetEntityIDByName("Ruin" .. i)
        Logic.InteractiveObjectSetAvailability(RuinID, false)
        Logic.InteractiveObjectSetPlayerState(RuinID, 1, 2)
    end

    DoNotStartAIForPlayer( VestholmPlayerID )
    
    GlobalTutorial.Entities = {}
    GlobalTutorial.Entities.WoodcutterPosition = Logic.GetEntityIDByName("WoodcutterPosition")
    GlobalTutorial.Entities.ClaimPosition = Logic.GetEntityIDByName("ClaimPosition")
    GlobalTutorial.Entities.HunterPosition = Logic.GetEntityIDByName("HunterPosition")
    GlobalTutorial.Entities.ButcherPosition = Logic.GetEntityIDByName("ButcherPosition")    
    
    GlobalTutorial.Entities.Knight = Logic.GetKnightID(1)
    GlobalTutorial.Entities.Marketplace = Logic.GetMarketplace(1)
    GlobalTutorial.Entities.Castle = Logic.GetHeadquarters(1)
    GlobalTutorial.Entities.Storehouse = Logic.GetStoreHouse(1)
    GlobalTutorial.Entities.SpawnEntity = Logic.GetEntityIDByName("SpawnPoint")
    GlobalTutorial.Entities.StoneCartCameraLookAt = Logic.GetEntityIDByName("StoneCartCameraLookAt")
    GlobalTutorial.Entities.TroopSpawnPoint = Logic.GetEntityIDByName("TroopSpawnPoint")
    
    
    local x,y = Logic.GetEntityPosition(Logic.GetEntityIDByName("Monk"))
    GlobalTutorial.Entities.Monk = Logic.CreateEntityOnUnblockedLand(Entities.U_NPC_Monk_ME, x, y, 0, 2)
    
    --create knight for vestholm
    do
        local SpawnID = Logic.GetEntityIDByName("VestholmKnight")
        local x,y = Logic.GetEntityPosition(SpawnID)    
        local Orientation = Logic.GetEntityOrientation(SpawnID)
        local KnightType = Entities.U_KnightChivalry
        
        if Logic.GetEntityType(Logic.GetKnightID(1)) == Entities.U_KnightChivalry then
            KnightType = Entities.U_KnightHealing
        end
        
        GlobalTutorial.Entities.VestholmKnight = Logic.CreateEntityOnUnblockedLand(KnightType,x,y,Orientation,2)
    end

    if g_OnGameStartPresentationMode ~= true then
        DeletePresentationModeBuildings()
    end
    
    GlobalTutorial.MoveToStartPath = {}
    GlobalTutorial.MoveToKnightPath = {}
    
    GenerateArrowsForPath("MoveToKnightPath", 8,  GlobalTutorial.MoveToKnightPath)
    
    DoNotActivateOutlawScripForPlayer( 5 )
    
    StartSimpleJob("CheckPlayerHasEnoughStones")
    StartSimpleJob("HACK_StopBanditSpawn")
    
    MakeInvulnerable(Logic.GetStoreHouse(BanditsPlayerID))
end

 function DeletePresentationModeBuildings()

    for i=1,3 do
        local BuildingID = Logic.GetEntityIDByName("ForPresentation" .. i)
        Logic.DestroyEntity(BuildingID)
    end

end


function SpawnTraders()

    local SpawnPoint = Logic.GetEntityIDByName("TraderSpawn")
    local X,Y = Logic.GetEntityPosition(SpawnPoint)

    local TraderID =  Logic.CreateEntityOnUnblockedLand(Entities.U_Marketer,X,Y,0,2)
    Logic.HireMerchant(TraderID, 2, Goods.G_Bread, 9, 3)

    GlobalTutorial.TraderID = TraderID

end


function SpawnTroopsAndSendThemToPlayer( EntityID )

    
    for i=1,2 do
        local x, y = Logic.GetEntityPosition(EntityID)
    
        if Logic.IsBuilding(EntityID) == 1 then
            x, y = Logic.GetBuildingApproachPosition(EntityID)
        end

    	GlobalTutorial.TroopID  = Logic.CreateBattalionOnUnblockedLand(Entities.U_MilitarySword, x,y, 0, 1, 9)
    
    	local MarketplaceID = Logic.GetMarketplace(1)
    
    	x, y = Logic.GetBuildingApproachPosition(MarketplaceID)
    
    	Logic.MoveSettler(GlobalTutorial.TroopID, x, y)
    end
    
end

function GenerateQuest()

    AIPlayer:new(VestholmPlayerID, AIPlayerProfile_City)                

    --EnableFoW()
    Logic.ExecuteInLuaLocalState("Display.SetRenderFogOfWar(1)")

    --ShowQuestMarker(GlobalTutorial.Entities.ClaimPosition)
    
    
    GenerateArrowsForPath("MoveToStoneQuarry", 4,  GlobalTutorial.MoveToStartPath)
    
    
    --we need a jump to button for distance 
    local moveToTerritoryQuestID, moveToTerritoryQuest = QuestTemplate:New("Quest_MoveToTerritory", 1, 1,
                                                        { {Objective.Distance, Logic.GetKnightID(1), GlobalTutorial.Entities.ClaimPosition  }},
                                                        { { Triggers.Time, 0 } },
                                                        0, nil,nil,OnMoveToTerritory, nil, true, false)
    
    --redefine the trigger function of this quest to highlight button when th quest starts
    function moveToTerritoryQuest:Trigger()
        QuestTemplate.Trigger(self)--call the generic function for this quest
        Logic.ExecuteInLuaLocalState("ActivateQuestButtonHighlight()")
    end


    local TerritoryToClaim = 21
    local createOutpostQuestID = QuestTemplate:New("Quest_CreateOutpost", 1, 1,
                                                    { {Objective.Create, Entities.B_BuildingPlot_8x8,1,TerritoryToClaim  }},
                                                    { { Triggers.Quest, moveToTerritoryQuestID , QuestResult.Success} },
                                                    0, nil,nil,OnBuildinsiteCreated, nil, true, false)


    local claimTerritoryQuestID = QuestTemplate:New("Quest_ClaimTerritory", 1, 1,
                                                    { {Objective.Claim, 1, TerritoryToClaim  }},
                                                    { { Triggers.Quest, createOutpostQuestID , QuestResult.Success} },
                                                    0, nil,nil,OnClaimTerritory, nil, true, false)


    local createStonecutterQuestID = QuestTemplate:New("Quest_BuildStonemine", 1, 1,
                                                    { {Objective.Create, Entities.B_StoneQuarry,2,TerritoryToClaim  }},
                                                    { { Triggers.Quest, claimTerritoryQuestID , QuestResult.Success} },
                                                    0, nil,nil,OnBuildStoneMineFinished, nil, true, false)


    
    QuestTemplate:New("", 1, 1,
                    { {Objective.Create, Entities.B_BuildingPlot_8x8,1,TerritoryToClaim  }},
                    { { Triggers.Quest, claimTerritoryQuestID , QuestResult.Success} },
                    0, nil,nil,OnStonecutterBuildinsiteCreated, nil, false, false)

    QuestTemplate:New("", 1, 1,
                    { {Objective.Create, Entities.B_BuildingPlot_8x8,2,TerritoryToClaim  }},
                    { { Triggers.Quest, claimTerritoryQuestID , QuestResult.Success} },
                    0, nil,nil,OnStonecutterBothBuildinsiteCreated, nil, false, false)


    local buildTannerQuestID = QuestTemplate:New("Quest_BuildTanner" .. GlobalTutorial.VestholmKnight, VestholmPlayerID, 1,
                                                    { {Objective.Create, Entities.B_Tanner,1 }},
                                                    { { Triggers.Quest, createStonecutterQuestID , QuestResult.Success} },
                                                    0, nil,nil,OnBuildTannerDone, nil, true, false)
    
    local StartTerritory = 5
    QuestTemplate:New("", 1, 1,
                    { {Objective.Create, Entities.B_BuildingPlot_8x8,2,StartTerritory  }},
                    { { Triggers.Quest, createStonecutterQuestID , QuestResult.Success} },
                    0, nil,nil,OnTannerBuildinsitesCreated, nil, false, false)
    
    local KnightTitleClothes = KnightTitleRequirements[KnightTitles.Mayor].Good[2]
    local produceClothesQuestID = QuestTemplate:New("Quest_ProduceClothes" .. GlobalTutorial.VestholmKnight, VestholmPlayerID, 1,
                                                    { {Objective.Produce, Goods.G_Leather, KnightTitleClothes }},
                                                    { { Triggers.Quest, buildTannerQuestID , QuestResult.Success} },
                                                    0, nil, nil, OnProduceClothesDone, DuringProcudeLeather)

    --quest: build street (not possible)
        
end

function GenerateStealStoneCutscene() 

    BecomeMayorID = QuestTemplate:New("Quest_BecomeMayor" .. GlobalTutorial.VestholmKnight ,VestholmPlayerID,1,
                                        { {Objective.KnightTitle,KnightTitles.Mayor  }},
                                        { { Triggers.Time, 0 } },
                                        0,nil,nil,OnMayorQuestCompleted)
    StealStoneCutsceneCounter = 0
    StartSimpleJob("StealStoneCutscene")
        
end


function StealStoneCutscene()
   --start cutscene, when cart is there
    if StealStoneCutsceneCounter == 10 then
        
        Logic.ExecuteInLuaLocalState("StartStealStoneCutscene()")    
        Logic.ExecuteInLuaLocalState("Display.SetRenderFogOfWar(0)")

        local SpawnEntity = Logic.GetEntityIDByName("SpawnPoint")
        local x,y = Logic.GetEntityPosition(SpawnEntity)
        
        StoneCartID =  Logic.CreateEntityOnUnblockedLand(Entities.U_ResourceMerchant,x,y,0,1)
        Logic.HireMerchant(StoneCartID, 1, Goods.G_Stone, 20, 2)
        
        SendVoiceMessage(VestholmPlayerID,"NPCTalk_SendStone" .. GlobalTutorial.VestholmKnight)
        
        SpawnBanditsForAttacks()
        
    --steal it with bandits
    elseif StealStoneCutsceneCounter == 13 then
        --BanditsPackGroupAttack( Logic.GetStoreHouse(5), StoneCartID )
        local Bandits = {Logic.GetPlayerEntitiesInCategory(BanditsPlayerID, EntityCategories.Leader)}        
        local LeaderID = Bandits[1]
        Logic.GroupAttack(LeaderID,StoneCartID)
        
    elseif StealStoneCutsceneCounter == 20 then
        
        SendVoiceMessage(VestholmPlayerID,"NPCTalk_TheyStolenTheStone" .. GlobalTutorial.VestholmKnight)
        
    elseif StealStoneCutsceneCounter == 30 then
        
        local Bandits = {Logic.GetPlayerEntitiesInCategory(BanditsPlayerID, EntityCategories.Leader)}        
        --local CampID = Logic.GetStoreHouse(BanditsPlayerID)
        local x,y = Logic.GetEntityPosition("BanditSpawn")
                
        for i=1, #Bandits do        
            Logic.MoveSettler(Bandits[i], x,y)
        end
        
        GenerateQuest()
        
        return true
    end
    
    StealStoneCutsceneCounter = StealStoneCutsceneCounter + 1
            

end

function OnTannerBuildinsitesCreated()
    Logic.ExecuteInLuaLocalState("DeactivateTutorialMarker()")
end

function OnBuildTannerDone(_Quest)

    Logic.ExecuteInLuaLocalState("DeactivateTutorialMarker()")
    
    local KnightTitleClothes = KnightTitleRequirements[KnightTitles.Mayor].Good[2]


    StartMissionGoodCounter(Goods.G_Leather, KnightTitleClothes)
    

end

function DuringProcudeLeather(_Quest)
    
    if _Quest.State == QuestState.Active then
        if CameraRotationExplainedCounter == nil then
            CameraRotationExplainedCounter = 30
        end
    
        CameraRotationExplainedCounter = CameraRotationExplainedCounter - 1
    
        if CameraRotationExplained == nil and CameraRotationExplainedCounter  < 0 then
            SendVoiceMessage(1, "Quest_RotateCamera")
            CameraRotationExplained = true
        end
    
        local LeatherInCity = GetPlayerGoodsInSettlement(Goods.G_Leather, 1)
        MissionCounter.CurrentAmount = LeatherInCity
    
    end
    
end

function OnProduceClothesDone()
    MissionCounter.CurrentAmount = 20
end

function OnMoveToTerritory()

    DestroyArrowPath(GlobalTutorial.MoveToStartPath)

    --DestroyQuestMarker(GlobalTutorial.Entities.ClaimPosition)
    Logic.ExecuteInLuaLocalState("ShowClaimButton()")
    
    Logic.ExecuteInLuaLocalState("ActivateTutorialMarkerEx('/InGame/Root/Normal/AlignBottomRight/MapFrame/KnightButton', '/InGame/Root/Normal/AlignBottomRight/DialogButtons/Knight/ClaimTerritory')")

end

function OnBuildinsiteCreated()
    Logic.ExecuteInLuaLocalState("DeactivateTutorialMarker()")
end

function OnClaimTerritory()
    
    UnLockFeaturesForPlayer(1, Technologies.R_StoneQuarry)
    
    Logic.ExecuteInLuaLocalState("ActivateTutorialMarkerEx('/InGame/Root/Normal/AlignBottomRight/BuildMenu/Categories/Gatherer', '/InGame/Root/Normal/AlignBottomRight/BuildMenu/SubMenus/Gatherer/Buttons/B_StoneQuarry')")
end

function DuringUpgradeStonemine(_Quest)
    
    local StoneQuarries = {Logic.GetPlayerEntities(1,Entities.B_StoneQuarry, 2,0)}
    
    for i=2, #StoneQuarries do    
        local StoneQuarryID = StoneQuarries[i]
        
        if Logic.GetUpgradeLevel(StoneQuarryID) > 0 then
            _Quest:Success()
        end
        
    end
    
end


function Custom_CastleUpgraded()
    
    if Logic.GetUpgradeLevel(Logic.GetHeadquarters(1)) > 0 then
        return true
    end
    
end


function OnBuildStoneMineFinished() 
    
    
    
    UnLockFeaturesForPlayer(1,Technologies.R_Clothes)
    UnLockFeaturesForPlayer(1,Technologies.R_Tanner)
    
    Logic.ExecuteInLuaLocalState("ActivateTutorialMarkerEx('/InGame/Root/Normal/AlignBottomRight/BuildMenu/Categories/Clothes', '/InGame/Root/Normal/AlignBottomRight/BuildMenu/SubMenus/Clothes/Buttons/B_Tanner')")
    
    
end

function OnStonecutterBuildinsiteCreated()    
    SendVoiceMessage(1, "Tutorial_ExplainBuildingRotation")
end

function OnStonecutterBothBuildinsiteCreated()

    Logic.ExecuteInLuaLocalState("DeactivateTutorialMarker()")
    --SendVoiceMessage(1, "NPCTalk_BuildTrail")
    SendVoiceMessage(1, "Quest_BuildTrail")
    UnLockFeaturesForPlayer(1,Technologies.R_Construction)
    UnLockFeaturesForPlayer(1,Technologies.R_Trail)
    
end


function CheckPlayerHasEnoughStones()
    
    local PlayersStone = GetPlayerResources(Goods.G_Stone, 1)
    local CastleUpgradeCosts = Logic.GetBuildingUpgradeCostByGoodType(Logic.GetHeadquarters(1) , Goods.G_Stone, 0) 

    if   PlayersStone >= CastleUpgradeCosts
        and UpgradeCastleQuestGenerated == nil then
        
            local upgradeCastleQuestID = QuestTemplate:New("Quest_UpgradeCastle", 1, 1,
                                                    { {Objective.Custom, Custom_CastleUpgraded}},
                                                    { { Triggers.Time, 0 } },
                                                    0)
        
            UpgradeCastleQuestGenerated = true
    end
    
end

function ShowQuestMarker(_Entity)
    
    if Questmarkers == nil then
        Questmarkers = {}
    end
    
    local x,y = Logic.GetEntityPosition(_Entity)
    
    local Marker = EGL_Effects.E_Questmarker_low
    
    local EntityType = Logic.GetEntityType(_Entity)
    
    if  Logic.IsBuilding(_Entity) == 1 
    and EntityType ~= Entities.B_Marketplace_ME then
        Marker = EGL_Effects.E_Questmarker
    end
    
    Questmarkers[_Entity] = Logic.CreateEffect(Marker, x,y,0)
    
end


function DestroyQuestMarker(_Entity)
    Logic.DestroyEffect(Questmarkers[_Entity])
end


function StopKnight()

    local KnightID = Logic.GetKnightID(1)
    local x,y = Logic.GetEntityPosition(KnightID)

    Logic.MoveSettler(KnightID, x, y)

end


function OnMayorQuestCompleted()

    --DisableFoW()
    Logic.ExecuteInLuaLocalState("Display.SetRenderFogOfWar(0)")
    
    SpawnBanditsForAttacks()

    local x, y = Logic.GetEntityPosition(GlobalTutorial.Entities.TroopSpawnPoint)
    
    Bowmen1  = Logic.CreateBattalionOnUnblockedLand(Entities.U_MilitaryBow, x,y, 0, 1, 9)
    Swordsmen1  = Logic.CreateBattalionOnUnblockedLand(Entities.U_MilitarySword, x,y, 0, 1, 9)    
    Spearmen1  = Logic.CreateBattalionOnUnblockedLand(Entities.U_MilitarySpear, x,y, 0, 1, 9)    
    
    local MarketplaceID = Logic.GetMarketplace(1)    
    x, y = Logic.GetBuildingApproachPosition(MarketplaceID)
    
    Logic.MoveSettler(Bowmen1, x, y)
    Logic.MoveSettler(Swordsmen1, x, y)
    Logic.MoveSettler(Spearmen1, x, y)
    
    BanditsAttackCutsceneCounter = 0
    StartSimpleJob("BanditsAttackPlayerCutscene")
    
    
    Logic.ExecuteInLuaLocalState("OnMayorQuestCompleted()")
    
end


function BanditsAttackPlayerCutscene()

    if BanditsAttackCutsceneCounter == 0 then
        
        local Target = Swordsmen1
        
        local Bandits = {Logic.GetPlayerEntitiesInCategory(BanditsPlayerID, EntityCategories.Military)}
        
        for i=1,#Bandits do
            Logic.GroupAttack(Bandits[i], Spearmen1)
        end
         
        
        Logic.ExecuteInLuaLocalState("StartBanditsAttackPlayerCutscene()")    
        
        --stop respawning of bandits and set up the needed stuff    
        Logic.RespawnResourceSetMaxCapacity(Logic.GetStoreHouse(5), 0)            
    
    end
    
    if BanditsAttackCutsceneCounter == 20 then
        MakeVulnerable(Logic.GetStoreHouse(BanditsPlayerID))
        SendVoiceMessage(1,"NPCTalk_BanditsAreAttacking")
        Logic.ExecuteInLuaLocalState("Display.SetRenderFogOfWar(1)")
        
        
        --local BanditsCampsOfPlayer5 = {Logic.GetBuildingsByPlayer(5)}    
        
        local Bandits = {Logic.GetPlayerEntitiesInCategory(BanditsPlayerID, EntityCategories.Soldier)}
        
        local destroyBanditsQuestID = QuestTemplate:New("NPCTalk_TheyHaveNoChance" .. GlobalTutorial.VestholmKnight,2,1,
                                        { {Objective.DestroyEntities,1,  Bandits  } },
                                        { { Triggers.Time, 0 } },
                                        0,
                                        { { Reward.CampaignMapFinished } }, 
                                        nil, nil, nil, true, false)
        
        
        GenerateVictoryDialog({{VestholmPlayerID,"Quest_DestroyCamps_Success" },
                            {VestholmPlayerID,"Victory_Vestholm" },
                            {1,"Victory_PlayersKnight" },
                            {VestholmPlayerID,"Victory_Final" }}, destroyBanditsQuestID)
    
        return true
    end

    
    
    BanditsAttackCutsceneCounter = BanditsAttackCutsceneCounter + 1
end




function SendFoodFromCity()

    local Storehouse = Logic.GetStoreHouse(2)
    local x, y = Logic.GetBuildingApproachPosition(Storehouse)

    local TraderID =  Logic.CreateEntityOnUnblockedLand(Entities.U_Marketer,x,y,0,2)
    Logic.HireMerchant(TraderID, 1, Goods.G_Bread, 9, 2)

    local Troop = Logic.CreateBattalionOnUnblockedLand(Entities.U_MilitarySword, x,y, 0, 1, 9)

    Logic.GroupGuard(Troop, TraderID)

end


function GenerateArrowsForPath(_PathName, _Number, _Table, _DontDeleteByKnight)
    
    --create path    
    for i=1, _Number do
    
        local MoveToID = Logic.GetEntityIDByName(_PathName .. i)
        local x,y = Logic.GetEntityPosition(MoveToID)    
        local Orientation = Logic.GetEntityOrientation(MoveToID)
        
        _Table[i] = Logic.CreateEntity(Entities.E_DirectionMarker,x,y,Orientation,1)
    end
    
    
    if _DontDeleteByKnight ~= true then
        StartSimpleJob("DeleteArrowsWhenPlayerIsNear")
    end
    
end


function DestroyArrowPath(_Table)

    for i=1, #_Table do
        local ArrowID = _Table[i]
        if  Logic.IsEntityAlive(ArrowID) then
            Logic.DestroyEntity(ArrowID)
        end
    end
    
end


function DeleteArrowsWhenPlayerIsNear()
    
    if #GlobalTutorial.MoveToStartPath == 0 then
        return true
    end
    
    for i=1, #GlobalTutorial.MoveToStartPath do
        local ArrowID = GlobalTutorial.MoveToStartPath[i]
        
        if  Logic.IsEntityAlive(ArrowID) 
        and Logic.CheckEntitiesDistance(GlobalTutorial.Entities.Knight,ArrowID, 750) then     
            
            for j = 1, i do
                local ArrowToDelete = GlobalTutorial.MoveToStartPath[1]
                Logic.DestroyEntity(ArrowToDelete)
                table.remove(GlobalTutorial.MoveToStartPath, 1)
            end
            
        end
    end

end


function PresentationStartShipTrader()

     ActivateTravelingSalesman(      4,                                  --TraderplayerID
                                    {
                                        {Logic.GetCurrentMonth(),     {  {Goods.G_Salt,5},{Entities.U_FireEater} }     } , --month 3 and the offers
                                    }
                              )

end


function SpawnBanditsForAttacks()

    local BanditsHQ = Logic.GetStoreHouse(BanditsPlayerID)
    
    local x,y = Logic.GetBuildingApproachPosition(BanditsHQ)
    
    local NPC_Melee = GetPlayerEntities(BanditsPlayerID, Entities.U_MilitaryBandit_Melee_ME)
    local NPC_Range = GetPlayerEntities(BanditsPlayerID, Entities.U_MilitaryBandit_Ranged_ME)
    
    if #NPC_Melee == 0 then
        for i=1, 2 do
            Logic.CreateBattalionOnUnblockedLand(Entities.U_MilitaryBandit_Melee_ME, x,y, 0, BanditsPlayerID, 3)
        end
    end
    if #NPC_Range == 0 then
        for i=1, 2 do
            Logic.CreateBattalionOnUnblockedLand(Entities.U_MilitaryBandit_Ranged_ME, x,y, 0, BanditsPlayerID, 3)
        end
    end
    
end


HACK_StopBanditSpawn_Counter = 0
function HACK_StopBanditSpawn()

    local NPC_Camp = GetPlayerEntities(BanditsPlayerID, Entities.B_NPC_BanditsHQ_ME)
    for i=1,#NPC_Camp do    
        Logic.RespawnResourceSetMaxCapacity(NPC_Camp[i], 0)                    
    end
    
    local NPC_Melee = GetPlayerEntities(BanditsPlayerID, Entities.U_MilitaryBandit_Melee_ME)
    for i=1,#NPC_Melee do   
        Logic.DestroyEntity(NPC_Melee[i])        
    end  

    local NPC_Ranged = GetPlayerEntities(BanditsPlayerID, Entities.U_MilitaryBandit_Ranged_ME)
    for i=1,#NPC_Ranged do   
        Logic.DestroyEntity(NPC_Ranged[i])        
    end  
    
    -- stop after 20 seconds
    HACK_StopBanditSpawn_Counter = HACK_StopBanditSpawn_Counter + 1    
    if (HACK_StopBanditSpawn_Counter > 20) then
        return true
    end
    
end        



function Mission_Victory()

    StartSimpleJob("MissionVictorySpawnTraders")

end


function MissionVictorySpawnTraders()
    
    if math.mod(Logic.GetTime(), 12) == 0 then
        
        if VictoryTraderID ~= nil and Logic.IsEntityAlive(VictoryTraderID) then
            Logic.DestroyEntity(VictoryTraderID)
        end
        
        local SpawnPoint = Logic.GetEntityIDByName("MoveToPath2")
        local X,Y = Logic.GetEntityPosition(SpawnPoint)
    
        VictoryTraderID =  Logic.CreateEntityOnUnblockedLand(Entities.U_Marketer,X,Y,29.25,2)
        Logic.HireMerchant(VictoryTraderID, 2, Goods.G_Bread, 9, 3)
        
    end
    
end

