
-----------------------------------------------------------------------------------------
-- Overwrites for CloseupView
-----------------------------------------------------------------------------------------

function InitOverwriteCloseUpViewEx2()

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
        
        g_HeroAbilityFeedback.Knights[Entities.U_KnightSabatta] 	= "Sabatta"
        g_HeroAbilityFeedback.Knights[Entities.U_KnightRedPrince] 	= "RedPrince"
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
        g_MilitaryFeedback.Soldiers[Entities.U_MilitaryCavalry]				= "Military_Bow"
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
        g_MilitaryFeedback.Animals[Entities.U_Tiger_White] 		= "Tiger"
        g_MilitaryFeedback.Animals[Entities.U_Lion_Male] 		= "Lion"
        g_MilitaryFeedback.Animals[Entities.U_Lion_Female] 		= "Lion"
        g_MilitaryFeedback.Animals[Entities.U_Bear] 		    = "Bear"
        g_MilitaryFeedback.Animals[Entities.U_BlackBear] 		= "Bear"
        g_MilitaryFeedback.Animals[Entities.U_PolarBear] 		= "Bear"
        g_MilitaryFeedback.Animals[Entities.U_Wolf_Grey] 		= "Wolf"
        g_MilitaryFeedback.Animals[Entities.U_Wolf_White] 		= "Wolf"
        g_MilitaryFeedback.Animals[Entities.U_Wolf_Black] 		= "Wolf"
        g_MilitaryFeedback.Animals[Entities.U_Wolf_Brown] 		= "Wolf"
        g_MilitaryFeedback.Animals[Entities.U_Cat1] 		    = "Cat"
        g_MilitaryFeedback.Animals[Entities.U_Cat2] 		    = "Cat"
        g_MilitaryFeedback.Animals[Entities.U_Cat3] 		    = "Cat"
        g_MilitaryFeedback.Animals[Entities.U_Cat4] 		    = "Cat"
        g_MilitaryFeedback.Animals[Entities.U_Dog1] 		    = "Dog"
        g_MilitaryFeedback.Animals[Entities.U_Dog2] 		    = "Dog"
        g_MilitaryFeedback.Animals[Entities.U_Dog3] 		    = "Dog"

        --Used for military feedback so we don't need excessive if clauses
        g_MilitaryFeedback.AnimalTypes = {
            Entities.U_Bear, 
            Entities.U_BlackBear, 
            Entities.U_PolarBear,
            Entities.U_Wolf_Grey, 
            Entities.U_Wolf_White, 
            Entities.U_Wolf_Black, 
            Entities.U_Wolf_Brown,
            Entities.U_Lion_Male, 
            Entities.U_Lion_Female, 
            Entities.U_Tiger, 
            Entities.U_Tiger_White,
            Entities.U_Cat1, 
            Entities.U_Cat2, 
            Entities.U_Cat3, 
            Entities.U_Cat4,
            Entities.U_Dog1, 
            Entities.U_Dog2, 
            Entities.U_Dog3
        }
    end   

    function MilitaryFeedback_GetSpeaker(_EntityID)

	    local type = Logic.GetEntityType(_EntityID)

	    if type == Entities.U_Thief then
	
		    return g_MilitaryFeedback.Thiefs[Entities.U_Thief]

	    end		
        if GetIndexOfItem(g_MilitaryFeedback.AnimalTypes, type) ~= nil then
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
         or type == Entities.U_TrebuchetCart
         or type == Entities.U_MilitaryCannon
         or type == Entities.U_CannonCart then
	
		    local leader = Logic.GetGuardianEntityID(_EntityID)
		
		    local type = Logic.LeaderGetSoldiersType(leader)

		    if g_MilitaryFeedback.Soldiers[type] ~= nil then
			    return g_MilitaryFeedback.Soldiers[type]
		    end
	    end

	    if Logic.IsKnight(_EntityID) then
	
		    return g_MilitaryFeedback.Knights[type]

	    elseif type == Entities.U_Helbardier or type == Entities.U_MilitaryCavalry  then
	
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
    
    do 
        local OldMilitaryFeedback_GetType = MilitaryFeedback_GetType
        function MilitaryFeedback_GetType(_EntityID)
	        local type = Logic.GetEntityType(_EntityID)

	        if GetIndexOfItem(g_MilitaryFeedback.AnimalTypes, type) ~= nil then
		        return "VoicesAnimals_" .. g_MilitaryFeedback.Animals[type]
            else
		        return OldMilitaryFeedback_GetType(_EntityID)
	        end
        end
    end
    
    function MilitaryFeedback_GetState(_EntityID, _Key)

	    local state = g_MilitaryFeedback.States[_Key]

	    if state == nil then
	
		    return ""
		
	    end 
    
	    local type = Logic.GetEntityType(_EntityID)

        if GetIndexOfItem(g_MilitaryFeedback.AnimalTypes, type) ~= nil then
        
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

end