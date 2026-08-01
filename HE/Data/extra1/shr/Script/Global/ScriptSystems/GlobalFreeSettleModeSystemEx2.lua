
function OnBribeCityQuestDone(_Quest)

    if _Quest.Result == QuestResult.Success then
        
        SetDiplomacyState(_Quest.SendingPlayer, _Quest.ReceivingPlayer, DiplomacyStates.TradeContact)        
        SendVoiceMessage(_Quest.SendingPlayer, "DiplomacyChanged_TradeContact", _Quest.ReceivingPlayer)
        
    else
    
        SetDiplomacyState(_Quest.SendingPlayer, _Quest.ReceivingPlayer, DiplomacyStates.Enemy)    
        SendVoiceMessage(_Quest.SendingPlayer, "DiplomacyChanged_Enemy", _Quest.ReceivingPlayer)
        
    end
    
    
    if RestartBribeCityQuestTime == nil then
        RestartBribeCityQuestTime = {}
        StartSimpleJob("RestartBribeCityQuestAfterSomeMinutes")
    end
                
    if RestartBribeCityQuestTime[_Quest.ReceivingPlayer] == nil then
        RestartBribeCityQuestTime[_Quest.ReceivingPlayer] = {}
    end
    
    RestartBribeCityQuestTime[_Quest.ReceivingPlayer][_Quest.SendingPlayer] = 60 * 20
       
end

function GenerateBribeCityQuestSP(_CityPlayerID, _HumanPlayerID, _GoldAmmount)
    local goldCosts = 1000
    if _GoldAmmount ~= nil then
        goldCosts = _GoldAmmount
    end

   QuestTemplate:New("Quest_Deliver_GC_Gold_Tribute", _CityPlayerID, _HumanPlayerID, 
                    { { Objective.Deliver, Goods.G_Gold, goldCosts } },
                    { { Triggers.PlayerDiscovered, _CityPlayerID } },
                    60 * 10,  
                    nil, nil, OnBribeCityQuestDone, nil, true, false)
                   
end

function RestartBribeCityQuestAfterSomeMinutes()
    
    for HumanPlayerID,value in pairs (RestartBribeCityQuestTime) do
    
        for CityPlayerID,value in pairs (RestartBribeCityQuestTime[HumanPlayerID]) do
            
            RestartBribeCityQuestTime[HumanPlayerID][CityPlayerID] = RestartBribeCityQuestTime[HumanPlayerID][CityPlayerID] - 1
            
            if RestartBribeCityQuestTime[HumanPlayerID][CityPlayerID] <= 0 then
                
                GenerateBribeCityQuestSP(CityPlayerID, HumanPlayerID)
                
                RestartBribeCityQuestTime[HumanPlayerID][CityPlayerID] = nil
                
            end
                
        end            
        
    end
end

-----------------------------------------------------------------------------------------
-- Overwrites for GlobalFreeSettleModeSystem
-----------------------------------------------------------------------------------------

function InitOverwriteGlobalFreeSettleModeSystemEx2()
    
    do
        function InitFreeSettleMode()

            QuestTemplate:New("Quest_KnightTitle", 1, 1, 
                            {{Objective.Create, Entities.B_Beautification_Cathedral, 1, nil, 4}},
                            { { Triggers.Time, 0 } },
                            0,  
                            { {Reward.Victory } } )
            
            --generate tables    
            local BanditsPlayerList = {}
            local EnemyCitiesPlayerList = {}    
            local VillagesPlayerList = {}
            
            local HumanPlayerID = 1
            
            for PlayerID = 2, 8 do
                
                if  Logic.GetStoreHouse(PlayerID) ~= 0 then
                
                    local PlayerCategory = GetPlayerCategoryType(PlayerID)
                
                    if  PlayerCategory == PlayerCategories.Cloister
                    or PlayerCategory == PlayerCategories.Village then                
                        table.insert(VillagesPlayerList, PlayerID)
                    elseif PlayerCategory == PlayerCategories.BanditsCamp then
                        table.insert(BanditsPlayerList, PlayerID)
                    elseif PlayerCategory == PlayerCategories.City then                
                        
                        if ListOfFriendlyCities ~= nil 
                        and ListOfFriendlyCities[PlayerID] ~= nil 
                        and ListOfFriendlyCities[PlayerID] then
                            table.insert(VillagesPlayerList, PlayerID)
                        else
                            table.insert(EnemyCitiesPlayerList, PlayerID)                
                        end
                    end
                    
                end

            end
            
            --Set all players to undecided at beginning and generate hidden discover Quest
            

            do
                for i = 1, #VillagesPlayerList do
                    
                    local NPCPlayerID = VillagesPlayerList[i]
                
                    SetDiplomacyState(HumanPlayerID, NPCPlayerID, DiplomacyStates.Undecided)
                
                    local DiscoverQuestID = QuestTemplate:New("", NPCPlayerID, HumanPlayerID, 
                                                            { { Objective.Discover, 2, { NPCPlayerID } } },
                                                            { { Triggers.Time, 0 } },
                                                            0,  
                                                            { {Reward.Diplomacy, NPCPlayerID , 2 } }, 
                                                            nil, OnTradePartnerQuestDone, nil, false)
            
                end 
            end
                
            --generate mercenaries Quests
            do
                for i = 1, #BanditsPlayerList do
                    
                    local BanditPlayerID = BanditsPlayerList[i]
                    SetDiplomacyState(HumanPlayerID, BanditPlayerID, DiplomacyStates.Enemy)
                    GenerateMercenaryQuestSP(BanditPlayerID, HumanPlayerID)
                    
                end
            end
            
            
            --add offers
            do 
                for i = 1, #BanditsPlayerList do
                    
                    local BanditPlayerID = BanditsPlayerList[i]
                    local OutlawMeleeType, OutlawRangedType = GetBanditMilitaryTypesForClimateZoneForCurrentMap()
                    local BanditHQ = Logic.GetStoreHouse(BanditPlayerID)
                    
                    AddMercenaryOffer(BanditHQ, 5, OutlawMeleeType)
                    AddMercenaryOffer(BanditHQ, 5, OutlawRangedType)
                end
            end
            
            -- make city enemy
            do
                for i = 1, #EnemyCitiesPlayerList do
                    local CityPlayerID = EnemyCitiesPlayerList[i]
                    SetDiplomacyState(HumanPlayerID, CityPlayerID, DiplomacyStates.Enemy)
                end
            end
            
        end
    end

end