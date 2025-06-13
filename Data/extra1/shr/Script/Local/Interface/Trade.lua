
GUI_Trade = {}


function InitPlayersTrade()

    g_Trade = {}
    g_Trade.SellToPlayers = {}
    g_Trade.GoodType = 0
    g_Trade.GoodAmount = 0
    g_Trade.TargetPlayers = {}
    MerchantSystem = Logic.CreateReferenceToTableInGlobaLuaState("MerchantSystem")

    XGUIEng.ShowAllSubWidgets("/InGame/Root/Normal/AlignBottomRight/Selection", 0)
    XGUIEng.ShowWidget("/InGame/Root/Normal/AlignBottomRight/SalesDialog",0)
    XGUIEng.ShowWidget("/InGame/Root/Normal/AlignBottomRight/DialogButtons/PlayerButtons",0)

    XGUIEng.ShowAllSubWidgets("/InGame/Root/Normal/AlignBottomRight/Selection/Storehouse/TabButtons", 0)

    XGUIEng.ShowWidget("/InGame/Root/Normal/AlignBottomRight/Selection/Storehouse/TabButtons/StoreHouseTabButtonUp", 1)
    XGUIEng.ShowWidget("/InGame/Root/Normal/AlignBottomRight/Selection/Storehouse/TabButtons/CityTabButtonDown", 1)

    if Framework.IsNetworkGame() then
        XGUIEng.ShowWidget("/InGame/Root/Normal/AlignBottomRight/Selection/Storehouse/TabButtons/Tab03Down", 1)
    else
        XGUIEng.ShowWidget("/InGame/Root/Normal/AlignBottomRight/Selection/Storehouse/TabButtons/Tab03Empty", 1)
    end

    XGUIEng.ShowWidget("/InGame/Root/Normal/AlignBottomRight/Selection/Storehouse/InStorehouse", 1)
    XGUIEng.ShowWidget("/InGame/Root/Normal/AlignBottomRight/Selection/Storehouse/InCity", 0)
    XGUIEng.ShowWidget("/InGame/Root/Normal/AlignBottomRight/Selection/Storehouse/InMulti", 0)

    XGUIEng.ShowWidget("/InGame/Root/Normal/AlignBottomRight/DialogButtons/PlayerButtons/DestroyGoods", 1)

end

function GUI_Trade.StorehouseSelected()

    g_Trade.GoodType = 0
    g_Trade.GoodAmount = 0

    XGUIEng.ShowWidget("/InGame/Root/Normal/AlignBottomRight/SalesDialog",0)
    XGUIEng.DisableButton("/InGame/Root/Normal/AlignBottomRight/DialogButtons/PlayerButtons/DestroyGoods", 1)

end

function GUI_Trade.CityTabButtonClicked()

    g_Trade.GoodType = 0
    g_Trade.GoodAmount = 0

    Sound.FXPlay2DSound("ui\\menu_click")

    XGUIEng.ShowAllSubWidgets("/InGame/Root/Normal/AlignBottomRight/Selection/Storehouse/TabButtons", 0)

    XGUIEng.ShowWidget("/InGame/Root/Normal/AlignBottomRight/Selection/Storehouse/TabButtons/StoreHouseTabButtonDown", 1)
    XGUIEng.ShowWidget("/InGame/Root/Normal/AlignBottomRight/Selection/Storehouse/TabButtons/CityTabButtonUp", 1)

    XGUIEng.ShowWidget("/InGame/Root/Normal/AlignBottomRight/Selection/Storehouse/InStorehouse", 0)
    XGUIEng.ShowWidget("/InGame/Root/Normal/AlignBottomRight/Selection/Storehouse/InCity", 1)
    XGUIEng.ShowWidget("/InGame/Root/Normal/AlignBottomRight/Selection/Storehouse/InMulti", 0)

    XGUIEng.ShowWidget("/InGame/Root/Normal/AlignBottomRight/DialogButtons/PlayerButtons/DestroyGoods", 0)

    if Framework.IsNetworkGame() then
        XGUIEng.ShowWidget("/InGame/Root/Normal/AlignBottomRight/Selection/Storehouse/TabButtons/Tab03Down", 1)
    else
        XGUIEng.ShowWidget("/InGame/Root/Normal/AlignBottomRight/Selection/Storehouse/TabButtons/Tab03Empty", 1)
    end

end

function GUI_Trade.StorehouseTabButtonClicked()

    g_Trade.GoodType = 0
    g_Trade.GoodAmount = 0

    Sound.FXPlay2DSound("ui\\menu_click")

    XGUIEng.ShowAllSubWidgets("/InGame/Root/Normal/AlignBottomRight/Selection/Storehouse/TabButtons", 0)

    XGUIEng.ShowWidget("/InGame/Root/Normal/AlignBottomRight/Selection/Storehouse/TabButtons/StoreHouseTabButtonUp", 1)
    XGUIEng.ShowWidget("/InGame/Root/Normal/AlignBottomRight/Selection/Storehouse/TabButtons/CityTabButtonDown", 1)

    XGUIEng.ShowWidget("/InGame/Root/Normal/AlignBottomRight/Selection/Storehouse/InStorehouse", 1)
    XGUIEng.ShowWidget("/InGame/Root/Normal/AlignBottomRight/Selection/Storehouse/InCity", 0)
    XGUIEng.ShowWidget("/InGame/Root/Normal/AlignBottomRight/Selection/Storehouse/InMulti", 0)

    XGUIEng.ShowWidget("/InGame/Root/Normal/AlignBottomRight/DialogButtons/PlayerButtons/DestroyGoods", 1)

    if Framework.IsNetworkGame() then
        XGUIEng.ShowWidget("/InGame/Root/Normal/AlignBottomRight/Selection/Storehouse/TabButtons/Tab03Down", 1)
    else
        XGUIEng.ShowWidget("/InGame/Root/Normal/AlignBottomRight/Selection/Storehouse/TabButtons/Tab03Empty", 1)
    end

end


function GUI_Trade.MultiTabButtonClicked()

    g_Trade.GoodType = 0
    g_Trade.GoodAmount = 0

    Sound.FXPlay2DSound("ui\\menu_click")

    XGUIEng.ShowAllSubWidgets("/InGame/Root/Normal/AlignBottomRight/Selection/Storehouse/TabButtons", 0)

    XGUIEng.ShowWidget("/InGame/Root/Normal/AlignBottomRight/Selection/Storehouse/TabButtons/StoreHouseTabButtonDown", 1)
    XGUIEng.ShowWidget("/InGame/Root/Normal/AlignBottomRight/Selection/Storehouse/TabButtons/CityTabButtonDown", 1)

    XGUIEng.ShowWidget("/InGame/Root/Normal/AlignBottomRight/Selection/Storehouse/InStorehouse", 0)
    XGUIEng.ShowWidget("/InGame/Root/Normal/AlignBottomRight/Selection/Storehouse/InCity", 0)
    XGUIEng.ShowWidget("/InGame/Root/Normal/AlignBottomRight/Selection/Storehouse/InMulti", 1)
    

    XGUIEng.ShowWidget("/InGame/Root/Normal/AlignBottomRight/DialogButtons/PlayerButtons/DestroyGoods", 1)
    
    local ShowGoods = 0
    
    if g_Trade.ShowGoodsInMultiTabOverride then
        ShowGoods = 1
    end
    
    XGUIEng.ShowAllSubWidgets( "/InGame/Root/Normal/AlignBottomRight/Selection/Storehouse/InMulti/Goods", ShowGoods )
    
    if Framework.IsNetworkGame() then
        XGUIEng.ShowWidget(        "/InGame/Root/Normal/AlignBottomRight/Selection/Storehouse/InMulti/Goods/G_Gold", 1 )
        XGUIEng.ShowAllSubWidgets( "/InGame/Root/Normal/AlignBottomRight/Selection/Storehouse/InMulti/Goods/G_Gold", 1 )
    else
        XGUIEng.ShowWidget( "/InGame/Root/Normal/AlignBottomRight/Selection/Storehouse/InMulti/Goods/G_Gold", 0 )
    end

    XGUIEng.ShowWidget("/InGame/Root/Normal/AlignBottomRight/Selection/Storehouse/TabButtons/Tab03Up", 1)

end


function GUI_Trade.GoodClicked()

    Sound.FXPlay2DSound( "ui\\menu_click")

    local GoodType = Goods[XGUIEng.GetWidgetNameByID(XGUIEng.GetWidgetsMotherID(XGUIEng.GetCurrentWidgetID()))]
    XGUIEng.ShowWidget("/InGame/Root/Normal/AlignBottomRight/Selection/Storehouse/AmountContainer",1)
    
    if g_Trade.GoodType ~= GoodType then
        g_Trade.GoodType = GoodType
        g_Trade.GoodAmount = 0
    end

    GUI_Trade.UpdateSlider()
    XGUIEng.SliderSetToMax("/InGame/Root/Normal/AlignBottomRight/Selection/Storehouse/AmountContainer/SliderWidget")

    if XGUIEng.IsWidgetShown("/InGame/Root/Normal/AlignBottomRight/SalesDialog") == 0 then
        XGUIEng.ShowWidget("/InGame/Root/Normal/AlignBottomRight/SalesDialog",1)

        XGUIEng.ShowWidget("/InGame/Root/Normal/AlignBottomRight/WeatherMenu", 0) -- hide weather menu (else, overlap)
    end
    
    if GoodType == Goods.G_Gold then
        XGUIEng.ShowWidget("/InGame/Root/Normal/AlignBottomRight/DialogButtons/PlayerButtons/DestroyGoods", 0)        
    else
        XGUIEng.ShowWidget("/InGame/Root/Normal/AlignBottomRight/DialogButtons/PlayerButtons/DestroyGoods", 1)        
    end
end

function GUI_Trade.UpdateSlider()
    local PlayerID = GUI.GetPlayerID()
    local GoodAmount = GetAmountOfGoodsForTrading(PlayerID, g_Trade.GoodType)

    local Waggonload = MerchantSystem.Waggonload
    if g_Trade.GoodType == Goods.G_Gold then
        Waggonload = MerchantSystem.GoldWaggonload
    end

    local Min = 0
    local Max = math.floor(GoodAmount / Waggonload)

    -- DIRTY HACK: to force slider to bottom if value is zero
    if Max == 0 then
        Min = 1
    end

    XGUIEng.SliderSetValueMin("/InGame/Root/Normal/AlignBottomRight/Selection/Storehouse/AmountContainer/SliderWidget", Min)
    XGUIEng.SliderSetValueMax("/InGame/Root/Normal/AlignBottomRight/Selection/Storehouse/AmountContainer/SliderWidget", Max)

    GUI_Trade.OnGoodValueChanged()
end

function GUI_Trade.OnGoodValueChanged()

    if g_Trade.GoodType ~= 0 then
        local PlayerID = GUI.GetPlayerID()
        local GoodAmount = GetAmountOfGoodsForTrading(PlayerID, g_Trade.GoodType)

        local Max = XGUIEng.SliderGetValueMax("/InGame/Root/Normal/AlignBottomRight/Selection/Storehouse/AmountContainer/SliderWidget")
        local Abs = XGUIEng.SliderGetValueAbs("/InGame/Root/Normal/AlignBottomRight/Selection/Storehouse/AmountContainer/SliderWidget")

        local Waggonload = MerchantSystem.Waggonload
        if g_Trade.GoodType == Goods.G_Gold then
            Waggonload = MerchantSystem.GoldWaggonload
        end

        local SliderValue = (Max - Abs) * Waggonload

        if SliderValue > GoodAmount then
            g_Trade.GoodAmount = math.min(GoodAmount, 999)
            XGUIEng.DisableButton("/InGame/Root/Normal/AlignBottomRight/DialogButtons/PlayerButtons/DestroyGoods", 0)
        elseif SliderValue <= 0 then
            g_Trade.GoodAmount = 0
            XGUIEng.DisableButton("/InGame/Root/Normal/AlignBottomRight/DialogButtons/PlayerButtons/DestroyGoods", 1)
        else
            g_Trade.GoodAmount = math.min(SliderValue, 999)
            XGUIEng.DisableButton("/InGame/Root/Normal/AlignBottomRight/DialogButtons/PlayerButtons/DestroyGoods", 0)
        end
        
        
    end    
end

function GUI_Trade.DestroyGoodsClicked()

    Sound.FXPlay2DSound( "ui\\menu_click")

    local PlayerID = GUI.GetPlayerID()
    local StorehouseID = Logic.GetStoreHouse(PlayerID)
    GUI.RemoveGoodFromStock(StorehouseID, g_Trade.GoodType, g_Trade.GoodAmount)

end


function GUI_Trade.GoodTypeToSellUpdate()
    local CurrentWidgetID = XGUIEng.GetCurrentWidgetID()
    local GoodType = g_Trade.GoodType

    if GoodType == 0 then
        XGUIEng.SetMaterialColor(CurrentWidgetID, 0, 0, 0, 0, 0)
    else
        XGUIEng.SetMaterialColor(CurrentWidgetID, 0, 255, 255, 255, 255)
        SetIcon(CurrentWidgetID, g_TexturePositions.Goods[GoodType], 128)
    end

    GUI_Trade.UpdateSlider()
end


function GUI_Trade.AmountToSellUpdate()

    local Amount = g_Trade.GoodAmount
    local GoodType = g_Trade.GoodType
    local CurrentWidgetID = XGUIEng.GetCurrentWidgetID()

    local PlayerID = GUI.GetPlayerID()
    local StorehouseID = Logic.GetStoreHouse(PlayerID)
    local StorehouseGoodIndex = Logic.GetIndexOnOutStockByGoodType(StorehouseID, GoodType)
    local GoodAmount

    if StorehouseGoodIndex == -1 then
        local GoodAmountsList = {Logic.GetAmountsOfGoodsInPlayerOutstocks(PlayerID, GoodType)}
        GoodAmount = GoodAmountsList[2]
    else
        GoodAmount = GetAmountOfGoodsForTrading(PlayerID, GoodType)
    end

    if g_Trade.GoodAmount >= GoodAmount then
        g_Trade.GoodAmount = math.min(GoodAmount, 999)
    end

    if GoodType ~= 0 then
        XGUIEng.SetText(XGUIEng.GetCurrentWidgetID(), "{center}" .. g_Trade.GoodAmount)
    else
        XGUIEng.SetText(XGUIEng.GetCurrentWidgetID(), "{center}" .. "-")
    end

    if GoodAmount == 0 then
        XGUIEng.ShowWidget("/InGame/Root/Normal/AlignBottomRight/Selection/Storehouse/AmountContainer/SliderWidget",0)
    else
        XGUIEng.ShowWidget("/InGame/Root/Normal/AlignBottomRight/Selection/Storehouse/AmountContainer/SliderWidget",1)
    end
end


function GUI_Trade.SalesClicked()
    Sound.FXPlay2DSound( "ui\\menu_click")

    if XGUIEng.IsWidgetShown("/InGame/Root/Normal/AlignBottomRight/SalesDialog") == 1 then
        XGUIEng.ShowWidget("/InGame/Root/Normal/AlignBottomRight/SalesDialog",0)
    else
        XGUIEng.ShowWidget("/InGame/Root/Normal/AlignBottomRight/SalesDialog",1)

        XGUIEng.ShowWidget("/InGame/Root/Normal/AlignBottomRight/WeatherMenu", 0) -- hide weather menu (else, overlap)
    end
end

function GUI_Trade.SellUpdate() -- grey the button if can't sell a wagon

    local ButtonWidgetID = XGUIEng.GetCurrentWidgetID()
    local MotherWidgetID = XGUIEng.GetWidgetsMotherID(ButtonWidgetID)
    local MotherWidgetPath = XGUIEng.GetWidgetPathByID(MotherWidgetID)
    local GoodTypeName     = XGUIEng.GetWidgetNameByID(MotherWidgetID)
    local AmountWidgetID = MotherWidgetPath .. "/Amount"

    local Amount = XGUIEng.GetText(AmountWidgetID)
    
    -- remove all the {center} {color:...} ,etc..
    local i,j = string.find(Amount,"}")
    while i do
        Amount = string.sub(Amount,j+1)
        i,j = string.find(Amount,"}")
    end
    ---------------------------------------------
    Amount = tonumber(Amount)

    local Waggonload = MerchantSystem.Waggonload
    if Goods[GoodTypeName] == Goods.G_Gold then
        Waggonload = MerchantSystem.GoldWaggonload
    end

    if Amount == nil or Amount < Waggonload then
        XGUIEng.DisableButton(ButtonWidgetID,1)
    else
        XGUIEng.DisableButton(ButtonWidgetID,0)
    end

end

function GUI_Trade.SellClicked()

    Sound.FXPlay2DSound( "ui\\menu_click")

    if g_Trade.GoodAmount == 0 then
        return
    end

    local PlayerID = GUI.GetPlayerID()
    local ButtonIndex = tonumber(XGUIEng.GetWidgetNameByID(XGUIEng.GetWidgetsMotherID(XGUIEng.GetCurrentWidgetID())))
    local TargetID = g_Trade.TargetPlayers[ButtonIndex]


    -- check if sell cart can reach target player (check for target player's gold cart is superfluous)
    local PlayerSectorType = PlayerSectorTypes.Civil

    if g_Trade.GoodType == Goods.G_Gold then
        PlayerSectorType = PlayerSectorTypes.Thief
    end

    local IsReachable = CanEntityReachTarget(TargetID, Logic.GetStoreHouse(PlayerID), Logic.GetStoreHouse(TargetID),
        nil, PlayerSectorType)

    if IsReachable == false then
        local MessageText = XGUIEng.GetStringTableText("Feedback_TextLines/TextLine_GenericUnreachable")
        Message(MessageText)
        return
    end


    if g_Trade.GoodType == Goods.G_Gold then
        -- check for treasury space in castle

    elseif Logic.GetGoodCategoryForGoodType(g_Trade.GoodType) == GoodCategories.GC_Resource then
        local SpaceForNewGoods = Logic.GetPlayerUnreservedStorehouseSpace(TargetID)
        if SpaceForNewGoods < g_Trade.GoodAmount then
            local MessageText = XGUIEng.GetStringTableText("Feedback_TextLines/TextLine_TargetFactionStorehouseSpace")
            Message(MessageText)
            return
        end

    else
        if Logic.GetNumberOfTradeGatherers(PlayerID) >= 1 then
            local MessageText = XGUIEng.GetStringTableText("Feedback_TextLines/TextLine_TradeGathererUnderway")
            Message(MessageText)
            return
        end
        if Logic.CanFitAnotherMerchantOnMarketplace(Logic.GetMarketplace(TargetID)) == false then
            local MessageText = XGUIEng.GetStringTableText("Feedback_TextLines/TextLine_TargetFactionMarketplaceFull")
            Message(MessageText)
            return
        end
    end


    local Price
    if Logic.PlayerGetIsHumanFlag(TargetID) then
        Price = 0
    else
        Price = GUI_Trade.ComputeSellingPrice(TargetID, g_Trade.GoodType, g_Trade.GoodAmount)
        Price = Price / g_Trade.GoodAmount -- price is per good
    end

    GUI.StartTradeGoodGathering(PlayerID, TargetID, g_Trade.GoodType, g_Trade.GoodAmount, Price)
    GUI_FeedbackSpeech.Add("SpeechOnly_CartsSent", g_FeedbackSpeech.Categories.CartsUnderway, nil, nil)

    StartKnightVoiceForPermanentSpecialAbility(Entities.U_KnightTrading)
    StartKnightVoiceForPermanentSpecialAbility(Entities.U_KnightSabatta)


    -- create table for each player and good
    if Price ~= 0 then
        if g_Trade.SellToPlayers[TargetID] == nil then
            g_Trade.SellToPlayers[TargetID] = {}
        end

        if g_Trade.SellToPlayers[TargetID][g_Trade.GoodType] == nil then
            g_Trade.SellToPlayers[TargetID][g_Trade.GoodType] = g_Trade.GoodAmount
        else
            g_Trade.SellToPlayers[TargetID][g_Trade.GoodType] = g_Trade.SellToPlayers[TargetID][g_Trade.GoodType] + g_Trade.GoodAmount
        end
    end

end


function GUI_Trade.ComputeSellingPrice(_TargetPlayerID, _GoodType, _GoodAmount)

    if _GoodType == Goods.G_Gold then
        return 0
    end

    local Waggonload = MerchantSystem.Waggonload
    local BasePrice  = MerchantSystem.BasePrices[_GoodType]

    -- AnKe: 13.09.2007 (Settlers 6)
    --
    -- there are two ways to add the ability of knight trading
    --
    -- 1) calculate the trade price and add the ability afterwards
    --    > the problem is, that the total amount of gold can differ
    --      if you sell waggonloads together (a) or if you sell each
    --      waggonload alone (b).
    --
    --      example:  a)  50 + 37 + 24 = 111
    --                    => 111 * 1.2 = 133.2
    --                    => 133
    --
    --                b)  50 * 1.2 = 60   => 60
    --                    37 * 1.2 = 44.4 => 44
    --                    24 * 1.2 = 28.8 => 28
    --                    
    --                    => 132 = 60 + 44 + 28
    --
    --      one solution is to use round instead of floor or ceil,
    --      but this can cause rounding problems too.
    --
    -- 2) add the ability directly to the baseprice before the calculation
    --    > this solves all problems and is the best solution.
    --
    -- because the game informs the player about the additional amount
    -- of gold from the knight trader, the logic needs the difference
    -- between the original price and the improved price.
    -- so passing only the improved price to the logic will kick this
    -- feature or you have to improve the logic and add a support to pass
    -- the additional amount of gold.
    --
    -- THIS IS NOT POSSIBLE, because this will affect savegames of the
    -- already send out final game.

    -- add ability of knight trading
    --local TraderAbility = Logic.GetKnightTraderAbilityModifier(PlayerID)
    --BasePrice = math.ceil(BasePrice * TraderAbility)

    local GoodsSoldToTargetPlayer = 0
    if  g_Trade.SellToPlayers[_TargetPlayerID] ~= nil
    and g_Trade.SellToPlayers[_TargetPlayerID][_GoodType] ~= nil then
        GoodsSoldToTargetPlayer = g_Trade.SellToPlayers[_TargetPlayerID][_GoodType]
    end

    local Modifier = math.ceil(BasePrice / 4)
    local MaxPriceToSubtractPerWaggon = BasePrice - Modifier

    local WaggonsToSell = math.ceil(_GoodAmount / Waggonload)
    local WaggonsSold = math.ceil(GoodsSoldToTargetPlayer / Waggonload)

    local PriceToSubtract = 0
    for i = 1, WaggonsToSell do
        PriceToSubtract = PriceToSubtract + math.min(WaggonsSold * Modifier, MaxPriceToSubtractPerWaggon)
        WaggonsSold = WaggonsSold + 1
    end

    return (WaggonsToSell * BasePrice) - PriceToSubtract

end


function GUI_Trade.GetPlayerOfferCountOfGoodType(_PlayerID, _TargetPlayerID, _GoodType)

    local StorhouseID = Logic.GetStoreHouse(_TargetPlayerID)

    local TradersInTheActiveBuilding = Logic.GetNumberOfMerchants(StorhouseID)

    -- has storehouse of player a goodtrader?
    for i = 0, TradersInTheActiveBuilding - 1 do

        if Logic.IsGoodTrader(StorhouseID, i) then

            local Offers = {Logic.GetMerchantOfferIDs(StorhouseID, i,_PlayerID)}

            for j = 1, #Offers do

                local OfferID = Offers[j]

                local OfferGoodType, GoodAmount, OfferAmount, AmountPrices = Logic.GetGoodTraderOffer(StorhouseID,OfferID,_PlayerID)

                if OfferGoodType == _GoodType then
                    local OfferCount = Logic.GetOfferCount(StorhouseID,OfferID,_PlayerID)
                    return OfferCount
                end

            end
        end
    end

    return 0

end

function GUI_Trade.SellMouseOver()
    local PlayerID = GUI.GetPlayerID()
    local ButtonIndex = tonumber(XGUIEng.GetWidgetNameByID(XGUIEng.GetWidgetsMotherID(XGUIEng.GetCurrentWidgetID())))
    local TargetPlayerID = g_Trade.TargetPlayers[ButtonIndex]
    local DiplomacyState = Diplomacy_GetRelationBetween(TargetPlayerID, PlayerID)
    local IsHumanBoolean = Logic.PlayerGetIsHumanFlag(TargetPlayerID)

    local TooltipTextKey
    local Price
    local Text

    if g_Trade.GoodAmount ~= 0 then
        local GoodName = XGUIEng.GetStringTableText("UI_ObjectNames/" .. Logic.GetGoodTypeName(g_Trade.GoodType))

        if DiplomacyState >= DiplomacyStates.TradeContact
        and IsHumanBoolean == true then
            TooltipTextKey = "TradeSend"
        else
            TooltipTextKey = "TradeSell"
        end
    else
        TooltipTextKey = "TradeNothingSelected"
    end

    if XGUIEng.IsButtonDisabled(XGUIEng.GetCurrentWidgetID()) == 0 then
        GUI_Tooltip.TooltipNormal(TooltipTextKey)

    elseif DiplomacyState < DiplomacyStates.TradeContact and g_Trade.GoodType ~= Goods.G_Gold then
        GUI_Tooltip.TooltipNormal("TradeSell", "TradeNotTradeContactYet")

    elseif DiplomacyState == DiplomacyStates.Enemy then
        GUI_Tooltip.TooltipNormal("TradeSell", "TradeHostile")

    elseif MerchantSystem.PlayerDoesNotBuyGoods[TargetPlayerID] then
        GUI_Tooltip.TooltipNormal("TradeSell", "TradeDoNotWantToBuyAtAll")

    elseif DoesTradePartnerWantTheGood(TargetPlayerID, g_Trade.GoodType) == false then
        GUI_Tooltip.TooltipNormal("TradeSell", "TradeDoNotWantThis")

    else
        GUI_Tooltip.TooltipNormal("TradeSell", "TradeDoNotWantThis")
    end
end

function GUI_Trade.GoodsMouseOver()
    local WidgetID = XGUIEng.GetCurrentWidgetID()
    local MotherID = XGUIEng.GetWidgetsMotherID(WidgetID)
    local TooltipTextKey  = XGUIEng.GetWidgetNameByID(MotherID)

    GUI_Tooltip.TooltipNormal(TooltipTextKey, "NotEnoughGoods")
end

function GUI_Trade.UpdateCityGoods()

    local PlayerID = GUI.GetPlayerID()
    local CastleID = Logic.GetHeadquarters(PlayerID)
    local StorehouseID = Logic.GetStoreHouse(PlayerID)

    if StorehouseID == 0
    or CastleID == 0 then
        return
    end

    local GoodsContainerPath = "/InGame/Root/Normal/AlignBottomRight/Selection/Storehouse/InCity/Goods"

    local GoodAmountsList =
    {
        {Goods.G_Beer,       GetAmountOfGoodsForTrading(PlayerID, Goods.G_Beer      ) },
        {Goods.G_Bread,      GetAmountOfGoodsForTrading(PlayerID, Goods.G_Bread     ) },
        {Goods.G_Broom,      GetAmountOfGoodsForTrading(PlayerID, Goods.G_Broom     ) },
        {Goods.G_Cheese,     GetAmountOfGoodsForTrading(PlayerID, Goods.G_Cheese    ) },
        {Goods.G_Clothes,    GetAmountOfGoodsForTrading(PlayerID, Goods.G_Clothes   ) },
        {Goods.G_Leather,    GetAmountOfGoodsForTrading(PlayerID, Goods.G_Leather   ) },
        {Goods.G_Medicine,   GetAmountOfGoodsForTrading(PlayerID, Goods.G_Medicine  ) },
        --{Goods.G_PoorBow,    GetAmountOfGoodsForTrading(PlayerID, Goods.G_PoorBow   ) },
        --{Goods.G_PoorSword,  GetAmountOfGoodsForTrading(PlayerID, Goods.G_PoorSword ) },
        {Goods.G_Sausage,    GetAmountOfGoodsForTrading(PlayerID, Goods.G_Sausage   ) },
        {Goods.G_SmokedFish, GetAmountOfGoodsForTrading(PlayerID, Goods.G_SmokedFish) },
        {Goods.G_Soap,       GetAmountOfGoodsForTrading(PlayerID, Goods.G_Soap      ) },
    }

    for i = 1, #GoodAmountsList do
        local GoodName = Logic.GetGoodTypeName(GoodAmountsList[i][1])
        local GoodAmountWidget = GoodsContainerPath .. "/" .. GoodName .. "/Amount"
        XGUIEng.SetText(GoodAmountWidget, "{center}" .. GoodAmountsList[i][2])
    end
end

-- These city goods have another container path so they have their own update function too
function GUI_Trade.UpdateInMultiGoods()
    --GUI.AddNote( "UpdateInMultiGoods" )
    local PlayerID = GUI.GetPlayerID()
    local CastleID = Logic.GetHeadquarters(PlayerID)
    local StorehouseID = Logic.GetStoreHouse(PlayerID)

    if StorehouseID == 0 or CastleID == 0 then
        return
    end

    local GoodsContainerPath = "/InGame/Root/Normal/AlignBottomRight/Selection/Storehouse/InMulti/Goods"

    local GoodAmountsList =
    {
        {Goods.G_PoorBow,    GetAmountOfGoodsForTrading(PlayerID, Goods.G_PoorBow   ) },
        {Goods.G_PoorSword,  GetAmountOfGoodsForTrading(PlayerID, Goods.G_PoorSword ) },
        {Goods.G_PoorSpear,  GetAmountOfGoodsForTrading(PlayerID, Goods.G_PoorSpear ) },
        {Goods.G_SiegeEnginePart,  GetAmountOfGoodsForTrading(PlayerID, Goods.G_SiegeEnginePart ) },
    }

    for i = 1, #GoodAmountsList do
        local GoodName = Logic.GetGoodTypeName(GoodAmountsList[i][1])
        local GoodAmountWidget = GoodsContainerPath .. "/" .. GoodName .. "/Amount"
        XGUIEng.SetText(GoodAmountWidget, "{center}" .. GoodAmountsList[i][2])
    end
end

function GUI_Trade.UpdatePlayers()
    local PlayerID = GUI.GetPlayerID()
    local Index = 1
    local PlayerButtonsPath = "/InGame/Root/Normal/AlignBottomRight/SalesDialog/"
    local TraderAbility = Logic.GetKnightTraderAbilityModifier(PlayerID)

    for TargetPlayerID = 1, 8 do

        local Storehouse = Logic.GetStoreHouse(TargetPlayerID)
        local Marketplace = Logic.GetMarketplace(TargetPlayerID)
        local Discovered = g_DiscoveredPlayers[TargetPlayerID]

        if TargetPlayerID ~= PlayerID
        and Storehouse ~= 0
        and Marketplace ~= 0
        and Logic.IsEntityInCategory(Storehouse, EntityCategories.BanditsCamp) == 0
        and Discovered == true
        then
            local PlayerContainer = PlayerButtonsPath .. Index
            XGUIEng.ShowWidget(PlayerContainer, 1)

            local ButtonWidget = PlayerButtonsPath .. Index .. "/Sell"
            local SumWidget = PlayerButtonsPath .. Index .. "/Amount"
            local DiplomacyState = Diplomacy_GetRelationBetween(TargetPlayerID, PlayerID)

            local IsHumanBoolean = Logic.PlayerGetIsHumanFlag(TargetPlayerID)
            local r, g, b = GUI.GetPlayerColor(TargetPlayerID)

            XGUIEng.SetMaterialColor(ButtonWidget, 6, r, g, b, 255)

            local Relation = Diplomacy_GetRelationBetween(PlayerID, TargetPlayerID)

            local DiplomacyStateName = GetNameOfDiplomacyState(Relation)

            XGUIEng.SetText(PlayerButtonsPath .. Index .. "/State", DiplomacyStateName)
            local Name = GetPlayerName(TargetPlayerID)

            if Name == "" then
                Name = "Player " .. TargetPlayerID .. "has no name"
            end

            XGUIEng.SetText(PlayerButtonsPath .. Index .. "/PlayerName", Name)

            if DiplomacyState >= DiplomacyStates.TradeContact then

                if MerchantSystem.PlayerDoesNotBuyGoods[TargetPlayerID] then
                    XGUIEng.DisableButton(ButtonWidget, 1)

                else

                    if DoesTradePartnerWantTheGood(TargetPlayerID, g_Trade.GoodType) then

                        if g_Trade.GoodAmount == nil
                        or g_Trade.GoodAmount == 0 then
                            XGUIEng.SetText(SumWidget, "{center}-")
                        else
                            local Price = GUI_Trade.ComputeSellingPrice(TargetPlayerID, g_Trade.GoodType, g_Trade.GoodAmount)

                            -- add ability of knight trading
                            Price = math.ceil(Price * TraderAbility) -- must be floor (floor is used in logic)

                            XGUIEng.SetText(SumWidget, "{center}" .. Price)
                        end

                        XGUIEng.DisableButton(ButtonWidget, 0)
                    else
                        XGUIEng.SetText(SumWidget, "{center}-")
                        XGUIEng.DisableButton(ButtonWidget, 1)
                    end
                end

                if IsHumanBoolean then
                    SetIcon(ButtonWidget, {5, 8})
                    local Text = XGUIEng.GetStringTableText("UI_Texts/TradeNotActive_center")
                    XGUIEng.SetText(SumWidget, Text)
                else
                    SetIcon(ButtonWidget, {1, 8})
                end

            else

                SetIcon(ButtonWidget, {11, 7}) -- "disabled" icon, black and white; special case
                XGUIEng.SetText(SumWidget, "{center}-")
                XGUIEng.DisableButton(ButtonWidget, 1)

            end

            g_Trade.TargetPlayers[Index] = TargetPlayerID
            Index = Index + 1
        end
    end

    -- adjust size of the sales window depending on the number of players
    local SalesBottomPositionX
    local SalesBottomPositionY
    SalesBottomPositionX, SalesBottomPositionY = XGUIEng.GetWidgetLocalPosition("/InGame/Root/Normal/AlignBottomRight/AnchorForSales")

    local NewPositionY = SalesBottomPositionY + 65* (7-Index+1)
    XGUIEng.SetWidgetLocalPosition( "/InGame/Root/Normal/AlignBottomRight/SalesDialog",
                                    SalesBottomPositionX,
                                    NewPositionY
                                    )


    -- hide unnecessary buttons
    for i = Index, 7 do
        g_Trade.TargetPlayers[i] = nil
        local PlayerContainer = PlayerButtonsPath .. i
        XGUIEng.ShowWidget(PlayerContainer, 0)
    end


    if Index == 1 then --no players discover yet
        XGUIEng.ShowWidget(PlayerButtonsPath .. "0", 1)

        local NewPositionY = SalesBottomPositionY + 65* 6
        XGUIEng.SetWidgetLocalPosition( "/InGame/Root/Normal/AlignBottomRight/SalesDialog",
                                        SalesBottomPositionX,
                                        NewPositionY
                                        )
    else
       XGUIEng.ShowWidget(PlayerButtonsPath .. "0", 0)
    end

end


function DoesTradePartnerWantTheGood( _PlayerID, _GoodType )

    local PlayerCategory = GetPlayerCategoryType( _PlayerID )
    local GoodCategory = Logic.GetGoodCategoryForGoodType( _GoodType )

    -- do NOT ALLOW, if it is gold and NOT human player
    if  _GoodType == Goods.G_Gold
    and Logic.PlayerGetIsHumanFlag(_PlayerID) ~= true then
        return false
    end

    -- do NOT ALLOW, if in blacklist (set by the map, or when player offers this type of good
    if IsGoodInTradeBlackList( _PlayerID, _GoodType ) then
        return false
    end

    -- do ALLOW, if it is a resource
    if GoodCategory == GoodCategories.GC_Resource then
        return true
    end

    -- do ALLOW all goods, if it is a city
    if PlayerCategory == PlayerCategories.City then
        return true
    end

    --do ALLOW goods for villages and cloisters, if it food, clothes or medicine
    if PlayerCategory == PlayerCategories.Village
    or PlayerCategory == PlayerCategories.Cloister then
        if GoodCategory == GoodCategories.GC_Food
        or GoodCategory == GoodCategories.GC_Clothes
        or GoodCategory == GoodCategories.GC_Medicine
        or _GoodType == Goods.G_Beer then
            return true
        end
    end

    return false
end


function IsGoodInTradeBlackList( _PlayerID, _GoodType )
    for i=1, MerchantSystem.TradeBlackList[_PlayerID][0] do
        local GoodTypeInList = MerchantSystem.TradeBlackList[_PlayerID][i]
        if GoodTypeInList == _GoodType then
            return true
        end
    end
    return false
end


function GetAmountOfGoodsForTrading(_PlayerID, _GoodType)
    return GetPlayerGoodsInSettlement(_GoodType, _PlayerID, true)
end

--function GetAmountOfGoodsForTrading(_PlayerID, _GoodType)
--    local  InSettlement = GetPlayerGoodsInSettlement(_GoodType, _PlayerID, true)
--    local  ToBeGathered = Logic.GetAmountOfGoodsToBeGatheredByTradeGatherers(_PlayerID, _GoodType)
--    return math.max(0, InSettlement - ToBeGathered)
--end
