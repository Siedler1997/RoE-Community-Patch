--++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
-- Close Up View 
--++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++

g_CloseUpView = {}
g_CloseUpView.Active = false
g_CloseUpView.Front = true
g_CloseUpView.CameraHeight = 0



g_MilitaryFeedback = {}
g_MilitaryFeedback.States = {}
g_MilitaryFeedback.States["WalkCommand"] 						= "Yes"
g_MilitaryFeedback.States["CWalkCommand_CannotReach"]		 	= "No"
g_MilitaryFeedback.States["PatrolCommand"] 						= "Yes"
g_MilitaryFeedback.States["MountBuildingCommand"]				= "Yes"
g_MilitaryFeedback.States["MountBuildingCommand_CannotReach"]	= "No"
g_MilitaryFeedback.States["MountWallCommand"]					= "MountWall"
g_MilitaryFeedback.States["MountWallCommand_CannotReach"]		= "No"
g_MilitaryFeedback.States["GuardingForeigner"] 					= "Guard"
g_MilitaryFeedback.States["GuardCommand"] 						= "Guard"
g_MilitaryFeedback.States["AttackCommand"] 						= "Attack"
g_MilitaryFeedback.States["AttackCommand_OutOfAmmo"]			= "NoAmmunition"
g_MilitaryFeedback.States["AttackCommand_AttackMove"]			= "Attack"
g_MilitaryFeedback.States["AttackCommand_Capture"]				= "Capture"
g_MilitaryFeedback.States["AttackCommand_CannotReach"]			= "No"
g_MilitaryFeedback.States["ExplicitAttackCommand"]				= "Yes"
g_MilitaryFeedback.States["StealBuildingCommand_CannotReach"]	= "No"
g_MilitaryFeedback.States["StealBuildingCommand"]				= "Yes"
g_MilitaryFeedback.States["AttachToWarMachineCommand_CannotReach"]="No"
g_MilitaryFeedback.States["AttachToWarMachineCommand"]			= "Yes"

g_MilitaryFeedback.Variants = {}
g_MilitaryFeedback.Variants["No"] 						= 3
g_MilitaryFeedback.Variants["Yes"] 						= 8
g_MilitaryFeedback.Variants["Attack"] 					= 8
g_MilitaryFeedback.Variants["Guard"] 					= 5
g_MilitaryFeedback.Variants["NoAmmunition"] 			= 5
g_MilitaryFeedback.Variants["MountWall"] 				= 5
g_MilitaryFeedback.Variants["StealGold"]				= 3
g_MilitaryFeedback.Variants["Capture"]					= 5
g_MilitaryFeedback.Knights = {}
g_MilitaryFeedback.Knights[Entities.U_KnightTrading] 	= "H_Knight_Trading"
g_MilitaryFeedback.Knights[Entities.U_KnightHealing] 	= "H_Knight_Healing"
g_MilitaryFeedback.Knights[Entities.U_KnightChivalry] 	= "H_Knight_Chivalry"
g_MilitaryFeedback.Knights[Entities.U_KnightWisdom] 	= "H_Knight_Wisdom"
g_MilitaryFeedback.Knights[Entities.U_KnightPlunder] 	= "H_Knight_Plunder"
g_MilitaryFeedback.Knights[Entities.U_KnightSong] 		= "H_Knight_Song"
g_MilitaryFeedback.Knights[Entities.U_KnightSabatta] 	= "H_Knight_Sabatt"
g_MilitaryFeedback.Knights[Entities.U_KnightRedPrince] 	= "H_Knight_RedPrince"
g_MilitaryFeedback.Soldiers = {}
g_MilitaryFeedback.Soldiers[Entities.U_MilitaryBow]					= "Military_Bow"
g_MilitaryFeedback.Soldiers[Entities.U_MilitarySword]				= "Military_Sword"
g_MilitaryFeedback.Soldiers[Entities.U_MilitaryBandit_Melee_ME]		= "H_NPC_Mercenary_ME"
g_MilitaryFeedback.Soldiers[Entities.U_MilitaryBandit_Melee_NA]		= "H_NPC_Mercenary_NA"
g_MilitaryFeedback.Soldiers[Entities.U_MilitaryBandit_Melee_NE]		= "H_NPC_Mercenary_NE"
g_MilitaryFeedback.Soldiers[Entities.U_MilitaryBandit_Melee_SE]		= "H_NPC_Mercenary_SE"
g_MilitaryFeedback.Soldiers[Entities.U_MilitaryBandit_Ranged_ME]	= "H_NPC_Mercenary_ME"
g_MilitaryFeedback.Soldiers[Entities.U_MilitaryBandit_Ranged_NA]	= "H_NPC_Mercenary_NA"
g_MilitaryFeedback.Soldiers[Entities.U_MilitaryBandit_Ranged_NE]	= "H_NPC_Mercenary_NE"
g_MilitaryFeedback.Soldiers[Entities.U_MilitaryBandit_Ranged_SE]	= "H_NPC_Mercenary_SE"
g_MilitaryFeedback.Soldiers[Entities.U_MilitaryBow_RedPrince]		= "Military_Bow"
g_MilitaryFeedback.Soldiers[Entities.U_MilitarySword_RedPrince]		= "Military_Sword"

g_MilitaryFeedback.Thiefs = {}
g_MilitaryFeedback.Thiefs[Entities.U_Thief] 			= "Thief"

function MilitaryFeedback_GetSpeaker(_EntityID)

	local type = Logic.GetEntityType(_EntityID)

	if type == Entities.U_Thief then
	
		return g_MilitaryFeedback.Thiefs[Entities.U_Thief]

	end			

	if type == Entities.U_MilitaryCatapult then
	
		local leader = Logic.GetGuardianEntityID(_EntityID)
		
		local type = Logic.LeaderGetSoldiersType(leader)

		if g_MilitaryFeedback.Soldiers[type] ~= nil then
			return g_MilitaryFeedback.Soldiers[type]
		else
			return "H_NPC_Mercenary_SE"	
		end
	end

	if Logic.IsKnight(_EntityID) then
	
		return g_MilitaryFeedback.Knights[type]

	else
	
		if Logic.IsLeader(_EntityID) then

	 		local soldiers = {Logic.GetSoldiersAttachedToLeader(_EntityID)}

			if soldiers[1] == 0 then
			
				return ""
				
			end

			local EntityID = soldiers[2]
	
			type = Logic.GetEntityType(EntityID)
	
			if g_MilitaryFeedback.Soldiers[type] == nil then
			
				return ""
				
			end
			
			return g_MilitaryFeedback.Soldiers[type]
		
		else
		
			return ""
			
		end

	end	

	return ""
	
end

function MilitaryFeedback_GetType(_EntityID)

	local type = Logic.GetEntityType(_EntityID)

	if type == Entities.U_Thief then
	
		return "VoiceThief_speech"
		
	else
	
		return "VoiceMilitary_speech"
	
	end

end

function MilitaryFeedback_GetState(_Key)

	local state = g_MilitaryFeedback.States[_Key]

	if state == nil then
	
		return ""
		
	end 

	local variants = -1

	if g_MilitaryFeedback.Variants[state] ~= nil then
	
		variants = g_MilitaryFeedback.Variants[state]
		
	end 

	if variants ~= -1 then

		if variants > 9 then  
		
			return state .. "_rnd_" .. (1 + XGUIEng.GetRandom(variants -1))	
			
		else 

			return state .. "_rnd_0" .. (1 + XGUIEng.GetRandom(variants -1))	
		
		end
		
	else
	
		return ""
	
	end

end


function MilitaryFeedback(_EntityID,_Key)

	local folder = "Voices"

	local type = MilitaryFeedback_GetType(_EntityID)

	local speaker = MilitaryFeedback_GetSpeaker(_EntityID)
	
	local state = MilitaryFeedback_GetState(_Key)
	
	if speaker == "" or state == "" then
	
		return
		
	end

	if speaker == nil or state == nil then
	
		return
		
	end
	
	Sound.PlayVoice("SettlersFeedbackVoice", folder.."/"..speaker.."/"..type.."_"..state..".mp3")

end


g_HeroAbilityFeedback = {}
g_HeroAbilityFeedback.Knights = {}
g_HeroAbilityFeedback.Knights[Entities.U_KnightTrading] 	= "Trading"
g_HeroAbilityFeedback.Knights[Entities.U_KnightHealing] 	= "Healing"
g_HeroAbilityFeedback.Knights[Entities.U_KnightChivalry] 	= "Chivalry"
g_HeroAbilityFeedback.Knights[Entities.U_KnightWisdom] 		= "Wisdom"
g_HeroAbilityFeedback.Knights[Entities.U_KnightPlunder] 	= "Plunder"
g_HeroAbilityFeedback.Knights[Entities.U_KnightSong] 		= "Song"
g_HeroAbilityFeedback.Knights[Entities.U_KnightSabatta] 	= "Sabatta"
g_HeroAbilityFeedback.Knights[Entities.U_KnightRedPrince] 	= "RedPrince"

function HeroAbilityFeedback(_EntityID)

	local type = Logic.GetEntityType(_EntityID)
 
	local name = g_HeroAbilityFeedback.Knights[type]

	local random = "_rnd_0" .. (1 + XGUIEng.GetRandom(3))	

	local speaker = MilitaryFeedback_GetSpeaker(_EntityID)

	local voice = "Voices/"..speaker.."/".."VoiceKnight"..name.."_speech_Ability"..random..".mp3"

	Sound.PlayVoice("MinimapFeedbackSpeech",voice)

end 


function ShowCloseUpView(_EntityID, _OptionalX, _OptionalY)
    
    if (_EntityID ~= 0) then
    
        Camera.CloseUp_SetEntityID(_EntityID);
        Camera.SwitchCameraBehaviour(1);
            
        PlaySettlersVoice(_EntityID)

        Display.SetCameraLookAtEntity(_EntityID)    
        Display.UseCloseUpSettings()

        g_CloseUpView.Active = true 
        gvCamera.DefaultFlag = 0
        
    else

        if (Camera.GetCameraBehaviour() ~= 0) then
    
            local CloseX, CloseY = Camera.CloseUp_GetLastLookAtPosition()
            
            CloseX = _OptionalX or CloseX
            CloseY = _OptionalY or CloseY
            
            Camera.RTS_SetLookAtPosition(CloseX, CloseY)
   
            Camera.SwitchCameraBehaviour(0);
        end

        Display.SetCameraLookAtEntity(0)
        Display.UseStandardSettings()
                            
        if (_EntityID ~= nil) and (_EntityID ~= 0) and (Logic.IsKnight(_EntityID) == true) then                 
            local X, Y = Logic.GetEntityPosition(_EntityID)             
            Camera.RTS_SetLookAtPosition(X, Y)          
        end

        g_CloseUpView.Active = false    
        gvCamera.DefaultFlag = 1
    end
end


g_SettlersVoices = {}
g_WorkersVoicesCounter = 1
g_SpousesVoicesCounter = 1

function PlaySettlersVoice(_EntityID)
    
    local ZoomFactor = Camera.RTS_GetZoomFactor()
    
    if ZoomFactor > 0.35 then
        return
    end

    -- wich settler
    local EntityType = Logic.GetEntityType(_EntityID)
    local PlayerID = GUI.GetPlayerID()

    
    --for workers:
    if Logic.IsWorker(_EntityID) == 1 then        
        if g_SettlersVoices[EntityType] == nil then     
            
            if g_WorkersVoicesCounter  > 6 then
                g_WorkersVoicesCounter = 1
            end
            
            if EntityType == Entities.U_BathWorker then
                g_SettlersVoices[EntityType] = "Spouse_03"
            else
                g_SettlersVoices[EntityType] = "Worker_0" .. g_WorkersVoicesCounter
            end
            
            g_WorkersVoicesCounter = g_WorkersVoicesCounter + 1
        end
    elseif Logic.IsSpouse(_EntityID) then
        
        --for spouses
        if g_SettlersVoices[EntityType] == nil then     
            
            if g_SpousesVoicesCounter  > 3 then
                g_SpousesVoicesCounter = 1
            end
            
            g_SettlersVoices[EntityType] = "Spouse_0" .. g_SpousesVoicesCounter
            
            g_SpousesVoicesCounter = g_SpousesVoicesCounter + 1
        end
    else
        return
    end
    
    local BuildingID = Logic.GetSettlersWorkBuilding(_EntityID)    
    local SettlerType = g_SettlersVoices[EntityType]
    
    
    local TextKeyBase = "" --"MoraleHigh"
    
    local TaskType, DestinationEntityType, GoodType, Amount, ErrorCode, FleeReason, IdleReason = 
            Logic.GetTaskHistoryEntry(_EntityID, 0)
    
    local TaskTypeName = Logic.GetHistoryTaskTypeName(TaskType)
    local IdleReasonName = Logic.GetHistoryIdleReasonName(IdleReason)
    
    
    --GUI.AddNote(TaskTypeName)
    
    --FIRST THE TASKS
    if TaskType == HistoryTaskTypes.TaskTypeExtinguishFire then 
        TextKeyBase = "Fire"
    end
    
    if TaskType == HistoryTaskTypes.TaskTypeIdle then
        
        if      IdleReason == HistoryIdleReasons.IdleReasonNoResource and Logic.IsEntityInCategory(BuildingID, EntityCategories.CityBuilding) == 1 then TextKeyBase = "IdleNoResource"
        elseif  IdleReason == HistoryIdleReasons.IdleReasonNoResource and Logic.IsEntityInCategory(BuildingID, EntityCategories.OuterRimBuilding) == 1 then TextKeyBase = "IdleNoGatherResource"
        elseif  IdleReason == HistoryIdleReasons.IdleReasonNoSpaceInStoreHouse then TextKeyBase = "IdleStorehouseFull"
        end
    end
        
    if TaskType == HistoryTaskTypes.TaskTypeGoToSermon then TextKeyBase = "Sermon" end
            
    if TaskType == HistoryTaskTypes.TaskTypeEnjoyingFestival then 
        --todo: find out if it is a normal fetival
        local KnightType = Logic.GetEntityType(Logic.GetKnightID(PlayerID))
        TextKeyBase = "OurKnightIsProgressing" .. KnightGender[KnightType]
    end
    
            
    if TextKeyBase == "" then
            
        --THEN THE PERSONAL NEEDS
        local NumberOfUnsatisfiedNeeds = 0
        
        --ENTERTAINMENT
        if Logic.GetNeedState(BuildingID, Needs.Entertainment) <= Logic.GetNeedCriticalThreshold(BuildingID, Needs.Entertainment)then 
            TextKeyBase = "NoEntertainment"
            NumberOfUnsatisfiedNeeds = NumberOfUnsatisfiedNeeds + 1
        end
        
        -- FOOD    
        if  Logic.GetNeedState(BuildingID, Needs.Nutrition) <= Logic.GetNeedCriticalThreshold(BuildingID, Needs.Nutrition) then            
            TextKeyBase = "NoFood"
            NumberOfUnsatisfiedNeeds = NumberOfUnsatisfiedNeeds + 1
        end
            
        -- HYGIENE        
        if Logic.GetNeedState(BuildingID, Needs.Hygiene) <= Logic.GetNeedCriticalThreshold(BuildingID, Needs.Hygiene) then
            TextKeyBase = "NoCleanHouse"
            NumberOfUnsatisfiedNeeds = NumberOfUnsatisfiedNeeds + 1
        end
        
        --CLOTHES
        if Logic.GetNeedState(BuildingID, Needs.Clothes) <= Logic.GetNeedCriticalThreshold(BuildingID, Needs.Clothes) then
            TextKeyBase = "NoClothes"
            NumberOfUnsatisfiedNeeds = NumberOfUnsatisfiedNeeds + 1
        end
        
        --ILLNESS
        if Logic.GetNeedState(BuildingID, Needs.Medicine) <= Logic.GetNeedCriticalThreshold(BuildingID, Needs.Medicine) then
            TextKeyBase = "Ill"
            NumberOfUnsatisfiedNeeds = NumberOfUnsatisfiedNeeds + 1
        end
        
        
        if NumberOfUnsatisfiedNeeds > 1 then
            TextKeyBase = "Unsatisfied"
        end
        
    end
       
    
    --THEN SOMETHING RANDOM
    if TextKeyBase == "" then
    
        SettlersVoicesTable = {}
        
        SettlersVoicesTable[#SettlersVoicesTable+1] = { Logic.IsNeedActive(BuildingID, Needs.Nutrition) 
                                                        and GetNumberOfGoodsOfPlayerInGoodCategory(GoodCategories.GC_Food, PlayerID) <= 3, 
                                                        "WeNeedMoreFood" }
                                                        
        SettlersVoicesTable[#SettlersVoicesTable+1] = { Logic.IsEntityInCategory(BuildingID, EntityCategories.CityBuilding) == 1 
                                                        and Logic.IsNeedActive(BuildingID, Needs.Clothes) 
                                                        and GetNumberOfGoodsOfPlayerInGoodCategory(GoodCategories.GC_Clothes, PlayerID)  < 3, 
                                                        "WeNeedMoreClothes"}
                                                        
        SettlersVoicesTable[#SettlersVoicesTable+1] = { Logic.IsEntityInCategory(BuildingID, EntityCategories.CityBuilding) == 1 
                                                        and Logic.IsNeedActive(BuildingID, Needs.Hygiene) 
                                                        and GetNumberOfGoodsOfPlayerInGoodCategory(GoodCategories.GC_Hygiene, PlayerID)  < 3, 
                                                        "WeNeedMoreHygiene"}
                                                        
        SettlersVoicesTable[#SettlersVoicesTable+1] = { Logic.IsEntityInCategory(BuildingID, EntityCategories.CityBuilding) == 1 
                                                        and Logic.IsNeedActive(BuildingID, Needs.Entertainment) 
                                                        and GetNumberOfGoodsOfPlayerInGoodCategory(GoodCategories.GC_Entertainment, PlayerID)  < 3, 
                                                        "WeNeedMoreEntertainment"}

        
        SettlersVoicesTable[#SettlersVoicesTable+1] = { Logic.GetCityReputation(PlayerID) >= 0.2 and Logic.GetCityReputation(PlayerID) <= 0.4, "MoraleLow"}        
        SettlersVoicesTable[#SettlersVoicesTable+1] = { Logic.GetCityReputation(PlayerID) >= 0.7 , "MoraleHigh"}
        
        SettlersVoicesTable[#SettlersVoicesTable+1] = { Logic.IsEntityInCategory(BuildingID, EntityCategories.CityBuilding) == 1 
                                                        and Logic.IsNeedActive(BuildingID, Needs.Prosperity) 
                                                        and Logic.GetBuildingProsperityIndex(BuildingID) == 1 , 
                                                        "Rich"}
                                                        
        SettlersVoicesTable[#SettlersVoicesTable+1] = { Logic.IsEntityInCategory(BuildingID, EntityCategories.CityBuilding) == 1 
                                                        and Logic.IsNeedActive(BuildingID, Needs.Prosperity) 
                                                        and Logic.GetBuildingProsperityIndex(BuildingID) == 0 , 
                                                        "WantToBeRich"}
                                                        
        SettlersVoicesTable[#SettlersVoicesTable+1] = { Logic.IsEntityInCategory(BuildingID, EntityCategories.CityBuilding) == 1  
                                                        and Logic.IsNeedActive(BuildingID, Needs.Prosperity) 
                                                        and Logic.GetBuildingProsperityIndex(BuildingID) == 0 , 
                                                        "Poor"}
        
        SettlersVoicesTable[#SettlersVoicesTable+1] = { Logic.GetUpgradeLevel(Logic.GetHeadquarters(PlayerID), 0) >= 1 , "CastleUpgraded"}
        SettlersVoicesTable[#SettlersVoicesTable+1] = { Logic.GetUpgradeLevel(Logic.GetCathedral(PlayerID), 0) >= 1 , "CathedralUpgraded"}
        SettlersVoicesTable[#SettlersVoicesTable+1] = { Logic.GetUpgradeLevel(Logic.GetStoreHouse(PlayerID), 0) >= 1 , "StorehouseUpgraded"}
        
        
        SettlersVoicesTable[#SettlersVoicesTable+1] = { Logic.IsEntityInCategory(BuildingID, EntityCategories.CityBuilding) == 1 
                                                        and Logic.IsNeedActive(BuildingID, Needs.Wealth)
                                                        and Logic.GetBuildingWealthGoodState(BuildingID, Goods.G_Banner ) == 0 
                                                        and Logic.GetBuildingWealthGoodState(BuildingID, Goods.G_Sign  ) == 0 
                                                        and Logic.GetBuildingWealthGoodState(BuildingID, Goods.G_Candle) == 0 
                                                        and Logic.GetBuildingWealthGoodState(BuildingID, Goods.G_Ornament  ) == 0,
                                                        "WantToHaveANiceHouse"}
                                                        
        SettlersVoicesTable[#SettlersVoicesTable+1] = { Logic.IsNeedActive(BuildingID, Needs.Wealth) 
                                                        and Logic.GetBuildingWealthGoodState(BuildingID, Goods.G_Banner ) > 0 
                                                        and Logic.GetBuildingWealthGoodState(BuildingID, Goods.G_Sign  ) > 0 
                                                        and Logic.GetBuildingWealthGoodState(BuildingID, Goods.G_Candle) > 0 
                                                        and Logic.GetBuildingWealthGoodState(BuildingID, Goods.G_Ornament  ) > 0,
                                                        "HasAllDecorations"}
                                                        
        
        SettlersVoicesTable[#SettlersVoicesTable+1] = { Logic.IsNeedActive(BuildingID, Needs.Wealth) 
                                                        and Logic.GetBuildingWealthGoodState(BuildingID, Goods.G_Banner ) > 0,
                                                        "HasBanner"}
        
        SettlersVoicesTable[#SettlersVoicesTable+1] = { Logic.IsNeedActive(BuildingID, Needs.Wealth) 
                                                        and Logic.GetBuildingWealthGoodState(BuildingID, Goods.G_Ornament ) > 0,
                                                        "HasOrnaments"}
        
        SettlersVoicesTable[#SettlersVoicesTable+1] = { Logic.IsNeedActive(BuildingID, Needs.Wealth )
                                                        and Logic.GetBuildingWealthGoodState(BuildingID, Goods.G_Candle ) > 0,
                                                        "HasCandles"}

        SettlersVoicesTable[#SettlersVoicesTable+1] = { Logic.IsNeedActive(BuildingID, Needs.Wealth) 
                                                        and Logic.GetBuildingWealthGoodState(BuildingID, Goods.G_Sign ) > 0, 
                                                        "HasBench"}
        
        
        SettlersVoicesTable[#SettlersVoicesTable+1] = { Logic.IsNeedActive(BuildingID, Needs.Wealth) 
                                                        and Logic.GetBuildingWealthGoodState(BuildingID, Goods.G_Sign ) > 0, 
                                                        "HasBench"}
        
        SettlersVoicesTable[#SettlersVoicesTable+1] = { Logic.GetTime() > 60*20 and g_EndStatistic[PlayerID].GoodsBought == 0, "WeShouldTradeMore" }
        
        local EnemiesAreRicher = false
        local EnemiesMoreSoldiers = false
        local EnemiesHaveStrikers = false
        local EnemiesHaveTerritories = false
        local BanditsOnTheMap = false
        local HighestTitle = Logic.GetKnightTitle(PlayerID)
        
        for OtherPlayerID=1,8 do 
            if OtherPlayerID ~= PlayerID and GetPlayerCategoryType(OtherPlayerID) == PlayerCategories.City then            
                if Diplomacy_GetRelationBetween(OtherPlayerID, PlayerID) == DiplomacyStates.Enemy then
                    
                    if EnemiesAreRicher ~= true and GetPlayerGoodsInSettlement(Goods.G_Gold,OtherPlayerID) > GetPlayerGoodsInSettlement(Goods.G_Gold,PlayerID) then
                        SettlersVoicesTable[#SettlersVoicesTable+1] = { true, "OurEnemiesHaveMuchMoreGold"}
                        EnemiesAreRicher = true 
                    end
                    
                    if EnemiesMoreSoldiers ~= true and Logic.GetCurrentSoldierCount(OtherPlayerID) > Logic.GetCurrentSoldierCount(PlayerID) then
                        SettlersVoicesTable[#SettlersVoicesTable+1] = { true, "OurEnemiesHaveMuchMoreSoldiers"}
                        EnemiesMoreSoldiers = true 
                    end
                    
                    if EnemiesHaveStrikers ~= true and GetNumberOfStrikersOfPlayer(OtherPlayerID) > 3 then
                        SettlersVoicesTable[#SettlersVoicesTable+1] = { true, "OurEnemiesHaveStrikers"}
                        EnemiesHaveStrikers = true 
                    end
                    
                    if EnemiesHaveTerritories ~= true and GetNumberOfTerritoriesOfPlayer( OtherPlayerID) >=  GetNumberOfTerritoriesOfPlayer( PlayerID) + 2 then
                        SettlersVoicesTable[#SettlersVoicesTable+1] = { true, "OurEnemiesClaimedALotOfTerritories"}
                        EnemiesHaveTerritories = true 
                    end
                end
            end
            
            if BanditsOnTheMap ~= true and GetPlayerCategoryType(OtherPlayerID) == PlayerCategories.BanditsCamp then
                SettlersVoicesTable[#SettlersVoicesTable+1] = { true, "ThereAreBanditsOnTheMap"}
                BanditsOnTheMap = true
            end
            
            if OtherPlayerID ~= PlayerID and Logic.GetKnightTitle(OtherPlayerID) >= HighestTitle then
                HighestTitle = Logic.GetKnightTitle(OtherPlayerID)
            end
            
        end
        
        local HighestKnightTitleText = "TheHighestTitleOnTheMapIsKnight"
        
        
        if HighestTitle == 1 then
            HighestKnightTitleText = "TheHighestTitleOnTheMapIsKnight"
        elseif HighestTitle == 2 then
            HighestKnightTitleText = "TheHighestTitleOnTheMapIsMayor"
        elseif HighestTitle == 3 then
            HighestKnightTitleText = "TheHighestTitleOnTheMapIsEarl"
        elseif HighestTitle == 4 then
            HighestKnightTitleText = "TheHighestTitleOnTheMapIsBaron"
        elseif HighestTitle == 5 then
            HighestKnightTitleText = "TheHighestTitleOnTheMapIsMarquees"
        elseif HighestTitle == 6 then
            HighestKnightTitleText = "TheHighestTitleOnTheMapIsDuke"
        end
        
        SettlersVoicesTable[#SettlersVoicesTable+1] = { true, HighestKnightTitleText}
        
        SettlersVoicesTable[#SettlersVoicesTable+1] = { Logic.GetTaxationLevel(PlayerID) == 0, "TaxesLow" }
        SettlersVoicesTable[#SettlersVoicesTable+1] = { Logic.GetTaxationLevel(PlayerID) == 2, "TaxesHigh" }
        
        --SettlersVoicesTable[#SettlersVoicesTable+1] = { #HiddenTreasures[0] > 0 , "ThereAreTreasuresOnTheMap"}
        
        
        
        --"WeShouldHelpTheVillage" when quest from village ??
        --"WeShouldHelpTheCloister"  when quest from cloister ??
        --"WeShouldHelpTheCity" when quest from city ??
        --"Plague" ??
        --"Thieves" ??

        for i = 1, 6 do
            
            local BuffID
            local BuffKey
        
            if i == 1 then
                BuffID = Buffs.Buff_Entertainers
                BuffKey = "EntertainerInCity" 
            elseif i == 2 then
                BuffID = Buffs.Buff_Spice
                BuffKey = "StorehouseHasSalt"
            elseif i == 3 then
                BuffID = Buffs.Buff_Colour
                BuffKey = "StorehouseHasDye"
            elseif i == 4 then
                BuffID = Buffs.Buff_SomeEnemySoldiersInCity
                BuffKey = "EnemiesInCity"
            elseif i == 5 then
                BuffID = Buffs.Buff_MoreEnemySoldiersInCity
                BuffKey = "TooManyEnemies"            
            elseif i == 6 then
                BuffID = Buffs.Buff_NoPayment
                BuffKey = "IncreasePayment"
            elseif i == 7 then
                BuffID = Buffs.Buff_ExtraPayment
                BuffKey = "DecreasePayment"            
            end
                
            local BuffCategory, SecondsLeft, CitySatisfactionModifier = Logic.GetBuff(PlayerID,BuffID)
            
            SettlersVoicesTable[#SettlersVoicesTable+1] = { SecondsLeft ~= nil and SecondsLeft > 0, BuffKey}        
        end
 

        local Tries = 0        
        
        repeat
    
            local RandomIndex = 1 + XGUIEng.GetRandom(#SettlersVoicesTable-1)
            
            if SettlersVoicesTable[RandomIndex][1] then 
                TextKeyBase = SettlersVoicesTable[RandomIndex][2] 
            end
            
            Tries = Tries + 1
        
        until TextKeyBase ~= ""  or Tries == 5000--( #SettlersVoicesTable * 50 )
        
        if TextKeyBase == "" then
            TextKeyBase = "MoraleHigh"
        end
    
    end

    
    local Text
    local Tries = 0 
    local TextKey
    
    repeat
    
        local rand = 1 + XGUIEng.GetRandom(9 - Tries)
        TextKey = TextKeyBase .. "_rnd_0" ..rand
        Text = XGUIEng.GetStringTableText("VoiceSettlers_speech/" .. TextKey)
        
        Tries = Tries + 1
    
    until Text ~= "" or Tries == 10 
    
    if Text == "" then
        Text = "VoiceKey missing, or bug in voice selection"
    end
    
--    NOT SHOWN ANY MORE - NOT THE RIGHT PLACE - SEE WITH AlBr

--    local Subtitles = Options.GetIntValue("Video", "Subtitles")
--    
--    if Subtitles == 1 then
--        local EntityTypeName = Logic.GetEntityTypeName(Logic.GetEntityType(_EntityID))
--        EntityTypeName = XGUIEng.GetStringTableText("UI_ObjectNames/" .. EntityTypeName)
--        GUI.AddNote(EntityTypeName .. ": " .. Text)
--    end
    
    Sound.PlayVoice("SettlersFeedbackVoice", "Voices/" .. SettlerType  .. "/VoiceSettlers_speech_" .. TextKey .. ".mp3")
end
