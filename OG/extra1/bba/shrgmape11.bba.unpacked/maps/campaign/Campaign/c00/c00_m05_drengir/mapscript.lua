CurrentMapIsCampaignMap = true

----------------------------------------------------------------------------------------------------------------------
function Mission_InitPlayers()

    --ToDo: Make Sababta an own player
    -- Start AI for Sabatta
    -- Respawn a lots of units until the vikings come


    ThordalPlayerID = SetupPlayer(2, "H_Knight_Song", "Thordals Camp", "BanditsColor1")   
    SabattaPlayerID = SetupPlayer(4, "H_Knight_Sabatt", "Lady Sabatta", "RedPrinceColor")   
    --grandma?
    UlricborgPlayerID = SetupPlayer(5, "H_NPC_Amma", "Ulricborg", "BanditsColor2")       
    ArumstadSetupPlayerID = SetupPlayer(7, "H_NPC_Villager01_NE", "Arumstad", "VillageColor2")   
    TidalhomPlayedID = SetupPlayer(8, "H_NPC_Villager01_NE", "Tidalholm", "VillageColor3") 
    
    
    UlricborgMilitaryPlayerID = SetupPlayer(3, "H_NPC_Mercenary_NE", "Ulricborg", "BanditsColor2")       

    -- set some resources for player 1
    AddResourcesToPlayer(Goods.G_Gold,300)
    AddResourcesToPlayer(Goods.G_Stone,20)
    AddResourcesToPlayer(Goods.G_Wood,50)    
    AddResourcesToPlayer(Goods.G_Carcass,20)
    AddResourcesToPlayer(Goods.G_RawFish,20)
    
    --lock technologies
    local TechologiesToLock = { Technologies.R_Castle_Upgrade_3,
                                Technologies.R_Cathedral_Upgrade_3, 
                                Technologies.R_Storehouse_Upgrade_3,
                                
                                Technologies.R_SiegeEngineWorkshop,
                                Technologies.R_BatteringRam,
                                Technologies.R_Ballista,
                                Technologies.R_AmmunitionCart,
                                Technologies.R_SiegeTower,
                                Technologies.R_Catapult,
                                
                                Technologies.R_Medicine,
                                Technologies.R_HerbGatherer}
    
    LockTitleForPlayer(1, KnightTitles.Marquees)
       
    LockFeaturesForPlayer(1, TechologiesToLock)
    
    SetPlayerMoral(SabattaPlayerID, 1)

end

----------------------------------------------------------------------------------------------------------------------
function Mission_SetStartingMonth()

    Logic.SetMonthOffset(6)

end

----------------------------------------------------------------------------------------------------------------------
function Mission_InitMerchants()
    
    local traderId = Logic.GetStoreHouse(UlricborgPlayerID)
	AddOffer			(traderId,	 5,Goods.G_Clothes)
	AddOffer			(traderId,	 5,Goods.G_Sheep)
	AddOffer			(traderId,	 5,Goods.G_SmokedFish)
	
    
	local traderId = Logic.GetStoreHouse(ArumstadSetupPlayerID)
	AddOffer			(traderId,	 5,Goods.G_Iron)
	AddOffer			(traderId,	 5,Goods.G_Cow)
	AddOffer			(traderId,	 5,Goods.G_SmokedFish)
	
	local traderId = Logic.GetStoreHouse(TidalhomPlayedID)
	AddOffer			(traderId,	 5,Goods.G_Sheep)
	AddOffer			(traderId,	 5,Goods.G_Clothes)
	AddOffer			(traderId,	 5,Goods.G_Iron)

end

----------------------------------------------------------------------------------------------------------------------
function Mission_FirstMapAction()

    StartSimpleJob("HACK_StopVikingSpawn")
       
    DoNotActivateOutlawScripForPlayer(ThordalPlayerID)
    
    DoNotActivateOutlawScripForPlayer(UlricborgPlayerID)
    
    
    --outpost of player 4, near thordal, small and easier
    TerritoryIDMosdal = 15
    
    --other outpost of player 4, medium
    TerritoryIDSvenanger = 11
    
    --player 4 HQ, middle of the map, vikings will help here
    TerritoryIDArumstrand = 10
    
    
    if g_OnGameStartPresentationMode ~= true then
    
        --DisableFoW()
        SetDiplomacyStates()
    
        Mission_SetupQuests()
    end
    

    AIPlayer:new(SabattaPlayerID)
    AICore.SetNumericalFact(SabattaPlayerID, "BARB", 0)
    AICore.SetNumericalFact(SabattaPlayerID, "FEAR", 1000)
    AICore.SetNumericalFact(SabattaPlayerID, "FMDB", 1000)
    AICore.SetNumericalFact(SabattaPlayerID, "FMDS", 1000)
    
    AIPlayer:new(ThordalPlayerID, AIProfile_Mercenaries)    
    AICore.SetNumericalFact(ThordalPlayerID, "FCOP", 0)
    
    AIPlayer:new(UlricborgPlayerID, AIPlayerProfile_Ulricborg)    
    AICore.SetNumericalFact(UlricborgPlayerID, "FCOP", 0)
        
end

----------------------------------------------------------------------------------------------------------------------
HACK_StopVikingSpawn_Counter = 0
function HACK_StopVikingSpawn()

    local NPC_Barracks = GetPlayerEntities(UlricborgPlayerID, Entities.B_NPC_Barracks_NE)
    for i=1,#NPC_Barracks do    
        Logic.RespawnResourceSetMaxCapacity(NPC_Barracks[i], 0)                    
    end
    
    local NPC_Melee_NE = GetPlayerEntities(UlricborgPlayerID, Entities.U_MilitaryBandit_Melee_NE)
    for i=1,#NPC_Melee_NE do   
        Logic.DestroyEntity(NPC_Melee_NE[i])        
    end  

    local NPC_Ranged_NE = GetPlayerEntities(UlricborgPlayerID, Entities.U_MilitaryBandit_Ranged_NE)
    for i=1,#NPC_Ranged_NE do   
        Logic.DestroyEntity(NPC_Ranged_NE[i])        
    end  
    
    -- stop after 2 seconds
    HACK_StopVikingSpawn_Counter = HACK_StopVikingSpawn_Counter + 1    
    if (HACK_StopVikingSpawn_Counter > 2) then
        return true
    end
    
end        

----------------------------------------------------------------------------------------------------------------------
function SetDiplomacyStates()
    
    SetDiplomacyState(1, SabattaPlayerID, DiplomacyStates.Enemy)
    
    SetDiplomacyState(1, ThordalPlayerID, DiplomacyStates.Undecided)
    SetDiplomacyState(1, UlricborgPlayerID, DiplomacyStates.Undecided)    
    SetDiplomacyState(1, ArumstadSetupPlayerID, DiplomacyStates.Undecided)
    SetDiplomacyState(1, TidalhomPlayedID, DiplomacyStates.Undecided)
    
    SetDiplomacyState(ThordalPlayerID, SabattaPlayerID, DiplomacyStates.Enemy)
    
    SetDiplomacyState(ThordalPlayerID, UlricborgPlayerID, DiplomacyStates.TradeContact)
    SetDiplomacyState(ThordalPlayerID, ArumstadSetupPlayerID, DiplomacyStates.TradeContact)
    SetDiplomacyState(ThordalPlayerID, TidalhomPlayedID, DiplomacyStates.TradeContact)

    SetDiplomacyState(SabattaPlayerID, UlricborgPlayerID, DiplomacyStates.Enemy)
    SetDiplomacyState(SabattaPlayerID, ArumstadSetupPlayerID, DiplomacyStates.Enemy)
    SetDiplomacyState(SabattaPlayerID, TidalhomPlayedID, DiplomacyStates.Enemy)
    
    
    --SetDiplomacyState(UlricborgPlayerID, ArumstadSetupPlayerID, DiplomacyStates.Allied)
    --SetDiplomacyState(UlricborgPlayerID, TidalhomPlayedID, DiplomacyStates.Allied)
    --SetDiplomacyState(ArumstadSetupPlayerID, TidalhomPlayedID, DiplomacyStates.Allied)
    
end

----------------------------------------------------------------------------------------------------------------------
function Mission_SetupQuests()
                
    ----------------------------------------------------------------------------------------------------------------------
    -- FIRST QUEST: FIND THORDAL
    ----------------------------------------------------------------------------------------------------------------------               
    local QuestID_FindThordal = QuestTemplate:New("Quest_FindThordal", 1, 1, 
                        { { Objective.Discover, 2, {ThordalPlayerID} } },
                        { { Triggers.Time, 0 } },                                                   
                        0, 
                        { { Reward.Diplomacy, ThordalPlayerID, 4 } },
                        nil, OnThordalFound)

    --DUMMY QUEST: WHEN THORDAL FOUND HE EXPLAINS THE MAP
    local QuestID_ThordalDiscoverd = QuestTemplate:New("Quest_ThordalDiscoverd", ThordalPlayerID, 1, 
                        { { Objective.Dummy } },
                        { { Triggers.Quest, QuestID_FindThordal, QuestResult.Success } }, 
                        0, nil, nil, nil, nil, true, false)
    
    --HIDDEN QUEST SO THORAL AND HIS TROOPS HELP
    thordalHelpsDialogs = {}
    thordalHelpsDialogs[#thordalHelpsDialogs+1] = QuestTemplate:New("NPCTalk_ThordalHelps", ThordalPlayerID, 1, 
                        { { Objective.Create, Entities.U_MilitarySword, 1, TerritoryIDMosdal } },
                        { { Triggers.Quest, QuestID_FindThordal, QuestResult.Success } }, 
                        0, nil, nil, OnThordalHelpDialogSpoken, nil, false)
                        
    thordalHelpsDialogs[#thordalHelpsDialogs+1] = QuestTemplate:New("NPCTalk_ThordalHelps", ThordalPlayerID, 1, 
                        { { Objective.Create, Entities.U_MilitaryBow, 1, TerritoryIDMosdal } },
                        { { Triggers.Quest, QuestID_FindThordal, QuestResult.Success } }, 
                        0, nil, nil, OnThordalHelpDialogSpoken, nil, false)
    
    ----------------------------------------------------------------------------------------------------------------------
    --TUTORIAL QUEST FOR BEEHIVES
    ----------------------------------------------------------------------------------------------------------------------
    
    --step one, dummy quest for baron trigger...
    local QuestID_BeeHivesTrigger = QuestTemplate:New("", ThordalPlayerID, 1, 
                        { { Objective.KnightTitle, KnightTitles.Baron } },
                        { { Triggers.Time, 0 } }, 
                        0, 
                        { { Reward.PrestigePoints, 500 } }, 
                        nil, nil, nil, false, false)
    --step two: quest.
    local QuestID_BuildBeeHive = QuestTemplate:New("Quest_BuildBeehives", ThordalPlayerID, 1,
                        { { Objective.Create, Entities.B_Beehive, 1 } },
                        { { Triggers.Quest, QuestID_BeeHivesTrigger, QuestResult.Success } },
                        0, 
                        { { Reward.PrestigePoints, 2000 } }, 
                        nil, nil, nil, true,true)

    local QuestID_ProduceBeer = QuestTemplate:New("Quest_ProduceMead", ThordalPlayerID, 1,
                        { { Objective.Produce, Goods.G_Beer, 1 } },
                        { { Triggers.Quest, QuestID_BuildBeeHive, QuestResult.Success } },
                        0, 
                        { { Reward.PrestigePoints, 1800 } }, 
                        nil, nil, nil, true, true)

    ----------------------------------------------------------------------------------------------------------------------
    --QUEST FOR SVENANGER
    ----------------------------------------------------------------------------------------------------------------------
    local SvenangerOutpostID = Logic.GetTerritoryAcquiringBuildingID(TerritoryIDSvenanger)
 
    local QuestID_SvenangerDestroy= QuestTemplate:New("Quest_DestroySvenanger", ThordalPlayerID, 1, 
                        { { Objective.DestroyEntities, 1, {SvenangerOutpostID} } }, 
                        { { Triggers.Quest, QuestID_ThordalDiscoverd, QuestResult.Success } }, 
                        0, 
                        { { Reward.PrestigePoints, 1000 }, { Reward.Diplomacy, TidalhomPlayedID, 1 } },
                        nil,OnSvenangerDestroyed,nil,false,true)    
    
    --this is a hidden quest to trigger the next one. The real quest if given to the player only when he destryoed the outpost instead of capture it          
    local QuestID_SvenangerClaim = QuestTemplate:New("Quest_ClaimSvenanger", ThordalPlayerID, 1, 
                        { { Objective.Claim, 1, TerritoryIDSvenanger } }, 
                        { { Triggers.Quest, QuestID_SvenangerDestroy, QuestResult.Success } }, 
                        0,
                        { { Reward.PrestigePoints, 1000 } },
                        nil,nil,nil,false)
                                                    
    local QuestID_SvenangerRebuild = QuestTemplate:New("Quest_RebuildSvenanger", ThordalPlayerID, 1, 
                        { { Objective.Create, Entities.B_HuntersHut, 3, TerritoryIDSvenanger } }, 
                        { { Triggers.Quest, QuestID_SvenangerClaim, QuestResult.Success } }, 
                        0, 
                        {  { Reward.PrestigePoints, 1200 }, { Reward.Diplomacy, TidalhomPlayedID, 1 }, { Reward.Diplomacy, UlricborgPlayerID, 1 }} ,  
                        nil, OnSvenangerRebuilt)

    ----------------------------------------------------------------------------------------------------------------------
    -- QUEST FOR MOSDAL
    ----------------------------------------------------------------------------------------------------------------------
    local MosdalOutpostID = Logic.GetTerritoryAcquiringBuildingID(TerritoryIDMosdal)
 
    local QuestID_MosdalDestroy = QuestTemplate:New("Quest_DestroyMosdal", ThordalPlayerID, 1, 
                        { { Objective.DestroyEntities, 1, {MosdalOutpostID} } }, 
                        { { Triggers.Quest, QuestID_ThordalDiscoverd, QuestResult.Success } }, 
                        0, 
                        { { Reward.PrestigePoints, 1000 },  { Reward.Diplomacy, ArumstadSetupPlayerID, 1 } },
                        nil,OnMosdalDestroyed,nil,false,true)

    --this is a hidden quest to trigger the next one. The real quest if given to the player only when he destryoed the outpost instead of capture it          
    local QuestID_MosdalClaim = QuestTemplate:New("Quest_ClaimMosdal", ThordalPlayerID, 1, 
                         { { Objective.Claim, 1, TerritoryIDMosdal } }, 
                         { { Triggers.Quest, QuestID_MosdalDestroy, QuestResult.Success } }, 
                         0,
                         { { Reward.PrestigePoints, 1000 } },
                         nil,nil,nil,false)
                                                 
    local QuestID_MosdalRebuild = QuestTemplate:New("Quest_RebuildMosdal", ThordalPlayerID, 1, 
                        { { Objective.Create, Entities.B_CattleFarm, 3, TerritoryIDMosdal } }, 
                        { { Triggers.Quest, QuestID_MosdalClaim, QuestResult.Success } }, 
                        0, 
                        { { Reward.PrestigePoints, 1200 }, { Reward.Diplomacy, ArumstadSetupPlayerID, 1 }, { Reward.Diplomacy, UlricborgPlayerID, 1 } }, 
                        nil, OnMosdalRebuilt)

   
    ----------------------------------------------------------------------------------------------------------------------
    -- GOBAL DESTROY INVADERS QUEST (uses the subquest of destroying bandits outpost )
    ----------------------------------------------------------------------------------------------------------------------
    QuestTemplate:New("Quest_DestroyInvaders", ThordalPlayerID, 1, 
                        { { Objective.Quest, {QuestID_SvenangerDestroy, QuestID_MosdalDestroy} } }, 
                        { { Triggers.Quest, QuestID_ThordalDiscoverd, QuestResult.Success } },
                        0, nil, nil, nil, nil, true, false)
                
    --GO TO CITY
    local HarbourStorehouseID = Logic.GetStoreHouse(UlricborgPlayerID)
    
    local QuestID_GoToHarbour = QuestTemplate:New("Quest_GoToHarbour", ThordalPlayerID, 1, 
                        { { Objective.Distance, Logic.GetKnightID(1), HarbourStorehouseID } }, 
                        { { Triggers.Quest, QuestID_MosdalRebuild, QuestResult.Success }, 
                        { Triggers.Quest, QuestID_SvenangerRebuild, QuestResult.Success } },
                        0, 
                        { { Reward.PrestigePoints, 500 } }, 
                        nil, 
                        nil, 
                        nil, 
                        true, 
                        false)

    local QuestID_WentToHarbour = QuestTemplate:New("NPCTalk_WentToHarbour", UlricborgPlayerID, 1, 
                        { { Objective.Dummy } },
                        { { Triggers.Quest, QuestID_GoToHarbour, QuestResult.Success } }, 
                        0, nil, nil, nil, nil,true, false)
   

    local QuestID_DeliverBeer = QuestTemplate:New("Quest_DeliverMead", UlricborgPlayerID, 1,
                        { { Objective.Deliver, Goods.G_Beer, 18 } },
                        { { Triggers.Quest, QuestID_GoToHarbour, QuestResult.Success } },
                        0, 
                        { { Reward.PrestigePoints, 1800 } }, 
                        nil, 
                        OnQuestDone_DeliverBeer
                        )

    local QuestID_BuildSiegeEngineWorkshop = QuestTemplate:New("Quest_BuildSiegeEngineWorkshop", 1, 1,
                        { { Objective.Create, Entities.B_SiegeEngineWorkshop, 1 } },
                        { { Triggers.Quest, QuestID_DeliverBeer, QuestResult.Success } },
                        0, 
                        { { Reward.PrestigePoints, 2000 } }, 
                        nil, 
                        OnSiegeEngineWorkshopBuilt
                        )
       
    local QuestID_ProduceRam = QuestTemplate:New("Quest_ProduceRam", 1, 1,
                        { { Objective.Create, Entities.U_BatteringRamCart, 1 } },
                        { { Triggers.Quest, QuestID_BuildSiegeEngineWorkshop, QuestResult.Success } },
                        0,
                        { { Reward.PrestigePoints, 1000 } }
                        )
        
    local QuestID_AttachBattalion = QuestTemplate:New("Quest_AttachBattalionToRam", 1, 1,
                        { { Objective.Custom, Custom_CheckAttachedBattalionToRam } },
                        { { Triggers.Quest, QuestID_ProduceRam, QuestResult.Success } },
                        0)
                            
    local QuestID_MoveRamToArumstrand = QuestTemplate:New("Quest_MoveRamToArumstrand", 1, 1,
                        { { Objective.Create, Entities.U_BatteringRamCart, 1, TerritoryIDArumstrand } },
                        { { Triggers.Quest, QuestID_AttachBattalion, QuestResult.Success } },
                        0)
    
    local QuestID_AssembleRam = QuestTemplate:New("Quest_AssembleRam", 1, 1,
                        { { Objective.Create, Entities.U_MilitaryBatteringRam, 1, TerritoryIDArumstrand } },
                        { { Triggers.Quest, QuestID_MoveRamToArumstrand, QuestResult.Success } },
                        0)

    local QuestID_DestroyGate = QuestTemplate:New("Quest_DestroyGate", 1, 1,
                        { { Objective.DestroyEntities, 2, Entities.B_WallGate_NE, 1, SabattaPlayerID } },                        
                        { { Triggers.Quest, QuestID_AssembleRam, QuestResult.Success } },
                        0, 
                        { { Reward.PrestigePoints, 1000 } }, 
                        nil, 
                        OnGateDestroyed
                        )
   
    ----------------------------------------------------------------------------------------------------------------------
    -- QUESTS FOR ARUMSTRAND (THE BANDITS HQ)
    ----------------------------------------------------------------------------------------------------------------------
    
    local ArumstrandOutpostID = Logic.GetTerritoryAcquiringBuildingID(TerritoryIDArumstrand)
    
    
    --ToDo: Generate end dialog for each of these quests 
    --END QUESTS
    local QuestID_DestroyArumstrand = QuestTemplate:New("Quest_DestroyArumstrand", UlricborgPlayerID, 1, 
                        { { Objective.DestroyEntities, 1, {ArumstrandOutpostID} } }, 
                        { { Triggers.Quest, QuestID_DestroyGate, QuestResult.Success } }, 
                        0,
                        { { Reward.PrestigePoints, 5000 } },
                        nil,OnArumstrandDestroyed)
--[[
    local QuestID_DestroyArumstrand2 = QuestTemplate:New("Quest_DestroyArumstrand", UlricborgPlayerID, 1, 
                        { { Objective.DestroyEntities, 1, {ArumstrandOutpostID} }, 
                        { Objective.Quest, { QuestID_MosdalRebuild, QuestID_SvenangerRebuild } } }, 
                        { { Triggers.Time, 0 } }, 
                        0,
                        { { Reward.PrestigePoints, 5000 }}, 
                        nil, OnArumstrandDestroyed, nil, false, true)
--]]
    local QuestID_HiddenEnd = QuestTemplate:New("Quest_ProtectVillages", 1, 1, 
                        { { Objective.DestroyEntities, 1, {ArumstrandOutpostID} } }, 
                        {{Triggers.Time, 0}}, 
                        0, nil, nil,OnArumstrandDestroyed, nil, false)    -- dont show this quest                                                        

   ----------------------------------------------------------------------------------------------------------------------
   -- Some small talk with sabatta
   ----------------------------------------------------------------------------------------------------------------------
    
    --HIDDEN QUEST SO SABBATA TALKS TO PLAYER
    aggressiveDialogs = {}
    aggressiveDialogs[#aggressiveDialogs+1] = QuestTemplate:New("NPCTalk_SabattaIsAggresive", SabattaPlayerID, 1, 
                        { { Objective.Create, Entities.U_MilitarySword, 1, TerritoryIDArumstrand } },
                        { { Triggers.Quest, QuestID_WentToHarbour, QuestResult.Success } }, 
                        0, nil, nil, OnAggressiveDialogSpoken, nil, false, true)
                        
    aggressiveDialogs[#aggressiveDialogs+1] = QuestTemplate:New("NPCTalk_SabattaIsAggresive", SabattaPlayerID, 1, 
                        { { Objective.Create, Entities.U_MilitaryBow, 1, TerritoryIDArumstrand } },
                        { { Triggers.Quest, QuestID_WentToHarbour, QuestResult.Success } }, 
                        0, nil, nil, OnAggressiveDialogSpoken, nil, false, true)

    aggressiveDialogs[#aggressiveDialogs+1] = QuestTemplate:New("NPCTalk_SabattaIsAggresive", SabattaPlayerID, 1, 
                        { { Objective.Create, Entities.U_MilitaryBatteringRam, 1, TerritoryIDArumstrand } },
                        { { Triggers.Quest, QuestID_WentToHarbour, QuestResult.Success } }, 
                        0, nil, nil, OnAggressiveDialogSpoken, nil, false, true)

    
   

end

function OnArumstrandDestroyed(_quest)
     ----------------------------------------------------------------------------------------------------------------------
    -- END DIAOLG. SABATTA ESCAPES AND THORDAL JOINS
    ----------------------------------------------------------------------------------------------------------------------
    if VictoryDialogGenerated == nil then
        local QuestID_DummyVictory = QuestTemplate:New("", 1, 1, 
                            { { Objective.Dummy }}, 
                            {{Triggers.Time, 0}}, 
                            0, 
                            { { Reward.CampaignMapFinished } }, 
                            nil,nil, nil, false)    -- dont show this quest                                                        
        
        GenerateVictoryDialog( {
                                    {ThordalPlayerID,"Victory_Thordal" },
                                    {SabattaPlayerID,"Victory_SabattaLeavesMap" }
                               }, QuestID_DummyVictory)
    
        VictoryDialogGenerated = true
        
    end
    
end

function OnThordalHelpDialogSpoken(quest)
    if quest.Result == QuestResult.Success then
        StartHelp = true
        for i=1, #thordalHelpsDialogs do
            if thordalHelpsDialogs[i] ~= quest.Index then
                Quests[thordalHelpsDialogs[i]]:Interrupt()
            end
        end
    end
end

function OnAggressiveDialogSpoken(quest)
    if quest.Result == QuestResult.Success then
        for i=1, #aggressiveDialogs do
            if aggressiveDialogs[i] ~= quest.Index then
                Quests[aggressiveDialogs[i]]:Interrupt()
            end
        end
    end
end

----------------------------------------------------------------------------------------------------------------------
function OnMosdalDestroyed()

    --generate and show claim quest only if player has destroyed outpost instead of capturing it
    if Logic.GetTerritoryPlayerID(TerritoryIDMosdal) ~= 1 then
        QuestTemplate:New("Quest_ClaimMosdal", ThordalPlayerID, 1, 
                         { { Objective.Claim, 1, TerritoryIDMosdal } }, 
                         { { Triggers.Time, 0 } }, 
                         0)
    end

end
----------------------------------------------------------------------------------------------------------------------
function OnSvenangerDestroyed()
    --generate and show claim quest only if player has destroyed outpost instead of capturing it
    if Logic.GetTerritoryPlayerID(TerritoryIDSvenanger) ~= 1 then
        QuestTemplate:New("Quest_ClaimSvenanger", ThordalPlayerID, 1, 
                        { { Objective.Claim, 1, TerritoryIDSvenanger } }, 
                        { { Triggers.Time, 0 } }, 
                        0)
    end
    
end

----------------------------------------------------------------------------------------------------------------------
function ChangeTerritoryPlayerID(_TerritoryID, _NewPlayerID)
    
    local JobTable = {}
    JobTable.TerritoryID = _TerritoryID
    JobTable.NewPlayerID = _NewPlayerID
    JobTable.Counter = 0
    
    Trigger.RequestTrigger(Events.LOGIC_EVENT_EVERY_SECOND, "", "ChangeTerritoryPlayer", 1, 0, { JobQueue_AddParameter(JobTable) })
    
end

----------------------------------------------------------------------------------------------------------------------
function ChangeTerritoryPlayer(slotID)

    local Parameter = JobQueue_GetParameter(slotID)
           
    -- dismount outpost and wait some seconds
    if (Parameter.Counter == 0) then
    
        local OutpostID = Logic.GetTerritoryAcquiringBuildingID(Parameter.TerritoryID)
    
        local BattalionID = Logic.GetBattalionOnBuilding(OutpostID)
        if BattalionID ~= 0 then
            local x, y = Logic.GetBuildingApproachPosition(OutpostID)
            Logic.CommandEntityToDismountBuilding(BattalionID, x, y)
        end
            
    end


    if Parameter.Counter > 5 then
    
        local OuterRimBuildings = { Logic.GetEntitiesOfCategoryInTerritory(Parameter.TerritoryID, 1, EntityCategories.OuterRimBuilding, 0) }
    
        -- save and destroy all outerrim buildings
        local SaveBuildings = {}
        for i=1, #OuterRimBuildings do

            local TempBuilding = {}
            TempBuilding.Type = Logic.GetEntityType(OuterRimBuildings[i])
            TempBuilding.PosX, TempBuilding.PosY = Logic.GetEntityPosition(OuterRimBuildings[i])
            TempBuilding.Orientation = Logic.GetEntityOrientation(OuterRimBuildings[i])        
        
            SaveBuildings[#SaveBuildings + 1] = TempBuilding
        
            Logic.DestroyEntity(OuterRimBuildings[i])
                    
        end
    
        -- destroy and recreate outpost
        do
            local OutpostID = Logic.GetTerritoryAcquiringBuildingID(Parameter.TerritoryID)
            local OutpostType = Logic.GetEntityType(OutpostID)
            local PosX, PosY = Logic.GetEntityPosition(OutpostID)
            local Orientation = Logic.GetEntityOrientation(OutpostID)        

            Logic.DestroyEntity(OutpostID)
            Logic.CreateEntity(OutpostType, PosX, PosY, Orientation, Parameter.NewPlayerID)            
            
        end
    
        -- rebuild the outerrimbuildings
        for i=1, #SaveBuildings do            
            Logic.CreateEntity(SaveBuildings[i].Type, SaveBuildings[i].PosX, SaveBuildings[i].PosY, SaveBuildings[i].Orientation, Parameter.NewPlayerID)
        end
                        
        return true
        
    end
    
    Parameter.Counter = Parameter.Counter + 1
    
end

----------------------------------------------------------------------------------------------------------------------
function OnSvenangerRebuilt()
    ChangeTerritoryPlayerID(TerritoryIDSvenanger, TidalhomPlayedID)
--    Logic.ChangeEntityPlayerID(Logic.GetTerritoryAcquiringBuildingID(TerritoryIDSvenanger), UlricborgPlayerID)
end

----------------------------------------------------------------------------------------------------------------------
function OnMosdalRebuilt()
    ChangeTerritoryPlayerID(TerritoryIDMosdal, ArumstadSetupPlayerID)
end

----------------------------------------------------------------------------------------------------------------------
function Custom_CheckAttachedBattalionToRam()
    local rams = GetPlayerEntities(1, Entities.U_BatteringRamCart)
    if #rams ~= 0 then
        for i=1, #rams do
            if Logic.GetGuardianEntityID(rams[i]) ~= 0 then
                return true
            end
        end
    end
    return nil
end

----------------------------------------------------------------------------------------------------------------------
function OnSiegeEngineWorkshopBuilt()
    
    UnLockFeaturesForPlayer(1, { Technologies.R_BatteringRam })
    
end

----------------------------------------------------------------------------------------------------------------------
function OnQuestDone_DeliverBeer()

    UnLockFeaturesForPlayer(1, { Technologies.R_SiegeEngineWorkshop })
    
    local EntityID = Logic.GetEntityIDByName("Vikings_ShipStart0")        
    local x, y = Logic.GetEntityPosition(EntityID)
    ShipEntityID = Logic.CreateEntity(Entities.D_X_Dragonboat02, x, y, Logic.GetEntityOrientation(EntityID), Logic.EntityGetPlayer(EntityID))
        
    Path:new(ShipEntityID, { "Vikings_ShipStart0", "Vikings_ShipEnd0" }, false, false, OnShipArrivalAtHarbor, nil, true, nil, nil, 100)
       
end

----------------------------------------------------------------------------------------------------------------------
function OnShipArrivalAtHarbor()
           
    local EntityID = Logic.GetEntityIDByName("Vikings_Spawn0")        
    local x, y = Logic.GetEntityPosition(EntityID)
                    
    for i= 1, 20 do
        Logic.CreateBattalionOnUnblockedLand(Entities.U_MilitaryBandit_Melee_NE, x, y, 0, UlricborgPlayerID, 3)
    end
    
end


----------------------------------------------------------------------------------------------------------------------
function OnGateDestroyed()

end

----------------------------------------------------------------------------------------------------------------------
function OnThordalFound()

    Logic.ExecuteInLuaLocalState("OnThordalFound()")
    
end

----------------------------------------------------------------------------------------------------------------------
-- Mercanries profile
----------------------------------------------------------------------------------------------------------------------

----------------------------------------------------------------------------------------------------------------------
function Mercenaries_FindTargetEntity()

   local OutPostID = Logic.GetTerritoryAcquiringBuildingID(TerritoryIDMosdal)
   
   
    if (OutPostID == 0) then
        OutPostID = nil
        StartHelp = false
    else
        if OutPostID.EntityGetPlayerID(OutPostID) == 1 then
            OutPostID = nil
            StartHelp = false
        end
    end

   return OutPostID
   
end

----------------------------------------------------------------------------------------------------------------------
function AIProfile_Mercenaries(self)
        
    if StartHelp then
                
        if (self.m_Behavior["ThordalHelps"] == nil) then
        
            self.m_Behavior["ThordalHelps"] = self:GenerateBehaviour(AIBehavior_AttackOutpost)
            
            self.m_Behavior["ThordalHelps"].m_MinNumberOfSwordsmen = 0  
            self.m_Behavior["ThordalHelps"].m_MaxNumberOfSwordsmen = 6  
            self.m_Behavior["ThordalHelps"].m_AliveNumberOfSwordsmen = 0  
            
            self.m_Behavior["ThordalHelps"].m_MinNumberOfBowmen = 0  
            self.m_Behavior["ThordalHelps"].m_MaxNumberOfBowmen = 6  
            self.m_Behavior["ThordalHelps"].m_AliveNumberOfBowmen = 0  
            
            self.m_Behavior["ThordalHelps"].m_MinNumberOfCatapults = 0  
            self.m_Behavior["ThordalHelps"].m_MaxNumberOfCatapults = 0
            self.m_Behavior["ThordalHelps"].m_FleeNumberOfCatapults = 0
            
            self.m_Behavior["ThordalHelps"].CB_FindTargetEntity = Mercenaries_FindTargetEntity
                
            if (self.m_Behavior["ThordalHelps"]:Start() == false) then
                self.m_Behavior["ThordalHelps"] = nil
            elseif StartHelp then
                SendVoiceMessage(ThordalPlayerID, "NPCTalk_ThordalHelps_Success")
                StartHelp = false
            end
        end
        
    end
end

----------------------------------------------------------------------------------------------------------------------
function AIPlayerProfile_Ulricborg(self)

    if (self.Init == nil) then
    
        self.Init = true
        self.TargetID = Logic.GetTerritoryAcquiringBuildingID(TerritoryIDArumstrand)
        self.SaidWaiting = false
    
    end
   
    -- is target is alive
    if (Logic.IsEntityAlive(self.TargetID) == false) then    
        return    
    end
   
    local IsWayFree = false

    -- check if the way is free ... if not send a message
    local AllLeaders = {Logic.GetPlayerEntitiesInCategory(self.m_PlayerID, EntityCategories.Leader)}
    if (#AllLeaders > 0) then

        -- check if the way to the target is free        
        local StartX, StartY = Logic.GetEntityPosition(AllLeaders[1])
        local EndX, EndY = Logic.GetBuildingApproachPosition(self.TargetID)        
        if (Logic.CanMoveFromTo(AllLeaders[1], StartX, StartY, EndX, EndY) == true) then
        
            IsWayFree = true
    
        else

            if (self.SaidWaiting == false) then
        
                SendVoiceMessage(UlricborgMilitaryPlayerID, "NPCTalk_VikingsWait")
                self.SaidWaiting = true
        
            end
        end
    end
    
    -- the way to arumstarnd is free so go and attack it    
    if (IsWayFree == true) then

        if (self.m_Behavior["AttackArumstrand"] == nil) then
        
            self.m_Behavior["AttackArumstrand"] = self:GenerateBehaviour(AIBehavior_RaidSettlement)
    
            self.m_Behavior["AttackArumstrand"].m_TargetID = self.TargetID
            self.m_Behavior["AttackArumstrand"].m_Radius = 40 * 100  
                        
            self.m_Behavior["AttackArumstrand"].m_MinNumberOfSwordsmen = 0  
            self.m_Behavior["AttackArumstrand"].m_MaxNumberOfSwordsmen = 99  
            self.m_Behavior["AttackArumstrand"].m_AliveNumberOfSwordsmen = 0  
            
            self.m_Behavior["AttackArumstrand"].m_MinNumberOfBowmen = 0  
            self.m_Behavior["AttackArumstrand"].m_MaxNumberOfBowmen = 99  
            self.m_Behavior["AttackArumstrand"].m_AliveNumberOfBowmen = 0  
            
            if (self.m_Behavior["AttackArumstrand"]:Start()) then            
                SendVoiceMessage(UlricborgMilitaryPlayerID, "NPCTalk_VikingsAttack")                
            else            
                self.m_Behavior["AttackArumstrand"] = nil
            end
        end    
    end

end


function Mission_Victory()

    local VictoryThordalPos = Logic.GetEntityIDByName("VictoryThordalPos")
    local x,y = Logic.GetEntityPosition(VictoryThordalPos)
    local Orientation = Logic.GetEntityOrientation(VictoryThordalPos)
    local ThordalID = Logic.GetKnightID(ThordalPlayerID)
    if ThordalID ~= nil then
        VictorySetEntityToPosition( ThordalID, x, y, Orientation )
    else
        Logic.CreateEntityOnUnblockedLand(Entities.U_KnightSong, x, y, Orientation-90, ThordalPlayerID)
    end
    
    
    local VictoryKnightPos = Logic.GetEntityIDByName("VictoryKnightPos")
    local x,y = Logic.GetEntityPosition(VictoryKnightPos)
    local Orientation = Logic.GetEntityOrientation(VictoryKnightPos)
    VictorySetEntityToPosition( Logic.GetKnightID(1), x, y, Orientation )

    local PossibleSettlerTypes = {Entities.U_NPC_Monk_NE,
                                  Entities.U_NPC_Monk_NE,
                                  Entities.U_NPC_Villager01_NE,
                                  Entities.U_NPC_Villager01_NE,
                                  Entities.U_SpouseS01,
                                  Entities.U_SpouseS02,
                                  Entities.U_SpouseS03,
                                  Entities.U_SpouseF01,
                                  Entities.U_SpouseF02,
                                  Entities.U_SpouseF03 }
    
    VictoryGenerateFestivalAtPlayer( UlricborgPlayerID, PossibleSettlerTypes )    

end