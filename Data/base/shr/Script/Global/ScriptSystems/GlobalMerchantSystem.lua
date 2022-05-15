--------------------------------------------------------------------------
--        ***************** MERCHANT SYSTEM SCRIPT *****************
--------------------------------------------------------------------------

function InitGlobalMerchantSystem()

    MerchantSystem = {}

    -- prices are specified for one waggonload NOT per Good!!
    -- prices can be set here, or be overwriten in the climate zone PriceTable Script

    MerchantSystem.BasePrices = {}

  -- Resources
    MerchantSystem.BasePrices[Goods.G_Water]        = 20

    MerchantSystem.BasePrices[Goods.G_Wood]         = 20
    MerchantSystem.BasePrices[Goods.G_Stone]        = 35
    MerchantSystem.BasePrices[Goods.G_Iron]         = 40

    MerchantSystem.BasePrices[Goods.G_Grain]        = 30
    MerchantSystem.BasePrices[Goods.G_Milk]         = 30
    MerchantSystem.BasePrices[Goods.G_Carcass]      = 30
    MerchantSystem.BasePrices[Goods.G_RawFish]      = 30

    MerchantSystem.BasePrices[Goods.G_Herb]         = 30
    MerchantSystem.BasePrices[Goods.G_Honeycomb]    = 30
    MerchantSystem.BasePrices[Goods.G_Wool]         = 30

    -- Goods
    MerchantSystem.BasePrices[Goods.G_Bread]        = 50
    MerchantSystem.BasePrices[Goods.G_Cheese]       = 50
    MerchantSystem.BasePrices[Goods.G_Sausage]      = 50
    MerchantSystem.BasePrices[Goods.G_SmokedFish]   = 50

    MerchantSystem.BasePrices[Goods.G_Soap]         = 50
    MerchantSystem.BasePrices[Goods.G_Broom]        = 50
    MerchantSystem.BasePrices[Goods.G_Medicine]     = 50

    MerchantSystem.BasePrices[Goods.G_Leather]      = 50
    MerchantSystem.BasePrices[Goods.G_Clothes]      = 50

    MerchantSystem.BasePrices[Goods.G_Beer]         = 50

    MerchantSystem.BasePrices[Goods.G_PoorSword]    = 60
    MerchantSystem.BasePrices[Goods.G_PoorBow]      = 60

    -- Trade Goods
    MerchantSystem.BasePrices[Goods.G_Dye]          = 150
    MerchantSystem.BasePrices[Goods.G_Salt]         = 150

    MerchantSystem.BasePrices[Entities.U_FireEater] = 120 --TODO: to be deleted
    MerchantSystem.BasePrices[Entities.U_Entertainer_NA_FireEater] = 120
    MerchantSystem.BasePrices[Entities.U_Entertainer_NA_StiltWalker] = 120
    MerchantSystem.BasePrices[Entities.U_Entertainer_NE_StrongestMan_Barrel] = 120
    MerchantSystem.BasePrices[Entities.U_Entertainer_NE_StrongestMan_Stone] = 120

    --prices are *9 (wagonload) for one herd of 5 animals!
    MerchantSystem.BasePrices[Goods.G_Cow]          = 70
    MerchantSystem.BasePrices[Goods.G_Sheep]        = 70

-- bandit battalions should cost 1/3 of the military batallions because they only have 3 soldiers
    MerchantSystem.BasePrices[Entities.U_MilitaryBandit_Ranged_NA] = 60
    MerchantSystem.BasePrices[Entities.U_MilitaryBandit_Ranged_NE] = 60
    MerchantSystem.BasePrices[Entities.U_MilitaryBandit_Ranged_ME] = 60
    MerchantSystem.BasePrices[Entities.U_MilitaryBandit_Ranged_SE] = 60

    MerchantSystem.BasePrices[Entities.U_MilitaryBandit_Melee_SE] = 60
    MerchantSystem.BasePrices[Entities.U_MilitaryBandit_Melee_NA] = 60
    MerchantSystem.BasePrices[Entities.U_MilitaryBandit_Melee_NE] = 60
    MerchantSystem.BasePrices[Entities.U_MilitaryBandit_Melee_ME] = 60
    
    MerchantSystem.BasePrices[Entities.U_MilitarySword] = 120
    MerchantSystem.BasePrices[Entities.U_MilitaryBow]  = 120
    MerchantSystem.BasePrices[Entities.U_MilitarySword_RedPrince] = 120
    MerchantSystem.BasePrices[Entities.U_MilitaryBow_RedPrince]  = 120

    -- refresh rates can be set here or be overwritten in the PriceAndRefreshrates scripts
    MerchantSystem.RefreshRates = {}
    MerchantSystem.RefreshRates[Goods.G_Water]      = 60

    MerchantSystem.RefreshRates[Goods.G_Wood]       = 60
    MerchantSystem.RefreshRates[Goods.G_Stone]      = 60
    MerchantSystem.RefreshRates[Goods.G_Iron]       = 60

    MerchantSystem.RefreshRates[Goods.G_Grain]      = 60
    MerchantSystem.RefreshRates[Goods.G_Milk]       = 60
    MerchantSystem.RefreshRates[Goods.G_Carcass]    = 60
    MerchantSystem.RefreshRates[Goods.G_RawFish]    = 60

    MerchantSystem.RefreshRates[Goods.G_Herb]       = 60
    MerchantSystem.RefreshRates[Goods.G_Honeycomb]  = 60
    MerchantSystem.RefreshRates[Goods.G_Wool]       = 60

    MerchantSystem.RefreshRates[Goods.G_Bread]      = 150
    MerchantSystem.RefreshRates[Goods.G_Cheese]     = 150
    MerchantSystem.RefreshRates[Goods.G_Sausage]    = 150
    MerchantSystem.RefreshRates[Goods.G_SmokedFish] = 150

    MerchantSystem.RefreshRates[Goods.G_Soap]       = 150
    MerchantSystem.RefreshRates[Goods.G_Broom]      = 150
    MerchantSystem.RefreshRates[Goods.G_Medicine]   = 150

     MerchantSystem.RefreshRates[Goods.G_Leather]    = 150
    MerchantSystem.RefreshRates[Goods.G_Clothes]    = 150

    MerchantSystem.RefreshRates[Goods.G_Beer]       = 150

    MerchantSystem.RefreshRates[Goods.G_PoorSword]  = 150
    MerchantSystem.RefreshRates[Goods.G_PoorBow]    = 150

    MerchantSystem.RefreshRates[Goods.G_Dye]  = 150
    MerchantSystem.RefreshRates[Goods.G_Salt]    = 150

    MerchantSystem.RefreshRates[Goods.G_Cow]        = 150
    MerchantSystem.RefreshRates[Goods.G_Sheep]      = 150


    MerchantSystem.RefreshRates[Entities.U_MilitaryBandit_Ranged_NA] = 150
    MerchantSystem.RefreshRates[Entities.U_MilitaryBandit_Ranged_NE] = 150
    MerchantSystem.RefreshRates[Entities.U_MilitaryBandit_Ranged_ME] = 150
    MerchantSystem.RefreshRates[Entities.U_MilitaryBandit_Ranged_SE] = 150

    MerchantSystem.RefreshRates[Entities.U_MilitaryBandit_Melee_SE] = 150
    MerchantSystem.RefreshRates[Entities.U_MilitaryBandit_Melee_NA] = 150
    MerchantSystem.RefreshRates[Entities.U_MilitaryBandit_Melee_NE] = 150
    MerchantSystem.RefreshRates[Entities.U_MilitaryBandit_Melee_ME] = 150
    
    MerchantSystem.RefreshRates[Entities.U_MilitarySword] = 150
    MerchantSystem.RefreshRates[Entities.U_MilitaryBow]  = 150
    MerchantSystem.RefreshRates[Entities.U_MilitarySword_RedPrince] = 150
    MerchantSystem.RefreshRates[Entities.U_MilitaryBow_RedPrince]  = 150

    -- load climate depending script with tables
    local MapName = Framework.GetCurrentMapName()
    local MapType, Campaign = Framework.GetCurrentMapTypeAndCampaignName()

    local ClimateZoneName = Framework.GetMapClimateZone(MapName, MapType, Campaign)

    if ClimateZoneName == "Generic" then
        ClimateZoneName = "MiddleEurope"
    end

    local PriceTableScript = "PriceAndRefreshRates_" ..ClimateZoneName .. ".lua"

    Script.Load( "Script\\Global\\ScriptSystems\\PriceAndRefreshRates\\" .. PriceTableScript )


    MerchantSystem.Waggonload = 9
    MerchantSystem.GoldWaggonload = 50


    -- consts for the traveling salesman (ship)
    g_TravelingSalesmanStatus = {}
    g_TravelingSalesmanStatus.Sailing = 0
    g_TravelingSalesmanStatus.OnHisWay = 1
    g_TravelingSalesmanStatus.AtHarbour = 2
    g_TravelingSalesmanStatus.Leaving = 3

    g_BuffForGood = {}
    g_BuffForGood[Goods.G_Salt] = Buffs.Buff_Spice
    g_BuffForGood[Goods.G_Dye]  = Buffs.Buff_Colour

    StartSimpleJob("CheckTradeBuffsForAllPlayers")


    --generate a black list of goods, the player will not buy (when an offer is created)
    MerchantSystem.TradeBlackList = {}
    MerchantSystem.PlayerDoesNotBuyGoods = {}

    for PlayerID=1, 8 do
        MerchantSystem.TradeBlackList[PlayerID] = {}
        MerchantSystem.TradeBlackList[PlayerID][0] = #MerchantSystem.TradeBlackList[PlayerID]
    end

end


function AddOffer(_Merchant,_NumberOfOffers, _GoodType, _RefreshRate)

    --AnSu: Maybe give the playerID instead of buildingId and get the storehouse...
	local MerchantID

	if type(_Merchant) == "string" then

		MerchantID = Logic.GetEntityIDByName(_Merchant)

	else

		MerchantID = _Merchant

	end

	if type(_GoodType) == "string" then
	    _GoodType = Goods[_GoodType]
    else
        _GoodType = _GoodType
    end

    --add good to blacklist
    local PlayerID = Logic.EntityGetPlayer(MerchantID)
    AddGoodToTradeBlackList(PlayerID, _GoodType)

    local MarketerType = Entities.U_Marketer

    if _GoodType == Goods.G_Medicine then
        MarketerType = Entities.U_Medicus
    end

    local GoodAmount = MerchantSystem.Waggonload

    --AnSu: Not Needed?
    local PlayerID = 1
    local Price = 0


    if _RefreshRate == nil then

        _RefreshRate = MerchantSystem.RefreshRates[_GoodType]

        if _RefreshRate == nil then
            _RefreshRate = 0
        end
    end

	return Logic.AddGoodTraderOffer(MerchantID,_NumberOfOffers,Goods.G_Gold,Price,_GoodType,GoodAmount,PlayerID,
    _RefreshRate,MarketerType,Entities.U_ResourceMerchant)

end


function AddMercenaryOffer( _Mercenary, _Amount, _Type, _RefreshRate)

    local MercenaryID

	if type(_Mercenary) == "string" then
		MercenaryID = Logic.GetEntityIDByName(_Mercenary)
	else
		MercenaryID = _Mercenary
	end


	local PlayerId = 1

	if _Type == nil then
	    _Type = Entities.U_MilitaryBandit_Melee_ME
    end


	if _RefreshRate == nil then

        _RefreshRate = MerchantSystem.RefreshRates[_Type]

        if _RefreshRate == nil then
            _RefreshRate = 0
        end
    end

    Logic.AddMercenaryTraderOffer(MercenaryID, _Amount, Goods.G_Gold, 3, _Type ,3,PlayerId,_RefreshRate)

end

-------------------------------------------------------------------------------------------------------
function AddEntertainerOffer(_Merchant, _EntertainerType)

    local MerchantID

	if type(_Merchant) == "string" then

		MerchantID = Logic.GetEntityIDByName(_Merchant)

	else

		MerchantID = _Merchant

	end


	local PlayerID = 1
	local RefreshRate = 0
	local NumberOfOffers = 1

	if _EntertainerType == nil then
	    _EntertainerType = Entities.U_Entertainer_NA_FireEater
	end

    Logic.AddEntertainerTraderOffer(MerchantID,NumberOfOffers,Goods.G_Gold,0,_EntertainerType, PlayerID,RefreshRate)

end


function ActivateMerchantForPlayersKnight( _TraderBuildingID, _PlayerID)

    Logic.SetTraderPlayerState(_TraderBuildingID,_PlayerID,0)

end


function DeActivateMerchantForPlayer( _TraderBuildingID, _PlayerID)

    Logic.SetTraderPlayerState(_TraderBuildingID,_PlayerID,2)

end


function ActivateMerchantPermanentlyForPlayer( _TraderBuildingID, _PlayerID)

    Logic.SetTraderPlayerState(_TraderBuildingID,_PlayerID,1)

end


function ActivateTravelingSalesman( _PlayerID, _MonthOfferTable, _DurationInMonths)

    --tabelle pro spieler script läuft auch für mehr als einen trader
    --value wie lange er bleibt
    --Offers müssen gelöscht werden können
    --we need getTraderPlayerState to close the UI when it is deactiavted during knight is there
    --vielleicht FoW sharem während schiff unterwegs ist

    -- Traveling Salesman needs
            -- a Storehouse (there is a sacial one)
            -- XD_TradeShipSpawn
            -- XD_TradeShipMoveTo
            -- free playerID, that is not used for diplomacy

    -- Example to set up a TravelingSalesman:
    --  ActivateTravelingSalesman(      8,                                  --TraderplayerID
    --                                {
    --                                    {3, {                           --Month
    --                                            {Goods.G_Bread,5},      --first offer for this month
    --                                            {Entities.U_FireEater}  --second offer for this month
    --                                         }
    --                                    } ,
    --
    --                                    {5
    --                                    }
    --                                }
    --                           )
    --

    if g_TravelingSalesman ~= nil then
        Logic.DEBUG_AddNote("DEBUG: Only one merchant ship is supported at the moment")
        return
    end

    g_TravelingSalesman = {}
    g_TravelingSalesman.PlayerID        = _PlayerID
    g_TravelingSalesman.StorehouseID    = Logic.GetStoreHouse(_PlayerID)
    g_TravelingSalesman.Status          = g_TravelingSalesmanStatus.Sailing
    g_TravelingSalesman.MonthOfferTable = {}
    if _DurationInMonths == nil then
        _DurationInMonths = 1
    end
    g_TravelingSalesman.ActivationTime  = _DurationInMonths --amount of month the ship stays


    --save offer tables
    for i=1, #_MonthOfferTable do

        local Month = _MonthOfferTable[i][1]
        g_TravelingSalesman.MonthOfferTable[Month] = _MonthOfferTable[i][2]

    end

    --save spawn point or return
    local ShipSpawnPoint = {Logic.GetPlayerEntities(g_TravelingSalesman.PlayerID, Entities.XD_TradeShipSpawn,1,0)}
    if ShipSpawnPoint[1] ~= 0 then
        g_TravelingSalesman.SpawnPoint = ShipSpawnPoint[2]
    else
        Logic.DEBUG_AddNote("DEBUG: Merchant ship has no spawn point")
        return
    end

    local ShipDestination = {Logic.GetPlayerEntities(g_TravelingSalesman.PlayerID, Entities.XD_TradeShipMoveTo,1,0)}
    if ShipDestination[1] ~= 0 then
        g_TravelingSalesman.ShipDestination = ShipDestination[2]
    else
        Logic.DEBUG_AddNote("DEBUG: Merchant ship has no move to point")
        return
    end

    --close for all
	for PlayerID = 1, 8 do
        Logic.SetTraderPlayerState(g_TravelingSalesman.StorehouseID,PlayerID,2)
    end

    --set right name and picture
    SetupPlayer( _PlayerID , "H_NPC_Generic_Trader", "XTradeShipX", "TravelingSalesmanColor")

    StartSimpleJob("TravelingSalesman")

end


function TravelingSalesman()

    --delete the ship and stop this function, if storehouse of traveling salesman is destroyed
    if Logic.IsEntityAlive(g_TravelingSalesman.StorehouseID) == false then

        if Logic.IsEntityAlive(g_TravelingSalesman.ShipID) then
            Logic.DestroyEntity(g_TravelingSalesman.ShipID)
            --Logic.DestroyEntity(g_TravelingSalesman.ShipWaveID)
        end

        --Logic.DEBUG_AddNote("The harbour has been destroyed. No more merchant ships will arrive.")
        Logic.ExecuteInLuaLocalState("LocalScriptCallback_QueueVoiceMessage("..g_TravelingSalesman.PlayerID..", 'TravelingSalesmanDestroyed')")
        return true
    end

    -- spawn ship and send it to the harbour
    if  g_TravelingSalesman.Status == g_TravelingSalesmanStatus.Sailing then

        local CurrentMonth = Logic.GetCurrentMonth()

        for Month,value in pairs (g_TravelingSalesman.MonthOfferTable) do

            if CurrentMonth == Month then

                --create offers for this month
                GenerateTravelingSalesManOffersForMonth(g_TravelingSalesman.MonthOfferTable[CurrentMonth])

                --create ship
                local x,y = Logic.GetEntityPosition(g_TravelingSalesman.SpawnPoint)
                g_TravelingSalesman.ShipID = Logic.CreateEntity(Entities.D_X_TradeShip, x, y, 0, g_TravelingSalesman.PlayerID)
                --g_TravelingSalesman.ShipWaveID = Logic.CreateEntity(Entities.E_Kogge, x, y, 0, g_TravelingSalesman.PlayerID)

                --move ship to destination
                local x, y = Logic.GetEntityPosition(g_TravelingSalesman.ShipDestination)
                Logic.MoveEntity(g_TravelingSalesman.ShipID, x, y)
                --Logic.MoveEntity(g_TravelingSalesman.ShipWaveID, x, y)


                --save new status
                g_TravelingSalesman.Status = g_TravelingSalesmanStatus.OnHisWay

                --send message to all players
                --Logic.DEBUG_AddNote("A merchant ship has been spotted.")
                Logic.ExecuteInLuaLocalState("LocalScriptCallback_QueueVoiceMessage(".. g_TravelingSalesman.PlayerID ..", 'TravelingSalesmanSpotted')")

                g_TravelingSalesman.ActivatedInMonth = CurrentMonth

            end
        end

    --Check if ship reached the harbour
    elseif      g_TravelingSalesman.Status == g_TravelingSalesmanStatus.OnHisWay
            and Logic.GetDistanceBetweenEntities(g_TravelingSalesman.ShipID, g_TravelingSalesman.ShipDestination) <= 800 then

            -- Rotate ship in the same direction as the destination
            local Orientation = Logic.GetEntityOrientation(g_TravelingSalesman.ShipDestination)
            Logic.RotateEntity(g_TravelingSalesman.ShipID, Orientation)

            -- delte wave
            --Logic.DestroyEntity(g_TravelingSalesman.ShipWaveID)

            -- open trader for all players
            for PlayerID = 1, 8 do
                Logic.SetTraderPlayerState(g_TravelingSalesman.StorehouseID,PlayerID,0)
            end

            --save new status
            g_TravelingSalesman.Status = g_TravelingSalesmanStatus.AtHarbour

            --send message to all players
            --Logic.DEBUG_AddNote("The merchant ship arrived at the harbour.")

            local x, ShipMoveToPoint = Logic.GetEntities(Entities.XD_TradeShipMoveTo, 1)
            g_TravelingSalesman.StayingTimeInSeconds = g_TravelingSalesman.ActivationTime * 150

            g_TravelingSalesman.ActivationTimeInSeconds = Logic.GetTime()

            QuestTemplate:New("TravelingSalesman",
                g_TravelingSalesman.PlayerID,
                1,
                { {Objective.Object, { ShipMoveToPoint } } },
                { { Triggers.Time, 0 } },
                g_TravelingSalesman.StayingTimeInSeconds)

            --callback to the map, to react on an arriving salesman
            if Mission_Callback_TravelingSalesman ~= nil then
                Mission_Callback_TravelingSalesman(g_TravelingSalesman.Status)
            end




    --ship leaves after 2 months
    elseif      g_TravelingSalesman.Status == g_TravelingSalesmanStatus.AtHarbour
            and Logic.GetTime() == g_TravelingSalesman.StayingTimeInSeconds + g_TravelingSalesman.ActivationTimeInSeconds then

            -- send ship back to map border
            local x, y = Logic.GetEntityPosition(g_TravelingSalesman.SpawnPoint)
            Logic.MoveEntity(g_TravelingSalesman.ShipID, x, y)

            local ShipPositionX, ShipPositionY = Logic.GetEntityPosition(g_TravelingSalesman.ShipID)
            --g_TravelingSalesman.ShipWaveID = Logic.CreateEntity(Entities.E_Kogge, ShipPositionX, ShipPositionY, 0, g_TravelingSalesman.PlayerID)
            --Logic.MoveEntity(g_TravelingSalesman.ShipWaveID, x, y)


            -- close trader for all players
            for PlayerID = 1, 8 do
                Logic.SetTraderPlayerState(g_TravelingSalesman.StorehouseID,PlayerID,2)
                
                -- Hack to force a menu update - force the menu do disappear even if the player is allied with the salesman
                Logic.ExecuteInLuaLocalState("GameCallback_CloseNPCInteraction(1, Logic.GetStoreHouse("..g_TravelingSalesman.StorehouseID.."))")
            end

            --save new status
            g_TravelingSalesman.Status = g_TravelingSalesmanStatus.Leaving

            --callback to the map, to react on an arriving salesman
            if Mission_Callback_TravelingSalesman ~= nil then
                Mission_Callback_TravelingSalesman(g_TravelingSalesman.Status)
            end



    elseif      g_TravelingSalesman.Status == g_TravelingSalesmanStatus.Leaving
            and Logic.GetDistanceBetweenEntities(g_TravelingSalesman.ShipID, g_TravelingSalesman.SpawnPoint) <= 100 then

            --ship vanish
            Logic.DestroyEntity(g_TravelingSalesman.ShipID)
            --Logic.DestroyEntity(g_TravelingSalesman.ShipWaveID)

            --save new status
            g_TravelingSalesman.Status = g_TravelingSalesmanStatus.Sailing

            --clear last month
            g_TravelingSalesman.ActivatedInMonth = 0

    end

end


 function GenerateTravelingSalesManOffersForMonth(_OfferTable)

    -- delete old offers
    Logic.RemoveAllOffers(g_TravelingSalesman.StorehouseID)

    --generate offers for month
    for i =1, #_OfferTable do

        local Type = _OfferTable[i][1]

        local IsGood = false

        for key,value in pairs (Goods) do

            if Type == value then

                AddOffer( g_TravelingSalesman.StorehouseID,
                         _OfferTable[i][2],
                         Type,
                         0)

                IsGood = true
            end
        end

        if IsGood == false then

            if Logic.IsEntityTypeInCategory(Type,EntityCategories.Military)== 1 then

                local Amount = _OfferTable[i][2]

	            AddMercenaryOffer	(g_TravelingSalesman.StorehouseID,
	                                Amount,
	                                Type,
	                                0)

            else

                AddEntertainerOffer	(g_TravelingSalesman.StorehouseID,
                                    Type)
            end

        end

    end

end


function CheckTradeBuffsForAllPlayers()

    for PlayerID=1,8 do

        -- Check for goods in Storehouse
        local Storehouse = Logic.GetStoreHouse(PlayerID)

        if Storehouse ~= 0 then

            for GoodType,BuffID in pairs (g_BuffForGood) do

                if Logic.GetIndexOnOutStockByGoodType(Storehouse, GoodType) ~= -1 then

                    local GoodAmount = Logic.GetAmountOnOutStockByGoodType(Storehouse,GoodType)

                    if GoodAmount > 0 then

                        Logic.AddBuff(PlayerID, BuffID)

                    else

                        local BuffCategory, SecondsLeft, CitySatisfactionModifier = Logic.GetBuff(PlayerID,BuffID)
                        Logic.RemoveBuff(PlayerID, BuffCategory)

                    end
                end
            end
        end


        --check for entertainer in city

        local MarketplaceID = Logic.GetMarketplace(PlayerID)

        if MarketplaceID ~= nil and MarketplaceID ~= 0 and Logic.IsAnyEntertainerOnTheMarketplace(MarketplaceID) then

            Logic.AddBuff(PlayerID, Buffs.Buff_Entertainers)

        else

            Logic.RemoveBuff(PlayerID, BuffCategories.BC_Entertainers)

        end

    end

end


function AddGoodToTradeBlackList(_PlayerID, _GoodType)

    if type(_GoodType) == "table" then
        for i=1, #_GoodType do
            table.insert(MerchantSystem.TradeBlackList[_PlayerID], _GoodType[i])
        end
    else
        table.insert(MerchantSystem.TradeBlackList[_PlayerID], _GoodType)
    end

    MerchantSystem.TradeBlackList[_PlayerID][0] = #MerchantSystem.TradeBlackList[_PlayerID]

end


function RemoveGoodToTradeBlackList(_PlayerID, _GoodType)

    for i=1, #MerchantSystem.TradeBlackList[_PlayerID] do
        if MerchantSystem.TradeBlackList[_PlayerID][i] == _GoodType then
            table.remove(MerchantSystem.TradeBlackList[_PlayerID], i)
            MerchantSystem.TradeBlackList[_PlayerID][0] = #MerchantSystem.TradeBlackList[_PlayerID]
        end
    end

end


function SetPlayerDoesNotBuyGoodsFlag( _PlayerID, _Flag)

    MerchantSystem.PlayerDoesNotBuyGoods[_PlayerID] = _Flag

end
