-----------------------------------------------------------------------------------------
-- Overwrites
-- it must be in a function because the mapeditor uses the overwritten functions too
-- but doesnt initializes the whole framework
-----------------------------------------------------------------------------------------
function InitLocalOverwrite()

    -----------------------------------------------------------------
    -- Buffs
    -----------------------------------------------------------------
    local OldInitBuffs = InitBuffs
    
    InitBuffs = function()
    
        -- call old initializer
        OldInitBuffs()
        
        -- new buffs
        g_Buffs.Widgets[Buffs.Buff_Gems or -1]          = "/InGame/Root/Normal/AlignTopLeft/TopBar/Buffs/Buff_Gems" --Luxory/Buff_Gems"
        g_Buffs.Widgets[Buffs.Buff_Olibanum or -1]          = "/InGame/Root/Normal/AlignTopLeft/TopBar/Buffs/Buff_Olibanum" --Luxory/Buff_Olibanum"
        g_Buffs.Widgets[Buffs.Buff_MusicalInstrument or -1] = "/InGame/Root/Normal/AlignTopLeft/TopBar/Buffs/Buff_MusicalInstrument" --Luxory/Buff_MusicalInstrument"
        
    end


    -----------------------------------------------------------------
    -- CloseupView
    -----------------------------------------------------------------
    do
        g_MilitaryFeedback.States["ExplicitAttackCommand"]				= "Attack"
        g_MilitaryFeedback.States["HoldGroundCommand"]			        = "HoldPosition"
        g_MilitaryFeedback.States["ShootCatapultCommand"] 				= "ShootCatapult"
        g_MilitaryFeedback.States["OpenGateCommand"] 				    = "ForceOpenGate"
        g_MilitaryFeedback.States["StealBuildingCommand"] 				= "StealBuilding"
        
        g_MilitaryFeedback.Variants["No"] 						= 5
        g_MilitaryFeedback.Variants["Yes"] 						= 10
        g_MilitaryFeedback.Variants["Attack"] 					= 10
        g_MilitaryFeedback.Variants["HoldPosition"]				= 5
        g_MilitaryFeedback.Variants["ShootCatapult"]			= 5
        
        g_MilitaryFeedback.Knights[Entities.U_KnightSabatta] 	         = "H_Knight_Sabatt"
        g_MilitaryFeedback.Knights[Entities.U_KnightRedPrince] 	         = "H_Knight_RedPrince"
        g_MilitaryFeedback.Knights[Entities.U_KnightSaraya]              = "H_Knight_Saraya"
        
        g_HeroAbilityFeedback.Knights[Entities.U_KnightSabatta] 	= "Sabatta"
        g_HeroAbilityFeedback.Knights[Entities.U_KnightRedPrince] 	= "RedPrince"
        g_HeroAbilityFeedback.Knights[Entities.U_KnightSaraya] 		     = "Tribute"
        g_HeroAbilityFeedback.Knights[Entities.U_KnightPraphat] 		 = "Praphat"
        g_HeroAbilityFeedback.Knights[Entities.U_KnightKhana] 		     = "Khana"
        
        g_MilitaryFeedback.Knights[Entities.U_KnightKhana]              = "H_Knight_Khana"
        g_MilitaryFeedback.Knights[Entities.U_KnightPraphat]              = "H_Knight_Praphat"
        
        g_MilitaryFeedback.Soldiers[Entities.U_MilitaryBandit_Melee_ME]		= "H_NPC_Mercenary_ME"
        g_MilitaryFeedback.Soldiers[Entities.U_MilitaryBandit_Melee_NA]		= "H_NPC_Mercenary_NA"
        g_MilitaryFeedback.Soldiers[Entities.U_MilitaryBandit_Melee_NE]		= "H_NPC_Mercenary_NE"
        g_MilitaryFeedback.Soldiers[Entities.U_MilitaryBandit_Melee_SE]		= "H_NPC_Mercenary_SE"
        g_MilitaryFeedback.Soldiers[Entities.U_MilitaryBandit_Ranged_ME]	= "H_NPC_Mercenary_ME"
        g_MilitaryFeedback.Soldiers[Entities.U_MilitaryBandit_Ranged_NA]	= "H_NPC_Mercenary_NA"
        g_MilitaryFeedback.Soldiers[Entities.U_MilitaryBandit_Ranged_NE]	= "H_NPC_Mercenary_NE"
        g_MilitaryFeedback.Soldiers[Entities.U_MilitaryBandit_Ranged_SE]	= "H_NPC_Mercenary_SE"
        g_MilitaryFeedback.Soldiers[Entities.U_MilitaryBow_RedPrince]		= "H_NPC_Mercenary_SE"
        g_MilitaryFeedback.Soldiers[Entities.U_MilitarySword_RedPrince]		= "H_NPC_Mercenary_SE"
        g_MilitaryFeedback.Soldiers[Entities.U_MilitarySpear]				= "H_NPC_Mercenary_NE"
        g_MilitaryFeedback.Soldiers[Entities.U_Helbardier]				    = "H_NPC_Mercenary_NE"
        g_MilitaryFeedback.Soldiers[Entities.U_MilitaryBandit_Melee_AS]		= "H_NPC_Mercenary_NA"
        g_MilitaryFeedback.Soldiers[Entities.U_MilitaryBandit_Ranged_AS]	= "H_NPC_Mercenary_NA"
        g_MilitaryFeedback.Soldiers[Entities.U_MilitarySword_Khana]		= "H_NPC_Mercenary_ME"
        g_MilitaryFeedback.Soldiers[Entities.U_MilitaryBow_Khana]	= "H_NPC_Mercenary_ME"
        
        g_MilitaryFeedback.ThiefFeedbackVariants = {
            "StealGold_rnd_01",
            "StealInformation_rnd_02",
            "StealInformation_rnd_04"
        }

        g_MilitaryFeedback.Animals = {}
        g_MilitaryFeedback.Animals[Entities.U_Tiger] 			= "Tiger"
        g_MilitaryFeedback.Animals[Entities.U_Lion_Male] 		= "Lion"
        g_MilitaryFeedback.Animals[Entities.U_Lion_Female] 		= "Lion"
        g_MilitaryFeedback.Animals[Entities.U_Bear] 		    = "Bear"
        g_MilitaryFeedback.Animals[Entities.U_BlackBear] 		= "Bear"
        g_MilitaryFeedback.Animals[Entities.U_PolarBear] 		= "Bear"
        g_MilitaryFeedback.Animals[Entities.U_Wolf_Grey] 		= "Wolf"
        g_MilitaryFeedback.Animals[Entities.U_Wolf_White] 		= "Wolf"
        g_MilitaryFeedback.Animals[Entities.U_Wolf_Black] 		= "Wolf"
        g_MilitaryFeedback.Animals[Entities.U_Wolf_Brown] 		= "Wolf"
    end      

    -----------------------------------------------------------------
    -- FeedbackSpeech
    -----------------------------------------------------------------
    do 
        local OldInitFeedbackSpeech = InitFeedbackSpeech
        
        function InitFeedbackSpeech()
    
            OldInitFeedbackSpeech()
        
            g_FeedbackSpeech.Categories.AttackedTradePost         = {["Prio"] = 2, ["IgnoreTime"] = 30, ["Sound"] = "ui\\mini_under_attack", ["SignalType"] = g_FeedbackSpeech.SignalTypes.BigRed}
            g_FeedbackSpeech.Categories.DestroyedTradePost        = {["Prio"] = 2, ["IgnoreTime"] = -1, ["Sound"] = "ui\\menu_left_killed", ["SignalType"] = g_FeedbackSpeech.SignalTypes.DestroyedRed}
            g_FeedbackSpeech.Categories.AttackedGeologist         = {["Prio"] = 2, ["IgnoreTime"] = 30, ["Sound"] = "ui\\mini_under_attack", ["SignalType"] = g_FeedbackSpeech.SignalTypes.BigRed}
            g_FeedbackSpeech.Categories.DestroyedGeologist        = {["Prio"] = 2, ["IgnoreTime"] = -1, ["Sound"] = "ui\\menu_left_killed", ["SignalType"] = g_FeedbackSpeech.SignalTypes.DestroyedRed}

            g_FeedbackSpeech.Categories.GeologistCalled           = {["Prio"] = 5, ["IgnoreTime"] = 4, ["Sound"] = nil, ["SignalType"] = nil}
            g_FeedbackSpeech.Categories.GeologistRefilled         = {["Prio"] = 5, ["IgnoreTime"] = 4, ["Sound"] = nil, ["SignalType"] = nil}
            g_FeedbackSpeech.Categories.TradePost_NoGoods         = {["Prio"] = 5, ["IgnoreTime"] = 4, ["Sound"] = nil, ["SignalType"] = nil}
            g_FeedbackSpeech.Categories.TradePost_TradeCartSent   = {["Prio"] = 6, ["IgnoreTime"] = 4, ["Sound"] = nil, ["SignalType"] = nil}
            g_FeedbackSpeech.Categories.TradePost_Constructed     = {["Prio"] = 5, ["IgnoreTime"] = 4, ["Sound"] = nil, ["SignalType"] = nil}
            g_FeedbackSpeech.Categories.CannotEnterSettlement     = {["Prio"] = 5, ["IgnoreTime"] = 4, ["Sound"] = nil, ["SignalType"] = nil}
            g_FeedbackSpeech.Categories.WellRanDry                = {["Prio"] = 5, ["IgnoreTime"] = 150, ["Sound"] = nil, ["SignalType"] = g_FeedbackSpeech.SignalTypes.DefaultYellow}
            g_FeedbackSpeech.Categories.Monsoon                   = {["Prio"] = 5, ["IgnoreTime"] = 4, ["Sound"] = nil, ["SignalType"] = nil}
            g_FeedbackSpeech.Categories.ThiefSabotagedWell        = {["Prio"] = 5, ["IgnoreTime"] = 4, ["Sound"] = nil, ["SignalType"] = nil}
            
            
            
            g_FeedbackSpeech.LastCategorySpeechTimes.AttackedTradePost = -100000
            g_FeedbackSpeech.LastCategorySpeechTimes.DestroyedTradePost = -100000
            g_FeedbackSpeech.LastCategorySpeechTimes.AttackedGeologist = -100000
            g_FeedbackSpeech.LastCategorySpeechTimes.DestroyedGeologist = -100000
            g_FeedbackSpeech.LastCategorySpeechTimes.GeologistCalled = -100000
            g_FeedbackSpeech.LastCategorySpeechTimes.GeologistRefilled = -100000
            g_FeedbackSpeech.LastCategorySpeechTimes.TradePost_NoGoods = -100000
            g_FeedbackSpeech.LastCategorySpeechTimes.TradePost_TradeCartSent = -100000
            g_FeedbackSpeech.LastCategorySpeechTimes.TradePost_Constructed = -100000
            g_FeedbackSpeech.LastCategorySpeechTimes.CannotEnterSettlement = -100000
            g_FeedbackSpeech.LastCategorySpeechTimes.WellRanDry = -100000
            g_FeedbackSpeech.LastCategorySpeechTimes.Monsoon = -100000
            g_FeedbackSpeech.LastCategorySpeechTimes.ThiefSabotagedWell = -100000
            
        end
    end
    
    
    -----------------------------------------------------------------
    -- TexturePositions
    -----------------------------------------------------------------
    do 
        local OldInitTexturePositions = InitTexturePositions
        
        InitTexturePositions = function()
            
            --call old initializer
            OldInitTexturePositions()
            
            -- Goods
            g_TexturePositions.Goods[Goods.G_Regalia] =  {16, 4}
            g_TexturePositions.Goods[Goods.G_PoorSpear] =  {16, 12}
            g_TexturePositions.Goods[Goods.G_Spear] =  {1, 16}
            g_TexturePositions.Goods[Goods.G_Gems] =  {1, 1, 1}
            g_TexturePositions.Goods[Goods.G_Olibanum] =  {1, 2, 1}
            g_TexturePositions.Goods[Goods.G_MusicalInstrument] =  {1, 3, 1}
            
            -- Entity Types
            g_TexturePositions.Entities[Entities.B_TradePost] = {3, 1, 1}
            g_TexturePositions.Entities[Entities.B_Castle_AS] = {3, 14}
            g_TexturePositions.Entities[Entities.B_Cistern] = {1, 16}
            g_TexturePositions.Entities[Entities.B_KhanaTemple] = {1, 7, 1}
            g_TexturePositions.Entities[Entities.B_NPC_StoreHouse_AS] = {3, 13}
            
            g_TexturePositions.Entities[Entities.U_Geologist] = {8, 1, 1}
            g_TexturePositions.Entities[Entities.U_KnightSaraya] = {5, 4, 1}
            g_TexturePositions.Entities[Entities.U_KnightKhana] = {6, 1, 1}
            g_TexturePositions.Entities[Entities.U_KnightPraphat] = {5, 3, 1}
            g_TexturePositions.Entities[Entities.U_NPC_Castellan_ME] = {7, 2, 1}
            g_TexturePositions.Entities[Entities.U_NPC_Castellan_NE] = {7, 2, 1}
            g_TexturePositions.Entities[Entities.U_NPC_Castellan_SE] = {7, 2, 1}
            g_TexturePositions.Entities[Entities.U_NPC_Castellan_NA] = {7, 2, 1}
            g_TexturePositions.Entities[Entities.U_NPC_Castellan_AS] = {7, 2, 1}
            
            g_TexturePositions.Entities[Entities.U_MilitaryBandit_Melee_AS] = {9, 15}
            g_TexturePositions.Entities[Entities.U_MilitaryBandit_Ranged_AS] = {9, 16}
            g_TexturePositions.Entities[Entities.U_MilitarySword_Khana] = {6, 3, 1}
            g_TexturePositions.Entities[Entities.U_MilitaryBow_Khana] = {6, 2, 1}

            g_TexturePositions.Entities[Entities.A_AS_Tiger] = {1, 8, 1}

            g_TexturePositions.Entities[Entities.U_HolyCow]  = {3, 3, 1}
            g_TexturePositions.Entities[Entities.I_X_Holy_Cow]  = {3, 3, 1}

            g_TexturePositions.Entities[Entities.B_Beautification_Brazier]          = {4, 1, 1}
            g_TexturePositions.Entities[Entities.B_Beautification_Pillar]           = {4, 2, 1}
            g_TexturePositions.Entities[Entities.B_Beautification_Shrine]           = {4, 3, 1}
            g_TexturePositions.Entities[Entities.B_Beautification_StoneBench]       = {4, 4, 1}
            g_TexturePositions.Entities[Entities.B_Beautification_Sundial]          = {5, 1, 1}
            g_TexturePositions.Entities[Entities.B_Beautification_TriumphalArch]    = {1, 5, 1}
            g_TexturePositions.Entities[Entities.B_Beautification_Vase]             = {5, 2, 1}
            g_TexturePositions.Entities[Entities.B_Beautification_VictoryColumn]    = {1, 6, 1}

            g_TexturePositions.Entities[Entities.U_TrebuchetCart] = {9, 4}
            g_TexturePositions.Entities[Entities.U_MilitaryTrebuchet] = {9, 1}
            g_TexturePositions.Entities[Entities.U_MilitarySword_RedPrince] = {9, 1, 1}
            g_TexturePositions.Entities[Entities.U_MilitaryBow_RedPrince] = {9, 2, 1}
            g_TexturePositions.Entities[Entities.U_Bear]    = {13, 8}
            g_TexturePositions.Entities[Entities.U_BlackBear]    = {13, 8}
            g_TexturePositions.Entities[Entities.U_PolarBear]    = {13, 8}
            g_TexturePositions.Entities[Entities.U_Wolf_Grey]    = {13, 8}
            g_TexturePositions.Entities[Entities.U_Wolf_White]    = {13, 8}
            g_TexturePositions.Entities[Entities.U_Wolf_Black]    = {13, 8}
            g_TexturePositions.Entities[Entities.U_Wolf_Brown]    = {13, 8}
            g_TexturePositions.Entities[Entities.U_Lion_Male]    = {13, 8}
            g_TexturePositions.Entities[Entities.U_Lion_Female]    = {13, 8}
            g_TexturePositions.Entities[Entities.U_Tiger]    = {1, 8, 1}
            g_TexturePositions.Entities[Entities.B_GuardTower_ME]    = {12, 3}
            g_TexturePositions.Entities[Entities.B_GuardTower_NE]    = {12, 3}
            g_TexturePositions.Entities[Entities.B_GuardTower_SE]    = {12, 3}
            g_TexturePositions.Entities[Entities.B_GuardTower_NA]    = {12, 3}
            g_TexturePositions.Entities[Entities.B_GuardTower_AS]    = {12, 3}
            g_TexturePositions.Entities[Entities.B_WatchTower_ME]    = {7, 6}
            g_TexturePositions.Entities[Entities.B_WatchTower_NE]    = {7, 6}
            g_TexturePositions.Entities[Entities.B_WatchTower_SE]    = {7, 6}
            g_TexturePositions.Entities[Entities.B_WatchTower_NA]    = {7, 6}
            g_TexturePositions.Entities[Entities.B_WatchTower_AS]    = {7, 6}
            g_TexturePositions.Entities[Entities.U_MilitarySpear] = {9, 1, 1}
            g_TexturePositions.Entities[Entities.U_Helbardier] = {9, 1, 1}
            g_TexturePositions.Entities[Entities.U_MagicOx] = {7, 3}
            g_TexturePositions.Entities[Entities.U_Dragon] = {7, 3}
            
            -- Quest Types
            g_TexturePositions.QuestTypes[Objective.Refill]                  = {5, 9}
        
            -- Technologies
            g_TexturePositions.Technologies[Technologies.R_Cistern]                         = {1, 16}
            
            g_TexturePositions.Technologies[Technologies.R_Beautification_Brazier]          = {4, 1, 1}
            g_TexturePositions.Technologies[Technologies.R_Beautification_Flowerpot_Round]  = {1, 16}
            g_TexturePositions.Technologies[Technologies.R_Beautification_Flowerpot_Square] = {1, 16}
            g_TexturePositions.Technologies[Technologies.R_Beautification_Lantern]          = {1, 16}
            g_TexturePositions.Technologies[Technologies.R_Beautification_Pillar]           = {4, 2, 1}
            g_TexturePositions.Technologies[Technologies.R_Beautification_Shrine]           = {4, 3, 1}
            g_TexturePositions.Technologies[Technologies.R_Beautification_StoneBench]       = {4, 4, 1}
            g_TexturePositions.Technologies[Technologies.R_Beautification_Sundial]          = {5, 1, 1}
            g_TexturePositions.Technologies[Technologies.R_Beautification_TriumphalArch]    = {1, 5, 1}
            g_TexturePositions.Technologies[Technologies.R_Beautification_Vase]             = {5, 2, 1}
            g_TexturePositions.Technologies[Technologies.R_Beautification_Waystone]         = {1, 16}
            g_TexturePositions.Technologies[Technologies.R_Beautification_VictoryColumn]    = {1, 6, 1}
            
            
            
        end
    end
    
    
    -----------------------------------------------------------------
    -- QuestLog
    -----------------------------------------------------------------
    do
        local OldQuestLog_GetQuestTypeCaption = QuestLog.GetQuestTypeCaption
        
        QuestLog.GetQuestTypeCaption = function(_QuestType, _Quest)
            
            local QuestTypeCaption = ""
            
            if _QuestType == Objective.Refill then
                local RefillID = _Quest.Objectives[1].Data[1]
                if Logic.GetEntityType( RefillID ) == Entities.B_Cistern then
                    QuestTypeCaption = XGUIEng.GetStringTableText("UI_Texts/QuestCaptionSendGeologistToRefillCistern")
                else
                    QuestTypeCaption = XGUIEng.GetStringTableText("UI_Texts/QuestCaptionSendGeologistToRefillMine")
                end
            end
            
            if QuestTypeCaption ~= "" then
                return QuestTypeCaption
            end
            
            return OldQuestLog_GetQuestTypeCaption(_QuestType, _Quest)
            
        end
    end
end

function MilitaryFeedback_GetSpeaker(_EntityID)

	local type = Logic.GetEntityType(_EntityID)

	if type == Entities.U_Thief then
	
		return g_MilitaryFeedback.Thiefs[Entities.U_Thief]

	end		
    
    if type == Entities.U_Bear or type == Entities.U_BlackBear or type == Entities.U_PolarBear
        or type == Entities.U_Wolf_Grey or type == Entities.U_Wolf_White or type == Entities.U_Wolf_Black or type == Entities.U_Wolf_Brown
        or type == Entities.U_Lion_Male or type == Entities.U_Lion_Female or type == Entities.U_Tiger then
	    return "Animals"
    end

	if type == Entities.U_MilitaryCatapult
     or type == Entities.U_MilitarySiegeTower
     or type == Entities.U_MilitaryBatteringRam
     or type == Entities.U_CatapultCart
     or type == Entities.U_SiegeTowerCart
     or type == Entities.U_BatteringRamCart
     or type == Entities.U_AmmunitionCart
     or type == Entities.U_MilitaryTrebuchet
     or type == Entities.U_TrebuchetCart then
	
		local leader = Logic.GetGuardianEntityID(_EntityID)
		
		local type = Logic.LeaderGetSoldiersType(leader)

		if g_MilitaryFeedback.Soldiers[type] ~= nil then
			return g_MilitaryFeedback.Soldiers[type]
		end
	end

	if Logic.IsKnight(_EntityID) then
	
		return g_MilitaryFeedback.Knights[type]

	elseif type == Entities.U_Helbardier then
	
		return g_MilitaryFeedback.Soldiers[type]

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
	elseif type == Entities.U_Bear or type == Entities.U_BlackBear or type == Entities.U_PolarBear
            or type == Entities.U_Wolf_Grey or type == Entities.U_Wolf_White or type == Entities.U_Wolf_Black or type == Entities.U_Wolf_Brown
            or type == Entities.U_Lion_Male or type == Entities.U_Lion_Female or type == Entities.U_Tiger then
		return "VoicesAnimals_" .. g_MilitaryFeedback.Animals[type]
    else
		return "VoiceMilitary_speech"
	end
end

function MilitaryFeedback_GetState(_EntityID, _Key)

	local state = g_MilitaryFeedback.States[_Key]

	if state == nil then
	
		return ""
		
	end 
    
	local type = Logic.GetEntityType(_EntityID)

    if type == Entities.U_Bear or type == Entities.U_BlackBear or type == Entities.U_PolarBear
        or type == Entities.U_Wolf_Grey or type == Entities.U_Wolf_White or type == Entities.U_Wolf_Black or type == Entities.U_Wolf_Brown
        or type == Entities.U_Lion_Male or type == Entities.U_Lion_Female or type == Entities.U_Tiger then
        
	    local variant = 1
	    if state == "Attack" then
	        variant = 1 + XGUIEng.GetRandom(1)
        end
		return state .. "_rnd_0" .. variant
    else

	    local variants = -1

	    if g_MilitaryFeedback.Variants[state] ~= nil then
	
		    variants = g_MilitaryFeedback.Variants[state]
		
	    end 
        --Message("_Key = " .. _Key)
	    if variants ~= -1 then
            local text = state .. "_rnd_"
            local variant = 1 + XGUIEng.GetRandom(variants -1)
		    if variant < 10 then  
			    text = text .. "0"
		    end
		    return text .. variant
	    else
	        if _Key == "StealBuildingCommand" then
                return g_MilitaryFeedback.ThiefFeedbackVariants[(1 + XGUIEng.GetRandom(2))]
            else
		        return state
	        end
	    end
    end

end

function MilitaryFeedback(_EntityID, _Key)
    local EntityType = Logic.GetEntityType(_EntityID)
	
	local folder = "Voices"

	local type = MilitaryFeedback_GetType(_EntityID)

	local speaker = MilitaryFeedback_GetSpeaker(_EntityID)
	
	local state

    if EntityType == Entities.U_MilitarySiegeTower and _Key == "AttackCommand" then
        state = MilitaryFeedback_GetState(_EntityID, "MountWallCommand")
    else
        state = MilitaryFeedback_GetState(_EntityID, _Key)
    end

	if speaker == "" or state == "" then
	
		return
		
	end

	if speaker == nil or state == nil then
	
		return
		
	end
    --Message(folder.."/"..speaker.."/"..type.."_"..state..".mp3")
	Sound.PlayVoice("SettlersFeedbackVoice", folder.."/"..speaker.."/"..type.."_"..state..".mp3")
end

function EndStatistic_SettlerSpawned( _EntityID )

    if g_EndStatistic ~= nil 
    and Logic.IsEntityAlive(_EntityID) 
    and Logic.IsLeader(_EntityID) == 0 
    and Logic.IsEntityInCategory(_EntityID, EntityCategories.HeavyWeapon) == 0 then 

        local PlayerID = Logic.EntityGetPlayer(_EntityID)
        local EntityType = Logic.GetEntityType(_EntityID)
        
        if  EntityType == Entities.U_MilitaryBandit_Ranged_NA
        or  EntityType == Entities.U_MilitaryBandit_Ranged_NE
        or  EntityType == Entities.U_MilitaryBandit_Ranged_ME
        or  EntityType == Entities.U_MilitaryBandit_Ranged_SE
        or  EntityType == Entities.U_MilitaryBandit_Ranged_AS
        or  EntityType == Entities.U_MilitaryBandit_Melee_SE
        or  EntityType == Entities.U_MilitaryBandit_Melee_NA
        or  EntityType == Entities.U_MilitaryBandit_Melee_NE
        or  EntityType == Entities.U_MilitaryBandit_Melee_AS
        or  EntityType == Entities.U_MilitaryBandit_Melee_ME then
            g_EndStatistic[PlayerID].MercenariesHired = g_EndStatistic[PlayerID].MercenariesHired + 1
            
        elseif Logic.IsEntityInCategory(_EntityID, EntityCategories.Military) == 1 then
            g_EndStatistic[PlayerID].UnitsProduced = g_EndStatistic[PlayerID].UnitsProduced + 1
            
        elseif Logic.IsWorker(_EntityID) == 1 then
            local Workers = Logic.GetNumberOfEmployedWorkers(PlayerID)
            if Workers > g_EndStatistic[PlayerID].MaxSettlers then
                g_EndStatistic[PlayerID].MaxSettlers = Workers
            end
        elseif Logic.IsEntityInCategory(_EntityID, EntityCategories.AttackableMerchant) == 1 then
            local goodType, goodAmount = Logic.GetMerchantCargo(_EntityID)
            
            if goodType ~= Goods.G_Gold then
                
                local GoodCategory = Logic.GetGoodCategoryForGoodType(goodType)                
                if GoodCategory == GoodCategories.GC_Resource then
                    g_EndStatistic[PlayerID].ResourcesBought = g_EndStatistic[PlayerID].ResourcesBought + goodAmount
                else
                    g_EndStatistic[PlayerID].GoodsBought = g_EndStatistic[PlayerID].GoodsBought + goodAmount
                end
            end
        end
    
    end
     
end 

function EndStatistic_ResourceAddedToPlayerStock(_PlayerID, _GoodType, _Amount)
    
    if g_EndStatistic ~= nil then

        local GoodCategory = Logic.GetGoodCategoryForGoodType(_GoodType)
        
        if  GoodCategory ~= GoodCategories.GC_Water 
        and _GoodType ~=  Goods.G_FoodLordTrading
        and _GoodType ~=  Goods.G_MedicinLadyHealing
        and _GoodType ~=  Goods.G_EntertainmentBard
        and _GoodType ~=  Goods.G_ClothesPraphat then
            
            if GoodCategory == GoodCategories.GC_Resource then
                g_EndStatistic[_PlayerID].GoodsGathered = g_EndStatistic[_PlayerID].GoodsGathered + _Amount
            elseif GoodCategory == GoodCategories.GC_Gold then
                g_EndStatistic[_PlayerID].GoldEarned = g_EndStatistic[_PlayerID].GoldEarned  + _Amount
            else
                g_EndStatistic[_PlayerID].GoodsProduced = g_EndStatistic[_PlayerID].GoodsProduced + _Amount
            end
            
        end
        
    end

end

function InitMultiselection()
    g_MultiSelection = {}
    g_MultiSelection.EntityList = {}
    g_MultiSelection.Highlighted = {}
    --g_MultiSelection.IgnoreCreate = 0
    
    LeaderSortOrder = {}
    LeaderSortOrder[1] = Entities.U_MilitarySword
    LeaderSortOrder[2] = Entities.U_MilitaryBow
    LeaderSortOrder[3] = Entities.U_MilitarySword_RedPrince
    LeaderSortOrder[4] = Entities.U_MilitaryBow_RedPrince
    LeaderSortOrder[5] = Entities.U_MilitaryBandit_Melee_ME
    LeaderSortOrder[6] = Entities.U_MilitaryBandit_Melee_NA
    LeaderSortOrder[7] = Entities.U_MilitaryBandit_Melee_NE
    LeaderSortOrder[8] = Entities.U_MilitaryBandit_Melee_SE
    LeaderSortOrder[9] = Entities.U_MilitaryBandit_Melee_AS
    LeaderSortOrder[10] = Entities.U_MilitaryBandit_Ranged_ME
    LeaderSortOrder[11] = Entities.U_MilitaryBandit_Ranged_NA
    LeaderSortOrder[12] = Entities.U_MilitaryBandit_Ranged_NE
    LeaderSortOrder[13] = Entities.U_MilitaryBandit_Ranged_SE
    LeaderSortOrder[14] = Entities.U_MilitaryBandit_Ranged_AS
    LeaderSortOrder[15] = Entities.U_MilitaryCatapult
    LeaderSortOrder[16] = Entities.U_MilitarySiegeTower
    LeaderSortOrder[17] = Entities.U_MilitaryBatteringRam
    LeaderSortOrder[18] = Entities.U_MilitaryTrebuchet
    LeaderSortOrder[19] = Entities.U_CatapultCart
    LeaderSortOrder[20] = Entities.U_SiegeTowerCart
    LeaderSortOrder[21] = Entities.U_BatteringRamCart
    LeaderSortOrder[22] = Entities.U_TrebuchetCart
    LeaderSortOrder[23] = Entities.U_Thief
    LeaderSortOrder[24] = Entities.U_MilitarySword_Khana
    LeaderSortOrder[25] = Entities.U_MilitaryBow_Khana
    LeaderSortOrder[26] = Entities.U_Bear
    LeaderSortOrder[27] = Entities.U_BlackBear
    LeaderSortOrder[28] = Entities.U_PolarBear
    LeaderSortOrder[29] = Entities.U_Lion_Male
    LeaderSortOrder[30] = Entities.U_Lion_Female
    LeaderSortOrder[31] = Entities.U_Wolf_Grey
    LeaderSortOrder[32] = Entities.U_Wolf_White
    LeaderSortOrder[33] = Entities.U_Wolf_Black
    LeaderSortOrder[34] = Entities.U_Wolf_Brown
    LeaderSortOrder[35] = Entities.U_Tiger
end





--------------------------------------------------------------------------
-- knight.liua 
--------------------------------------------------------------------------

function GUI_Knight.GetKnightAbilityAndIcons(_KnightID)

    local Ability
    local AbilityIconPosition = {11,2}
    local KnightType = Logic.GetEntityType(_KnightID)

    if KnightType == Entities.U_KnightSong then
        Ability = Abilities.AbilityBard
        AbilityIconPosition = {11,1}
    elseif KnightType == Entities.U_KnightHealing then
        Ability = Abilities.AbilityHeal
        AbilityIconPosition = {11,2}
    elseif KnightType == Entities.U_KnightPlunder then
        Ability = Abilities.AbilityPlunder
        AbilityIconPosition = {11,3}
    elseif KnightType == Entities.U_KnightTrading then
        Ability = Abilities.AbilityFood
        AbilityIconPosition = {11,5}
    elseif KnightType == Entities.U_KnightChivalry or KnightType == Entities.U_KnightKhana then
        Ability = Abilities.AbilityTorch
        AbilityIconPosition = {11,4}
    elseif KnightType == Entities.U_KnightWisdom or KnightType == Entities.U_KnightSabatta then
        Ability = Abilities.AbilityConvert
        AbilityIconPosition = {11,6}
    elseif KnightType == Entities.U_KnightSaraya or KnightType == Entities.U_KnightRedPrince then
        Ability = Abilities.AbilityTribute
        AbilityIconPosition = {1,4,1}
    elseif KnightType == Entities.U_KnightPraphat then
        Ability = Abilities.AbilityFood
        AbilityIconPosition = {1,2}
    elseif KnightType == Entities.U_KnightRedPrince then
        --Currently unreachable
        Ability = Abilities.AbilityConvert
        AbilityIconPosition = {15,16}
    end

    return Ability, AbilityIconPosition

end

function SetIcon(_Widget, _Coordinates, _OptionalIconSize )

    if _Coordinates == nil then

        if Debug_EnableDebugOutput then
            GUI.AddNote("Bug: no valid Icon available. Caused by invalid EntityType or GoodType, or a missing entry in TexturePositions.lua")

            if type(_Widget) == "string" then
                _Widget = XGUIEng.GetWidgetID(_Widget)
            end

            local WidgetPath = XGUIEng.GetWidgetPathByID(_Widget)
            GUI.AddNote("Widget: " .. WidgetPath)
        end

        _Coordinates = {16, 16}
        --return
    end

    local IsButton = XGUIEng.IsButton(_Widget)
    local WidgetState

    if IsButton == 1 then
        WidgetState = 7
    else
        WidgetState = 1
    end

    local IconSize
    
    local UVOverride = false
    local u0, v0, u1, v1
    
    if _Coordinates[1] == 16 and _Coordinates[2]==16 then
        XGUIEng.SetMaterialAlpha(_Widget, WidgetState, 0)
    else
        XGUIEng.SetMaterialAlpha(_Widget, WidgetState, 255)
        
        if _Coordinates[3] == nil
        or _Coordinates[3] == 0 then
		        if _OptionalIconSize == nil
		        or _OptionalIconSize == 64 then
		            IconSize = 64
		            XGUIEng.SetMaterialTexture(_Widget, WidgetState, "IconsBig.png")
		        elseif _OptionalIconSize == 44 then
		            IconSize = 44
		            XGUIEng.SetMaterialTexture(_Widget, WidgetState, "Icons.png")
		        elseif _OptionalIconSize == 128 then
		            IconSize = 128
		            
                    -- For salt & dye we need a bit of a hack...
                    if  _Coordinates[1] == 5 and _Coordinates[2] == 10 then -- salt
                        XGUIEng.SetMaterialTexture(_Widget, WidgetState, "IconsBig2.png")
                        UVOverride = true
                        u0 = 128
                        v0 = 256 
                        u1 = u0 + IconSize
                        v1 = v0 + IconSize
                    elseif _Coordinates[1] == 5 and _Coordinates[2] == 11 then -- dye
                        XGUIEng.SetMaterialTexture(_Widget, WidgetState, "IconsBig2.png")
                        UVOverride = true
                        u0 = 256
                        v0 = 256 
                        u1 = u0 + IconSize
                        v1 = v0 + IconSize                                                 
                    else 
                        XGUIEng.SetMaterialTexture(_Widget, WidgetState, "IconsVeryBig.png")
                    end
		        end
		    else
		        if _OptionalIconSize == nil
		        or _OptionalIconSize == 64 then
		            IconSize = 64
		            XGUIEng.SetMaterialTexture(_Widget, WidgetState, "IconsBig2.png")
		        elseif _OptionalIconSize == 44 then
		            IconSize = 44
		            XGUIEng.SetMaterialTexture(_Widget, WidgetState, "Icons2.png")
		        elseif _OptionalIconSize == 128 then
                    IconSize = 128
                    
                    -- For muscical instruments, gems & olibanum we need a bit of a hack...
                    if  _Coordinates[1] == 1 and _Coordinates[2] == 1 then -- gems
                        XGUIEng.SetMaterialTexture(_Widget, WidgetState, "IconsBig2.png")
                        UVOverride = true
                        u0 = 128
                        v0 = 384 
                        u1 = u0 + IconSize
                        v1 = v0 + IconSize
                    elseif  _Coordinates[1] == 1 and _Coordinates[2] == 2 then -- olibanum
                        XGUIEng.SetMaterialTexture(_Widget, WidgetState, "IconsBig2.png")
                        UVOverride = true
                        u0 = 256
                        v0 = 384 
                        u1 = u0 + IconSize
                        v1 = v0 + IconSize
                    elseif  _Coordinates[1] == 1 and _Coordinates[2] == 3 then -- musicalinst
                        XGUIEng.SetMaterialTexture(_Widget, WidgetState, "IconsBig2.png")
                        UVOverride = true
                        u0 = 384
                        v0 = 384 
                        u1 = u0 + IconSize
                        v1 = v0 + IconSize
                    else 
                        XGUIEng.SetMaterialTexture(_Widget, WidgetState, "IconsVeryBig.png")
                    end
		        end
		    end
            
            
        if not UVOverride then
            
            u0 = (_Coordinates[1] - 1) * IconSize
            v0 = (_Coordinates[2] - 1) * IconSize
            u1 = _Coordinates[1] * IconSize
            v1 = _Coordinates[2] * IconSize

        end
        
        XGUIEng.SetMaterialUV(_Widget, WidgetState, u0, v0, u1, v1)
    end

end

-- Same as in MainMenuEx
if g_VideoOptions then
    g_VideoOptions.Old_OnShow = g_VideoOptions.OnShow
    function g_VideoOptions:OnShow()
        XGUIEng.ShowWidget("/InGame/VideoOptionsMain/OptionFrame/NVLogo", 0)
        g_VideoOptions:Old_OnShow()
    end
end
