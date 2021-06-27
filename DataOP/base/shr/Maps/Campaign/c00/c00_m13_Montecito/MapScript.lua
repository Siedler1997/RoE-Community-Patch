Script.Load("Script\\Global\\CampaignHotfix.lua")

CurrentMapIsCampaignMap = true


-- AI Attack modes
AttackMode = 
{
    Thieves         = 1,
    Scouts          = 2,
    Army            = 3,
    RedPrinceArmy   = 4
}


MissionState = {}
MissionState.PlayerHasWall = {}
MissionState.LastAttackWaveStartTime = 90
-- time, attackmode, where, who, 
MissionState.DebugMap = false
MissionState.NumberOfFinishedBuildPallisadeQuests = 0
MissionState.AIWarningTime = 4
MissionState.AIThiefInfectRadius = 5000
MissionState.AIWarningTime = 4
MissionState.AIAttackCounter = 0
MissionState.AIAttackArmies = {}
MissionState.AIAttackThiefs = {}
MissionState.AIAttacks = {}
MissionState.AITroopsGarbage = {}
MissionState.TipsForThePlayerDistance = 3000
MissionState.TipsForThePlayer = {
                                    { "wall1", "NPCTalk_Advice_Walls" },
                                    { "wall2", "NPCTalk_Advice_Walls" },
                                    { "wall3", "NPCTalk_Advice_Walls" },
                                    { "wall4", "NPCTalk_Advice_Walls" },
                                    { "bow1", "NPCTalk_Advice_Bowmen" },
                                    { "bow2", "NPCTalk_Advice_Bowmen" },
                                    { "bow3", "NPCTalk_Advice_Bowmen" },
                                    { "bow4", "NPCTalk_Advice_Bowmen" }
                                }

MissionState.WarningIfEnemyArives = {}


----------------------------------------------------------------------------------------------------------------------
function Helper_AddAttack(_Attack)

    MissionState.AIAttacks[#MissionState.AIAttacks + 1] = _Attack

end

----------------------------------------------------------------------------------------------------------------------
function Mission_InitPlayers()
    
    SanTorranoPlayerID      = SetupPlayer(3, "H_NPC_Monk_SE",           "TorantesForest",   "CloisterColor1")
    CaspuenaPlayerID        = SetupPlayer(4, "H_NPC_Villager01_ME",     "Caspuena",         "VillageColor2")
    SeradilloPlayerID       = SetupPlayer(5, "H_NPC_Villager01_SE",     "CabezaQuarry",     "VillageColor3")    
    HarborBayPlayerID       = SetupPlayer(7, "H_NPC_Generic_Trader",    "Harbor Bay",       "TravelingSalesmanColor")        
    RedPrincePlayerID       = SetupPlayer(8, "H_Knight_RedPrince",      "Red Prince",       "RedPrinceColor")
        
    -- set some resources for player 1
    AddResourcesToPlayer(Goods.G_Gold,250)
    AddResourcesToPlayer(Goods.G_Stone,50)
    AddResourcesToPlayer(Goods.G_Wood,50)
    AddResourcesToPlayer(Goods.G_Grain,10)
    AddResourcesToPlayer(Goods.G_Carcass,10)
    AddResourcesToPlayer(Goods.G_RawFish,10)
    AddResourcesToPlayer(Goods.G_Milk,10)


    -- set some resources for player RedPrincePlayerID
    AddResourcesToPlayer(Goods.G_Gold,250, RedPrincePlayerID)
    AddResourcesToPlayer(Goods.G_Stone,150, RedPrincePlayerID)
    AddResourcesToPlayer(Goods.G_Wood, 150, RedPrincePlayerID)
	
	GameCallback_CreateKnightByTypeOrIndex(Entities.U_KnightSabatta, RedPrincePlayerID)

    ----------------------------------------------------------------------------------------------------------------------
    -- Scout the villages
    ----------------------------------------------------------------------------------------------------------------------
    do
        local AIAttack = {}
        AIAttack.StartTime = 15
        AIAttack.AttackMode = AttackMode.Scouts
        AIAttack.SpawnPlaces = { "UnitSpawnB", "UnitSpawnD" }
        AIAttack.AttackPlayer = CaspuenaPlayerID
        AIAttack.SpawnMessage = {1, "NPCTalk_Attack_Village"}
        AIAttack.TerritoryMessage = {CaspuenaPlayerID, "NPCTalk_Attack_Caspuena"}
        Helper_AddAttack(AIAttack)
    end
   
    do
        local AIAttack = {}
        AIAttack.StartTime = 20
        AIAttack.AttackMode = AttackMode.Scouts
        AIAttack.SpawnPlaces =  { "UnitSpawnA" } --, "UnitSpawnB" }
        AIAttack.AttackPlayer = SanTorranoPlayerID
        AIAttack.SpawnMessage = {1, "NPCTalk_Attack_Village"}
        AIAttack.TerritoryMessage = {SanTorranoPlayerID, "NPCTalk_Attack_SanTorrano"}
        Helper_AddAttack(AIAttack)
    end

    do
        local AIAttack = {}
        AIAttack.StartTime = 24
        AIAttack.AttackMode = AttackMode.Scouts
        AIAttack.SpawnPlaces =  { "UnitSpawnD", "UnitSpawnE" }
        AIAttack.AttackPlayer = SeradilloPlayerID
        AIAttack.SpawnMessage = {1, "NPCTalk_Attack_Village"}
        AIAttack.TerritoryMessage = {SeradilloPlayerID, "NPCTalk_Attack_Seradillo"}
        Helper_AddAttack(AIAttack)
    end

    do
        local AIAttack = {}
        AIAttack.StartTime = 30
        AIAttack.AttackMode = AttackMode.Thieves
        AIAttack.SpawnPlaces =  { "UnitSpawnC" }
        AIAttack.AttackPlayer = 1
        Helper_AddAttack(AIAttack)
    end

    ----------------------------------------------------------------------------------------------------------------------
    -- Try to destory the villages to isolate the player
    ----------------------------------------------------------------------------------------------------------------------
    do
        local AIAttack = {}
        AIAttack.StartTime = 34
        AIAttack.AttackMode = AttackMode.Army
        AIAttack.SpawnPlaces = { "UnitSpawnB" }
        AIAttack.AttackPlayer = CaspuenaPlayerID
        AIAttack.SpawnMessage = {1, "NPCTalk_Attack_Village"}
        AIAttack.TerritoryMessage = {CaspuenaPlayerID, "NPCTalk_Attack_Caspuena"}
        Helper_AddAttack(AIAttack)
    end
   
    do
        local AIAttack = {}
        AIAttack.StartTime = 38
        AIAttack.AttackMode = AttackMode.Army
        AIAttack.SpawnPlaces =  { "UnitSpawnA", "UnitSpawnB" }
        AIAttack.AttackPlayer = SanTorranoPlayerID
        AIAttack.SpawnMessage = {1, "NPCTalk_Attack_Village"}
        AIAttack.TerritoryMessage = {SanTorranoPlayerID, "NPCTalk_Attack_SanTorrano"}
        Helper_AddAttack(AIAttack)
    end

    do
        local AIAttack = {}
        AIAttack.StartTime = 44
        AIAttack.AttackMode = AttackMode.Army
        AIAttack.SpawnPlaces =  { "UnitSpawnD", "UnitSpawnE" }
        AIAttack.AttackPlayer = SeradilloPlayerID
        AIAttack.SpawnMessage = {1, "NPCTalk_Attack_Village"}
        AIAttack.TerritoryMessage = {SeradilloPlayerID, "NPCTalk_Attack_Seradillo"}
        Helper_AddAttack(AIAttack)
    end

    do
        local AIAttack = {}
        AIAttack.StartTime = 50
        AIAttack.AttackMode = AttackMode.Thieves
        AIAttack.SpawnPlaces =  { "UnitSpawnC"}
        AIAttack.AttackPlayer = 1
        Helper_AddAttack(AIAttack)
    end
    
    ----------------------------------------------------------------------------------------------------------------------
    -- Get the harbor
    ----------------------------------------------------------------------------------------------------------------------

    do
        local AIAttack = {}
        AIAttack.StartTime = 56
        AIAttack.AttackMode = AttackMode.Army
        AIAttack.SpawnPlaces =  {"UnitSpawnE"}
        AIAttack.AttackPlayer = HarborBayPlayerID
        AIAttack.SpawnMessage = {1, "NPCTalk_Attack_Village"}
        AIAttack.TerritoryMessage = {HarborBayPlayerID, "NPCTalk_HarborBay_Help"} 
        Helper_AddAttack(AIAttack)
    end

    ----------------------------------------------------------------------------------------------------------------------
    -- Try to kill the player
    ----------------------------------------------------------------------------------------------------------------------
    
    do
        local AIAttack = {}
        AIAttack.StartTime = 58
        AIAttack.AttackMode = AttackMode.Thieves
        AIAttack.SpawnPlaces = { "UnitSpawnA", "UnitSpawnC", "UnitSpawnE"}
        AIAttack.AttackPlayer = 1
        Helper_AddAttack(AIAttack)
    end
        
    do
        local AIAttack = {}
        AIAttack.StartTime = 64
        AIAttack.AttackMode = AttackMode.Army
        AIAttack.SpawnPlaces = {"UnitSpawnA", "UnitSpawnB"}
        AIAttack.AttackPlayer = 1
        AIAttack.SpawnMessage = {1, "NPCTalk_Attack_City"}
        Helper_AddAttack(AIAttack)
    end

    do
        local AIAttack = {}
        AIAttack.StartTime = 70
        AIAttack.AttackMode = AttackMode.Army
        AIAttack.SpawnPlaces = {"UnitSpawnD", "UnitSpawnE"}
        AIAttack.AttackPlayer = 1
        AIAttack.SpawnMessage = {1, "NPCTalk_Attack_City"}
        Helper_AddAttack(AIAttack)
    end

    do
        local AIAttack = {}
        AIAttack.StartTime = MissionState.LastAttackWaveStartTime - 10 --launch the attack a bit earlier than the timer says
        AIAttack.AttackMode = AttackMode.RedPrinceArmy
        AIAttack.SpawnPlaces = {"UnitSpawnC"}
        AIAttack.AttackPlayer = 1
        AIAttack.SpawnMessage = {1, "NPCTalk_Attack_City"}
        AIAttack.TerritoryMessage = {RedPrincePlayerID, "NPCTalk_RedPrinceAttack_City"}         
        Helper_AddAttack(AIAttack)
    end
    
end

----------------------------------------------------------------------------------------------------------------------
function SetDiplomacyStates()

    -- set diplomacy state
    SetDiplomacyState(1, SanTorranoPlayerID,        DiplomacyStates.TradeContact)
    SetDiplomacyState(1, CaspuenaPlayerID,          DiplomacyStates.TradeContact)
    SetDiplomacyState(1, SeradilloPlayerID,         DiplomacyStates.TradeContact)
    --SetDiplomacyState(1, HarborBayPlayerID,         DiplomacyStates.TradeContact)
    SetDiplomacyState(1, RedPrincePlayerID,         DiplomacyStates.Enemy)    

    SetDiplomacyState(SanTorranoPlayerID, HarborBayPlayerID,    DiplomacyStates.Undecided)
    SetDiplomacyState(SanTorranoPlayerID, CaspuenaPlayerID,     DiplomacyStates.Undecided)
    SetDiplomacyState(SanTorranoPlayerID, SeradilloPlayerID,    DiplomacyStates.Undecided)
    SetDiplomacyState(SanTorranoPlayerID, RedPrincePlayerID,    DiplomacyStates.Enemy)

    SetDiplomacyState(CaspuenaPlayerID, HarborBayPlayerID,      DiplomacyStates.Undecided)
    SetDiplomacyState(CaspuenaPlayerID, SeradilloPlayerID,      DiplomacyStates.Undecided)
    SetDiplomacyState(CaspuenaPlayerID, RedPrincePlayerID,      DiplomacyStates.Enemy)
    
    SetDiplomacyState(SeradilloPlayerID, HarborBayPlayerID,     DiplomacyStates.Undecided)
    SetDiplomacyState(SeradilloPlayerID, RedPrincePlayerID,     DiplomacyStates.Enemy)

end

----------------------------------------------------------------------------------------------------------------------
function Mission_SetStartingMonth()

    Logic.SetMonthOffset(3)

end

----------------------------------------------------------------------------------------------------------------------
function Mission_InitMerchants()
    
    local TraderID = Logic.GetStoreHouse(SanTorranoPlayerID)
    AddOffer			(TraderID,	 5, Goods.G_Medicine)
    AddOffer			(TraderID,	 5, Goods.G_Bread)
    
    local TraderID = Logic.GetStoreHouse(CaspuenaPlayerID)
    AddOffer			(TraderID,	 5, Goods.G_Wool)
    AddOffer			(TraderID,	 10, Goods.G_Iron)
    
    local TraderID = Logic.GetStoreHouse(SeradilloPlayerID)
    AddOffer			(TraderID,	 5, Goods.G_Stone)
    AddOffer			(TraderID,	 10, Goods.G_Iron)
    
    
    ActivateTravelingSalesman(HarborBayPlayerID, { 
                                                    {5,     
                                                        {  
                                                            {Goods.G_Salt, 5}, 
                                                            {Entities.U_Entertainer_NA_StiltWalker}, 
                                                            {Entities.U_MilitaryBandit_Melee_NA, 5},
                                                            {Entities.U_MilitaryBandit_Ranged_NA, 5}
                                                        }     
                                                    },
                                                    {9,     
                                                        {  
                                                            {Entities.U_Entertainer_NE_StrongestMan_Stone}, 
                                                            {Goods.G_Medicine, 5}, 
                                                            {Entities.U_MilitaryBandit_Melee_NA, 5},
                                                            {Entities.U_MilitaryBandit_Ranged_NA, 5}
                                                        }     
                                                    }  
                                                } 
                                          )

end

----------------------------------------------------------------------------------------------------------------------
function Mission_FirstMapAction()
   
    SetDiplomacyStates()           
    
    -- init AI Player
    AIPlayer:new(SanTorranoPlayerID, AIPlayerProfile_Village)
    AICore.SetNumericalFact(SanTorranoPlayerID, "BPMX", 0 )

    AIPlayer:new(CaspuenaPlayerID, AIPlayerProfile_Village)
    AICore.SetNumericalFact(CaspuenaPlayerID, "BPMX", 0 )
    
    AIPlayer:new(SeradilloPlayerID, AIPlayerProfile_Village)
    AICore.SetNumericalFact(SeradilloPlayerID, "BPMX", 0 )
    
    RedPrinceAI = AIPlayer:new(RedPrincePlayerID, AIProfile_Skirmish, Entities.U_KnightSabatta)
    RedPrinceAI.Skirmish = {}
    RedPrinceAI.Skirmish.Claim_SuperiorTerritories = 3
    RedPrinceAI.Skirmish.Claim_MinTime = 8 * 60
    RedPrinceAI.Skirmish.Claim_MaxTime = 12 * 60
    RedPrinceAI.Skirmish.Attack_MinTime = 17 * 60
    RedPrinceAI.Skirmish.Attack_MaxTime = 25 * 60
    RedPrinceAI.Skirmish.ManOutposts = false
    AICore.SetNumericalFact(RedPrincePlayerID, "PRPT", 1 )
    
    
    -- RedPrinceAI.Skirmish.Cheat = true
            
    SetPlayerMoral(RedPrincePlayerID, 1.0)
        
    -- start simple jobs to give the player tips
    -- StartSimpleJob("SimpleJob_TipsForThePlayer")
    StartSimpleJob("SimpleJob_AIAttackStateMachine")
            
end


function SetupQuestsAfterStartCutscene()

    ShowMissionTimer(MissionState.LastAttackWaveStartTime * 60 )
    
    -- "Quest_DestoryRedPrince"     (hidden)
    QuestTemplate:New("Quest_DestoryRedPrince", 1, 1, 
                    { { Objective.DestroyEntities, 1, {Logic.GetStoreHouse(RedPrincePlayerID)} } }, 
                    {{Triggers.Time, 0}}, 
                    0, 
                    { { Reward.CampaignMapFinished } },
                    nil,
                    nil,
                    nil,
                    false,
                    false) 

            
    -- "Quest_ProtectMontecito" 
    Quest_ProtectMontecitoID = QuestTemplate:New("Quest_ProtectMontecito", 1, 1, 
                    { { Objective.Custom, Custom_IsLastAttackOver } },
                    {{Triggers.Time, 0}}, 
                    0, 
                    { {Reward.PrestigePoints, 5000} }, 
                    { {Reprisal.Defeat} },
                    OnQuestDone_ProtectMontecitoID,
                    nil,
                    true,
                    false)        

    -- "Quest_DiscoverSanTorrano"     (hidden)
   QuestTemplate:New("Quest_DiscoverSanTorrano", 1, 1,                 
                    { { Objective.Discover, 2, {SanTorranoPlayerID} } }, 
                    {{Triggers.Time, 0}}, 
                    0, 
                    nil, 
                    nil, 
                    OnQuestFinished_DiscoverSanTorrano,
                    nil,
                    false) 
   
    -- "Quest_DiscoverCaspuena"     (hidden)
   QuestTemplate:New("Quest_DiscoverCaspuena", 1, 1,                 
                    { { Objective.Discover, 2, {CaspuenaPlayerID} } }, 
                    {{Triggers.Time, 0}}, 
                    0, 
                    nil, 
                    nil, 
                    OnQuestFinished_DiscoverCaspuena,
                    nil,
                    false) 
            
    -- "Quest_DiscoverSeradillo"     (hidden)
   QuestTemplate:New("Quest_DiscoverSeradillo", 1, 1,                 
                    { { Objective.Discover, 2, {SeradilloPlayerID} } }, 
                    {{Triggers.Time, 0}}, 
                    0, 
                    nil, 
                    nil, 
                    OnQuestFinished_DiscoverSeradillo,
                    nil,
                    false)                 

    -- "Quest_PalisadeSanTorrano"   
    QuestTemplate:New("Quest_PalisadeSanTorrano", SanTorranoPlayerID, 1,
                    {{Objective.Deliver, Goods.G_Wood, 40}},
                    {{Triggers.Time, 0}}, 
                    0,
                    { { Reward.PrestigePoints, 1800 } }, 
                    nil, 
                    OnQuestFinished_PalisadeSanTorrano)
                    
    -- "Quest_PalisadeCaspuena"   
    QuestTemplate:New("Quest_PalisadeCaspuena", CaspuenaPlayerID, 1,
                    {{Objective.Deliver, Goods.G_Wood, 40 }},
                    {{Triggers.Time, 0}}, 
                    0,
                    { { Reward.PrestigePoints, 1800 } }, 
                    nil, 
                    OnQuestFinished_PalisadeCaspuena)
    
    -- "Quest_PalisadeSeradillo"   
    QuestTemplate:New("Quest_PalisadeSeradillo", SeradilloPlayerID, 1,
                    {{Objective.Deliver, Goods.G_Wood, 40 }},
                    {{Triggers.Time, 0}}, 
                    0,
                    { { Reward.PrestigePoints, 1800 } }, 
                    nil, 
                    OnQuestFinished_PalisadeSeradillo)

end    

----------------------------------------------------------------------------------------------------------------------
function OnQuestDone_ProtectMontecitoID(_Quest)

    if (_Quest.Result == QuestResult.Failure) then
    
        SendVoiceMessage(RedPrincePlayerID, "Quest_ProtectMontecito_failure")      
    
    end

end

----------------------------------------------------------------------------------------------------------------------
function GameCallback_AIWallBuildingOrder(_PlayerID)
 
    if (_PlayerID == SanTorranoPlayerID) or (_PlayerID == CaspuenaPlayerID) or (_PlayerID == SeradilloPlayerID) then
    
       return 20
        
    end
    
end

----------------------------------------------------------------------------------------------------------------------
function Custom_IsLastAttackOver()

    -- if there is no attack anymore and if the last army is fallen we have won!
    if (#MissionState.AIAttackArmies == 0) and (#MissionState.AIAttacks == 0) then

        SetPlayerMoral(RedPrincePlayerID, 0.3)

        VictoryQuestID = QuestTemplate:New("Quest_DestroyEntities_Building", 1, 1, 
                                                { { Objective.DestroyEntities, 1, {Logic.GetStoreHouse(RedPrincePlayerID)} } }, 
                                                {{Triggers.Time, 0}}, 
                                                0, 
                                                { {Reward.PrestigePoints, 5000}, { Reward.CampaignMapFinished } },
                                                nil,nil,nil,true, false) 
        
            -- END DIALOG
        GenerateVictoryDialog(  {
                                    {RedPrincePlayerID, "Victory_RedPrince" },
                                    {1,                 "Victory_MapIsDone" },
                                }, VictoryQuestID)
        
        return true
                
    end

    
end
----------------------------------------------------------------------------------------------------------------------
function OnQuestFinished_PalisadeSanTorrano()

    AICore.SetNumericalFact(SanTorranoPlayerID, "BPMX", 255 )
    MissionState.NumberOfFinishedBuildPallisadeQuests = MissionState.NumberOfFinishedBuildPallisadeQuests + 1

end

----------------------------------------------------------------------------------------------------------------------
function OnQuestFinished_PalisadeCaspuena()

    AICore.SetNumericalFact(CaspuenaPlayerID, "BPMX", 255 )
    MissionState.NumberOfFinishedBuildPallisadeQuests = MissionState.NumberOfFinishedBuildPallisadeQuests + 1

end

----------------------------------------------------------------------------------------------------------------------
function OnQuestFinished_PalisadeSeradillo()

    AICore.SetNumericalFact(SeradilloPlayerID, "BPMX", 255 )
    MissionState.NumberOfFinishedBuildPallisadeQuests = MissionState.NumberOfFinishedBuildPallisadeQuests + 1

end


----------------------------------------------------------------------------------------------------------------------
function SimpleJob_TipsForThePlayer()

    -- check for nice positions
    local KnightID = Logic.GetKnightID(1)
    
    if (Logic.IsEntityAlive(KnightID)) then
        for Key, CurrentEntry in pairs(MissionState.TipsForThePlayer) do
    
            local EntityID = AIScriptHelper_GetEntityID(CurrentEntry[1])
            if (Logic.GetDistanceBetweenEntities(KnightID, EntityID) < MissionState.TipsForThePlayerDistance) then
    
                SendVoiceMessage(1, CurrentEntry[2])  
                MissionState.TipsForThePlayer[Key] = nil
                    
            end        
        end
    end
end

----------------------------------------------------------------------------------------------------------------------
function CheckIfPlayerHasToRepairIsWall(_PlayerID)

    -- check if the player is still alive
    if (Logic.GetStoreHouse(_PlayerID) == 0) then
    
        return false
        
    end

    -- initialize 
    if (MissionState.PlayerHasWall[_PlayerID] == nil) then
    
        MissionState.PlayerHasWall[_PlayerID] = false
    
    end

    -- get sector id
    local x,y = Logic.GetBuildingApproachPosition(Logic.GetStoreHouse(_PlayerID))
    local Sector1 = Logic.GetPlayerSectorAtPosition(RedPrincePlayerID, x, y)

    x,y = Logic.GetEntityPosition(Logic.GetEntityIDByName("UnitSpawnA"))
    local Sector2 = Logic.GetPlayerSectorAtPosition(RedPrincePlayerID, x, y)

    if (MissionState.PlayerHasWall[_PlayerID] == false) then
    
        if (Sector1 ~= Sector2) then
        
            MissionState.PlayerHasWall[_PlayerID] = true
         
        end
    
    else
    
        if (Sector1 == Sector2) then
        
            return true
            
        end
    
    end
    
    return false

end

----------------------------------------------------------------------------------------------------------------------
function QuestTrigger_RepairSanTorrano()

    return CheckIfPlayerHasToRepairIsWall(SanTorranoPlayerID)

end

----------------------------------------------------------------------------------------------------------------------
function QuestTrigger_RepairCaspuena(_HasWall, _PlayerID)

    return CheckIfPlayerHasToRepairIsWall(CaspuenaPlayerID)
    
end

----------------------------------------------------------------------------------------------------------------------
function QuestTrigger_RepairSeradillo(_HasWall, _PlayerID)

    return CheckIfPlayerHasToRepairIsWall(SeradilloPlayerID)
    
end

----------------------------------------------------------------------------------------------------------------------
function GetFirstEntryOfTable(_Table)

    for Key, CurrentEntry in pairs(_Table) do
    
        return CurrentEntry
    
    end
    
    return nil

end

----------------------------------------------------------------------------------------------------------------------
function SimpleJob_AIAttackStateMachine()

    if Logic.GetStoreHouse(RedPrincePlayerID) == nil or Logic.GetStoreHouse(RedPrincePlayerID) == 0 then
        return
    end

    -- check if which state we are
    for Key, CurrentWarning in pairs(MissionState.WarningIfEnemyArives) do
        
        local EntityID = Logic.GetStoreHouse(CurrentWarning.Player)
        local x, y = Logic.GetEntityPosition(EntityID)
        local TerritoryID = Logic.GetTerritoryAtPosition(x, y)
        
        local AllLeader = { Logic.GetEntitiesOfTypeInTerritory(TerritoryID, RedPrincePlayerID, Entities.U_MilitaryLeader, 0) }  

        if (#AllLeader > 0) then
        
            SendVoiceMessage(CurrentWarning.MessageGiver, CurrentWarning.Message)
            MissionState.WarningIfEnemyArives[Key] = nil
        
        end        
        
    end


--    -- start with out attacks after the player has finished the building quest
--    if (MissionState.NumberOfFinishedBuildPallisadeQuests < 3) then
--    
--        return
--    
--    end

    -- destroy all spawned troops after an attack
    local HomeEntityID = AICore.GetHomeEntityID(RedPrincePlayerID)
    for Key, TroopID in pairs(MissionState.AITroopsGarbage) do
        
        if ( Logic.IsEntityAlive(TroopID) ) and (Logic.GetDistanceBetweenEntities(HomeEntityID, TroopID) < 2000) then
        
            Logic.DestroyEntity(TroopID)
            table.remove(MissionState.AITroopsGarbage, Key)
            
        end
        
    end 


    -- update the attacking armies    
    for Key, Army in pairs(MissionState.AIAttackArmies) do

        -- refill ammu 
        if ((MissionState.AIAttackCounter % 30) == 0) then
            
            for i=1, #Army.Troops do
            
                if ( Logic.IsEntityAlive(Army.Troops[i]) ) and (Logic.CanRefillBattalion(Army.Troops[i])) then
                    Logic.RefillAmmunitions(Army.Troops[i])
                end
                
            end
            
        end

        if (AICore.GetNumberOfLeaders(RedPrincePlayerID, Army.ArmyID) < 2) then
        
            for i=1, #Army.Troops do
                MissionState.AITroopsGarbage[#MissionState.AITroopsGarbage+1] = Army.Troops[i]
            end
            
            table.remove(MissionState.AIAttackArmies, Key)
        
        end
                       
    end

    -- check if the thiefs are still alive
    for Key, ThiefID in pairs(MissionState.AIAttackThiefs) do
    
        if (Logic.IsEntityAlive(ThiefID) == false) then
        
            MissionState.AIAttackThiefs[Key] = nil
        
        end
    
    end

    -- increase attack counter
    MissionState.AIAttackCounter = MissionState.AIAttackCounter + 1
    
    -- check if which state we are
    for Key, CurrentAttack in pairs(MissionState.AIAttacks) do
                        
        if ((CurrentAttack.StartTime * 60) < MissionState.AIAttackCounter) then

            local AttackSpawnPosition   = CurrentAttack.SpawnPlaces[Logic.GetRandom(#CurrentAttack.SpawnPlaces) + 1]
            local AttackPlayerID        = CurrentAttack.AttackPlayer

            local X,Y = Logic.GetEntityPosition(Logic.GetEntityIDByName(AttackSpawnPosition))
            if (Logic.GetTerritoryPlayerID(Logic.GetTerritoryAtPosition(X,Y)) ~= RedPrincePlayerID) then            
            
                -- delete the current attack
                table.remove(MissionState.AIAttacks, Key)
                
            else

                -- try to start an attack
                local ArmyID = nil
                local Troops = nil
                local ThiefID = nil
                if (CurrentAttack.AttackMode == AttackMode.Thieves) then
                
                    ThiefID = AttackWithThieves(AttackPlayerID, AttackSpawnPosition)                
                
                elseif (CurrentAttack.AttackMode == AttackMode.Scouts) then 
                
                    ArmyID, Troops = AttackWithScouts(AttackPlayerID, AttackSpawnPosition)
                                
                elseif (CurrentAttack.AttackMode == AttackMode.Army) then
                
                    ArmyID, Troops = AttackWithArmy(AttackPlayerID, AttackSpawnPosition)
                                
                elseif (CurrentAttack.AttackMode == AttackMode.RedPrinceArmy) then
    
                    ArmyID, Troops = AttackWithRedPrinceArmy(AttackPlayerID, AttackSpawnPosition)                
    
                end
        
                -- check if we have successfully attacked something
                local Success = false
                if (ArmyID ~= nil) then
    
                    local Army = {}
                    Army.ArmyID = ArmyID
                    Army.Troops = Troops
                
                    MissionState.AIAttackArmies[#MissionState.AIAttackArmies + 1] = Army
                    Success = true
                
                end
                
                if (ThiefID ~= nil) then
                
                    MissionState.AIAttackThiefs[#MissionState.AIAttackThiefs + 1] = ThiefID
                    Success = true
                
                end
        
                -- on success send a message and delete the ai attack plan
                if (Success == true) then   
                                        
                    if MissionState.DebugMap then

                        Logic.DEBUG_AddNote("Spawn: " .. AttackSpawnPosition)                 
                        Logic.DEBUG_AddNote("AttackPlayer: " .. AttackPlayerID)
                        Logic.DEBUG_AddNote("AttackMode: " .. CurrentAttack.AttackMode)                   
                    
                    end
                                                                                        
                    -- send voice message that the attack has started
                    if (CurrentAttack.SpawnMessage ~= nil) then                
                        SendVoiceMessage(CurrentAttack.SpawnMessage[1], CurrentAttack.SpawnMessage[2])   
                    end
            
                    -- add territory warning
                    if (CurrentAttack.TerritoryMessage ~= nil) then
                    
                        local Index = #MissionState.WarningIfEnemyArives + 1                
                        MissionState.WarningIfEnemyArives[Index] = {}
                        MissionState.WarningIfEnemyArives[Index].Player         = CurrentAttack.AttackPlayer
                        MissionState.WarningIfEnemyArives[Index].MessageGiver   = CurrentAttack.TerritoryMessage[1]
                        MissionState.WarningIfEnemyArives[Index].Message        = CurrentAttack.TerritoryMessage[2]
                        
                    end
                    
                    -- delete the current attack
                    table.remove(MissionState.AIAttacks, Key)
                end            
            end
        end

    end

    if MissionState.DebugMap then
        Logic.DEBUG_AddNote("Armies: " .. #MissionState.AIAttackArmies .. "   States: " .. #MissionState.AIAttacks)    
    end

--    -- increase the counter if no attack is active anymore
--    if (#MissionState.AIAttackArmies == 0) and (#MissionState.AIAttackThiefs == 0) then
--        local FirstEntry = GetFirstEntryOfTable(MissionState.AIAttacks)        
--        if (FirstEntry ~= nil) then                    
--            if (((FirstEntry.StartTime- MissionState.AIWarningTime) * 60) == MissionState.AIAttackCounter) then                    
--        
--                ShowMissionTimer(MissionState.AIWarningTime * 60)
--            
--            end        
--        end                         
--    end


    -- as long as the vicotry quest isnt started make our worker happy... prolly a little bit to aggressive
    if (VictoryQuestID == nil) then
                
        if ((Logic.GetTime() % 10) == 0) then
        
            FillInStocksOfBigCity(RedPrincePlayerID)
        
            local CityBuildings = {Logic.GetPlayerEntitiesInCategory(RedPrincePlayerID, EntityCategories.CityBuilding)}        
            for i = 1, table.getn(CityBuildings) do
            
                local BuildingID = CityBuildings[i]
                for Need=0, 5 do
                            
                    local CriticalThreshold = Logic.GetNeedCriticalThreshold(BuildingID, Need)
                    Logic.SetNeedState(BuildingID, Need, 1)
                                    
                end
            end    
        end
    end  
    
    if (RedPrinceAI.Skirmish.NumberOfDefendSwordmen < 3) then 
        RedPrinceAI.Skirmish.NumberOfDefendSwordmen = 3
    end

    if (RedPrinceAI.Skirmish.NumberOfDefendBowmen < 2) then 
        RedPrinceAI.Skirmish.NumberOfDefendBowmen = 2
    end
       
    -- we dont want to mount outposts
    AICore.SetNumericalFact(RedPrincePlayerID, "FMOP", 0 )   
end

----------------------------------------------------------------------------------------------------------------------
function AttackWithThieves(_PlayerID, _SpawnPosition)

    local SpawnPosition = AIScriptHelper_GetEntityID(_SpawnPosition)

    if (SpawnPosition ~= 0) then
        
        local ThiefX, ThiefY = Logic.GetEntityPosition(SpawnPosition)
        local ThiefID = Logic.CreateEntityOnUnblockedLand(Entities.U_Thief, ThiefX, ThiefY, 0, RedPrincePlayerID)              
        Logic.SendThiefStealBuilding(ThiefID, Logic.GetStoreHouse(_PlayerID))              
        return ThiefID          
        
    end
    
    return nil
    
end

----------------------------------------------------------------------------------------------------------------------
function MissionCallback_OnThiefStealBuilding(_ThiefID, _ThiefPlayerID, _BuildingID, _BuildingPlayerID)

    for Key, ThiefID in pairs(MissionState.AIAttackThiefs) do
    
        if (ThiefID == _ThiefID) then
            
            -- make some buildings ill
            if (_BuildingPlayerID == 1) then
            
                local Buildings = {Logic.GetPlayerEntitiesInCategory(_BuildingPlayerID, EntityCategories.CityBuilding)}
                for i=1,#Buildings do
                
                    if (Logic.GetDistanceBetweenEntities(Buildings[i], _ThiefID) < MissionState.AIThiefInfectRadius) then
                    
                        Logic.MakeBuildingIll(Buildings[i], true)
                    
                    end    
                
                end
            
            end

            -- send voice message            
            SendVoiceMessage(1, "NPCTalk_Attack_Thieves")

            -- remove and destroy the thief       
            MissionState.AIAttackThiefs[Key] = nil
            
            --KoBo: removed this because this is too early for the GameCallback_Feedback_ThiefDeliverInformations to work
            -- also, he's destroyed by GlobalThiefSystem anyway (but a bit later).
            --Logic.DestroyEntity(ThiefID)
        
        end
        
    end

end

----------------------------------------------------------------------------------------------------------------------
function GetPlayerSector(_PlayerID)


    return Sector1
    
end

----------------------------------------------------------------------------------------------------------------------
function AttackWithScouts(_PlayerID, _SpawnPosition)

    if (Logic.GetStoreHouse(_PlayerID) ~= 0) then
          
        local x1,y1 = Logic.GetBuildingApproachPosition(Logic.GetStoreHouse(_PlayerID))
        local Sector1 = Logic.GetPlayerSectorAtPosition(RedPrincePlayerID, x1, y1)

        local x2,y2 = Logic.GetEntityPosition(Logic.GetEntityIDByName(_SpawnPosition))
        local Sector2 = Logic.GetPlayerSectorAtPosition(RedPrincePlayerID, x2, y2)
    
        if (Sector1 ~= Sector2) then
                
            local ArmyID, SpawnedTroops = AIScript_SpawnAndAttackCity(RedPrincePlayerID, Logic.GetStoreHouse(_PlayerID), _SpawnPosition, 2, 1, 0, 0 , 1, 0)
            if (ArmyID == 0) then
                ArmyID = nil
            end
            
            return ArmyID, SpawnedTroops
            
        else
        
            local ArmyID, SpawnedTroops = AIScript_SpawnAndRaidSettlement(RedPrincePlayerID, Logic.GetStoreHouse(_PlayerID), _SpawnPosition, 2000, 2, 1)
            if (ArmyID == 0) then
                ArmyID = nil
            end
            
            return ArmyID, SpawnedTroops

        end
        
    end
    
    return nil
                 
end

----------------------------------------------------------------------------------------------------------------------
function AttackWithArmy(_PlayerID, _SpawnPosition)

    if (Logic.GetStoreHouse(_PlayerID) ~= 0) then
    
        local ArmyID, SpawnedTroops = AIScript_SpawnAndAttackCity(RedPrincePlayerID, Logic.GetStoreHouse(_PlayerID), _SpawnPosition, 5, 4, 1, 0, 0, 2)
        if (ArmyID == 0) then
            ArmyID = nil
        end
        
        return ArmyID, SpawnedTroops
        
    end
        
    return nil
    
end

----------------------------------------------------------------------------------------------------------------------
function AttackWithRedPrinceArmy(_PlayerID, _SpawnPosition)

    if (Logic.GetStoreHouse(_PlayerID) ~= 0) then
    
        local ArmyID, SpawnedTroops = AIScript_SpawnAndAttackCity(RedPrincePlayerID, Logic.GetStoreHouse(_PlayerID), _SpawnPosition, 10, 6, 2, 2, 0, 6)    
        
        if (ArmyID == 0) then
            ArmyID = nil
        end
        
        return ArmyID, SpawnedTroops
        
    end

    return nil    
    
end



function Mission_Victory()

    local PossibleSettlerTypes = {Entities.U_NPC_Monk_SE,
                                  Entities.U_NPC_Villager01_SE,
                                  Entities.U_SpouseS01,
                                  Entities.U_SpouseS02,
                                  Entities.U_SpouseS03,
                                  Entities.U_SpouseF01,
                                  Entities.U_SpouseF02,
                                  Entities.U_SpouseF03 }                                  
    
    VictoryGenerateFestivalAtPlayer( SanTorranoPlayerID, PossibleSettlerTypes )    
    VictoryGenerateFestivalAtPlayer( CaspuenaPlayerID  , PossibleSettlerTypes )    
    VictoryGenerateFestivalAtPlayer( SeradilloPlayerID , PossibleSettlerTypes )    
    VictoryGenerateFestivalAtPlayer( HarborBayPlayerID , PossibleSettlerTypes )   
    
    Logic.StartFestival(1,0)

end