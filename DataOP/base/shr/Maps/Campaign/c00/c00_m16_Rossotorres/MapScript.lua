-- TODO
-- The Red Prince doesn't do anything right now ... just waits that you do something
--  


CurrentMapIsCampaignMap = true

MissionState = {}
MissionState.TrebuchetsTimer           = -1
MissionState.TrebuchetsWaitTime        = 60 * 10
MissionState.TrebuchetsFirstWaitTime   = 0
MissionState.TrebuchetsAttackTime      = 60
MissionState.TrebuchetsAttackTimer     = -1
MissionState.TrebuchetLastFired        = 0

MissionState.BlessingTimer             = -1
MissionState.BlessingWaitTime          = 60 * 10
MissionState.BlessingFirstWaitTime     = 0

MissionState.AttackTimer               = -1
MissionState.AttackWaitTime            = 60 * 10
MissionState.AttackFirstWaitTime       = 60 * 2.5   --- be careful! this timer must be larger than MissionState.AttackShipArrivingTime
MissionState.AttackShipArrivingTime    = 60 * 2
MissionState.AttackShipReturnTime      = 60 * 1
MissionState.AttackNumberOfMelee       = 3
MissionState.AttackNumberOfRanged      = 2
MissionState.AttackNumberOfSieges      = 1

MissionState.AIAttacksHumanCity        = false
MissionState.AITimeBetweenMainAttacks  = 60 * 10
MissionState.AIMainAttackTimer         = 60 * 10

MissionState.FortifyCityTimer          = 60 * 30


----------------------------------------------------------------------------------------------------------------------
function Mission_InitPlayers()

    local RossotorresKnightHeads = {
        [1] = { Type = Entities.U_KnightTrading; Face ="H_Knight_Trading" };
        [2] = { Type = Entities.U_KnightPlunder; Face ="H_Knight_Plunder" };
        [3] = { Type = Entities.U_KnightHealing; Face ="H_Knight_Healing" };        
        [4] = { Type = Entities.U_KnightWisdom; Face ="H_Knight_Wisdom" };
        [5] = { Type = Entities.U_KnightSong; Face ="H_Knight_Song" };
        [6] = { Type = Entities.U_KnightChivalry; Face ="H_Knight_Chivalry" };
    }

    local TraitorEntityType = GlobalGetTraitor()
    local OwnKnightType = Logic.GetEntityType(Logic.GetKnightID(1))
    
    HarbourPlayerKnight = nil 
    GranCastillaPlayerKnight = nil 
    MonasterioPlayerKnight = nil 
    
    for PlayerID = 3, 5 do
        for i=1, #RossotorresKnightHeads do
            if TraitorEntityType ~= RossotorresKnightHeads[i].Type and OwnKnightType ~= RossotorresKnightHeads[i].Type then
                
                if HarbourPlayerKnight == nil and RossotorresKnightHeads[i].Used ~= true then
                    HarbourPlayerKnight = RossotorresKnightHeads[i]
                    RossotorresKnightHeads[i].Used = true
                    
                elseif GranCastillaPlayerKnight == nil and RossotorresKnightHeads[i].Used ~= true then
                    GranCastillaPlayerKnight = RossotorresKnightHeads[i]
                    RossotorresKnightHeads[i].Used = true
                    
                elseif MonasterioPlayerKnight == nil and RossotorresKnightHeads[i].Used ~= true then
                    MonasterioPlayerKnight = RossotorresKnightHeads[i]
                    RossotorresKnightHeads[i].Used = true
                    
                end
                
            end
        end
    end
    
    
    RossotorresPlayerID     = SetupPlayer(2, "H_Knight_RedPrince", "Rossotorres", "RedPrinceColor")                
    HarborPlayerID          = SetupPlayer(3, HarbourPlayerKnight.Face, "", "VillageColor1")
    GranCastillaPlayerID    = SetupPlayer(4, GranCastillaPlayerKnight.Face, "", "CP_OrangeColor")    
    MonasterioPlayerID      = SetupPlayer(5, MonasterioPlayerKnight.Face, "", "CloisterColor1")        
    Bandits1PlayerID        = SetupPlayer(6, "H_NPC_Mercenary_ME", "Bandits1", "BanditsColor1")
    Bandits2PlayerID        = SetupPlayer(7, "H_NPC_Mercenary_ME", "Bandits1", "CP_BlackColor")    
    Bandits3PlayerID        = SetupPlayer(8, "H_NPC_Mercenary_ME", "Bandits1", "BanditsColor3")
       
    TerritoryID_WesternGarrison = 13
    TerritoryID_EasternGarrison = 10
    TerritoryID_SouthGarrison   = 4    
       
    -- set some resources for player 1
    AddResourcesToPlayer(Goods.G_Gold,310)
    AddResourcesToPlayer(Goods.G_Stone,75)
    AddResourcesToPlayer(Goods.G_Wood,75)
    AddResourcesToPlayer(Goods.G_Grain,20)
    AddResourcesToPlayer(Goods.G_Carcass,20)
    
    
    SetKnightTitle(RossotorresPlayerID, KnightTitles.Duke)
    
    AddResourcesToPlayer(Goods.G_Gold,3000, RossotorresPlayerID)    
    AddResourcesToPlayer(Goods.G_Iron,80, RossotorresPlayerID)
    AddResourcesToPlayer(Goods.G_Wood,80, RossotorresPlayerID)
    AddResourcesToPlayer(Goods.G_Grain,80, RossotorresPlayerID)
    AddResourcesToPlayer(Goods.G_Carcass,80, RossotorresPlayerID)
    AddResourcesToPlayer(Goods.G_Herb,80, RossotorresPlayerID)
    AddResourcesToPlayer(Goods.G_Wool,80, RossotorresPlayerID)
    AddResourcesToPlayer(Goods.G_Milk,80, RossotorresPlayerID)
    AddResourcesToPlayer(Goods.G_Honeycomb,80, RossotorresPlayerID)

    SetKnightTitle(GranCastillaPlayerID, KnightTitles.Marquees)
    
    AddResourcesToPlayer(Goods.G_Gold,1000, GranCastillaPlayerID)    
    AddResourcesToPlayer(Goods.G_Iron,30, GranCastillaPlayerID)
    AddResourcesToPlayer(Goods.G_Wood,30, GranCastillaPlayerID)
    AddResourcesToPlayer(Goods.G_Grain,30, GranCastillaPlayerID)
    AddResourcesToPlayer(Goods.G_Carcass,30, GranCastillaPlayerID)
    AddResourcesToPlayer(Goods.G_Herb,30, GranCastillaPlayerID)
    AddResourcesToPlayer(Goods.G_Wool,30, GranCastillaPlayerID)
    AddResourcesToPlayer(Goods.G_Milk,30, GranCastillaPlayerID)
    AddResourcesToPlayer(Goods.G_RawFish,30, GranCastillaPlayerID)
    AddResourcesToPlayer(Goods.G_Honeycomb,30, GranCastillaPlayerID)
    
    VictoryApprouchPosInRossotorres ={}
    
    --flag all buildings 
    local CityBuildings = {Logic.GetPlayerEntitiesInCategory(RossotorresPlayerID, EntityCategories.CityBuilding)}
        
    for i=1, #CityBuildings do
        
        local BuildingID = CityBuildings[i]
        local x,y  = Logic.GetBuildingApproachPosition(BuildingID)
        VictoryApprouchPosInRossotorres[i] = {x,y}
    end
    
    local Marketplace = Logic.GetMarketplace(RossotorresPlayerID)
    local x,y = Logic.GetEntityPosition(Marketplace)
    VictoryMarketPosInRossotorres = {x,y}
    
end

----------------------------------------------------------------------------------------------------------------------
function Mission_SetStartingMonth()

    Logic.SetMonthOffset(3)

end

----------------------------------------------------------------------------------------------------------------------
function Mission_InitMerchants()

    local TraderID = Logic.GetStoreHouse(HarborPlayerID)    
    AddOffer			(TraderID,	5, Goods.G_Sheep)
    AddOffer			(TraderID,	5, Goods.G_Cow)
    AddOffer			(TraderID, 10, Goods.G_Stone)
    AddOffer			(TraderID, 10, Goods.G_SmokedFish)

	local TraderID = Logic.GetStoreHouse(GranCastillaPlayerID)
	AddOffer			(TraderID,	 5, Goods.G_Sheep)
	AddOffer			(TraderID,	 5, Goods.G_Cow)
	AddOffer			(TraderID,	10, Goods.G_Clothes)
	AddOffer			(TraderID,	10, Goods.G_Iron)

	local TraderID = Logic.GetStoreHouse(MonasterioPlayerID)
	AddOffer			(TraderID,	 5, Goods.G_Clothes)
	AddOffer			(TraderID,	 5, Goods.G_Medicine)
	AddOffer			(TraderID,	10, Goods.G_Herb)
	AddOffer			(TraderID,	10, Goods.G_Cheese)

end

----------------------------------------------------------------------------------------------------------------------
function Mission_FirstMapAction()

    --DisableFoW()                      
    SetPlayerMoral(RossotorresPlayerID, 1.2)

    local HarborID = Logic.GetEntityIDByName("Harbor")
    Logic.InteractiveObjectSetPlayerState(HarborID, 1, 2)

    local PrisonID = Logic.GetEntityIDByName("Prison")    
    Logic.InteractiveObjectSetPlayerState(PrisonID, 1, 2)
          
    -- init ai players
    do
    
        AIPlayer:new(HarborPlayerID,        nil, HarbourPlayerKnight.Type)
        AIPlayer:new(MonasterioPlayerID,    nil, MonasterioPlayerKnight.Type)
        AIPlayer:new(GranCastillaPlayerID,  nil, GranCastillaPlayerKnight.Type)
        AIPlayer:new(RossotorresPlayerID,   AIProfile_Rossotorres)
        
    end
    
    -- do this after the AI has been initialized, because "AIPlayer:new" spawns knights
    Mission_SetDiplomacy()
    Mission_SetupQuests()       

    -- setup AI
    do
        RedPrinceAI = AIPlayer:new(RossotorresPlayerID, AIProfile_Skirmish, Entities.U_KnightSabatta)
        AICore.SetNumericalFact(RossotorresPlayerID, "PRPT", 1 )
        
    end

    StartSimpleJob("SimpleJob_UpdateTimer")
	
	-- benchmarking
	if RossoTorres_Benchmark == 1 then
        RossoTorres_Benchmark01()
    elseif RossoTorres_Benchmark == 2 then
        RossoTorres_Benchmark02()	
    end
    
    -- ChSc hack
    --OnQuestDone_DeliveryToGranCastilla()
end

----------------------------------------------------------------------------------------------------------------------
function Mission_SetDiplomacy()

    --first make bandits enemy with everybody except rossotorres and rossotorres enemy with everybody else
    for i=1, 8 do

        if (i == RossotorresPlayerID) or (i == Bandits1PlayerID) or (i == Bandits2PlayerID) or (i == Bandits3PlayerID) then

            SetDiplomacyState(i, RossotorresPlayerID,   DiplomacyStates.EstablishedContact)
            SetDiplomacyState(i, Bandits1PlayerID,      DiplomacyStates.EstablishedContact)
            SetDiplomacyState(i, Bandits2PlayerID,      DiplomacyStates.EstablishedContact)
            SetDiplomacyState(i, Bandits3PlayerID,      DiplomacyStates.EstablishedContact)
            
            SetDiplomacyState(i, 1,                     DiplomacyStates.Enemy)    
            SetDiplomacyState(i, HarborPlayerID,        DiplomacyStates.Enemy)
            SetDiplomacyState(i, MonasterioPlayerID,    DiplomacyStates.Enemy)
            SetDiplomacyState(i, GranCastillaPlayerID,  DiplomacyStates.Enemy)            
                        
        end
    end
        
    --Make player enemy with rossotorrs and bandits (just to be sure)
    SetDiplomacyState(1, RossotorresPlayerID,   DiplomacyStates.Enemy)
    SetDiplomacyState(1, Bandits1PlayerID,      DiplomacyStates.Enemy)
    SetDiplomacyState(1, Bandits2PlayerID,      DiplomacyStates.Enemy)
    SetDiplomacyState(1, Bandits3PlayerID,      DiplomacyStates.Enemy)
    
    --Make Knights allied
    SetDiplomacyState(1, HarborPlayerID,        DiplomacyStates.Allied)
    SetDiplomacyState(1, MonasterioPlayerID,    DiplomacyStates.Allied)
    SetDiplomacyState(1, GranCastillaPlayerID,  DiplomacyStates.Allied)
    
    
    --Make knights Trade contact to each other
    SetDiplomacyState(HarborPlayerID, MonasterioPlayerID,    DiplomacyStates.TradeContact)
    SetDiplomacyState(HarborPlayerID, GranCastillaPlayerID,  DiplomacyStates.TradeContact)    
    SetDiplomacyState(MonasterioPlayerID, GranCastillaPlayerID,    DiplomacyStates.TradeContact)
    
    
    -- share fog of war so the trebuchets can fire in the fow
    Logic.SetShareExplorationWithPlayerFlag(GranCastillaPlayerID, RossotorresPlayerID, 1)
    
end

----------------------------------------------------------------------------------------------------------------------
--
--
--
-- Quest handling
--
--
--
----------------------------------------------------------------------------------------------------------------------

----------------------------------------------------------------------------------------------------------------------
function CreateQuestToProtectKnight(_PlayerID)

    local KnightID = Logic.GetKnightID(_PlayerID);
    local KnightType = Logic.GetEntityType(KnightID)

    if (KnightType == Entities.U_KnightChivalry) then

        -- "HiddenQuest_NPCMarcusMustSurvive"
        QuestTemplate:New("HiddenQuest_NPCMarcusMustSurvive", 1, 1, 
                        {{Objective.Protect, {KnightID}}},
                        {{Triggers.Time, 0}}, 
                        0, 
                        nil, 
                        {{Reprisal.Defeat}},
                        nil, nil, false, true)
    
    elseif (KnightType == Entities.U_KnightHealing) then
        
        -- "HiddenQuest_NPCAlandraMustSurvive"
        QuestTemplate:New("HiddenQuest_NPCAlandraMustSurvive", 1, 1, 
                        {{Objective.Protect, {KnightID}}},
                        {{Triggers.Time, 0}}, 
                        0, 
                        nil, 
                        {{Reprisal.Defeat}},
                        nil, nil, false, true)
    
    elseif (KnightType == Entities.U_KnightTrading) then
        
        -- "HiddenQuest_NPCEliasMustSurvive"
        QuestTemplate:New("HiddenQuest_NPCEliasMustSurvive", 1, 1, 
                        {{Objective.Protect, {KnightID}}},
                        {{Triggers.Time, 0}}, 
                        0, 
                        nil, 
                        {{Reprisal.Defeat}},
                        nil, nil, false, true)
    
    elseif (KnightType == Entities.U_KnightPlunder) then
        
        -- "HiddenQuest_NPCKestralMustSurvive"
        QuestTemplate:New("HiddenQuest_NPCKestralMustSurvive", 1, 1, 
                        {{Objective.Protect, {KnightID}}},
                        {{Triggers.Time, 0}}, 
                        0, 
                        nil, 
                        {{Reprisal.Defeat}},
                        nil, nil, false, true)
    
    elseif (KnightType == Entities.U_KnightSong) then
                        
        -- "HiddenQuest_NPCThordalMustSurvive"
        QuestTemplate:New("HiddenQuest_NPCThordalMustSurvive", 1, 1, 
                        {{Objective.Protect, {KnightID}}},
                        {{Triggers.Time, 0}}, 
                        0, 
                        nil, 
                        {{Reprisal.Defeat}},
                        nil, nil, false, true)
    
    elseif (KnightType == Entities.U_KnightWisdom) then
                        
        -- "HiddenQuest_NPCHakimMustSurvive"
        QuestTemplate:New("HiddenQuest_NPCHakimMustSurvive", 1, 1, 
                        {{Objective.Protect, {KnightID}}},
                        {{Triggers.Time, 0}}, 
                        0, 
                        nil, 
                        {{Reprisal.Defeat}},
                        nil, nil, false, true)    

    end

end

----------------------------------------------------------------------------------------------------------------------
function Mission_SetupQuests()

    --------------------------------------------------------------------------------------------------------------------------------------------
    ------- HIDDEN QUESTS ----------------------------------------------------------------------------------------------------------------------
    --------------------------------------------------------------------------------------------------------------------------------------------

    CreateQuestToProtectKnight(MonasterioPlayerID)
    CreateQuestToProtectKnight(HarborPlayerID)
    CreateQuestToProtectKnight(GranCastillaPlayerID)
    
    -- "HiddenQuest_RossotorresDestroyed
    local Quest_Victory = QuestTemplate:New("HiddenQuest_RossotorresDestroyed", 1, 1, 
                    {{Objective.DestroyEntities, 1, {Logic.GetStoreHouse(RossotorresPlayerID)}}}, 
                    {{Triggers.Time, 0}},
                    0,
                    {{Reward.CampaignMapFinished}},  
                    nil,
                    nil, nil, false)    -- dont show this quest

    --------------------------------------------------------------------------------------------------------------------------------------------
    ------- HUMANPLAYER BASE QUESTS STRAND -----------------------------------------------------------------------------------------------------
    --------------------------------------------------------------------------------------------------------------------------------------------

    -- "Quest_BecomeBaron"
    Quest_BecomeBaronID = QuestTemplate:New("Quest_BecomeBaron", 1, 1, 
                    {{Objective.KnightTitle, KnightTitles.Baron  }}, 
                    {{Triggers.Time, 0}},
                    0, 
                    { { Reward.PrestigePoints, 500 } }, 
                    nil,
                    OnQuestDone_BecomeBaron)    

    -- "Quest_FortifyCity"
    Quest_FortifyCityID = QuestTemplate:New("Quest_FortifyCity", 1, 1, 
                    {{Objective.Custom, ObjectiveCustom_FortifyCity  }}, 
                    {{Triggers.Time, 0}},
                    0, 
                    { { Reward.PrestigePoints, 2400 } }, 
                    nil,
                    OnQuestDone_FortifyCity)

    --------------------------------------------------------------------------------------------------------------------------------------------
    ------- SUPPORT & PREPERATION QUESTS STRAND ------------------------------------------------------------------------------------------------
    --------------------------------------------------------------------------------------------------------------------------------------------
    
    local GarrisonsAcquiringBuildings =
                    {
                        Logic.GetTerritoryAcquiringBuildingID(TerritoryID_SouthGarrison),
                        Logic.GetTerritoryAcquiringBuildingID(TerritoryID_WesternGarrison),
                        Logic.GetTerritoryAcquiringBuildingID(TerritoryID_EasternGarrison)
                    }

    -- "Quest_ThreeGarrisons"
    local Quest_ThreeGarrisonsID = QuestTemplate:New("Quest_ThreeGarrisons", 1, 1, 
                    {{Objective.DestroyEntities, 1, GarrisonsAcquiringBuildings}},  
                    {{Triggers.Custom, TriggerCustom_StartupQuestsDone}},   
                    0,
                    { { Reward.PrestigePoints, 6000 } },
                    nil,
                    OnQuestDone_ThreeGarrisons)

    -- "Quest_DeliveryToGranCastilla"
    Quest_DeliveryToGranCastillaID = QuestTemplate:New("Quest_DeliveryToGranCastilla", GranCastillaPlayerID, 1, 
                    {{Objective.Deliver, Goods.G_Stone, 50}}, 
                    {{Triggers.Custom, TriggerCustom_StartupQuestsDone}},   
                    0,
                    { { Reward.PrestigePoints, 800 } },
                    nil,
                    OnQuestDone_DeliveryToGranCastilla)

    -- "Quest_RebuildHarbor"
    Quest_RebuildHarborID = QuestTemplate:New("Quest_RebuildHarbor", HarborPlayerID, 1, 
                    {{Objective.Object, { Logic.GetEntityIDByName("Harbor") } }}, 
                    {{Triggers.Custom, TriggerCustom_StartupQuestsDone}},   
                    0,
                    { { Reward.PrestigePoints, 1200 } },
                    nil,
                    OnQuestDone_RebuildHarbor)
                    
    -- "Quest_RescueTheBishop"
    local Quest_RescueTheBishopID = QuestTemplate:New("Quest_RescueTheBishop", MonasterioPlayerID, 1, 
                    {{Objective.Object, { Logic.GetEntityIDByName("Prison") } }}, 
                    {{Triggers.Custom, TriggerCustom_StartupQuestsDone}},                       
                    0,
                    { { Reward.PrestigePoints, 1800 } },
                    nil,
                    OnQuestDone_RescueTheBishop)                    


    --------------------------------------------------------------------------------------------------------------------------------------------
    ------- ASSAULT ON ROSSOTORRES QUESTS STRAND -----------------------------------------------------------------------------------------------------
    --------------------------------------------------------------------------------------------------------------------------------------------

    -- "Quest_DefeatRossotorres"
    local Quest_DefeatRossotorresID = QuestTemplate:New("Quest_DefeatRossotorres", 1, 1, 
                    { { Objective.Custom, ObjectiveCustom_DestroyRossotorres} },
                    {
                        {Triggers.Quest, Quest_ThreeGarrisonsID, QuestResult.Success}
                    },
                    0,
                    { { Reward.PrestigePoints, 8000 } ,{Reward.CampaignMapFinished}},  
                    nil, nil, nil, true, false)   


    -- end dialog
    GenerateVictoryDialog(
                        {
                            {1,   "Quest_DefeatRossotorres_Success" },
                        }, 
                        Quest_Victory)
                        
                        
    -- interactive objects                        
    do
    
        local HarborID = Logic.GetEntityIDByName("Harbor")    
        
        Logic.InteractiveObjectClearCosts(HarborID)
        Logic.InteractiveObjectAddCosts(HarborID, Goods.G_Wood, 20)
        Logic.InteractiveObjectSetInteractionDistance(HarborID, 2000)
        Logic.InteractiveObjectSetTimeToOpen(HarborID, 0)
        Logic.InteractiveObjectSetPlayerState(HarborID, 1, 0)
        Logic.InteractiveObjectSetReplacingEntityType(HarborID, Entities.B_NPC_ShipsStorehouse)                        


        local PrisonID = Logic.GetEntityIDByName("Prison")    
        
        Logic.InteractiveObjectClearCosts(PrisonID)
        Logic.InteractiveObjectSetInteractionDistance(PrisonID, 1000)
        Logic.InteractiveObjectSetPlayerState(PrisonID, 1, 0)
        Logic.InteractiveObjectSetTimeToOpen(PrisonID, 30)

    end

end

----------------------------------------------------------------------------------------------------------------------
function OnQuestDone_BecomeBaron()

    local EntityID = AIScript_FindOuterrimInSamePlayerSector(RossotorresPlayerID, 1)    
    if (EntityID ~= 0) then

        SendVoiceMessage(RossotorresPlayerID, "NPCTalk_FirstAttackWave")
        AIScript_SpawnAndRaidSettlement(RossotorresPlayerID, EntityID, "AI_Spawn", 3000, 3, 2, true)
        
    end

end

----------------------------------------------------------------------------------------------------------------------
function ObjectiveCustom_FortifyCity()

    local x,y = Logic.GetBuildingApproachPosition(Logic.GetStoreHouse(1))
    local Sector1 = Logic.GetPlayerSectorAtPosition(RossotorresPlayerID, x, y)
    
    x, y = Logic.GetBuildingApproachPosition(Logic.GetStoreHouse(RossotorresPlayerID))        
    local Sector2 = Logic.GetPlayerSectorAtPosition(RossotorresPlayerID, x, y)
  
    if Sector1 ~= Sector2 then
        return true
    end
    
    if Logic.GetTime() >= MissionState.FortifyCityTimer then
        Quests[Quest_FortifyCityID]:Interrupt()
    end
    
    return nil

end

----------------------------------------------------------------------------------------------------------------------
function OnQuestDone_FortifyCity(_Quest)

    if (_Quest.Result == QuestResult.Success) then
        SendVoiceMessage(RossotorresPlayerID, "NPCTalk_SecondAttackWave")    
    end
    
    AIScript_SpawnAndAttackCity(RossotorresPlayerID, Logic.GetStoreHouse(1), "AI_Spawn", 3, 3, 0, 0, 1, 0, true)

end

----------------------------------------------------------------------------------------------------------------------
function TriggerCustom_StartupQuestsDone()

    if (Quests[Quest_BecomeBaronID].Result == nil) then
        return false
    end

    if (Quests[Quest_FortifyCityID].Result == nil) then
        return false
    end

    return true

end

----------------------------------------------------------------------------------------------------------------------
function OnQuestDone_ThreeGarrisons()

    SetPlayerMoral(RossotorresPlayerID, 0.3)

    MissionState.AIAttacksHumanCity = true

end

----------------------------------------------------------------------------------------------------------------------
function OnQuestDone_DeliveryToGranCastilla()

    MissionState.TrebuchetsTimer = MissionState.TrebuchetsFirstWaitTime
    
    SendVoiceMessage(RossotorresPlayerID, "NPCTalk_SecondAttackWave")
    AIScript_SpawnAndAttackCity(RossotorresPlayerID, Logic.GetStoreHouse(1), "AI_Spawn", 3, 3, 2, 0, 0, 6, true)    
    
end

----------------------------------------------------------------------------------------------------------------------
function OnQuestDone_RescueTheBishop()
   
    -- Quest 
    do
        local PrisonID = Logic.GetEntityIDByName("Prison")    
        
        -- spawn cart 
        local x,y = Logic.GetEntityPosition(PrisonID)
        MissionState.CardinalCartID =  Logic.CreateEntityOnUnblockedLand(Entities.U_RegaliaCart, x, y, 0, MonasterioPlayerID)
        Logic.HireMerchant(MissionState.CardinalCartID, MonasterioPlayerID, Goods.G_Gold, 0, 1)
        
        -- destroy the prison        
        Logic.DestroyEntity(PrisonID)
    
        -- activate blessing timer
        MissionState.BlessingTimer = MissionState.BlessingFirstWaitTime
    end

    -- AI
    do
        --SendVoiceMessage(RossotorresPlayerID, "NPCTalk_MonasteryAttackWave")
        SendVoiceMessage(RossotorresPlayerID, "NPCTalk_FirstAttackWave")        
        AIScript_SpawnAndAttackCity(RossotorresPlayerID, Logic.GetStoreHouse(1), "AI_Spawn", 3, 3, 2, 0, 0, 6, true)            
    end
    
end

----------------------------------------------------------------------------------------------------------------------
function OnQuestDone_RebuildHarbor()

    MissionState.AttackTimer = MissionState.AttackFirstWaitTime

    SendVoiceMessage(RossotorresPlayerID, "NPCTalk_LazlopolHarborAttackWave")
    AIScript_SpawnAndAttackCity(RossotorresPlayerID, Logic.GetStoreHouse(1), "AI_Spawn", 3, 3, 2, 0, 0, 6, true)    
    
end

----------------------------------------------------------------------------------------------------------------------
function ObjectiveCustom_DestroyRossotorres()

    if  Logic.GetStoreHouse(RossotorresPlayerID) == nil 
    or  Logic.GetStoreHouse(RossotorresPlayerID) == 0 then
        return true     
    end
    
end

----------------------------------------------------------------------------------------------------------------------
function DemoralizeRossotorres()

    local NewMoral = GetPlayerMoral(RossotorresPlayerID) - 0.2
    SetPlayerMoral(RossotorresPlayerID, NewMoral)

    SendVoiceMessage(RossotorresPlayerID, "NPCTalk_Demoralized")

end

----------------------------------------------------------------------------------------------------------------------
function Mission_CallBack_TerritoryOwnershipChanged(_TerritoryID, _NewPlayerID, _OldPlayerID)

    if (Logic.GetTerritoryPlayerID(TerritoryID_EasternGarrison) ~= RossotorresPlayerID) then

        Quests[Quest_DeliveryToGranCastillaID]:Interrupt()
        Quests[Quest_RebuildHarborID]:Interrupt()
        
    end

end

----------------------------------------------------------------------------------------------------------------------
--
--
--
-- Support from the knight villages and cities
--
--
--
----------------------------------------------------------------------------------------------------------------------

----------------------------------------------------------------------------------------------------------------------
function SimpleJob_UpdateTimer()

    if (MissionState.TrebuchetsTimer > 0) then
    
        MissionState.TrebuchetsTimer = MissionState.TrebuchetsTimer - 1
    
    end

    if (MissionState.BlessingTimer > 0) then
    
        MissionState.BlessingTimer = MissionState.BlessingTimer - 1
    
    end

    if (MissionState.AttackTimer > 0) then
    
        MissionState.AttackTimer = MissionState.AttackTimer - 1
    
    end
    
    
    -- 2 minutes before the attack timer is ready again we send a ship with support troups    
    do
            
        if (MissionState.AttackTimer == MissionState.AttackShipArrivingTime) then
    
            local EntityID = Logic.GetEntityIDByName("Ship_SpawnPos")        
            local x, y = Logic.GetEntityPosition(EntityID)
            ShipEntityID = Logic.CreateEntity(Entities.D_X_TradeShip, x, y, Logic.GetEntityOrientation(EntityID), Logic.EntityGetPlayer(EntityID))
        
            Path:new(ShipEntityID, { "Ship_SpawnPos", "Ship_HarborPos" }, false, false, OnShipArrivalAtHarbor, nil, true)
        
        end    
        
        -- drive back
        if (MissionState.AttackTimer == MissionState.AttackShipReturnTime) then
        
            Path:new(ShipEntityID, { "Ship_HarborPos", "Ship_SpawnPos" }, false, false, OnShipArrivalAtEndPos, nil, true)
        
        end
    
    end    
    
    -- check if the eastern garrison is still alive
    do
        local BuildingID = Logic.GetTerritoryAcquiringBuildingID(TerritoryID_EasternGarrison)
        if (Logic.EntityGetPlayer(BuildingID) ~= RossotorresPlayerID) then
        
            MissionState.TrebuchetsTimer = -1
            MissionState.AttackTimer = -1
        
        end
    
    end
    
end

----------------------------------------------------------------------------------------------------------------------
function OnShipArrivalAtEndPos()

    if (ShipEntityID ~= nil) then
    
        Logic.DestroyEntity(ShipEntityID)
    
    end

end

----------------------------------------------------------------------------------------------------------------------
function OnShipArrivalAtHarbor()

    local UnitTable =
    {
        [0] = Entities.U_MilitaryBandit_Melee_NE,
        [1] = Entities.U_MilitaryBandit_Ranged_NE,
        [2] = Entities.U_MilitaryBandit_Melee_SE,
        [3] = Entities.U_MilitaryBandit_Ranged_SE,
        [4] = Entities.U_MilitaryBandit_Melee_NA,
        [5] = Entities.U_MilitaryBandit_Ranged_NA,
        [6] = Entities.U_MilitaryBandit_Melee_ME,
        [7] = Entities.U_MilitaryBandit_Ranged_ME,        
    }

    local RandomType = Logic.GetRandom(4)

    local EntityID = Logic.GetEntityIDByName("Troops_SpawnPos")        
    local x, y = Logic.GetEntityPosition(EntityID)
                    
    local UnitTypeMelee = UnitTable[RandomType*2+0]
    local UnitTypeRanged = UnitTable[RandomType*2+1]
                    
    for i= 1, MissionState.AttackNumberOfMelee do
        Logic.CreateBattalionOnUnblockedLand(UnitTypeMelee, x, y, 0, HarborPlayerID, 9)
    end

    for i= 1, MissionState.AttackNumberOfRanged do
        Logic.CreateBattalionOnUnblockedLand(UnitTypeRanged, x, y, 0, HarborPlayerID, 9)
    end
    
end

----------------------------------------------------------------------------------------------------------------------
function Support_StartTrebuchets()
    
    if (MissionState.TrebuchetsTimer == 0) then
    
        MissionState.TrebuchetsTimer = MissionState.TrebuchetsWaitTime

        MissionState.TrebuchetsAttackTimer = MissionState.TrebuchetsAttackTime
        MissionState.NextAttack = MissionState.TrebuchetsAttackTimer

        SendVoiceMessage(GranCastillaPlayerID, "NPCTalk_Trebuchets")

        StartSimpleJob("SimpleJob_AttackWithTrebuchets")
       
    end

end

----------------------------------------------------------------------------------------------------------------------
function SimpleJob_AttackWithTrebuchets()

    -- we are ready
    if (MissionState.TrebuchetsAttackTimer <= 0) then
        return true
    end

    if (MissionState.NextAttack == MissionState.TrebuchetsAttackTimer) then

        MissionState.NextAttack = MissionState.NextAttack - (Logic.GetRandom(8) + 1)
        
        local Targets = {}
        
        -- find some targets        
        do
            Targets = {Logic.GetEntitiesOfCategoryInTerritory(TerritoryID_EasternGarrison, RossotorresPlayerID, EntityCategories.CityWallSegment, 0) }
            local CityWallGates = {Logic.GetEntitiesOfCategoryInTerritory(TerritoryID_EasternGarrison, RossotorresPlayerID, EntityCategories.CityWallGate, 0) }

            -- put gates 3 times to the list so they will be hit often
            for j=1,3 do             
                for i=1, #CityWallGates do
                    table.insert(Targets, CityWallGates[i])
                end
            end
        end
                
        
        -- fire if we have something to destroy
        if (#Targets > 0) then
            
            local AllTrebuchets = GetPlayerEntities(GranCastillaPlayerID, Entities.U_Trebuchet)
            
            if (#AllTrebuchets > 0) then
                                                                       
                MissionState.TrebuchetLastFired = MissionState.TrebuchetLastFired + 1
            
                local FiringTrebuchet = AllTrebuchets[(MissionState.TrebuchetLastFired % #AllTrebuchets) + 1]
                local AttackBuilding = Targets[Logic.GetRandom(#Targets) + 1]              
            
                Logic.RefillAmmunitions(FiringTrebuchet)                 
                Logic.GroupAttack(FiringTrebuchet, AttackBuilding)
                
            
            end
        end            
                   
    end

    MissionState.TrebuchetsAttackTimer = MissionState.TrebuchetsAttackTimer - 1

end

----------------------------------------------------------------------------------------------------------------------
function Support_StartBlessing()

    if (MissionState.BlessingTimer == 0) then

        MissionState.BlessingTimer = MissionState.BlessingWaitTime

        SendVoiceMessage(MonasterioPlayerID, "NPCTalk_Blessing")
    
        Logic.AddBuff(1, Buffs.Buff_Sermon)
        
    end
            
end

----------------------------------------------------------------------------------------------------------------------
function Support_StartAttack()

    if (MissionState.AttackTimer == 0) then

        MissionState.AttackTimer = MissionState.AttackWaitTime

        SendVoiceMessage(HarborPlayerID, "NPCTalk_Attack")
        
        -- start an attack        
        local ArmyID = AICore.CreateArmy(HarborPlayerID)
        AICore.AddSwordsmenToArmy(HarborPlayerID, ArmyID, 0, MissionState.AttackNumberOfMelee,     0)
        AICore.AddBowmenToArmy(HarborPlayerID,    ArmyID, 0, MissionState.AttackNumberOfRanged,    0)

        local AreaID = AICore.CreateAD()
        AICore.AD_AddEntity(AreaID, Logic.GetTerritoryAcquiringBuildingID(TerritoryID_EasternGarrison), 1600)

        if (TargetID ~= 0) then
            AICore.StartAttackWithPlanRaidSettlement(HarborPlayerID, ArmyID, AreaID, 0)
        end
        
    end

end

----------------------------------------------------------------------------------------------------------------------
--
--
--
-- AI handling
--
--
--
----------------------------------------------------------------------------------------------------------------------

----------------------------------------------------------------------------------------------------------------------
function AIProfile_Rossotorres(self)

    -- acitvate skirmish mode
    do        
        if self.Skirmish == nil then

            self.Skirmish = {}
            self.Skirmish.Claim_SuperiorTerritories = -99
            self.Skirmish.Claim_MinTime = 8 * 60
            self.Skirmish.Claim_MaxTime = 12 * 60
            self.Skirmish.Attack_MinTime = 200 * 60
            self.Skirmish.Attack_MaxTime = 300 * 60
            self.Skirmish.ManOutposts = true        
        
        end
        AIProfile_Skirmish(self)
    end
        
    -- deactivate cheating if rossotorres has no "outer territories" anymore
    do
        local Territories = { AITerritory.GetTerritories(self.m_PlayerID) }
        if (#Territories <= 1) then        
            if (self.m_BlackList == nil) then
            
                self.m_BlackList = {}
                self.m_BlackList[#self.m_BlackList+1] = Goods.G_Gold
                
                self.m_BlackList[#self.m_BlackList+1] = Goods.G_Regalia
                self.m_BlackList[#self.m_BlackList+1] = Goods.G_Dye
                self.m_BlackList[#self.m_BlackList+1] = Goods.G_Salt
                
                self.m_BlackList[#self.m_BlackList+1] = Goods.G_Grain
                self.m_BlackList[#self.m_BlackList+1] = Goods.G_Milk
                self.m_BlackList[#self.m_BlackList+1] = Goods.G_Carcass
                self.m_BlackList[#self.m_BlackList+1] = Goods.G_RawFish            
                self.m_BlackList[#self.m_BlackList+1] = Goods.G_Herb                            
                self.m_BlackList[#self.m_BlackList+1] = Goods.G_Wood
                self.m_BlackList[#self.m_BlackList+1] = Goods.G_Stone
                self.m_BlackList[#self.m_BlackList+1] = Goods.G_Iron
                self.m_BlackList[#self.m_BlackList+1] = Goods.G_Honeycomb
                self.m_BlackList[#self.m_BlackList+1] = Goods.G_Wool                                                          
                
            end                            
        end       
    end
    
    
    if (MissionState.AIAttacksHumanCity == true) then
    
        self.Skirmish.Claim_SuperiorTerritories = 99
    
        if ((self.m_Behavior["PlayerCityAttack"] == nil) and (MissionState.AITimeBetweenMainAttacks > 0)) then
        
            MissionState.AITimeBetweenMainAttacks  = MissionState.AITimeBetweenMainAttacks - 1
            
        end
                
        if ((self.m_Behavior["PlayerCityAttack"] == nil) and
            (MissionState.AITimeBetweenMainAttacks <= 0)) then

            self.m_Behavior["PlayerCityAttack"] = self:GenerateBehaviour(AIBehavior_AttackCity);
            self.m_Behavior["PlayerCityAttack"].m_MinNumberOfSwordsmen = 2;  
            self.m_Behavior["PlayerCityAttack"].m_MaxNumberOfSwordsmen = 5;  
            self.m_Behavior["PlayerCityAttack"].m_AliveNumberOfSwordsmen = 0;  
                
            self.m_Behavior["PlayerCityAttack"].m_MinNumberOfBowmen = 3;  
            self.m_Behavior["PlayerCityAttack"].m_MaxNumberOfBowmen = 5;  
            self.m_Behavior["PlayerCityAttack"].m_AliveNumberOfBowmen = 0; 
            
            self.m_Behavior["PlayerCityAttack"].m_MinNumberOfCatapults = 1
            self.m_Behavior["PlayerCityAttack"].m_MaxNumberOfCatapults = 2
            self.m_Behavior["PlayerCityAttack"].m_FleeNumberOfCatapults = 0    
            
            self.m_Behavior["AttackCity"].m_MinNumberOfRams= rams
            self.m_Behavior["AttackCity"].m_MaxNumberOfRams = rams
            self.m_Behavior["AttackCity"].m_FleeNumberOfRams = 0  

            self.m_Behavior["AttackCity"].m_MinNumberOfTowers= 0
            self.m_Behavior["AttackCity"].m_MaxNumberOfTowers = 1
            self.m_Behavior["AttackCity"].m_FleeNumberOfTowers = 0  
                                    
            self.m_Behavior["PlayerCityAttack"].m_TargetID = Logic.GetStoreHouse(1)
                        
            if (self.m_Behavior["PlayerCityAttack"]:Start() == false) then
            
                self.m_Behavior["PlayerCityAttack"] = nil;
                
            else
                            
                SendVoiceMessage(SabattaPlayerID, "NPCTalk_MainAttackWavePre1")
                SendVoiceMessage(SabattaPlayerID, "NPCTalk_MainAttackWave")
                
            end 
        
        end
                            
    
    end
    
end

----------------------------------------------------------------------------------------------------------------------
--
--
--
-- Benchmarking
--
--
--
----------------------------------------------------------------------------------------------------------------------

function RossoTorres_SetCameraToBigCity()

	Logic.ExecuteInLuaLocalState("Camera.RTS_SetLookAtPosition(52150, 45100)")
	Logic.ExecuteInLuaLocalState("Camera.RTS_SetZoomFactor(1)")
	
end

function RossoTorres_Benchmark01()

	Game.ShowFPS(1)
	DisableFoW()
	Game.GUIActivate(0)
	
	RossoTorres_SetCameraToBigCity()

end

function RossoTorres_Benchmark02()

	Game.ShowFPS(1)
	DisableFoW()
	--Game.GUIActivate(0)
	
	RossoTorres_SetCameraToBigCity()

end

function Mission_Victory()

    local x, y = Logic.GetEntityPosition(Logic.GetEntityIDByName("VictoryPrisonCartPath0"))
    local PrisonCart = Logic.CreateEntityOnUnblockedLand(Entities.U_PrisonCart, x, y, 0, 1)    
    
    local x, y = Logic.GetEntityPosition(Logic.GetEntityIDByName("VictorySpawnLeader"))
    local Leader = Logic.CreateBattalionOnUnblockedLand(Entities.U_MilitaryBow, x, y, 0, 1, 6)    
    Logic.GroupGuard(Leader, PrisonCart)
    
    Path:new(PrisonCart, { "VictoryPrisonCartPath0", "VictoryPrisonCartPath1" } , false)        
    
    --Logic.DestroyEntity(Logic.GetKnightID(HarborPlayerID))
    --Logic.DestroyEntity(Logic.GetKnightID(MonasterioPlayerID))
    --Logic.DestroyEntity(Logic.GetKnightID(GranCastillaPlayerID))
    
    local VictoryKnightPos = Logic.GetEntityIDByName("VictoryKnight1")
    local x,y = Logic.GetEntityPosition(VictoryKnightPos)
    local Orientation = Logic.GetEntityOrientation(VictoryKnightPos)
    VictorySetEntityToPosition( Logic.GetKnightID(1), x, y, Orientation )
    
    
    local TraitorEntityType = GlobalGetTraitor()
    local OwnKnightType = Logic.GetEntityType(Logic.GetKnightID(1))
    
    local KnightTypes = {Entities.U_KnightTrading,
                        Entities.U_KnightHealing,
                        Entities.U_KnightChivalry,
                        Entities.U_KnightPlunder,
                        Entities.U_KnightSong,
                        Entities.U_KnightWisdom}
    
    for m=1, #KnightTypes do
        if KnightTypes[m] == TraitorEntityType then
            table.remove(KnightTypes, m)
        end
        
        if KnightTypes[m] == OwnKnightType then
            table.remove(KnightTypes, m)
        end
    end
    
    for l=2,5 do
        local VictoryKnightPos = Logic.GetEntityIDByName("VictoryKnight" ..l)
        local x,y = Logic.GetEntityPosition(VictoryKnightPos)
        local Orientation = Logic.GetEntityOrientation(VictoryKnightPos)
        Logic.CreateEntityOnUnblockedLand(KnightTypes[l-1], x, y, Orientation-90, 1)
    end
    
   
    local PossibleSettlerTypes = {  Entities.U_NPC_Monk_ME,    
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
   
   --Logic.HurtEntity(Logic.GetHeadquarters(RossotorresPlayerID), 300)
    
    
    local MarketX, MarketY = VictoryMarketPosInRossotorres[1], VictoryMarketPosInRossotorres[2]
    Logic.CreateEntity(Entities.D_X_Garland, MarketX, MarketY, 0, 1)
        
        
    for i=1, 30 do
        for k=1,30 do
            local SettlersX = MarketX -3000+ (i*200)
            local SettlersY = MarketY -3000+ (k*200)
            
            local rand = Logic.GetRandom(100)
            
            if rand > 70 then
                local SettlerType = PossibleSettlerTypes[1 + Logic.GetRandom(#PossibleSettlerTypes)]
                local Orientation = Logic.GetRandom(360)
                local WorkerID = Logic.CreateEntityOnUnblockedLand(SettlerType, SettlersX, SettlersY, Orientation, SanRamosPlayerID)
                Logic.SetTaskList(WorkerID, TaskLists.TL_WORKER_FESTIVAL_APPLAUD_SPEECH)
            end
        end
    end


end


