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
    
    Logic.SetMonthOffset(5)
    
end

--++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
-- This function is called from main script to add offers to all kind of traders on the map
-- this is data that could be saved with the editor in an xml file later
function Mission_InitMerchants()

    -- jalal
    local TraderBuilding = Logic.GetStoreHouse(3)
    AddOffer(TraderBuilding, 5,Goods.G_Carcass)
    AddOffer(TraderBuilding, 8,Goods.G_Wool)
    AddOffer(TraderBuilding, 1, Goods.G_Iron)
    AddOffer(TraderBuilding, 5, Goods.G_Honeycomb)
    
    
    --sinaha
    local TraderBuilding = Logic.GetStoreHouse(4)    
    AddOffer(TraderBuilding, 5,Goods.G_Carcass)
    AddOffer(TraderBuilding, 8,Goods.G_Wool)
    AddOffer(TraderBuilding, 1, Goods.G_Iron)
    AddOffer(TraderBuilding, 5, Goods.G_Honeycomb)
      
end
	
--++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
-- This function is called on game start after all initialization is done
function Mission_FirstMapAction()

end