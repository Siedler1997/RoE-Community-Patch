--------------------------------------------------------------------------
--        *****************Tooltip*****************
--------------------------------------------------------------------------

GUI_Tooltip = {}


function InitTooltips()
    
    g_Tooltip = {}
    
    g_Tooltip.FadeInCurrentWidgetID = 0
    g_Tooltip.FadeInCurrentStartTime = nil
    g_Tooltip.FadeInTriggerTime = 1000
    g_Tooltip.FadeInFadingTime = 200
    
    g_Tooltip.Production = {
    [Entities.B_Bakery]                 = {Goods.G_Grain, Goods.G_Bread},
    [Entities.B_BannerMaker]            = {Goods.G_Wool, Goods.G_Banner},
    [Entities.B_Barracks]               = {Goods.G_PoorSword, Goods.G_Sword},
    [Entities.B_BarracksArchers]        = {Goods.G_PoorBow, Goods.G_Bow},
    [Entities.B_Baths]                  = {Goods.G_Water, Goods.G_EntBaths},
    [Entities.B_Blacksmith]             = {Goods.G_Iron, Goods.G_Ornament},
    [Entities.B_BowMaker]               = {Goods.G_Iron, Goods.G_PoorBow},
    [Entities.B_BroomMaker]             = {Goods.G_Wood, Goods.G_Broom},
    [Entities.B_Butcher]                = {Goods.G_Carcass, Goods.G_Sausage},
    [Entities.B_CandleMaker]            = {Goods.G_Honeycomb, Goods.G_Candle},
    [Entities.B_Carpenter]              = {Goods.G_Wood, Goods.G_Sign},
    [Entities.B_Dairy]                  = {Goods.G_Milk, Goods.G_Cheese},
    [Entities.B_Pharmacy]               = {Goods.G_Herb, Goods.G_Medicine},
    [Entities.B_SiegeEngineWorkshop]    = {Goods.G_Iron, Goods.G_SiegeEnginePart},
    [Entities.B_SmokeHouse]             = {Goods.G_RawFish, Goods.G_SmokedFish},
    [Entities.B_Soapmaker]              = {Goods.G_Carcass, Goods.G_Soap},
    [Entities.B_SwordSmith]             = {Goods.G_Iron, Goods.G_PoorSword},
    [Entities.B_Tanner]                 = {Goods.G_Carcass, Goods.G_Leather},
    [Entities.B_Tavern]                 = {Goods.G_Honeycomb, Goods.G_Beer},
    [Entities.B_Theatre]                = {Goods.G_Wool, Goods.G_EntTheatre},
    [Entities.B_Weaver]                 = {Goods.G_Wool, Goods.G_Clothes}
    }
end


function GUI_Tooltip.TooltipUpdate()
    
    --control functions for the Tooltip go here
    g_Tooltip.CursorX, g_Tooltip.CursorY = GUI.GetMousePosition()
end


function GameCallback_OnMouseOut(_WidgetID)
    --GUI.AddNote(XGUIEng.GetWidgetPathByID(_WidgetID))
    g_Tooltip.FadeInCurrentStartTime = Game.RealTimeGetMs()
end


function GUI_Tooltip.TooltipTechnology(_TechnologyType, _OptionalTextKeyName, _OptionalDisabledTextKeyName)

    local DisabledTextKeyName = GUI_Tooltip.GetDisabledKeyForTechnologyType(_TechnologyType)
    
    if DisabledTextKeyName == nil then
        DisabledTextKeyName = _OptionalDisabledTextKeyName
    end

    GUI_Tooltip.TooltipNormal(_OptionalTextKeyName, DisabledTextKeyName)
end


function GUI_Tooltip.GetDisabledKeyForTechnologyType(_TechnologyType)
    
    local NeededTitle = KnightTitleNeededForTechnology[_TechnologyType]
    
    if NeededTitle == nil then
        return
    end
    
    local PlayerID = GUI.GetPlayerID()
    local KnightID = Logic.GetKnightID(PlayerID)
    local KnightType = Logic.GetEntityType(KnightID)
    local CurrentTitle = Logic.GetKnightTitle(PlayerID)
    
    if CurrentTitle < NeededTitle then
        local DisabledTextKeyName
        local TitleName = GetNameOfKeyInTable(KnightTitles, NeededTitle)
        local KnightGender = KnightGender[KnightType]
        if KnightGender == nil then
            KnightGender = KnightGender[Entities.U_KnightChivalry]
        end
        DisabledTextKeyName = "Title_" .. TitleName .."_" .. KnightGender .. "_needed"    
        
        return DisabledTextKeyName
    end
end


function GUI_Tooltip.TooltipNormal(_OptionalTextKeyName, _OptionalDisabledTextKeyName, _OptionalMissionTextFileBoolean)

    local TooltipContainerPath = "/InGame/Root/Normal/TooltipNormal"
    local TooltipContainer = XGUIEng.GetWidgetID(TooltipContainerPath)
    local TooltipNameWidget = XGUIEng.GetWidgetID(TooltipContainerPath .. "/FadeIn/Name")
    local TooltipDescriptionWidget = XGUIEng.GetWidgetID(TooltipContainerPath .. "/FadeIn/Text")
    local TooltipBGWidget = XGUIEng.GetWidgetID(TooltipContainerPath .. "/FadeIn/BG")
    local TooltipFadeInContainer = XGUIEng.GetWidgetID(TooltipContainerPath .. "/FadeIn")
    
    local PositionWidget = XGUIEng.GetCurrentWidgetID()

    GUI_Tooltip.SetNameAndDescription(TooltipNameWidget, TooltipDescriptionWidget, _OptionalTextKeyName, _OptionalDisabledTextKeyName,
        _OptionalMissionTextFileBoolean)
    GUI_Tooltip.ResizeBG(TooltipBGWidget, TooltipDescriptionWidget)
    
    local TooltipContainerSizeWidgets = {TooltipBGWidget}
    GUI_Tooltip.SetPosition(TooltipContainer, TooltipContainerSizeWidgets, PositionWidget)

    GUI_Tooltip.FadeInTooltip(TooltipFadeInContainer)
end


function GUI_Tooltip.TooltipBuy(_Costs, _OptionalTextKeyName, _OptionalDisabledTextKeyName, _TechnologyType,
        _GoodsInSettlementBoolean, _OptionalPositionWidget, _LimitString)
    
    local TooltipContainerPath = "/InGame/Root/Normal/TooltipBuy"
    local TooltipContainer = XGUIEng.GetWidgetID(TooltipContainerPath)
    local TooltipNameWidget = XGUIEng.GetWidgetID(TooltipContainerPath .. "/FadeIn/Name")
    local TooltipDescriptionWidget = XGUIEng.GetWidgetID(TooltipContainerPath .. "/FadeIn/Text")
    local TooltipBGWidget = XGUIEng.GetWidgetID(TooltipContainerPath .. "/FadeIn/BG")
    local TooltipFadeInContainer = XGUIEng.GetWidgetID(TooltipContainerPath .. "/FadeIn")
    local TooltipCostsContainer = XGUIEng.GetWidgetID(TooltipContainerPath .. "/Costs")
    
    local PositionWidget = _OptionalPositionWidget or XGUIEng.GetCurrentWidgetID()
    
    if _TechnologyType ~= nil then
        local TechnologyIsTheReason = GUI_Tooltip.GetDisabledKeyForTechnologyType(_TechnologyType)
        
        if TechnologyIsTheReason ~= nil then
            _OptionalDisabledTextKeyName = TechnologyIsTheReason
        end
    end
    
    GUI_Tooltip.SetNameAndDescription(TooltipNameWidget, TooltipDescriptionWidget, _OptionalTextKeyName, _OptionalDisabledTextKeyName, nil, _LimitString)
    GUI_Tooltip.ResizeBG(TooltipBGWidget, TooltipDescriptionWidget)
    GUI_Tooltip.SetCosts(TooltipCostsContainer, _Costs, _GoodsInSettlementBoolean)
    
    local TooltipContainerSizeWidgets = {TooltipContainer, TooltipCostsContainer, TooltipBGWidget}
    GUI_Tooltip.SetPosition(TooltipContainer, TooltipContainerSizeWidgets, PositionWidget, nil, true)
    GUI_Tooltip.OrderTooltip(TooltipContainerSizeWidgets, TooltipFadeInContainer, TooltipCostsContainer, PositionWidget, TooltipBGWidget)
    
    GUI_Tooltip.FadeInTooltip(TooltipFadeInContainer)
end


function GUI_Tooltip.TooltipCostsOnly(_Costs)
    local TooltipContainerPath = "/InGame/Root/Normal/TooltipCostsOnly"
    local TooltipContainer = XGUIEng.GetWidgetID(TooltipContainerPath)
    local TooltipCostsContainer = XGUIEng.GetWidgetID(TooltipContainerPath .. "/Costs")
    
    GUI_Tooltip.SetCosts(TooltipCostsContainer, _Costs)
    
    local TooltipContainerSizeWidgets = {TooltipCostsContainer}
    GUI_Tooltip.SetPosition(TooltipContainer, TooltipContainerSizeWidgets, nil, nil)
end


function GUI_Tooltip.TooltipBuild(_OptionalPositionTooltipAboveBoolean, _OptionalNoProductionBoolean, _TechnologyType)
    
    local TooltipContainerPath = "/InGame/Root/Normal/AlignBottomRight/BuildMenu/TooltipBuild"
    local TooltipContainer = XGUIEng.GetWidgetID(TooltipContainerPath)
    local TooltipNameWidget = XGUIEng.GetWidgetID(TooltipContainerPath .. "/Name")
    local TooltipDescriptionWidget = XGUIEng.GetWidgetID(TooltipContainerPath .. "/Text")
    local TooltipDescriptionAnchorBottom = XGUIEng.GetWidgetID(TooltipContainerPath .. "/TextAnchorBottom")
    local TooltipDescriptionAnchorTop = XGUIEng.GetWidgetID(TooltipContainerPath .. "/TextAnchorTop")
    local TooltipCostsContainer = XGUIEng.GetWidgetID(TooltipContainerPath .. "/Costs")
    local TooltipProductionContainer = XGUIEng.GetWidgetID(TooltipContainerPath .. "/Production")
    
    local CurrentWidgetID = XGUIEng.GetCurrentWidgetID()
    local PositionWidget = XGUIEng.GetWidgetsMotherID(CurrentWidgetID)
    local WidgetName = XGUIEng.GetWidgetNameByID(CurrentWidgetID)
    local BuildingType
    
    if WidgetName == "B_WallGate" or WidgetName == "B_GuardTower" or WidgetName == "B_WatchTower" then
        BuildingType = GetEntityTypeForClimatezone(WidgetName)
    else
        BuildingType = Entities[WidgetName]
    end

    local Costs

    if BuildingType ~= nil then
        Costs = {Logic.GetEntityTypeFullCost(BuildingType)}
    else
        if WidgetName == "Trail" then
            Costs = {0, 0}
        elseif WidgetName == "Street" then
            Costs = {Goods.G_Stone, -1}
        elseif WidgetName == "Palisade" then
            Costs = {Goods.G_Wood, -1}
        elseif WidgetName == "Wall" then
            Costs = {Goods.G_Stone, -1}
        end
    end
    
    if _OptionalNoProductionBoolean == nil
    or _OptionalNoProductionBoolean == false then
        --in the case of normal menus, show Production section in tooltip; adjust position of Description
        XGUIEng.ShowWidget(TooltipProductionContainer, 1)
        local X, Y = XGUIEng.GetWidgetLocalPosition(TooltipDescriptionAnchorBottom)
        XGUIEng.SetWidgetLocalPosition(TooltipDescriptionWidget, X, Y)
        
        GUI_Tooltip.SetProduction(TooltipProductionContainer, BuildingType)
    else
        --in the case of the Infrastructure and Gatherer menus, remove Production section from tooltip; adjust position of Description
        XGUIEng.ShowWidget(TooltipProductionContainer, 0)
        local X, Y = XGUIEng.GetWidgetLocalPosition(TooltipDescriptionAnchorTop)
        XGUIEng.SetWidgetLocalPosition(TooltipDescriptionWidget, X, Y)
    end

    local DisabledTextKeyName
     
    if _TechnologyType ~= nil then
        DisabledTextKeyName = GUI_Tooltip.GetDisabledKeyForTechnologyType(_TechnologyType)
    end

    GUI_Tooltip.SetNameAndDescription(TooltipNameWidget, TooltipDescriptionWidget, nil, DisabledTextKeyName)

    GUI_Tooltip.SetCosts(TooltipCostsContainer, Costs)
    
    local TooltipContainerSizeWidgets = {TooltipContainer}
    GUI_Tooltip.SetPosition(TooltipContainer, TooltipContainerSizeWidgets, PositionWidget, _OptionalPositionTooltipAboveBoolean)
    
    GUI_Tooltip.FadeInTooltip()
end


function GUI_Tooltip.SetNameAndDescription(_TooltipNameWidget, _TooltipDescriptionWidget, _OptionalTextKeyName, _OptionalDisabledTextKeyName,
        _OptionalMissionTextFileBoolean, _LimitString)
    local CurrentWidgetID = XGUIEng.GetCurrentWidgetID()
    local WidgetName = XGUIEng.GetWidgetNameByID(CurrentWidgetID)

    local TooltipName
    local TooltipDesc
    local TooltipLimit = _LimitString or ""

    if _OptionalTextKeyName == nil then
        
        if _OptionalMissionTextFileBoolean == true then
            local CurrentMapName = Framework.GetCurrentMapName()
            TooltipName = XGUIEng.GetStringTableText("Map_" .. CurrentMapName .. "/" .. WidgetName .. "Name")
            TooltipDesc = XGUIEng.GetStringTableText("Map_" .. CurrentMapName .. "/" .. WidgetName .. "Description")
        end
        
        if _OptionalMissionTextFileBoolean ~= true
        or TooltipName == "" then
            TooltipName = XGUIEng.GetStringTableText("UI_ObjectNames/" .. WidgetName)
            TooltipDesc = XGUIEng.GetStringTableText("UI_ObjectDescription/".. WidgetName)
        end
    else
        if _OptionalMissionTextFileBoolean == true then
            local CurrentMapName = Framework.GetCurrentMapName()
            TooltipName = XGUIEng.GetStringTableText("Map_" .. CurrentMapName .. "/" .. _OptionalTextKeyName .. "Name")
            TooltipDesc = XGUIEng.GetStringTableText("Map_" .. CurrentMapName .. "/" .. _OptionalTextKeyName .. "Description")
        else
            TooltipName = XGUIEng.GetStringTableText("UI_ObjectNames/" .. _OptionalTextKeyName)
            TooltipDesc = XGUIEng.GetStringTableText("UI_ObjectDescription/".. _OptionalTextKeyName)
        end
    end

    if TooltipName == "" then
        if _OptionalTextKeyName == nil then
            TooltipName = "TOOLTIP NAME MISSING : " .. WidgetName
        else
            TooltipName = "TOOLTIP NAME MISSING : " .. _OptionalTextKeyName
        end
    end

    if (XGUIEng.IsButton(CurrentWidgetID) == 1
    and XGUIEng.IsButtonDisabled(CurrentWidgetID) == 1)
    or (XGUIEng.IsSlider(CurrentWidgetID) == 1
    and XGUIEng.IsSliderDisabled(CurrentWidgetID) == 1)
    then
        local ButtonDisabledTextKey

        if _OptionalDisabledTextKeyName == nil then
            if _OptionalTextKeyName ~= nil then
                ButtonDisabledTextKey = _OptionalTextKeyName
            else
                ButtonDisabledTextKey = WidgetName
            end
        else
            ButtonDisabledTextKey = _OptionalDisabledTextKeyName
        end
        
        -- Use existing multipurpose disabled text "currently not possible"
        if ButtonDisabledTextKey == "JumpToEntityQuestTargets" or ButtonDisabledTextKey == "BuyBatteringRamCart"
            or ButtonDisabledTextKey == "UpgradeTurret" then
            ButtonDisabledTextKey = "UpgradeOutpost"
        end
        
        local ButtonDisabledText = XGUIEng.GetStringTableText("UI_ButtonDisabled/" .. ButtonDisabledTextKey)

        if ButtonDisabledText == "" then
            ButtonDisabledText = "DISABLED TEXT MISSING : " .. ButtonDisabledTextKey
        end

        local DoesDescExist = "{cr}"
        
        if TooltipDesc == "" then
            DoesDescExist = ""
        end
        
        --TooltipDesc = TooltipDesc .. DoesDescExist .. "{@script:ColorRed}" .. ButtonDisabledText .. "{@script:ColorNone}"
        TooltipDesc = TooltipDesc .. DoesDescExist .. "{@color:220, 0, 0}" .. ButtonDisabledText .. "{@color:none}"
    end

    XGUIEng.SetText(_TooltipNameWidget, "{center}" .. TooltipName .. TooltipLimit)
    XGUIEng.SetText(_TooltipDescriptionWidget, TooltipDesc)
    
    local Height = XGUIEng.GetTextHeight(_TooltipDescriptionWidget, true)
    local W, H = XGUIEng.GetWidgetSize(_TooltipDescriptionWidget)
    
    XGUIEng.SetWidgetSize(_TooltipDescriptionWidget, W, Height)
end


function GUI_Tooltip.ResizeBG(_TooltipBGWidget, _TooltipDescriptionWidget)
    
    local X, Y = XGUIEng.GetWidgetLocalPosition(_TooltipDescriptionWidget)
    local W, H = XGUIEng.GetWidgetSize(_TooltipDescriptionWidget)
    local FadeInHeight = Y + H + 25
    
    if FadeInHeight < 60 then
        FadeInHeight = 60
    end
    
    local BGW, BGH = XGUIEng.GetWidgetSize(_TooltipBGWidget)
    XGUIEng.SetWidgetSize(_TooltipBGWidget, BGW, FadeInHeight)
end


function GUI_Tooltip.SetCosts(_TooltipCostsContainer, _Costs, _GoodsInSettlementBoolean)

    local TooltipCostsContainerPath = XGUIEng.GetWidgetPathByID(_TooltipCostsContainer)
    local Good1ContainerPath = TooltipCostsContainerPath .. "/1Good"
    local Goods2ContainerPath = TooltipCostsContainerPath .. "/2Goods"

    local NumberOfValidAmounts = 0
    local Good1Path
    local Good2Path

    for i = 2, #_Costs, 2 do
        if _Costs[i] ~= 0 then
            NumberOfValidAmounts = NumberOfValidAmounts + 1
        end
    end

    if NumberOfValidAmounts == 0 then
        XGUIEng.ShowWidget(Good1ContainerPath, 0)
        XGUIEng.ShowWidget(Goods2ContainerPath, 0)
        return
    elseif NumberOfValidAmounts == 1 then
        XGUIEng.ShowWidget(Good1ContainerPath, 1)
        XGUIEng.ShowWidget(Goods2ContainerPath, 0)
        Good1Path = Good1ContainerPath .. "/Good1Of1"
    elseif NumberOfValidAmounts == 2 then
        XGUIEng.ShowWidget(Good1ContainerPath, 0)
        XGUIEng.ShowWidget(Goods2ContainerPath, 1)
        Good1Path = Goods2ContainerPath .. "/Good1Of2"
        Good2Path = Goods2ContainerPath .. "/Good2Of2"
    elseif NumberOfValidAmounts > 2 then
        GUI.AddNote("Debug: Invalid Costs table. Not more than 2 GoodTypes allowed.")
    end

    local ContainerIndex = 1

    for i = 1, #_Costs, 2 do
        if _Costs[i + 1] ~= 0 then
            local CostsGoodType = _Costs[i]
            local CostsGoodAmount = _Costs[i + 1]
            
            local IconWidget
            local AmountWidget
            
            if ContainerIndex == 1 then
                IconWidget = Good1Path .. "/Icon"
                AmountWidget = Good1Path .. "/Amount"
            else
                IconWidget = Good2Path .. "/Icon"
                AmountWidget = Good2Path .. "/Amount"
            end
            
            SetIcon(IconWidget, g_TexturePositions.Goods[CostsGoodType], 44)
            
            local PlayerID = GUI.GetPlayerID()
            local PlayersGoodAmount
            
            if _GoodsInSettlementBoolean == true then
                PlayersGoodAmount = GetPlayerGoodsInSettlement(CostsGoodType, PlayerID, true)
            else
                --check either in Castle & Storehouse, or in selected building, or in refilling barracks
                local IsInOutStock
                local BuildingID
                
                if CostsGoodType == Goods.G_Gold then
                    BuildingID = Logic.GetHeadquarters(PlayerID)
                    IsInOutStock = Logic.GetIndexOnOutStockByGoodType(BuildingID, CostsGoodType)
                else
                    BuildingID = Logic.GetStoreHouse(PlayerID)
                    IsInOutStock = Logic.GetIndexOnOutStockByGoodType(BuildingID, CostsGoodType)
                end
                
                if IsInOutStock ~= -1 then
                    PlayersGoodAmount = Logic.GetAmountOnOutStockByGoodType(BuildingID, CostsGoodType)
                else
                    BuildingID = GUI.GetSelectedEntity()
                    
                    if BuildingID ~= nil then
                        if Logic.GetIndexOnOutStockByGoodType(BuildingID, CostsGoodType) == nil then
                            BuildingID = Logic.GetRefillerID(GUI.GetSelectedEntity())
                        end
                        
                        PlayersGoodAmount = Logic.GetAmountOnOutStockByGoodType(BuildingID, CostsGoodType)
                    else
                        PlayersGoodAmount = 0
                    end
                end
            end
            
            local Color = ""
            
            if PlayersGoodAmount < CostsGoodAmount then
                Color = "{@script:ColorRed}"
            end
            
            if CostsGoodAmount > 0 then
                XGUIEng.SetText(AmountWidget, "{center}" .. Color .. CostsGoodAmount)
            else
                --in case of -1, it means that the cost is variable (streets, palisades, walls)
                XGUIEng.SetText(AmountWidget, "")
            end
            
            ContainerIndex = ContainerIndex + 1
        end
    end
end


function GUI_Tooltip.SetProduction(_TooltipProductionContainer, _BuildingType)

    local Good1, Good2 = g_Tooltip.Production[_BuildingType][1], g_Tooltip.Production[_BuildingType][2]

    local InstockWidget = XGUIEng.GetWidgetID(XGUIEng.GetWidgetPathByID(_TooltipProductionContainer) .. "/Instock")
    local OutstockWidget = XGUIEng.GetWidgetID(XGUIEng.GetWidgetPathByID(_TooltipProductionContainer) .. "/Outstock")
    
    SetIcon(InstockWidget, g_TexturePositions.Goods[Good1])
    SetIcon(OutstockWidget, g_TexturePositions.Goods[Good2])
end


function GUI_Tooltip.SetPosition(_TooltipContainer, _TooltipContainerSizeWidgets, _OptionalPositionWidget, 
        _OptionalPositionTooltipAboveBoolean, _OptionalCheckCostsX)

    local PositionWidget = _OptionalPositionWidget

    local WidgetX, WidgetY
    local WidgetW, WidgetH

    if PositionWidget ~= nil then
        WidgetX, WidgetY = XGUIEng.GetWidgetScreenPosition(PositionWidget)
        WidgetW, WidgetH = XGUIEng.GetWidgetScreenSize(PositionWidget)
    else
        WidgetX, WidgetY = GUI.GetMousePosition()
        WidgetY = WidgetY + 40

        WidgetW, WidgetH = 1, 1
    end
    
    local WidgetCenterX = WidgetX + WidgetW / 2

    local TooltipW, TooltipH = GUI_Tooltip.GetTooltipScreenSize(_TooltipContainerSizeWidgets)
    
    local ScreenSizeX, ScreenSizeY = GUI.GetScreenSize()
    local TooltipX, TooltipY

    if WidgetCenterX + TooltipW / 2 < ScreenSizeX then
        if WidgetCenterX - TooltipW / 2 > 0 then
            TooltipX = WidgetCenterX - TooltipW / 2
        else
            TooltipX = 0
        end
    else
        TooltipX = ScreenSizeX - TooltipW
    end

    if (_OptionalPositionTooltipAboveBoolean == nil
    or _OptionalPositionTooltipAboveBoolean == false)
    and WidgetY + WidgetH + TooltipH < ScreenSizeY then
        TooltipY = WidgetY + WidgetH
    else
        TooltipY = WidgetY - TooltipH
    end

    --don't move BuildMenu Tooltip in X direction
    --when _OptionalPositionTooltipAboveBoolean is true or false
    if _OptionalPositionTooltipAboveBoolean == nil then
        XGUIEng.SetWidgetScreenPosition(_TooltipContainer, TooltipX, TooltipY)
    else
        local CurrentTooltipX, CurrentTooltipY = XGUIEng.GetWidgetScreenPosition(_TooltipContainer)
        XGUIEng.SetWidgetScreenPosition(_TooltipContainer, CurrentTooltipX, TooltipY)
    end
    
    --check if moving Costs seperately is necessary (at the screen border)
    if _OptionalCheckCostsX == true then
        local Anchor = XGUIEng.GetWidgetID(XGUIEng.GetWidgetPathByID(_TooltipContainer) .. "/Costs")
        local Good1Container = XGUIEng.GetWidgetID(XGUIEng.GetWidgetPathByID(_TooltipContainer) .. "/Costs/1Good")
        local Goods2Container = XGUIEng.GetWidgetID(XGUIEng.GetWidgetPathByID(_TooltipContainer) .. "/Costs/2Goods")
        local CurrentGoodContainer
        
        if XGUIEng.IsWidgetShown(Good1Container) == 1 then
            CurrentGoodContainer = Good1Container
        elseif XGUIEng.IsWidgetShown(Goods2Container) == 1 then
            CurrentGoodContainer = Goods2Container
        end
        
        if CurrentGoodContainer == nil then
            return
        end
        
        local AnchorX, AnchorY = XGUIEng.GetWidgetScreenPosition(Anchor)
        local CostsX, CostsY = XGUIEng.GetWidgetScreenPosition(CurrentGoodContainer)
        local CostsW, CostsH = XGUIEng.GetWidgetScreenSize(CurrentGoodContainer)
        local CostsCenterX = CostsX + CostsW / 2
        
        if WidgetCenterX - CostsCenterX < -5
        or WidgetCenterX - CostsCenterX > 5 then
            local XDestination = WidgetCenterX - CostsW / 2
            local CostsLocalX, CostsLocalY = XGUIEng.GetWidgetLocalPosition(CurrentGoodContainer)
            local AnchorW, AnchorH = XGUIEng.GetWidgetScreenSize(Anchor)
            
            if XDestination < AnchorX then
                XDestination = AnchorX
            elseif XDestination + CostsW > AnchorX + AnchorW then
                XDestination = AnchorX + AnchorW - CostsW
            end
            
            XGUIEng.SetWidgetScreenPosition(CurrentGoodContainer, XDestination, AnchorY)
        end
    end
end


function GUI_Tooltip.GetTooltipScreenSize(_TooltipContainerSizeWidgets)

    local TooltipW, TooltipH = XGUIEng.GetWidgetScreenSize(_TooltipContainerSizeWidgets[1])
    local TotalHeight
    
    if #_TooltipContainerSizeWidgets == 1 then
        TotalHeight = TooltipH
    else
        TotalHeight = 0
    
        for i = 2, #_TooltipContainerSizeWidgets do
            local W, H = XGUIEng.GetWidgetScreenSize(_TooltipContainerSizeWidgets[i])
            TotalHeight = TotalHeight + H
            
            --little hack due to overlapping
            if i == 3 then
                TotalHeight = TotalHeight - 15
            end
        end
    end
    
    return TooltipW, TotalHeight
end


function GUI_Tooltip.OrderTooltip(_TooltipContainerSizeWidgets, _TooltipFadeInContainer, _TooltipCostsContainer, _PositionWidget, _TooltipBGWidget)

    local WidgetX, WidgetY = XGUIEng.GetWidgetScreenPosition(_PositionWidget)
    local WidgetW, WidgetH = XGUIEng.GetWidgetScreenSize(_PositionWidget)

    local TooltipW, TooltipH = GUI_Tooltip.GetTooltipScreenSize(_TooltipContainerSizeWidgets)
    local ScreenSizeX, ScreenSizeY = GUI.GetScreenSize()

    if WidgetY + WidgetH + TooltipH < ScreenSizeY then
        XGUIEng.SetWidgetLocalPosition(_TooltipFadeInContainer, nil, 30)

        XGUIEng.SetWidgetLocalPosition(_TooltipCostsContainer, nil, 0)
    else
        XGUIEng.SetWidgetLocalPosition(_TooltipFadeInContainer, nil, 0)
        
        local BGW, BGH = XGUIEng.GetWidgetSize(_TooltipBGWidget)

        -- - 15 is a little hack due to overlapping
        XGUIEng.SetWidgetLocalPosition(_TooltipCostsContainer, nil, BGH - 15)
    end
end


function GUI_Tooltip.FadeInTooltip(_TooltipFadeInContainer)
    
    local CurrentWidgetID = XGUIEng.GetCurrentWidgetID()
    local CurrentTime = Game.RealTimeGetMs()
    
    if g_Tooltip.FadeInCurrentWidgetID ~= CurrentWidgetID then
        g_Tooltip.FadeInCurrentWidgetID = CurrentWidgetID
        g_Tooltip.FadeInCurrentStartTime = CurrentTime
    end
    
    if _TooltipFadeInContainer == nil then
        return
    end
    
    local Milliseconds = CurrentTime - (g_Tooltip.FadeInCurrentStartTime + g_Tooltip.FadeInTriggerTime)
    
    local Alpha = Milliseconds / g_Tooltip.FadeInFadingTime
    
    if Alpha < 0 then
        Alpha = 0
    elseif Alpha > 1 then
        Alpha = 1
    end
    
    Alpha = math.floor(Alpha * 255)
    
    local FadeInWidgets = {XGUIEng.ListSubWidgetsRecursive(_TooltipFadeInContainer)}
    
    for i = 1, #FadeInWidgets do
        if XGUIEng.IsTextWidget(FadeInWidgets[i]) == 1 then
            XGUIEng.SetTextAlpha(FadeInWidgets[i], Alpha)
        else
            XGUIEng.SetMaterialAlpha(FadeInWidgets[i], 0, Alpha)
        end
    end
end


---------


function AreCostsAffordable(_Costs, _GoodsInSettlementBoolean)

    local PlayerID = GUI.GetPlayerID()

    local CanBuyBoolean = true
    local CanNotBuyString = ""
    local CanNotBuyStringSections = {}
    CanNotBuyStringSections.Number = 0

    local CastleID = Logic.GetHeadquarters(PlayerID)
    local StorehouseID = Logic.GetStoreHouse(PlayerID)
    
    local PlayerGoldAmount = Logic.GetAmountOnOutStockByGoodType(CastleID, Goods.G_Gold)
    local PlayerStoneAmount = Logic.GetAmountOnOutStockByGoodType(StorehouseID, Goods.G_Stone)
    local PlayerWoodAmount = Logic.GetAmountOnOutStockByGoodType(StorehouseID, Goods.G_Wood)
    
    local PlayerWeaponOrPartAmount = 0
    local WeaponOrPartType
    local BarracksID = GUI.GetSelectedEntity()

    local GoldCost = 0
    local StoneCost = 0
    local WoodCost = 0
    local WeaponOrPartCost = 0

    for i = 1, table.getn(_Costs), 2 do
        if _Costs[i] == Goods.G_Gold then
            GoldCost = _Costs[i + 1]
        elseif _Costs[i] == Goods.G_Stone then
            StoneCost = _Costs[i + 1]
        elseif _Costs[i] == Goods.G_Wood then
            WoodCost = _Costs[i + 1]
        else
            if WeaponOrPartType == nil then
                WeaponOrPartType = _Costs[i]
                WeaponOrPartCost = _Costs[i + 1]
            else
                GUI.AddNote("Debug: Too many good types in cost table")
            end
        end
    end

    local CastleID = Logic.GetHeadquarters(PlayerID)
    local StorehouseID = Logic.GetStoreHouse(PlayerID)

    if WeaponOrPartType ~= nil
    and BarracksID ~= nil
    and _GoodsInSettlementBoolean ~= true then
        local CastleGoodIndex = Logic.GetIndexOnOutStockByGoodType(CastleID, WeaponOrPartType)
        local StorehouseGoodIndex = Logic.GetIndexOnOutStockByGoodType(StorehouseID, WeaponOrPartType)
        local BarracksGoodIndex = Logic.GetIndexOnOutStockByGoodType(BarracksID, WeaponOrPartType)
        
        if BarracksGoodIndex == nil
        and Logic.IsEntityInCategory(BarracksID, EntityCategories.Leader) == 1 then
            BarracksID = Logic.GetRefillerID(BarracksID)
            BarracksGoodIndex = Logic.GetIndexOnOutStockByGoodType(BarracksID, WeaponOrPartType)
        end

        if CastleGoodIndex == -1
        and StorehouseGoodIndex == -1
        and BarracksGoodIndex == -1 then
            GUI.AddNote("Debug: Good type " .. Logic.GetGoodTypeName(WeaponOrPartType) .. " neither in castle, storehouse or selected building")
            return
        end

        local BuildingID

        if CastleGoodIndex ~= -1 then
            BuildingID = CastleID
        elseif StorehouseGoodIndex ~= -1 then
            BuildingID = StorehouseID
        elseif BarracksGoodIndex ~= -1 then
            BuildingID = BarracksID
        end

        PlayerWeaponOrPartAmount = Logic.GetAmountOnOutStockByGoodType(BuildingID, WeaponOrPartType)
    
    elseif _GoodsInSettlementBoolean == true then
        PlayerWeaponOrPartAmount = GetPlayerGoodsInSettlement(WeaponOrPartType, PlayerID, true)--we don't check in market place
    end

    if PlayerGoldAmount < GoldCost then
        CanBuyBoolean = false
        local GoodName = Logic.GetGoodTypeName(Goods.G_Gold)
        CanNotBuyStringSections.Number = CanNotBuyStringSections.Number + 1
        CanNotBuyStringSections[CanNotBuyStringSections.Number] = GoodName
    end

    if PlayerStoneAmount < StoneCost then
        CanBuyBoolean = false
        local GoodName = Logic.GetGoodTypeName(Goods.G_Stone)
        CanNotBuyStringSections.Number = CanNotBuyStringSections.Number + 1
        CanNotBuyStringSections[CanNotBuyStringSections.Number] = GoodName
    end

    if PlayerWoodAmount < WoodCost then
        CanBuyBoolean = false
        local GoodName = Logic.GetGoodTypeName(Goods.G_Wood)
        CanNotBuyStringSections.Number = CanNotBuyStringSections.Number + 1
        CanNotBuyStringSections[CanNotBuyStringSections.Number] = GoodName
    end

    if PlayerWeaponOrPartAmount < WeaponOrPartCost then
        CanBuyBoolean = false
        local GoodName = Logic.GetGoodTypeName(WeaponOrPartType)
        CanNotBuyStringSections.Number = CanNotBuyStringSections.Number + 1
        CanNotBuyStringSections[CanNotBuyStringSections.Number] = GoodName
    end

    if CanNotBuyStringSections.Number == 1 then
        CanNotBuyString = "TextLine_NotEnough_" .. CanNotBuyStringSections[1]
    elseif CanNotBuyStringSections.Number == 2 then
        CanNotBuyString = "TextLine_NotEnough_" .. CanNotBuyStringSections[1] .. "_" .. CanNotBuyStringSections[2]
    end

    local CanNotBuyStringTableText = XGUIEng.GetStringTableText("Feedback_TextLines/" .. CanNotBuyString)
    
    if CanBuyBoolean == false
    and CanNotBuyStringTableText == "" then
        
        local StorehouseGoodIndex = Logic.GetIndexOnOutStockByGoodType(StorehouseID, _Costs[1])
        
        if _Costs[1] == Goods.G_Gold then
            CanNotBuyStringTableText = XGUIEng.GetStringTableText("Feedback_TextLines/TextLine_NotEnough_G_Gold")
        elseif StorehouseGoodIndex ~= -1 then
            CanNotBuyStringTableText = XGUIEng.GetStringTableText("Feedback_TextLines/TextLine_NotEnough_Resources")
        else
            CanNotBuyStringTableText = XGUIEng.GetStringTableText("Feedback_TextLines/TextLine_NotEnough_Goods")
        end
        
        --CanNotBuyStringTableText = "TextKey missing for " .. CanNotBuyString
    end
    
    return CanBuyBoolean, CanNotBuyStringTableText
end


function Message(_String, _OptionalAlternativeSound, _OptionalNormalSound)
    local ContainerWidget = "/InGame/Root/Normal/TextMessages/MessageContainer"
    local MessageText = "{center}" .. _String
    local CurrentText = XGUIEng.GetText(ContainerWidget .. "/Message1")

    if CurrentText ~= MessageText then
        
        for i = 1, 4 do
            XGUIEng.SetText(ContainerWidget .. "/Message" .. i, MessageText)
        end
        
        XGUIEng.ShowWidget(ContainerWidget, 1)
        g_MessageTime = Framework.GetTimeMs()

        if _OptionalAlternativeSound == nil then
            Sound.FXPlay2DSound( "ui\\menu_click_negative")
        else
            Sound.FXPlay2DSound(_OptionalAlternativeSound)
        end
    else
        if _OptionalNormalSound == nil then
            Sound.FXPlay2DSound("ui\\menu_click_negative")
        else
            Sound.FXPlay2DSound(_OptionalNormalSound)
        end
    end
end


function MessagesUpdate()
    local ContainerWidget = "/InGame/Root/Normal/TextMessages/MessageContainer"
    local CurrentRealTime = Framework.GetTimeMs()
    
    if g_MessageTime ~= nil
    and CurrentRealTime > g_MessageTime + 5000 then
        XGUIEng.ShowWidget(ContainerWidget, 0)
        XGUIEng.SetText(ContainerWidget .. "/Message1", "")
    end
end

