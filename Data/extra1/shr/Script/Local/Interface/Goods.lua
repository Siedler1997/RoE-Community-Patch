--------------------------------------------------------------------------
--        *****************Goods *****************
--------------------------------------------------------------------------

GUI_Goods = {}
g_Goods = {}

GUI_Goods.MenuTechs = {
    "BGBreak1",
    nil,
    "Nutrition",
    Technologies.R_Nutrition,
    "Clothes",
    Technologies.R_Clothes,
    "Cleanliness",
    Technologies.R_Hygiene,
    "Entertainment",
    Technologies.R_Entertainment,
    "BGBreak2",
    nil,
    "Decoration",
    Technologies.R_Wealth,
    "Prosperity",
    Technologies.R_Prosperity,
    "BGBreak3",
    nil,
    "Military",
    Technologies.R_Military,
    "BGBreak4",
    nil,
    }
    
--These buildings can't get prosperity so we substract them from CityNumber in GUI_Goods.ProsperityUpdate()
GUI_Goods.ExceptionBuildingTypes = {
        Entities.B_Barracks,
        Entities.B_BarracksArchers,
        Entities.B_SiegeEngineWorkshop,
        Entities.B_Barracks_RedPrince,
        Entities.B_BarracksArchers_Redprince,
        Entities.B_Barracks_Khana,
        Entities.B_BarracksArchers_Khana,
        Entities.B_BarracksSpearmen,
        Entities.B_BarracksCavalry
}

function GUI_Goods.MenusUpdate()

    local PlayerID = GUI.GetPlayerID()

    -- local MotherContainerPath = XGUIEng.GetWidgetPathByID(XGUIEng.GetWidgetsMotherID(XGUIEng.GetCurrentWidgetID()))

    local MotherContainerPath = "/InGame/Root/Normal/AlignTopLeft/TopBar"

    if CameraAnimation.IsRunning() then
        XGUIEng.ShowAllSubWidgets(MotherContainerPath, 0)-- except :
        XGUIEng.ShowWidget(MotherContainerPath .. "/UpdateFunction", 1)

        return
    else
        XGUIEng.ShowWidget(MotherContainerPath .. "/BGBreak0", 1)
        XGUIEng.ShowWidget(MotherContainerPath .. "/CityInfo", 1)
        XGUIEng.ShowWidget(MotherContainerPath .. "/G_Gold", 1)
        XGUIEng.ShowWidget(MotherContainerPath .. "/G_Stone", 1)
        XGUIEng.ShowWidget(MotherContainerPath .. "/G_Wood", 1)

        XGUIEng.ShowWidget(MotherContainerPath .. "/Windows", 1)
        XGUIEng.ShowWidget(MotherContainerPath .. "/Buffs", 1)
        XGUIEng.ShowWidget(MotherContainerPath .. "/CityMessages", 1)
        XGUIEng.ShowWidget(MotherContainerPath .. "/GoldMessages", 1)
    end

    -- create global table of relative positions of window containers to bar containers
    if g_Goods.MenuPositions == nil then
        g_Goods.MenuPositions = {}

        for i = 1, #GUI_Goods.MenuTechs, 2 do
            -- ignore BGBreaks
            if GUI_Goods.MenuTechs[i+1] ~= nil then
                local BarContainer = MotherContainerPath .. "/" .. GUI_Goods.MenuTechs[i]
                local WindowContainer = MotherContainerPath .. "/Windows/" .. GUI_Goods.MenuTechs[i]

                if GUI_Goods.MenuTechs[i] == "G_Gold" then
                    WindowContainer = MotherContainerPath .. "/Windows/Gold"
                elseif GUI_Goods.MenuTechs[i] == "G_Stone"
                or GUI_Goods.MenuTechs[i] == "G_Wood" then
                    WindowContainer = MotherContainerPath .. "/Windows/Resources"
                end

                local BarX, BarY = XGUIEng.GetWidgetLocalPosition(BarContainer)
                local WindowX, WindowY = XGUIEng.GetWidgetLocalPosition(WindowContainer)
                g_Goods.MenuPositions[GUI_Goods.MenuTechs[i] .. "Window"] = WindowX - BarX
            end
        end
    end

    local LastMenu
    -- MenuX is the starting point
    local MenuX = XGUIEng.GetWidgetLocalPosition(MotherContainerPath .. "/G_Wood") + XGUIEng.GetWidgetSize(MotherContainerPath .. "/G_Wood")
    local ShowBGBreak = true

    for i = 1, #GUI_Goods.MenuTechs, 2 do
        local BarContainer = MotherContainerPath .. "/" .. GUI_Goods.MenuTechs[i]
        --local BuffsContainer = MotherContainerPath .. "/Buffs/" .. GUI_Goods.MenuTechs[i]
        local WindowContainer = MotherContainerPath .. "/Windows/" .. GUI_Goods.MenuTechs[i]
        local Tech = GUI_Goods.MenuTechs[i+1]
        local IsResearched = 0

        if EnableRights == nil
        or EnableRights == false
        or Logic.TechnologyGetState(PlayerID,Tech) == TechnologyStates.Researched
        or (Tech == nil
        and ShowBGBreak == true) then
            IsResearched = 1
            LastMenu = BarContainer

            -- set bar container to MenuX
            XGUIEng.SetWidgetLocalPosition(BarContainer, MenuX, 0)

            -- set buffs too (since they are in a different container now)
            --if XGUIEng.IsWidgetExisting(BuffsContainer) == 1 then --note : not a buffscontainer for each barcontainer
            --    XGUIEng.SetWidgetLocalPosition(BuffsContainer, MenuX, 0)
            --end

            -- set window container to MenuX - relative position of window container to bar container; not for BGBreaks
            if Tech ~= nil then
                XGUIEng.SetWidgetLocalPosition(WindowContainer, MenuX + g_Goods.MenuPositions[GUI_Goods.MenuTechs[i] .. "Window"], 0)
                -- show a break
                ShowBGBreak = true
            else
                -- don't show 2 breaks consecutively
                ShowBGBreak = false
            end

            -- increase MenuX by width of bar container; -1 to prevent texture gap bug
            MenuX = MenuX + XGUIEng.GetWidgetSize(BarContainer) - 1
        end

        XGUIEng.ShowWidget(BarContainer, IsResearched)
        --if XGUIEng.IsWidgetExisting(BuffsContainer) == 1 then --note : not a buffscontainer for each barcontainer
        --    XGUIEng.ShowWidget(BuffsContainer, IsResearched)
        --end

    end

    -- replace last BGBreak in the row (with shadow) with BGBreak4 (without shadow)
    XGUIEng.ShowWidget(LastMenu, 0)
    local EndX = XGUIEng.GetWidgetLocalPosition(LastMenu)
    XGUIEng.ShowWidget(MotherContainerPath .. "/BGBreak4", 1)
    XGUIEng.SetWidgetLocalPosition(MotherContainerPath .. "/BGBreak4", EndX, 0)
end


function GUI_Goods.NeedButtonMouseOver(_TechnologyType)
    local CurrentWidgetID = XGUIEng.GetCurrentWidgetID()
    local MotherContainerID = XGUIEng.GetWidgetsMotherID(CurrentWidgetID)
    local MotherContainerName = XGUIEng.GetWidgetNameByID(MotherContainerID)
    local TooltipTextKey = MotherContainerName .. "Tooltip"

    --GUI_Tooltip.TooltipNormal(TooltipTextKey, nil ,_TechnologyType)
    GUI_Tooltip.TooltipTechnology(_TechnologyType, TooltipTextKey)
end


function GUI_Goods.NeedButtonUpdate(_GoodCategory)
    local CurrentWidgetID = XGUIEng.GetCurrentWidgetID()
    local MotherContainerPath = XGUIEng.GetWidgetPathByID(XGUIEng.GetWidgetsMotherID(CurrentWidgetID))
    local CriticalPath = MotherContainerPath .. "/Critical"
    local GoodAmount = XGUIEng.GetText(MotherContainerPath .. "/Amount")

    -- only if amount is 0, check if settlers idle because of it
    -- check if good is in g_Goods.MissingNeeds table
    if GoodAmount == 0
    and g_Goods.MissingNeeds ~= nil
    and g_Goods.MissingNeeds[_GoodCategory] ~= nil
    and g_Goods.MissingNeeds[_GoodCategory] > 4 then
        -- check if any building has this need; if not, then don't color it red and set g_Goods.MissingNeeds[_GoodCategory] to 0
        local Buildings = {Logic.GetPlayerEntitiesInCategory(GUI.GetPlayerID(), EntityCategories.CityBuilding)}
        local IsNeedActiveBoolean = false

        if _GoodCategory == GoodCategories.GC_Food then
            local OuterRimBuildings = {Logic.GetPlayerEntitiesInCategory(GUI.GetPlayerID(), EntityCategories.OuterRimBuilding)}

            for i = 1, #OuterRimBuildings do
                table.insert(Buildings, OuterRimBuildings[i])
            end
        end

        local Need

        if _GoodCategory == GoodCategories.GC_Food then
            Need = Needs.Nutrition
        elseif _GoodCategory == GoodCategories.GC_Hygiene then
            Need = Needs.Hygiene
        elseif _GoodCategory == GoodCategories.GC_Clothes then
            Need = Needs.Clothes
        elseif _GoodCategory == GoodCategories.GC_Entertainment then
            Need = Needs.Entertainment
        end

        for i = 1, #Buildings do
            if Logic.IsNeedActive(Buildings[i], Need) == true then
                IsNeedActiveBoolean = true
            end
        end

        if IsNeedActiveBoolean == true then
            XGUIEng.ShowWidget(CriticalPath, 1)
        else
            if g_Goods.MissingNeeds ~= nil
            and g_Goods.MissingNeeds[_GoodCategory] ~= nil then
                g_Goods.MissingNeeds[_GoodCategory] = 0
            end
        end
    else
        if g_Goods.MissingNeeds ~= nil
        and g_Goods.MissingNeeds[_GoodCategory] ~= nil
        and g_Goods.MissingNeeds[_GoodCategory] > 4 then
            g_Goods.MissingNeeds[_GoodCategory] = 0
        end

        XGUIEng.ShowWidget(CriticalPath, 0)
    end
end


-- if the technology is unlocked, but the need is not yet unlocked, display the NextTitle icon
function GUI_Goods.NeedButtonCheckNeed(_Need)
    local PlayerID = GUI.GetPlayerID()
    local CurrentWidgetID = XGUIEng.GetCurrentWidgetID()
    local MotherContainerPath = XGUIEng.GetWidgetPathByID(XGUIEng.GetWidgetsMotherID(CurrentWidgetID))
    local Appendix = "Need"

    if _Need == Needs.Wealth
    or _Need == Needs.Prosperity then
        Appendix = "Wish"
    end

    local NextTitleIcon = MotherContainerPath .. "/NextTitle" .. Appendix
    local NextTitleIconBG = NextTitleIcon .. "BG"

    local NextTitle = Logic.GetKnightTitle(PlayerID) + 1

    if PlayerActiveNeeds[PlayerID][_Need] == true then
        --XGUIEng.SetMaterialColor(CurrentWidgetID, 7, 255, 255, 255, 255)
        XGUIEng.ShowWidget(NextTitleIcon, 0)
        XGUIEng.ShowWidget(NextTitleIconBG, 0)

    -- if this need can't be unlocked in this campaign map, don't display the NextTitle icon
    elseif IsKnightTitleLockedForPlayer(PlayerID, NextTitle) == true then
        XGUIEng.ShowWidget(NextTitleIcon, 0)
        XGUIEng.ShowWidget(NextTitleIconBG, 0)

    else
        --XGUIEng.SetMaterialColor(CurrentWidgetID, 7, 255, 255, 255, 255)

        local NextTitleName = GetNameOfKeyInTable(KnightTitles, NextTitle)
        local IconPosition = g_TexturePositions.KnightTitles[KnightTitles[NextTitleName]]
        SetIcon(NextTitleIcon, IconPosition, 44)

        XGUIEng.ShowWidget(NextTitleIcon, 1)
        XGUIEng.ShowWidget(NextTitleIconBG, 1)
    end
end


function GUI_Goods.ProsperityUpdate()
    local PlayerID = GUI.GetPlayerID()
    local CityNumber = Logic.GetNumberOfPlayerEntitiesInCategory(PlayerID, EntityCategories.CityBuilding)

    --These buildings cant get prosperity so we substract them from CityNumber
    local exceptions = 0
    for i = 1, #GUI_Goods.ExceptionBuildingTypes do
        local numberOfEntities = Logic.GetNumberOfEntitiesOfTypeOfPlayer(PlayerID, GUI_Goods.ExceptionBuildingTypes[i])
        
        CityNumber = CityNumber - numberOfEntities
    end

    local RichNumber = Logic.GetNumberOfProsperBuildings(PlayerID, 1)
    local PoorNumber = CityNumber - RichNumber

    local MotherContainerPath = XGUIEng.GetWidgetPathByID(XGUIEng.GetWidgetsMotherID(XGUIEng.GetCurrentWidgetID()))
    XGUIEng.SetText(MotherContainerPath .. "/CityBuildings/CityBuildingsNumber", "{center}" .. CityNumber)

    XGUIEng.SetText(MotherContainerPath .. "/RichAmount", "{center}" .. RichNumber)
    XGUIEng.SetText(MotherContainerPath .. "/PoorAmount", "{center}" .. PoorNumber)
end


function GUI_Goods.DecorationUpdate()
    local MotherContainerPath = XGUIEng.GetWidgetPathByID(XGUIEng.GetWidgetsMotherID(XGUIEng.GetCurrentWidgetID()))

    local CityBuildings = {Logic.GetPlayerEntitiesInCategory(GUI.GetPlayerID(), EntityCategories.CityBuilding)}
    local CityBuildingsNumber = #CityBuildings
    XGUIEng.SetText(MotherContainerPath .. "/CityBuildings/CityBuildingsNumber", "{center}" .. CityBuildingsNumber)

    local DecorationGoods = {}
    DecorationGoods.G_Sign = 0
    DecorationGoods.G_Candle = 0
    DecorationGoods.G_Ornament = 0
    DecorationGoods.G_Banner = 0

    for k, v in ipairs(CityBuildings) do
        for l, w in pairs(DecorationGoods) do
            local GoodType = Goods[l]
            local Time = Logic.GetTimeTillBuildingWealthGoodExpires(v, GoodType)
            if Time ~= 0 then
                DecorationGoods[l] = DecorationGoods[l] + 1
            end
        end
    end

    XGUIEng.SetText(MotherContainerPath .. "/G_Sign/Amount", "{center}" .. DecorationGoods.G_Sign)
    XGUIEng.SetText(MotherContainerPath .. "/G_Candle/Amount", "{center}" .. DecorationGoods.G_Candle)
    XGUIEng.SetText(MotherContainerPath .. "/G_Ornament/Amount", "{center}" .. DecorationGoods.G_Ornament)
    XGUIEng.SetText(MotherContainerPath .. "/G_Banner/Amount", "{center}" .. DecorationGoods.G_Banner)
end


function GUI_Goods.DecorationMouseOver()

    local CurrentWidgetID = XGUIEng.GetCurrentWidgetID()
    local MotherContainerID = XGUIEng.GetWidgetsMotherID(CurrentWidgetID)
    local GoodName = XGUIEng.GetWidgetNameByID(MotherContainerID)
    local TooltipTextKey = "Decoration" .. GoodName

    GUI_Tooltip.TooltipNormal(TooltipTextKey)
end


function GUI_Goods.GetNumberOfGoodsInPlayerOutstocks( _GoodCategory, _WithOutMarketplace )

    local CurrentWidgetID = XGUIEng.GetCurrentWidgetID()
    local PlayerID = GUI.GetPlayerID()

    local GoodAmount
    local GoodType

    if _GoodCategory ~= nil then
        GoodAmount = GetNumberOfGoodsOfPlayerInGoodCategory(_GoodCategory, PlayerID, _WithOutMarketplace )
    else

        local MotherContainer= XGUIEng.GetWidgetsMotherID(CurrentWidgetID)
        local GoodName = XGUIEng.GetWidgetNameByID(MotherContainer)
        GoodType = Goods[GoodName]

        GoodAmount = GetPlayerGoodsInSettlement(GoodType, PlayerID, _WithOutMarketplace)

    end

    local Color = "{@color:none}"

    if GoodAmount == 0 then
        local GrandGrandMotherContainerName = XGUIEng.GetWidgetNameByID(XGUIEng.GetWidgetsMotherID(XGUIEng.GetWidgetsMotherID(XGUIEng.GetWidgetsMotherID(XGUIEng.GetCurrentWidgetID()))))
        local TimeThreshold = Logic.GetTime() - 10

        if GrandGrandMotherContainerName == "Windows"
        and g_Goods.MissingResources ~= nil
        and g_Goods.MissingResources[GoodType] ~= nil
        and g_Goods.MissingResources[GoodType] > TimeThreshold then
            Color = "{@color:255,50,20}"
        end
    end

    local StorehouseID = Logic.GetStoreHouse(PlayerID)
    local Limit = Logic.GetMaxAmountOnStock(StorehouseID) - 8

    if  ( _GoodCategory == GoodCategories.GC_Resource
        or (GoodType ~= nil and Logic.GetGoodCategoryForGoodType(GoodType) == GoodCategories.GC_Resource) )
        and Logic.GetSumOfGoodsOnStock(StorehouseID, false) >= Limit then
        Color = "{@color:255,50,20}"
    end

    local TextOrientation = "{center}"

    XGUIEng.SetText(CurrentWidgetID, TextOrientation .. Color .. GoodAmount)

    -- check if red icon will be shown, when it is goodcategory AND goodamount 0
    if _GoodCategory ~= nil then

        local MotherContainerPath = XGUIEng.GetWidgetPathByID(XGUIEng.GetWidgetsMotherID(CurrentWidgetID))
        local CriticalPath = MotherContainerPath .. "/Critical"

        if GoodAmount == 0 then

            if  g_Goods.MissingNeeds ~= nil
            and g_Goods.MissingNeeds[_GoodCategory] ~= nil
            and g_Goods.MissingNeeds[_GoodCategory] > 4 then

                local Need

                if _GoodCategory == GoodCategories.GC_Food then
                    Need = Needs.Nutrition
                elseif _GoodCategory == GoodCategories.GC_Hygiene then
                    Need = Needs.Hygiene
                elseif _GoodCategory == GoodCategories.GC_Clothes then
                    Need = Needs.Clothes
                elseif _GoodCategory == GoodCategories.GC_Entertainment then
                    Need = Needs.Entertainment
                end

                if PlayerActiveNeeds[PlayerID][Need] == true then
                    XGUIEng.ShowWidget(CriticalPath, 1)
                end
            else
                XGUIEng.ShowWidget(CriticalPath, 0)
            end
        else
            if g_Goods.MissingNeeds ~= nil
            and g_Goods.MissingNeeds[_GoodCategory] ~= nil
            and g_Goods.MissingNeeds[_GoodCategory] > 4 then
                g_Goods.MissingNeeds[_GoodCategory] = 0
            end

            XGUIEng.ShowWidget(CriticalPath, 0)
        end
    end
end



function GUI_Goods.GetAmountsOfGoodsInPlayerOutstocks()

    if true then return end

--    local PlayerID = GUI.GetPlayerID()
--    local CastleID = Logic.GetHeadquarters(PlayerID)
--    local StorehouseID = Logic.GetStoreHouse(PlayerID)
--
--    if StorehouseID == 0
--    or CastleID == 0 then
--        return
--    end
--
--    local CurrentWidgetID = XGUIEng.GetCurrentWidgetID()
--    local MotherContainer = XGUIEng.GetWidgetsMotherID(CurrentWidgetID)
--    local MotherContainerPath = XGUIEng.GetWidgetPathByID(MotherContainer)
--
--    local WidgetList = {XGUIEng.ListSubWidgets(MotherContainer)}
--    local GoodTypeList = {}
--
--    for k, v in ipairs(WidgetList) do
--        local GoodName = XGUIEng.GetWidgetNameByID(v)
--        local GoodType = Goods[GoodName]
--
--        if GoodType ~= nil then
--            local CastleGoodIndex = Logic.GetIndexOnOutStockByGoodType(CastleID, GoodType)
--            local StorehouseGoodIndex = Logic.GetIndexOnOutStockByGoodType(StorehouseID, GoodType)
--
--            if CastleGoodIndex == -1
--            and StorehouseGoodIndex == -1 then
--                table.insert(GoodTypeList, GoodType)
--            end
--        end
--    end
--
--    local GoodAmountsList = {Logic.GetAmountsOfGoodsInPlayerOutstocks(PlayerID, GoodTypeList[1], GoodTypeList[2], GoodTypeList[3], GoodTypeList[4])}
--
--    for k, v in ipairs(GoodTypeList) do
--        local GoodName = Logic.GetGoodTypeName(v)
--        local GoodAmountWidget = MotherContainerPath .. "/" .. GoodName .. "/Amount"
--        XGUIEng.SetText(GoodAmountWidget, "{center}" .. GoodAmountsList[k*2])
--        local GoodAmountWidget2 = GoodAmountWidget .. "2"
--
--        if XGUIEng.IsWidgetExisting(GoodAmountWidget2) == 1 then
--            XGUIEng.SetText(GoodAmountWidget2, "{center}" .. GoodAmountsList[k*2])
--        end
--
--        local GoodAmountWidget3 = GoodAmountWidget .. "3"
--
--        if XGUIEng.IsWidgetExisting(GoodAmountWidget3) == 1 then
--            XGUIEng.SetText(GoodAmountWidget3, "{center}" .. GoodAmountsList[k*2])
--        end
--    end
end


function GUI_Goods.AmountUpdate(_GoodName)
    local PlayerID = GUI.GetPlayerID()
    local CastleID = Logic.GetHeadquarters(PlayerID)
    local StorehouseID = Logic.GetStoreHouse(PlayerID)

    --if StorehouseID == 0
    --or CastleID == 0 then
    --    return
    --end

    local TextOrientation = "{center}"

    local CurrentWidgetID = XGUIEng.GetCurrentWidgetID()
    local GoodType

    if _GoodName == nil then
        local MotherContainer= XGUIEng.GetWidgetsMotherID(CurrentWidgetID)
        local GoodName = XGUIEng.GetWidgetNameByID(MotherContainer)
        GoodType = Goods[GoodName]
    else

        GoodType = Goods["G_" .. _GoodName]
        TextOrientation = "{right}"
    end

    local CastleGoodIndex = Logic.GetIndexOnOutStockByGoodType(CastleID, GoodType)
    local StorehouseGoodIndex = Logic.GetIndexOnOutStockByGoodType(StorehouseID, GoodType)
    local GoodAmount = "X"

    -- color will be set to red, if GoodAmount == Storehouse Limit
    local Color = "{@color:none}"

    if CastleGoodIndex == -1
    and StorehouseGoodIndex == -1 then
        return
    else
        GoodAmount = GetPlayerGoodsInSettlement(GoodType, PlayerID )
        local Limit = Logic.GetMaxAmountOnStock(StorehouseID) - 8

        if GoodType ~= Goods.G_Gold
        and Logic.GetSumOfGoodsOnStock(StorehouseID, false) >= Limit then
            Color = "{@color:255,50,20}"
        end
    end

    -- only if amount is 0, check if settlers idle because of it
    -- check if widget is in dropdown window
    -- check if good is in g_Goods.MissingResources table
    if GoodAmount == 0 then
        local GrandGrandMotherContainerName = XGUIEng.GetWidgetNameByID(XGUIEng.GetWidgetsMotherID(XGUIEng.GetWidgetsMotherID(XGUIEng.GetWidgetsMotherID(XGUIEng.GetCurrentWidgetID()))))
        local TimeThreshold = Logic.GetTime() - 4

        if GrandGrandMotherContainerName == "Windows"
        and g_Goods.MissingResources ~= nil
        and g_Goods.MissingResources[GoodType] ~= nil
        and g_Goods.MissingResources[GoodType] > TimeThreshold then
            Color = "{@color:255,50,20}"
        end
    end

    XGUIEng.SetText(CurrentWidgetID, TextOrientation .. Color .. GoodAmount)
end

function GUI_Goods.ResourceMouseOver()
    local WidgetID = XGUIEng.GetCurrentWidgetID()
    local MotherID = XGUIEng.GetWidgetsMotherID(WidgetID)
    local TooltipTextKey  = XGUIEng.GetWidgetNameByID(MotherID)

    GUI_Tooltip.TooltipNormal(TooltipTextKey)
end

function GUI_Goods.StorageUpdate()

    local CurrentWidgetID = XGUIEng.GetCurrentWidgetID()
    local PlayerID = GUI.GetPlayerID()
    local Storehouse= Logic.GetStoreHouse(PlayerID)
    local Limit = Logic.GetMaxAmountOnStock(Storehouse)
    local GoodAmount = Logic.GetSumOfGoodsOnStock(Storehouse, false)
    local Color = "{@color:none}"

    if GoodAmount >= Limit - 8 then
        Color = "{@color:255,0,0}"
    end

    XGUIEng.SetText(CurrentWidgetID, "{center}" .. Color .. GoodAmount .. "/".. Limit )
end
