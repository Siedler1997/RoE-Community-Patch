-----------------------------------------------------------------------------------------
-- Overwrites for OverwriteGlobalQuestSystem
-----------------------------------------------------------------------------------------

function InitOverwriteGlobalQuestSystemEx2()

    -----------------------------------------------------------------------------------------------
    --  this is used to make a dialog at the end of the map
    -----------------------------------------------------------------------------------------------
    do
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
    end

end