
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

end