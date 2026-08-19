
-----------------------------------------------------------------------------------------
-- Overwrites for GlobalFreeSettleModeSystem
-----------------------------------------------------------------------------------------

function InitOverwriteFreeSettleModeEx2()
    
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