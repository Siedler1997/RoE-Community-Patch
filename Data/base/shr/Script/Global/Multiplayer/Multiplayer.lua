g_Multiplayer = {}

g_Multiplayer.VictoryConditions = {}
g_Multiplayer.ResourceModificators = {}
Script.Load("Script\\Shared\\ScriptSystems\\SharedMultiplayer.lua" )

Script.Load("Script\\Global\\Multiplayer\\VictoryCondition.lua" )
Script.Load("Script\\Global\\Multiplayer\\ResourceModificators.lua" )


function GameCallback_InitVictoryCondition(_ConditionIndex)
    local MapName = Framework.GetCurrentMapName()
    local MapType = Framework.GetCurrentMapTypeAndCampaignName()
        
    local VictoryConditions = {GetMPValidVictoryConditions(MapName, MapType)}
    
    g_Multiplayer.CurrentVictoryCondition = g_Multiplayer.VictoryConditions[VictoryConditions[_ConditionIndex]]:CreateNewVictoryCondition()

end


function GameCallback_InitMPResources(_ResourceFunctionIndex, _PlayerID)
    local MapName = Framework.GetCurrentMapName()
    local MapType = Framework.GetCurrentMapTypeAndCampaignName()
    
    local ResourceModificators = {GetMPValidResourceModificators(MapName, MapType)}
     
    g_Multiplayer.ResourceModificators[ResourceModificators[_ResourceFunctionIndex]](_PlayerID)
end


function GameCallback_OnMPGameStart()
    Trigger.RequestTrigger(Events.LOGIC_EVENT_EVERY_TURN, NIL, "VictoryConditionHandler", 1)
    
    SetupNPCQuests()
    
end



function GetKnightTypeIDForMPGame(_KnightIndex, _PlayerID)
    local MapName = Framework.GetCurrentMapName()
    local MapType = Framework.GetCurrentMapTypeAndCampaignName()
    
    local KnightNames = {GetMPValidKnightNames(MapName, MapType)}
    local ValidKnightNames = {Framework.GetValidKnightNames(MapName, MapType)}

    -- MaMa: Have to handle _KnightIndex being a type rather than an index (when
    -- restarting map) -- I hope what I'm doing is right...
    -- Arguably, one could simply return an invalid index, assuming it is an
    -- entity type, but I decided to play it safe.
    --
    --Finally fixed...
    if #ValidKnightNames == 0 then
        return Entities[KnightNames[_KnightIndex]]
    else
        return Entities[MPDefaultKnightNames[_KnightIndex]] 
    end
    return -1
end



function GameCallback_PlayerLeft(_MultiplayerSlotID)
    for i =1,8 do
        local CurrentSlotID = Logic.GetPlayerMultiplayerSlot(i)
        if CurrentSlotID == _MultiplayerSlotID then
            Logic.PlayerSetGameStateToLeft(i)
            local CastleID = Logic.GetHeadquarters(i)
            if CastleID ~= 0 and CastleID ~= nil then
                local Name = Logic.GetPlayerName(i)
                
                if Name == nil then
                    Name = i
                end
                
                Logic.DestroyEntity(CastleID)
            end
        end
    end
end



function FrameworkCallback_OutOfSync(_GameTurn, _Dummy)
    if DesyncTurn == nil then
        DesyncTurn = _GameTurn 
        Framework.SaveGame("desyncsave", "Savegame created upon desync", false)
    end
end


function SetupNPCQuests()
    
    --generate tables
    local HumanPlayerList = {}
    local NPCPlayerList = {}
    local BanditsPlayerList = {}
    
    for PlayerID = 1, 8 do
        
        if Logic.PlayerGetIsHumanFlag(PlayerID) then
        
            table.insert(HumanPlayerList, PlayerID)
        
        elseif  Logic.GetStoreHouse(PlayerID) ~= 0 
        and GetPlayerCategoryType(PlayerID) ~= PlayerCategories.City then
        
            if GetPlayerCategoryType(PlayerID) ~= PlayerCategories.BanditsCamp then
                table.insert(NPCPlayerList, PlayerID)
            else
                table.insert(BanditsPlayerList, PlayerID)
            end
            
        end

    end
    
    --generate random quests
    local PossibleGoodsToDeliver = {Goods.G_Wood, Goods.G_Stone}
    
    local PossibleObjectives = {    {"Quest_Deliver_Resources", { Objective.Deliver, Goods.G_Wood, 20 }},
                                    {"Quest_KnightTitle", { Objective.KnightTitle, KnightTitles.Mayor }}
                                }
    
    local QuestsFromVillages = {}
    
    local QuestIndexCounter = 1
    local DeliverTypeCounter = 1

    for k=1, #NPCPlayerList do
        
        local NPCPlayerID = NPCPlayerList[k]
        
        
        local RandomQuestIndex = 1 + Logic.GetRandom(#PossibleObjectives)
        
        local RandomQuest = PossibleObjectives[RandomQuestIndex]
        
        QuestsFromVillages[NPCPlayerID] = {}
        QuestsFromVillages[NPCPlayerID].Text = RandomQuest[1]
        QuestsFromVillages[NPCPlayerID].Objective = RandomQuest[2]
        
        if RandomQuest[2][1] ==  Objective.Deliver then
            
            local RandomGoodTypeIndex = 1 + Logic.GetRandom(#PossibleGoodsToDeliver)
            local RandomGoodType = PossibleGoodsToDeliver[RandomGoodTypeIndex]
            
            QuestsFromVillages[NPCPlayerID].Objective[2] = RandomGoodType
            
            DeliverTypeCounter = DeliverTypeCounter + 1
            
            if DeliverTypeCounter > #PossibleGoodsToDeliver then
                DeliverTypeCounter = 1
            end
            
        end
        
        QuestIndexCounter = QuestIndexCounter + 1
        
        if QuestIndexCounter > #PossibleObjectives then
            QuestIndexCounter = 1
        end
        
    end
    

    --map quests on players
    for i= 1, #HumanPlayerList do
        
        local HumanPlayerID = HumanPlayerList [i]
        
        for j = 1, #NPCPlayerList do
        
            local NPCPlayerID = NPCPlayerList[j]
        
            SetDiplomacyState(HumanPlayerID, NPCPlayerID, DiplomacyStates.Undecided)
        
            local DiscoverQuestID = QuestTemplate:New("", NPCPlayerID, HumanPlayerID, 
                                                    { { Objective.Discover, 2, { NPCPlayerID } } },
                                                    { { Triggers.Time, 0 } },
                                                    0,  
                                                    { {Reward.Diplomacy, NPCPlayerID , 2 } }, 
                                                    nil, OnTradePartnerQuestDone, nil, false)

            --local TradePartnerQuestID = QuestTemplate:New(QuestsFromVillages[NPCPlayerID].Text, NPCPlayerID, HumanPlayerID, 
            --                                        { QuestsFromVillages[NPCPlayerID].Objective },
            --                                        { { Triggers.Quest, DiscoverQuestID, QuestResult.Success } },
            --                                        0, 
            --                                        { { Reward.Diplomacy, NPCPlayerID, 1 } },                                                     
            --                                        nil, OnTradePartnerQuestDone, nil, true, true)
        end
    end
    
    --set all bandits hostile in MP,  generate quest for them and set offers
    for k= 1, #HumanPlayerList do
        
        local HumanPlayerID = HumanPlayerList [k]
        
        for l = 1, #BanditsPlayerList do
        
            local BanditPlayerID = BanditsPlayerList[l]
        
            SetDiplomacyState(HumanPlayerID, BanditPlayerID, DiplomacyStates.Enemy)

            GenerateMercenaryQuestMP(BanditPlayerID, HumanPlayerID)
            
            QuestTemplate:New("", BanditPlayerID, _HumanPlayerID, 
                    { { Objective.DestroyEntities, 1, {Logic.GetStoreHouse(BanditPlayerID)}} },
                    { { Triggers.Time, 0 } },
                    0,  
                    nil, nil, OnBanditsHQDestroyed, nil, true, false)
            
            
        end
    end
    
    --add offers
    for m = 1, #BanditsPlayerList do
        
        local BanditPlayerID = BanditsPlayerList[m]
        local OutlawMeleeType, OutlawRangedType = GetBanditMilitaryTypesForClimateZoneForCurrentMap()
        local BanditHQ = Logic.GetStoreHouse(BanditPlayerID)
    
        AddMercenaryOffer(BanditHQ, 2, OutlawMeleeType)
        AddMercenaryOffer(BanditHQ, 2, OutlawRangedType)
    end
    
end


function OnBanditsHQDestroyed(_Quest)
    
    for i=1, #Quests do
        
        local QuestID = Quests[i]
        
        if  _Quest.SendingPlayer == QuestID.SendingPlayer 
        and QuestID.State == QuestState.Active then
            QuestID:Interrupt()
        end
    end
    
end


function OnTradePartnerQuestDone(_Quest)

    SendVoiceMessage(_Quest.SendingPlayer, "DiplomacyChanged_TradeContact", _Quest.ReceivingPlayer)
    
end


function OnMercenaryQuestDone(_Quest)

    if _Quest.Result == QuestResult.Success then
        
        SetDiplomacyState(_Quest.SendingPlayer, _Quest.ReceivingPlayer, DiplomacyStates.TradeContact)        
        SendVoiceMessage(_Quest.SendingPlayer, "DiplomacyChanged_TradeContact", _Quest.ReceivingPlayer)
        
    else
        
        if Diplomacy_GetRelationBetween(_Quest.SendingPlayer, _Quest.ReceivingPlayer) ~= DiplomacyStates.Enemy then
            SendVoiceMessage(_Quest.SendingPlayer, "DiplomacyChanged_Enemy", _Quest.ReceivingPlayer)
        end
        
        SetDiplomacyState(_Quest.SendingPlayer, _Quest.ReceivingPlayer, DiplomacyStates.Enemy)    
        
    end
    
    
    if RestartMercenatryQuestTime == nil then
        RestartMercenatryQuestTime = {}
        StartSimpleJob("RestartMercenaryQuestAfterSomeMinutes")
    end
                
    if RestartMercenatryQuestTime[_Quest.ReceivingPlayer] == nil then
        RestartMercenatryQuestTime[_Quest.ReceivingPlayer] = {}
    end
    
    RestartMercenatryQuestTime[_Quest.ReceivingPlayer][_Quest.SendingPlayer] = 60 * 15
                        
    
end

function GenerateMercenaryQuestMP(_BanditPlayerID, _HumanPlayerID)

   QuestTemplate:New("Quest_Deliver_GC_Gold_Tribute", _BanditPlayerID, _HumanPlayerID, 
                    { { Objective.Deliver, Goods.G_Gold, 200 } },
                    { { Triggers.PlayerDiscovered, _BanditPlayerID } },
                    60 * 5,  
                    nil, nil, OnMercenaryQuestDone, nil, true, false)
                   
end


function RestartMercenaryQuestAfterSomeMinutes()
    
    for HumanPlayerID,value in pairs (RestartMercenatryQuestTime) do
    
        for BanditPlayerID,value in pairs (RestartMercenatryQuestTime[HumanPlayerID]) do
            
            RestartMercenatryQuestTime[HumanPlayerID][BanditPlayerID] = RestartMercenatryQuestTime[HumanPlayerID][BanditPlayerID] - 1
            
            if RestartMercenatryQuestTime[HumanPlayerID][BanditPlayerID] <= 0 then
                
                GenerateMercenaryQuestMP(BanditPlayerID, HumanPlayerID)
                
                RestartMercenatryQuestTime[HumanPlayerID][BanditPlayerID] = nil
                
                
            end
                
        end            
        
    end
end
