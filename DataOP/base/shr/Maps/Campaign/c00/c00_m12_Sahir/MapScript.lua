Script.Load("Script\\Global\\CampaignHotfix.lua")

CurrentMapIsCampaignMap = true
----------------------------------------------------------------------------------------------------------------------
function Mission_InitPlayers()

    SabattaPlayerID = SetupPlayer(2, "H_Knight_Sabatt", "Jumajir", "RedPrinceColor")

    NorthExcarvationPlayerID = SetupPlayer(3, "H_NPC_Mercenary_NA", "Twanzur Excarvation", "VillageColor1")
    WestExcarvationPlayerID = SetupPlayer(4, "H_NPC_Villager01_SE", "Jum am Excavation", "VillageColor2")
    EastExcarvationPlayerID = SetupPlayer(5, "H_NPC_Castellan_NA", "Tijah Excavation", "VillageColor3")
    
    CloisterPlayerID = SetupPlayer(6, "H_NPC_Monk_NA", "Quabiyar Cloister", "CloisterColor1")
    VillagePlayerID = SetupPlayer(7, "H_NPC_Villager01_NA", "Sabralant Village", "CloisterColor2")
    
    -- set some resources for player 1
    AddResourcesToPlayer(Goods.G_Gold,250)
    AddResourcesToPlayer(Goods.G_Stone,50)
    AddResourcesToPlayer(Goods.G_Wood,50)
    AddResourcesToPlayer(Goods.G_Grain,10)
    AddResourcesToPlayer(Goods.G_Carcass,10)
    AddResourcesToPlayer(Goods.G_RawFish,10)
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
	
	SetDiplomacyState(1, NorthExcarvationPlayerID, DiplomacyStates.Undecided)
	SetDiplomacyState(1, WestExcarvationPlayerID, DiplomacyStates.Undecided)
	SetDiplomacyState(1, EastExcarvationPlayerID, DiplomacyStates.Undecided)
	
	SetDiplomacyState(1, CloisterPlayerID, DiplomacyStates.Undecided)
	SetDiplomacyState(1, VillagePlayerID, DiplomacyStates.Undecided)
	
	
	SetDiplomacyState(SabattaPlayerID, NorthExcarvationPlayerID, DiplomacyStates.Undecided)
	SetDiplomacyState(SabattaPlayerID, WestExcarvationPlayerID, DiplomacyStates.Undecided)
	SetDiplomacyState(SabattaPlayerID, EastExcarvationPlayerID, DiplomacyStates.Enemy)
	
    
    SetKnightTitle(SabattaPlayerID, KnightTitles.Duke)
	
	GameCallback_CreateKnightByTypeOrIndex(Entities.U_KnightSabatta, SabattaPlayerID)
end
----------------------------------------------------------------------------------------------------------------------
function Mission_SetStartingMonth()

    Logic.SetMonthOffset(3)

end
----------------------------------------------------------------------------------------------------------------------
function Mission_InitMerchants()

    local playerId = 1

    local traderId = Logic.GetStoreHouse(7)
    AddOffer			(traderId,	 5,Goods.G_RawFish)
	AddOffer			(traderId,	 5,Goods.G_Cow)
	AddOffer			(traderId,	 5,Goods.G_Sheep)

	local traderId = Logic.GetStoreHouse(6)
	AddOffer			(traderId,	 5,Goods.G_Herb)
	
end
----------------------------------------------------------------------------------------------------------------------
function Mission_FirstMapAction()

    NumRegalias = {}
    
    NumRegalias[1] = 0
    NumRegalias[SabattaPlayerID] = 0
    
    NumRegalias[NorthExcarvationPlayerID]= 1
    NumRegalias[WestExcarvationPlayerID] = 1
    NumRegalias[EastExcarvationPlayerID] = 1
    
    --MissionCounter.CurrentAmount = NumRegalias[1]
    
    StartMissionGoodCounter(Goods.G_Regalia, 3)
    
    -- AI
    AIPlayer:new(SabattaPlayerID, AIProfile_Sabatta, Entities.U_KnightSabatta)
    AIPlayer:new(WestExcarvationPlayerID, AIPlayerProfile_Village)

    -- Setup Quests
    Mission_SetupQuests()
    
    StartSimpleJob("CheckIfRegaliaCartIsNearCastle")
    StartSimpleJob("CheckIfSabattasThiefHasStolenRegalia")
    StartSimpleJob("CheckIfSabattasCastleLost")
    
    
end


function Mission_SetupQuests()
    
    --QUEST TO MAKE PLAYERS ESTABLISHED CONTACT
    QuestTemplate:New("", WestExcarvationPlayerID, 1, 
                        { { Objective.Discover, 2, {WestExcarvationPlayerID} } },
                        { { Triggers.Time, 0}},  
                        0, 
                         { { Reward.Diplomacy, WestExcarvationPlayerID, 1 }},
                        nil, nil, nil, false)

    QuestTemplate:New("", EastExcarvationPlayerID, 1, 
                        { { Objective.Discover, 2, {EastExcarvationPlayerID} } },
                        { { Triggers.Time, 0}},  
                        0, 
                         { { Reward.Diplomacy, EastExcarvationPlayerID, 2 }},
                        nil, OnEastExcarvationDiscovered, nil, false)


    QuestTemplate:New("", NorthExcarvationPlayerID, 1, 
                        { { Objective.Discover, 2, {NorthExcarvationPlayerID} } },
                        { { Triggers.Time, 0}},  
                        0, 
                         { { Reward.Diplomacy, NorthExcarvationPlayerID, 1 }},
                        nil, OnNorthExcarvationDiscovered, nil, false)

    QuestTemplate:New("Quest_CloisterDiscovered", CloisterPlayerID, 1, 
                        { { Objective.Discover, 2, {CloisterPlayerID} } },
                        { { Triggers.Time, 0}},  
                        0, 
                         { { Reward.Diplomacy, CloisterPlayerID, 2 }},
                        nil, nil, nil, false, true)


    QuestTemplate:New("Quest_VillageDiscovered", VillagePlayerID, 1, 
                        { { Objective.Discover, 2, {VillagePlayerID} } },
                        { { Triggers.Time, 0}},  
                        0, 
                         { { Reward.Diplomacy, VillagePlayerID, 2 }},
                        nil, nil, nil, false, true)
    


    -- global quest
    local mainQuest = QuestTemplate:New("Quest_GetAllRegalia", 1, 1,
                                        { { Objective.Custom, Custom_GetAllRegalia } },
                                        { { Triggers.Time, 0}},  
                                        0, 
                                        { {Reward.PrestigePoints, 5000}, { Reward.CampaignMapFinished } }, 
                                        { {Reprisal.Defeat}}, 
                                        nil, nil, true, false)

    GenerateVictoryDialog({{VillagePlayerID,"Victory_AfricansJoin" },
                            {SabattaPlayerID,"Victory_Wholaughslast" }}, mainQuest)
    

    QuestTemplate:New("Quest_DiscoverTheThreeExcarvations", 1, 1, 
                        {   { Objective.Discover, 2, {NorthExcarvationPlayerID} },
                            { Objective.Discover, 2, {EastExcarvationPlayerID} },
                            { Objective.Discover, 2, {WestExcarvationPlayerID} } },
                        { { Triggers.Time, 0}},  
                        0,nil,nil, nil, nil, true, false)


    --NORTH EXCARVATION: PAY GOLD AFTER MAYOR
    local triggerBecomeMayor = QuestTemplate:New("", NorthExcarvationPlayerID, 1, 
                                                { { Objective.KnightTitle, KnightTitles.Mayor  } },
                                                { { Triggers.Time, 0}},
                                                0, 
                                                {{Reward.PrestigePoints, 500}}, 
                                                nil, nil, nil, false)

    QuestTemplate:New("Quest_FirstExcavationRequest", NorthExcarvationPlayerID, 1,
                                                    {{Objective.Deliver, Goods.G_Gold, 500 }},
                                                    {{Triggers.Quest, triggerBecomeMayor, QuestResult.Success},
                                                    {Triggers.PlayerDiscovered, NorthExcarvationPlayerID}}, 
                                                    60 * 20, 
                                                    { { Reward.PrestigePoints, 1000 } }, 
                                                    nil, OnRegaliaPayed)

    --WEST EXCARVATION: DELIVER GOOD REGULARY
    local firstExcavationRequest = QuestTemplate:New("Quest_SecondExcavationFirstRequest", WestExcarvationPlayerID, 1,
                                                    {{Objective.Deliver, Goods.G_Wood, 50 }},
                                                    {{Triggers.PlayerDiscovered, WestExcarvationPlayerID}}, 
                                                    60 * 20,
                                                    { { Reward.PrestigePoints, 800 } },
                                                    { {Reprisal.Defeat}})
    
    local secondExcavationRequest = QuestTemplate:New("Quest_SecondExcavationSecondRequest", WestExcarvationPlayerID, 1,
                                                        {{Objective.Deliver, Goods.G_Sausage, 6 }},
                                                        {{Triggers.Quest, firstExcavationRequest, QuestResult.Success}}, 
                                                        60 * 20,
                                                        { { Reward.PrestigePoints, 1200 } },
                                                        { {Reprisal.Defeat}})

    local thirdExcavationRequest = QuestTemplate:New("Quest_SecondExcavationThirdRequest", WestExcarvationPlayerID, 1,
                                                        {{Objective.Deliver, Goods.G_Medicine, 6 }},
                                                        {{Triggers.Quest, secondExcavationRequest, QuestResult.Success}}, 
                                                        60 * 30,
                                                        { { Reward.PrestigePoints, 1600 } },
                                                        { {Reprisal.Defeat}})
    
    
    local fourthExcavationRequest = QuestTemplate:New("Quest_SecondExcavationFourthRequest", WestExcarvationPlayerID, 1,
                                                        {{Objective.Deliver, Goods.G_Broom, 6 }},
                                                        {{Triggers.Quest, thirdExcavationRequest, QuestResult.Success}}, 
                                                        60 * 30,
                                                        { { Reward.PrestigePoints, 1600 } },
                                                        { {Reprisal.Defeat}},
                                                        OnRegaliaInMineFound)

    -- EAST EXCARVATION: Protect excarvation for a certain time, after Baron
    local triggerBecomeBaron = QuestTemplate:New("", EastExcarvationPlayerID, 1, 
                                                { { Objective.KnightTitle, KnightTitles.Baron  } },
                                                { { Triggers.Time, 0}},
                                                0, 
                                                nil, 
                                                nil, OnPlayerBecameBaron, nil, false)


    local ExcarvationStoreHouseID = Logic.GetStoreHouse(EastExcarvationPlayerID)    
    protectEastExcarvation = QuestTemplate:New("Quest_ThirdExcavationRequest", EastExcarvationPlayerID, 1,
                        {{Objective.Protect, { ExcarvationStoreHouseID }}}, 
                        {{Triggers.Quest, triggerBecomeBaron, QuestResult.Success},
                        {Triggers.PlayerDiscovered, EastExcarvationPlayerID}}, 
                        60 * 60, 
                        { { Reward.PrestigePoints, 2400 } }, 
                        { {Reprisal.Defeat}},
                        OnRegaliaFoundInEastExcarvation)
    
    
    
   
end


function OnEastExcarvationDiscovered()

    EastExcarvationSideDiscovered = true

    local KnightTitle = Logic.GetKnightTitle(1)
    
    if KnightTitle < KnightTitles.Baron then
        
        QuestTemplate:New("Quest_EastExcarvationBecomeBaron", EastExcarvationPlayerID, 1, 
                            { { Objective.KnightTitle, KnightTitles.Baron  } },
                            { { Triggers.Time, 0}},
                            0, 
                            nil, 
                            nil, bil, nil, true, false)
        
    end

end


function OnNorthExcarvationDiscovered()

    local KnightTitle = Logic.GetKnightTitle(1)

    if KnightTitle < KnightTitles.Mayor then        
        QuestTemplate:New("Quest_NorthExcarvationBecomeMayor", NorthExcarvationPlayerID, 1, 
                            { { Objective.KnightTitle, KnightTitles.Mayor  } },
                            { { Triggers.Time, 0}},
                            0, 
                            nil, 
                            nil, nil, nil, true, false)
    end

    
end


function OnPlayerBecameBaron()
    --set attack time
    NextExcarvationAttackTime = Logic.GetTime() --+ 60 * 15
end


function Custom_GetAllRegalia(_Quest)

    -- I used this function to update the interface
    MissionCounter.CurrentAmount = NumRegalias[1]
    
    
    --Logic.DEBUG_AddNote(SabattaPlayerID ..":" ..NumRegalias[SabattaPlayerID] .."-----" ..  WestExcarvationPlayerID ..":" ..NumRegalias[WestExcarvationPlayerID] .."-----" .. NorthExcarvationPlayerID ..":" ..NumRegalias[NorthExcarvationPlayerID] .."-----" .. EastExcarvationPlayerID ..":" ..NumRegalias[EastExcarvationPlayerID])
    
    if NumRegalias[SabattaPlayerID] == 3 then
        
        SendVoiceMessage(SabattaPlayerID,"NPCTalk_SabattaGotAllRegalia")
        
        _Quest:Fail()
    end
    
    
    if NumRegalias[1] == 3 then
        return true
    end
    
end


function OnRegaliaPayed(_Quest)
    
    local TargetPlayer
    
    if _Quest.Result == QuestResult.Failure then
        TargetPlayer = SabattaPlayerID
    else
        TargetPlayer = 1
    end
    
    SendRegaliaToPlayer(TargetPlayer, NorthExcarvationPlayerID)
    
end

function OnRegaliaInMineFound(_Quest)
    
    if _Quest.Result == QuestResult.Success then
        SendRegaliaToPlayer(1, WestExcarvationPlayerID)
    end
    
end

function OnRegaliaFoundInEastExcarvation(_Quest)
    
    if _Quest.Result == QuestResult.Success then
        SendRegaliaToPlayer(1, EastExcarvationPlayerID)
        StopAttackOnExcarvationSite = true
    end
    
end


function CheckIfRegaliaCartIsNearCastle()

    if RegaliaCarts == nil or #RegaliaCarts == 0 then
        return
    end
    
    for i=1,#RegaliaCarts do
        
        local RegaliaCartID = RegaliaCarts[i][1]
        
        if Logic.IsEntityAlive(RegaliaCartID) then
            
            local PlayerID = Logic.EntityGetPlayer(RegaliaCartID)
            local CastleID = Logic.GetHeadquarters(PlayerID)
            
            if Logic.GetDistanceBetweenEntities(CastleID, RegaliaCartID) < 1500 then
                
                NumRegalias[PlayerID] = NumRegalias[PlayerID] + RegaliaCarts[i][2]
                
                if PlayerID == SabattaPlayerID then
                    Quests[recaptureRegaliaCart]:Fail()
                end
                
                table.remove(RegaliaCarts, i)
            end
            
        else
            table.remove(RegaliaCarts, i)
        end
        
    end
    
end


function MissionCallback_OnThiefStealBuilding(_ThiefID, _ThiefPlayerID, _BuildingID, _BuildingPlayerID)
   
   if Logic.GetHeadquarters(_BuildingPlayerID) ==  _BuildingID then
   
        if NumRegalias[_BuildingPlayerID] > 0 then
   
           Logic.DestroyEntity(_ThiefID)
           
           SendRegaliaToPlayer(_ThiefPlayerID, _BuildingPlayerID, NumRegalias[_BuildingPlayerID])
        
        else
        
            if _ThiefPlayerID == 1 then
                SendVoiceMessage(1,"NPCTalk_ThiefFoundEmptyCastle")
            end
            
        end
       
    end
   
end

function SendRegaliaToPlayer(_TargetPlayerID, _SendingPlayerID, _RegaliaAmount)
    
    if _RegaliaAmount == nil then
        _RegaliaAmount = 1
    end
    
    --substarct regalias
    NumRegalias[_SendingPlayerID] = NumRegalias[_SendingPlayerID] - _RegaliaAmount
    
    local SpawnBuilding = Logic.GetHeadquarters(_SendingPlayerID)
    
    if SpawnBuilding == nil or SpawnBuilding == 0 then
        SpawnBuilding = Logic.GetStoreHouse(_SendingPlayerID)
    end
    
    
    local RegaliaCartID
    
    if _SendingPlayerID == SabattaPlayerID and Logic.GetHeadquarters(SabattaPlayerID) == 0 then        
        local x,y = Logic.GetEntityPosition(Logic.GetEntityIDByName("CrimsonSabattRegaliaCartSpawnPoint"))
        RegaliaCartID = Logic.CreateEntityOnUnblockedLand(Entities.U_RegaliaCart,x,y,0,_TargetPlayerID)
    else
        --spawn and hire cart
        RegaliaCartID = Logic.CreateEntityAtBuilding(Entities.U_RegaliaCart, SpawnBuilding, 0, _TargetPlayerID)
    end
    
    Logic.HireMerchant(RegaliaCartID, _TargetPlayerID, Goods.G_Gold, 1, _SendingPlayerID)

    --generate escort quest, if it is the player
    if _TargetPlayerID == 1 then
            QuestTemplate:New("Quest_EscortRegalia", 1, 1, 
                             {{Objective.Distance, RegaliaCartID, Logic.GetHeadquarters(1)}},
                             {{Triggers.Time, 0 }}, 
                             0)
            if StealQuestTriggered == true then
                Quests[stealRegaliaQuest]:Success()
            end
    end
    
    --steal quest is finished
    if _SendingPlayerID == SabattaPlayerID then
        StealQuestTriggered = nil
    end
    
    --Update regalia carts list
    if RegaliaCarts == nil then
        RegaliaCarts = {}
    end
    
    local Cartinfo = {RegaliaCartID, _RegaliaAmount}
    
    table.insert(RegaliaCarts, Cartinfo)
    
    
end


function MapCallback_EntityCaptured(_OldEntityID, _OldEntityPlayerID, _NewEntityID, _NewEntityPlayerID)

    if RegaliaCarts == nil or #RegaliaCarts == 0 then
        return
    end
    
    for i=1,#RegaliaCarts do
        
        local RegaliaCartID = RegaliaCarts[i][1]
        
        if _OldEntityID == RegaliaCartID then
            
            RegaliaCarts[i][1] = _NewEntityID    
            
            if _OldEntityPlayerID == 1 then
                SendVoiceMessage(SabattaPlayerID,"NPCTalk_SabattaStopsThief")
            end
            
        end
        
    end
    
end


function CheckIfSabattasThiefHasStolenRegalia()
    
    if NumRegalias[SabattaPlayerID] > 0 then
    
        if StealQuestTriggered == nil then
            stealRegaliaQuest = QuestTemplate:New("Quest_StealRegalia", 1, 1,
                                        { { Objective.Steal, 1, { Logic.GetHeadquarters(SabattaPlayerID) } } },
                                        { {Triggers.Time, 0 } },
                                        0)
            StealQuestTriggered = true
        end
    end
    
    
    if RegaliaCarts == nil or #RegaliaCarts == 0 then
        return
    end
    
    for i=1,#RegaliaCarts do
        
        local RegaliaCartID = RegaliaCarts[i][1]
    
        if Logic.IsEntityAlive(RegaliaCartID) then
            
            local PlayerID = Logic.EntityGetPlayer(RegaliaCartID)
            
            if CaptureQuestHasBeenTriggered == nil and PlayerID == SabattaPlayerID then
                
                local TerritoryCartIsIn = GetTerritoryUnderEntity(RegaliaCartID)
                
                local TerritoryInFrontOfThePlayer = 6
                local TerritoryOnTheWayToSabbata = 14
                local TerritoryExcarvationSiteNorth = 5
                
                local TerritoryToReactOn = TerritoryInFrontOfThePlayer
                
                if Logic.GetTerritoryPlayerID(TerritoryInFrontOfThePlayer) == 1 then
                    TerritoryToReactOn = TerritoryOnTheWayToSabbata
                end
                
                
                if TerritoryCartIsIn == TerritoryExcarvationSiteNorth then
                     
                     recaptureRegaliaCart = QuestTemplate:New("Quest_CaptureRegalia", 1, 1, 
                                            {{Objective.Capture, 2, Entities.U_RegaliaCart,1,SabattaPlayerID}}, 
                                            {{Triggers.Time, 0}},
                                            0, nil, nil, OnSabattasCartCaptured)
                                        
                     CaptureQuestHasBeenTriggered = true
                
                elseif TerritoryCartIsIn == TerritoryToReactOn then
                    
                    recaptureRegaliaCart = QuestTemplate:New("Quest_CaptureThiefCart", 1, 1, 
                                            {{Objective.Capture, 2, Entities.U_RegaliaCart,1,SabattaPlayerID}}, 
                                            {{Triggers.Time, 0}},
                                            0, nil, nil, OnSabattasCartCaptured)
                                        
                    CaptureQuestHasBeenTriggered = true
                    
                end
       
            end
        end
    end
   
end

function CheckIfSabattasCastleLost()
    local SabattCastleID = Logic.GetHeadquarters(SabattaPlayerID)
    if SabattCastleID == 0 and NumRegalias[SabattaPlayerID] > 0 then
        SendRegaliaToPlayer(1, SabattaPlayerID, NumRegalias[SabattaPlayerID])
    end
end


function OnSabattasCartCaptured()
    CaptureQuestHasBeenTriggered = nil
end



function AIProfile_Sabatta(self)
   
    if Logic.GetHeadquarters(SabattaPlayerID) == 0 then
        
        if SabattaDestroyed == nil then
            Quests[protectEastExcarvation]:Success()
            SabattaDestroyed = true
        end
            
        return
    end
    

    if (self.m_FirstCall == nil) then        
        self.m_FirstCall = true;
        
        ExcarvationAttackMinSwordsman = 1
        ExcarvationAttackMaxSwordsman = 1
        
        ExcarvationAttackMinBowman = 1
        ExcarvationAttackMaxBowman = 1
    end
    
    --send thieves
    if  NumRegalias[1] >= 1 
    and Logic.GetNumberOfPlayerEntitiesInCategory(SabattaPlayerID, EntityCategories.Thief) == 0 
    and DoesSabattaHasARegaliaCart() == false 
    and  ( NextThiefAttack == nil 
    or Logic.GetTime() >= NextThiefAttack ) then
        
        local CastleID = Logic.GetHeadquarters(SabattaPlayerID)
        
        local ThiefID = Logic.CreateEntityAtBuilding(Entities.U_Thief, CastleID, 0, 2)
        
        Logic.SendThiefStealBuilding(ThiefID, Logic.GetHeadquarters(1))
        
        NextThiefAttack = Logic.GetTime() + 60 * (5 + Logic.GetRandom(10))
        
        --Logic.DEBUG_AddNote("Sabatta send thief!!!!!!!!!!")

    end
    
    if NextExcarvationAttackTime ~= nil then
        --Logic.DEBUG_AddNote("Attack: " .. NextExcarvationAttackTime .."/" .. Logic.GetTime())
    end

    --attack excarvation regulary, when player is baron
    if (self.m_Behavior["AttackExcarvation"] == nil) then
        
        local KnightTitle = Logic.GetKnightTitle(1)
        
        if  KnightTitle >= KnightTitles.Baron 
        and EastExcarvationSideDiscovered == true
        and NextExcarvationAttackTime ~= nil 
        and Logic.GetTime() >= NextExcarvationAttackTime 
        and StopAttackOnExcarvationSite ~= true then
            
            self.m_Behavior["AttackExcarvation"] = self:GenerateBehaviour(AIBehavior_AttackCity);
    
            self.m_Behavior["AttackExcarvation"].m_TargetID = Logic.GetStoreHouse(EastExcarvationPlayerID)
            self.m_Behavior["AttackExcarvation"].m_Radius = 40 * 100;  
            
            
            self.m_Behavior["AttackExcarvation"].m_MinNumberOfSwordsmen = ExcarvationAttackMinSwordsman;  
            self.m_Behavior["AttackExcarvation"].m_MaxNumberOfSwordsmen = ExcarvationAttackMaxSwordsman;  
            self.m_Behavior["AttackExcarvation"].m_FleeNumberOfSwordsmen = 0;  
            
            self.m_Behavior["AttackExcarvation"].m_MinNumberOfBowmen = ExcarvationAttackMinBowman;  
            self.m_Behavior["AttackExcarvation"].m_MaxNumberOfBowmen = ExcarvationAttackMaxBowman;  
            self.m_Behavior["AttackExcarvation"].m_FleeNumberOfBowmen = 0;  
            self.m_Behavior["AttackExcarvation"].m_MinNumberOfRams = 1;  
            self.m_Behavior["AttackExcarvation"].m_MinNumberOfCatapults = 0;  
            self.m_Behavior["AttackExcarvation"].m_MaxNumberOfCatapults = 0;  
            self.m_Behavior["AttackExcarvation"].m_MinNumberOfTowers = 0;  
            self.m_Behavior["AttackExcarvation"].m_MaxNumberOfTowers = 0;  
            self.m_Behavior["AttackExcarvation"].m_FleeNumberOfCatapults = 0;
            
            if (self.m_Behavior["AttackExcarvation"]:Start() == false) then
                self.m_Behavior["AttackExcarvation"] = nil;
            else
                --Increase strength for next attack
                --ExcarvationAttackMinSwordsman = ExcarvationAttackMinSwordsman + 1
                ExcarvationAttackMaxSwordsman = ExcarvationAttackMaxSwordsman + 1
                
                --ExcarvationAttackMinBowman = ExcarvationAttackMinBowman + 1
                ExcarvationAttackMaxBowman = ExcarvationAttackMaxBowman + 1
                
                NextExcarvationAttackTime = Logic.GetTime() + 60 * (10 + Logic.GetRandom(10))
                
                SendVoiceMessage(SabattaPlayerID, "NPCTalk_SabattaAttacksExcavation")
            end
        end
    end
    
    --AnSu: Seemds not to work for the moment
    
    --stop try capturing, when cart is not there anymore
    --if GetCartToCapture() == nil then
    --    self.m_Behavior["CaptureCarts"] = nil
    --end
    --
    ----try to capture carts regulary
    --if GetCartToCapture() ~= nil and (self.m_Behavior["CaptureCarts"] == nil) then
    --
    --    self.m_Behavior["CaptureCarts"] = self:GenerateBehaviour(AIBehavior_AttackTradecart);
    --    self.m_Behavior["CaptureCarts"].m_MinNumberOfSwordsmen = 1;  
    --    self.m_Behavior["CaptureCarts"].m_MaxNumberOfSwordsmen = 1;  
    --    
    --        
    --    self.m_Behavior["CaptureCarts"].m_MinNumberOfBowmen = 0;  
    --    self.m_Behavior["CaptureCarts"].m_MaxNumberOfBowmen = 0;  
    --    self.m_Behavior["CaptureCarts"].m_CartID = GetCartToCapture()
    --    
    --    if (self.m_Behavior["CaptureCarts"]:Start() == false) then
    --        self.m_Behavior["CaptureCarts"] = nil;
    --        Logic.DEBUG_AddNote("Sabatta capture !!!!!!!!!!")
    --    end 
    --    
    --end
    
    --attack player city once the player has x regalias, use last attack time from excarvation site for now
    if  NumRegalias[1] >= 2 
    and SabattaAttackedPlayer == nil 
    and NextExcarvationAttackTime ~= nil 
    and Logic.GetTime() >= NextExcarvationAttackTime 
    and (self.m_Behavior["PlayerCityAttack"] == nil) then

        self.m_Behavior["PlayerCityAttack"] = self:GenerateBehaviour(AIBehavior_AttackCity);
        self.m_Behavior["PlayerCityAttack"].m_MinNumberOfSwordsmen = 2;  
        self.m_Behavior["PlayerCityAttack"].m_MaxNumberOfSwordsmen = 5;  
        self.m_Behavior["PlayerCityAttack"].m_FleeNumberOfSwordsmen = 0;  
            
        self.m_Behavior["PlayerCityAttack"].m_MinNumberOfBowmen = 3;  
        self.m_Behavior["PlayerCityAttack"].m_MaxNumberOfBowmen = 5;  
        self.m_Behavior["PlayerCityAttack"].m_FleeNumberOfBowmen = 0; 

        self.m_Behavior["PlayerCityAttack"].m_MinNumberOfRams = 0;  
        self.m_Behavior["PlayerCityAttack"].m_MinNumberOfCatapults = 0;  
        self.m_Behavior["PlayerCityAttack"].m_MinNumberOfTowers = 0;  
        self.m_Behavior["PlayerCityAttack"].m_FleeNumberOfCatapults = 0;
        
        self.m_Behavior["PlayerCityAttack"].m_TargetID = Logic.GetHeadquarters(1)
        
        
        if (self.m_Behavior["PlayerCityAttack"]:Start() == false) then
            self.m_Behavior["PlayerCityAttack"] = nil;
            
            SendVoiceMessage(SabattaPlayerID, "NPCTalk_SabattaAttacksPlayer")
        
            --Logic.DEBUG_AddNote("Sabatta attacks player!!!!!!!!!!")
        
            SabattaAttackedPlayer = true
        end 
        
    end

end


function DoesSabattaHasARegaliaCart()
    
    if RegaliaCarts == nil or #RegaliaCarts == 0 then
        return false    
    end
    
    for i=1,#RegaliaCarts do
        
        local RegaliaCartID = RegaliaCarts[i][1]
    
        if Logic.IsEntityAlive(RegaliaCartID) then
            
            if Logic.EntityGetPlayer(RegaliaCartID) == SabattaPlayerID then
                return true
            end
        end
    end
    
    return false
    
end

function GetCartToCapture()

    if RegaliaCarts == nil or #RegaliaCarts == 0 then
        return 
    end
    
    for i=1,#RegaliaCarts do
        
        local RegaliaCartID = RegaliaCarts[i][1]
    
        if Logic.IsEntityAlive(RegaliaCartID) then
            
            if Logic.EntityGetPlayer(RegaliaCartID) == 1 then
                return RegaliaCartID
            end
        end
    end
    
    return 
end
