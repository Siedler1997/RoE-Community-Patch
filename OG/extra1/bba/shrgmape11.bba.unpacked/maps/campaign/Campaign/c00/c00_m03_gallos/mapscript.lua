KestralLeftMap = false
CurrentMapIsCampaignMap = true
discoverQuests = {}
KestralGoldTribute = 0
KestralStepGoldTribute = 100
RandalfingenTribute = 0
RandalfingenStepTribute = 300
RandalfingenTributePaid = false
MonsteinBuildingOrder = 2
TaxCollectionsFirstLaunch = true
----------------------------------------------------------------------------------------------------------------------
function Mission_InitPlayers()

    --AnSu TODO:
    -- After cloister quest, move Baron all 2 month to the harbor, so the player can capture him
    -- Make Destroy Randalfingen a loosing condition
    -- sending clothes not possible?
    --strong troops at the harbour!!
    -- pallisade near harbor

    --AnSu: Add Knight_Plunder, when available
    KestralPlayerID = SetupPlayer(2, "H_Knight_Plunder", "Kestrals Camp", "BanditsColor1")
    
    --AnSu: Add castlean here
    --enemy City
    RandalfingenPlayerID = SetupPlayer(3, "H_NPC_Castellan_SE", "Randalfingen", "CityColor3")    
    
    --other friendly city
    JanusbergPlayerID = SetupPlayer(4, "H_NPC_Castellan_ME", "Janusberg", "CityColor4")
    
    --Villages
    MonsteinPlayerID = SetupPlayer(5, "H_NPC_Villager01_ME", "Monstein", "VillageColor1")    
    RiedfurtPlayerID = SetupPlayer(6, "H_NPC_Villager01_ME", "Riedfurt", "VillageColor2")    
    
    --Cloister
    CloisterPlayerID = SetupPlayer(7, "H_NPC_Monk_ME", "Castanna Cloister", "VillageColor3")
    
    --Harbor
    HarborBayPlayerID = SetupPlayer(8, "H_NPC_Generic_Trader", "Randalfingen", "TravelingSalesmanColor")    
    
    -- set some resources for player 1
    AddResourcesToPlayer(Goods.G_Gold,200)
    AddResourcesToPlayer(Goods.G_Stone,25)
    AddResourcesToPlayer(Goods.G_Iron,10)
    AddResourcesToPlayer(Goods.G_Wood,40)
    AddResourcesToPlayer(Goods.G_Grain,12)
    AddResourcesToPlayer(Goods.G_Carcass,12)
    AddResourcesToPlayer(Goods.G_RawFish,12)
    
    --AnSu: For testing
    --AddResourcesToPlayer(Goods.G_Wool,20)
    

    -- set some resources for player 3 (Randalfingen)
    AddResourcesToPlayer(Goods.G_Gold,20,RandalfingenPlayerID)
    AddResourcesToPlayer(Goods.G_Wood,20,RandalfingenPlayerID)
	AddResourcesToPlayer(Goods.G_Stone,10,RandalfingenPlayerID)
	AddResourcesToPlayer(Goods.G_Iron,10,RandalfingenPlayerID)
	AddResourcesToPlayer(Goods.G_Carcass,50,RandalfingenPlayerID)
	AddResourcesToPlayer(Goods.G_RawFish,40,RandalfingenPlayerID)
	AddResourcesToPlayer(Goods.G_Herb,50,RandalfingenPlayerID)
	AddResourcesToPlayer(Goods.G_Grain,20,RandalfingenPlayerID)
    AddResourcesToPlayer(Goods.G_Honeycomb,10,RandalfingenPlayerID)
	AddResourcesToPlayer(Goods.G_Milk,10,RandalfingenPlayerID)
	AddResourcesToPlayer(Goods.G_Wool,20,RandalfingenPlayerID)
	
	-- set some resources for player 4 (Janusberg)
    AddResourcesToPlayer(Goods.G_Gold,20,JanusbergPlayerID)
    AddResourcesToPlayer(Goods.G_Wood,20,JanusbergPlayerID)
	AddResourcesToPlayer(Goods.G_Stone,10,JanusbergPlayerID)
	AddResourcesToPlayer(Goods.G_Iron,10,JanusbergPlayerID)
	AddResourcesToPlayer(Goods.G_Carcass,50,JanusbergPlayerID)
	AddResourcesToPlayer(Goods.G_RawFish,40,JanusbergPlayerID)
	AddResourcesToPlayer(Goods.G_Herb,50,JanusbergPlayerID)
	AddResourcesToPlayer(Goods.G_Grain,20,JanusbergPlayerID)
    AddResourcesToPlayer(Goods.G_Honeycomb,10,JanusbergPlayerID)
	AddResourcesToPlayer(Goods.G_Milk,10,JanusbergPlayerID)
	AddResourcesToPlayer(Goods.G_Wool,20,JanusbergPlayerID)
	
	-- set some resources for player 5 (Monstein Village)
    AddResourcesToPlayer(Goods.G_Gold,50,MonsteinPlayerID)
	AddResourcesToPlayer(Goods.G_RawFish,50,MonsteinPlayerID)
	AddResourcesToPlayer(Goods.G_Grain,50,MonsteinPlayerID)
    AddResourcesToPlayer(Goods.G_Carcass,50,MonsteinPlayerID)
	AddResourcesToPlayer(Goods.G_Milk,50,MonsteinPlayerID)

	-- set some resources for player 6 (Riedfurt Village)
    AddResourcesToPlayer(Goods.G_Gold,50,RiedfurtPlayerID)
	AddResourcesToPlayer(Goods.G_RawFish,50,RiedfurtPlayerID)
	AddResourcesToPlayer(Goods.G_Grain,50,RiedfurtPlayerID)
    AddResourcesToPlayer(Goods.G_Milk,50,RiedfurtPlayerID)
    AddResourcesToPlayer(Goods.G_Carcass,50,RiedfurtPlayerID)

    local TechologiesToLock = { Technologies.R_Castle_Upgrade_3,
                                Technologies.R_Cathedral_Upgrade_3,
                                Technologies.R_Storehouse_Upgrade_3,
                                Technologies.R_Thieves,
                                Technologies.R_Entertainment,
                                Technologies.R_Tavern,
                                Technologies.R_Medicine,
                                Technologies.R_Beekeeper,
                                Technologies.R_HerbGatherer,
                                Technologies.R_CattleFarm,
                                Technologies.R_Dairy,
                                Technologies.R_SheepFarm,
                                Technologies.R_Weaver
                               }

    LockFeaturesForPlayer( 1, TechologiesToLock)
    
    LockTitleForPlayer(1, KnightTitles.Earl)
    
    --AnSu: Use this to set a knight title from start (needs and right will be activated)    
    SetKnightTitle(RandalfingenPlayerID, KnightTitles.Earl)
    SetKnightTitle(JanusbergPlayerID, KnightTitles.Mayor)
    
    SetPlayerMoral(RandalfingenPlayerID, 1.2)


end
----------------------------------------------------------------------------------------------------------------------
function Mission_SetStartingMonth()

    Logic.SetMonthOffset(4)

end
----------------------------------------------------------------------------------------------------------------------
function Mission_InitMerchants()

	local traderId = Logic.GetStoreHouse(JanusbergPlayerID)
	AddOffer			(traderId,	 5,Goods.G_Stone)
	AddOffer			(traderId,	 5,Goods.G_Wood)
	AddOffer			(traderId,	10,Goods.G_Cow)
    AddOffer			(traderId,	10,Goods.G_Sheep)

	local traderId = Logic.GetStoreHouse(MonsteinPlayerID)
    AddOffer			(traderId,	 5,Goods.G_Sausage)
    AddOffer			(traderId,	10,Goods.G_Grain)
    AddOffer			(traderId,	10,Goods.G_Bread)
    AddOffer			(traderId,	 5,Goods.G_Sheep)

    local traderId = Logic.GetStoreHouse(RiedfurtPlayerID)
    AddOffer			(traderId,	 5,Goods.G_Stone)
    AddOffer			(traderId,	 5,Goods.G_Cow)
    

end
----------------------------------------------------------------------------------------------------------------------
function Mission_SetDiplomacy()
    
    SetDiplomacyState(1, KestralPlayerID, DiplomacyStates.Undecided)
    SetDiplomacyState(1, RandalfingenPlayerID, DiplomacyStates.Enemy)
    SetDiplomacyState(1, JanusbergPlayerID, DiplomacyStates.Undecided)
    SetDiplomacyState(1, MonsteinPlayerID, DiplomacyStates.Undecided)
    SetDiplomacyState(1, RiedfurtPlayerID, DiplomacyStates.Undecided)
    SetDiplomacyState(1, CloisterPlayerID, DiplomacyStates.Undecided)

    SetDiplomacyState(KestralPlayerID, RandalfingenPlayerID, DiplomacyStates.Enemy)
    SetDiplomacyState(KestralPlayerID, JanusbergPlayerID, DiplomacyStates.Undecided)
    SetDiplomacyState(KestralPlayerID, MonsteinPlayerID, DiplomacyStates.TradeContact)
    SetDiplomacyState(KestralPlayerID, RiedfurtPlayerID, DiplomacyStates.Undecided)
    SetDiplomacyState(KestralPlayerID, CloisterPlayerID, DiplomacyStates.Undecided)

    SetDiplomacyState(RandalfingenPlayerID, JanusbergPlayerID, DiplomacyStates.Enemy)
    SetDiplomacyState(RandalfingenPlayerID, MonsteinPlayerID, DiplomacyStates.Enemy)
    SetDiplomacyState(RandalfingenPlayerID, RiedfurtPlayerID, DiplomacyStates.Enemy)
    SetDiplomacyState(RandalfingenPlayerID, CloisterPlayerID, DiplomacyStates.Undecided)

    SetDiplomacyState(JanusbergPlayerID, MonsteinPlayerID, DiplomacyStates.TradeContact)
    SetDiplomacyState(JanusbergPlayerID, RiedfurtPlayerID, DiplomacyStates.TradeContact)
    SetDiplomacyState(JanusbergPlayerID, CloisterPlayerID, DiplomacyStates.TradeContact)


end

----------------------------------------------------------------------------------------------------------------------
function Mission_FirstMapAction()
    
    
    if g_OnGameStartPresentationMode == true then
        SetDiplomacyState(1, MonsteinPlayerID, DiplomacyStates.TradeContact)
        SetDiplomacyState(1, RiedfurtPlayerID, DiplomacyStates.TradeContact)        
        SetDiplomacyState(1, KestralPlayerID, DiplomacyStates.Enemy)
        
    else
        Mission_SetDiplomacy()
        Mission_SpawnUnits()
        Mission_SetupQuests()
        --  OnTaxCollectionStart()
        DoNotActivateOutlawScripForPlayer(KestralPlayerID)
        AIPlayer:new(KestralPlayerID,       AIProfile_Mercenaries)
        AICore.HideEntityFromAI(KestralPlayerID, Logic.GetKnightID(KestralPlayerID), true)

    end

    raidTarget = MonsteinPlayerID
    AIPlayer:new(RandalfingenPlayerID,  AIProfile_Randalfingen)
    AIPlayer:new(JanusbergPlayerID,     AIPlayerProfile_City)
    
    
    AIPlayer:new(MonsteinPlayerID, AIPlayerProfile_Village)
    AIPlayer:new(RiedfurtPlayerID, AIPlayerProfile_Village)
    
    AICore.SetNumericalFact(MonsteinPlayerID, "BPMX", 5)
    

end
----------------------------------------------------------------------------------------------------------------------
function Mission_SetupQuests()
    
    local kestralID = Logic.GetEntityIDByName("Plunder")


    discoverQuests[#discoverQuests+1] = QuestTemplate:New("HiddenQuest_VisitMonsteinBeforeJanusberg", MonsteinPlayerID, 1,
                { { Objective.Discover, 2, { MonsteinPlayerID } } },
                { { Triggers.Time, 0 } },
                0,nil, nil, nil, nil, false, true)

    discoverQuests[#discoverQuests+1] = QuestTemplate:New("HiddenQuest_VisitRiedfurtBeforeJanusberg", RiedfurtPlayerID, 1,
                { { Objective.Discover, 2, { RiedfurtPlayerID } } },
                { { Triggers.Time, 0 } },
                0,nil, nil, nil, nil, false, true)

    discoverQuests[#discoverQuests+1] = QuestTemplate:New("HiddenQuest_VisitCloisterBeforeJanusberg", CloisterPlayerID, 1,
                { { Objective.Discover, 2, { CloisterPlayerID } } },
                { { Triggers.Time, 0 } },
                0, nil, nil, nil, nil, false, true)

    discoverQuests[#discoverQuests+1] = QuestTemplate:New("HiddenQuest_VisitJanusbergBeforeMayor", JanusbergPlayerID, 1,
                { { Objective.Discover, 2, { JanusbergPlayerID } } },
                { { Triggers.Time, 0 } },
                0, nil, nil, nil, nil, false, true)


    visitKestralID = QuestTemplate:New("HiddenQuest_VisitKestral", KestralPlayerID, 1,
                    { { Objective.Discover, 2, { KestralPlayerID } } },
                    { { Triggers.Time, 0 } },
                    0, { { Reward.Diplomacy, 0, DiplomacyStates.EstablishedContact, 1 } }, nil, OnKestralFound, nil, false, true)

    becomeMayorID = QuestTemplate:New("Quest_BecomeMayor", 1, 1,
                    { { Objective.KnightTitle, KnightTitles.Mayor } },
                    { { Triggers.Time, 0 } },
                    0, 
                    { { Reward.PrestigePoints, 200 } }, 
                    nil, OnBecameMayor)

    visitJanusbergID = QuestTemplate:New("Quest_VisitJanusberg", 1, 1,
                    { { Objective.Discover, 2, { JanusbergPlayerID } } },
                    { { Triggers.Quest, becomeMayorID, QuestResult.Success } },
                    0, 
                    { { Reward.Diplomacy, JanusbergPlayerID, DiplomacyStates.TradeContact, 1 } }, 
                    nil, OnJanusbergFound, nil, true, true)

----------------------------------------------------------------------------------------------------------------------------  
-- Monstein Quest Line -----------------------------------------------------------------------------------------------------
----------------------------------------------------------------------------------------------------------------------------  

    gotomonsteinID1 = QuestTemplate:New("Quest_GoToMonsteinStorehouse", JanusbergPlayerID, 1,
                    { { Objective.Distance, Logic.GetKnightID(1), Logic.GetMarketplace(MonsteinPlayerID) } },
                    { { Triggers.Quest, visitJanusbergID, QuestResult.Success } },
                    0, 
                    { { Reward.Diplomacy, MonsteinPlayerID, DiplomacyStates.EstablishedContact, 1 } }, 
                    nil, nil, nil, true, false)

    gotomonsteinID = QuestTemplate:New("Quest_GoToMonsteinStorehouse", MonsteinPlayerID, 1,
                    { { Objective.Dummy } },
                    { { Triggers.Quest, gotomonsteinID1, QuestResult.Success } },
                    0, { { Reward.Diplomacy, MonsteinPlayerID, DiplomacyStates.TradeContact, 1 } }, nil, nil, nil, false, true)


    buySheepsID = QuestTemplate:New("Quest_BuySheeps", MonsteinPlayerID, 1,
                    { { Objective.Custom, Custom_BuyMonsteinSheeps } },
                    { { Triggers.Quest, gotomonsteinID, QuestResult.Success } },
                    0, {{ Reward.PrestigePoints, 200 }}, nil, OnSheepsBought)

    buildFarmID = QuestTemplate:New("Quest_BuildSheepFarm", 1, 1,
                    { { Objective.Create, Entities.B_SheepFarm, 1 } },
                    { { Triggers.Quest, buySheepsID, QuestResult.Success } },
                    0, {{ Reward.PrestigePoints, 200 }}
                    )

    QuestTemplate:New("Quest_PlaceSheepPasture", 1, 1,
        { { Objective.Create, Entities.B_SheepPasture, 1 } },
        { { Triggers.Quest, buildFarmID, QuestResult.Success } },
        0, {{ Reward.PrestigePoints, 200 }} ,nil,OnSheepQuestEnded)

    -- security
    QuestTemplate:New("Quest_ProtectMonstein", 1, 1,
        {{Objective.Protect, { Logic.GetStoreHouse(MonsteinPlayerID) } }},
        {{Triggers.Time,0}},
        0, 
        nil, 
        {{Reprisal.Defeat}}, nil, nil, false, false)

----------------------------------------------------------------------------------------------------------------------------  
-- Cloister Quest Line -----------------------------------------------------------------------------------------------------  
----------------------------------------------------------------------------------------------------------------------------  

    gotocloisterID1 = QuestTemplate:New("Quest_GoToCloister", JanusbergPlayerID, 1,
                        { { Objective.Distance, Logic.GetKnightID(1), Logic.GetMarketplace(CloisterPlayerID) } },
                        { { Triggers.Quest, visitJanusbergID, QuestResult.Success } },
                        0, 
                        { { Reward.Diplomacy, CloisterPlayerID, DiplomacyStates.EstablishedContact, 1 } },
                        nil, nil, nil, true, false)

    gotocloisterID = QuestTemplate:New("Quest_GoToCloister", CloisterPlayerID, 1,
                        { { Objective.Dummy } },
                        { { Triggers.Quest, gotocloisterID1, QuestResult.Success } },
                        0, { { Reward.Diplomacy, CloisterPlayerID, DiplomacyStates.TradeContact, 1 } }, nil, nil, nil, false, true)


    deliverSoapID = QuestTemplate:New("Quest_DeliverSoapToCloister", CloisterPlayerID, 1,
        { { Objective.Deliver, Goods.G_Broom, 9 } },
        { { Triggers.Quest, gotocloisterID, QuestResult.Success } },
        0, {{ Reward.PrestigePoints, 1600 }} , nil, OnSoapDeliveredToCloister)

----------------------------------------------------------------------------------------------------------------------------  
-- Riedfurt Quest Line -----------------------------------------------------------------------------------------------------  
---------------------------------------------------------------------------------------------------------------------------- 

    gotoriedfurtID1 = QuestTemplate:New("Quest_GoToRiedfurtStorehouse", JanusbergPlayerID, 1,
        { { Objective.Distance, Logic.GetKnightID(1), Logic.GetMarketplace(RiedfurtPlayerID) } },
        { { Triggers.Quest, visitJanusbergID, QuestResult.Success } },
        0, 
        { { Reward.Diplomacy, RiedfurtPlayerID, DiplomacyStates.EstablishedContact, 1 } },
        nil, nil, nil, true, false)

    gotoriedfurtID = QuestTemplate:New("Quest_GoToRiedfurtStorehouse", RiedfurtPlayerID, 1,
        { { Objective.Dummy } },
        { { Triggers.Quest, gotoriedfurtID1, QuestResult.Success } },
        0, { { Reward.Diplomacy, RiedfurtPlayerID, DiplomacyStates.TradeContact, 1 } }, nil, nil, nil, false, true)

    producebowmenID = QuestTemplate:New("Quest_ProduceBowmen", RiedfurtPlayerID, 1,
        { { Objective.Create, Entities.U_MilitaryBow, 1 } },
        { { Triggers.Quest, gotoriedfurtID, QuestResult.Success } },
        0, { { Reward.PrestigePoints, 800 } }
        )

    sendbowmenID = QuestTemplate:New("Quest_SendBowmen", RiedfurtPlayerID, 1,
        { { Objective.Create, Entities.U_MilitaryBow, 1, 5 } },
        { { Triggers.Quest, producebowmenID, QuestResult.Success } },
        0, { { Reward.PrestigePoints, 200 } }, nil, OnBowmenSentToRiedfurt)

    deliverSwordsID = QuestTemplate:New("Quest_DeliverSwords", RiedfurtPlayerID, 1,
        { { Objective.Deliver, Goods.G_PoorSword, 9 } },
        { { Triggers.Quest, sendbowmenID, QuestResult.Success } },
        0, { { Reward.PrestigePoints, 1400 } }, nil, OnSwordsDeliveredToRiedfurt)

----------------------------------------------------------------------------------------------------------------------------  
-- Oppressors Taxes Quest Line ---------------------------------------------------------------------------------------------  
---------------------------------------------------------------------------------------------------------------------------- 

    QuestTemplate:New("", RandalfingenPlayerID, 1,
        { { Objective.Dummy } },
        { { Triggers.Quest, deliverSwordsID, QuestResult.Success }, { Triggers.Quest, deliverSoapID, QuestResult.Success } },
        0, nil, nil, OnTaxCollectionStart, nil, false, false)

--    OnTaxCollectionStart()
--    QuestTemplate:New("", RandalfingenPlayerID, 1,
--        { { Objective.Dummy } },
--        { { Triggers.Time, 0 } },
--        0, nil, nil, OnTaxCollectionStart, nil, false, false)

end

----------------------------------------------------------------------------------------------------------------------------  
-- Riedfurt Quest Line -----------------------------------------------------------------------------------------------------  
---------------------------------------------------------------------------------------------------------------------------- 

function BringBackBattalion()
    BringBackBattalion_CountDown = BringBackBattalion_CountDown + 1
    if BringBackBattalion_CountDown > 5 * 2 then
        SendVoiceMessage(RiedfurtPlayerID, "NPCTalk_MercsAreReady")
        local x, y = Logic.GetBuildingApproachPosition(RiedfurtBarracks)
        local leaderID = Logic.CreateBattalionOnUnblockedLand(Entities.U_MilitaryBow, x, y, 0, 1)
        local dx, dy = Logic.GetBuildingApproachPosition(Logic.GetMarketplace(1))
        Logic.MoveSettler(leaderID, dx, dy)
        return true
    end
end

function OnKestralFound()
    Logic.ExecuteInLuaLocalState("OnKestralFound()")
end

function OnBowmenSentToRiedfurt()
    AddMercenaryOffer(Logic.GetStoreHouse(RiedfurtPlayerID), 6, Entities.U_MilitaryBandit_Ranged_ME)
    RiedfurtBattalion = GetBowmenInRiedfurt()
    StartSimpleJob("SendBattalionToBarracks")
end

function GetBowmenInRiedfurt()
    -- get the list of bowmen on Riedfurt territory
    local leaders = GetPlayerEntities(1, Entities.U_MilitaryLeader)
    for i=1, #leaders do
        if Logic.LeaderGetSoldiersType(leaders[i]) == Entities.U_MilitaryBow then
            local x, y = Logic.GetEntityPosition(leaders[i])
            local territory = Logic.GetTerritoryAtPosition(x, y)
            if territory == 5 then
                return leaders[i]
            end
        end
    end
    -- oh noes!!!:(
end

function SendBattalionToBarracks()
    RiedfurtBarracks = Logic.GetEntityIDByName("riedfurt_barracks")
    if Logic.GetDistanceBetweenEntities(RiedfurtBarracks, RiedfurtBattalion) > 1000 then
        local x, y = Logic.GetBuildingApproachPosition(RiedfurtBarracks)
        Logic.MoveSettler(RiedfurtBattalion, x, y)
    else
        Logic.DestroyGroupByLeader(RiedfurtBattalion)
        StartSimpleJob("BringBackBattalion")
        BringBackBattalion_CountDown = 0
        return true
    end
end

function OnSwordsDeliveredToRiedfurt()
    local ironMerchant = Logic.CreateEntityAtBuilding(Entities.U_ResourceMerchant, Logic.GetStoreHouse(RiedfurtPlayerID), 0, 1)
    Logic.HireMerchant(ironMerchant, 1, Goods.G_Iron, 20, RiedfurtPlayerID)
--    Logic.StartTradeGoodGathering(RiedfurtPlayerID, 1, Goods.G_Iron, 20, 0)
--    AddOffer(Logic.GetStoreHouse(RiedfurtPlayerID), 5, Goods.G_Iron)
end


----------------------------------------------------------------------------------------------------------------------------  
-- Monstein Quest Line -----------------------------------------------------------------------------------------------------
----------------------------------------------------------------------------------------------------------------------------  

function OnSheepsBought()
    UnLockFeaturesForPlayer( 1, { Technologies.R_SheepFarm, Technologies.R_Weaver })
end

function OnSheepQuestEnded()
     UnLockFeaturesForPlayer( 1, { Technologies.R_SheepFarm,
                                   Technologies.R_CattleFarm,
                                   Technologies.R_Dairy })
end

function ArePlayersSeparated(playerid1, playerid2)
    local x, y = Logic.GetBuildingApproachPosition(Logic.GetStoreHouse(playerid1))
    local u, v = Logic.GetBuildingApproachPosition(Logic.GetStoreHouse(playerid2) )
    local sector1 = Logic.DEBUG_GetSectorAtPosition(x, y)
    local sector2 = Logic.DEBUG_GetSectorAtPosition(u, v)
    return sector1 ~= sector2
end

function Custom_CheckMonsteinPalissadeBuilt()
    if ArePlayersSeparated(MonsteinPlayerID, RiedfurtPlayerID) then
        return true
    end

    return nil
end

MonsteinPalissadeBuilt = false
function OnMonsteinPalissadeBuilt(quest)
    if quest.Result == QuestResult.Success and MonsteinPalissadeBuilt ~= true then
        MonsteinPalissadeBuilt = true
        Quests[protectMonsteinDisplayedID]:Success()
        SendVoiceMessage(RandalfingenPlayerID, "NPCTalk_RandalfingenAttacks")
        --StartTimer stuff
        HideMissionTimer()
        -- now using quest as timer callback
        protectPlayerCityID = QuestTemplate:New("Quest_Protect_City", 1, 1,
            {{Objective.Protect, {Logic.GetStoreHouse(1)}}},
            {{Triggers.Time, 0}}, 0, nil, nil, nil, nil, true)
    
        QuestTemplate:New("", RandalfingenPlayerID, RandalfingenPlayerID,
            {{Objective.Protect, {Logic.GetStoreHouse(1)}}},
            {{Triggers.Time, 0}}, 1*60, nil, nil, OnFirstAttackStart, nil, false)
    end
end

function GameCallback_AIWallBuildingOrder(playerID)
    if playerID == MonsteinPlayerID then
        return 15
    end
end

function OnWoodDelivered()
    AICore.SetNumericalFact(MonsteinPlayerID, "BPMX", 20)
    QuestTemplate:New("", MonsteinPlayerID, MonsteinPlayerID,
        {{Objective.Custom, Custom_CheckMonsteinPalissadeBuilt}},
        {{Triggers.Time, 0}},
        0, nil, nil, OnMonsteinPalissadeBuilt,nil,false)
end

previousNumberOfSheeps = 0
function Custom_BuyMonsteinSheeps()
    local sheeps = GetPlayerEntities(1, Entities.A_X_Sheep01)
    if #sheeps == previousNumberOfSheeps+5 then
        return true
    end
    previousNumberOfSheeps = #sheeps
    return nil
end

----------------------------------------------------------------------------------------------------------------------------  
-- Cloister Quest Line -----------------------------------------------------------------------------------------------------  
----------------------------------------------------------------------------------------------------------------------------  

function OnSoapDeliveredToCloister()
    -- send a cart with 18 chaussée aux moines G_Cheese to player from cloister
--    Logic.StartTradeGoodGathering(CloisterPlayerID, 1, Goods.G_Cheese, 18, 0)
    local cheeseMerchant = Logic.CreateEntityAtBuilding(Entities.U_Marketer, Logic.GetStoreHouse(CloisterPlayerID), 0, 1)
    Logic.HireMerchant(cheeseMerchant, 1, Goods.G_Cheese, 18, CloisterPlayerID)
end

----------------------------------------------------------------------------------------------------------------------------  
-- Other Quests ------------------------------------------------------------------------------------------------------------  
----------------------------------------------------------------------------------------------------------------------------  

function SpawnGoldCart()
    local x, y = Logic.GetEntityPosition(Logic.GetEntityIDByName("GoldCartPath0"))
    local BaronGoldCart = Logic.CreateEntityOnUnblockedLand(Entities.U_GoldCart_Mission, x, y, 0, RandalfingenPlayerID)
    --ToDo: comment this in, when catpuring a cart, that is controlled by script is working
    local Leader = Logic.CreateBattalionOnUnblockedLand(Entities.U_MilitaryBow, x, y, 0, RandalfingenPlayerID, 9)    
    Logic.GroupGuard(Leader, BaronGoldCart)

    AICore.HideEntityFromAI(RandalfingenPlayerID, BaronGoldCart, true)
    AICore.HideEntityFromAI(RandalfingenPlayerID, Leader, true)

    Path:new(BaronGoldCart, { "GoldCartPath0", "GoldCartPath1" } , true)
end

function OnJanusbergFound()
    for i=1, #discoverQuests do
        Quests[discoverQuests[i]]:Interrupt()
    end
end

function OnBecameMayor()
    -- send 3 carts. eh ?
end

----------------------------------------------------------------------------------------------------------------------------  
-- Kestral Quest Line ------------------------------------------------------------------------------------------------------  
---------------------------------------------------------------------------------------------------------------------------- 

function OnKestralLeavesMap()
    KestralLeftMap = true
end

function CheckKestralOutOfMap()
    if Logic.GetDistanceBetweenEntities(Logic.GetKnightID(KestralPlayerID), Logic.GetEntityIDByName("Kestral_Depart_Return_Pos")) < 1500 then
        Logic.DestroyEntity(Logic.GetKnightID(KestralPlayerID))
        return true
    end
end


function OnKestralComeback()
    local x, y = Logic.GetEntityPosition(Logic.GetEntityIDByName("Kestral_Depart_Return_Pos"))
    Logic.CreateEntityOnUnblockedLand(Entities.U_KnightPlunder, x, y, 0, KestralPlayerID)
    Logic.CreateBattalionOnUnblockedLand(Entities.U_MilitaryBow, x, y, 0, KestralPlayerID)
    Logic.CreateBattalionOnUnblockedLand(Entities.U_MilitaryBow, x, y, 0, KestralPlayerID)
    Logic.CreateBattalionOnUnblockedLand(Entities.U_MilitarySword, x, y, 0, KestralPlayerID)
    Logic.CreateBattalionOnUnblockedLand(Entities.U_MilitarySword, x, y, 0, KestralPlayerID)
end

function OnKestralMovingOut()
    Logic.DestroyEntity(Logic.GetKnightID(KestralPlayerID))
end

function OnKestralPaid(quest)
    if quest.Result == QuestResult.Success then
        KestralDefendsVillages = true
    else
        OnKestralLeavesMap()
        --Path:new(Logic.GetKnightID(KestralPlayerID), { Logic.GetStoreHouse(KestralPlayerID), "Kestral_Depart_Return_Pos" }, false, false, OnKestralMovingOut)
    end
end


----------------------------------------------------------------------------------------------------------------------------  
-- Military functions ------------------------------------------------------------------------------------------------------  
---------------------------------------------------------------------------------------------------------------------------- 

function Mission_SpawnUnits()
    SpawnMilitary(Entities.U_CatapultCart, 3, 2)
    SpawnMilitary(Entities.U_CatapultCart, 4, 2)

    SpawnMilitary(Entities.U_MilitarySword, 3, 2)
    SpawnMilitary(Entities.U_MilitaryBow, 3, 2)
    SpawnMilitary(Entities.U_MilitarySword, 4, 2)
    SpawnMilitary(Entities.U_MilitaryBow, 4, 2)
end

function SpawnMilitary(entityType, playerID, number)
    local n = 4
    if number ~= nil then
        n = number
    end

    local marketPlace = Logic.GetMarketplace(playerID)
    local x, y = Logic.GetEntityPosition(marketPlace)
    x = x + 1000

    for i=1, n do
        if entityType == Entities.U_CatapultCart then
            Logic.CreateEntityOnUnblockedLand(Entities.U_CatapultCart, x, y, 0, playerID)
        else
            Logic.CreateBattalionOnUnblockedLand(entityType, x, y, 0, playerID, 0)
        end
    end
end

----------------------------------------------------------------------------------------------------------------------------  
-- Tax Collections ---------------------------------------------------------------------------------------------------------
---------------------------------------------------------------------------------------------------------------------------- 

function OnStartTaxRaid()
    if payTributeID ~= nil and Quests[payTributeID].State == QuestState.Active then
       Quests[payTributeID]:Fail()
       payTributeID = nil
    end

    if not RandalfingenTributePaid then
        -- order ai to move raid the settlement
        -- spawn tax collectors and launch a job to get those taxes
        local monsteinBuildings = { Logic.GetPlayerEntitiesInCategory(MonsteinPlayerID, EntityCategories.CityBuilding) }
    
        -- TODO: implement a timer so that they dont spawn all at the same time (fugly)
        local x, y = Logic.GetBuildingApproachPosition(Logic.GetHeadquarters(RandalfingenPlayerID))
        for i=1, #monsteinBuildings do
            local taxCollectorData = {}
            taxCollectorData.Collector = Logic.CreateEntityOnUnblockedLand(Entities.U_TaxCollector, x, y, 0, RandalfingenPlayerID)
            taxCollectorData.Destination = monsteinBuildings[i]
            local dx, dy = Logic.GetBuildingApproachPosition(monsteinBuildings[i])
            taxCollectorData.x = dx
            taxCollectorData.y = dy
    
            Path:new(taxCollectorData.Collector, { Logic.GetHeadquarters(RandalfingenPlayerID), monsteinBuildings[i] }, false, true, OnTaxCollectorArrived, OnTaxCollectorReturned, false, nil, taxCollectorData)
        end

        QueueRandalfingenAttack(MonsteinPlayerID, AIBehavior_RaidSettlement, true)
    else
        RandalfingenTributePaid = true
    end
end

function OnTaxCollectorArrived(pathObject)
    if not Logic.IsEntityDestroyed(pathObject.TagData.Destination) then
        Logic.RemoveGoodFromStock(pathObject.TagData.Destination, Goods.G_Gold, 5)
        Logic.AddGoodToStock(pathObject.TagData.Collector, Goods.G_Gold, 5, true)
    end
end

function OnTaxCollectorReturn(pathObject)
    Logic.DestroyEntity(pathObject.TagData.Collector)
end

function OnRandalfingenTributePaid(quest)
    local merchantCart = Logic.CreateEntityAtBuilding(Entities.U_GoldCart, Logic.GetStoreHouse(MonsteinPlayerID), 0, RandalfingenPlayerID)
    Logic.HireMerchant(merchantCart, RandalfingenPlayerID, Goods.G_Gold, RandalfingenTribute, MonsteinPlayerID)
    if quest.Result == QuestResult.Success then
        RandalfingenTributePaid = true
    end
end

TimeUntilTaxCollectionStarts = 6*60
function UpdateTaxCollectionTimer()
    ShowMissionTimer(TimeBeforeTaxCollection)
    TimeBeforeTaxCollection = TimeBeforeTaxCollection - 1
end

function OnTaxCollectionStart()
    if RandalfingenTributePaid ~= false then
        RandalfingenTributePaid = false
    end

    SendVoiceMessage(RandalfingenPlayerID, "HiddenQuest_StartTaxCollection")
    taxCollectionID = QuestTemplate:New("HiddenQuest_StartTaxCollection", RandalfingenPlayerID, 1,
        { { Objective.Protect, { Logic.GetStoreHouse(1) } } }, -- dummy objective to call the end callback again in 5 minutes
        { { Triggers.Time, 0 } },
        TimeUntilTaxCollectionStarts, nil, nil, OnStartTaxRaid, UpdateTaxCollectionTimer, false, false)
    TimeBeforeTaxCollection = TimeUntilTaxCollectionStarts

    if TaxCollectionsFirstLaunch == true then
        -- those are only going to be launched on the first time
        protectMonsteinID = QuestTemplate:New("Quest_ProtectMonstein", 1, 1,
            {{Objective.Protect, { Logic.GetStoreHouse(MonsteinPlayerID) } }},
            {{Triggers.Time,0}},
            0, nil, {{Reprisal.Defeat}}, nil, nil, false)

        protectMonsteinDisplayedID = QuestTemplate:New("Quest_ProtectMonstein", 1, 1,
            {{Objective.Protect, { Logic.GetStoreHouse(MonsteinPlayerID) } }},
            {{Triggers.Time,0}},
            0, {{Reward.PrestigePoints, 1000}}, {{Reprisal.Defeat}}, nil, nil, true)

        deliverWoodToMonsteinID = QuestTemplate:New("Quest_DeliverWoodToMonstein", MonsteinPlayerID, 1,
            { { Objective.Deliver, Goods.G_Wood, 80 } },
            { { Triggers.Quest, protectMonsteinID, QuestResult.Success } },
            0, { { Reward.PrestigePoints, 800 } }, nil, OnWoodDelivered)

        TaxCollectionsFirstLaunch = false

    else
        RandalfingenTribute = RandalfingenTribute + RandalfingenStepTribute

        payTributeID = QuestTemplate:New("Quest_PayTributeToRandalfingen", MonsteinPlayerID, 1,
            { { Objective.Deliver, Goods.G_Gold, RandalfingenTribute } },
            { { Triggers.Time, 0 } },
            4 * 60, { { Reward.PrestigePoints, 800 } }, nil, OnRandalfingenTributePaid)

   end

    if not KestralLeftMap then
        KestralGoldTribute = KestralStepGoldTribute + KestralGoldTribute

        payKestralID = QuestTemplate:New("Quest_PayTributeToKestral", KestralPlayerID, 1,
            { { Objective.Deliver, Goods.G_Gold, KestralGoldTribute } },
            { { Triggers.Time, 0 } },
    --        { { Triggers.Quest, visitKestralID, QuestResult.Success }, { Triggers.Quest, sendbowmenID, QuestResult.Success }, { Triggers.Quest, deliverSoapID, QuestResult.Success } },
            4 * 60, { { Reward.PrestigePoints, 800 } }, nil, OnKestralPaid, nil)
    end

    
    StartSimpleJob("RelaunchTaxCollection")
end

function RelaunchTaxCollection()
    -- final map phase, stop the taxes
    if MonsteinPalissadeBuilt then
        return true
    end

    if RelaunchTaxCollectionCounter == nil then
        RelaunchTaxCollectionCounter = 0
    end

    RelaunchTaxCollectionCounter= RelaunchTaxCollectionCounter + 1
    if RelaunchTaxCollectionCounter > 8*60 then
        RelaunchTaxCollectionCounter = nil
        OnTaxCollectionStart()
        return true
    end
end

----------------------------------------------------------------------------------------------------------------------------  
-- Randalfingen Profile ----------------------------------------------------------------------------------------------------
---------------------------------------------------------------------------------------------------------------------------- 

function OnFirstAttackStart()
    if ArePlayersSeparated(1, RiedfurtPlayerID) then            -- since riedfurt has no walls..
        SendVoiceMessage(RandalfingenPlayerID, "NPCTalk_WithWall")
    else
        SendVoiceMessage(RandalfingenPlayerID, "NPCTalk_NoWall")
        AIScript_SpawnAndCreateArmy(RandalfingenPlayerID, Logic.GetEntityIDByName("RandalfingenSpawn"), 4, 4, 0, 0, 1, 1)
        RandalfingenMaxSwordsman = 4
        RandalfingenMaxBowman = 4
        QueueRandalfingenAttack(1, AIBehavior_AttackCity, true)
    end
    
    QuestTemplate:New("", RandalfingenPlayerID, RandalfingenPlayerID,
        {{Objective.Protect, {Logic.GetStoreHouse(1)}}},
        {{Triggers.Time, 0}}, 6*60, nil, nil, OnSecondAttackStart, nil, false)
end

function OnSecondAttackStart()
    SecondAttackStarted = true
    if ArePlayersSeparated(1, RiedfurtPlayerID) then            -- since riedfurt has no walls..
        SendVoiceMessage(RandalfingenPlayerID, "NPCTalk_SecondWithWall")
    else
        SendVoiceMessage(RandalfingenPlayerID, "NPCTalk_SecondNoWall")
    end
    RandalfingenIsAttackingPlayer = true -- triggers kestral

    AIScript_SpawnAndCreateArmy(RandalfingenPlayerID, Logic.GetEntityIDByName("RandalfingenSpawn"), 5, 5, 0, 0, 2, 1)
    RandalfingenMaxSwordsman = 5
    RandalfingenMaxBowman = 5
    QueueRandalfingenAttack(1, AIBehavior_AttackCity, true, 2)
end

RandalfingenQueue = {}
function QueueRandalfingenAttack(targetID, aiBehavior, increaseTroups, batteringRams)
    local newAttack = {}
    newAttack.Target = targetID
    newAttack.Behavior = aiBehavior
    newAttack.IncreaseTroups = increaseTroups
    if batteringRams == nil then
        newAttack.BatteringRams = 0
    else
        newAttack.BatteringRams = batteringRams
    end
    RandalfingenQueue[#RandalfingenQueue+1] = newAttack
end

function OnRandalfingenAttackFinished()
    if Quests[protectMonsteinID].State == QuestState.Active then
        Quests[protectMonsteinID]:Success()
    end

    if SecondAttackStarted == true then
        SpawnGoldCart()
    
        captureCastellanID = QuestTemplate:New("Quest_CaptureRandalfingenCastellan", KestralPlayerID, 1,
            {{Objective.Capture, 2, Entities.U_GoldCart_Mission, 1, RandalfingenPlayerID }},
            {{Triggers.Time, 0}},
            0, { { Reward.PrestigePoints, 5000 }, {Reward.CampaignMapFinished }})

        --END DIAOLG. SABATTA ESCAPES AND THORDAL JOINS
        GenerateVictoryDialog({{RandalfingenPlayerID,"Victory_BaronCaught" },
                                {JanusbergPlayerID,"Victory_JanusbergFreedom" },
                                {KestralPlayerID,"Victory_Kestral" }}, captureCastellanID)

        SecondAttackStarted = false
    end
end

function AI_SpawnNecessaryUnits(playerid, bowmen, swordmen)
    local x, y = Logic.GetBuildingApproachPosition(Logic.GetStoreHouse(playerid))

    local numbowmen = Logic.GetNumberOfEntitiesOfTypeOfPlayer(playerid, Entities.U_MilitaryBow)
    if numbowmen <= bowmen then
        local diff = bowmen - numbowmen + 1
        for i = 1, diff do
            Logic.CreateBattalionOnUnblockedLand(Entities.U_MilitaryBow, x, y, 0, playerid)
        end
    end

    local numswordmen =  Logic.GetNumberOfEntitiesOfTypeOfPlayer(playerid, Entities.U_MilitarySword)
    if numswordmen <= swordmen then
        local diff = swordmen - numswordmen + 1
        for i = 1, diff do
            Logic.CreateBattalionOnUnblockedLand(Entities.U_MilitarySword, x, y, 0, playerid)
        end
    end
end
----------------------------------------------------------------------------------------------------------------------
function AIProfile_Randalfingen(self)
    
    if (self.m_FirstCall == nil) then        
        self.m_FirstCall = true;
        
        RandalfingenMinSwordsman = 0
        RandalfingenMaxSwordsman = 1
        
        RandalfingenMinBowman = 0
        RandalfingenMaxBowman = 1
    end


    if #RandalfingenQueue ~= 0 then
        if (self.m_Behavior["RandelfingenAttack"] == nil) then
            self.m_Behavior["RandelfingenAttack"] = self:GenerateBehaviour(RandalfingenQueue[1].Behavior);
            self.m_Behavior["RandelfingenAttack"].CB_AttackFinished = OnRandalfingenAttackFinished
            
            AI_SpawnNecessaryUnits(RandalfingenPlayerID, RandalfingenMaxBowman, RandalfingenMaxSwordsman)

            RandalfingenIsAttackingVillage = true
            raidTarget = RandalfingenQueue[1].Target
            
            self.m_Behavior["RandelfingenAttack"].m_TargetID = Logic.GetStoreHouse(RandalfingenQueue[1].Target)
            self.m_Behavior["RandelfingenAttack"].m_Radius = 40 * 100;

            self.m_Behavior["RandelfingenAttack"].m_MinNumberOfSwordsmen = RandalfingenMinSwordsman;
            self.m_Behavior["RandelfingenAttack"].m_MaxNumberOfSwordsmen = RandalfingenMaxSwordsman;
            self.m_Behavior["RandelfingenAttack"].m_AliveNumberOfSwordsmen = 0;  

            self.m_Behavior["RandelfingenAttack"].m_MinNumberOfBowmen = RandalfingenMinBowman;
            self.m_Behavior["RandelfingenAttack"].m_MaxNumberOfBowmen = RandalfingenMaxBowman;
            self.m_Behavior["RandelfingenAttack"].m_AliveNumberOfBowmen = 0;  

            self.m_Behavior["RandelfingenAttack"].m_MinNumberOfCatapults = 0;
            self.m_Behavior["RandelfingenAttack"].m_MaxNumberOfCatapults = 0;
            self.m_Behavior["RandelfingenAttack"].m_FleeNumberOfCatapults = 0;    
            
            self.m_Behavior["RandelfingenAttack"].m_MinNumberOfRams= 0;
            self.m_Behavior["RandelfingenAttack"].m_MaxNumberOfRams = RandalfingenQueue[1].BatteringRams;
            self.m_Behavior["RandelfingenAttack"].m_FleeNumberOfRams = 0;  
            
            self.m_Behavior["RandelfingenAttack"].m_MinNumberOfTowers= 0;
            self.m_Behavior["RandelfingenAttack"].m_MaxNumberOfTowers = 0;
            self.m_Behavior["RandelfingenAttack"].m_FleeNumberOfTowers = 0;

            if (self.m_Behavior["RandelfingenAttack"]:Start() == false) then
                self.m_Behavior["RandelfingenAttack"] = nil;
                return
            end

            if RandalfingenMinSwordsman < 6 and RandalfingenQueue[1].IncreaseTroups then
                RandalfingenMinSwordsman = RandalfingenMinSwordsman + 1
                RandalfingenMaxSwordsman = RandalfingenMaxSwordsman + 1
                
                RandalfingenMinBowman = RandalfingenMinBowman + 1
                RandalfingenMaxBowman = RandalfingenMaxBowman + 1
            end

            table.remove(RandalfingenQueue, 1)
        end
    end
end


function RandalfingenFindTargetEntity()
    
    -- Attack Monstein
    raidTarget = MonsteinPlayerID
    
    --is mondstein is dead, attack riedfurt
    if Logic.IsEntityDestroyed(Logic.GetStoreHouse(MonsteinPlayerID)) then
        raidTarget = RiedfurtPlayerID
    end
    
    local Soldiers = Logic.GetCurrentSoldierCount(1)

    --Attack player, if he has some soldiers
    if Soldiers >= 9 * 4 then
        raidTarget = 1
        NextAttackTime = Logic.GetTime() + 60 * 20
    end
    
    return Logic.GetStoreHouse(raidTarget)
end

----------------------------------------------------------------------------------------------------------------------------  
-- Kestral AI Profile ------------------------------------------------------------------------------------------------------
----------------------------------------------------------------------------------------------------------------------------
 
MercenariesCounter = 0
function AIProfile_Mercenaries(self)

    MercenariesCounter = MercenariesCounter + 1

    if (MercenariesCounter <= 1) then
        return 0
    end   
     
    if (self.m_FirstCall == nil) then
    
        self.m_FirstCall = true;
        AIBehavior_ProtectArea.m_MinNumberOfSwordsmen = 0
        AIBehavior_ProtectArea.m_MinNumberOfBowmen = 0
        
    end

    if (self.m_Behavior["ProtectArea"] == nil) then

        if (RandalfingenIsAttackingVillage == true and KestralDefendsVillages == true) or (RandalfingenIsAttackingPlayer == true) then
            --start helping after some seconds

            if Logic.GetKnightID(KestralPlayerID) == 0 then
                OnKestralComeback()
            end

            RandalfingenIsAttackingVillage = nil
            RandalfingenIsAttackingPlayer = nil
            KestralDefendsVillages = nil
    
            self.m_Behavior["ProtectArea"] = self:GenerateBehaviour(AIBehavior_ProtectArea);
    
            self.m_Behavior["ProtectArea"].m_TargetID = Logic.GetStoreHouse(raidTarget);
            self.m_Behavior["ProtectArea"].m_ProtectionTime = 60*3;
            self.m_Behavior["ProtectArea"].m_Radius = 40 * 100;  
            
            self.m_Behavior["ProtectArea"].m_MinNumberOfSwordsmen = 0;  
            self.m_Behavior["ProtectArea"].m_MaxNumberOfSwordsmen = 6;  
            self.m_Behavior["ProtectArea"].m_AliveNumberOfSwordsmen = 0;  
            
            self.m_Behavior["ProtectArea"].m_MinNumberOfBowmen = 0;  
            self.m_Behavior["ProtectArea"].m_MaxNumberOfBowmen = 6;  
            self.m_Behavior["ProtectArea"].m_AliveNumberOfBowmen = 0;  
                        
            RaidSettlementStartTime = nil
            
            if (self.m_Behavior["ProtectArea"]:Start() == false) then
                self.m_Behavior["ProtectArea"] = nil;
            end
        end
    end
end



function Mission_Victory()

    local x, y = Logic.GetEntityPosition(Logic.GetEntityIDByName("PrisonCartPath0"))
    
    local PrisonCart = Logic.CreateEntityOnUnblockedLand(Entities.U_PrisonCart, x, y, 0, JanusbergPlayerID)    
    local Leader = Logic.CreateBattalionOnUnblockedLand(Entities.U_MilitaryBow, x, y, 0, JanusbergPlayerID, 6)    
    Logic.GroupGuard(Leader, PrisonCart)

    AICore.HideEntityFromAI(RandalfingenPlayerID, PrisonCart, true)
    AICore.HideEntityFromAI(RandalfingenPlayerID, Leader, true)
    
    Path:new(PrisonCart, { "PrisonCartPath0", "PrisonCartPath1" } , false)    
    Logic.SetEntityName(PrisonCart, "PrisonCart")

    local VictoryKnightPos = Logic.GetEntityIDByName("VictoryKnightPos")
    local x,y = Logic.GetEntityPosition(VictoryKnightPos)
    local Orientation = Logic.GetEntityOrientation(VictoryKnightPos)
    VictorySetEntityToPosition( Logic.GetKnightID(1), x, y, Orientation )


    local VictoryKestralPos = Logic.GetEntityIDByName("VictoryKestralPos")
    local x,y = Logic.GetEntityPosition(VictoryKestralPos)
    local Orientation = Logic.GetEntityOrientation(VictoryKestralPos)
    local KestralID = Logic.GetKnightID(KestralPlayerID)
    
    if KestralID ~= nil then
        VictorySetEntityToPosition( KestralID, x, y, Orientation )
    else
        local Plunder = Logic.CreateEntityOnUnblockedLand(Entities.U_KnightPlunder, x, y, Orientation-90, KestralPlayerID)
        AICore.HideEntityFromAI(KestralPlayerID, Plunder, true)
    end
    
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


    for k=1, 11 do
        local ScriptEntityName = "V" .. k
        local VictorySettlerPos = Logic.GetEntityIDByName(ScriptEntityName)
        local x,y = Logic.GetEntityPosition(VictorySettlerPos)        
        local SettlerType = PossibleSettlerTypes[1 + Logic.GetRandom(#PossibleSettlerTypes)]
        local SettlerID = Logic.CreateEntityOnUnblockedLand(SettlerType, x, y, Orientation-90, TournamentPlayerID) 
        Logic.SetTaskList(SettlerID, TaskLists.TL_WORKER_FESTIVAL_APPLAUD_SPEECH)
    end

    

end
