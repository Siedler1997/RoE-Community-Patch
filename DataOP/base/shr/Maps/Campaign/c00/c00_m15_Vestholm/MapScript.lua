CurrentMapIsCampaignMap = true
NumKnightsFreed = 0
PrisonIslandID = Logic.GetEntityIDByName("PrisonIsland")
PrisonIslandX, PrisonIslandY = Logic.GetEntityPosition(Logic.GetEntityIDByName("KnightAtIsland"))
PrisonCityID = Logic.GetEntityIDByName("PrisonCity")
PrisonCityX, PrisonCityY = Logic.GetEntityPosition(Logic.GetEntityIDByName("KnightAtCity"))
PrisonBanditsID = Logic.GetEntityIDByName("PrisonBandits")
PrisonBanditsX, PrisonBanditsY = Logic.GetBuildingApproachPosition(PrisonBanditsID)
PrisonVillageID = Logic.GetEntityIDByName("PrisonVillage")
----------------------------------------------------------------------------------------------------------------------
function Mission_InitPlayers()

    --traitor head will be set in intitialknights
    VestholmPlayerID = SetupPlayer(2, "H_Knight_Chivalry", "City of Vestholm", "RedPrinceColor")
    
    HarborPlayerID = SetupPlayer(3, "H_NPC_Generic_Trader", "Vestholm Harbor", "TravelingSalesmanColor")
    
    CalhadorHoldPlayerID = SetupPlayer(4, "H_NPC_Mercenary_ME", "Calhador Hold", "BanditsColor1")

    SetupPlayer(5, "H_NPC_Villager01_ME", "Village of Eastholm", "VillageColor3")

    -- set some resources for player 1
    AddResourcesToPlayer(Goods.G_Gold,250)
    AddResourcesToPlayer(Goods.G_Stone,50)
    AddResourcesToPlayer(Goods.G_Wood,50)
    AddResourcesToPlayer(Goods.G_Grain,10)
    AddResourcesToPlayer(Goods.G_Carcass,10)
    AddResourcesToPlayer(Goods.G_RawFish,10)
    AddResourcesToPlayer(Goods.G_Milk,10)
    
    AddResourcesToPlayer(Goods.G_Gold,310, VestholmPlayerID)    
    AddResourcesToPlayer(Goods.G_Iron,30, VestholmPlayerID)
    AddResourcesToPlayer(Goods.G_Wood,30, VestholmPlayerID)
    AddResourcesToPlayer(Goods.G_Grain,60, VestholmPlayerID)
    AddResourcesToPlayer(Goods.G_Carcass,60, VestholmPlayerID)
    AddResourcesToPlayer(Goods.G_Herb,60, VestholmPlayerID)
    AddResourcesToPlayer(Goods.G_Wool,60, VestholmPlayerID)
    AddResourcesToPlayer(Goods.G_Milk,60, VestholmPlayerID)
    AddResourcesToPlayer(Goods.G_Honeycomb,60, VestholmPlayerID)
    
        
    SetKnightTitle(VestholmPlayerID, KnightTitles.Duke)
end
----------------------------------------------------------------------------------------------------------------------
function Mission_SetStartingMonth()

    Logic.SetMonthOffset(9)

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

    --AnSu: can not be used withour further changes on the map
	--ActivateTravelingSalesman(HarborPlayerID, { 
    --                                            {3,     
    --                                                {  
    --                                                    {Goods.G_Bread, 5}, 
    --                                                    {Goods.G_Salt, 1}, 
    --                                                    {Entities.U_Entertainer_NA_StiltWalker}, 
    --                                                    {Entities.U_MilitaryBandit_Meelee_NA}                                                        
    --                                                }     
    --                                            },
    --                                            {6,     
    --                                                {  
    --                                                    {Goods.G_Medicine, 2},
    --                                                    {Goods.G_Dye, 1},
    --                                                    {Entities.U_Entertainer_NE_StrongestMan_Barrel}, 
    --                                                    {Entities.U_MilitaryBandit_Meelee_NE}                                                        
    --                                                }     
    --                                            }  
    --                                        } 
    --                                  )

end
----------------------------------------------------------------------------------------------------------------------
function Mission_SetupDiplomacy()
    SetDiplomacyState(1,2, DiplomacyStates.Enemy)
    SetDiplomacyState(1,3, DiplomacyStates.EstablishedContact)
    SetDiplomacyState(1,4, DiplomacyStates.Enemy)
    SetDiplomacyState(1,5, DiplomacyStates.Enemy)
    SetDiplomacyState(1,6, DiplomacyStates.Undecided)
    SetDiplomacyState(1,7, DiplomacyStates.Undecided)
    SetDiplomacyState(1,8, DiplomacyStates.Undecided)
    
    SetDiplomacyState(2,3, DiplomacyStates.Undecided)
    SetDiplomacyState(2,4, DiplomacyStates.Undecided)
    SetDiplomacyState(2,5, DiplomacyStates.TradeContact)
    SetDiplomacyState(2,6, DiplomacyStates.Enemy)
    SetDiplomacyState(2,7, DiplomacyStates.Enemy)
    SetDiplomacyState(2,8, DiplomacyStates.Enemy)
    
    SetDiplomacyState(3, 4, DiplomacyStates.Undecided)
    SetDiplomacyState(3, 5, DiplomacyStates.Undecided)
    SetDiplomacyState(3, 6, DiplomacyStates.Undecided)
    SetDiplomacyState(3, 7, DiplomacyStates.Undecided)
    SetDiplomacyState(3, 8, DiplomacyStates.Undecided)
    
    SetDiplomacyState(4, 5, DiplomacyStates.EstablishedContact)
    SetDiplomacyState(4, 6, DiplomacyStates.Undecided)
    SetDiplomacyState(4, 7, DiplomacyStates.Undecided)
    SetDiplomacyState(4, 8, DiplomacyStates.Undecided)
    
    SetDiplomacyState(5, 6, DiplomacyStates.TradeContact)
    SetDiplomacyState(5, 7, DiplomacyStates.TradeContact)
    SetDiplomacyState(5, 8, DiplomacyStates.TradeContact)
    
    SetDiplomacyState(6, 7, DiplomacyStates.TradeContact)
    SetDiplomacyState(6, 8, DiplomacyStates.TradeContact)
    
    SetDiplomacyState(7, 8, DiplomacyStates.TradeContact)
end
----------------------------------------------------------------------------------------------------------------------
function Mission_FirstMapAction()
    --DisableFoW()
    
    if g_OnGameStartPresentationMode == true then
    
        Logic.DestroyEntity(Logic.GetKnightID(1))
       
        StartSimpleJob("HACK_DestroyAllMilitaryUnits")
        
        Logic.CreateEntityAtBuilding(Entities.U_KnightSong, Logic.GetMarketplace(2), 0,2)
        SetupPlayer(2, "H_Knight_Song","",  "CityColor2")
        
        DoNotStartAIForPlayer( 2 )
        
        SetDiplomacyState(3,7, DiplomacyStates.Enemy)
        
        Viking = AIPlayer:new(7, AIPlayerProfile_Viking)
        Viking.m_ShipSpawnID = Logic.GetEntityIDByName("PresentationVikingsShipStart")
        Viking.m_ShipEndID = Logic.GetEntityIDByName("PresentationVikingsShipEnd")
        Viking.m_VikingSpawnID = Logic.GetEntityIDByName("PresentationVikingsSpawnPoint")
        Viking.m_StartAttackMonth = -1
        
        return
    end
    
    Mission_SetupDiplomacy()
    
    InitializeShip()
    InitializeKnights()

    Logic.InteractiveObjectSetAvailability(PrisonIslandID, false)
    Logic.InteractiveObjectSetPlayerState(PrisonIslandID, 1, 2)

    Logic.InteractiveObjectSetAvailability(PrisonCityID, false)
    Logic.InteractiveObjectSetPlayerState(PrisonCityID, 1, 2)

    Mission_SetupQuests()

    -- Launch AI
   AIPlayer:new(VestholmPlayerID, AIProfile_Sabbata)
--   LaunchEndQuest()

    StartSimpleJob("MonitorCarfulState")
	
	--OnShipReturningToHarbor()
    
    Logic.WeatherEventSetPrecipitationFalling(true)
    Logic.WeatherEventSetPrecipitationIsSnow(false)
    Logic.WeatherEventClearGoodTypesNotGrowing()
    Logic.ActivateWeatherEvent()
end
----------------------------------------------------------------------------------------------------------------------
function Mission_SetupQuests()
    protectKnightID = QuestTemplate:New("Quest_ProtectYourKnight", 1, 1,
        {{ Objective.Protect, { Logic.GetKnightID(1) } }},
        {{ Triggers.Time, 0 }},
        0, 
        nil, 
        { { Reprisal.Defeat } }, OnProtectKnightDone, nil, true, false)

    reachStartPositionID = QuestTemplate:New("Quest_GetToStartposition", 1, 1,
        {{ Objective.Distance, Logic.GetKnightID(1), Logic.GetHeadquarters(1) }},
        {{ Triggers.Time, 0 }},
        0, 
        { { Reward.PrestigePoints, 1200 } }, 
        nil, OnStartPositionReached, nil, true, false)

    becomeBaronID = QuestTemplate:New("Quest_BecomeBaron", 1, 1,
        {{ Objective.KnightTitle, KnightTitles.Baron }},
        {{ Triggers.Quest, reachStartPositionID, QuestResult.Success }},
        0, 
        { { Reward.PrestigePoints, 500 } }, 
        nil, nil, nil, true, false)
        
    becomeMayorID = QuestTemplate:New("", 1, 1,
        {{ Objective.KnightTitle, KnightTitles.Mayor }},
        {{ Triggers.Quest, reachStartPositionID, QuestResult.Success }},
        0, nil, nil, nil, nil, false, false)    
    

    reachDocksID = QuestTemplate:New("Quest_GetToTheDocks", 1, 1,
        {{ Objective.Distance, Logic.GetKnightID(1), Logic.GetStoreHouse(HarborPlayerID) }},
        {{ Triggers.Quest, becomeMayorID, QuestResult.Success }},
        0, 
        { { Reward.PrestigePoints, 500 } }, 
        nil, OnDocksReached, nil, true, false)

    stealPrisonLocationsID = QuestTemplate:New("Quest_StealPrisonLocations", 1, 1,
        {{ Objective.Steal, 1, { Logic.GetHeadquarters(VestholmPlayerID) } }},
        {{ Triggers.Quest, becomeBaronID, QuestResult.Success }},
        0, 
        { { Reward.PrestigePoints, 1200 } }, 
        nil, OnPrisonLocationsStole, nil, true)

-- 1st knight
----------------------------------------------------------------------------------------------------------------------

    freeFirstKnightID = QuestTemplate:New("Quest_FreeFirstKnightAlcatraz", 1, 1,
        {{ Objective.DestroyEntities, 1, { PrisonIslandID } }},
        {{ Triggers.Quest, stealPrisonLocationsID, QuestResult.Success }},
        0, nil, nil, OnPrisonIslandDestroyed, nil, false, false)

    freeUseFirstKnightID = QuestTemplate:New("Quest_FreeFirstKnightAlcatraz", 1, 1,
        {{ Objective.Object, { PrisonIslandID } }},
        {{ Triggers.Quest, stealPrisonLocationsID, QuestResult.Success }},
        0, 
        { { Reward.PrestigePoints, 1200 } }, 
        nil, OnPrisonIslandOpened, nil, true, false)

-- 3rd knight
----------------------------------------------------------------------------------------------------------------------

    freeThirdKnightID = QuestTemplate:New("Quest_FreeThirdKnightVestholm", 1, 1,
        { { Objective.Object, { PrisonCityID } } },
        {{ Triggers.Quest, freeUseFirstKnightID, QuestResult.Success }},
        0, nil, nil, OnThirdKnightFreed, nil, true, false)

    destroyThirdKnightID = QuestTemplate:New("Quest_FreeThirdKnightVestholm", 1, 1,
        { { Objective.DestroyEntities, 1, { PrisonCityID } } },
        {{ Triggers.Quest, freeUseFirstKnightID, QuestResult.Success }},
        0, 
        { { Reward.PrestigePoints, 1200 } }, 
        nil, OnThirdKnightDestroyed, nil, false, false)

-- 4th knight
----------------------------------------------------------------------------------------------------------------------

    destroyBanditsID = QuestTemplate:New("", CalhadorHoldPlayerID, 1,
        {{Objective.DestroyPlayers, CalhadorHoldPlayerID }},
        {{Triggers.Time, 0}},
        0, nil, nil, OnDestroyBanditsFinished, nil, false)


end

function OnProtectKnightDone(_Quest)    
    if _Quest.Result == QuestResult.Failure then                
        Quests[reachStartPositionID]:Fail()
        OnMissionLost(_Quest)        
    end
end

function OnMissionLost(_Quest)
        
    if freeSecondKnightID ~= nil then
        Quests[freeSecondKnightID]:Interrupt()
    end
        
    SendVoiceMessage(VestholmPlayerID, "Defeat_Traitor")
    
end

LastCareful = 0
Careful = 0
function Mission_CallBack_BuildingDestroyed(_EntityID, _PlayerID, _KnockedDown)    
      
    if _PlayerID == VestholmPlayerID and Logic.IsBuilding(_EntityID) == 1 then
        
        Careful = Careful + 1
        
    end
end


function MonitorCarfulState()

    if (LastCareful ~= Careful) then
    
        LastCareful = Careful        
        if Careful > 2 then
            local d = QuestTemplate:New("", 1, 1, 
                { {Objective.Protect, { Logic.GetHeadquarters( VestholmPlayerID ) } } },
                { { Triggers.Time, 0 }}, 0, nil, { { Reprisal.Defeat }}, nil, nil, false)
            Quests[d]:Fail()
            SendVoiceMessage(1, "Defeat_VestholmDestroyed")
        else
            
            SendVoiceMessage(1, "NPCTalk_BeCareful0"..Careful)            
            
        end    
    end
end


----------------------------------------------------------------------------------------------------------------------
-- Knights quests callbacks
----------------------------------------------------------------------------------------------------------------------

function OnThirdKnightDestroyed(quest)
    if quest.Result == QuestResult.Success then
        Quests[freeThirdKnightID]:Success()
    end
end

function OnThirdKnightFreed(quest)
    if quest.Result == QuestResult.Success then
        Quests[destroyThirdKnightID]:Interrupt()
        SpawnKnight(PrisonCityX, PrisonCityY)
        Logic.InteractiveObjectSetAvailability(PrisonCityID, false)
        Logic.InteractiveObjectSetPlayerState(PrisonCityID, 1, 2)
    --Logic.DestroyEntity(PrisonCityID)
    end
end

function OnPrisonCartCaptured(quest)
    if quest.Result == QuestResult.Failure then
        OnMissionLost()
    else
        local l = GetPlayerEntities(1, Entities.U_PrisonCart)
        if #l > 0 then
            Logic.DestroyEntity(l[1])
        end
        SpawnKnight(prisonX, prisonY)
    end
end

function OnBargainFinished(quest)
    if quest.Result == QuestResult.Success then
        -- spawn Knight
        SetDiplomacyState(1, CalhadorHoldPlayerID, DiplomacyStates.Undecided)
        Quests[destroyBanditsID]:Success()
    end
--    Path:new(AllKnights[i].ID, { PrisonBanditsID, Logic.GetHeadquarters(1) }, false, false)
end

function OnDestroyBanditsFinished()
    if bargainBanditsID ~= nil then
        Quests[bargainBanditsID]:Interrupt()
    end
    SpawnKnight(PrisonBanditsX, PrisonBanditsY)
end

function OnPrisonIslandDestroyed()
    Quests[freeUseFirstKnightID]:Success()
    Logic.InteractiveObjectSetAvailability(PrisonIslandID, false)
    Logic.InteractiveObjectSetPlayerState(PrisonIslandID, 1, 2)
    SpawnKnight(PrisonIslandX, PrisonIslandY)
    InitPrison(PrisonCityID)
end

function OnPrisonIslandOpened()
    Quests[freeFirstKnightID]:Interrupt()
    --Logic.DestroyEntity(PrisonIslandID)
end

function SpawnKnight(x, y)
    for i=1, #AllKnights do
        if AllKnights[i].Used ~= true then
            AllKnights[i].ID = Logic.CreateEntityOnUnblockedLand(AllKnights[i].Type, x, y, 0, 1)            
            FlexibalPlayerID = SetupPlayer(8, AllKnights[i].Face,  "CityofVestholm", "CityColor1")
            FlexibalPlayerVoiceStart = Logic.GetTime()
            FlexibalPlayerVoiceText =  AllKnights[i].Text
            StartSimpleJob("StartFlexibalPlayerVoiceAfterOneSecond")
            --SendVoiceMessage(playerid, AllKnights[i].Text)
            
            AllKnights[i].Used = true
            NumKnightsFreed = NumKnightsFreed + 1
            if NumKnightsFreed < 4 then
                KnightJustFreed = true
            end
            return i
        end
    end
end

function LaunchEndQuest()
    -- spawn traitor
    local x, y = Logic.GetBuildingApproachPosition(Logic.GetHeadquarters(VestholmPlayerID))
    TraitorKnight.ID = Logic.CreateEntityOnUnblockedLand(TraitorKnight.Type, x, y, 0, VestholmPlayerID)

    killTraitorID = QuestTemplate:New("Quest_KillTheTraitor", 1, 1,
        { { Objective.DestroyEntities, 1, { TraitorKnight.ID } } },
        { { Triggers.Time, 0 } },
        0, 
        { { Reward.PrestigePoints, 5000 } }, 
        nil, OnTraitorKilled, nil, true, false)

    LaunchFinalAttack = true
end


function SetupVictoryDialog()

    VictoryDialogStart = Logic.GetTime()
    RedPricePlayerID = SetupPlayer(7, "H_Knight_RedPrince",  "CityofVestholm", "CityColor1")
    StartSimpleJob("ShowVictoryDialogAfterOneSecond")

end

function ShowVictoryDialogAfterOneSecond()

    if Logic.GetTime() >= VictoryDialogStart + 1 then
    
        local QuestID_DummyVictory = QuestTemplate:New("", 1, 1, 
                            { { Objective.Dummy }}, 
                            {{Triggers.Time, 0}}, 
                            0, 
                            { { Reward.CampaignMapFinished } }, 
                            nil,nil, nil, false)    -- dont show this quest   

        
        GenerateVictoryDialog({{1,"Victory_StoppedTheTraitor" },
                            {RedPricePlayerID,"Victory_RedPrinceRetreats" },
                            {VestholmPlayerID,"Victory_Traitor" }}, QuestID_DummyVictory)
       
       return true
        
    end

end



function OnTraitorKilled(_Quest)
    if _Quest.Result == QuestResult.Success then
        MoveTraitor_Stop = true
--        Logic.DestroyEntity(TraitorKnight.ID)

        SetupVictoryDialog()

    end
end


function InitializeKnights()
    AllKnights = {
        [1] = { Text = "NPCTalk_FreedTrading"; Type = Entities.U_KnightTrading; Face ="H_Knight_Trading" };
        [2] = { Text = "NPCTalk_FreedHealing"; Type = Entities.U_KnightHealing; Face ="H_Knight_Healing" };
        [3] = { Text = "NPCTalk_FreedPlunder"; Type = Entities.U_KnightPlunder; Face ="H_Knight_Plunder" };
        [4] = { Text = "NPCTalk_FreedWisdom"; Type = Entities.U_KnightWisdom; Face ="H_Knight_Wisdom" };
        [5] = { Text = "NPCTalk_FreedSong"; Type = Entities.U_KnightSong; Face ="H_Knight_Song" };
        [6] = { Text = "NPCTalk_FreedChivalry"; Type = Entities.U_KnightChivalry; Face ="H_Knight_Chivalry" };
    };

    local traitorEntityType = GlobalGetTraitor()
    local OwnKnightType = Logic.GetEntityType(Logic.GetKnightID(1))
    
    for i=1, #AllKnights do
        
        if traitorEntityType == AllKnights[i].Type then
            TraitorKnight = AllKnights[i]
        end
        
        if OwnKnightType == AllKnights[i].Type then
            YourKnight = AllKnights[i]
        end
        
    end

    TraitorKnight.Used = true
    YourKnight.Used = true

    --SetupPlayer(1, YourKnight.Face, "City of Vestholm", "CityColor1")
    SetupPlayer(2, TraitorKnight.Face, "City of Vestholm", "RedPrinceColor")
-- not sure about this.
--    Logic.DestroyEntity(Logic.GetKnightID(1))
--    local startPos = { Logic.GetPlayerEntities(1, Entities.XD_StartPosition, 1, 0) }
--    local x, y = Logic.GetEntityPosition(startPos[1])
--    Logic.CreateEntityOnUnblockedLand(YourKnight.Type, x, y, 0, 1)
    local n = 1
    for i=1, 4 do
        while AllKnights[n] == YourKnight or AllKnights[n] == TraitorKnight do
            n = n+1
        end
--        SetupPlayer(i+4, AllKnights[n].Face, "Vestholm", "CityColor1")
        AllKnights[n].PlayerID = i+4
    end
end

----------------------------------------------------------------------------------------------------------------------
-- Other callbacks
----------------------------------------------------------------------------------------------------------------------

function OnPrisonLocationsStole()
    LaunchPrisonCart()

    InitPrison(PrisonIslandID)


-- 2nd knight
----------------------------------------------------------------------------------------------------------------------

    freeSecondKnightID = QuestTemplate:New("Quest_FreeSecondKnightPrisonCart", 1, 1,
        {{ Objective.Capture, 1, { PrisonCart } }},
        {{ Triggers.Quest, stealPrisonLocationsID, QuestResult.Success }},
        365, 
        { { Reward.PrestigePoints, 1200 } }, 
        { {Reprisal.Defeat } }, OnPrisonCartCaptured, nil, true, false)

-- 4th knight
----------------------------------------------------------------------------------------------------------------------

    if Quests[destroyBanditsID].Result == nil then
        findBanditsID = QuestTemplate:New("Quest_FreeFourthKnightFindBandits", 1, 1,
            {{ Objective.Discover, 2, { CalhadorHoldPlayerID }}},
            {{ Triggers.Quest, freeSecondKnightID, QuestResult.Success }, { Triggers.PlayerDiscovered, CalhadorHoldPlayerID }},
            0, 
            { { Reward.PrestigePoints, 1200 } }, 
            nil, nil, nil, true, false)
    
        bargainBanditsID = QuestTemplate:New("Quest_FreeFourthKnightBargainBandits", CalhadorHoldPlayerID, 1,
            {{Objective.Deliver, Goods.G_Gold, 2000 }},
            {{Triggers.Quest, findBanditsID, QuestResult.Success}},
            0, 
            { { Reward.PrestigePoints, 1200 } }, 
            nil, OnBargainFinished, nil, true, false)
    end


-- Overall
----------------------------------------------------------------------------------------------------------------------

    overallGoalsID = QuestTemplate:New("Quest_OverallGoals", 1, 1,
        { { Objective.Quest, { freeUseFirstKnightID, freeSecondKnightID, freeThirdKnightID, destroyBanditsID } }},
        {{ Triggers.Quest, reachStartPositionID, QuestResult.Success }},
        0, nil, {{Reprisal.Defeat}}, OnOverallGoalsFinished, nil, true, false)

end

function OnOverallGoalsFinished()
    LaunchEndQuest()
end

function OnStartPositionReached(_Quest)
    if _Quest.Result == QuestResult.Success then        
        Quests[protectKnightID]:Success()
    end
end

function InitPrison(entityID)
    Logic.InteractiveObjectClearCosts(entityID)
    Logic.InteractiveObjectSetInteractionDistance(entityID, 1000)
    Logic.InteractiveObjectSetTimeToOpen(entityID, 10)
    Logic.InteractiveObjectSetAvailability(entityID, true)
    Logic.InteractiveObjectSetPlayerState(entityID, 1, 0)
end

TraitorCounter = 10
MoveTraitor_Stop = false
function MoveTraitor()
    if MoveTraitor_Stop then
        return true
    end

    if battalionList == nil then
        TraitorCounter = 10
        --local bl = GetPlayerEntities(2, Entities.U_MilitaryBow)
        battalionList = {}
        for i=1, #TroupsToFollow do
            if Logic.IsLeader(TroupsToFollow[i]) then
                battalionList[#battalionList+1] = TroupsToFollow[i]
            end
        end
    end

    -- end
    if #battalionList == 0 then
        return true
    end

    TraitorCounter = TraitorCounter - 1
    if TraitorCounter < 0 then
        local x = 0
        local y = 0
        for j = 1, #battalionList do
            if Logic.IsEntityDestroyed(battalionList[j]) or battalionList[j] == 0 then
                battalionList[j] = battalionList[#battalionList]
                battalionList[#battalionList] = nil
                return
            end
            local xp, yp = Logic.GetEntityPosition(battalionList[j])
            x = x + xp
            y = y + yp
        end
        x = x / #battalionList
        y = y / #battalionList
        Logic.MoveSettler(TraitorKnight.ID, x, y)
    end
end

----------------------------------------------------------------------------------------------------------------------
-- PrisonCart
----------------------------------------------------------------------------------------------------------------------

function LaunchPrisonCart()
    local x, y = Logic.GetBuildingApproachPosition(Logic.GetEntityIDByName("PrisonVillage"))
    prisonX, prisonY = x, y
    PrisonCart = Logic.CreateEntityOnUnblockedLand(Entities.U_PrisonCart, x, y, 0, CalhadorHoldPlayerID)
    StartSimpleJob("WaitThenStartPrisonCart")
end

function UpdatePrisonCartPosition()
    prisonX, prisonY = Logic.GetEntityPosition(PrisonCart)
end

function TerminatePrisonCart()
    Logic.DestroyEntity(PrisonCart)
    Quests[freeSecondKnightID]:Fail()
end

function WaitThenStartPrisonCart()
    if cartCounter == nil then
        cartCounter = 10
    end
    
    cartCounter = cartCounter - 1

    if cartCounter < 0 then
        Path:new(PrisonCart, { "PrisonCartRoute01", "PrisonCartRoute02", "PrisonCartRoute03", "PrisonCartRoute04",
            "PrisonCartRoute04", "PrisonCartRoute05", "PrisonCartRoute06", "PrisonCartRoute07",
            "PrisonCartRoute08", "PrisonCartRoute09", "PrisonCartRoute10" }, false, false, TerminatePrisonCart, nil, false, UpdatePrisonCartPosition)
        return true
    end
end


----------------------------------------------------------------------------------------------------------------------
-- Ship reinforcements
----------------------------------------------------------------------------------------------------------------------

function OnDocksReached()
    SendVoiceMessage(HarborPlayerID, "NPCTalk_HarbourContact")
    Path:new(shipID, { "ShipAtHarbor", "ShipAtSea" } , false, false, OnShipLeavingMap, nil, true)
end

function InitializeShip()
    x, y = Logic.GetEntityPosition(Logic.GetEntityIDByName("ShipAtHarbor"))
    shipID = Logic.CreateEntity(Entities.D_X_TradeShip, x, y, 0, 3)
end

function OnShipLeavingMap()
    Logic.DestroyEntity(shipID)
    StartSimpleJob("ShipComeback")
end

function ShipComeback()
    if shipComebackCounter == nil then
        shipComebackCounter = 400
    end

    shipComebackCounter = shipComebackCounter - 1
    if shipComebackCounter < 0 then
        local x, y = Logic.GetEntityPosition(Logic.GetEntityIDByName("ShipAtSea"))
        shipID = Logic.CreateEntity(Entities.D_X_TradeShip, x, y, 0, 3)
        Path:new(shipID, { "ShipAtSea", "ShipAtHarbor" } , false, false, OnShipReturningToHarbor, nil, true)
        return true
    end
end

function OnShipReturningToHarbor()
    local x, y = Logic.GetEntityPosition(Logic.GetEntityIDByName("ReinforcementSpawn"))
    -- increased base value by 1 to make the reinforcements more useful
    NumberOfReinforcements = 3 + Logic.GetRandom(2)
    
    local rand = Logic.GetRandom(10)
    
    local MecrenariesFromClimatzone = "NA"
    
    if rand <= 3 then
        MecrenariesFromClimatzone = "NE"
    elseif rand > 6 then
        MecrenariesFromClimatzone = "SE"
    end

    for i=1, NumberOfReinforcements-1 do
		-- increased x-value to allow the reinforcements to spawn
        Logic.CreateBattalionOnUnblockedLand(Entities["U_MilitaryBandit_Melee_" ..MecrenariesFromClimatzone], x+50, y, 0, 1)
    end
    Logic.CreateBattalionOnUnblockedLand(Entities["U_MilitaryBandit_Ranged_" ..MecrenariesFromClimatzone], x+50, y, 0, 1)
    
    FlexibalPlayerID = SetupPlayer(8, "H_NPC_Mercenary_" .. MecrenariesFromClimatzone,  "Vestholm Harbor", "TravelingSalesmanColor")

    FlexibalPlayerVoiceStart = Logic.GetTime()
    FlexibalPlayerVoiceText =  "NPCTalk_Reinforcements".. MecrenariesFromClimatzone
    StartSimpleJob("StartFlexibalPlayerVoiceAfterOneSecond")
end

function StartFlexibalPlayerVoiceAfterOneSecond()
    if Logic.GetTime()  >= FlexibalPlayerVoiceStart + 1 then
        SendVoiceMessage(FlexibalPlayerID, FlexibalPlayerVoiceText )
        return true
    end
end

----------------------------------------------------------------------------------------------------------------------
-- Vestholm AI profile
----------------------------------------------------------------------------------------------------------------------
LaunchFinalAttack_done = false
function AIProfile_Sabbata(self)
        
    if self.m_Behavior["AttackCity"] == nil then
        if LaunchFinalAttack == true then
            if LaunchFinalAttack_done == false then
                LaunchFinalAttack_done = true
                local what, troups = AIScript_SpawnAndAttackCity(VestholmPlayerID, Logic.GetStoreHouse(1), Logic.GetEntityIDByName("AISpawn"), 8, 8, 4, 1, 1, 3)
                TroupsToFollow = troups
                StartSimpleJob("MoveTraitor")
            else
                self.m_Behavior["AttackCity"] = self:GenerateBehaviour(AIBehavior_AttackCity)
                self.m_Behavior["AttackCity"].m_MinNumberOfSwordsmen = 1
                self.m_Behavior["AttackCity"].m_MinNumberOfBowmen = 1
                self.m_Behavior["AttackCity"].m_MinNumberOfCatapults = 0
                self.m_Behavior["AttackCity"].m_MinNumberOfRams = 0
                self.m_Behavior["AttackCity"].m_MinNumberOfTowers = 0
                self.m_Behavior["AttackCity"].m_MaxNumberOfSwordsmen = 8
                self.m_Behavior["AttackCity"].m_MaxNumberOfBowmen = 8
                self.m_Behavior["AttackCity"].m_MaxNumberOfCatapults = 1
                self.m_Behavior["AttackCity"].m_FleeNumberOfCatapults = 0
                self.m_Behavior["AttackCity"].m_FleeNumberOfBowmen = 0
                self.m_Behavior["AttackCity"].m_FleeNumberOfSwordsmen = 0

                if (self.m_Behavior["AttackCity"]:Start() == false) then
                    self.m_Behavior["AttackCity"] = nil;
                end
            end
        elseif KnightJustFreed == true then
            self.m_Behavior["AttackCity"] = self:GenerateBehaviour(AIBehavior_AttackCity)
            self.m_Behavior["AttackCity"].m_MinNumberOfSwordsmen = 2
            self.m_Behavior["AttackCity"].m_MinNumberOfBowmen = 2
            self.m_Behavior["AttackCity"].m_MinNumberOfCatapults = 0
            self.m_Behavior["AttackCity"].m_MinNumberOfRams = 0
            self.m_Behavior["AttackCity"].m_MinNumberOfTowers = 0
            self.m_Behavior["AttackCity"].m_MaxNumberOfSwordsmen = 4
            self.m_Behavior["AttackCity"].m_MaxNumberOfBowmen = 4
            self.m_Behavior["AttackCity"].m_MaxNumberOfCatapults = 1
            self.m_Behavior["AttackCity"].m_FleeNumberOfCatapults = 0
            self.m_Behavior["AttackCity"].m_FleeNumberOfBowmen = 0
            self.m_Behavior["AttackCity"].m_FleeNumberOfSwordsmen = 0

            if (self.m_Behavior["AttackCity"]:Start() == false) then
                self.m_Behavior["AttackCity"] = nil;
            else
                KnightJustFreed = false
            end
        end
    end
end

function AIBehavior_AttackCity:FindTargetEntity()
    return Logic.GetStoreHouse(1)
end


HACK_DestroyAllMilitaryUnits_Counter = 0

function HACK_DestroyAllMilitaryUnits()

    for PlayerID=1, 2 do
    
        local NPC_Melee_NE = GetPlayerEntities(PlayerID, Entities.U_MilitarySword)
        for i=1,#NPC_Melee_NE do   
            Logic.DestroyEntity(NPC_Melee_NE[i])        
        end  
    
        local NPC_Ranged_NE = GetPlayerEntities(PlayerID, Entities.U_MilitaryBow)
        for i=1,#NPC_Ranged_NE do   
            Logic.DestroyEntity(NPC_Ranged_NE[i])
        end  
        
    end
    
    -- stop after 20 seconds
    HACK_DestroyAllMilitaryUnits_Counter = HACK_DestroyAllMilitaryUnits_Counter + 1    
    if (HACK_DestroyAllMilitaryUnits_Counter > 20) then        
        return true
    end
         
end


function PresentationStartVikings()
    
    CreateSpousesForPlayer(3)
    
    Viking.m_StartAttackMonth = Logic.GetCurrentMonth()
    Viking.m_TargetID = Logic.GetStoreHouse(3)
    Viking.m_NumberOfVikings = 4
    Viking.m_AttackInstant = true
end

function Mission_Victory()

    Quests[protectKnightID]:Interrupt()

    local x, y = Logic.GetEntityPosition(Logic.GetEntityIDByName("VictoryPrisonCartPath0"))
    local TraitorPrisonCart = Logic.CreateEntityOnUnblockedLand(Entities.U_PrisonCart, x, y, 0, 1)    
    
    local x, y = Logic.GetEntityPosition(Logic.GetEntityIDByName("VictorySpawnLeader"))
    local Leader = Logic.CreateBattalionOnUnblockedLand(Entities.U_MilitaryBow, x, y, 0, 1, 6)    
    Logic.GroupGuard(Leader, TraitorPrisonCart)
    
    Path:new(TraitorPrisonCart, { "VictoryPrisonCartPath0", "VictoryPrisonCartPath1" } , false)        
    
    
    local VictoryKnightPos = Logic.GetEntityIDByName("VictoryKnightSpawn")
    local x,y = Logic.GetEntityPosition(VictoryKnightPos)
    local Orientation = Logic.GetEntityOrientation(VictoryKnightPos)
    VictorySetEntityToPosition( Logic.GetKnightID(1), x, y, Orientation )
   

    local TopSettlerPos = Logic.GetEntityIDByName("VictorySettler1")
    local TopX,TopY = Logic.GetEntityPosition(TopSettlerPos)
    local TopOrientation = Logic.GetEntityOrientation(TopSettlerPos)
    local SettlerID = Logic.CreateEntityOnUnblockedLand(Entities.U_SwordSmith, TopX,TopY, TopOrientation-90, SanRamosPlayerID ) 
    Logic.SetTaskList(SettlerID, TaskLists.TL_WORKER_FESTIVAL_APPLAUD_SPEECH)
    
    local DownSettlerPos = Logic.GetEntityIDByName("VictorySettler2")
    local DownX,DownY = Logic.GetEntityPosition(DownSettlerPos)
    local DownOrientation = Logic.GetEntityOrientation(DownSettlerPos)
    local SettlerID = Logic.CreateEntityOnUnblockedLand(Entities.U_Armourer, DownX,DownY, DownOrientation-90, SanRamosPlayerID ) 
    Logic.SetTaskList(SettlerID, TaskLists.TL_WORKER_FESTIVAL_APPLAUD_SPEECH)

    

end


