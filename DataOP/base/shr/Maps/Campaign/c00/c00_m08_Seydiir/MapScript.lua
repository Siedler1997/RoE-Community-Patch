Script.Load("Script\\Global\\CampaignHotfix.lua")

CurrentMapIsCampaignMap = true
----------------------------------------------------------------------------------------------------------------------
function Mission_InitPlayers()

    SabattaPlayerID = SetupPlayer(2, "H_Knight_Sabatt", "Efstad", "RedPrinceColor")
    GrandmaPlayerID = SetupPlayer(3, "H_NPC_Amma", "Reykka", "CityColor3")
    VillagePlayerID = SetupPlayer(4, "H_NPC_Villager01_NE", "Ytravik", "VillageColor3")
    
    RedPrincePlayerID = SetupPlayer(5, "H_Knight_RedPrince", "Red Prince", "RedPrinceColor")

    -- set some resources for player 1
    AddResourcesToPlayer(Goods.G_Gold,250)
    AddResourcesToPlayer(Goods.G_Stone,50)
    AddResourcesToPlayer(Goods.G_Wood,50)
    AddResourcesToPlayer(Goods.G_Grain,10)
    AddResourcesToPlayer(Goods.G_Carcass,10)
    --AddResourcesToPlayer(Goods.G_RawFish,10)
    AddResourcesToPlayer(Goods.G_Milk,10)
    
    
    -- set some resources for player 2    
    AddResourcesToPlayer(Goods.G_Gold,310, SabattaPlayerID)    
    AddResourcesToPlayer(Goods.G_Iron,30, SabattaPlayerID)
    AddResourcesToPlayer(Goods.G_Wood,30, SabattaPlayerID)
    AddResourcesToPlayer(Goods.G_Grain,60, SabattaPlayerID)
    AddResourcesToPlayer(Goods.G_Carcass,60, SabattaPlayerID)
    AddResourcesToPlayer(Goods.G_Herb,60, SabattaPlayerID)
    AddResourcesToPlayer(Goods.G_Wool,60, SabattaPlayerID)
    AddResourcesToPlayer(Goods.G_Milk,60, SabattaPlayerID)
    AddResourcesToPlayer(Goods.G_Honeycomb,60, SabattaPlayerID)
    

    -- set diplomacy state
	SetDiplomacyState(1, SabattaPlayerID, DiplomacyStates.Enemy)
	SetDiplomacyState(1, GrandmaPlayerID, DiplomacyStates.EstablishedContact)
	SetDiplomacyState(1, VillagePlayerID, DiplomacyStates.Undecided)
	
	SetDiplomacyState(SabattaPlayerID, GrandmaPlayerID, DiplomacyStates.Undecided)
	SetDiplomacyState(SabattaPlayerID, VillagePlayerID, DiplomacyStates.Undecided)
	
	SetDiplomacyState(GrandmaPlayerID, VillagePlayerID, DiplomacyStates.EstablishedContact)
	
	
	 -- locked technolgies and upgrade levels.
    local TechologiesToLock = { Technologies.R_Medicine,
                                Technologies.R_HerbGatherer,
                                
                                Technologies.R_Wealth,
                                Technologies.R_BannerMaker}

    LockFeaturesForPlayer( 1, TechologiesToLock)
    
    LockTitleForPlayer(1, KnightTitles.Duke)
    
    SetKnightTitle(SabattaPlayerID, KnightTitles.Duke)
	
	GameCallback_CreateKnightByTypeOrIndex(Entities.U_KnightSabatta, SabattaPlayerID)
end
----------------------------------------------------------------------------------------------------------------------
function Mission_SetStartingMonth()

    Logic.SetMonthOffset(6)

end
----------------------------------------------------------------------------------------------------------------------
function Mission_InitMerchants()

    local traderId = Logic.GetStoreHouse(VillagePlayerID)
    AddOffer(traderId,	10,Goods.G_Sheep)
    AddOffer(traderId,	10,Goods.G_Bread)

end
----------------------------------------------------------------------------------------------------------------------
function Mission_FirstMapAction()

    Mission_SetupQuests()
    
    ActivateRespawnForCarnivores(Logic.GetEntityIDByName("WolfPack"))
    
    --setup
    AIPlayer:new(SabattaPlayerID, AIProfile_Sabatta, Entities.U_KnightSabatta)
    
    --the avalanche
    local AvalancheID  = Logic.GetEntityIDByName("avalanche")
    
    --save the data, to replace it later and to start an effect
    Avalanche ={}    
    Avalanche.X, Avalanche.Y = Logic.GetEntityPosition(AvalancheID)
    Avalanche.Orientation = Logic.GetEntityOrientation(AvalancheID)
    
    Logic.InteractiveObjectClearCosts(AvalancheID)
    Logic.InteractiveObjectSetInteractionDistance(AvalancheID, 1000)
    Logic.InteractiveObjectSetTimeToOpen(AvalancheID, 0)
    Logic.InteractiveObjectSetPlayerState(AvalancheID,1, 2)
    
    --Create Thief
    --local ThiefPosition  = Logic.GetEntityIDByName("thief")
    --local ThiefX, ThiefY = Logic.GetEntityPosition(ThiefPosition)
    --PlayersFirstThief = Logic.CreateEntityOnUnblockedLand(Entities.U_Thief, ThiefX, ThiefY,0,1)

end

function Mission_SetupQuests()



    Deliveries = {}
    Deliveries.Lost = 0
    Deliveries.Won = 0
    
    FishTerritory = 21
    

    --MAIN QUEST ACTIVE ALL THE TIME, NO SUCESS MESSAGE.. THIS IS SET TO SUCCESS, FROM THE LAST QUEST
    raceMainQuestID, raceMainQuest = QuestTemplate:New("Quest_Race", GrandmaPlayerID, 1, 
                                                { { Objective.Custom, Custom_QuestRace} }, 
                                                {{Triggers.Time, 1}}, 
                                                0, 
                                                { { Reward.PrestigePoints, 5000 } , {Reward.CampaignMapFinished} }, 
                                                {{Reprisal.Defeat}}, 
                                                OnQuestRaceEnded, nil, true, false) 

                        
    --DELIVER GOLD
    deliverGoldQuestID, deliverGoldQuest = QuestTemplate:New("Quest_DeliverGold", GrandmaPlayerID, 1, 
                                                { { Objective.Deliver, Goods.G_Gold, 300 } }, 
                                                { { Triggers.Time, 1 } }, 
                                                0, 
                                                { { Reward.PrestigePoints, 800 } },
                                                nil, 
                                                OnDeliverGoldQuestFinished, 
                                                DuringDeliverQuest
                                                )


    --DELIVER CLOTHES
    deliverClothesQuestID, deliverClothesQuest = QuestTemplate:New("Quest_DeliverClothes", GrandmaPlayerID, 1, 
                                                { { Objective.Deliver, Goods.G_Clothes, 8 } },
                                                { { Triggers.Quest, deliverGoldQuestID, 0} }, 
                                                0, 
                                                { { Reward.PrestigePoints, 1400 } },
                                                nil, 
                                                OnDeliverClothesQuestFinished, 
                                                DuringDeliverQuest
                                                )

    --DELIVER SMOKED FISH
    deliverFishQuestID,deliverFishQuest = QuestTemplate:New("Quest_DeliverFish", GrandmaPlayerID, 1, 
                                                { { Objective.Deliver, Goods.G_RawFish, 8 } },
                                                { { Triggers.Quest, deliverClothesQuestID, 0} }, 
                                                0, 
                                                { { Reward.PrestigePoints, 800 } },
                                                nil, 
                                                OnDeliverFishFinished, 
                                                DuringDeliverQuest
                                                )

    --DELIVER SIEGE ENGINE PARTS
    deliverPartsQuestID, deliverPartsQuest = QuestTemplate:New("Quest_DeliverSiegeEngineParts", GrandmaPlayerID, 1, 
                                                { { Objective.Deliver, Goods.G_SiegeEnginePart, 10 } },
                                                { { Triggers.Quest, deliverFishQuestID, 0} },                                                 
                                                0, 
                                                { { Reward.PrestigePoints, 1800 } },
                                                nil, 
                                                OnDeliverQuestFinished, 
                                                DuringDeliverQuest
                                                )
                                                
    --Add data to the quests
    SabattasProductionDuration = {}
    SabattasProductionDuration[deliverGoldQuestID]     = 60 * 15   
    SabattasProductionDuration[deliverClothesQuestID]  = 60 * 15
    SabattasProductionDuration[deliverFishQuestID]     = 60 * 20
    SabattasProductionDuration[deliverPartsQuestID]    = 60 * 30
    
    SabattaSpeech ={}
    SabattaSpeech[deliverGoldQuestID]     = {"NPCTalk_SabattaSendsGoldBeforePlayer", "NPCTalk_SabattaSendsGoldAfterPlayer"}
    SabattaSpeech[deliverClothesQuestID]  = {"NPCTalk_SabattaSendsClothesBeforePlayer", "NPCTalk_SabattaSendsClothesAfterPlayer"}
    SabattaSpeech[deliverFishQuestID]     = {"NPCTalk_SabattaSendsFishBeforePlayer", "NPCTalk_SabattaSendsFishAfterPlayer"}
    SabattaSpeech[deliverPartsQuestID]    = {"NPCTalk_SabattaSendsPartsBeforePlayer", "NPCTalk_SabattaSendsPartsAfterPlayer"}

    FishTerritory = 21
    
    SetupSabattasQuests()
    
    GenerateDoNotKillCheck()
    
   
    --SUBQUEST: HELP VILLAGE
    findVillageQuestID = QuestTemplate:New("Quest_DiscoverVillage", VillagePlayerID, 1, 
                                              { { Objective.Discover, 2, {VillagePlayerID} } },
                                              { { Triggers.Time, 0 } },
                                              0, 
                                              { { Reward.Diplomacy, VillagePlayerID, 1 } },
                                              nil, OnVillageFound, nil, false, true)
    
    

    --END DIAOLG. SABATTA LOST, VIKINGS JOIN
    GenerateVictoryDialog({{GrandmaPlayerID,"Victory_GrandmaCongratulats" },
                            {SabattaPlayerID,"Victory_SabattaLeftMap" },
                            {GrandmaPlayerID,"Victory_VikingsJoinEmpire" }}, raceMainQuestID)
    
    
    StartSimpleJob("CheckIfFishTerritoryBelongsToPlayer")
    
end

function Custom_QuestRace()

end

function OnQuestRaceEnded(_Quest)
    if Quests[findVillageQuestID].State ~= QuestState.Over then
        Quests[findVillageQuestID]:Interrupt()
    end
    
    if killWolves1ID ~= nil then
        Quests[killWolves1ID]:Interrupt()
        Quests[killWolves2ID]:Interrupt()
    end

    if Quests[deliverPartsQuestID].State ~= QuestState.Over then
        Quests[deliverPartsQuestID]:Interrupt()
    end
    if _Quest.Result == QuestResult.Failure then
        SendVoiceMessage(GrandmaPlayerID,"Defeat_GrandmaCongratulats")
        SendVoiceMessage(SabattaPlayerID,"Defeat_SabattaTriumph")        
    end
    
end

---------------------------------------------------------------------------
-- Do not kill check
---------------------------------------------------------------------------
function GenerateDoNotKillCheck()

    --HIDDEN QUEST: KILLING AND DESTROYING NOT ALLOWED
    doNotKillSoldiers1QuestID = QuestTemplate:New("Quest_DoNotKillSoldiers1", GrandmaPlayerID, 1, 
                                    { { Objective.DestroyEntities, 2, 0,1,SabattaPlayerID } }, 
                                    {{Triggers.Time, 0}}, 
                                    0, nil,nil,nil, nil, false, true) 


    doNotKillSoldiers2QuestID = QuestTemplate:New("Quest_DoNotKillSoldiers2", GrandmaPlayerID, 1, 
                                    { { Objective.DestroyEntities, 2, 0,1,SabattaPlayerID } }, 
                                    { { Triggers.Quest, doNotKillSoldiers1QuestID, QuestResult.Success} }, 
                                    0, nil,nil,nil, nil, false, true) 


    --HIDDEN QUEST: KILLING AND DESTROYING third TIME LEADS TO LOOSE
    doNotKillSoldiers3QuestID = QuestTemplate:New("Quest_DoNotKillSoldiers3", GrandmaPlayerID, 1, 
                                { { Objective.DestroyEntities, 2, 0,1,SabattaPlayerID } }, 
                                { { Triggers.Quest, doNotKillSoldiers2QuestID, QuestResult.Success } }, 
                                0, nil, nil, OnTooMuchSoldiersKilled, nil, false, true) 

    

end


function OnTooMuchSoldiersKilled(_Quest)
    if _Quest.Result == QuestResult.Success then
        raceMainQuest:Fail()
    end
end

---------------------------------------------------------------------------
-- Steal quest
---------------------------------------------------------------------------
function OnDeliverGoldQuestFinished(_Quest)
    OnStealQuestCompleted()
    OnDeliverQuestFinished(_Quest)
end

function OnFishTerritoryClaimed1(quest)
    if quest.Result == QuestResult.Success then
        if MoveToTerritoryID ~= nil and Quests[MoveToTerritoryID].State ~= QuestState.Over then
            Quests[MoveToTerritoryID]:Interrupt()
        end
        if claimTerritoryQuestID ~= nil and Quests[claimTerritoryQuestID].State ~= QuestState.Over then
            Quests[claimTerritoryQuestID]:Interrupt()
        end
    end
end

function OnFishTerritoryClaimed2(quest)
    if quest.Result == QuestResult.Success then
        Quests[claimTerritoryQuestID2]:Interrupt()
    end
end
function OnDeliverClothesQuestFinished(_Quest)
    
    
    local FishTerritoryPosition = Logic.GetEntityIDByName("FishTerritory")
    
    local TerritoryOwner = Logic.GetTerritoryPlayerID(FishTerritory)
    if TerritoryOwner == 1 then
        claimTerritoryQuestID = QuestTemplate:New("Quest_ClaimFishTerritory", 1, 1,
                                                        { {Objective.Claim, 1, FishTerritory  }},
                                                        { { Triggers.Time, 0} },
                                                        0, nil, nil,nil, nil, false, true)
    else
        claimTerritoryQuestID2 = QuestTemplate:New("Quest_ClaimFishTerritory", 1, 1,
                                                        { {Objective.Claim, 1, FishTerritory  }},
                                                        { { Triggers.Time, 0} },
                                                        0, 
                                                        {{ Reward.PrestigePoints, 800 }},
                                                        nil,OnFishTerritoryClaimed1, nil, false, true)

        MoveToTerritoryID = QuestTemplate:New("Quest_MoveToFishTerritory", 1, 1,
                                        { {Objective.Distance, Logic.GetKnightID(1), FishTerritoryPosition  }},
                                        { { Triggers.Time, 0 } },
                                        0, nil,nil,nil, nil, true, false)
        
        claimTerritoryQuestID = QuestTemplate:New("Quest_ClaimFishTerritory", 1, 1,
                                                        { {Objective.Claim, 1, FishTerritory  }},
                                                        { { Triggers.Quest, MoveToTerritoryID , QuestResult.Success} },
                                                        0, 
                                                        {{ Reward.PrestigePoints, 800 }},
                                                        nil,OnFishTerritoryClaimed2, nil, true)
    end
    
    Quests[doNotKillSoldiers1QuestID]:Interrupt()
    Quests[doNotKillSoldiers2QuestID]:Interrupt()
    Quests[doNotKillSoldiers3QuestID]:Interrupt()

    OnDeliverQuestFinished(_Quest)
    
end


function OnDeliverFishFinished(_Quest)

    OnDeliverQuestFinished(_Quest)
    GenerateDoNotKillCheck()
end

function OnStealQuestCompleted()

    stealQuestID = QuestTemplate:New("Quest_SabotageSabatta", 1, 1,
                        { { Objective.Steal, 1, { Logic.GetStoreHouse(SabattaPlayerID) } } },
                        { {Triggers.Time, 0 } },
                        0, 
                        { { Reward.PrestigePoints, 2000 } }, 
                        nil, 
                        nil, 
                        nil, 
                        true, 
                        false
                        )
                                
end

function MissionCallback_OnThiefStealBuilding(_ThiefID, _ThiefPlayerID, _BuildingID, _BuildingPlayerID)

   if stealQuestID == nil or Quests[stealQuestID].State ~= QuestState.Active then
    return 
   end

   if   _ThiefPlayerID == 1 
   and  Logic.GetStoreHouse(_BuildingPlayerID) ==  _BuildingID then
   
        --KoBo: removed this because this is too early for the GameCallback_Feedback_ThiefDeliverInformations to work
        -- also, he's destroyed by GlobalThiefSystem anyway (but a bit later).
        --Logic.DestroyEntity(_ThiefID)

        SendVoiceMessage(SabattaPlayerID,"NPCTalk_ThiefCaptured")
        
        local ActiveQuestID
        
        if Quests[deliverGoldQuestID].State == QuestState.Active then
            ActiveQuestID = deliverGoldQuestID
        elseif Quests[deliverClothesQuestID].State == QuestState.Active then
            ActiveQuestID = deliverClothesQuestID
        elseif Quests[deliverFishQuestID].State == QuestState.Active then
            ActiveQuestID = deliverFishQuestID
            FishDeliverySabbattaStartTime = FishDeliverySabbattaStartTime + (60 * 3)
            ResetFishTimer = true
        elseif Quests[deliverPartsQuestID].State == QuestState.Active then
            ActiveQuestID = deliverPartsQuestID
        end
        
        if ActiveQuestID ~= deliverFishQuestID then
            SabattasDeliverStartTime[ActiveQuestID] = SabattasDeliverStartTime[ActiveQuestID] + (60 * 3)
            local displayedTime = SabattasProductionDuration[ActiveQuestID] + Quests[ActiveQuestID].StartTime + (60 * 3 ) - Logic.GetTime()
            ShowMissionTimer(displayedTime)
        end
        
        Quests[stealQuestID]:Success()
       
    end
   
end


---------------------------------------------------------------------------
-- Claim territory quest
---------------------------------------------------------------------------
function CheckIfFishTerritoryBelongsToPlayer()
    
    local TerritoryOwner = Logic.GetTerritoryPlayerID(FishTerritory)
    
    if TerritoryOwner == SabattaPlayerID and CaptureQuestTriggered == nil then
            if MoveToTerritoryID ~= nil then
                Quests[MoveToTerritoryID]:Interrupt()
            end
            if claimTerritoryQuestID ~= nil then
                Quests[claimTerritoryQuestID]:Interrupt()
            end

            captureFishTerritoryID = QuestTemplate:New("Quest_CaptureFishTerritory", 1, 1,
                                        { {Objective.Create, Entities.B_Outpost_NE,1,FishTerritory  }},
                                        { { Triggers.Time, 0 } },
                                        0, 
                                        { { Reward.PrestigePoints, 1500 } },
                                        nil,
                                        OnFishTerritoryCaptured, 
                                        nil, 
                                        true
                                        )
                        
            CaptureQuestTriggered = true
            
    end
    
end

function OnFishTerritoryCaptured()
    ShowMissionTimer(-1)
end

 ---------------------------------------------------------------------------
-- Player Quest handling
---------------------------------------------------------------------------

function OnDeliverQuestFinished(_Quest)

    if _Quest.State == QuestState.Over then
        
        if _Quest.Index == deliverFishQuestID then
            
            if captureFishTerritoryID ~= nil then
                Quests[captureFishTerritoryID]:Interrupt()
            end
            
            if MoveToTerritoryID ~= nil and Quests[MoveToTerritoryID].State ~= QuestState.Over then
                Quests[MoveToTerritoryID]:Interrupt()
            end
            if claimTerritoryQuestID ~= nil and Quests[claimTerritoryQuestID].State ~= QuestState.Over then
                Quests[claimTerritoryQuestID]:Interrupt()
            end
        end
        
        --Count when player looses
        if _Quest.Result == QuestResult.Failure then
            Deliveries.Lost = Deliveries.Lost + 1
        elseif _Quest.Result == QuestResult.Success then
            Deliveries.Won = Deliveries.Won + 1
        end
    end
    
    --finish quest for sabatta, when player succeded
    if _Quest.Result == QuestResult.Success then
    
        if _Quest.Index == deliverGoldQuestID then   
            if SabattaDeliverGoldQuest.Result ~= QuestResult.Success then         
                SabattaDeliverGoldQuest:Fail()
            end
        end
        
        if _Quest.Index == deliverClothesQuestID then            
            if SabattaDeliverClothesQuest.Result ~= QuestResult.Success then         
                SabattaDeliverClothesQuest:Fail()
            end
        end
        
        if _Quest.Index == deliverFishQuestID then            
            if SabattaDeliverFishQuest.Result ~= QuestResult.Success then         
                SabattaDeliverFishQuest:Fail()
            end
        end
        
        if _Quest.Index == deliverPartsQuestID then            
            if SabattaDeliverPartsQuest.Result ~= QuestResult.Success then         
                SabattaDeliverPartsQuest:Fail()
            end
        end
        
    end
    
    if Deliveries.Won == 3 then
        raceMainQuest:Success()
    end
    
    if Deliveries.Lost == 1 and GetBetterSpoken == nil then
        SendVoiceMessage(GrandmaPlayerID, "NPCTalk_GetBetter")
        GetBetterSpoken = true
    end
    
    if Deliveries.Lost == 2 and LastChanceSpoken == nil then
        SendVoiceMessage(GrandmaPlayerID, "NPCTalk_LastChance")
        LastChanceSpoken = true
    end
    
    
    --MAIN QUEST IS LOST, WHEN 3 DELIVER QUESTS LOST
    if Deliveries.Lost == 3 then
        raceMainQuest:Fail()
    end

    --MAIN QUEST IS WON WITH DELIVER SIEGE ENGINE PARTS QUEST
    if _Quest.Index == deliverPartsQuestID then
       
        if Deliveries.Lost == 2 and _Quest.Result == QuestResult.Success then
            raceMainQuest:Success()
        elseif Deliveries.Lost == 2 then
            raceMainQuest:Fail()
        end
    end

end

FishPlayerTimeCounter = 0
ResetFishTimer = true
function DuringDeliverQuest(_Quest)

    if _Quest.State == QuestState.Active then
    
        local QuestIndex            = _Quest.Index
        local GoodTypeToDeliver     = _Quest.Objectives[1].Data[1]
        local GoodAmountToDeliver   = _Quest.Objectives[1].Data[2]
        local PlayersCart           = _Quest.Objectives[1].Data[3]
        
        
        if PlayerSendGood == nil then
            PlayerSendGood ={}
        end
        
        if QuestStartTime == nil then
            QuestStartTime = {}
        end
        
        if SabattasDeliverStartTime == nil then
            SabattasDeliverStartTime = {}
        end
        
        if SabattaSendGood == nil then
            SabattaSendGood =  {}
        end
        
        if RedPrinceSendShip == nil then
            RedPrinceSendShip = {}
        end
        
        --set start time and show timer
         if QuestStartTime[GoodTypeToDeliver] == nil then
            
            QuestStartTime[GoodTypeToDeliver] = Logic.GetTime()

            if  GoodTypeToDeliver ~= Goods.G_RawFish then        
                SabattasDeliverStartTime[QuestIndex] = Logic.GetTime() + SabattasProductionDuration[QuestIndex]
                
                ShowMissionTimer(SabattasProductionDuration[QuestIndex])
            end
        end 
        
        --special case handling for the fish territory stuff
        if  GoodTypeToDeliver == Goods.G_RawFish then
        
            if PlayersCart ~= nil then
                CaptureQuestTriggered = true
                if captureFishTerritoryID ~= nil and Quests[captureFishTerritoryID].State ~= QuestState.Over then
                    Quests[captureFishTerritoryID]:Interrupt()
                end
                -- should not be needed but...
                if MoveToTerritoryID ~= nil and Quests[MoveToTerritoryID].State ~= QuestState.Over then
                    Quests[MoveToTerritoryID]:Interrupt()
                end
                if claimTerritoryQuestID ~= nil and Quests[claimTerritoryQuestID].State ~= QuestState.Over then
                    Quests[claimTerritoryQuestID]:Interrupt()
                end
            end
            
            if  Logic.GetTerritoryPlayerID(FishTerritory) == SabattaPlayerID then
            
                if TimerForSabattaDeliversFishStarted == nil then
                    FishDeliverySabbattaStartTime = Logic.GetTime()
                    TimerForSabattaDeliversFishStarted = true
                end

                if ResetFishTimer then
                    SabattasDeliverStartTime[QuestIndex] = FishDeliverySabbattaStartTime + SabattasProductionDuration[QuestIndex] + FishPlayerTimeCounter
                    ShowMissionTimer(SabattasDeliverStartTime[QuestIndex] - Logic.GetTime())
                    ResetFishTimer = false
                end

            else
                FishPlayerTimeCounter = FishPlayerTimeCounter + 1
                ShowMissionTimer(-1)
                ResetFishTimer = true
                
            end
        end            
        
        
           
        
        --whan player has launched cart, and sabatta not,  sabbata gets ship and starts
        if  PlayersCart ~= nil 
        and PlayersCart ~= 1 
        and PlayerSendGood[GoodTypeToDeliver] == nil 
        and SabattaSendGood[GoodTypeToDeliver] == nil then
        
            --Red prince sends ship
            StartShip()            
            
            PlayerSendGood[GoodTypeToDeliver] = true
            
            if SabattaSendGood[GoodTypeToDeliver] ~= true then
                SendVoiceMessage(GrandmaPlayerID, "NPCTalk_GrandmaDeliverIsOnItsWay")
            end

            
        end
        

        if ship ~= nil and RedPrinceSendShip[GoodTypeToDeliver] == nil then
            
            --wait X seconds before sabatta starts
            local WaitTimeAfterPlayerSend = 60 + Logic.GetRandom(15)
            
            --set new time
            SabattasDeliverStartTime[QuestIndex] = Logic.GetTime() + WaitTimeAfterPlayerSend
            
            --reset timer
            ShowMissionTimer(WaitTimeAfterPlayerSend)
            
            RedPrinceSendShip[GoodTypeToDeliver] = true
            
        end
        
        --sabatta starts deliver
        --local PlayersGoods = GetPlayerGoodsInSettlement(GoodTypeToDeliver, 1)
        
        --if  PlayersGoods  >= GoodAmountToDeliver        
        if SabattasDeliverStartTime[QuestIndex] ~= nil and
            Logic.GetTime() >= SabattasDeliverStartTime[QuestIndex] then
        
        
            local MerchantID = Quests[SabattaDeliverQuest[QuestIndex]].Objectives[1].Data[3]
            
            if MerchantID == nil then
               
                --generate cart and send it to grandma
                Quests[SabattaDeliverQuest[QuestIndex]].Objectives[1].Data[3] = SabattaStartDeliver(GoodTypeToDeliver,GoodAmountToDeliver )
                
                --play voice, depending if player has also send
                local SabattaMessage = SabattaSpeech[QuestIndex][1]
                
                if PlayerSendGood[GoodTypeToDeliver] == true then
                    SabattaMessage = SabattaSpeech[QuestIndex][2]
                end
                
                SendVoiceMessage(SabattaPlayerID, SabattaMessage)
                
                if PlayerSendGood[GoodTypeToDeliver] ~= true then
                    SendVoiceMessage(GrandmaPlayerID, "NPCTalk_GrandmaDeliverIsOnItsWay")
                end
                
                SabattaSendGood[GoodTypeToDeliver] = true
                
                
                --activate avalanche quest, after sabatta has started her delivering
                if  GoodTypeToDeliver == Goods.G_SiegeEnginePart
                and avalancheactivated == nil then
                    
                    if WolfQuestForVillageFulfilled then
                        local AvalancheID  = Logic.GetEntityIDByName("avalanche")
                        local avalancheQuestID = QuestTemplate:New("Quest_ActivateAvalanche",VillagePlayerID,1,
                                                                    { {Objective.Object, { AvalancheID} } },
                                                                    { { Triggers.Time, 0 } },
                                                                    0,
                                                                    { { Reward.PrestigePoints, 1000 } },
                                                                    nil,
                                                                    OnAvalancheActivated
                                                                    )
                
                        Logic.InteractiveObjectSetPlayerState(AvalancheID,1, 0)
                
                        avalancheactivated = true
                    end
                end
                
                
            end
        end
    end

end


---------------------------------------------------------------------------
-- Village quest strand
---------------------------------------------------------------------------

function OnVillageFound(quest)

    if quest.Result == QuestResult.Success then
        WolfesTerritoryID = 5
        
        --Getting wolves like this, because GetEntitiesInTerritory does not work for PlayerID 0
        local allWolves = { Logic.GetEntities(Entities.A_ME_Wolf,29) }
        local wolves = {}
        for i=1, allWolves[1] do
            local wolf = allWolves[i+1]
            local x, y = Logic.GetEntityPosition(wolf)
            if Logic.GetTerritoryAtPosition(x, y) == WolfesTerritoryID then
                wolves[#wolves+1] = wolf
            end
        end
        
        killWolves1ID = QuestTemplate:New("Quest_KillWolves", VillagePlayerID, 1, 
                        {{Objective.DestroyEntities, 1, wolves}}, 
                        { { Triggers.Quest, deliverGoldQuestID, QuestResult.Success } }, 
                        0, 
                        { { Reward.PrestigePoints, 900 },{Reward.Diplomacy, VillagePlayerID, 1 } },
                        nil,
                        OnWolfesKilled
                        )
    
    
        killWolves2ID = QuestTemplate:New("Quest_KillWolves", VillagePlayerID, 1, 
                        {{Objective.DestroyEntities, 1, wolves}}, 
                        { { Triggers.Quest, deliverGoldQuestID, QuestResult.Failure } }, 
                        0, 
                        { { Reward.PrestigePoints, 900 },{Reward.Diplomacy, VillagePlayerID, 1 } },
                        nil,
                        OnWolfesKilled
                        )
    end
end


function OnWolfesKilled(_Quest)

    if _Quest.Result == QuestResult.Success then
        WolfQuestForVillageFulfilled = true
    end
    --delte spawners
    local allWolveSpanwers = { Logic.GetEntities(Entities.S_WolfPack,29) }
    
    for i=1, allWolveSpanwers[1] do
        local spawn = allWolveSpanwers[i+1]
        local x, y = Logic.GetEntityPosition(spawn)
        if Logic.GetTerritoryAtPosition(x, y) == WolfesTerritoryID then
            Logic.DestroyEntity(spawn)
        end
    end
    
end

---------------------------------------------------------------------------
-- Avalanche 
---------------------------------------------------------------------------

function OnAvalancheActivated(_Quest)


    local x,y = Avalanche.X, Avalanche.Y
    local type = EGL_Effects.E_NE_Avalanche_Anim
    local orientation = Avalanche.Orientation
    
    Avalanche.EffectID = Logic.CreateEffectWithOrientation(type, x,y,orientation,0)
    Avalanche.StartTime = Logic.GetTimeMs()
    
    local KnightID = Logic.GetKnightID(1)    
    local MoveToX, MoveToY = Logic.GetEntityPosition(Logic.GetEntityIDByName("behindAvalanche"))
    
    Logic.MoveSettler(KnightID, MoveToX, MoveToY)
    
--    Logic.ExecuteInLuaLocalState("ShowAvalanche()")
    
    StartSimpleJob("ReplaceObjectAfterEffect")
    
end


function ReplaceObjectAfterEffect()


    if Avalanche.Deleted == nil  and Logic.GetTimeMs() >= Avalanche.StartTime + 1 then
        Logic.DestroyEntity(Logic.GetEntityIDByName("avalanche"))
        Avalanche.Deleted = true
    end

    if Logic.GetTimeMs() >= Avalanche.StartTime + 5600 then
        
        Logic.DestroyEffect(Avalanche.EffectID )

        
        local Type = Entities.D_NE_Avalanche_Broken
        local CreatingPlayerID = 0
        local BeamToX, BeamToY = Logic.GetEntityPosition(Logic.GetEntityIDByName("behindAvalanche"))

        Logic.OnAvalancheLaunched(Type, Avalanche.X, Avalanche.Y, Avalanche.Orientation, CreatingPlayerID, BeamToX, BeamToY)
        
        --kill the Job
        return true
        
    end
    
end


---------------------------------------------------------------------------
-- Sabattas deliver quests
---------------------------------------------------------------------------


function SetupSabattasQuests()

    --take data from the players quests
    local GoldAmountToDeliver       = deliverGoldQuest.Objectives[1].Data[2]
    local ClothesAmountToDeliver    = deliverClothesQuest.Objectives[1].Data[2]
    local FishAmountToDeliver       = deliverFishQuest.Objectives[1].Data[2]
    local PartsAmountToDeliver      = deliverPartsQuest.Objectives[1].Data[2]

    
    SabattaDeliverGoldQuestID, SabattaDeliverGoldQuest = QuestTemplate:New("", GrandmaPlayerID, SabattaPlayerID, 
                                                        { { Objective.Deliver, Goods.G_Gold, GoldAmountToDeliver } }, 
                                                        { { Triggers.Time, 0 } },
                                                        0, nil, nil, OnSabattaDelivered)

    
    SabattaDeliverClothesQuestID,SabattaDeliverClothesQuest = QuestTemplate:New("", GrandmaPlayerID, SabattaPlayerID, 
                                                            { { Objective.Deliver, Goods.G_Clothes, ClothesAmountToDeliver } },
                                                            { { Triggers.Quest, SabattaDeliverGoldQuestID,0} },
                                                            0, nil, nil, OnSabattaDelivered)

    
    SabattaDeliverFishQuestID,SabattaDeliverFishQuest = QuestTemplate:New("", GrandmaPlayerID, SabattaPlayerID, 
                                                            { { Objective.Deliver, Goods.G_RawFish, FishAmountToDeliver } },
                                                            { { Triggers.Quest, SabattaDeliverClothesQuestID,0} },
                                                            0, nil, nil, OnSabattaDelivered)

    
    SabattaDeliverPartsQuestID,SabattaDeliverPartsQuest = QuestTemplate:New("", GrandmaPlayerID, SabattaPlayerID, 
                                                            { { Objective.Deliver, Goods.G_SiegeEnginePart, PartsAmountToDeliver } },
                                                            { { Triggers.Quest, SabattaDeliverFishQuestID,0} }, 
                                                            --{ { Triggers.Time, 0 } }, 
                                                            0, nil, nil, OnSabattaDelivered)

    SabattaDeliverQuest =  {}
    SabattaDeliverQuest[deliverGoldQuestID]    = SabattaDeliverGoldQuestID
    SabattaDeliverQuest[deliverClothesQuestID] = SabattaDeliverClothesQuestID
    SabattaDeliverQuest[deliverFishQuestID]    = SabattaDeliverFishQuestID
    SabattaDeliverQuest[deliverPartsQuestID]   = SabattaDeliverPartsQuestID
    
end


function OnSabattaDelivered(_Quest)
    
    --player has lost, if sabatta win the quest
    if _Quest.Result == QuestResult.Success then
    
        if _Quest.Index == SabattaDeliverGoldQuestID then
            if deliverGoldQuest.Result ~= QuestResult.Success then                
                deliverGoldQuest:Fail()
            end
        end
        
        if _Quest.Index == SabattaDeliverClothesQuestID then
            if deliverClothesQuest.Result ~= QuestResult.Success then
                deliverClothesQuest:Fail()
            end
        end
        
        if _Quest.Index == SabattaDeliverFishQuestID then
            if deliverFishQuest.Result ~= QuestResult.Success then
                deliverFishQuest:Fail()
            end
        end
        
        if _Quest.Index == SabattaDeliverPartsQuestID then
            if deliverPartsQuest.Result ~= QuestResult.Success then
                deliverPartsQuest:Fail()
            end                
        end
        
    end
    
end

---------------------------------------------------------------------------
-- Sabatta deliver tool
---------------------------------------------------------------------------

function SabattaStartDeliver(_goodType,_amount )

    local BuildingToSpawnCart = Logic.GetStoreHouse(SabattaPlayerID)
    local CartType = Entities.U_Marketer

    
    if Logic.GetGoodCategoryForGoodType(_goodType) == GoodCategories.GC_Gold then        
        BuildingToSpawnCart = Logic.GetHeadquarters(SabattaPlayerID)
        CartType = Entities.U_GoldCart
        
    elseif Logic.GetGoodCategoryForGoodType(_goodType) == GoodCategories.GC_Resource then
        CartType = Entities.U_ResourceMerchant
    
    end

    local Merchant = Logic.CreateEntityAtBuilding(CartType, BuildingToSpawnCart, 0, GrandmaPlayerID)
    Logic.HireMerchant(Merchant, GrandmaPlayerID, _goodType, _amount, SabattaPlayerID)
    
    return Merchant

end

---------------------------------------------------------------------------
-- SHIP
---------------------------------------------------------------------------


function StartShip()
    StartSimpleJob("StartShipAfterSomeSeconds")
end

function StartShipAfterSomeSeconds()

    if shipComeCounter == nil then
        shipComeCounter = 10 + Logic.GetRandom(5)
    end
    
    shipComeCounter = shipComeCounter - 1
    
    if shipComeCounter <  0 then
        
        local x, y = Logic.GetEntityPosition(Logic.GetEntityIDByName("Path0"))
    
        ship = Logic.CreateEntity(Entities.D_X_TradeShip, x, y, 0, GrandmaPlayerID)
        
        Path:new(ship, { "Path0", "Path1" } , false, false, OnShipArrival, nil, true)
        
        SendVoiceMessage(RedPrincePlayerID, "NPCTalk_RedPrinceSendsShip")
        
        return true
    end
    
end

function OnShipArrival()    
    StartSimpleJob("ShipLeave")
end

function ShipLeave()
    if shipLeaveCounter == nil then
        shipLeaveCounter = 60
    end
    shipLeaveCounter = shipLeaveCounter - 1
    if shipLeaveCounter < 0 then
        Path:new(ship, { "Path1", "Path0" } , false, false, OnShipReturn, nil, true)
        return true
    end
end

function OnShipReturn()
    Logic.DestroyEntity(ship)
    ship = nil
end

LastMountTime = 0
function AIProfile_Sabatta(self)
    
    --start captureing or claiming fish territory
    if (deliverFishQuest.State == QuestState.Active) and
       (Logic.IsEntityAlive(deliverFishQuest.Objectives[1].Data[3]) == false) then   -- check if we havnt sent already the raw fish
    
        local TerritoryOwner = Logic.GetTerritoryPlayerID(FishTerritory)
        
        if TerritoryOwner == 1 then
            
            if (self.m_Behavior["SabattaCapture"] == nil) then
            
                self.m_Behavior["SabattaCapture"] = self:GenerateBehaviour(AIBehavior_CaptureOutpost)
                
                self.m_Behavior["SabattaCapture"].m_MinNumberOfSwordsmen = 2  
                self.m_Behavior["SabattaCapture"].m_MaxNumberOfSwordsmen = 3  
                self.m_Behavior["SabattaCapture"].m_AliveNumberOfSwordsmen = 0  
                
                self.m_Behavior["SabattaCapture"].m_MinNumberOfBowmen = 2
                self.m_Behavior["SabattaCapture"].m_MaxNumberOfBowmen = 2
                self.m_Behavior["SabattaCapture"].m_AliveNumberOfBowmen = 0
                
                self.m_Behavior["SabattaCapture"].m_MinNumberOfCatapults = 0
                self.m_Behavior["SabattaCapture"].m_MaxNumberOfCatapults = 0
                self.m_Behavior["SabattaCapture"].m_FleeNumberOfCatapults = 0
                
                self.m_Behavior["SabattaCapture"].m_OutpostID = Logic.GetTerritoryAcquiringBuildingID(FishTerritory)
                                                                                                           
                if (self.m_Behavior["SabattaCapture"]:Start() == false) then
                    self.m_Behavior["SabattaCapture"] = nil
                else
                    SendVoiceMessage(SabattaPlayerID, "NPCTalk_IWillAttackYou")                    
                end
            end
        
        elseif TerritoryOwner == 0 then
        
            if (self.m_Behavior["SabattaClaim"] == nil) then
            
                self.m_Behavior["SabattaClaim"] = self:GenerateBehaviour(AIBehavior_KnightClaim)
                self.m_Behavior["SabattaClaim"].m_Territory = FishTerritory
                
                if (self.m_Behavior["SabattaClaim"]:Start() == false) then
                
                    self.m_Behavior["SabattaClaim"] = nil
                    
                else
                
                    AddResourcesToPlayer(Goods.G_Gold,2000, SabattaPlayerID)
                    AddResourcesToPlayer(Goods.G_Wood,10, SabattaPlayerID)
                    SendVoiceMessage(SabattaPlayerID, "NPCTalk_IWillClaimTheFishTerritory")                  
                    
                end
            
            end
        elseif (TerritoryOwner == self.m_PlayerID) then
        
        
            local OutpostID = Logic.GetTerritoryAcquiringBuildingID(FishTerritory)
            if Logic.GetBattalionOnBuilding(OutpostID) == 0 then
            
                if (LastMountTime + 60 < Logic.GetTime()) then
                
                    if (AICore.MountOutpost(self.m_PlayerID, OutpostID) == true) then
                    
                        LastMountTime = Logic.GetTime()
                    end
                    
                end                
            end        
        end
    else
    
        AICore.CancelAllAttacks(self.m_PlayerID)
    
    end
end


function AIBehavior_CaptureOutpost:FindTargetEntity()

   local OutPostID = Logic.GetTerritoryAcquiringBuildingID(FishTerritory)
   
   if (OutPostID == 0) then
        OutPostID = nil
   end
   
   return OutPostID
   
end


function Mission_Victory()

    local VictoryAmmaPos = Logic.GetEntityIDByName("VictoryAmmaPos")
    local x,y = Logic.GetEntityPosition(VictoryAmmaPos)
    local Orientation = Logic.GetEntityOrientation(VictoryAmmaPos)    
    local AmmaID = Logic.CreateEntityOnUnblockedLand(Entities.U_NPC_Amma_NE, x, y, Orientation-90, GrandmaPlayerID)
    AICore.HideEntityFromAI(GrandmaPlayerID, AmmaID, true)
    
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
    
    VictoryGenerateFestivalAtPlayer( GrandmaPlayerID, PossibleSettlerTypes )

end
