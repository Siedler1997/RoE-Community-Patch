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

    AddOffer(Logic.GetStoreHouse(3), 10, Goods.G_Cow)
    AddOffer(Logic.GetStoreHouse(3), 30, Goods.G_Bread)
    AddOffer(Logic.GetStoreHouse(3), 10, Goods.G_Honeycomb)

    AddOffer(Logic.GetStoreHouse(4), 10, Goods.G_Sheep)
    AddOffer(Logic.GetStoreHouse(4), 30, Goods.G_SmokedFish)
    AddOffer(Logic.GetStoreHouse(4), 10, Goods.G_Wool)
    
end
	
--++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
-- This function is called on game start after all initialization is done
function Mission_FirstMapAction()


end
