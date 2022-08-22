--ToDo: Mybe obsolete. Please check and remove unedited maps!
function GameCallback_CreateKnightByTypeOrIndex(_KnightType, _PlayerID)

    if Logic.GetKnightID(_PlayerID) == 0 then
    
        local MapType, CampaignName = Framework.GetCurrentMapTypeAndCampaignName()
    
        if (Logic.PlayerGetIsHumanFlag(_PlayerID) )then
        
            if (MapType == 3 or MapType == 2 or MapType == 0)then  -- Multiplayer, Singleplayer, Custom        
                    
                local KnightIndex = _KnightType
                
                _KnightType = GetKnightTypeIDForMPGame(KnightIndex, _PlayerID)
            end
		--[[
        else
            _KnightType = nil
		--]]
        end
        
        if (_KnightType == nil) or (_KnightType <= 1) then
        
        	_KnightType = Entities.U_KnightChivalry
        
        end
        
        
        if Framework.CheckIDV() then
        
        	if _KnightType ~= Entities.U_KnightChivalry and _KnightType ~= Entities.U_KnightHealing then
        
        		_KnightType = Entities.U_KnightChivalry
        		
        	end
        
        end
        
        
        -- Get Startposition
        local Amount, StartID = Logic.GetPlayerEntities(_PlayerID, Entities.XD_StartPosition, 1)
        
        local x,y,Orientation
        
        if StartID ~= nil then            
            x,y = Logic.GetEntityPosition(StartID)
            Orientation = Logic.GetEntityOrientation(StartID) - 90
        end
        
        -- Get Castle, if no startposition has been set
        if StartID ==  nil then
            
            StartID = Logic.GetHeadquarters(_PlayerID)
        end
        
        -- Get Storehouse, if no startposition and no castle has been set
        if StartID ==  nil then
            
            StartID = Logic.GetStoreHouse(_PlayerID)
            
        end
        
        
        if StartID ~= nil and StartID ~= 0 then
        
            local KnightID
            
            if x == nil then
            
                KnightID = Logic.CreateEntityAtBuilding(_KnightType, StartID, Orientation, _PlayerID)
            
            else
                
                KnightID = Logic.CreateEntityOnUnblockedLand( _KnightType, x, y, Orientation, _PlayerID)
                
            end
            
            Logic.SetEntityName(KnightID, "Player" .. _PlayerID .. "Knight")
        
        else
            Logic.DEBUG_AddNote("DEBUG: Knight could not placed for player " .. _PlayerID .. "No XD_StartPosition, Castle or Storhouse")
        end
    end
end