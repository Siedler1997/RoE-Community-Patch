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
    AddResourcesToPlayer(Goods.G_Grain,10)
end


--++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
-- This function is called from main script to define the month offset
-- this is data that could be saved with the editor in an xml file later
function Mission_SetStartingMonth()
    
    Logic.SetMonthOffset(3)
    
end

--++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
-- This function is called from main script to add offers to all kind of traders on the map
-- this is data that could be saved with the editor in an xml file later
function Mission_InitMerchants()

    --Cloister Mitra
    local TraderBuilding = Logic.GetStoreHouse(4)
    AddOffer(TraderBuilding, 1, Goods.G_Sheep)
    AddOffer(TraderBuilding, 3, Goods.G_Herb)
    AddOffer(TraderBuilding, 5, Goods.G_Stone)
    AddOffer(TraderBuilding, 5, Goods.G_Iron)
 
    local _, TradepostID = Logic.GetPlayerEntities( 4, Entities.I_X_TradePostConstructionSite, 1, 0 )
    assert( TradepostID and TradepostID ~= 0 )
    Logic.TradePost_SetTradePartnerGenerateGoodsFlag(TradepostID, true)
    Logic.TradePost_SetTradePartnerPlayerID(TradepostID, 4)
    Logic.TradePost_SetTradeDefinition(TradepostID, 0, Goods.G_Wool, 18, Goods.G_Stone, 9)
    Logic.TradePost_SetTradeDefinition(TradepostID, 1, Goods.G_Grain, 18, Goods.G_Dye, 4)
    Logic.TradePost_SetTradeDefinition(TradepostID, 2, Goods.G_Herb, 18, Goods.G_Salt, 4)
    Logic.TradePost_SetTradeDefinition(TradepostID, 3, Goods.G_Milk, 18, Goods.G_Gems, 4)
 
     --Village Yoni
    local TraderBuilding = Logic.GetStoreHouse(3)
    AddMercenaryOffer( TraderBuilding, 3, Entities.U_MilitaryBandit_Ranged_AS )
    AddMercenaryOffer( TraderBuilding, 3, Entities.U_MilitaryBandit_Melee_AS )
    AddOffer(TraderBuilding, 1, Goods.G_Cow)
    AddOffer(TraderBuilding, 5, Goods.G_RawFish)

    local _, TradepostID = Logic.GetPlayerEntities( 3, Entities.I_X_TradePostConstructionSite, 1, 0 )
    assert( TradepostID and TradepostID ~= 0 )
    Logic.TradePost_SetTradePartnerGenerateGoodsFlag(TradepostID, true)
    Logic.TradePost_SetTradePartnerPlayerID(TradepostID, 3)
    Logic.TradePost_SetTradeDefinition(TradepostID, 0, Goods.G_Wool, 18, Goods.G_Iron, 9)
    Logic.TradePost_SetTradeDefinition(TradepostID, 1, Goods.G_Grain, 18, Goods.G_Dye, 4)
    Logic.TradePost_SetTradeDefinition(TradepostID, 2, Goods.G_Herb, 18, Goods.G_Salt, 4)
    Logic.TradePost_SetTradeDefinition(TradepostID, 3, Goods.G_Milk, 18, Goods.G_Gems, 4)

    --Cloister Daksha
    local TraderBuilding = Logic.GetStoreHouse(6)
    AddOffer(TraderBuilding, 1, Goods.G_Sheep)
    AddOffer(TraderBuilding, 3, Goods.G_Herb)
    AddOffer(TraderBuilding, 5, Goods.G_Stone)
    AddOffer(TraderBuilding, 5, Goods.G_Iron)
 
    local _, TradepostID = Logic.GetPlayerEntities( 6, Entities.I_X_TradePostConstructionSite, 1, 0 )
    assert( TradepostID and TradepostID ~= 0 )
    Logic.TradePost_SetTradePartnerGenerateGoodsFlag(TradepostID, true)
    Logic.TradePost_SetTradePartnerPlayerID(TradepostID, 6)
    Logic.TradePost_SetTradeDefinition(TradepostID, 0, Goods.G_Wool, 18, Goods.G_Stone, 9)
    Logic.TradePost_SetTradeDefinition(TradepostID, 1, Goods.G_Grain, 18, Goods.G_Dye, 4)
    Logic.TradePost_SetTradeDefinition(TradepostID, 2, Goods.G_Herb, 18, Goods.G_Salt, 4)
    Logic.TradePost_SetTradeDefinition(TradepostID, 3, Goods.G_Milk, 18, Goods.G_Gems, 4)
 
     --Village Amba
    local TraderBuilding = Logic.GetStoreHouse(5)
    AddMercenaryOffer( TraderBuilding, 3, Entities.U_MilitaryBandit_Ranged_AS )
    AddMercenaryOffer( TraderBuilding, 3, Entities.U_MilitaryBandit_Melee_AS )
    AddOffer(TraderBuilding, 1, Goods.G_Cow)
    AddOffer(TraderBuilding, 5, Goods.G_RawFish)

    local _, TradepostID = Logic.GetPlayerEntities( 5, Entities.I_X_TradePostConstructionSite, 1, 0 )
    assert( TradepostID and TradepostID ~= 0 )
    Logic.TradePost_SetTradePartnerGenerateGoodsFlag(TradepostID, true)
    Logic.TradePost_SetTradePartnerPlayerID(TradepostID, 5)
    Logic.TradePost_SetTradeDefinition(TradepostID, 0, Goods.G_Wool, 18, Goods.G_Iron, 9)
    Logic.TradePost_SetTradeDefinition(TradepostID, 1, Goods.G_Grain, 18, Goods.G_Dye, 4)
    Logic.TradePost_SetTradeDefinition(TradepostID, 2, Goods.G_Herb, 18, Goods.G_Salt, 4)
    Logic.TradePost_SetTradeDefinition(TradepostID, 3, Goods.G_Milk, 18, Goods.G_Gems, 4)
   
    
end
	
--++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
-- This function is called on game start after all initialization is done
function Mission_FirstMapAction()

    EnableFoW()
    
        Startup_Player()
              


end
