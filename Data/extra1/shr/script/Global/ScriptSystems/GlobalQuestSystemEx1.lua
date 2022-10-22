
do 
    local OldQuestTemplate_IsObjectiveCompleted = QuestTemplate.IsObjectiveCompleted
    
    function QuestTemplate:IsObjectiveCompleted(objective)
         local objectiveType = objective.Type
         local data = objective.Data

        if objective.Completed ~= nil then
            return objective.Completed
        end
        
        if objectiveType == Objective.Refill then
            if data[2] then
                objective.Completed = true
            end
        else
            return OldQuestTemplate_IsObjectiveCompleted(self, objective)
        end
        
        return objective.Completed
    end
end
function Quest_OnGeologistRefill( _PlayerID, _TargetID, _GeologistID )
    if Quests[0] == nil then
        return
    end
    
    for i=1, Quests[0] do
        if Quests[i].State == QuestState.Active then
            for j=1, Quests[i].Objectives[0] do
                if Quests[i].Objectives[j].Type == Objective.Refill then
                    if Quests[i].ReceivingPlayer == _PlayerID then
                        if Quests[i].Objectives[j].Data[1] == _TargetID then
                            Quests[i].Objectives[j].Data[2] = _GeologistID or true
                        end
                    end
                end
            end
        end
    end
end

-- this is used to make a dialog at the end of the map
function GenerateVictoryDialog( _MessagesTable, _TriggerQuestID)
    if CurrentMapIsCampaignMap ~= true or Framework.GetCampaignName() == "c01" or Framework.GetCampaignName() == "c02" then
        QuestTemplate.TerminateEventsAndStuff()
        Victory(g_VictoryAndDefeatType.VictoryMissionComplete)
    end

    Logic.ExecuteInLuaLocalState("GUI_Interaction.ResetVoiceMessageQueue()")
	
    GlobalVictoryQuests = {}
    
    local QuestID = _TriggerQuestID


    for i= 1, #_MessagesTable do
    
        local SendingPlayerID = _MessagesTable[i][1]
        local Identifier    = _MessagesTable[i][2]
        
        local VictoryReward
        
        if i == #_MessagesTable then
            VictoryReward = { { Reward.Victory } }
        end
        
        if QuestID == nil then
            QuestID = QuestTemplate:New(Identifier, SendingPlayerID, 1, { { Objective.Dummy } },
                                            { { Triggers.Time, 0 } }, 
                                            0, 
                                            VictoryReward,nil, nil, nil,true, false)
        else
            QuestID = QuestTemplate:New(Identifier, SendingPlayerID, 1, { { Objective.Dummy } },
                                            { { Triggers.Quest, QuestID, QuestResult.Success } }, 
                                            0, 
                                            VictoryReward,nil, nil, nil,true, false)
        end
        
        table.insert(GlobalVictoryQuests, QuestID)
    end
end

-- Added for Mission Pack
function GenerateDefeatDialog( _MessagesTable, _TriggerQuestID)

    QuestTemplate.TerminateEventsAndStuff()
    Logic.ExecuteInLuaLocalState("GUI_Interaction.ResetVoiceMessageQueue()")

    Defeated(1)

    GlobalVictoryQuests = {}
    
    local QuestID = _TriggerQuestID


    for i= 1, #_MessagesTable do
    
        local SendingPlayerID = _MessagesTable[i][1]
        local Identifier    = _MessagesTable[i][2]
        
        local ReprisalDefeat
        local CustomObjective = {{  Objective.Dummy }}
        
        if i == #_MessagesTable then
            ReprisalDefeat  = { { Reprisal.Defeat } }
            CustomObjective = {{ Objective.DummyFail }}
        end
        
        if QuestID == nil then
            QuestID = QuestTemplate:New(Identifier, SendingPlayerID, 1, CustomObjective,
                                            { { Triggers.Time, 0 } }, 
                                            0, 
                                            nil,ReprisalDefeat, nil, nil,true, false)
        else
            QuestID = QuestTemplate:New(Identifier, SendingPlayerID, 1, CustomObjective,
                                            { { Triggers.Quest, QuestID, QuestResult.Success } }, 
                                            0, 
                                            nil,ReprisalDefeat, nil, nil,true, false)
        end
        
        table.insert(GlobalVictoryQuests, QuestID)
    end
end