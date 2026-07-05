
function AIProfile_Skirmish(_AIPlayer)

	if (_AIPlayer.Skirmish == nil) then
		_AIPlayer.Skirmish = {}
	end

	if (_AIPlayer.Skirmish.Init == nil) then
			
		_AIPlayer.Skirmish.Timer = 0
		_AIPlayer.Skirmish.Init = true

		if (_AIPlayer.Skirmish.Enemy == nil) then
			_AIPlayer.Skirmish.Enemy = SkirmishDefault.Enemy
		end
		
		-- claim init
		do
		
			if (_AIPlayer.Skirmish.Claim_SuperiorTerritories == nil) then
				_AIPlayer.Skirmish.Claim_SuperiorTerritories = SkirmishDefault.Claim_SuperiorTerritories
			end
			
			if (_AIPlayer.Skirmish.Claim_StartTerritories == nil) then
				_AIPlayer.Skirmish.Claim_StartTerritories = SkirmishDefault.Claim_StartTerritories
			end
			
			if (_AIPlayer.Skirmish.Claim_MinTime == nil) then
				_AIPlayer.Skirmish.Claim_MinTime = SkirmishDefault.Claim_MinTime
			end
			
			if (_AIPlayer.Skirmish.Claim_MaxTime == nil) then
				_AIPlayer.Skirmish.Claim_MaxTime = SkirmishDefault.Claim_MaxTime
			end						

			if (_AIPlayer.Skirmish.Attack_MinTime == nil) then
				_AIPlayer.Skirmish.Attack_MinTime = SkirmishDefault.Attack_MinTime
			end
			
			if (_AIPlayer.Skirmish.Attack_MaxTime == nil) then
				_AIPlayer.Skirmish.Attack_MaxTime = SkirmishDefault.Attack_MaxTime
			end			

			if (_AIPlayer.Skirmish.CheatDefense == nil) then
				_AIPlayer.Skirmish.CheatDefense = SkirmishDefault.CheatDefense
			end			

			if (_AIPlayer.Skirmish.ManOutposts == nil) then
				_AIPlayer.Skirmish.ManOutposts = SkirmishDefault.ManOutposts
			end			
									
		end
		
		-- attack init
		do
		    _AIPlayer.Skirmish.Claim_NextTime = 0
		    _AIPlayer.Skirmish.Attack_NextTime = 0
		    _AIPlayer.Skirmish.Last_CheatTime = 0
		
		    _AIPlayer.Skirmish.ImportantTerritories = {}
        end
		
		
		-- some facts
		do
		    if (_AIPlayer.Skirmish.ManOutposts) then
                AICore.SetNumericalFact(_AIPlayer.m_PlayerID, "FMOP", 1 )        
            end
		
		    _AIPlayer.Skirmish.NumberOfDefendSpearmen   = 1
		    _AIPlayer.Skirmish.NumberOfDefendSwordmen   = 0
		    _AIPlayer.Skirmish.NumberOfDefendBowmen     = 0
		                            
            AICore.SetNumericalFact(_AIPlayer.m_PlayerID, "FDAP", _AIPlayer.Skirmish.NumberOfDefendSpearmen )
            AICore.SetNumericalFact(_AIPlayer.m_PlayerID, "FDAS", _AIPlayer.Skirmish.NumberOfDefendSwordmen )
            AICore.SetNumericalFact(_AIPlayer.m_PlayerID, "FDAB", _AIPlayer.Skirmish.NumberOfDefendBowmen )
        
            AICore.SetNumericalFact(_AIPlayer.m_PlayerID, "FEAR", 1.5 )
            AICore.SetNumericalFact(_AIPlayer.m_PlayerID, "FTIA", 0.8 )
            
            AICore.SetNumericalFact(_AIPlayer.m_PlayerID, "FMPM", 4 )   -- max spearmen
            AICore.SetNumericalFact(_AIPlayer.m_PlayerID, "FMSM", 6 )   -- max swordmen
            AICore.SetNumericalFact(_AIPlayer.m_PlayerID, "FMBM", 10 )   -- max bowmen
            
        end

	
	end

    -- update AI
    if (Logic.IsEntityAlive(Logic.GetStoreHouse(_AIPlayer.m_PlayerID))) then

    	_AIPlayer.Skirmish.Timer = _AIPlayer.Skirmish.Timer + 1
    	
    	AISkirmish_UpdateStrength(_AIPlayer)
    	AISkirmish_UpdateClaiming(_AIPlayer)
    	AISkirmish_Attack(_AIPlayer)
    
    end
    
end

----------------------------------------------------------------------------------------------------------------------------------------------------
function AISkirmish_UpdateStrength(_AIPlayer)

	if ((_AIPlayer.Skirmish.NumberOfDefendSwordmen + _AIPlayer.Skirmish.NumberOfDefendBowmen) < 10) then
	
    	if (_AIPlayer.Skirmish.Timer % (10 * 60) == 0) then
			local randomtype = Logic.GetRandom(11)
    	    -- add some more defense power
    	    if (randomtype >= 8) then
    	    
    	        _AIPlayer.Skirmish.NumberOfDefendBowmen = _AIPlayer.Skirmish.NumberOfDefendBowmen + 1
    	        
			elseif (randomtype >= 4) then
    	    
    	        _AIPlayer.Skirmish.NumberOfDefendSpearmen = _AIPlayer.Skirmish.NumberOfDefendSpearmen + 1

    	    else

    	        _AIPlayer.Skirmish.NumberOfDefendSwordmen = _AIPlayer.Skirmish.NumberOfDefendSwordmen + 1
    	        
    	    end 
    	  
    	    -- update facts
            AICore.SetNumericalFact(_AIPlayer.m_PlayerID, "FDAP", _AIPlayer.Skirmish.NumberOfDefendSpearmen )
            AICore.SetNumericalFact(_AIPlayer.m_PlayerID, "FDAS", _AIPlayer.Skirmish.NumberOfDefendSwordmen )
            AICore.SetNumericalFact(_AIPlayer.m_PlayerID, "FDAB", _AIPlayer.Skirmish.NumberOfDefendBowmen ) 
    
    	end	
    end

end

----------------------------------------------------------------------------------------------------------------------------------------------------
function AISkirmish_AttackWithCatapults(_AIPlayer, AttackTerritory)

    _AIPlayer.m_Behavior["Skirmish_Attack"] = _AIPlayer:GenerateBehaviour(AIBehavior_AttackCity)
    
    _AIPlayer.m_Behavior["Skirmish_Attack"].m_MinNumberOfSwordsmen = 2  
    _AIPlayer.m_Behavior["Skirmish_Attack"].m_MaxNumberOfSwordsmen = 5
    _AIPlayer.m_Behavior["Skirmish_Attack"].m_AliveNumberOfSwordsmen = 1  
    
    _AIPlayer.m_Behavior["Skirmish_Attack"].m_MinNumberOfBowmen = 1  
    _AIPlayer.m_Behavior["Skirmish_Attack"].m_MaxNumberOfBowmen = 4  
    _AIPlayer.m_Behavior["Skirmish_Attack"].m_AliveNumberOfBowmen = 0
    
    _AIPlayer.m_Behavior["Skirmish_Attack"].m_MinNumberOfSpearmen = 1
    _AIPlayer.m_Behavior["Skirmish_Attack"].m_MaxNumberOfSpearmen = 3
    _AIPlayer.m_Behavior["Skirmish_Attack"].m_AliveNumberOfSpearmen = 1  
        
    _AIPlayer.m_Behavior["Skirmish_Attack"].m_MinNumberOfCatapults = 1
    _AIPlayer.m_Behavior["Skirmish_Attack"].m_MaxNumberOfCatapults = 1
    _AIPlayer.m_Behavior["Skirmish_Attack"].m_FleeNumberOfCatapults = 1

    _AIPlayer.m_Behavior["Skirmish_Attack"].m_MinNumberOfRams = 0
    _AIPlayer.m_Behavior["Skirmish_Attack"].m_MaxNumberOfRams = 0
    _AIPlayer.m_Behavior["Skirmish_Attack"].m_FleeNumberOfRams = 0

    _AIPlayer.m_Behavior["Skirmish_Attack"].m_MinNumberOfTowers = 0
    _AIPlayer.m_Behavior["Skirmish_Attack"].m_MaxNumberOfTowers = 0
    _AIPlayer.m_Behavior["Skirmish_Attack"].m_FleeNumberOfTowers = 0
    
    _AIPlayer.m_Behavior["Skirmish_Attack"].m_TargetID = Logic.GetTerritoryAcquiringBuildingID(AttackTerritory)    

    if (_AIPlayer.m_Behavior["Skirmish_Attack"]:Start() == false) then
    
        _AIPlayer.m_Behavior["Skirmish_Attack"] = nil
                        
    end
    
end

----------------------------------------------------------------------------------------------------------------------------------------------------
function AISkirmish_CaptureOutpost(_AIPlayer, AttackTerritory)
	
    _AIPlayer.m_Behavior["Skirmish_Attack"] = _AIPlayer:GenerateBehaviour(AIBehavior_CaptureOutpost)
    
    _AIPlayer.m_Behavior["Skirmish_Attack"].m_MinNumberOfSwordsmen = 1  
    _AIPlayer.m_Behavior["Skirmish_Attack"].m_MaxNumberOfSwordsmen = 3  
    _AIPlayer.m_Behavior["Skirmish_Attack"].m_AliveNumberOfSwordsmen = 0  
    
    _AIPlayer.m_Behavior["Skirmish_Attack"].m_MinNumberOfBowmen = 2  
    _AIPlayer.m_Behavior["Skirmish_Attack"].m_MaxNumberOfBowmen = 3  
    _AIPlayer.m_Behavior["Skirmish_Attack"].m_AliveNumberOfBowmen = 0
    
    _AIPlayer.m_Behavior["Skirmish_Attack"].m_MinNumberOfSpearmen = 1
    _AIPlayer.m_Behavior["Skirmish_Attack"].m_MaxNumberOfSpearmen = 2
    _AIPlayer.m_Behavior["Skirmish_Attack"].m_AliveNumberOfSpearmen = 0
        
    _AIPlayer.m_Behavior["Skirmish_Attack"].m_MinNumberOfCatapults = 0
    _AIPlayer.m_Behavior["Skirmish_Attack"].m_MaxNumberOfCatapults = 0
    _AIPlayer.m_Behavior["Skirmish_Attack"].m_FleeNumberOfCatapults = 0
    
    _AIPlayer.m_Behavior["Skirmish_Attack"].m_OutpostID = Logic.GetTerritoryAcquiringBuildingID(AttackTerritory)    

    if (_AIPlayer.m_Behavior["Skirmish_Attack"]:Start() == false) then
    
        _AIPlayer.m_Behavior["Skirmish_Attack"] = nil
                        
    end
    
end

----------------------------------------------------------------------------------------------------------------------------------------------------
--
-- Cheat callbacks
--
----------------------------------------------------------------------------------------------------------------------------------------------------

----------------------------------------------------------------------------------------------------------------------------------------------------
function Helper_CheatSpearmen(_PlayerID, _Number)

    local Barracks = GetPlayerEntities(_PlayerID, Entities.B_BarracksSpearmen)
    if #Barracks > 0 then
    
        local PosX, PosY = Logic.GetBuildingApproachPosition(Barracks[1])
        for i=1,_Number do
                    
            Logic.CreateBattalionOnUnblockedLand(Entities.U_MilitarySpear, PosX, PosY, 0, _PlayerID)
        
        end
        
    end

end

----------------------------------------------------------------------------------------------------------------------------------------------------
function AISkirmish_AIDefendArmyNeedsSpearmen(_AIPlayer, _Number)

    if (_AIPlayer.Skirmish == nil) then
        return
    end        

    if (_AIPlayer.Skirmish.CheatDefense == false) then
        return
    end

    if ((Logic.GetTime() == _AIPlayer.Skirmish.Last_CheatTime) or
        (Logic.GetTime() > _AIPlayer.Skirmish.Last_CheatTime + SKIRMISH_CHEAT_TIME)) then
        
        _AIPlayer.Skirmish.Last_CheatTime = Logic.GetTime()

        Helper_CheatSpearmen(_AIPlayer.m_PlayerID, _Number)
        
    end

end