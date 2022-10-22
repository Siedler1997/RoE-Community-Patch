-----------------------------------------------------------------------------------------------
--  END STATISTIC
-----------------------------------------------------------------------------------------------
do 
    local OldEndStatistic_SettlerSpawned = EndStatistic_SettlerSpawned
    
    function EndStatistic_SettlerSpawned( _EntityID )

        if g_EndStatistic ~= nil and Logic.IsEntityAlive(_EntityID) and Logic.IsLeader(_EntityID) == 0 and Logic.IsEntityInCategory(_EntityID, EntityCategories.HeavyWeapon) == 0 then 

            local PlayerID = Logic.EntityGetPlayer(_EntityID)
        
            if Logic.IsWorker(_EntityID) == 1 then
                local Workers = Logic.GetNumberOfEmployedWorkers(PlayerID)
			    if g_EndStatistic[PlayerID] ~= nil then
				    if Workers > g_EndStatistic[PlayerID].MaxSettlers then
					    g_EndStatistic[PlayerID].MaxSettlers = Workers
				    end
			    end
            else
                OldEndStatistic_SettlerSpawned(_EntityID)
            end
    
        end
     
    end 
end