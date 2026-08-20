
--------------------------------------------------------------------------
-- Overwrites for ToolTip
--------------------------------------------------------------------------

function InitOverwriteToolTipEx2()

    do
        local OldInitTooltips = InitTooltips
        function InitTooltips()
            OldInitTooltips()
            g_Tooltip.Production[Entities.B_BarracksSpearmen]   = {Goods.G_PoorSpear, Goods.G_Spear}
            g_Tooltip.Production[Entities.B_SpearMaker]         = {Goods.G_Iron, Goods.G_PoorSpear}
            g_Tooltip.Production[Entities.B_BarracksCavalry]    = {Goods.G_PoorSword, Goods.G_Sword}
        end
    end

--[[
    do
        function GUI_Tooltip.TooltipTechnology(_TechnologyType, _OptionalTextKeyName, _OptionalDisabledTextKeyName, _OptionalCosts)
            
            local TooltipContainerPath = "/InGame/Root/Normal/TooltipTechnology"
            local TooltipContainer = XGUIEng.GetWidgetID(TooltipContainerPath)
            local TooltipNameWidget = XGUIEng.GetWidgetID(TooltipContainerPath .. "/FadeIn/Name")
            local TooltipDescriptionWidget = XGUIEng.GetWidgetID(TooltipContainerPath .. "/FadeIn/Text")
            local TooltipBGWidget = XGUIEng.GetWidgetID(TooltipContainerPath .. "/FadeIn/BG")
            local TooltipFadeInContainer = XGUIEng.GetWidgetID(TooltipContainerPath .. "/FadeIn")
            local TooltipCostsContainer = XGUIEng.GetWidgetID(TooltipContainerPath .. "/Costs")
            
            local PositionWidget = XGUIEng.GetCurrentWidgetID()
            
            local DisabledTextKeyName = GUI_Tooltip.GetDisabledKeyForTechnologyType(_TechnologyType)
            
            if DisabledTextKeyName == nil then
                DisabledTextKeyName = _OptionalDisabledTextKeyName
            end

            GUI_Tooltip.SetNameAndDescription(TooltipNameWidget, TooltipDescriptionWidget, _OptionalTextKeyName, DisabledTextKeyName, _OptionalMissionTextFileBoolean)
            GUI_Tooltip.ResizeBG(TooltipBGWidget, TooltipDescriptionWidget)
            GUI_Tooltip.SetCosts(TooltipCostsContainer, _Costs, _GoodsInSettlementBoolean)
            
            local TooltipContainerSizeWidgets = {TooltipContainer, TooltipCostsContainer, TooltipBGWidget}
            GUI_Tooltip.SetPosition(TooltipContainer, TooltipContainerSizeWidgets, PositionWidget)
            GUI_Tooltip.OrderTooltip(TooltipContainerSizeWidgets, TooltipFadeInContainer, TooltipCostsContainer, PositionWidget, TooltipBGWidget)

            GUI_Tooltip.FadeInTooltip(TooltipFadeInContainer)
        end
    end
--]]

    do
        function GUI_Tooltip.GetDisabledKeyForTechnologyType(_TechnologyType)

            if _TechnologyType == Technologies.R_Beautification_Cathedral then
                local PlayerID  = GUI.GetPlayerID()
                if Logic.GetNumberOfEntitiesOfTypeOfPlayer(PlayerID, Entities.B_R_Beautification_Cathedral) then
                    return "BuildingLimitReached"
                end
            else
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
                        KnightGender = "male"
                    end
                    DisabledTextKeyName = "Title_" .. TitleName .."_" .. KnightGender .. "_needed"    
            
                    return DisabledTextKeyName
                end
            end
        end
    end

    do
        function GUI_Tooltip.TooltipBuy(_Costs, _OptionalTextKeyName, _OptionalDisabledTextKeyName, _TechnologyType, _GoodsInSettlementBoolean, _OptionalPositionWidget, _LimitString)
    
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
    end

    do
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
            local SkinAmmount
            local ChangeType

            if WidgetName == "B_WallGate" or WidgetName == "B_GuardTower" or WidgetName == "B_WatchTower" or WidgetName == "B_Plaza" then
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
                elseif WidgetName == "Fence" then
                    Costs = {Goods.G_Wood, -1}
                elseif WidgetName == "NPCWall" then
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
    
            local BuildingUpgradeCategory = Logic.GetUpgradeCategoryByBuildingType(BuildingType)
            if BuildingUpgradeCategory ~= 0 and GUI_Construction.BuildingsWithSkins[BuildingUpgradeCategory] ~= nil then
                SkinAmmount = "("..table.getn(GUI_Construction.BuildingsWithSkins[BuildingUpgradeCategory])..")"
                ChangeType = "ChangeType"
            end

            GUI_Tooltip.SetNameAndDescription(TooltipNameWidget, TooltipDescriptionWidget, nil, DisabledTextKeyName, nil, SkinAmmount, ChangeType)

            GUI_Tooltip.SetCosts(TooltipCostsContainer, Costs)
    
            --Fixes location as that button has one layer less here
            if WidgetName == "B_Beautification_Cathedral" then
                PositionWidget = CurrentWidgetID
            end

            local TooltipContainerSizeWidgets = {TooltipContainer}
            GUI_Tooltip.SetPosition(TooltipContainer, TooltipContainerSizeWidgets, PositionWidget, _OptionalPositionTooltipAboveBoolean)

            GUI_Tooltip.FadeInTooltip()
        end
    end

    do
        function GUI_Tooltip.SetNameAndDescription(_TooltipNameWidget, _TooltipDescriptionWidget, _OptionalTextKeyName, _OptionalDisabledTextKeyName,
                _OptionalMissionTextFileBoolean, _LimitString, _SpecialTextKeyName)
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

            if _SpecialTextKeyName ~= nil then
                TooltipDesc = TooltipDesc .. XGUIEng.GetStringTableText("UI_ObjectDescription/".. _SpecialTextKeyName)
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

            XGUIEng.SetText(_TooltipNameWidget, "{center}" .. TooltipName .. " " .. TooltipLimit)
            XGUIEng.SetText(_TooltipDescriptionWidget, TooltipDesc)
    
            local Height = XGUIEng.GetTextHeight(_TooltipDescriptionWidget, true)
            local W, H = XGUIEng.GetWidgetSize(_TooltipDescriptionWidget)
    
            XGUIEng.SetWidgetSize(_TooltipDescriptionWidget, W, Height)
        end
    end

    do
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
            local PlayerIronAmount = Logic.GetAmountOnOutStockByGoodType(StorehouseID, Goods.G_Iron)
            local PlayerHoneyAmount = Logic.GetAmountOnOutStockByGoodType(StorehouseID, Goods.G_Honeycomb)
    
            local PlayerWeaponOrPartAmount = 0
            local WeaponOrPartType
            local BarracksID = GUI.GetSelectedEntity()

            local GoldCost = 0
            local StoneCost = 0
            local WoodCost = 0
            local IronCost = 0
            local HoneyCost = 0
            local WeaponOrPartCost = 0

            for i = 1, table.getn(_Costs), 2 do
                if _Costs[i] == Goods.G_Gold then
                    GoldCost = _Costs[i + 1]
                elseif _Costs[i] == Goods.G_Stone then
                    StoneCost = _Costs[i + 1]
                elseif _Costs[i] == Goods.G_Wood then
                    WoodCost = _Costs[i + 1]
                elseif _Costs[i] == Goods.G_Iron then
                    IronCost = _Costs[i + 1]
                elseif _Costs[i] == Goods.G_Honeycomb then
                    HoneyCost = _Costs[i + 1]
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

            if PlayerIronAmount < IronCost then
                CanBuyBoolean = false
                local GoodName = Logic.GetGoodTypeName(Goods.G_Iron)
                CanNotBuyStringSections.Number = CanNotBuyStringSections.Number + 1
                CanNotBuyStringSections[CanNotBuyStringSections.Number] = GoodName
            end

            if PlayerHoneyAmount < HoneyCost then
                CanBuyBoolean = false
                local GoodName = Logic.GetGoodTypeName(Goods.G_Honeycomb)
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
    end

end