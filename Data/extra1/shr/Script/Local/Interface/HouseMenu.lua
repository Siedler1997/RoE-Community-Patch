---------------------------------------------------------------------------------------------------
HouseMenu = {}
HouseMenu.Widget = {}
HouseMenu.Widget.CurrentTab = 2
HouseMenu.Widget.Dialog = "/InGame/Root/Normal/AlignBottomRight/HouseMenu/Dialog"
HouseMenu.Widget.OuterRim = "/InGame/Root/Normal/AlignBottomRight/HouseMenu/Dialog/OuterRim"
HouseMenu.Widget.City = "/InGame/Root/Normal/AlignBottomRight/HouseMenu/Dialog/City"
HouseMenu.Widget.Special = "/InGame/Root/Normal/AlignBottomRight/HouseMenu/Dialog/Special"
HouseMenu.Widget.CurrentStop = "/InGame/Root/Normal/AlignBottomRight/HouseMenu/Dialog/CurrentBuilding/Stop"
HouseMenu.Widget.CurrentBuilding = nil
HouseMenu.Widget.CurrentBuildingNumber = 0
HouseMenu.Counter = 0

HouseMenu.StopConsumptionBool = false
HouseMenu.StopProductionBool = false

function ToggleHouseMenu()
    Sound.FXPlay2DSound( "ui\\menu_click")

    if XGUIEng.IsWidgetShown( HouseMenu.Widget.Dialog ) == 0 then

        HouseMenu.Widget.CurrentBuilding = nil
        HouseMenuSetIcons(true)

        HideOtherMenus()
        XGUIEng.ShowWidget(HouseMenu.Widget.Dialog,1)
    else
        XGUIEng.ShowWidget(HouseMenu.Widget.Dialog,0)
    end
end


function HouseMenuSetIcons(_HighlightBool)

    if HouseMenu.Widget.CurrentTab == 1 then
        HouseMenuSetIconsPart(HouseMenu.Widget.OuterRim, _HighlightBool)
    elseif HouseMenu.Widget.CurrentTab == 2 then
        HouseMenuSetIconsPart(HouseMenu.Widget.City, _HighlightBool)
    elseif HouseMenu.Widget.CurrentTab == 3 then
        HouseMenuSetIconsPart(HouseMenu.Widget.Special, _HighlightBool)
    end

    HouseMenuUpdateCurrentBuildingIcon()
end


function HouseMenuSetIconsPart(_Part, _HighlightBool)

    local HouseMenuButtons = {XGUIEng.ListSubWidgets(_Part)}
    local WidgetName
    local Buildings = {Logic.GetBuildingsByPlayer(GUI.GetPlayerID())}
    local i

    for i = 1, #HouseMenuButtons do
        WidgetName = XGUIEng.GetWidgetNameByID(HouseMenuButtons[i])

        local WidgetPosEntry = Entities[WidgetName]
        local Button = _Part .. "/" .. WidgetName .. "/Button"

        SetIcon(Button, g_TexturePositions.Entities[WidgetPosEntry])

        local Count = 0

        for i = 1, #Buildings do
            local EntityType = Logic.GetEntityType(Buildings[i])
            local EntityName = Logic.GetEntityTypeName(EntityType)
            local ClimateWidgetName = GetClimateEntityName(WidgetName)

            if EntityName == ClimateWidgetName then
                Count = Count + 1
            end
        end

        if Count == 0 then
            XGUIEng.DisableButton(Button, 1)
        else
            XGUIEng.DisableButton(Button, 0)
        end

        local Amount = _Part .. "/" .. WidgetName .. "/Amount"

        XGUIEng.SetText(Amount, "{center}" .. Count)

        local StopWidget = _Part .. "/" .. WidgetName .. "/Stop"
        UpdateStopOverlay(StopWidget, WidgetName, Count)

        -- display overlay icon of current building
        if WidgetName == HouseMenu.Widget.CurrentBuilding then
            UpdateStopOverlay(HouseMenu.Widget.CurrentStop, HouseMenu.Widget.CurrentBuilding, Count)
        end
    end

    HouseMenu.Counter = HouseMenu.Counter + 1

    if _HighlightBool == true
    or math.mod(HouseMenu.Counter, 20) == 0 then

        for j = 1, #HouseMenuButtons do
            local WidgetNameHighlighted = XGUIEng.GetWidgetNameByID(HouseMenuButtons[j])

            local ButtonHighlighted = _Part .. "/" .. WidgetNameHighlighted .. "/Button"

            WidgetNameHighlighted = GetClimateEntityName(WidgetNameHighlighted)

            if WidgetNameHighlighted == HouseMenu.Widget.CurrentBuilding then
                XGUIEng.HighLightButton(ButtonHighlighted, 1)
            else
                XGUIEng.HighLightButton(ButtonHighlighted, 0)
            end
        end
    end
end

 -- display overlay icons
function UpdateStopOverlay(_StopWidget, _Name, _Count)

    if XGUIEng.IsWidgetExisting(_StopWidget) == 0 then
        return
    end

    if _Count > 0 then
        local PlayerID = GUI.GetPlayerID()
        local EntityType = Entities[_Name]

        -- yellow overlay
        local GoodType = Logic.GetProductOfBuildingType(EntityType)
        if Logic.IsGoodLocked(PlayerID, GoodType) then
            SetIcon(_StopWidget, {16,9})
            XGUIEng.ShowWidget(_StopWidget, 1)
            return
        end

        -- red overlay
        local N, OneBuildingOfThisType = Logic.GetPlayerEntities(PlayerID, EntityType, 1, 0) -- we need only one as they should all be stopped
        if Logic.IsBuildingStopped(OneBuildingOfThisType) then
            SetIcon(_StopWidget, {14,4})
            XGUIEng.ShowWidget(_StopWidget, 1)
            return
        end
    end

    -- fallback to disable overlay icons
    XGUIEng.ShowWidget(_StopWidget, 0)
end

---------------------------------------------------------------------------------------------------

--function HouseMenuGoToBuilding()
--
--    local index = XGUIEng.ListBoxGetSelectedIndex(OverviewMap.Widget.Buildings)
--
--    if index +1 > #OverviewMap.Buildings then
--        return
--    end
--
--    local entity = OverviewMap.Buildings[index +1]
--    local x,y = Logic.GetEntityPosition(entity)
--    GUI.SelectEntity(entity)
--    CloseOverviewMap()
--    Camera.RTS_SetLookAtPosition(x,y)
--
--end

---------------------------------------------------------------------------------------------------

function GetClimateEntityName(_WidgetName)
    if _WidgetName == "B_Castle_ME" then
        _WidgetName = Logic.GetEntityTypeName(GetEntityTypeForClimatezone("B_Castle"))
    elseif _WidgetName == "B_Outpost_ME" then
        _WidgetName = Logic.GetEntityTypeName(GetEntityTypeForClimatezone("B_Outpost"))
    end

    return _WidgetName
end


--function HouseMenuWidgetStandardName( _WidgetName )
--    if _WidgetName == "B_Castle_NE"
--    or _WidgetName == "B_Castle_SE"
--    or _WidgetName == "B_Castle_NA" then
--        _WidgetName = "B_Castle_ME"
--    end
--
--    if _WidgetName == "B_Outpost_NE"
--    or _WidgetName == "B_Outpost_SE"
--    or _WidgetName == "B_Outpost_NA" then
--        _WidgetName = "B_Outpost_ME"
--    end
--
--    return _WidgetName
--end


function HouseMenuGetNextBuildingID(WidgetName)

    WidgetName = GetClimateEntityName(WidgetName)

    local Buildings = { Logic.GetBuildingsByPlayer(GUI.GetPlayerID()) }
    local i

    if HouseMenu.Widget.CurrentBuilding ~= WidgetName then
        HouseMenu.Widget.CurrentBuilding = WidgetName
        HouseMenu.Widget.CurrentBuildingNumber = 0
    end

    local FoundNumber = 0
    local HigherBuildingFound = false

    for i = 1, #Buildings do
        local EntityType = Logic.GetEntityType(Buildings[i])
        local EntityName = Logic.GetEntityTypeName(EntityType)

        if EntityName == WidgetName then
            FoundNumber = i

            if FoundNumber > HouseMenu.Widget.CurrentBuildingNumber then
                HouseMenu.Widget.CurrentBuildingNumber = FoundNumber
                HigherBuildingFound = true
                break
            end
        end
    end

    if FoundNumber == 0 then
        return nil
    end

    if not HigherBuildingFound then
        for i = 1, #Buildings do
            local EntityType = Logic.GetEntityType(Buildings[i])
            local EntityName = Logic.GetEntityTypeName(EntityType)
            if EntityName == WidgetName then
                HouseMenu.Widget.CurrentBuildingNumber = i
                break
            end
        end
    end

    return Buildings[HouseMenu.Widget.CurrentBuildingNumber]

end



function HouseMenuCountBuildings(WidgetName)

    local Buildings = { Logic.GetBuildingsByPlayer(GUI.GetPlayerID()) }
    local i

    local FoundNumber = 0
    local HigherBuildingFound = false

    for i = 1, #Buildings do
        local EntityType = Logic.GetEntityType(Buildings[i])
    local EntityName = Logic.GetEntityTypeName(EntityType)
        if EntityName == WidgetName then
            FoundNumber = FoundNumber + 1
        end
    end

    return FoundNumber

end


---------------------------------------------------------------------------------------------------

function HouseMenuStopProductionClicked()
    local PlayerID = GUI.GetPlayerID()
    local WidgetName = HouseMenu.Widget.CurrentBuilding
    local EntityType = Entities[WidgetName]
    local BuildingsOfThisType = GetPlayerEntities(PlayerID, EntityType)

    for i = 1, #BuildingsOfThisType do
        GUI.SetStoppedState(BuildingsOfThisType[i], HouseMenu.StopProductionBool)
    end

    if not HouseMenu.StopConsumptionBool then
        local PlayerID = GUI.GetPlayerID()
        local WidgetName = HouseMenu.Widget.CurrentBuilding
        local EntityType = Entities[WidgetName]
        local GoodType = Logic.GetProductOfBuildingType(EntityType)
        GUI.SetGoodLockState(GoodType, HouseMenu.StopConsumptionBool)
    end
end


function HouseMenuStopProductionMouseOver()
    local TooltipTextKey

    if HouseMenu.StopConsumptionBool == nil
    or HouseMenu.StopProductionBool == true then
        TooltipTextKey = "BuildingsMenuStopProduction"
    else
        TooltipTextKey = "BuildingsMenuResumeProduction"
    end

    local TooltipDisabledTextKey

    if HouseMenu.Widget.CurrentBuilding ~= nil then
        TooltipDisabledTextKey = "BuildingsMenuNotPossible"
    else
        TooltipDisabledTextKey = "BuildingsMenuNothingSelected"
    end

    GUI_Tooltip.TooltipNormal(TooltipTextKey, TooltipDisabledTextKey)
end


function HouseMenuStopProductionUpdate()
    local CurrentWidgetID = XGUIEng.GetCurrentWidgetID()

    if HouseMenu.Widget.CurrentBuilding == nil
    or HouseMenu.Widget.CurrentBuilding == "B_Castle_ME"
    or HouseMenu.Widget.CurrentBuilding == "B_Castle_NE"
    or HouseMenu.Widget.CurrentBuilding == "B_Castle_SE"
    or HouseMenu.Widget.CurrentBuilding == "B_Castle_NA"
    or HouseMenu.Widget.CurrentBuilding == "B_Cathedral"
    or HouseMenu.Widget.CurrentBuilding == "B_Outpost_ME"
    or HouseMenu.Widget.CurrentBuilding == "B_Outpost_NE"
    or HouseMenu.Widget.CurrentBuilding == "B_Outpost_SE"
    or HouseMenu.Widget.CurrentBuilding == "B_Outpost_NA"
    or HouseMenu.Widget.CurrentBuilding == "B_StoreHouse"
    or HouseMenu.Widget.CurrentBuilding == "B_Castle_AS"
    or HouseMenu.Widget.CurrentBuilding == "B_Outpost_AS"
    or HouseMenu.Widget.CurrentBuilding == "B_TradePost"
    or HouseMenu.Widget.CurrentBuilding == "B_Cathedral_Big" then
        XGUIEng.DisableButton(CurrentWidgetID, 1)
        return
    else
        XGUIEng.DisableButton(CurrentWidgetID, 0)
    end

    -- check whether to stop or to start
    local PlayerID = GUI.GetPlayerID()
    local WidgetName = HouseMenu.Widget.CurrentBuilding
    local EntityType = Entities[WidgetName]

    local BuildingsOfThisType = GetPlayerEntities(PlayerID, EntityType)
    local NumberOfStopped = 0
    local NumberOfWorking = 0

    for i = 1, #BuildingsOfThisType do
        local IsStopped = Logic.IsBuildingStopped(BuildingsOfThisType[i])

        if IsStopped == true then
            NumberOfStopped = NumberOfStopped + 1
        else
            NumberOfWorking = NumberOfWorking + 1
        end
    end

    if NumberOfStopped <= NumberOfWorking then
        SetIcon(CurrentWidgetID, {4, 13})
        HouseMenu.StopProductionBool = true
    else
        SetIcon(CurrentWidgetID, {4, 12})
        HouseMenu.StopProductionBool = false
    end
end




function HouseMenuStopConsumptionClicked()
    local PlayerID = GUI.GetPlayerID()
    local WidgetName = HouseMenu.Widget.CurrentBuilding
    local EntityType = Entities[WidgetName]
    local GoodType = Logic.GetProductOfBuildingType(EntityType)
    GUI.SetGoodLockState(GoodType, HouseMenu.StopConsumptionBool)

    if not HouseMenu.StopProductionBool then
        local PlayerID = GUI.GetPlayerID()
        local WidgetName = HouseMenu.Widget.CurrentBuilding
        local EntityType = Entities[WidgetName]
        local BuildingsOfThisType = GetPlayerEntities(PlayerID, EntityType)

        for i = 1, #BuildingsOfThisType do
            GUI.SetStoppedState(BuildingsOfThisType[i], HouseMenu.StopProductionBool)
        end
    end
end

function HouseMenuStopConsumptionMouseOver()
    local TooltipTextKey

    if HouseMenu.StopConsumptionBool == nil
    or HouseMenu.StopConsumptionBool == true then
        TooltipTextKey = "BuildingsMenuStopConsumption"
    else
        TooltipTextKey = "BuildingsMenuResumeConsumption"
    end

    local TooltipDisabledTextKey

    if HouseMenu.Widget.CurrentBuilding ~= nil then
        TooltipDisabledTextKey = "BuildingsMenuNotPossible"
    else
        TooltipDisabledTextKey = "BuildingsMenuNothingSelected"
    end

    GUI_Tooltip.TooltipNormal(TooltipTextKey, TooltipDisabledTextKey)
end


function HouseMenuStopConsumptionUpdate()
    local CurrentWidgetID = XGUIEng.GetCurrentWidgetID()

    if HouseMenu.Widget.CurrentBuilding == nil
    or HouseMenu.Widget.CurrentBuilding == "B_Castle_ME"
    or HouseMenu.Widget.CurrentBuilding == "B_Castle_NE"
    or HouseMenu.Widget.CurrentBuilding == "B_Castle_SE"
    or HouseMenu.Widget.CurrentBuilding == "B_Castle_NA"
    or HouseMenu.Widget.CurrentBuilding == "B_Cathedral"
    or HouseMenu.Widget.CurrentBuilding == "B_Outpost_ME"
    or HouseMenu.Widget.CurrentBuilding == "B_Outpost_NE"
    or HouseMenu.Widget.CurrentBuilding == "B_Outpost_SE"
    or HouseMenu.Widget.CurrentBuilding == "B_Outpost_NA"
    or HouseMenu.Widget.CurrentBuilding == "B_StoreHouse"
    or HouseMenu.Widget.CurrentBuilding == "B_Barracks"
    or HouseMenu.Widget.CurrentBuilding == "B_BarracksArchers"
    or HouseMenu.Widget.CurrentBuilding == "B_SiegeEngineWorkshop"
    or HouseMenu.Widget.CurrentBuilding == "B_Castle_AS"
    or HouseMenu.Widget.CurrentBuilding == "B_Outpost_AS"
    or HouseMenu.Widget.CurrentBuilding == "B_TradePost"
    or HouseMenu.Widget.CurrentBuilding == "B_Cathedral_Big"
    or HouseMenu.Widget.CurrentBuilding == "B_BarracksSpearmen" 
    or HouseMenu.Widget.CurrentBuilding == "B_BarracksCavalry"then
        XGUIEng.DisableButton(CurrentWidgetID, 1)
        return
    else
        XGUIEng.DisableButton(CurrentWidgetID, 0)
    end

    -- check whether to stop or to start
    local PlayerID = GUI.GetPlayerID()
    local WidgetName = HouseMenu.Widget.CurrentBuilding
    local EntityType = Entities[WidgetName]
    local GoodType = Logic.GetProductOfBuildingType(EntityType)
    local IsLocked = Logic.IsGoodLocked(PlayerID, GoodType)

    if IsLocked == false then
        SetIcon(CurrentWidgetID, {15, 6})
        HouseMenu.StopConsumptionBool = true
    else
        SetIcon(CurrentWidgetID, {10, 9})
        HouseMenu.StopConsumptionBool = false
    end
end

---------------------------------------------------------------------------------------------------

function HouseMenuUpdateCurrentBuildingIcon()
    if HouseMenu.Widget.CurrentBuilding ~= nil then
        XGUIEng.ShowWidget("/InGame/Root/Normal/AlignBottomRight/HouseMenu/Dialog/CurrentBuilding", 1)

        local WidgetPosEntry = Entities[HouseMenu.Widget.CurrentBuilding]
        SetIcon("/InGame/Root/Normal/AlignBottomRight/HouseMenu/Dialog/CurrentBuilding/Icon",
                g_TexturePositions.Entities[WidgetPosEntry])

        local HouseCount =  HouseMenuCountBuildings(HouseMenu.Widget.CurrentBuilding)
        XGUIEng.SetText("/InGame/Root/Normal/AlignBottomRight/HouseMenu/Dialog/CurrentBuilding/Amount",
                        "{center}" .. HouseCount)
    else
        XGUIEng.ShowWidget("/InGame/Root/Normal/AlignBottomRight/HouseMenu/Dialog/CurrentBuilding", 0)
    end
end


function HouseMenuClicked()
    Sound.FXPlay2DSound("ui\\menu_click")

    GUI.ClearSelection()

    local CurrentWidgetID = XGUIEng.GetCurrentWidgetID()
    local MotherWidgetID = XGUIEng.GetWidgetsMotherID(CurrentWidgetID)
    local WidgetName = XGUIEng.GetWidgetNameByID(MotherWidgetID)
    local Entity = HouseMenuGetNextBuildingID(WidgetName)

    if Entity ~= nil then
        local x, y = Logic.GetEntityPosition(Entity)
        GUI.SetSelectedEntity(Entity)
        Camera.RTS_SetLookAtPosition(x, y)
    end

    HouseMenuSetIcons(true)
end


function HouseMenuMouseOver()
    local CurrentWidgetID = XGUIEng.GetCurrentWidgetID()
    local MotherWidgetID = XGUIEng.GetWidgetsMotherID(CurrentWidgetID)
    local WidgetName = XGUIEng.GetWidgetNameByID(MotherWidgetID)
    local EntityType = Entities[WidgetName]
    local EntityTypeName = Logic.GetEntityTypeName(EntityType)

    GUI_Tooltip.TooltipNormal(EntityTypeName, "BuildingsMenuNoBuildings")
end


function HouseMenuCityTabButtonClicked()

    XGUIEng.ShowAllSubWidgets("/InGame/Root/Normal/AlignBottomRight/HouseMenu/Dialog/TabButtons", 0)

    XGUIEng.ShowWidget("/InGame/Root/Normal/AlignBottomRight/HouseMenu/Dialog/TabButtons/GathererTabButtonDown", 1)
    XGUIEng.ShowWidget("/InGame/Root/Normal/AlignBottomRight/HouseMenu/Dialog/TabButtons/CityTabButtonUp", 1)

    XGUIEng.ShowWidget("/InGame/Root/Normal/AlignBottomRight/HouseMenu/Dialog/TabButtons/SpecialDown", 1)

    XGUIEng.ShowWidget("/InGame/Root/Normal/AlignBottomRight/HouseMenu/Dialog/OuterRim", 0)
    XGUIEng.ShowWidget("/InGame/Root/Normal/AlignBottomRight/HouseMenu/Dialog/City", 1)
    XGUIEng.ShowWidget("/InGame/Root/Normal/AlignBottomRight/HouseMenu/Dialog/Special", 0)

    XGUIEng.ShowWidget("/InGame/Root/Normal/AlignBottomRight/HouseMenu/Dialog/StopProduction", 1)
    XGUIEng.ShowWidget("/InGame/Root/Normal/AlignBottomRight/HouseMenu/Dialog/StopProductionBG", 1)
    XGUIEng.ShowWidget("/InGame/Root/Normal/AlignBottomRight/HouseMenu/Dialog/StopConsumption", 1)
    XGUIEng.ShowWidget("/InGame/Root/Normal/AlignBottomRight/HouseMenu/Dialog/StopConsumptionBG", 1)

    HouseMenu.Widget.CurrentTab = 2
    HouseMenu.Widget.CurrentBuilding = nil
    HouseMenuSetIcons(true)
end


function HouseMenuGathererTabButtonClicked()

    XGUIEng.ShowAllSubWidgets("/InGame/Root/Normal/AlignBottomRight/HouseMenu/Dialog/TabButtons", 0)

    XGUIEng.ShowWidget("/InGame/Root/Normal/AlignBottomRight/HouseMenu/Dialog/TabButtons/GathererTabButtonUp", 1)
    XGUIEng.ShowWidget("/InGame/Root/Normal/AlignBottomRight/HouseMenu/Dialog/TabButtons/CityTabButtonDown", 1)

    XGUIEng.ShowWidget("/InGame/Root/Normal/AlignBottomRight/HouseMenu/Dialog/TabButtons/SpecialDown", 1)

    XGUIEng.ShowWidget("/InGame/Root/Normal/AlignBottomRight/HouseMenu/Dialog/OuterRim", 1)
    XGUIEng.ShowWidget("/InGame/Root/Normal/AlignBottomRight/HouseMenu/Dialog/City", 0)
    XGUIEng.ShowWidget("/InGame/Root/Normal/AlignBottomRight/HouseMenu/Dialog/Special", 0)

    XGUIEng.ShowWidget("/InGame/Root/Normal/AlignBottomRight/HouseMenu/Dialog/StopProduction", 1)
    XGUIEng.ShowWidget("/InGame/Root/Normal/AlignBottomRight/HouseMenu/Dialog/StopProductionBG", 1)
    XGUIEng.ShowWidget("/InGame/Root/Normal/AlignBottomRight/HouseMenu/Dialog/StopConsumption", 0)
    XGUIEng.ShowWidget("/InGame/Root/Normal/AlignBottomRight/HouseMenu/Dialog/StopConsumptionBG", 0)

    HouseMenu.Widget.CurrentTab = 1
    HouseMenu.Widget.CurrentBuilding = nil
    HouseMenuSetIcons(true)
end


function HouseMenuMultiTabButtonClicked()

    XGUIEng.ShowAllSubWidgets("/InGame/Root/Normal/AlignBottomRight/HouseMenu/Dialog/TabButtons", 0)

    XGUIEng.ShowWidget("/InGame/Root/Normal/AlignBottomRight/HouseMenu/Dialog/TabButtons/GathererTabButtonDown", 1)
    XGUIEng.ShowWidget("/InGame/Root/Normal/AlignBottomRight/HouseMenu/Dialog/TabButtons/CityTabButtonDown", 1)

    XGUIEng.ShowWidget("/InGame/Root/Normal/AlignBottomRight/HouseMenu/Dialog/TabButtons/SpecialUp", 1)

    XGUIEng.ShowWidget("/InGame/Root/Normal/AlignBottomRight/HouseMenu/Dialog/OuterRim", 0)
    XGUIEng.ShowWidget("/InGame/Root/Normal/AlignBottomRight/HouseMenu/Dialog/City", 0)
    XGUIEng.ShowWidget("/InGame/Root/Normal/AlignBottomRight/HouseMenu/Dialog/Special", 1)

    XGUIEng.ShowWidget("/InGame/Root/Normal/AlignBottomRight/HouseMenu/Dialog/StopProduction", 1)
    XGUIEng.ShowWidget("/InGame/Root/Normal/AlignBottomRight/HouseMenu/Dialog/StopProductionBG", 1)
    XGUIEng.ShowWidget("/InGame/Root/Normal/AlignBottomRight/HouseMenu/Dialog/StopConsumption", 1)
    XGUIEng.ShowWidget("/InGame/Root/Normal/AlignBottomRight/HouseMenu/Dialog/StopConsumptionBG", 1)

    HouseMenu.Widget.CurrentTab = 3
    HouseMenu.Widget.CurrentBuilding = nil
    HouseMenuSetIcons(true)
end



