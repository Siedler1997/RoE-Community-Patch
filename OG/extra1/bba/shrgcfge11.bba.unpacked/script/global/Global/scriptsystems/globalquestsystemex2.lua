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

    do
        function QuestTemplate:GetNumberOfUnitsOnTerritory(unitType, territoryID, _level)
            if territoryID == nil then
                territoryID = 0
            end

            local number = 0
            if unitType == Entities.U_MilitaryBow or unitType == Entities.U_MilitarySword then
                local leaders = GetPlayerEntities(self.ReceivingPlayer, Entities.U_MilitaryLeader)
                for i=1, #leaders do
                    if Logic.LeaderGetSoldiersType(leaders[i]) == unitType then
                        if territoryID == 0 then
                            number = number + 1
                        else
                            local x, y = Logic.GetEntityPosition(leaders[i])
                            local territory = Logic.GetTerritoryAtPosition(x, y)
                            if territory == territoryID then
                                number = number + 1
                            end
                        end
                    end
                end
            else
                --local entities = { Logic.GetPlayerEntities(self.ReceivingPlayer, unitType, 48, 0) }
                local entities = GetPlayerEntities(self.ReceivingPlayer, unitType)
                if #entities > 0 then
                    if Logic.IsBuilding(entities[1]) == 1 then
                        for i=1, #entities do
                            if Logic.IsConstructionComplete(entities[i]) == 1 then
                                if _level == nil or Logic.GetUpgradeLevel(entities[i]) >= _level then
                                    if territoryID == 0 then
                                        number = number + 1
                                    else
                                        local x, y = Logic.GetEntityPosition(entities[i])
                                        local territory = Logic.GetTerritoryAtPosition(x, y)
                                        if territory == territoryID then
                                            number = number + 1
                                        end
                                    end
                                end
                            end
                        end
                    else
                        if territoryID == 0 then
                            number = #entities
                        else
                            for i=1, #entities do
                                local x, y = Logic.GetEntityPosition(entities[i])
                                local territory = Logic.GetTerritoryAtPosition(x, y)
                                if territory == territoryID then
                                    number = number + 1
                                end
                            end
                        end
                    end
                end
            end
            return number
        end
    end

    do
        
        local QuestTemplate_OldIsObjectiveCompleted = QuestTemplate.IsObjectiveCompleted
        function QuestTemplate:IsObjectiveCompleted(objective)
            local objectiveType = objective.Type
            local data = objective.Data

            if objective.Completed ~= nil then
                return objective.Completed
            end

            if objectiveType == Objective.Create then
                if self:GetNumberOfUnitsOnTerritory(data[1], data[3], data[4]) >= data[2] then
                    objective.Completed = true
                end
            else
                return QuestTemplate_OldIsObjectiveCompleted(self, objective)
            end

            return objective.Completed
        end
    end

end