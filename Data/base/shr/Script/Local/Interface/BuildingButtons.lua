--------------------------------------------------------------------------
--        *****************Building Buttons*****************
--------------------------------------------------------------------------

GUI_BuildingButtons = {}


function GUI_BuildingButtons.BuildingButtonsPositionUpdater()

    local EntityID = GUI.GetSelectedEntity()

    local WidgetName = "/InGame/Root/Normal/BuildingButtons"

    if EntityID ~= nil then

        local Position = {GUI.GetEntityInfoScreenPosition(EntityID)}

        if Position[1] == 0 and Position[2] == 0 then
            XGUIEng.ShowWidget(WidgetName, 0)
        else
            XGUIEng.ShowWidget(WidgetName, 1)

            local WidgetSize = {XGUIEng.GetWidgetScreenSize(WidgetName)}

            local x = Position[1] - (WidgetSize[1] / 2)
            local y = Position[2] - (WidgetSize[2] / 2)

            if y < 0 then
                local EntityX, EntityY  = Logic.GetEntityPosition(EntityID)
                local EntityZ = Display.GetTerrainHeight(EntityX, EntityY)
                local EntityScreenPosX, EntityScreenPosY = Camera.GetScreenCoord(EntityX, EntityY, EntityZ)

                y = y + 500

                if y > 0 then
                    y = 0
                end

                if y > EntityScreenPosY - (WidgetSize[2] / 2) then
                    y = EntityScreenPosY - (WidgetSize[2] / 2)
                end
            end

            XGUIEng.SetWidgetScreenPosition(WidgetName, x, y)
        end
    end
end


function GUI_BuildingButtons.UpgradeSpecialBuildingUpdate()
    local CurrentWidgetID = XGUIEng.GetCurrentWidgetID()
    local EntityID = GUI.GetSelectedEntity()
    local PlayerID = GUI.GetPlayerID()

    if EntityID == nil
    or EntityID == 0 then
        return
    end

    -- is upgrade locked, than disable widget
    if EnableRights then
        for EntityCategory, Value in pairs(TechnologyNeededForUpgrade) do
            if Logic.IsEntityInCategory(EntityID, EntityCategory) == 1 then
                local UpgradeLevel = Logic.GetUpgradeLevel(EntityID) + 1
                local TechnologyType = TechnologyNeededForUpgrade[EntityCategory][UpgradeLevel]

                if Logic.TechnologyGetState(PlayerID, TechnologyType) == TechnologyStates.Locked then
                    XGUIEng.DisableButton(CurrentWidgetID, 1)
                    --return
                end
            end
        end
    end

    -- do not show button, when building can not be upgraded anymore
    if (Logic.IsBuilding(EntityID) == 0
    or (Logic.IsBuilding(EntityID) == 1
    and Logic.IsBuildingUpgradable(EntityID, true) == false)) then
        XGUIEng.ShowWidget(CurrentWidgetID, 0)
        return
    else
        -- set texture or do not show button
        if EntityID == Logic.GetHeadquarters(PlayerID) then
            SetIcon(CurrentWidgetID, {4, 7})

        elseif EntityID == Logic.GetStoreHouse(PlayerID) then
            SetIcon(CurrentWidgetID, {4, 6})

        elseif EntityID == Logic.GetCathedral(PlayerID) then
            SetIcon(CurrentWidgetID, {4, 5})

        else
            XGUIEng.ShowWidget(CurrentWidgetID, 0)
            return
        end

        -- disable if currently not possible
        if Logic.IsBuildingUpgradable(EntityID, false) == false then
            XGUIEng.DisableButton(CurrentWidgetID, 1)
            return
        else
            XGUIEng.DisableButton(CurrentWidgetID, 0)
        end

        if Logic.GetNumberOfEmployedWorkers(PlayerID) < 2 then
            XGUIEng.DisableButton(CurrentWidgetID, 1)
            return
        else
            XGUIEng.DisableButton(CurrentWidgetID, 0)
        end
    end
end


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

        if XGUIEng.GetCurrentWidgetID() ~= 0 then
            SaveButtonPressed(XGUIEng.GetCurrentWidgetID())
        end
    else
        Message(CanNotBuyString)
    end
end


function GUI_BuildingButtons.UpgradeMouseOver()

    local TooltipTextKey
    local TooltipTextKeyDisabled

    local CurrentWidgetID = XGUIEng.GetCurrentWidgetID()
    local PlayerID = GUI.GetPlayerID()
    local EntityID = GUI.GetSelectedEntity()

    local UpgradeCosts = GUI_BuildingButtons.GetUpgradeCosts()

    -- used to check if technology is locked (upgrade is impossible)
    local TechnologyType = Technologies.R_BuildingUpgrade

    if EntityID ~= 0 and EntityID ~= nil then
        if Logic.IsEntityInCategory(EntityID, EntityCategories.OuterRimBuilding) == 1 then
            TooltipTextKey = "UpgradeOuterRim"

            if Logic.BuildingDoWorkersStrike(EntityID) == true then
                TooltipTextKeyDisabled = "UpgradeSettlersStrike"
            end

        elseif Logic.IsEntityInCategory(EntityID, EntityCategories.CityBuilding) == 1 then
            TooltipTextKey = "UpgradeCity"

            if Logic.BuildingDoWorkersStrike(EntityID) == true then
                TooltipTextKeyDisabled = "UpgradeSettlersStrike"
            end

            if Logic.GetEntityType(EntityID) == Entities.B_Theatre then
                local TheatrePlayProgress = Logic.GetTheatrePlayProgress(EntityID)

                if TheatrePlayProgress ~= 0 then
                    TooltipTextKeyDisabled = "UpgradeTheaterPlayRunning"
                end
            end

        elseif Logic.IsEntityInCategory(EntityID, EntityCategories.Outpost) == 1 then
            TooltipTextKey = "UpgradeOutpost"

            if Logic.BuildingDoWorkersStrike(EntityID) == true then
                TooltipTextKeyDisabled = "UpgradeSettlersStrike"
            end

        elseif Logic.IsEntityInCategory(EntityID, EntityCategories.Storehouse) == 1 then
            TooltipTextKey = "UpgradeStorehouse"

            if Logic.GetNumberOfEmployedWorkers(PlayerID) < 2 then
                TooltipTextKeyDisabled = "UpgradeStorehouseNoSettler"
            end

            local UpgradeLevel = Logic.GetUpgradeLevel(EntityID) + 1
            TechnologyType = TechnologyNeededForUpgrade[EntityCategories.Storehouse][UpgradeLevel]

        elseif Logic.IsEntityInCategory(EntityID, EntityCategories.Headquarters) == 1 then
            TooltipTextKey = "UpgradeCastle"

            if Logic.GetNumberOfEmployedWorkers(PlayerID) < 2 then
                TooltipTextKeyDisabled = "UpgradeCastleNoSettler"
            end

            local UpgradeLevel = Logic.GetUpgradeLevel(EntityID) + 1
            TechnologyType = TechnologyNeededForUpgrade[EntityCategories.Headquarters][UpgradeLevel]

        elseif Logic.IsEntityInCategory(EntityID, EntityCategories.Cathedrals) == 1 then
            TooltipTextKey = "UpgradeCathedral"

            if Logic.GetNumberOfEmployedWorkers(PlayerID) < 2 then
                TooltipTextKeyDisabled = "UpgradeCathedralNoSettler"
            end

            if Logic.IsSermonActive(PlayerID) == true then
                TooltipTextKeyDisabled = "UpgradeCathedralSermonRunning"
            end

            local UpgradeLevel = Logic.GetUpgradeLevel(EntityID) + 1
            TechnologyType = TechnologyNeededForUpgrade[EntityCategories.Cathedrals][UpgradeLevel]
        end
    end

    local CurrentHealth = Logic.GetEntityHealth(EntityID)
    local MaxHealth = Logic.GetEntityMaxHealth(EntityID)
    local Damage = MaxHealth - CurrentHealth

    if Logic.CanCancelUpgradeBuilding(EntityID) then
        UpgradeCosts = {}
        TooltipTextKey = TooltipTextKey .. "Cancel"
    end

    if Damage > 0
    and Logic.IsBuildingBeingUpgraded(EntityID) == false then
        TooltipTextKeyDisabled = "UpgradeDamaged"
    end

    if Logic.CanCancelKnockDownBuilding(EntityID) then
        TooltipTextKeyDisabled = "UpgradeKnockDown"
    end

    if Logic.TechnologyGetState(PlayerID, TechnologyType) == TechnologyStates.Locked
        or IsSpecificBuildingUpgradeLocked( PlayerID, EntityID ) then
        
        TooltipTextKeyDisabled = "UpgradeLevelLocked"
    end

    GUI_Tooltip.TooltipBuy(UpgradeCosts, TooltipTextKey, TooltipTextKeyDisabled)
end


function GUI_BuildingButtons.UpgradeUpdate()

    local CurrentWidgetID = XGUIEng.GetCurrentWidgetID()
    local PlayerID = GUI.GetPlayerID()

    local EntityID = GUI.GetSelectedEntity()
    
    if Logic.IsBuildingBeingKnockedDown(EntityID) == true then
        XGUIEng.ShowWidget(CurrentWidgetID, 0)
        return
    end

    if Logic.TechnologyGetState(PlayerID, Technologies.R_BuildingUpgrade) == TechnologyStates.Locked
        or IsSpecificBuildingUpgradeLocked( PlayerID, EntityID ) then
        
        XGUIEng.DisableButton(CurrentWidgetID, 1)
        return
    end

    local UpgradeLevel = Logic.GetUpgradeLevel(EntityID)
    local MaxUpgradeLevel = Logic.GetMaxUpgradeLevel(EntityID)

    local UpgradeIsPossible = false
    local IsBuilding = Logic.IsBuilding(EntityID)

    if IsBuilding == 1 then
        UpgradeIsPossible = Logic.IsBuildingUpgradable(EntityID,true)
    else
        XGUIEng.ShowWidget(CurrentWidgetID, 0)
        return
    end

    if Logic.IsConstructionComplete(EntityID) == 0 then
        if UpgradeLevel == 0
        and Logic.CanCancelUpgradeBuilding(EntityID) == false then
            UpgradeIsPossible = false
        end
    end

    if Logic.IsBurning(EntityID) then
        UpgradeIsPossible = false
    end

    if Logic.CanCancelKnockDownBuilding(EntityID) then
        UpgradeIsPossible = false
    end

    if UpgradeIsPossible == false then
        if Logic.CanCancelUpgradeBuilding(EntityID) then
            SetIcon(CurrentWidgetID, {4, 8})
            XGUIEng.DisableButton(CurrentWidgetID, 0)
        else
            -- only hide the button if upgrading isn't possible on principle, or the construction is incomplete
            if Logic.IsBuildingUpgradable(EntityID, true) == false
            or Logic.IsConstructionComplete(EntityID) == 0 then
                XGUIEng.ShowWidget(CurrentWidgetID, 0)
                return
            else
                XGUIEng.DisableButton(CurrentWidgetID, 1)
            end
        end
    else
        -- set texture
        if Logic.IsEntityInCategory(EntityID,EntityCategories.OuterRimBuilding) == 1 then
            SetIcon(CurrentWidgetID, {4, 4})
        elseif Logic.IsEntityInCategory(EntityID,EntityCategories.CityBuilding) == 1 then
            SetIcon(CurrentWidgetID, {4, 4})
        elseif Logic.IsEntityInCategory(EntityID,EntityCategories.Outpost) == 1 then
            SetIcon(CurrentWidgetID, {5, 1})
        else
            XGUIEng.ShowWidget(CurrentWidgetID, 0)
            return
        end

        if Logic.CanCancelUpgradeBuilding(EntityID) then
            -- set cancel texture
            if Logic.IsEntityInCategory(EntityID,EntityCategories.OuterRimBuilding) == 1 then
                SetIcon(CurrentWidgetID, {4, 8})
            elseif Logic.IsEntityInCategory(EntityID,EntityCategories.CityBuilding) == 1 then
                SetIcon(CurrentWidgetID, {4, 8})
            elseif Logic.IsEntityInCategory(EntityID,EntityCategories.Outpost) == 1 then
                SetIcon(CurrentWidgetID, {5, 4})
            end

            XGUIEng.DisableButton(CurrentWidgetID, 0)
        else
            if Logic.IsBuildingUpgradable(EntityID,false) == false then
                XGUIEng.DisableButton(CurrentWidgetID, 1)
            else
                if Logic.BuildingDoWorkersStrike(EntityID) == true then
                    XGUIEng.DisableButton(CurrentWidgetID, 1)
                else
                    XGUIEng.DisableButton(CurrentWidgetID, 0)
                end
            end
        end
    end
end


function GUI_BuildingButtons.GetUpgradeCosts()
    local EntityID = GUI.GetSelectedEntity()
    local Costs

    -- upgrade strands removed
    local UpgradePart = 0

    local GoldCost = Logic.GetBuildingUpgradeCostByGoodType(EntityID , Goods.G_Gold, UpgradePart)
    local StoneCost = Logic.GetBuildingUpgradeCostByGoodType(EntityID , Goods.G_Stone, UpgradePart)
    local WoodCost = Logic.GetBuildingUpgradeCostByGoodType(EntityID , Goods.G_Wood, UpgradePart)

    --if Logic.IsEntityInCategory(EntityID,EntityCategories.OuterRimBuilding) == 1 or Logic.IsEntityInCategory(EntityID,EntityCategories.CityBuilding) == 1 then
    --
    --    local PlayerID = GUI.GetPlayerID()
    --
    --    local parameter = Logic.GetKnightUpgradeAbilityModifier(PlayerID)
    --
    --    if parameter > 0 then
    --
    --        GoldCost = Round(GoldCost * parameter)
    --        StoneCost = Round(StoneCost * parameter)
    --        WoodCost = Round(WoodCost * parameter)
    --
    --    end
    --
    --end

    Costs = {Goods.G_Gold, GoldCost,
             Goods.G_Stone, StoneCost,
             Goods.G_Wood, WoodCost}

    return Costs
end


--------------------------------------------------------------------------------


function GUI_BuildingButtons.StartFestivalClicked(_FestivalIndex)

    local PlayerID = GUI.GetPlayerID()

    local Costs = {Logic.GetFestivalCost(PlayerID, _FestivalIndex)}
    local CanBuyBoolean, CanNotBuyString = AreCostsAffordable(Costs)

    local MarketID = GUI.GetSelectedEntity()

    -- AnSu: Why is this button displayed in front of the upgrade button sometimes, so it can happen, that the player makes a festival instead upgarding the selected building
    if MarketID ~= Logic.GetMarketplace(PlayerID) then
        return
    end

    --GUI.ClearMarketplace(MarketID)
    if CanBuyBoolean == true then

        Sound.FXPlay2DSound("ui\\menu_click")
        GUI.StartFestival(PlayerID, _FestivalIndex)
        StartEventMusic(MusicSystem.EventFestivalMusic, PlayerID)

        StartKnightVoiceForPermanentSpecialAbility(Entities.U_KnightSong)

        GUI.AddBuff(Buffs.Buff_Festival)

        if false then --g_OnGameStartPresentationMode then
            local StormSequenceID = Display.AddEnvironmentSettingsSequence("ME_Special_Sundawn.xml")
            Display.PlayEnvironmentSettingsSequence(StormSequenceID ,80 )
        end
    else
        Message(CanNotBuyString)
    end
end


function GUI_BuildingButtons.StartFestivalMouseOver(_FestivalIndex)

    local TooltipTextKeyDisabled

    local CurrentWidgetID = XGUIEng.GetCurrentWidgetID()
    local PlayerID = GUI.GetPlayerID()
    local Costs = {Logic.GetFestivalCost(PlayerID, _FestivalIndex)}
    --local TechnologyState = Logic.TechnologyGetState(PlayerID, Technologies.R_Festival)

    -- if disabled find out reason
    if XGUIEng.IsButtonDisabled(CurrentWidgetID) == 1 then
        if Logic.IsFestivalActive(PlayerID) == true then
            TooltipTextKeyDisabled = "StartFestivalCurrentlyRunning"
        elseif Logic.GetNumberOfEmployedWorkers(PlayerID) < 2 then
            TooltipTextKeyDisabled = "StartFestivalNoSettlers"
        else
            TooltipTextKeyDisabled = "StartFestivalMarketplaceNotFree"
        end
    end

    --and TechnologyState == TechnologyStates.Researched then
    --    if Logic.GetNumberOfEmployedWorkers(PlayerID) < 2 then
    --        TooltipTextKeyDisabled = "StartFestivalNoSettlers"
    --    elseif Logic.IsFestivalActive(PlayerID) == true then
    --        TooltipTextKeyDisabled = "StartFestivalCurrentlyRunning"
    --    else
    --        TooltipTextKeyDisabled = "StartFestivalMarketplaceNotFree"
    --    end
    --end

    GUI_Tooltip.TooltipBuy(Costs, nil, TooltipTextKeyDisabled, Technologies.R_Festival)
end


function GUI_BuildingButtons.StartFestivalUpdate(_FestivalIndex)

    local CurrentWidgetID = XGUIEng.GetCurrentWidgetID()

    local EntityID = GUI.GetSelectedEntity()
    local PlayerID = GUI.GetPlayerID()

    if Logic.GetMarketplace(PlayerID) ~= EntityID then
        XGUIEng.ShowWidget(CurrentWidgetID, 0)
        return
    end

    --if Logic.GetMarketplace(PlayerID) == EntityID then
    --    if Logic.IsFestivalActive(PlayerID) == false then
    --        XGUIEng.ShowWidget(CurrentWidgetID, 1)
    --    else
    --        XGUIEng.ShowWidget(CurrentWidgetID, 1) -- don't show button when festival is active?
    --    end
    --else
    --    XGUIEng.ShowWidget(CurrentWidgetID, 0)
    --    return
    --end

    if EnableRights == nil or EnableRights == false then
        XGUIEng.DisableButton(CurrentWidgetID, 0)
        return
    end

    if Logic.CanStartFestival(PlayerID, _FestivalIndex) == true
    and Logic.TechnologyGetState(PlayerID, Technologies.R_Festival) == TechnologyStates.Researched then
        XGUIEng.DisableButton(CurrentWidgetID, 0)
    else
        XGUIEng.DisableButton(CurrentWidgetID, 1)
    end
end


function GUI_BuildingButtons.GateOpenCloseClicked()

    Sound.FXPlay2DSound("ui\\menu_click")

    local EntityID = GUI.GetSelectedEntity()
    local WeaponHolder = Logic.GetWeaponHolder(EntityID)

    if WeaponHolder ~= nil then
        EntityID = WeaponHolder
    end

    if g_OnGameStartPresentationMode == true or XGUIEng.IsModifierPressed(Keys.ModifierControl) then
        GUI_BuildingButtons.GatesAllOpenCloseClicked()
    end

    if Logic.IsGateOpen (EntityID) == true then
        GUI.CloseGate(EntityID)
    else
        GUI.OpenGate(EntityID)
    end
end


function GUI_BuildingButtons.GatesAllOpenCloseClicked()

    Sound.FXPlay2DSound("ui\\menu_click")

    local PlayerID = GUI.GetPlayerID()
    local Gates = {Logic.GetPlayerEntitiesInCategory(PlayerID, EntityCategories.CityWallGate)}

    for i = 1, #Gates do
        local GateID = Gates[i]

        if Logic.IsGateOpen (GateID) == true then
            GUI.CloseGate(GateID)
        else
            GUI.OpenGate(GateID)
        end
    end
end


function GUI_BuildingButtons.GateOpenCloseMouseOver()
    local EntityID = GUI.GetSelectedEntity()
    local WeaponHolder = Logic.GetWeaponHolder(EntityID)

    if WeaponHolder ~= nil then
        EntityID = WeaponHolder
    end

    local TooltipTextKey

    if Logic.IsGateOpen(EntityID) == true then
        TooltipTextKey = "GateClose"
    else
        TooltipTextKey = "GateOpen"
    end

    GUI_Tooltip.TooltipNormal(TooltipTextKey)
end


function GUI_BuildingButtons.GateOpenCloseUpdate()
    local CurrentWidgetID = XGUIEng.GetCurrentWidgetID()

    -- gate buttons should be unnecessary now
    XGUIEng.ShowWidget(CurrentWidgetID, 0)

--    local EntityID = GUI.GetSelectedEntity()
--    local WeaponHolder = Logic.GetWeaponHolder(EntityID)
--
--    if WeaponHolder ~= nil then
--        EntityID = WeaponHolder
--    end
--
--    if Logic.IsGate(EntityID) == true then
--    --and Logic.IsGateInAutomaticMode(EntityID) == false then
--        if Logic.IsGateOpen(EntityID) == true then
--            SetIcon(CurrentWidgetID, {7, 15})
--        else
--            SetIcon(CurrentWidgetID, {7, 16})
--        end
--    else
--        XGUIEng.ShowWidget(CurrentWidgetID,0)
--    end
end


function GUI_BuildingButtons.GateAutoToggleClicked()

    Sound.FXPlay2DSound("ui\\menu_click")

    local EntityID = GUI.GetSelectedEntity()
    local WeaponHolder = Logic.GetWeaponHolder(EntityID)

    if WeaponHolder ~= nil then
        EntityID = WeaponHolder
    end

    local IsInAuto = Logic.IsGateInAutomaticMode(EntityID)

    if IsInAuto == true then
        GUI.SetGateAutomaticMode(EntityID, false)
        XGUIEng.ShowWidget("/InGame/Root/Normal/BuildingButtons/GateOpenClose",1)
    else
        GUI.SetGateAutomaticMode(EntityID, true)
    end
end


function GUI_BuildingButtons.GateAutoToggleMouseOver()
    local CurrentWidgetID = XGUIEng.GetCurrentWidgetID()
    local EntityID = GUI.GetSelectedEntity()
    local WeaponHolder = Logic.GetWeaponHolder(EntityID)

    if WeaponHolder ~= nil then
        EntityID = WeaponHolder
    end

    local TooltipTextKey

    if Logic.IsGateInAutomaticMode(EntityID) == true then
        TooltipTextKey = "GateAutoToggleCurrentlyAutomatic"
    else
        TooltipTextKey = "GateAutoToggleCurrentlyManual"
    end

    GUI_Tooltip.TooltipNormal(TooltipTextKey)
end


function GUI_BuildingButtons.GateAutoToggleUpdate()
    local CurrentWidgetID = XGUIEng.GetCurrentWidgetID()

    -- gate buttons should be unnecessary now
    XGUIEng.ShowWidget(CurrentWidgetID, 0)

--    local EntityID = GUI.GetSelectedEntity()
--    local WeaponHolder = Logic.GetWeaponHolder(EntityID)
--
--    if WeaponHolder ~= nil then
--        EntityID = WeaponHolder
--    end
--
--    if Logic.IsGate(EntityID) == true
--    or Logic.GetWeaponHolder(EntityID) ~= nil then
--        if Logic.IsGateInAutomaticMode(EntityID) == true then
--            SetIcon(CurrentWidgetID, {7, 14})
--            XGUIEng.ShowWidget("/InGame/Root/Normal/BuildingButtons/GateOpenClose", 0)
--        else
--            SetIcon(CurrentWidgetID, {7, 13})
--            XGUIEng.ShowWidget("/InGame/Root/Normal/BuildingButtons/GateOpenClose", 1)
--        end
--    else
--        XGUIEng.ShowWidget(CurrentWidgetID,0)
--    end
end


function GUI_BuildingButtons.ContinueWallClicked()

    Sound.FXPlay2DSound("ui\\menu_click")

    local TurretID = GUI.GetSelectedEntity()
    local WeaponSlotID = Logic.GetWeaponHolder(TurretID)

    if WeaponSlotID ~= nil then
        TurretID = WeaponSlotID
    end

    local TurretType = Logic.GetEntityType(TurretID)
    local UpgradeCategory = UpgradeCategories.PalisadeSegment

    if      TurretType ~= Entities.B_PalisadeTurret
        and TurretType ~= Entities.B_PalisadeGate_Turret_L
        and TurretType ~= Entities.B_PalisadeGate_Turret_R then
        UpgradeCategory = GetUpgradeCategoryForClimatezone( "WallSegment" )
    end

    GUI.DeselectEntity(TurretID)
    local x,y = Logic.GetEntityPosition(TurretID)
    GUI.ActivateContinuePlaceWallState(UpgradeCategory, x,y)
end


function GUI_BuildingButtons.ContinueWallMouseOver()

    local TurretID = GUI.GetSelectedEntity()
    local WeaponSlotID = Logic.GetWeaponHolder(TurretID)

    if WeaponSlotID ~= nil then
        TurretID = WeaponSlotID
    end

    local TurretType = Logic.GetEntityType(TurretID)
    local Costs
    local TooltipTextKey

    if      TurretType == Entities.B_PalisadeTurret
        or TurretType == Entities.B_PalisadeGate_Turret_L
        or TurretType == Entities.B_PalisadeGate_Turret_R then
        TooltipTextKey = "ContinuePalisade"
        Costs = {Goods.G_Wood, -1}
    else
        TooltipTextKey = "ContinueWall"
        Costs = {Goods.G_Stone, -1}

    end

    GUI_Tooltip.TooltipBuy(Costs, TooltipTextKey)
end


function GUI_BuildingButtons.ContinueWallUpdate()
    local CurrentWidgetID = XGUIEng.GetCurrentWidgetID()
    local EntityID = GUI.GetSelectedEntity()
    local IsInTurretCategory = Logic.IsEntityInCategory(EntityID, EntityCategories.Turret)
    local WeaponHolder = Logic.GetWeaponHolder(EntityID)
    local IsWeaponHolderGate

    if WeaponHolder ~= nil then
        IsWeaponHolderGate = Logic.IsGate(WeaponHolder)
    end

    if ( IsInTurretCategory == 1
    or (WeaponHolder ~= nil
    and IsWeaponHolderGate == false) )
    and Logic.IsBuildingBeingKnockedDown(EntityID) == false
    then
        XGUIEng.ShowWidget(CurrentWidgetID, 1)

        if Logic.GetWeaponHolder(EntityID) ~= nil then
            EntityID = Logic.GetWeaponHolder(EntityID)
        end

        local TurretType = Logic.GetEntityType(EntityID)

        if TurretType == Entities.B_PalisadeTurret
        or TurretType == Entities.B_PalisadeGate_Turret_L
        or TurretType == Entities.B_PalisadeGate_Turret_R then
            SetIcon(CurrentWidgetID, {3, 7})
        else
            SetIcon(CurrentWidgetID, {3, 9})
        end
    else
        XGUIEng.ShowWidget(CurrentWidgetID, 0)
    end
end


function GUI_BuildingButtons.UpgradeTurretClicked()

    local EntityID = GUI.GetSelectedEntity()
    local PlayerID = GUI.GetPlayerID()
    local WeaponTypeList = {Logic.GetWeaponTypeList(EntityID, 0)}
    local Costs = {Logic.GetEntityTypeFullCost(WeaponTypeList[1])}
    local CanBuyBoolean, CanNotBuyString = AreCostsAffordable(Costs)

    local IsReachable = CanEntityReachTarget(PlayerID, Logic.GetStoreHouse(PlayerID), EntityID, nil, PlayerSectorTypes.Civil)

    if IsReachable == false then
        local MessageText = XGUIEng.GetStringTableText("Feedback_TextLines/TextLine_GenericUnreachable")
        Message(MessageText)
        return
    end

    -- TODO: we assume that the building holds a single slot only
    if CanBuyBoolean == true then
        Sound.FXPlay2DSound("ui\\menu_click")
        SlotIdx = 0
        GUI.OrderDefenseWeapon(PlayerID, EntityID, SlotIdx, WeaponTypeList[1])
    else
        Message(CanNotBuyString)
    end
end


function GUI_BuildingButtons.UpgradeTurretMouseOver()

    local CurrentWidgetID = XGUIEng.GetCurrentWidgetID()
    local EntityID = GUI.GetSelectedEntity()
    local WeaponTypeList = {Logic.GetWeaponTypeList(EntityID, 0)}
    local Costs = {Logic.GetEntityTypeFullCost(WeaponTypeList[1])}

    local TooltipTextKey
    local Technology = Technologies.R_Ballista

    if WeaponTypeList[1] == Entities.U_MilitaryTrap then
        TooltipTextKey = "BuildStoneTrap"
        Technology = Technologies.R_Ballista -- stonetrap unlocked with ballista
    end

    GUI_Tooltip.TooltipBuy(Costs, TooltipTextKey, nil, Technologies.R_Ballista)
end


function GUI_BuildingButtons.UpgradeTurretUpdate()

    local CurrentWidgetID = XGUIEng.GetCurrentWidgetID()

    local EntityID = GUI.GetSelectedEntity()
    local EntityType = Logic.GetEntityType(EntityID)

    -- TODO: we assume that only one weapon slot is available per turret
    SlotIdx = 0

    if Logic.IsConstructionComplete(EntityID) == 1
    and Logic.IsBuildingBeingKnockedDown(EntityID) == false
    and Logic.HasWeaponSlot(EntityID) == true
    and Logic.HasAutomaticWeapon(EntityID) == false
    and Logic.IsWeaponCurrentlyDelivered(EntityID, SlotIdx) == false then

        --local WeaponSlotCount = Logic.GetWeaponSlotCount(EntityID)
        local WeaponTypeList = {Logic.GetWeaponTypeList(EntityID, 0)}

        if WeaponTypeList[1] == Entities.U_MilitaryTrap then
            SetIcon(CurrentWidgetID, {10, 6})
        elseif WeaponTypeList[1] == Entities.U_MilitaryBallista then
            SetIcon(CurrentWidgetID, {10, 5})
        end

        XGUIEng.ShowWidget(CurrentWidgetID, 1)

        if EnableRights == nil or EnableRights == false then
            XGUIEng.DisableButton(CurrentWidgetID, 0)
            return
        end

        local PlayerID = GUI.GetPlayerID()

        if Logic.TechnologyGetState(PlayerID,Technologies.R_Ballista) == TechnologyStates.Researched then
            XGUIEng.DisableButton(CurrentWidgetID, 0)
        else
            XGUIEng.DisableButton(CurrentWidgetID, 1)
        end
    else
        XGUIEng.ShowWidget(CurrentWidgetID, 0)
    end
end


--------------------------------------------------------------------------------
-- Stop Start Building

function GUI_BuildingButtons.StartStopBuildingUpdate()

    local CurrentWidgetID = XGUIEng.GetCurrentWidgetID()

    -- not used anymore
    do
        XGUIEng.ShowWidget(CurrentWidgetID, 0)
        return
    end

    --local EntityID = GUI.GetSelectedEntity()
    --
    --if Logic.IsBuildingStoppable(EntityID,true) == false
    --or  Logic.IsEntityInCategory(EntityID, EntityCategories.Cathedrals) == 1
    --or Logic.IsBurning(EntityID)
    ----or Logic.CanCancelUpgradeBuilding(EntityID)
    --or Logic.CanCancelKnockDownBuilding(EntityID) then
    --
    --    XGUIEng.ShowWidget(CurrentWidgetID,0)
    --else
    --    XGUIEng.ShowWidget(CurrentWidgetID,1)
    --
    --    if Logic.IsBuildingStopped(EntityID) == false then
    --        SetIcon(CurrentWidgetID, {4, 13})
    --    else
    --        SetIcon(CurrentWidgetID, {4, 12})
    --    end
    --end
end


function GUI_BuildingButtons.StartStopBuildingMouseOver()

    local EntityID = GUI.GetSelectedEntity()
    local TooltipTextKey

    if Logic.IsBuildingStopped(EntityID) == false then
        TooltipTextKey = "StopBuilding"
    else
        TooltipTextKey = "StartBuilding"
    end

    GUI_Tooltip.TooltipNormal(TooltipTextKey)
end


function GUI_BuildingButtons.StartStopBuildingClicked()

    local EntityID = GUI.GetSelectedEntity()
    local CurrentWidgetID = XGUIEng.GetCurrentWidgetID()

    Sound.FXPlay2DSound("ui\\menu_click")

    if Logic.IsBuildingStopped(EntityID) == true then
        GUI.SetStoppedState(EntityID, false)
    else
        GUI.SetStoppedState(EntityID, true)
    end

    XGUIEng.ShowAllSubWidgets("/InGame/Root/Normal/BuildingButtons",1)
end


--------------------------------------------------------------------------------
-- Place Field Button
function GUI_BuildingButtons.PlaceFieldClicked()

    Sound.FXPlay2DSound("ui\\menu_click")

    local CurrentWidgetID = XGUIEng.GetCurrentWidgetID()

    local EntityType = Logic.GetEntityType(GUI.GetSelectedEntity()  )

    local UpgradeCategory

    if EntityType == Entities.B_GrainFarm then
        UpgradeCategory = GetUpgradeCategoryForClimatezone( "GrainField" )
    elseif EntityType == Entities.B_Beekeeper then
        UpgradeCategory = UpgradeCategories.BeeHive
    elseif EntityType == Entities.B_CattleFarm then
        UpgradeCategory = UpgradeCategories.CattlePasture
    elseif EntityType == Entities.B_SheepFarm then
        UpgradeCategory = UpgradeCategories.SheepPasture
    end

    GUI_Construction.BuildClicked(UpgradeCategory)

    XGUIEng.HighLightButton(CurrentWidgetID, 0 )
end


function GUI_BuildingButtons.PlaceFieldUpdate()

    local EntityID = GUI.GetSelectedEntity()
    local CurrentWidgetID = XGUIEng.GetCurrentWidgetID()

    if Logic.IsEntityInCategory(EntityID, EntityCategories.FarmerBuilding) == 1 then
        XGUIEng.ShowWidget(CurrentWidgetID,1)
    else
        XGUIEng.ShowWidget(CurrentWidgetID,0)
        return
    end

    -- change texture

    local EntityType = Logic.GetEntityType(EntityID)

    if EntityType == Entities.B_GrainFarm then
        SetIcon(CurrentWidgetID, {14, 2})
    elseif  EntityType == Entities.B_Beekeeper then
        SetIcon(CurrentWidgetID, {14, 3})
    else
        SetIcon(CurrentWidgetID, {4, 16})
    end
end


function GUI_BuildingButtons.PlaceFieldMouseOver()

    local CurrentWidgetID = XGUIEng.GetCurrentWidgetID()

    local EntityType = Logic.GetEntityType(GUI.GetSelectedEntity()  )

    local FieldType
    local TooltipTextKey

    if EntityType == Entities.B_GrainFarm then
        FieldType = GetEntityTypeForClimatezone("B_GrainField")
        TooltipTextKey = "PlaceGrainField"
    elseif EntityType == Entities.B_Beekeeper then
        FieldType = Entities.B_Beehive
        TooltipTextKey = "PlaceBeehive"
    elseif EntityType == Entities.B_CattleFarm then
        FieldType = Entities.B_CattlePasture
        TooltipTextKey = "PlaceCattlePasture"
    elseif EntityType == Entities.B_SheepFarm then
        FieldType = Entities.B_SheepPasture
        TooltipTextKey = "PlaceSheepPasture"
    end

    local Costs = {Logic.GetEntityTypeFullCost(FieldType)}
    GUI_Tooltip.TooltipBuy(Costs, TooltipTextKey)
end


--------------------------------------------------------------------------------
-- Theatre

function GUI_BuildingButtons.StartTheatrePlayClicked()

    local PlayerID = GUI.GetPlayerID()
    local EntityID = GUI.GetSelectedEntity()
    local GoodType = Logic.GetGoodTypeOnOutStockByIndex(EntityID, 0)
    local Amount = Logic.GetMaxAmountOnStock(EntityID)
    local Costs = {GoodType, Amount}
    local CanBuyBoolean, CanNotBuyString = AreCostsAffordable(Costs)

    if Logic.CanStartTheatrePlay(EntityID) == true then

        Sound.FXPlay2DSound("ui\\menu_click")
        GUI.StartTheatrePlay(EntityID)
    elseif CanBuyBoolean == false then
        Message(CanNotBuyString)
    end
end


function GUI_BuildingButtons.StartTheatrePlayMouseOver()

    local CurrentWidgetID = XGUIEng.GetCurrentWidgetID()
    local EntityID = GUI.GetSelectedEntity()
    local GoodType = Logic.GetGoodTypeOnOutStockByIndex(EntityID, 0)
    local Amount = Logic.GetMaxAmountOnStock(EntityID)
    local Costs = {GoodType, Amount}
    local TooltipTextKeyDisabled

    if XGUIEng.IsButtonDisabled(CurrentWidgetID) == 1 then
        if Logic.CanCancelUpgradeBuilding(EntityID) == true then
            TooltipTextKeyDisabled = "StartTheatrePlayCurrentlyUpgrading"
        else
            local TheatrePlayProgress = Logic.GetTheatrePlayProgress(EntityID)

            if TheatrePlayProgress ~= 0 then
                TooltipTextKeyDisabled = "StartTheatrePlayCurrentlyRunning"
            end
        end
    end

    GUI_Tooltip.TooltipBuy(Costs, nil, TooltipTextKeyDisabled)
end


function GUI_BuildingButtons.StartTheatrePlayUpdate()

    local CurrentWidgetID = XGUIEng.GetCurrentWidgetID()

    -- check if we have really something selected
    local EntityID = GUI.GetSelectedEntity()

    if EntityID == nil
    or EntityID == 0
    or Logic.IsConstructionComplete(EntityID) == 0 then
        XGUIEng.ShowWidget(CurrentWidgetID, 0)
        return
    end

    -- get the entity type and test if we have selected a theatre
    local EntityType = Logic.GetEntityType(EntityID)

    if EntityType == Entities.B_Theatre then
        XGUIEng.ShowWidget(CurrentWidgetID,1)
        local TheatrePlayProgress = Logic.GetTheatrePlayProgress(EntityID)

        if TheatrePlayProgress ~= 0
        or Logic.CanCancelUpgradeBuilding(EntityID) == true then
            XGUIEng.DisableButton(CurrentWidgetID, 1)
        else
            XGUIEng.DisableButton(CurrentWidgetID, 0)
        end
    else
        XGUIEng.ShowWidget(CurrentWidgetID,0)
    end
end


--------------------------------------------------------------------------------
-- Cathedral

function GUI_BuildingButtons.StartSermonClicked()

    local PlayerID = GUI.GetPlayerID()

    if Logic.CanSermonBeActivated(PlayerID) then
        GUI.ActivateSermon(PlayerID)

        StartKnightVoiceForPermanentSpecialAbility(Entities.U_KnightHealing)

        GUI.AddBuff(Buffs.Buff_Sermon)

        local CathedralID = Logic.GetCathedral(PlayerID)
        local x, y = Logic.GetEntityPosition(CathedralID)
        local z = 0
        Sound.FXPlay3DSound("buildings\\building_start_sermon", x, y, z)
    end
end


function GUI_BuildingButtons.StartSermonMouseOver()

    local CurrentWidgetID = XGUIEng.GetCurrentWidgetID()
    local PlayerID = GUI.GetPlayerID()
    local EntityID = GUI.GetSelectedEntity()
    local TooltipTextKeyDisabled

    if Logic.CanSermonBeActivated(PlayerID) == false then
    --and Logic.TechnologyGetState(PlayerID,Technologies.R_Sermon) == TechnologyStates.Researched then

        if Logic.IsBuildingBeingUpgraded(EntityID) == true then
            TooltipTextKeyDisabled = "StartSermonCurrentlyUpgrading"

        elseif Logic.CanRepairAlarmBeActivated(EntityID) == true then
            TooltipTextKeyDisabled = "StartSermonCurrentlyDamaged"

        elseif Logic.IsSermonActive(PlayerID) == true then
            TooltipTextKeyDisabled = "StartSermonCurrentlyRunning"

        else
            TooltipTextKeyDisabled = "StartSermonNotReadyYet"
        end
    elseif XGUIEng.IsButtonDisabled(CurrentWidgetID) == 1 then
        TooltipTextKeyDisabled = "StartSermonNoSettler"
    end

    --GUI_Tooltip.TooltipNormal(nil, TooltipTextKeyDisabled)

    GUI_Tooltip.TooltipTechnology(Technologies.R_Sermon, nil, TooltipTextKeyDisabled)
end


function GUI_BuildingButtons.StartSermonUpdate()

    local CurrentWidgetID = XGUIEng.GetCurrentWidgetID()

    -- check if we have really something selected
    local EntityID = GUI.GetSelectedEntity()
    if (EntityID == nil) or (EntityID == 0) then
        XGUIEng.ShowWidget(CurrentWidgetID,0)
        return
    end

    -- get the entity type and test if we have selected a cathedral
    local EntityType = Logic.GetEntityType(EntityID)
    if (EntityType == Entities.B_Cathedral) or (EntityType == Entities.B_Cathedral_Big) then

        XGUIEng.ShowWidget(CurrentWidgetID,1)

        if EnableRights == nil or EnableRights == false then
            XGUIEng.DisableButton(CurrentWidgetID,0)
            return
        end

        local PlayerID = GUI.GetPlayerID()

        if (Logic.CanSermonBeActivated(PlayerID) == true)
        and Logic.TechnologyGetState(PlayerID,Technologies.R_Sermon) == TechnologyStates.Researched then
            XGUIEng.DisableButton(CurrentWidgetID, 0)
        else
            XGUIEng.DisableButton(CurrentWidgetID, 1)
        end

        local Settlers = Logic.GetNumberOfEmployedWorkers(PlayerID)

        if Settlers < 2 then
            XGUIEng.DisableButton(CurrentWidgetID, 1)
        end

    else
        -- no cathedral so hide the button
        XGUIEng.ShowWidget(CurrentWidgetID, 0)
    end
end


--------------------------------------------------------------------------------
-- Barracks

function GUI_BuildingButtons.BuyBattalionClicked(_IsSpecial)

    local PlayerID  = GUI.GetPlayerID()
    local BarrackID = GUI.GetSelectedEntity()
    local BarrackEntityType = Logic.GetEntityType(BarrackID)
    local KnightType = Logic.GetEntityType(Logic.GetKnightID(GUI.GetPlayerID()))
    local EntityType

    if BarrackEntityType == Entities.B_Barracks then
        if _IsSpecial == true then
            if KnightType == Entities.U_KnightSabatta or KnightType == Entities.U_KnightRedPrince then
                EntityType = Entities.U_MilitarySword_RedPrince
            elseif KnightType == Entities.U_KnightKhana then
                EntityType = Entities.U_MilitarySword_Khana
            end
        else
            EntityType = Entities.U_MilitarySword
        end
    elseif BarrackEntityType == Entities.B_BarracksArchers then
        if _IsSpecial == true then
            if KnightType == Entities.U_KnightSabatta or KnightType == Entities.U_KnightRedPrince then
                EntityType = Entities.U_MilitaryBow_RedPrince
            elseif KnightType == Entities.U_KnightKhana then
                EntityType = Entities.U_MilitaryBow_Khana
            end
        else
            EntityType = Entities.U_MilitaryBow
        end
    elseif Logic.IsEntityInCategory(BarrackID, EntityCategories.Headquarters) == 1 then
        EntityType = Entities.U_Thief
    else
        return
    end

    local Costs = {Logic.GetUnitCost(BarrackID, EntityType)}

    local CanBuyBoolean, CanNotBuyString = AreCostsAffordable(Costs)

    local CanProduce = Logic.CanProduceUnits(BarrackID, EntityType)

    if CanBuyBoolean == true
    and CanProduce == false then
        CanBuyBoolean = false
        CanNotBuyString = XGUIEng.GetStringTableText("Feedback_TextLines/TextLine_NotEnoughRoomToBuyMilitary")
    end

    local CurrentSoldierCount = Logic.GetCurrentSoldierCount(PlayerID)
    local CurrentSoldierLimit = Logic.GetCurrentSoldierLimit(PlayerID)

    local SoldierSize
    if EntityType == Entities.U_Thief then
        SoldierSize = 1
    else
        SoldierSize = Logic.GetBattalionSize(BarrackID)
    end

    if (CurrentSoldierCount + SoldierSize) > CurrentSoldierLimit then
        CanBuyBoolean = false
        CanNotBuyString = XGUIEng.GetStringTableText("Feedback_TextLines/TextLine_SoldierLimitReached")
    end

    if CanBuyBoolean == true then

        Sound.FXPlay2DSound("ui\\menu_click")
        if EntityType == Entities.U_Thief then
            GUI.BuyThief(PlayerID)
        else
            GUI.ProduceUnits(BarrackID, EntityType)
            StartKnightVoiceForPermanentSpecialAbility(Entities.U_KnightChivalry)
        end
    else
        Message(CanNotBuyString)
    end
end


function GUI_BuildingButtons.BuyBattalionMouseOver()
    local CurrentWidgetID = XGUIEng.GetCurrentWidgetID()
    local BarrackID = GUI.GetSelectedEntity()
    local BarrackEntityType = Logic.GetEntityType(BarrackID)
    local EntityType
    local TooltipString
    local TechnologyType

    if BarrackEntityType == Entities.B_Barracks then
        EntityType = Entities.U_MilitarySword
        TooltipString = "BuySwordfighters"
        TechnologyType = Technologies.R_Barracks
    elseif BarrackEntityType == Entities.B_BarracksArchers then
        EntityType = Entities.U_MilitaryBow
        TooltipString = "BuyBowmen"
        TechnologyType = Technologies.R_BarracksArchers
    elseif BarrackEntityType == Entities.B_StoreHouse then
        EntityType = Entities.U_AmmunitionCart
        TooltipString = "BuyAmmunitionCart"
        TechnologyType = Technologies.R_AmmunitionCart
    elseif Logic.IsEntityInCategory(BarrackID, EntityCategories.Headquarters) == 1 then
        EntityType = Entities.U_Thief
        TechnologyType = Technologies.R_Thieves
        TooltipString = "BuyThief"
    else
        return
    end

    local Costs = {Logic.GetUnitCost(BarrackID, EntityType)}

    --Marcus buys these for less Gold
    --  if EntityType == Entities.U_MilitarySword
    --  or EntityType == Entities.U_MilitaryBow then
    --      local GoldCost = Logic.GetUnitCost(BarrackID, EntityType)
    --
    --      for i = 1, #Costs, 2 do
    --          if Costs[i] == Goods.G_Gold then
    --              Costs[i + 1] = GoldCost
    --              break
    --        end
    --      end
    --  end

    local TooltipStringDisabled

    if XGUIEng.IsButtonDisabled(CurrentWidgetID) == 1
    and EntityType == Entities.U_Thief then
        TooltipStringDisabled = "BuyThief"
    end

    GUI_Tooltip.TooltipBuy(Costs, TooltipString, TooltipStringDisabled, TechnologyType )
end


function GUI_BuildingButtons.BuyBattalionUpdate(_IsSpecial)
    local CurrentWidgetID = XGUIEng.GetCurrentWidgetID()
    local BarrackID = GUI.GetSelectedEntity()
    local BarrackEntityType = Logic.GetEntityType(BarrackID)
    local KnightType = Logic.GetEntityType(Logic.GetKnightID(GUI.GetPlayerID()))
    local doShow = 1

    if BarrackEntityType == Entities.B_BarracksArchers then
        if _IsSpecial == true then
            if KnightType == Entities.U_KnightSabatta or KnightType == Entities.U_KnightRedPrince then
                SetIcon(CurrentWidgetID, g_TexturePositions.Entities[Entities.U_MilitaryBow_RedPrince])
            elseif KnightType == Entities.U_KnightKhana then
                SetIcon(CurrentWidgetID, g_TexturePositions.Entities[Entities.U_MilitaryBow_Khana])
            else
                doShow = 0
            end
        else
            SetIcon(CurrentWidgetID, g_TexturePositions.Entities[Entities.U_MilitaryBow])
        end
    elseif Logic.IsEntityInCategory(BarrackID, EntityCategories.Headquarters) == 1 then
        SetIcon(CurrentWidgetID, g_TexturePositions.Entities[Entities.U_Thief])
        if _IsSpecial == true then
            doShow = 0
        end
    else
        if _IsSpecial == true then
            if KnightType == Entities.U_KnightSabatta or KnightType == Entities.U_KnightRedPrince then
                SetIcon(CurrentWidgetID, g_TexturePositions.Entities[Entities.U_MilitarySword_RedPrince])
            elseif KnightType == Entities.U_KnightKhana then
                SetIcon(CurrentWidgetID, g_TexturePositions.Entities[Entities.U_MilitarySword_Khana])
            else
                doShow = 0
            end
        else
            SetIcon(CurrentWidgetID, g_TexturePositions.Entities[Entities.U_MilitarySword])
        end
    end

    if BarrackEntityType == Entities.B_Barracks
    or BarrackEntityType == Entities.B_BarracksArchers
    or Logic.IsEntityInCategory(BarrackID, EntityCategories.Headquarters) == 1 then
        XGUIEng.ShowWidget(CurrentWidgetID,doShow)
    else
        XGUIEng.ShowWidget(CurrentWidgetID,0)
        return
    end

    if Logic.IsConstructionComplete(GUI.GetSelectedEntity()) == 0 then
        XGUIEng.ShowWidget(CurrentWidgetID,0)
    end

    -- technology check necessary only for thief
    if Logic.IsEntityInCategory(BarrackID, EntityCategories.Headquarters) == 1 then
        local PlayerID = GUI.GetPlayerID()
        local TechnologyState = Logic.TechnologyGetState(PlayerID, Technologies.R_Thieves)

        if EnableRights == nil or EnableRights == false then
            XGUIEng.DisableButton(CurrentWidgetID,0)
            return
        end

        if TechnologyState == TechnologyStates.Locked then
            XGUIEng.ShowWidget(CurrentWidgetID,0)
        end

        if TechnologyState == TechnologyStates.Researched then
            XGUIEng.DisableButton(CurrentWidgetID,0)
        else
            XGUIEng.DisableButton(CurrentWidgetID,1)
        end
    else
        XGUIEng.DisableButton(CurrentWidgetID,0)
    end
end


function GUI_BuildingButtons.BuySiegeEngineCartClicked(_EntityType)

    local WorkshopID = GUI.GetSelectedEntity()
    local EntityType = Logic.GetEntityType(WorkshopID)

    if EntityType ~= Entities.B_SiegeEngineWorkshop then
        return
    end

    local Costs = {Logic.GetUnitCost(WorkshopID, _EntityType)}

    local CanBuyBoolean, CanNotBuyString = AreCostsAffordable(Costs)

    local CanProduce = Logic.CanProduceUnits(WorkshopID, EntityType)

    if CanBuyBoolean == true
    and CanProduce == false then
        CanBuyBoolean = false
        CanNotBuyString = XGUIEng.GetStringTableText("Feedback_TextLines/TextLine_NotEnoughRoomToBuyMilitary")
    end

    if CanBuyBoolean == true then
        Sound.FXPlay2DSound("ui\\menu_click")
        GUI.ProduceUnits(WorkshopID, _EntityType)
    else
        Message(CanNotBuyString)
    end
end


function GUI_BuildingButtons.BuySiegeEngineCartMouseOver(_EntityType,_TechnologyType)

    local CurrentWidgetID = XGUIEng.GetCurrentWidgetID()
    local BarrackID = GUI.GetSelectedEntity()
    local BuildingEntityType = Logic.GetEntityType(BarrackID)

    if BuildingEntityType ~= Entities.B_SiegeEngineWorkshop then
        return
    end

    local Costs = {Logic.GetUnitCost(BarrackID, _EntityType)}
    GUI_Tooltip.TooltipBuy(Costs,nil,nil,_TechnologyType)
end


function GUI_BuildingButtons.BuySiegeEngineCartUpdate(_Technology)

    local PlayerID = GUI.GetPlayerID()
    local CurrentWidgetID = XGUIEng.GetCurrentWidgetID()
    local EntityID = GUI.GetSelectedEntity()
    local EntityType = Logic.GetEntityType(EntityID)

    if EntityType == Entities.B_SiegeEngineWorkshop then
        XGUIEng.ShowWidget(CurrentWidgetID,1)
    else
        XGUIEng.ShowWidget(CurrentWidgetID,0)
        return
    end

    if Logic.IsConstructionComplete(GUI.GetSelectedEntity()) == 0 then
        XGUIEng.ShowWidget(CurrentWidgetID,0)
        return
    end

    local TechnologyState = Logic.TechnologyGetState(PlayerID, _Technology)

    if EnableRights == nil or EnableRights == false then
        XGUIEng.DisableButton(CurrentWidgetID,0)
        return
    end

    if TechnologyState == TechnologyStates.Researched then
        XGUIEng.DisableButton(CurrentWidgetID,0)
    else
        XGUIEng.DisableButton(CurrentWidgetID,1)
    end
end


-- Buy ammunition cart
function GUI_BuildingButtons.BuyAmmunitionCartClicked()
    local StorehouseID = GUI.GetSelectedEntity()

    if StorehouseID ~= Logic.GetStoreHouse(GUI.GetPlayerID())then
        return
    end

    local Costs = {Logic.GetUnitCost(StorehouseID, Entities.U_AmmunitionCart)}

    local CanBuyBoolean, CanNotBuyString = AreCostsAffordable(Costs)

    --local CanProduce = Logic.CanProduceUnits(StorehouseID, Entities.U_AmmunitionCart)
    --
    --if CanBuyBoolean == true
    --and CanProduce == false then
    --    CanBuyBoolean = false
    --    CanNotBuyString = "No room for battalion!"
    --end

    if CanBuyBoolean == true then
        Sound.FXPlay2DSound("ui\\menu_click")
        GUI.BuyAmmunitionCart()
    else
        Message(CanNotBuyString)
    end
end


function GUI_BuildingButtons.BuyAmmunitionCartUpdate()

    local CurrentWidgetID = XGUIEng.GetCurrentWidgetID()
    local PlayerID = GUI.GetPlayerID()
    local EntityID = GUI.GetSelectedEntity()

    if EntityID == Logic.GetStoreHouse(PlayerID) then
        XGUIEng.ShowWidget(CurrentWidgetID,1)
    else
        XGUIEng.ShowWidget(CurrentWidgetID,0)
        return
    end

    if Logic.IsConstructionComplete(GUI.GetSelectedEntity()) == 0 then
        XGUIEng.ShowWidget(CurrentWidgetID,0)
    end

    if Logic.IsConstructionComplete(GUI.GetSelectedEntity()) == 0 then
        XGUIEng.DisableButton(CurrentWidgetID,1)
    else
        XGUIEng.DisableButton(CurrentWidgetID,0)
    end

    local TechnologyState = Logic.TechnologyGetState(PlayerID, Technologies.R_Ballista)

    if EnableRights == nil or EnableRights == false then
        XGUIEng.DisableButton(CurrentWidgetID,0)
        return
    end

    if TechnologyState == TechnologyStates.Locked then
        XGUIEng.ShowWidget(CurrentWidgetID,0)
    end

    if TechnologyState == TechnologyStates.Researched then
        XGUIEng.DisableButton(CurrentWidgetID,0)
    else
        XGUIEng.DisableButton(CurrentWidgetID,1)
    end
end


--------------------------------------------------------------------------------
-- Stone Trap

function GUI_BuildingButtons.TrapTriggerClicked()

    Sound.FXPlay2DSound("ui\\menu_click")

    local PlayerID = GUI.GetPlayerID()
    local EntityID = GUI.GetSelectedEntity()

    if Logic.GetEntityType(EntityID) ~= Entities.U_MilitaryTrap then
        Trap = Logic.GetTrap(EntityID)
        GUI.TriggerTrap(PlayerID, Trap)
    else
        GUI.TriggerTrap(PlayerID, EntityID)
    end

end


function GUI_BuildingButtons.TrapTriggerUpdate()
    local CurrentWidgetID = XGUIEng.GetCurrentWidgetID()
    local EntityID = GUI.GetSelectedEntity()

    -- (Logic.GetEntityType(EntityID) ~= Entities.U_MilitaryTrap) -- not a trap
    if (not Logic.IsWall(EntityID) or not Logic.IsGate(EntityID)) -- not a gate
    or ((Logic.IsWall(EntityID) or Logic.IsGate(EntityID)) and (Logic.GetTrap(EntityID) == nil or Logic.GetTrap(EntityID) == 0 )) then --a gate but no trap
        XGUIEng.ShowWidget(CurrentWidgetID, 0)
    end
end


function GUI_BuildingButtons.TrapToggleClicked()

    Sound.FXPlay2DSound("ui\\menu_click")

    local PlayerID = GUI.GetPlayerID()
    local EntityID = GUI.GetSelectedEntity()
    local IsAutomatic = Logic.IsTrapInAutomaticMode(EntityID)

    if IsAutomatic == true then
        GUI.SwitchTrapToManualMode(PlayerID, EntityID)
    else
        GUI.SwitchTrapToAutomaticMode(PlayerID, EntityID)
    end
end


function GUI_BuildingButtons.TrapToggleMouseOver()
    local PlayerID = GUI.GetPlayerID()
    local EntityID = GUI.GetSelectedEntity()
    local IsAutomatic = Logic.IsTrapInAutomaticMode(EntityID)
    local TooltipTextKey

    if IsAutomatic == true then
        TooltipTextKey = "TrapToggleCurrentlyAutomatic"
    else
        TooltipTextKey = "TrapToggleCurrentlyManual"
    end

    GUI_Tooltip.TooltipNormal(TooltipTextKey)
end


function GUI_BuildingButtons.TrapToggleUpdate()
    local CurrentWidgetID = XGUIEng.GetCurrentWidgetID()

    -- automatic mode button not desired
    XGUIEng.ShowWidget(CurrentWidgetID, 0)

    --local EntityID = GUI.GetSelectedEntity()
    --
    --if Logic.GetEntityType(EntityID) ~= Entities.U_MilitaryTrap then
    --    XGUIEng.ShowWidget(CurrentWidgetID, 0)
    --end
end


--------------------------------------------------------------------------------
-- Fire Alarm


function GUI_BuildingButtons.StartStopFireAlarmClicked()

    local CurrentWidgetID = XGUIEng.GetCurrentWidgetID()
    local EntityID = GUI.GetSelectedEntity()

    if Logic.IsFireAlarmActiveAtBuilding(EntityID) == true then
        GUI.SetFireAlarm(EntityID, false)
    else
        GUI.SetFireAlarm(EntityID, true)
        local x, y = Logic.GetEntityPosition(EntityID)
        local z = 0
        Sound.FXPlay3DSound("buildings\\building_alarm", x, y, z)
    end
end


function GUI_BuildingButtons.StartStopFireAlarmMouseOver()

    local EntityID = GUI.GetSelectedEntity()
    local TooltipTextKey

    if Logic.IsFireAlarmActiveAtBuilding(EntityID) == false then
        TooltipTextKey = "StartFireAlarm"
    else
        TooltipTextKey = "StopFireAlarm"
    end

    GUI_Tooltip.TooltipNormal(TooltipTextKey)
end


function GUI_BuildingButtons.StartStopFireAlarmUpdate()

    local CurrentWidgetID = XGUIEng.GetCurrentWidgetID()
    local EntityID = GUI.GetSelectedEntity()

    if EntityID == nil then
        return
    end

    if Logic.CanFireAlarmBeActivated(EntityID) == false
    and Logic.IsFireAlarmActiveAtBuilding(EntityID) == false then
        XGUIEng.ShowWidget(CurrentWidgetID, 0)
    else
        XGUIEng.ShowWidget(CurrentWidgetID, 1)

        if Logic.IsFireAlarmActiveAtBuilding(EntityID) == false then
            SetIcon(CurrentWidgetID, {6, 15})
        else
            SetIcon(CurrentWidgetID, {6, 16})
        end
    end
end


--------------------------------------------------------------------------------
-- Repair Alarm

function GUI_BuildingButtons.StartStopRepairAlarmClicked()

    local EntityID = GUI.GetSelectedEntity()
    local CurrentWidgetID = XGUIEng.GetCurrentWidgetID()

    if Logic.IsRepairAlarmActiveAtBuilding(EntityID) == true then
        GUI.SetRepairAlarm(EntityID, false)
    else
        GUI.SetRepairAlarm(EntityID, true)
        local x, y = Logic.GetEntityPosition(EntityID)
        local z = 0
        Sound.FXPlay3DSound("buildings\\building_alarm", x, y, z)
    end
end


function GUI_BuildingButtons.StartStopRepairAlarmMouseOver()

    local EntityID = GUI.GetSelectedEntity()
    local TooltipTextKey

    if Logic.IsRepairAlarmActiveAtBuilding(EntityID) == false then
        TooltipTextKey = "StartRepairAlarm"
    else
        TooltipTextKey = "StopRepairAlarm"
    end

    GUI_Tooltip.TooltipNormal(TooltipTextKey)
end


function GUI_BuildingButtons.StartStopRepairAlarmUpdate()

    local EntityID = GUI.GetSelectedEntity()
    local CurrentWidgetID = XGUIEng.GetCurrentWidgetID()

    if EntityID == nil then
        return
    end

    if Logic.CanRepairAlarmBeActivated(EntityID) == false
    and Logic.IsRepairAlarmActiveAtBuilding(EntityID) == false then
        XGUIEng.ShowWidget(CurrentWidgetID, 0)
    else
        XGUIEng.ShowWidget(CurrentWidgetID, 1)

        if Logic.IsRepairAlarmActiveAtBuilding(EntityID) == false then
            SetIcon(CurrentWidgetID, {6, 13})
        else
            SetIcon(CurrentWidgetID, {6, 14})
        end
    end
end

function IsSpecificBuildingUpgradeLocked( _PlayerID, _EntityID )
    return Mission_Callback_IsSpecificBuildingUpgradeLocked and Mission_Callback_IsSpecificBuildingUpgradeLocked( _PlayerID, _EntityID )
end
