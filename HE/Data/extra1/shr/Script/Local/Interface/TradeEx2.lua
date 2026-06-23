
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

-----------------------------------------------------------------------------------------
-- Overwrites for Trade
-----------------------------------------------------------------------------------------

function InitOverwriteTradeEx2()

    do
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
    end

    do
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
    end

end