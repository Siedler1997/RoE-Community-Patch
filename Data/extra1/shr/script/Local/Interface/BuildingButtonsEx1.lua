GUI_BuildingButtons.EntitiesWithLimit = {
    [Entities.U_Thief]              = 6,
    [Entities.U_MilitaryBallista]   = 12,
}

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
    
    if GUI_BuildingButtons.GetLimitReached(Entities.U_MilitaryBallista, Entities.U_MilitaryBallista_BuildingSite) then
        Message(XGUIEng.GetStringTableText("Feedback_TextLines/TextLine_EntityLimitReached"))
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
    local EntityLimitString = GUI_BuildingButtons.GetLimitString(Entities.U_MilitaryBallista, Entities.U_MilitaryBallista_BuildingSite)
    local Costs = {Logic.GetEntityTypeFullCost(WeaponTypeList[1])}

    local TooltipTextKey
    local Technology = Technologies.R_Ballista

    if WeaponTypeList[1] == Entities.U_MilitaryTrap then
        TooltipTextKey = "BuildStoneTrap"
        Technology = Technologies.R_Ballista -- stonetrap unlocked with ballista
    end

    GUI_Tooltip.TooltipBuy(Costs, TooltipTextKey, nil, Technologies.R_Ballista, nil, nil, EntityLimitString)
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

        if GUI_BuildingButtons.GetLimitReached(Entities.U_MilitaryBallista, Entities.U_MilitaryBallista_BuildingSite) then
            XGUIEng.DisableButton(CurrentWidgetID, 1)
            return
        end

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
-- Barracks

-- BuyBattalion for first tier units and their special deviants
function GUI_BuildingButtons.BuyBattalionClicked(_tier, _special)

    local PlayerID  = GUI.GetPlayerID()
    local BarrackID = GUI.GetSelectedEntity()
    local BarrackEntityType = Logic.GetEntityType(BarrackID)
    local KnightId = Logic.GetKnightID(GUI.GetPlayerID())
    local specialUnitType = GetKnightSpecialBattalionType(KnightId, BarrackID, _tier, _special)
    local EntityType
    
    if _special == true and specialUnitType > 0 then
        EntityType = specialUnitType
    else
        if BarrackEntityType == Entities.B_Barracks or BarrackEntityType == Entities.B_Barracks_RedPrince or BarrackEntityType == Entities.B_Barracks_Khana then
            EntityType = Entities.U_MilitarySword
        elseif BarrackEntityType == Entities.B_BarracksArchers or BarrackEntityType == Entities.B_BarracksArchers_Redprince or BarrackEntityType == Entities.B_BarracksArchers_Khana then
            EntityType = Entities.U_MilitaryBow
        elseif BarrackEntityType == Entities.B_BarracksSpearmen then
            EntityType = Entities.U_MilitarySpear
        elseif Logic.IsEntityInCategory(BarrackID, EntityCategories.Headquarters) == 1 then
            EntityType = Entities.U_Thief
        else
            return
        end
    end

    local Costs = {Logic.GetUnitCost(BarrackID, EntityType)}

    local CanBuyBoolean, CanNotBuyString = AreCostsAffordable(Costs)

    local CanProduce = Logic.CanProduceUnits(BarrackID, EntityType)

    if CanBuyBoolean == true and CanProduce == false then
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

function GUI_BuildingButtons.BuyBattalionMouseOver(_tier, _special)
    local CurrentWidgetID = XGUIEng.GetCurrentWidgetID()
    local BarrackID = GUI.GetSelectedEntity()
    local BarrackEntityType = Logic.GetEntityType(BarrackID)
    local KnightId = Logic.GetKnightID(GUI.GetPlayerID())
    local EntityType = GetKnightSpecialBattalionType(KnightId, BarrackID, _tier, _special)
    local TooltipString
    local TechnologyType

    if BarrackEntityType == Entities.B_Barracks or BarrackEntityType == Entities.B_Barracks_RedPrince or BarrackEntityType == Entities.B_Barracks_Khana then
        --EntityType = Entities.U_MilitarySword
        TechnologyType = Technologies.R_Barracks
    elseif BarrackEntityType == Entities.B_BarracksArchers or BarrackEntityType == Entities.B_BarracksArchers_Redprince or BarrackEntityType == Entities.B_BarracksArchers_Khana then
        --EntityType = Entities.U_MilitaryBow
        TechnologyType = Technologies.R_BarracksArchers
    elseif BarrackEntityType == Entities.B_BarracksSpearmen then
        --EntityType = Entities.U_MilitarySpear
        TechnologyType = Technologies.R_BarracksSpearmen
    elseif BarrackEntityType == Entities.B_StoreHouse then
        --EntityType = Entities.U_AmmunitionCart
        TechnologyType = Technologies.R_AmmunitionCart
    elseif Logic.IsEntityInCategory(BarrackID, EntityCategories.Headquarters) == 1 then
        --EntityType = Entities.U_Thief
        TechnologyType = Technologies.R_Thieves
    else
        return
    end

    TooltipString = GetBattalionBuyTooltipString(EntityType)

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

    if XGUIEng.IsButtonDisabled(CurrentWidgetID) == 1 and EntityType == Entities.U_Thief then
        TooltipStringDisabled = "BuyThief"
    end

    GUI_Tooltip.TooltipBuy(Costs, TooltipString, TooltipStringDisabled, TechnologyType )
end

function GUI_BuildingButtons.BuyBattalionUpdate(_tier, _special)

    local CurrentWidgetID = XGUIEng.GetCurrentWidgetID()
    local BarrackID = GUI.GetSelectedEntity()
    local BarrackEntityType = Logic.GetEntityType(BarrackID)
    local KnightId = Logic.GetKnightID(GUI.GetPlayerID())
    local battalionType = GetKnightSpecialBattalionType(KnightId, BarrackID, _tier, _special)
    local doShow = 1
    
    SetIcon(CurrentWidgetID, g_TexturePositions.Entities[battalionType])

    if battalionType > 0 then
        XGUIEng.ShowWidget(CurrentWidgetID,1)
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

-- New funcs
function GUI_BuildingButtons.GetLimitReached(_entityType, _secondEntityType)
    local PlayerID  = GUI.GetPlayerID()
    local limitReached = false
    local numberOfEntities = Logic.GetNumberOfEntitiesOfTypeOfPlayer(PlayerID, _entityType)
    local maxNumberOfEntities = GUI_BuildingButtons.EntitiesWithLimit[_entityType]

    --Some entities have a buildingSite...
    local numberOfEntities2 = 0 
    if _secondEntityType ~= nil then
        numberOfEntities2 = Logic.GetNumberOfEntitiesOfTypeOfPlayer(PlayerID, _secondEntityType)
    end
    
    if maxNumberOfEntities ~= nil then
        if numberOfEntities + numberOfEntities2 >= maxNumberOfEntities then
            limitReached = true
        end
    end
    return limitReached
end

function GUI_BuildingButtons.GetLimitString(_entityType, _secondEntityType)
    local PlayerID  = GUI.GetPlayerID()
    local limitString = ""        
    
    local numberOfEntities = Logic.GetNumberOfEntitiesOfTypeOfPlayer(PlayerID, _entityType)
    local maxNumberOfEntities = GUI_BuildingButtons.EntitiesWithLimit[_entityType]

    --Some entities have a buildingSite...
    local numberOfEntities2 = 0 
    if _secondEntityType ~= nil then
        numberOfEntities2 = Logic.GetNumberOfEntitiesOfTypeOfPlayer(PlayerID, _secondEntityType)
    end

    if maxNumberOfEntities ~= nil then
        local maxNumberColor = ""
        local sumOfEntities = numberOfEntities + numberOfEntities2
        if sumOfEntities >= maxNumberOfEntities then
            maxNumberColor = "{@color:220, 0, 0}"
        end
        limitString = limitString .. " ("..maxNumberColor..sumOfEntities.."/"..maxNumberOfEntities.."{@color:none})"
    end

    return limitString
end