
-----------------------------------------------------------------------------------------
-- Overwrites for HouseMenu
-----------------------------------------------------------------------------------------

function InitOverwriteHouseMenuEx2()

    do
        function HouseMenuSetIconsPart(_Part, _HighlightBool)

            local HouseMenuButtons = {XGUIEng.ListSubWidgets(_Part)}
            local WidgetName
            local player = GUI.GetPlayerID()
            local Buildings = {Logic.GetBuildingsByPlayer(player)}
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
                    if (ClimateWidgetName == "B_Barracks" and (EntityType == Entities.B_Barracks_RedPrince or EntityType == Entities.B_Barracks_Khana))
                        or (ClimateWidgetName == "B_BarracksArchers" and (EntityType == Entities.B_BarracksArchers_Redprince or EntityType == Entities.B_BarracksArchers_Khana)) then
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

            if _HighlightBool == true or math.mod(HouseMenu.Counter, 20) == 0 then

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
    end

    do
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

                if EntityName == WidgetName
                    or (WidgetName == "B_Barracks" and (EntityType == Entities.B_Barracks_RedPrince or EntityType == Entities.B_Barracks_Khana))
                    or (WidgetName == "B_BarracksArchers" and (EntityType == Entities.B_BarracksArchers_Redprince or EntityType == Entities.B_BarracksArchers_Khana)) then
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
    end

    do
        function HouseMenuCountBuildings(WidgetName)

            local Buildings = { Logic.GetBuildingsByPlayer(GUI.GetPlayerID()) }
            local i

            local FoundNumber = 0
            local HigherBuildingFound = false

            for i = 1, #Buildings do
                local EntityType = Logic.GetEntityType(Buildings[i])
                local EntityName = Logic.GetEntityTypeName(EntityType)
                if EntityName == WidgetName 
                    or (WidgetName == "B_Barracks" and (EntityType == Entities.B_Barracks_RedPrince or EntityType == Entities.B_Barracks_Khana))
                    or (WidgetName == "B_BarracksArchers" and (EntityType == Entities.B_BarracksArchers_Redprince or EntityType == Entities.B_BarracksArchers_Khana)) then
                    FoundNumber = FoundNumber + 1
                end
            end

            return FoundNumber

        end
    end

    do
        local OldHouseMenuStopProductionUpdate = HouseMenuStopProductionUpdate
        function HouseMenuStopProductionUpdate()
            local CurrentWidgetID = XGUIEng.GetCurrentWidgetID()

            if HouseMenu.Widget.CurrentBuilding == nil
            or HouseMenu.Widget.CurrentBuilding == "B_Castle_AS"
            or HouseMenu.Widget.CurrentBuilding == "B_Outpost_AS"
            or HouseMenu.Widget.CurrentBuilding == "B_TradePost"
            or HouseMenu.Widget.CurrentBuilding == "B_Cathedral_Big" then
                XGUIEng.DisableButton(CurrentWidgetID, 1)
                return
            else
                OldHouseMenuStopProductionUpdate()
            end
        end
    end

    do
        local OldHouseMenuStopConsumptionUpdate = HouseMenuStopConsumptionUpdate
        function HouseMenuStopConsumptionUpdate()
            local CurrentWidgetID = XGUIEng.GetCurrentWidgetID()

            if HouseMenu.Widget.CurrentBuilding == nil
            or HouseMenu.Widget.CurrentBuilding == "B_Castle_AS"
            or HouseMenu.Widget.CurrentBuilding == "B_Outpost_AS"
            or HouseMenu.Widget.CurrentBuilding == "B_TradePost"
            or HouseMenu.Widget.CurrentBuilding == "B_Cathedral_Big"
            or HouseMenu.Widget.CurrentBuilding == "B_BarracksSpearmen" 
            or HouseMenu.Widget.CurrentBuilding == "B_BarracksCavalry" then
                XGUIEng.DisableButton(CurrentWidgetID, 1)
                return
            else
                OldHouseMenuStopConsumptionUpdate()
            end
        end
    end

end