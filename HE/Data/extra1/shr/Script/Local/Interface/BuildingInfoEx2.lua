
-----------------------------------------------------------------------------------------
-- Overwrites for BuildingInfo
-----------------------------------------------------------------------------------------

function InitOverwriteBuildingInfoEx2()

    do
        function GUI_BuildingInfo.UpgradeUpdate()

            local CurrentWidgetID = XGUIEng.GetCurrentWidgetID()
            local BuildingID = GetBuildingIDAlsoWhenWorkerIsSelected()--GUI.GetSelectedEntity()

            local UpgradeLevel = Logic.GetUpgradeLevel(BuildingID)
            local UpgradeLimit = Logic.GetMaxUpgradeLevel(BuildingID)

            local Text = XGUIEng.GetStringTableText("UI_Texts/BuildingUpgradeLevel")

            if UpgradeLimit ~= 0 then
                Text = "{center}" .. Text .. " " .. UpgradeLevel+1 .."/" .. UpgradeLimit+1
            else
                Text = "{center}" .. Text .. " 1/1"
            end

            if Logic.IsSettler(GUI.GetSelectedEntity()) == 1 then
                Text = ""
            end
    
            XGUIEng.SetText(CurrentWidgetID, Text)
        end
    end

end