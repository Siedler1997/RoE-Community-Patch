CurrentMapIsCampaignMap = true
----------------------------------------------------------------------------------------------------------------------
function Mission_InitPlayers()

    TournamentPlayerID  = SetupPlayer(2,"H_NPC_Castellan_SE", "Tournament", "CP_OrangeColor")
   	
   	BanditsNorthPlayerID= SetupPlayer(3,"H_NPC_Mercenary_SE", "Bandits Sucea", "BanditsColor1")
    BanditsWestPlayerID = SetupPlayer(4,"H_NPC_Mercenary_SE","Bandits Horcanada", "CP_BlackColor")
    BanditsEastPlayerID = SetupPlayer(5,"H_NPC_Mercenary_SE","Bandits Dalaganza","BanditsColor3")
    
    CloisterPlayerID    = SetupPlayer(6,"H_NPC_Monk_SE","Santa Cenitza","CloisterColor1")
    
    TiosHarbourPlayerID = SetupPlayer(7,"H_NPC_Generic_Trader","Tios Harbour","TravelingSalesmanColor")
    
    FlexibleSpeakerPlayerID = SetupPlayer(8,"H_Knight_RedPrince","Red Prince","RedPrinceColor")
        
     

    -- set some resources for player 1
    AddResourcesToPlayer(Goods.G_Gold,250)
    AddResourcesToPlayer(Goods.G_Stone,25)
    AddResourcesToPlayer(Goods.G_Wood,50)
    AddResourcesToPlayer(Goods.G_Grain,10)
    AddResourcesToPlayer(Goods.G_Carcass,10)
    AddResourcesToPlayer(Goods.G_RawFish,10)
    AddResourcesToPlayer(Goods.G_Milk,10)

    -- to allow the ai to build stuff!
    --AddResourcesToPlayer(Goods.G_Gold,300, 2)
    --AddResourcesToPlayer(Goods.G_Stone,300, 2)
    --AddResourcesToPlayer(Goods.G_Wood,300, 2)

    -- set diplomacy states
	SetDiplomacyState(1, TournamentPlayerID, DiplomacyStates.TradeContact)	
	SetDiplomacyState(1, TiosHarbourPlayerID, DiplomacyStates.TradeContact)	
	SetDiplomacyState(1, CloisterPlayerID, DiplomacyStates.TradeContact)
	
    
	SetDiplomacyState(BanditsNorthPlayerID, 1, DiplomacyStates.Enemy)
	SetDiplomacyState(BanditsNorthPlayerID, CloisterPlayerID, DiplomacyStates.Enemy)
	SetDiplomacyState(BanditsNorthPlayerID, TournamentPlayerID, DiplomacyStates.Enemy)
	
	SetDiplomacyState(BanditsWestPlayerID, 1, DiplomacyStates.Enemy)
	SetDiplomacyState(BanditsWestPlayerID, CloisterPlayerID, DiplomacyStates.Enemy)
	SetDiplomacyState(BanditsWestPlayerID, TournamentPlayerID, DiplomacyStates.Enemy)
	
	SetDiplomacyState(BanditsEastPlayerID, 1, DiplomacyStates.Enemy)
	SetDiplomacyState(BanditsEastPlayerID, CloisterPlayerID, DiplomacyStates.Enemy)
	SetDiplomacyState(BanditsEastPlayerID, TournamentPlayerID, DiplomacyStates.Enemy)
    
    
    SetKnightTitle(1, KnightTitles.Baron)
    

end
----------------------------------------------------------------------------------------------------------------------
function Mission_SetStartingMonth()

    Logic.SetMonthOffset(3)

end
----------------------------------------------------------------------------------------------------------------------
function Mission_InitMerchants()

	local traderId = Logic.GetStoreHouse(CloisterPlayerID)
	AddOffer			(traderId,	 10,Goods.G_Herb)
	AddOffer			(traderId,	 2,Goods.G_Wool)
	
	
	SetPlayerDoesNotBuyGoodsFlag( TournamentPlayerID, true)
    
end
----------------------------------------------------------------------------------------------------------------------
function Mission_FirstMapAction()

    TournamentAI = AIPlayer:new(TournamentPlayerID)
    AICore.HideEntityFromAI(TournamentPlayerID, Logic.GetKnightID(TournamentPlayerID), true) 
    
    if (TournamentAI.m_BlackList == nil) then
    
        TournamentAI.m_BlackList = {}
        TournamentAI.m_BlackList[#TournamentAI.m_BlackList+1] = Goods.G_Gold        

    end
    
    AICore.SetNumericalFact(TournamentPlayerID, "BPMX", 0 )
    
    DoNotStartAIForPlayer( FlexibleSpeakerPlayerID )
    
    InflictPlague()

    Mission_SetupQuests()
    
    TournamentBuildings = {}
    TournamentBuildings[#TournamentBuildings+1] = Logic.GetEntityIDByName("fence_right")
    TournamentBuildings[#TournamentBuildings+1] = Logic.GetEntityIDByName("fence_left")
    TournamentBuildings[#TournamentBuildings+1] = Logic.GetEntityIDByName("fence_middle")
    
    TournamentUpgradeLevel = 0
  
    GenerateTournamentKnightTable()
end


function InflictPlague()

    local CityBuidlings = {Logic.GetPlayerEntitiesInCategory(1,EntityCategories.CityBuilding)}
    
    local BuildingsInflicted = 0
    
    for i=1, #CityBuidlings do
        
        local BuildingID = CityBuidlings[i]
        
        if BuildingsInflicted < 8 then        
            Logic.MakeBuildingIll(BuildingID)
            BuildingsInflicted = BuildingsInflicted + 1
        end
    end        
    
end


function Mission_SetupQuests()
    
    TimeForFirstEpisode = 60 * 60    
    TimeForSecondEpisode = 120 * 60
    MinimumTrophyMoney = 2000
    NeededBuildingsWithDecoration = 10
    
    VIPAtTournament = 0
    
    VIPs = {}
        
    VIPs[0] = {}
    VIPs[0].ProtectQuest = "Quest_ProtectFirstVIP"
    VIPs[0].FreeQuest    = "Quest_FreeFirstVIP"
    VIPs[0].Success      = "Quest_ProtectFirstVIP_Success"
    VIPs[0].Knight       = "NPCTalk_FightFreeFirstVIP"
    VIPs[0].Spawn        = "SpawnVIPNorth"
    VIPs[0].Bandits      = BanditsNorthPlayerID
    VIPs[0].Good         = Goods.G_Gold
    VIPs[0].Amount       = 500
    VIPs[0].TrophyMoney  = 250
    
    
    
    VIPs[1] = {}
    VIPs[1].ProtectQuest = "Quest_ProtectSecondVIP"
    VIPs[1].FreeQuest    = "Quest_FreeSecondVIP"
    VIPs[1].Success      = "Quest_ProtectSecondVIP_Success"
    VIPs[1].Knight       = "NPCTalk_FightFreeSecondVIP"
    VIPs[1].Spawn        = "SpawnVIPEast"
    VIPs[1].Bandits      = BanditsEastPlayerID
    VIPs[1].Good         = Goods.G_PoorBow
    VIPs[1].Amount       = 20
    VIPs[1].TrophyMoney  = 750
    
    
    VIPs[2] = {}
    VIPs[2].ProtectQuest = "Quest_ProtectThirdVIP"
    VIPs[2].FreeQuest    = "Quest_FreeThirdVIP"
    VIPs[2].Success      = "Quest_ProtectThirdVIP_Success"
    VIPs[2].Knight       = "NPCTalk_FightFreeThirdVIP"
    VIPs[2].Spawn        = "SpawnVIPWest"
    VIPs[2].Bandits      = BanditsWestPlayerID
    VIPs[2].Good         = Goods.G_Gold
    VIPs[2].Amount       = 3000
    VIPs[2].TrophyMoney  = 1000
    
    
    WaitUntilNextVIPStarts = 10
    
    ShowMissionTimer(TimeForFirstEpisode)
    
    --First Episode: REBUILD TIOS IN TIME
    local gatherHerbsID = QuestTemplate:New("Quest_GatherHerbs", 1, 1,
                                    {{Objective.Produce, Goods.G_Herb, 3}},
                                    { { Triggers.Time, 0}},  
                                    0, 
                                    {{Reward.PrestigePoints, 500}}, 
                                    nil, nil, nil, true, false)
    
    
    
    local buildPharmaciesID = QuestTemplate:New("Quest_BuiltPharmacies", 1, 1,
                                    {{Objective.Create, Entities.B_Pharmacy, 1}},
                                    {{Triggers.Quest, gatherHerbsID, QuestResult.Success}}, 
                                    0, 
                                    {{Reward.PrestigePoints, 1500}}, 
                                    nil, nil, nil, true)
    
    
    local cureSettlersID = QuestTemplate:New("Quest_CureAllSettlers", 1, 1, 
                        { {Objective.SatisfyNeed, Needs.Medicine, 1} },
                        {{Triggers.Quest, buildPharmaciesID, QuestResult.Success}}, 
                        0, 
                        {{Reward.PrestigePoints, 2000}}, 
                        nil, nil, nil, true)
    
    local buildWallID = QuestTemplate:New("Quest_RebuildWall", 1, 1,
                            { { Objective.Custom, Custom_BuildWall } },
                            {{Triggers.Quest, cureSettlersID, QuestResult.Success}}, 
                            0, 
                            {{Reward.PrestigePoints, 2000}}, 
                            nil, nil, nil, true)
    
    local noStrikersID = QuestTemplate:New("Quest_NoStrikers", 1, 1, 
                        {{Objective.SatisfyNeed, Needs.Medicine, 1},
                         {Objective.SatisfyNeed, Needs.Clothes, 1},
                         {Objective.SatisfyNeed, Needs.Hygiene, 1},
                         {Objective.SatisfyNeed, Needs.Nutrition, 1}},
                        {{Triggers.Quest, cureSettlersID, QuestResult.Success}}, 
                        0, 
                        {{Reward.PrestigePoints, 3000}}, 
                        nil, nil, nil, true)
    
    reestablishTiosID = QuestTemplate:New("Quest_ReestablishTios", TournamentPlayerID, 1,
                            { { Objective.Quest, { buildWallID, noStrikersID } } },
                            { { Triggers.Time, 1}},
                            TimeForFirstEpisode, 
                            nil, 
                            { {Reprisal.Defeat}},  
                            OnFirstEpisodeFinished, nil, true)
    
    --Quests[gatherHerbsID]:Success()
    --Quests[buildPharmaciesID]:Success()
    --Quests[cureSettlersID]:Success()
    --Quests[buildWallID]:Success()
    --Quests[noStrikersID]:Success()
    --Quests[reestablishTiosID]:Success()
    

    --SECOND EPISODE: Prepare tournament
    preparationFundamentalsID = QuestTemplate:New("Quest_PreparationFundamentals", TournamentPlayerID, 1, 
                                                    {{Objective.Deliver, Goods.G_Wood, 50}}, 
                                                    {{Triggers.Quest, reestablishTiosID, QuestResult.Success}}, 
                                                    0, 
                                                    {{Reward.PrestigePoints, 800}}, 
                                                    nil, OnTournamentQuestDone, nil, true, false)
    
    preparationClothesID = QuestTemplate:New("Quest_PreparationClothes", TournamentPlayerID, 1, 
                                                    {{Objective.Deliver, Goods.G_Leather, 12}}, 
                                                    {{Triggers.Quest, preparationFundamentalsID, QuestResult.Success}}, 
                                                    0, 
                                                    {{Reward.PrestigePoints, 800}}, 
                                                    nil, OnTournamentQuestDone, nil, true, false)
    
    preparationWeaponsID = QuestTemplate:New("Quest_PreparationWeapons", TournamentPlayerID, 1, 
                                                    {{ Objective.Deliver, Goods.G_PoorSword, 18 }}, 
                                                    {{Triggers.Quest, preparationClothesID, QuestResult.Success}}, 
                                                    0, 
                                                    {{Reward.PrestigePoints, 1600}}, 
                                                    nil, OnTournamentQuestDone, nil, true, false)
    
    --Quests[preparationFundamentalsID]:Success()
    --Quests[preparationClothesID]:Success()
    --Quests[preparationWeaponsID]:Success()
    
    hiddentrophyMoneyID = QuestTemplate:New("", 1, TournamentPlayerID, 
                                            {{Objective.Custom, Custom_TrophyMoney}},
                                            {{Triggers.Quest, preparationWeaponsID, QuestResult.Success}}, 
                                            0, nil, nil, nil, nil, false)


    preparationWealthInTiosID = QuestTemplate:New("Quest_PreparationWealthInTios", TournamentPlayerID, 1,
                            { { Objective.Custom, Custom_Decoration } },
                            {{Triggers.Quest, reestablishTiosID, QuestResult.Success}},                             
                            0, 
                            {{Reward.PrestigePoints, 1200}}, 
                            nil, OnTournamentQuestDone, nil, true)
                            
    VIPsAreThereInTiosID = QuestTemplate:New("", TournamentPlayerID, 1,
                                        { { Objective.Custom, Custom_VIPS } },
                                        {{Triggers.Quest, reestablishTiosID, QuestResult.Success}},                             
                                        0, nil, nil, nil, nil, false)

    prepareTournamentID = QuestTemplate:New("Quest_TournamentPreparations", TournamentPlayerID, 1,
                            { { Objective.Quest, { hiddentrophyMoneyID, preparationWealthInTiosID, VIPsAreThereInTiosID } } },
                            {{Triggers.Quest, reestablishTiosID, QuestResult.Success}}, 
                            TimeForSecondEpisode, 
                            { { Reward.CampaignMapFinished } }, 
                            { {Reprisal.Defeat}}, 
                            OnPrepareTournamentFinished, nil, true, false)
    
    
    GenerateVictoryDialog({{TournamentPlayerID,"Victory_TiosAttaches" },
                            {TiosHarbourPlayerID,"Victory_TouchAtTiosAgain" },
                            {FlexibleSpeakerPlayerID,"Victory_WhoLaughsLast" }}, prepareTournamentID)


end


function GenerateTournamentKnightTable()

    local PlayerKnightType = Logic.GetEntityType(Logic.GetKnightID(1))
    
    local KnightName = Logic.GetEntityTypeName(PlayerKnightType)
        
    local FirstKnightType = Entities.U_KnightChivalry
    local SecondKnightType = Entities.U_KnightSong
    local ThirdKnightType = Entities.U_KnightWisdom
    local FourthKnightType = Entities.U_KnightPlunder
    
    local TournamentArrivalText = {}
    TournamentArrivalText[Entities.U_KnightChivalry] = "NPCTalk_FirstKnightMarcusArrives" 
    TournamentArrivalText[Entities.U_KnightHealing] = "NPCTalk_FirstKnightAlandraArrives" 
    TournamentArrivalText[Entities.U_KnightSong] = "NPCTalk_SecondKnightThordalArrives" 
    TournamentArrivalText[Entities.U_KnightTrading] = "NPCTalk_SecondKnightEliasArrives" 
    TournamentArrivalText[Entities.U_KnightWisdom] = "NPCTalk_ThirdKnightHakimArrives" 
    TournamentArrivalText[Entities.U_NPC_Castellan_NA] = "NPCTalk_ThirdKnightCastellanNAArrives" 
    TournamentArrivalText[Entities.U_KnightPlunder] = "NPCTalk_FourthKnightKestralArrives" 
    TournamentArrivalText[Entities.U_NPC_Castellan_ME] = "NPCTalk_FourthKnightCastellanMEArrives" 
    
    
    TournamentKnightHead = {}
    TournamentKnightHead[Entities.U_KnightChivalry] = "H_Knight_Chivalry"
    TournamentKnightHead[Entities.U_KnightHealing]  = "H_Knight_Healing"
    TournamentKnightHead[Entities.U_KnightSong]     = "H_Knight_Song"
    TournamentKnightHead[Entities.U_KnightTrading]  = "H_Knight_Trading"
    TournamentKnightHead[Entities.U_KnightWisdom]   = "H_Knight_Wisdom"
    TournamentKnightHead[Entities.U_NPC_Castellan_NA]  = "H_NPC_Castellan_NA"
    TournamentKnightHead[Entities.U_KnightPlunder]  = "H_Knight_Plunder" 
    TournamentKnightHead[Entities.U_NPC_Castellan_ME]= "H_NPC_Castellan_ME" 
    
    
    TournamentKnightName = {}
    TournamentKnightName[Entities.U_KnightChivalry] = "Marcus"
    TournamentKnightName[Entities.U_KnightHealing]  = "Alandra"
    TournamentKnightName[Entities.U_KnightSong]     = "Thordal"
    TournamentKnightName[Entities.U_KnightTrading]  = "Elias"
    TournamentKnightName[Entities.U_KnightWisdom]   = "Hakim"
    TournamentKnightName[Entities.U_NPC_Castellan_NA]  = "Hakim"
    TournamentKnightName[Entities.U_KnightPlunder]  = "Kestral" 
    TournamentKnightName[Entities.U_NPC_Castellan_ME]= "Marcus" 
    
    if PlayerKnightType == FirstKnightType then
        FirstKnightType = Entities.U_KnightHealing
    end
    
    if PlayerKnightType == SecondKnightType then
        SecondKnightType = Entities.U_KnightTrading
    end
    
    if PlayerKnightType == ThirdKnightType then
        ThirdKnightType = Entities.U_NPC_Castellan_NA
    end
    
    if PlayerKnightType == FourthKnightType then
        FourthKnightType = Entities.U_NPC_Castellan_ME
    end
    
    TournamentKnights = {}
    
    TournamentKnights[0] ={}
    TournamentKnights[0].KnightType     = FirstKnightType
    TournamentKnights[0].BattalionType  = Entities.U_MilitarySword
    TournamentKnights[0].Speech         = TournamentArrivalText[FirstKnightType]
    TournamentKnights[0].KnightMoveTo   = "FirstKnightPosition"
    TournamentKnights[0].SoldiersMoveTo = "FirstBattalionPosition"
    TournamentKnights[0].TrophyGold     = 250
    TournamentKnights[0].Head           = TournamentKnightHead[FirstKnightType]
    TournamentKnights[0].Name           = TournamentKnightName[FirstKnightType]
    
    
    
    TournamentKnights[1] ={}
    TournamentKnights[1].KnightType     = SecondKnightType
    TournamentKnights[1].BattalionType  = Entities.U_MilitaryBandit_Melee_NE
    TournamentKnights[1].Speech         = TournamentArrivalText[SecondKnightType]
    TournamentKnights[1].KnightMoveTo   = "SecondKnightPosition"
    TournamentKnights[1].SoldiersMoveTo = "SecondBattalionPosition"
    TournamentKnights[1].TrophyGold     = 750
    TournamentKnights[1].Head           = TournamentKnightHead[SecondKnightType]
    TournamentKnights[1].Name           = TournamentKnightName[SecondKnightType]
    
    TournamentKnights[2] ={}
    TournamentKnights[2].KnightType     = ThirdKnightType
    TournamentKnights[2].BattalionType  = Entities.U_MilitaryBandit_Ranged_NA
    TournamentKnights[2].Speech         = TournamentArrivalText[ThirdKnightType]
    TournamentKnights[2].KnightMoveTo   = "ThirdKnightPosition"
    TournamentKnights[2].SoldiersMoveTo = "ThirdBattalionPosition"
    TournamentKnights[2].TrophyGold     = 1250
    TournamentKnights[2].Head           = TournamentKnightHead[ThirdKnightType]
    TournamentKnights[2].Name           = TournamentKnightName[ThirdKnightType]
    
    
    TournamentKnights[3] ={}
    TournamentKnights[3].KnightType     = FourthKnightType
    TournamentKnights[3].BattalionType  = Entities.U_MilitaryBandit_Melee_ME
    TournamentKnights[3].Speech         = TournamentArrivalText[FourthKnightType]
    TournamentKnights[3].KnightMoveTo   = "FourthKnightPosition"
    TournamentKnights[3].SoldiersMoveTo = "FourthBattalionPosition"
    TournamentKnights[3].TrophyGold     = 1750
    TournamentKnights[3].Head           = TournamentKnightHead[FourthKnightType]
    TournamentKnights[3].Name           = TournamentKnightName[FourthKnightType]
    
    
    ArrivedKnights = 0
    
end


function OnPrepareTournamentFinished(_Quest)
    
    FlexibleSpeakerPlayerID = SetupPlayer(8,"H_Knight_RedPrince","Red Prince","RedPrinceColor")        
    
    if _Quest.Result ~= QuestResult.Success then        
        FlexibalPlayerVoiceStart = Logic.GetTime()
        FlexibalPlayerVoiceText =  "Defeat_TiosIsMine"
        StartSimpleJob("StartFlexibalPlayerVoiceAfterOneSecond")
    end
    
end

function StartFlexibalPlayerVoiceAfterOneSecond()
    if Logic.GetTime()  >= FlexibalPlayerVoiceStart + 1 then
        SendVoiceMessage(FlexibleSpeakerPlayerID, FlexibalPlayerVoiceText )
        return true
    end
end


function Custom_BuildWall()
    local x,y = Logic.GetBuildingApproachPosition(Logic.GetStoreHouse(1))
    local i,j = Logic.GetBuildingApproachPosition(Logic.GetStoreHouse(BanditsEastPlayerID))--Logic.GetEntityPosition(Logic.GetEntityIDByName("PrisonSucea"))
    local sector1 = Logic.DEBUG_GetSectorAtPosition(x, y)
    local sector2 = Logic.DEBUG_GetSectorAtPosition(i, j)
    if sector1 ~= sector2 then
        return true
    end
    
    return nil
end


function Custom_Decoration()

    local BuildingsWithDecoration = 0
    
    local CityBuildings = {Logic.GetPlayerEntitiesInCategory(1, EntityCategories.CityBuilding)}

    for i=1, #CityBuildings do
        
        local BuildingID = CityBuildings[i]
        local GoodState = Logic.GetBuildingWealthGoodState(BuildingID, Goods.G_Banner)
            
        if GoodState > 0 then
            BuildingsWithDecoration = BuildingsWithDecoration + 1
        end
    end
                
    
    if BuildingsWithDecoration >= NeededBuildingsWithDecoration then
        
        return true
    
    end

end

function Custom_VIPS()

    if VIPAtTournament == 3 then
        return true
    end        
end

function OnFirstEpisodeFinished()

    local TimeLeft = TimeForFirstEpisode - Logic.GetTime()
    
    TimeForSecondEpisode = Logic.GetTime() + TimeForSecondEpisode + TimeLeft
    
    ShowMissionTimer(TimeForSecondEpisode)
    
    Quests[prepareTournamentID].Duration = TimeForSecondEpisode
    
end


function OnTournamentQuestDone(_Quest)
    
    if _Quest.Result == QuestResult.Success then
    
        if _Quest.Index == preparationWeaponsID then
            GenerateTrophyMoneyQuest()
            StartMissionGoodCounter(Goods.G_Gold, MinimumTrophyMoney)
        end
        
        TournamentUpgradeLevel = TournamentUpgradeLevel + 1
        
        for i=1, #TournamentBuildings do
            local TournamentPlaceID = TournamentBuildings[i]
            Logic.UpgradeBuilding(TournamentPlaceID, TournamentUpgradeLevel)
        end
    
        AICore.SetNumericalFact(TournamentPlayerID, "BPMX", TournamentUpgradeLevel )
        
    end
    
end

function Custom_TrophyMoney()
    if TotalMoneyCollected >= MinimumTrophyMoney then
        return true
    end
    return nil
end

function GenerateTrophyMoneyQuest()
    if Quests[hiddentrophyMoneyID].Result ~= QuestResult.Success then
        if TotalMoneyCollected == nil then
            TotalMoneyCollected = 0
            StartSimpleJob("CheckTrophyMoney")
        else
            TotalMoneyCollected = 250 + TotalMoneyCollected
        end

        if Custom_TrophyMoney() == true then
            return
        end

        sendTrophyMoneyQuest = QuestTemplate:New("Quest_PreparationTrophyMoney", TournamentPlayerID, 1,
                                {{Objective.Deliver, Goods.G_Gold, 250}}, 
                                { {Triggers.Time, 0 } },
                                0, 
                                nil, 
                                nil, GenerateTrophyMoneyQuest, nil, true, false)
    end
end


function CheckTrophyMoney()

    local TournamentMoney = TotalMoneyCollected --GetPlayerResources(Goods.G_Gold, TournamentPlayerID)
    
    --update counter
    MissionCounter.CurrentAmount = TournamentMoney
    
    --generate cart, when enogh money is there and the previous cart quest strand is done
    if  VIPs[VIPAtTournament] ~= nil 
    and TournamentMoney >= VIPs[VIPAtTournament].TrophyMoney 
    and VIPs[VIPAtTournament].Triggered == nil
    and Logic.GetTime() >= WaitUntilNextVIPStarts
    and (VIPs[VIPAtTournament-1] == nil or VIPs[VIPAtTournament-1].Done == true ) then
        
        local VIPCart = GenerateVIPCart(VIPs[VIPAtTournament].Spawn)
        
        protectVIPID = QuestTemplate:New(VIPs[VIPAtTournament].ProtectQuest, TournamentPlayerID, 1,
                                        { { Objective.Protect, {VIPCart} } }, 
                                        { { Triggers.Time, 0 } },
                                        0, nil, nil, OnProtectQuestFinished, nil, true,false)
        
        freeVIPID = QuestTemplate:New(VIPs[VIPAtTournament].FreeQuest, VIPs[VIPAtTournament].Bandits, 1, 
                                {{Objective.Deliver, VIPs[VIPAtTournament].Good, VIPs[VIPAtTournament].Amount}},
                                {{Triggers.Quest, protectVIPID, QuestResult.Failure}}, 
                                0, 
                                nil, 
                                nil, OnVIPCartPayed, nil, true)

        destroyBanditsID = QuestTemplate:New("", 1, 1, 
                            {{Objective.DestroyPlayers, VIPs[VIPAtTournament].Bandits}},
                                {{Triggers.Quest, protectVIPID, QuestResult.Failure}}, 
                                0, 
                                nil, 
                                nil, OnBanditsDestroyed, nil, false)
        
        VIPs[VIPAtTournament].Triggered = true
    end 
    
    
    if  TournamentKnights[ArrivedKnights] ~= nil
    and TournamentKnights[ArrivedKnights].Triggeres == nil 
    and TournamentMoney >= TournamentKnights[ArrivedKnights].TrophyGold then 
    
        local KnightName = TournamentKnights[ArrivedKnights].Name
        
        FlexibleSpeakerPlayerID = SetupPlayer(FlexibleSpeakerPlayerID,TournamentKnights[ArrivedKnights].Head, KnightName, "CP_BabyBlueColor")
        
        FlexibalPlayerVoiceStart = Logic.GetTime()
        FlexibalPlayerVoiceText =  TournamentKnights[ArrivedKnights].Speech
        StartSimpleJob("StartFlexibalPlayerVoiceAfterOneSecond")
    
        local HarbourID = Logic.GetStoreHouse(TiosHarbourPlayerID)
        local x, y = Logic.GetBuildingApproachPosition(HarbourID)
        
        local KnightType    = TournamentKnights[ArrivedKnights].KnightType
        local BattlionType  = TournamentKnights[ArrivedKnights].BattalionType
        
        local KnightID    = Logic.CreateEntityAtBuilding(KnightType, HarbourID, 0, FlexibleSpeakerPlayerID)
        local BattalionID = Logic.CreateBattalionOnUnblockedLand(BattlionType, x, y, 0, FlexibleSpeakerPlayerID, 0)
        
        local KnightMoveToID = Logic.GetEntityIDByName(TournamentKnights[ArrivedKnights].KnightMoveTo)
        local KnightTartgetPosX, KnightTartgetPosY = Logic.GetEntityPosition(KnightMoveToID)
        local KnightOrientation = Logic.GetEntityOrientation(KnightMoveToID)
        
        local SoldiersMoveToID = Logic.GetEntityIDByName(TournamentKnights[ArrivedKnights].SoldiersMoveTo)
        local BattalionTartgetPosX, BattalionTartgetPosY = Logic.GetEntityPosition(SoldiersMoveToID)
        local BattalionOrientation = Logic.GetEntityOrientation(SoldiersMoveToID)
        
        
        --AICore.HideEntityFromAI(FlexibleSpeakerPlayerID, KnightID, true) 
        --AICore.HideEntityFromAI(FlexibleSpeakerPlayerID, BattalionID, true) 
        
        Logic.MoveSettler(KnightID, KnightTartgetPosX, KnightTartgetPosY)
        Logic.MoveSettler(BattalionID, BattalionTartgetPosX, BattalionTartgetPosY)
        
        
        
        TournamentKnights[ArrivedKnights].Triggeres = true
        
        ArrivedKnights = ArrivedKnights + 1
    end

    
    --add thief behavior here
    
    
end

function OnProtectQuestFinished(_Quest)

    if _Quest.Result == QuestResult.Failure then        
        SendVoiceMessage(1, "NPCTalk_WeDoNotHaveToPayBandits")
    end

end


function OnBanditsDestroyed(_Quest)
    if _Quest.Result == QuestResult.Success then    
    
        Quests[freeVIPID]:Interrupt()

        if VIPCart == nil or Logic.IsEntityDestroyed(VIPCart) then
            SendVoiceMessage(1, VIPs[VIPAtTournament].Knight)
            OnVIPCartFreed()
        end
    end
end

function OnVIPCartPayed(_Quest)

    if _Quest.Result == QuestResult.Success then        
        OnVIPCartFreed()
    end
    
end

function OnVIPCartFreed()
    
    SetDiplomacyState(VIPs[VIPAtTournament].Bandits, TournamentPlayerID, DiplomacyStates.EstablishedContact)
    
    local Amount, SpawnID = Logic.GetPlayerEntities(VIPs[VIPAtTournament].Bandits, Entities.XD_StartPosition, 1)
    
    local VIPCart = GenerateVIPCart(SpawnID)
    
    
    protectVIPID = QuestTemplate:New(VIPs[VIPAtTournament].ProtectQuest, TournamentPlayerID, 1,
                                        { { Objective.Protect, {VIPCart} } }, 
                                        { { Triggers.Time, 0 } },
                                        0, 
                                        {{Reward.PrestigePoints, 2000}}, 
                                        nil, OnProtectQuestFinished, nil, true,false)
end


function GenerateVIPCart(_SpawnPointName)

    local SpawnID
    
    if type(_SpawnPointName) == "string" then
		SpawnID = Logic.GetEntityIDByName(_SpawnPointName)
    else
        SpawnID = _SpawnPointName
    end

    local x,y = Logic.GetEntityPosition(SpawnID)
    
    VIPCart = Logic.CreateEntityOnUnblockedLand(Entities.U_Noblemen_Cart,x,y,0,TournamentPlayerID)    
    
    Logic.HireMerchant(VIPCart, TournamentPlayerID, Goods.G_Gold, 1, TiosHarbourPlayerID)
    
    StartSimpleJob("CheckIfVIPCartReachedTournament")
        
    return VIPCart

end


function CheckIfVIPCartReachedTournament()

    if  Logic.IsEntityAlive(VIPCart) then
        if  Logic.GetDistanceBetweenEntities(VIPCart, Logic.GetHeadquarters(TournamentPlayerID)) < 600 
        and VIPs[VIPAtTournament].Done == nil then
        
            Quests[protectVIPID]:Success()
            Quests[freeVIPID]:Interrupt()
            Quests[destroyBanditsID]:Interrupt()
            
            SendVoiceMessage(TournamentPlayerID, VIPs[VIPAtTournament].Success)
            
            VIPs[VIPAtTournament].Done = true
            
            VIPAtTournament = VIPAtTournament + 1
            
            WaitUntilNextVIPStarts = Logic.GetTime() + 30
            
            RemoveBowsFromBandits()
            
            --Logic.DEBUG_AddNote("VIPAtTournament " .. VIPAtTournament)
            
            return true
        end            
    else
       return true
    end
    
end


function RemoveBowsFromBandits()
    --remove bows, when player send bows 
    local MarketSlots = {Logic.GetPlayerEntities(BanditsEastPlayerID, Entities.B_Marketslot, 5,0)}
    for i=2, #MarketSlots do
        local MarketSlotID = MarketSlots[i]
    
        local NumberOfGoodTypes = Logic.GetNumberOfGoodTypesOnOutStock(MarketSlotID)
    
        for j = 0, NumberOfGoodTypes-1 do        
            local GoodType = Logic.GetGoodTypeOnOutStockByIndex(MarketSlotID,j)
            local Amount = Logic.GetAmountOnOutStockByIndex(MarketSlotID, j)
            
            if Amount > 0 then
                for k=1, 20 do
                    Logic.RemoveGoodFromStock(MarketSlotID, GoodType, 1, false)
                end
            end
        end
    end
end

function Mission_Victory()

    local PossibleSettlerTypes = {
    Entities.U_NPC_Monk_ME,
    Entities.U_NPC_Monk_NE,
    Entities.U_NPC_Monk_NA,
    Entities.U_NPC_Monk_SE,
    Entities.U_NPC_Villager01_ME,
    Entities.U_NPC_Villager01_NE,
    Entities.U_NPC_Villager01_SE,
    Entities.U_NPC_Villager01_NA,
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
    Entities.U_TheatreWorker,
    Entities.U_SpouseS01,
    Entities.U_SpouseS02,
    Entities.U_SpouseS03,
    Entities.U_SpouseF01,
    Entities.U_SpouseF02,
    Entities.U_SpouseF03}

    local VictoryKnightsMoveTo = Logic.GetEntityIDByName("VictoryKnightsMoveTo")
    local x,y = Logic.GetEntityPosition(VictoryKnightsMoveTo)

    for j=1,6 do
        local PlacesForSettlers = {Logic.GetEntitiesInArea(Entities.D_X_Stump, x,y,4000,16)}
        for i=2, #PlacesForSettlers do
            local StumpID = PlacesForSettlers[i]
            local x,y = Logic.GetEntityPosition(StumpID)
            local Orientation = 0
            Logic.DestroyEntity(StumpID) 
            local SettlerType = PossibleSettlerTypes[1 + Logic.GetRandom(#PossibleSettlerTypes)]
            local SettlerID = Logic.CreateEntityOnUnblockedLand(SettlerType, x, y, Orientation, TournamentPlayerID) 
            
            Logic.SetTaskList(SettlerID, TaskLists.TL_WORKER_FESTIVAL_APPLAUD_SPEECH)
        end
    end

    local VictoryKnightPos = Logic.GetEntityIDByName("VictoryChivalryStart")
    local x,y = Logic.GetEntityPosition(VictoryKnightPos)
    local Orientation = Logic.GetEntityOrientation(VictoryKnightPos)        
    VictoryKnight1 = Logic.CreateEntityOnUnblockedLand(Entities.U_KnightChivalry, x, y, Orientation-90, 1)  
    
    local VictoryPlunderStart = Logic.GetEntityIDByName("VictoryPlunderStart")
    local x,y = Logic.GetEntityPosition(VictoryPlunderStart)
    local Orientation = Logic.GetEntityOrientation(VictoryPlunderStart)
    VictoryKnight2 = Logic.CreateEntityOnUnblockedLand(Entities.U_KnightPlunder, x, y, Orientation-90, FlexibleSpeakerPlayerID)  
    
    
    local VictoryFighters1 = Logic.GetEntityIDByName("VictoryFighters1")
    local x,y = Logic.GetEntityPosition(VictoryFighters1)
    local Orientation = Logic.GetEntityOrientation(VictoryFighters1)
    Logic.CreateBattalionOnUnblockedLand(Entities.U_MilitarySword, x, y, Orientation-90, 1)    
    
    
    local VictoryFighters2 = Logic.GetEntityIDByName("VictoryFighters2")
    local x,y = Logic.GetEntityPosition(VictoryFighters2)
    local Orientation = Logic.GetEntityOrientation(VictoryFighters2)
    Logic.CreateBattalionOnUnblockedLand(Entities.U_MilitarySword, x, y, Orientation-90, BanditsNorthPlayerID)
    
    
    VictoryWaitBeforeStart = 0
    StartSimpleJob("VictoryControlTournament")
    
    StartSimpleJob("VictoryHealSoldiers")
    
end


function VictoryHealSoldiers()
    
    local PlayerID = 1
    
    for i=1, 2 do
        local Leaders = {Logic.GetPlayerEntitiesInCategory(PlayerID, EntityCategories.Leader)}
        
        for j=1, #Leaders do
            local LeaderID = Leaders[j]
            local Soldiers = {Logic.GetSoldiersAttachedToLeader(LeaderID)}
            for k=2, #Soldiers do
                local SoldierID = Soldiers[k]
                Logic.HealEntity(SoldierID, Logic.GetEntityMaxHealth(SoldierID))
            end
        end
        
        PlayerID = BanditsNorthPlayerID
    end
    
    
end

function VictoryControlTournament()

    
    local VictoryKnightsMoveTo = Logic.GetEntityIDByName("VictoryKnightsMoveTo")
    local x,y = Logic.GetEntityPosition(VictoryKnightsMoveTo)
    
    if VictoryWaitBeforeStart == 20 then
        Logic.MoveSettler(VictoryKnight1, x,y)
        Logic.MoveSettler(VictoryKnight2, x,y)
    end
    
    if VictoryWaitBeforeStart == 22 then
        Logic.CreateEffect(EGL_Effects.E_Shockwave03, x,y,1)    
        Logic.CreateEffect(EGL_Effects.E_KnightFight, x,y,1)    
        Logic.DestroyEntity(VictoryKnight1)
        Logic.DestroyEntity(VictoryKnight2)
        return true
    end
    

    VictoryWaitBeforeStart = VictoryWaitBeforeStart + 1
end

