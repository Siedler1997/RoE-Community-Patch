Script.Load("Script\\Global\\CampaignHotfix.lua")

CurrentMapIsCampaignMap = true
wellList = { "well1", "well2", "well3", "well4" }
TotalWellActivations = 0
HusranAttacksTriggered = false
HusranAttackCounter = 5 * 60
----------------------------------------------------------------------------------------------------------------------
function Mission_InitPlayers()

    HusranPlayerID = SetupPlayer(2, "H_Knight_Sabatt", "Husran", "RedPrinceColor")
    AlHadrPlayerID = SetupPlayer(3, "H_NPC_Villager01_NA", "Village1", "VillageColor1")
    AlAssirPlayerID = SetupPlayer(4, "H_NPC_Villager01_NA", "Village2", "VillageColor2")
    CloisterPlayerID = SetupPlayer(5, "H_NPC_Monk_NA", "Cloister", "VillageColor3")
    

    -- set some resources for player 1
    AddResourcesToPlayer(Goods.G_Gold,250)
    AddResourcesToPlayer(Goods.G_Stone,50)
    AddResourcesToPlayer(Goods.G_Wood,50)
    AddResourcesToPlayer(Goods.G_Grain,10)
    AddResourcesToPlayer(Goods.G_Carcass,10)
    AddResourcesToPlayer(Goods.G_RawFish,10)
    AddResourcesToPlayer(Goods.G_Milk,10)
    
    -- set some resources for player 2    
    AddResourcesToPlayer(Goods.G_Gold,310, HusranPlayerID)    
    AddResourcesToPlayer(Goods.G_Iron,30, HusranPlayerID)
    AddResourcesToPlayer(Goods.G_Wood,30, HusranPlayerID)
    AddResourcesToPlayer(Goods.G_Grain,60, HusranPlayerID)
    AddResourcesToPlayer(Goods.G_Carcass,60, HusranPlayerID)
    AddResourcesToPlayer(Goods.G_Herb,60, HusranPlayerID)
    AddResourcesToPlayer(Goods.G_Wool,60, HusranPlayerID)
    AddResourcesToPlayer(Goods.G_Milk,60, HusranPlayerID)
    AddResourcesToPlayer(Goods.G_Honeycomb,60, HusranPlayerID)
    
    
     -- locked technolgies and upgrade levels.
    local TechologiesToLock = { Technologies.R_Medicine,
                                Technologies.R_HerbGatherer,
                                
                                Technologies.R_Wealth,
                                Technologies.R_BannerMaker}

    LockFeaturesForPlayer( 1, TechologiesToLock)
    
    LockTitleForPlayer(1, KnightTitles.Duke)
    
    SetKnightTitle(HusranPlayerID, KnightTitles.Duke)
	
	GameCallback_CreateKnightByTypeOrIndex(Entities.U_KnightSabatta, HusranPlayerID)
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
    AddOffer			(traderId, 5, Goods.G_Sausage)

	local traderId = Logic.GetStoreHouse(4)
	AddOffer			(traderId, 5, Goods.G_Wood)

	DeActivateMerchantForPlayer( traderId, playerId )



end
----------------------------------------------------------------------------------------------------------------------
function Mission_FirstMapAction()
    
    Logic.SetResourceDoodadGoodAmount(Logic.GetEntityIDByName("StoneMine"),3)
    
    ActivateRespawnForCarnivores(Logic.GetEntityIDByName("LionPack"))
    
    for i=1, #wellList do
        local id = Logic.GetEntityIDByName(wellList[i])
        wellList[i] = {}
        wellList[i].ID = id
        wellList[i].NumActivated = 0
        Logic.InteractiveObjectSetAvailability(wellList[i].ID, false)
        Logic.InteractiveObjectSetPlayerState(wellList[i].ID, 1, 2)
    end

    Mission_SetupDiplomacyStates()
    Mission_SetupQuests()

    AIPlayer = AIPlayer:new(HusranPlayerID, AIProfile_Skirmish, Entities.U_KnightSabatta)

end

function Mission_SetupDiplomacyStates()
    SetDiplomacyState(1,HusranPlayerID, DiplomacyStates.Enemy)
    SetDiplomacyState(1,AlHadrPlayerID, DiplomacyStates.Undecided)
    SetDiplomacyState(1,AlAssirPlayerID, DiplomacyStates.Undecided)
    SetDiplomacyState(1,CloisterPlayerID, DiplomacyStates.Undecided)

    SetDiplomacyState(HusranPlayerID,AlHadrPlayerID, DiplomacyStates.Undecided)
    SetDiplomacyState(HusranPlayerID,AlAssirPlayerID, DiplomacyStates.Undecided)
    SetDiplomacyState(HusranPlayerID,CloisterPlayerID, DiplomacyStates.Undecided)

    SetDiplomacyState(AlHadrPlayerID,AlAssirPlayerID, DiplomacyStates.Undecided)
    SetDiplomacyState(AlHadrPlayerID,CloisterPlayerID, DiplomacyStates.Undecided)

    SetDiplomacyState(AlAssirPlayerID,CloisterPlayerID, DiplomacyStates.Undecided)
end

function OnHusranDiscovered()
    SendVoiceMessage(HusranPlayerID, "HiddenQuest_FirstContactWithHusran")
    TriggerHusranAttacks()


    Quests[amountOfHappyID]:Success()
end

function OnLostStoreHouse()
    SendVoiceMessage(HusranPlayerID, "NPCTalk_SabattaWins")
end

function Mission_SetupQuests()

    -- waterquest Special
    WaterDelivered = {
        [AlHadrPlayerID] = 0;
        [AlAssirPlayerID] = 0;
        }
    WaterNotDelivered = {
        [AlHadrPlayerID] = 0;
        [AlAssirPlayerID] = 0;
        }

    QuestTemplate:New("", 1, 1,
        { { Objective.Protect, { Logic.GetStoreHouse(1) } }},
        { { Triggers.Time, 0 }},
        0, nil, nil, OnPlayerStoreHouseDestroyed, nil, false)
        
-- losing 
    QuestTemplate:New("", HusranPlayerID, 1,
        { {Objective.Protect, { Logic.GetStoreHouse(1) } } },
        { { Triggers.Time, 0 } },
        0, nil, nil, OnLostStoreHouse, nil, false)
    
    QuestTemplate:New("", 1, 1,
        { { Objective.Discover, 2, { HusranPlayerID } } },
        { { Triggers.Time, 0 } },
        0, nil, nil, OnHusranDiscovered, nil, false)        

    QuestTemplate:New("Quest_FindCloisterAndVillages", 1, 1,
        { { Objective.Discover, 2, { AlHadrPlayerID, AlAssirPlayerID, CloisterPlayerID  } } },
        { { Triggers.Time, 0 } },
        0, nil, nil, nil, nil, true, false)

    discoverAlHadrID = QuestTemplate:New("HiddenQuest_DiscoverVillageWest", AlHadrPlayerID, 1,
        { { Objective.Dummy } },
        { { Triggers.PlayerDiscovered, AlHadrPlayerID } },
        0, {{Reward.Diplomacy, 0, 1}}, nil, nil, nil, true, false)
        
    discoverCloisterID = QuestTemplate:New("", CloisterPlayerID, 1,
        { { Objective.Dummy } },
        { { Triggers.PlayerDiscovered, CloisterPlayerID } },
        0, {{Reward.Diplomacy, 0, 1}}, nil, nil, nil, false, false)

    discoverAlAssirID = QuestTemplate:New("HiddenQuest_DiscoverVillageEast", AlAssirPlayerID, 1,
        { { Objective.Dummy } },
        { { Triggers.PlayerDiscovered, AlAssirPlayerID } },
        0, {{Reward.Diplomacy, 0, 1}}, nil, nil, nil, true, false)

    amountOfHappyID = QuestTemplate:New("Quest_AmountOfHappySettlersCloister", CloisterPlayerID, 1,
        { { Objective.Custom, Custom_AmountOfHappySettlers } },
        { { Triggers.PlayerDiscovered, CloisterPlayerID } },
        0, 
        { { Reward.PrestigePoints, 1600 } }, 
        nil, 
        OnAmountOfHappySettlersOver, 
        nil, 
        true, 
        true
        )

    --      
    QuestTemplate:New("Quest_RegularWaterWest", AlHadrPlayerID, 1, 
        { { Objective.Dummy } },
        { { Triggers.Quest, amountOfHappyID, QuestResult.Success }, { Triggers.PlayerDiscovered, AlHadrPlayerID, 1 } },
        0, 
        { { Reward.PrestigePoints, 1000 } }, 
        { { Reprisal.Defeat } }, 
        OnRegularWaterQuestOver, 
        nil, 
        false, 
        true)

    QuestTemplate:New("Quest_RegularWaterEast", AlAssirPlayerID, 1, 
        { { Objective.Dummy } },
        { { Triggers.Quest, amountOfHappyID, QuestResult.Success }, { Triggers.PlayerDiscovered, AlAssirPlayerID, 1 } },
        0, 
        { { Reward.PrestigePoints, 1000 } }, 
        { { Reprisal.Defeat } }, 
        OnRegularWaterQuestOver, 
        nil, 
        false, 
        true)
        --  

    QuestTemplate:New("Quest_RegularWaterWest", AlHadrPlayerID, AlHadrPlayerID, 
        { { Objective.Dummy } },
        { { Triggers.Quest, amountOfHappyID, QuestResult.Success }, { Triggers.PlayerDiscovered, AlHadrPlayerID, 1 } },
        0, nil, nil, nil, nil, false)

    QuestTemplate:New("Quest_RegularWaterEast", AlAssirPlayerID, AlAssirPlayerID, 
        { { Objective.Dummy } },
        { { Triggers.Quest, amountOfHappyID, QuestResult.Success }, { Triggers.PlayerDiscovered, AlAssirPlayerID, 1 } },
        0, nil, nil, nil, nil, false)

--- mission lost conditions
    -- those are not exactly the quests. lurk moar.
    QuestTemplate:New("Quest_RegularWaterWest", AlHadrPlayerID, 1,
        { { Objective.Custom, Custom_DiplomacyStateAlHadr } },
        { { Triggers.Time, 0 } },
        0, 
        { { Reward.PrestigePoints, 1000 } }, 
        { { Reprisal.Defeat } }, 
        OnRegularWaterQuestOver, 
        nil, 
        false, 
        true
        )


    QuestTemplate:New("Quest_RegularWaterEast", AlAssirPlayerID, 1,
        { { Objective.Custom, Custom_DiplomacyStateAlAssir } },
        { { Triggers.Time, 0 } },
        0, 
        { { Reward.PrestigePoints, 1000 } },
        { { Reprisal.Defeat } }, 
        OnRegularWaterQuestOver, 
        nil, 
        false, 
        true
        )

---

    QuestTemplate:New("", AlHadrPlayerID, 1,
        { { Objective.Dummy } },
        { { Triggers.Custom, Trigger_RegularWaterWest3 } },
        0, nil, nil, OnStartLionKillQuest, nil, false)

    --Quests[amountOfHappyID]:Success()
end


function Custom_DiplomacyStateAlHadr()
    if GetDiplomacyState(1, AlHadrPlayerID) <= DiplomacyStates.Enemy then
        return false
    end
    return nil
end

function Custom_DiplomacyStateAlAssir()
    if GetDiplomacyState(1, AlAssirPlayerID) <= DiplomacyStates.Enemy then
        return false
    end
    return nil
end

function OnPlayerStoreHouseDestroyed()
    SendVoiceMessage(HusranPlayerID, "NPCTalk_SabattasWins")
end

function OnRegularWaterQuestOver(quest)
    if quest.Result == QuestResult.Failure then
        SendVoiceMessage(HusranPlayerID, "Defeat_SabattaTriumph")
    end
end

function OnStartLionKillQuest()
    --Getting wolves like this, because GetEntitiesInTerritory does not work for PlayerID 0
    
    local LionsTerritoryID = 10
    
    local AllLions = { Logic.GetEntities(Entities.A_NA_Lion_Male,29) }
    local lionList = {}
    
    for i=2, AllLions[1] do
        local lion = AllLions[i]
        local x, y = Logic.GetEntityPosition(lion)
        if Logic.GetTerritoryAtPosition(x, y) == LionsTerritoryID then
            lionList[#lionList+1] = lion
        end
    end

    AllLions = { Logic.GetEntities(Entities.A_NA_Lion_Female,29) }
    for i=2, AllLions[1] do
        local lion = AllLions[i]
        local x, y = Logic.GetEntityPosition(lion)
        if Logic.GetTerritoryAtPosition(x, y) == LionsTerritoryID then
            lionList[#lionList+1] = lion
        end 
    end

    QuestTemplate:New("Quest_KillTheLionsWest", AlHadrPlayerID, 1,
        { { Objective.DestroyEntities, 1, lionList } },
        { { Triggers.Time, 0 } },
        0, 
        { { Reward.PrestigePoints, 1200 },  { Reward.Diplomacy, 0, DiplomacyStates.Allied, 1 } }, 
        nil, 
        OnLionsKilled, 
        nil
        )
end

function OnLionsKilled()
    -- well well well...
    for i=1, Quests[0] do
        if Quests[i].Identifier == "Quest_RegularWaterWest" then
            Quests[i]:Interrupt()
        end
    end
    
    InitializeWells()
    -- quests for finding the first well
    firstWellQuests = {}
    for i=1, #wellList do
        firstWellQuests[i] = QuestTemplate:New("", 1, 1,
            { { Objective.Distance, Logic.GetKnightID(1), wellList[i].ID }},
            { { Triggers.Time, 0 }}, 0, nil, nil, OnFirstWellFound, nil, false)
    end
    
    -- max 3 DIGS per well / STOP AT 8
    QuestTemplate:New("Quest_RebuiltFountainEast", AlAssirPlayerID, 1,
        { { Objective.Custom, Objective_RebuildFountain } },
        { { Triggers.Time, Logic.GetTime() + 30 } },
        0, 
        { { Reward.PrestigePoints, 1800 }, { Reward.Diplomacy, 0, DiplomacyStates.Allied, 1 } }, 
        nil, 
        OnWellRebuilt)
        
    for i=1, #wellList do
        local mahboi = wellList[i].ID
        QuestTemplate:New("wellQuest", 1, 1,
            { { Objective.Object, { wellList[i].ID } } },
            { { Triggers.Time, 0 } },
            0, nil, nil, OnWellActivated, nil, false)
    end
end

function OnFirstWellFound(quest)
    if quest.Result == QuestResult.Success then
        for i=1, #firstWellQuests do
            Quests[firstWellQuests[i]]:Interrupt()
        end
        SendVoiceMessage(1, "HiddenQuest_FirstFountainInSight")
    end
end

function OnWellRebuilt()
    for i=1, Quests[0] do
        if Quests[i].Identifier == "Quest_RegularWaterEast" then
            Quests[i]:Interrupt()
        end
    end
    
    HusranVictoryQuest = QuestTemplate:New("Quest_WaterPumpCloister", CloisterPlayerID, 1,
                        { { Objective.Deliver, Goods.G_SiegeEnginePart, 5 } },
                        { { Triggers.Time, 0 } },
                        0, 
                        { { Reward.PrestigePoints, 5000 } , { Reward.CampaignMapFinished } }, 
                        nil, 
                        nil, 
                        nil, 
                        true, 
                        false
                        )

    GenerateVictoryDialog({{HusranPlayerID,"Victory_SabattaWarns" },
                            {CloisterPlayerID,"Victory_CloisterWaterForAllPartTwo" }}, HusranVictoryQuest)
        
end


function OnWellActivated(quest)
    if quest.Result == QuestResult.Success then
        local object = quest.Objectives[1].Data[1]
        
        TotalWellActivations = TotalWellActivations + 1
        if TotalWellActivations == 5 then
            -- interrupts all other well quests
            for i=1, #wellList do
                Logic.InteractiveObjectSetAvailability(wellList[i].ID, false)
                Logic.InteractiveObjectSetPlayerState(wellList[i].ID, 1, 2)
            end
    
            for i=1, Quests[0] do
                if Quests[i].Identifier == "wellQuest" then
                    Quests[i]:Interrupt()
                end
            end
    
            local x, y = Logic.GetEntityPosition(object)
            local ang = Logic.GetEntityOrientation(object)
            Logic.DestroyEntity(object)
            Logic.CreateEntity(Entities.D_NA_Well_Repaired, x, y, ang, 0)
            return
        elseif TotalWellActivations > 5 then
            return
        end
    
        for i=1, #wellList do
            if wellList[i].ID == object then
                wellList[i].NumActivated = wellList[i].NumActivated + 1
                if wellList[i].NumActivated == 3 then
                    SendVoiceMessage(1, "NPCTalk_FountainHasNoWater")
                    Logic.InteractiveObjectSetAvailability(wellList[i].ID, false)
                    Logic.InteractiveObjectSetPlayerState(wellList[i].ID, 1, 2)
                else
                    SendVoiceMessage(1, "NPCTalk_DigDeeper")
                    -- increase costs
                    Logic.InteractiveObjectClearCosts(wellList[i].ID)
                    Logic.InteractiveObjectAddCosts(wellList[i].ID, Goods.G_Stone, (wellList[i].NumActivated + 1) * 10)
                    RemoveInteractiveObjectFromOpenedList(wellList[i].ID)
    
                    QuestTemplate:New(quest.Identifier, 1, 1,
                        { { Objective.Object, { wellList[i].ID } } },
                        { { Triggers.Time, 0 } },
                        0, nil, nil, OnWellActivated, nil, false)
    
                end
            end
        end
    end
end

function InitializeWells()

    for i=1, #wellList do
        Logic.InteractiveObjectClearCosts(wellList[i].ID)
        Logic.InteractiveObjectAddCosts(wellList[i].ID, Goods.G_Stone, 10)
        Logic.InteractiveObjectSetInteractionDistance(wellList[i].ID, 1000)
        Logic.InteractiveObjectSetTimeToOpen(wellList[i].ID, 10)
        Logic.InteractiveObjectSetAvailability(wellList[i].ID, true)
        Logic.InteractiveObjectSetPlayerState(wellList[i].ID, 1, 0)
    end
end

function Objective_RebuildFountain()
    if TotalWellActivations >= 5 then
        return true
    end

    return nil
end

function Trigger_RegularWaterWest3()
    return WaterDelivered[AlHadrPlayerID] >= 3
end

function TriggerHusranAttacks()
    if not HusranAttacksTriggered then
        HusranAttacksTriggered = true
    end
end

function OnLaunchWaterQuest(quest)

    if quest.Result == QuestResult.Success then
        if quest.ReceivingPlayer ~= 1 then
            QuestTemplate:New(quest.Identifier, quest.ReceivingPlayer, quest.ReceivingPlayer,
                { { Objective.Protect, { Logic.GetStoreHouse(1) } } },
                { { Triggers.Time, Logic.GetTime() } }, 5 * 60, nil, nil, OnLaunchWaterQuest, nil, false)

            QuestTemplate:New(quest.Identifier, quest.SendingPlayer, 1,
                { { Objective.Deliver, Goods.G_Water, 10 } },
                { { Triggers.Time, Logic.GetTime() } }, 3 * 60,
                { { Reward.Diplomacy, 0, DiplomacyStates.EstablishedContact, 1 } }, { {Reprisal.Diplomacy, 0, -1 } },
                OnLaunchWaterQuest, nil, true, false)

        else
            SendVoiceMessage(quest.SendingPlayer, "NPCTalk_VillageWestGotWater")
            WaterDelivered[quest.SendingPlayer] = WaterDelivered[quest.SendingPlayer] + 1

        end
        TriggerHusranAttacks()

    elseif quest.Result == QuestResult.Failure then

        for i=1, Quests[0] do
            if Quests[i].Identifier == quest.Identifier and Quests[i].ReceivingPlayer ~= 1 and Quests[i].State ~= QuestState.Over then
                Quests[i].Duration = 1
            end
        end

        WaterNotDelivered[quest.SendingPlayer] = WaterNotDelivered[quest.SendingPlayer] + 1
        if WaterNotDelivered[quest.SendingPlayer] == 1 then
            SendVoiceMessage(quest.SendingPlayer, "NPCTalk_VillageWestSuffers")

        else --if WaterNotDelivered[quest.SendingPlayer] == 2 then
            SendVoiceMessage(quest.SendingPlayer, "NPCTalk_VillageWestDieOfThirst")

        end
    end
end


function Custom_AmountOfHappySettlers()
    if Logic.GetNumberOfPlayerEntitiesInCategory(1, EntityCategories.Worker) >= 30
        and GetNumberOfStrikersOfPlayer(1) == 0 then
        return true
    end
    return nil
end

function OnAmountOfHappySettlersOver()
    Quests[discoverAlHadrID]:Interrupt()
    Quests[discoverAlAssirID]:Interrupt()
end

HusranSwordmen = 2
HusranBowmen = 2
HusranAttackCount = 0
function AIProfile_Sabbatha(self)
    
    if HusranAttacksTriggered then
        HusranAttackCounter = HusranAttackCounter - 1
    end

    --
    -- check if we have to attack something 
    --
    if HusranAttacksTriggered and HusranAttackCounter == 0 then
        HusranAttackCounter = 5 * 60
    
        if (self.m_Behavior["AttackCity"] == nil) then

            local rams = 0
            local x, y = Logic.GetEntityPosition(Logic.GetStoreHouse(1))
            local p1Sector = Logic.DEBUG_GetSectorAtPosition(x, y)
            if p1Sector ~= 0 then
                rams = 1
            end

            self.m_Behavior["AttackCity"] = self:GenerateBehaviour(AIBehavior_AttackCity);

            self.m_Behavior["AttackCity"].m_TargetID = Logic.GetStoreHouse(1)
            self.m_Behavior["AttackCity"].CB_AttackFinished = OnHusranAttackFinished
            self.m_Behavior["AttackCity"].m_MinNumberOfSwordsmen = 0
            self.m_Behavior["AttackCity"].m_MaxNumberOfSwordsmen = HusranSwordmen
            self.m_Behavior["AttackCity"].m_FleeNumberOfSwordsmen = 0
            
            self.m_Behavior["AttackCity"].m_MinNumberOfBowmen = 0
            self.m_Behavior["AttackCity"].m_MaxNumberOfBowmen = HusranBowmen
            self.m_Behavior["AttackCity"].m_FleeNumberOfBowmen = 0
            
            self.m_Behavior["AttackCity"].m_MinNumberOfCatapults = 0
            self.m_Behavior["AttackCity"].m_MaxNumberOfCatapults = 0
            self.m_Behavior["AttackCity"].m_FleeNumberOfCatapults = 0    

            self.m_Behavior["AttackCity"].m_MinNumberOfRams= rams
            self.m_Behavior["AttackCity"].m_MaxNumberOfRams = rams
            self.m_Behavior["AttackCity"].m_FleeNumberOfRams = 0  

            self.m_Behavior["AttackCity"].m_MinNumberOfTowers= 0
            self.m_Behavior["AttackCity"].m_MaxNumberOfTowers = 0
            self.m_Behavior["AttackCity"].m_FleeNumberOfTowers = 0  

            if (self.m_Behavior["AttackCity"]:Start() == false) then
                self.m_Behavior["AttackCity"] = nil;
            else
                HusranAttackCount = HusranAttackCount + 1
            end
            
            if HusranAttackCount == 1 then
                --AnSu:This message has the wrong voice... Can we find a generic one for sabatt????
                SendVoiceMessage(HusranPlayerID, "NPCTalk_SabattasFirstAttack")
            end

            if HusranBowmen < 5 then
                HusranBowmen = HusranBowmen + 1
                HusranSwordmen = HusranSwordmen + 1
            end
        end
    
    end
    
end

function OnHusranAttackFinished()
    if HusranAttackCount == 1 then
        SendVoiceMessage(HusranPlayerID, "NPCTalk_SabattasFirstAttackFailures")
    end
end


function Mission_Victory()

    local VictoryMonkPos = Logic.GetEntityIDByName("VictoryMonkPos")
    local x,y = Logic.GetEntityPosition(VictoryMonkPos)
    local Orientation = Logic.GetEntityOrientation(VictoryMonkPos)    
    Logic.CreateEntityOnUnblockedLand(Entities.U_NPC_Monk_NA, x, y, Orientation-90, CloisterPlayerID)
    
    
    local VictoryKnightPos = Logic.GetEntityIDByName("VictoryKnightPos")
    local x,y = Logic.GetEntityPosition(VictoryKnightPos)
    local Orientation = Logic.GetEntityOrientation(VictoryKnightPos)    
    VictorySetEntityToPosition( Logic.GetKnightID(1), x, y, Orientation )
    
end