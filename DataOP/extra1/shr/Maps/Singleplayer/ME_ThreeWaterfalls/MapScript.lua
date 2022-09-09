CurrentMapIsFreeSettleModeMap = true


--++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
-- This function is called from main script to initialize the players
-- including resources, rights and initial diplomacy state
-- this is data that could be saved with the editor in an xml file later
function Mission_InitPlayers()
    -- set resources for playerID 1
    AddResourcesToPlayer(Goods.G_Gold,250)
    AddResourcesToPlayer(Goods.G_Wood,30)
    AddResourcesToPlayer(Goods.G_RawFish,10)
    AddResourcesToPlayer(Goods.G_Carcass,10)
end


--++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
-- This function is called from main script to define the month offset
-- this is data that could be saved with the editor in an xml file later
function Mission_SetStartingMonth()
    
    Logic.SetMonthOffset(4)
    
end

--++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
-- This function is called from main script to add offers to all kind of traders on the map
-- this is data that could be saved with the editor in an xml file later
function Mission_InitMerchants()
    
	ActivateTravelingSalesman((3), { 
				{5,     --first Month
					{  
						{Goods.G_Salt, 5}, 
						{Entities.U_Entertainer_ME_StiltWalker}, 
						{Goods.G_Sheep, 2},
						{Goods.G_Cow, 2}
					}     
			},
				{9,     --second month
					{  
						{Entities.U_Entertainer_ME_StrongestMan_Stone}, 
						{Goods.G_Medicine, 5}, 
						{Entities.U_MilitaryBandit_Melee_ME, 5},
						{Entities.U_MilitaryBandit_Ranged_ME, 5}
					}     
				}  
			} 
		) 
	
end
	
--++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
-- This function is called on game start after all initialization is done
function Mission_FirstMapAction()


end