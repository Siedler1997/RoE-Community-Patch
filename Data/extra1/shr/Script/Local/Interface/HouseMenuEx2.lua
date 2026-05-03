
-----------------------------------------------------------------------------------------
-- Overwrites for HouseMenu
-----------------------------------------------------------------------------------------

function InitOverwriteHouseMenuEx2()

    do
        function HouseMenuSetIconsPart(_Part, _HighlightBool)

            local playerID = GUI.GetPlayerID();
            local houseMenuButtons = {XGUIEng.ListSubWidgets(_Part)};
            local buildings = {Logic.GetBuildingsByPlayer(playerID)};

            for i = 1, #houseMenuButtons do
                local widgetName = XGUIEng.GetWidgetNameByID(houseMenuButtons[i]);
                local trimedWidgetName = string.gsub(widgetName, "_%w%w?%w?$", "");
                local button = _Part .. "/" .. widgetName .. "/Button";
                SetIcon(button, g_TexturePositions.Entities[Entities[widgetName]]);

                local count = 0;
                for j = 1, #buildings do
                    local entityType = Logic.GetEntityType(buildings[j]);
                    local entityName = Logic.GetEntityTypeName(entityType);
                    local trimedEntityName = string.gsub(entityName, "_%w%w?%w?$", "");
                    if trimedWidgetName == trimedEntityName then
                        count = count + 1;
                    end
                    if (trimedWidgetName == "B_Barracks" and (entityType == Entities.B_Barracks_RedPrince or entityType == Entities.B_Barracks_Khana))
                        or (trimedWidgetName == "B_BarracksArchers" and (entityType == Entities.B_BarracksArchers_Redprince or entityType == Entities.B_BarracksArchers_Khana)) then
                        Count = Count + 1
                    end
                end

                XGUIEng.DisableButton(button, (count == 0 and 1) or 0);
                XGUIEng.SetText(_Part .. "/" .. widgetName .. "/Amount", "{center}" .. count);
                UpdateStopOverlay(_Part .. "/" .. widgetName .. "/Stop", widgetName, count);

                if widgetName == HouseMenu.Widget.CurrentBuilding then
                    UpdateStopOverlay(
                        HouseMenu.Widget.CurrentStop,
                        HouseMenu.Widget.CurrentBuilding,
                        count
                    );
                end
            end

            HouseMenu.Counter = HouseMenu.Counter + 1;
            if _HighlightBool or HouseMenu.Counter % 20 == 0 then
                for j = 1, #houseMenuButtons do
                    local building = HouseMenu.Widget.CurrentBuilding;
                    local highligtedName = XGUIEng.GetWidgetNameByID(houseMenuButtons[j]);
                    local button = _Part .. "/" .. highligtedName .. "/Button";
                    highligtedName = GetClimateEntityName(highligtedName);
                    local highlightFlag = (highligtedName == building and 1) or 0;
                    XGUIEng.HighLightButton(button, highlightFlag);
                end
            end

        end
    end

    do
        function HouseMenuGetNextBuildingID(WidgetName)
        
            local playerID = GUI.GetPlayerID();
            local buildingsList = {Logic.GetBuildingsByPlayer(playerID)};

            WidgetName = GetClimateEntityName(WidgetName);
            local TrimedWidgetName = string.gsub(WidgetName, "_%w%w?%w?$", "");
            if HouseMenu.Widget.CurrentBuilding ~= WidgetName then
                HouseMenu.Widget.CurrentBuilding = WidgetName;
                HouseMenu.Widget.CurrentBuildingNumber = 0;
            end

            local foundNumber = 0;
            local higherBuildingFound = false;
            for i = 1, #buildingsList do
                local entityType = Logic.GetEntityType(buildingsList[i]);
                local entityName = Logic.GetEntityTypeName(entityType);
                local trimedEntityName = string.gsub(entityName, "_%w%w?%w?$", "");
                if trimedEntityName == TrimedWidgetName 
                    or (TrimedWidgetName == "B_Barracks" and (entityType == Entities.B_Barracks_RedPrince or entityType == Entities.B_Barracks_Khana))
                    or (TrimedWidgetName == "B_BarracksArchers" and (entityType == Entities.B_BarracksArchers_Redprince or entityType == Entities.B_BarracksArchers_Khana)) then
                    foundNumber = i;
                    if foundNumber > HouseMenu.Widget.CurrentBuildingNumber then
                        HouseMenu.Widget.CurrentBuildingNumber = foundNumber;
                        higherBuildingFound = true;
                        break;
                    end
                end
            end

            if foundNumber == 0 then
                return nil;
            end
            if not higherBuildingFound then
                for i = 1, #buildingsList do
                    local entityType = Logic.GetEntityType(buildingsList[i]);
                    local entityName = Logic.GetEntityTypeName(entityType);
                    if entityName == WidgetName then
                        HouseMenu.Widget.CurrentBuildingNumber = i;
                        break;
                    end
                end
            end
            return buildingsList[HouseMenu.Widget.CurrentBuildingNumber];

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
            or HouseMenu.Widget.CurrentBuilding == "B_TradePost" then
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
            or HouseMenu.Widget.CurrentBuilding == "B_TradePost"
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