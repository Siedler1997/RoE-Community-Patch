
function GUI_BuildingButtons.UpgradeClicked()

    local EntityID = GUI.GetSelectedEntity()

    if Logic.CanCancelUpgradeBuilding(EntityID) then
        Sound.FXPlay2DSound("ui\\menu_click")
        GUI.CancelBuildingUpgrade(EntityID)
        XGUIEng.ShowAllSubWidgets("/InGame/Root/Normal/BuildingButtons",1)
        return
    end

    local Costs = GUI_BuildingButtons.GetUpgradeCosts()
    local CanBuyBoolean, CanNotBuyString = AreCostsAffordable(Costs)

    if CanBuyBoolean == true then
        Sound.FXPlay2DSound("ui\\menu_click")
        GUI.UpgradeBuilding(EntityID, UpgradePart)

        StartKnightVoiceForPermanentSpecialAbility(Entities.U_KnightWisdom)
        StartKnightVoiceForPermanentSpecialAbility(Entities.U_KnightPraphat)

        if XGUIEng.GetCurrentWidgetID() ~= 0 then
            SaveButtonPressed(XGUIEng.GetCurrentWidgetID())
        end
    else
        Message(CanNotBuyString)
    end
end

function GUI_BuildingButtons.StartSermonClicked()

    local PlayerID = GUI.GetPlayerID()

    if Logic.CanSermonBeActivated(PlayerID) then
        GUI.ActivateSermon(PlayerID)

        StartKnightVoiceForPermanentSpecialAbility(Entities.U_KnightHealing)
        StartKnightVoiceForPermanentSpecialAbility(Entities.U_KnightKhana)

        GUI.AddBuff(Buffs.Buff_Sermon)

        local CathedralID = Logic.GetCathedral(PlayerID)
        local x, y = Logic.GetEntityPosition(CathedralID)
        local z = 0
        Sound.FXPlay3DSound("buildings\\building_start_sermon", x, y, z)
    end
end