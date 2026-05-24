
GUI_BuildingButtons.EntitiesWithLimit = {
    [Entities.U_Thief]              = 6,
    [Entities.U_MilitaryBallista]   = 12,
}

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

-----------------------------------------------------------------------------------------
-- Overwrites for BuildingButtons
-----------------------------------------------------------------------------------------

function InitOverwriteBuildingButtonsEx2()

    do
        function GUI_BuildingButtons.UpgradeSpecialBuildingUpdate()
            local CurrentWidgetID = XGUIEng.GetCurrentWidgetID()
            local EntityID = GUI.GetSelectedEntity()
            local EntityType = Logic.GetEntityType(EntityID)
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
            and (Logic.IsBuildingUpgradable(EntityID, true) == false 
            or Logic.IsConstructionComplete(EntityID) == 0))) then
                XGUIEng.ShowWidget(CurrentWidgetID, 0)
                return
            else
                -- set texture or do not show button
                if EntityID == Logic.GetHeadquarters(PlayerID) then
                    SetIcon(CurrentWidgetID, {4, 7})

                elseif EntityID == Logic.GetStoreHouse(PlayerID) then
                    SetIcon(CurrentWidgetID, {4, 6})

                elseif EntityID == Logic.GetCathedral(PlayerID) or EntityType == Entities.B_Beautification_Cathedral then
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
    end

    do
        function GUI_BuildingButtons.UpgradeMouseOver()

            local TooltipTextKey
            local TooltipTextKeyDisabled

            local CurrentWidgetID = XGUIEng.GetCurrentWidgetID()
            local PlayerID = GUI.GetPlayerID()
            local EntityID = GUI.GetSelectedEntity()
            local EntityType = Logic.GetEntityType(EntityID)

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

                elseif EntityType == Entities.B_Beautification_Cathedral then
                    TooltipTextKey = "UpgradeBeutification"

                    if Logic.GetNumberOfEmployedWorkers(PlayerID) < 2 then
                        TooltipTextKeyDisabled = "UpgradeCathedralNoSettler"
                    end

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
    end

    do
        local GUI_BuildingButtons_OldUpgradeTurretClicked = GUI_BuildingButtons.UpgradeTurretClicked
        function GUI_BuildingButtons.UpgradeTurretClicked()
            if GUI_BuildingButtons.GetLimitReached(Entities.U_MilitaryBallista, Entities.U_MilitaryBallista_BuildingSite) then
                Message(XGUIEng.GetStringTableText("Feedback_TextLines/TextLine_EntityLimitReached"))
                return
            else
                GUI_BuildingButtons_OldUpgradeTurretClicked()
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
    end

    do
        function GUI_BuildingButtons.ContinueWallClicked()

            Sound.FXPlay2DSound("ui\\menu_click")

            local TurretID = GUI.GetSelectedEntity()
            local WeaponSlotID = Logic.GetWeaponHolder(TurretID)

            if WeaponSlotID ~= nil then
                TurretID = WeaponSlotID
            end

            local TurretType = Logic.GetEntityType(TurretID)
            local UpgradeCategory = UpgradeCategories.PalisadeSegment

            if TurretType ~= Entities.B_PalisadeTurret and TurretType ~= Entities.B_PalisadeGate_Turret_L and TurretType ~= Entities.B_PalisadeGate_Turret_R then
                if Logic.IsEntityInCategory(TurretID,EntityCategories.Fence) == 1 then
                    if TurretType == Entities.B_FenceTurret then
                        UpgradeCategory = UpgradeCategories.FenceSegment
                    else
                        UpgradeCategory = GetUpgradeCategoryForClimatezone( "WallSegment_NPC" )
                    end
                else
                    UpgradeCategory = GetUpgradeCategoryForClimatezone( "WallSegment" )
                end
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

            if TurretType == Entities.B_PalisadeTurret or TurretType == Entities.B_PalisadeGate_Turret_L or TurretType == Entities.B_PalisadeGate_Turret_R then
                TooltipTextKey = "ContinuePalisade"
                Costs = {Goods.G_Wood, -1}
            elseif Logic.IsEntityInCategory(TurretID,EntityCategories.Fence) == 1 then 
                if TurretType == Entities.B_FenceTurret then
                    TooltipTextKey = "ContinueFence"
                    Costs = {Goods.G_Wood, -1}
                else
                    TooltipTextKey = "ContinueNPCWall"
                    Costs = {Goods.G_Stone, -1}
                end
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
                or TurretType == Entities.B_PalisadeGate_Turret_R
                or TurretType == Entities.B_FenceTurret then
                    SetIcon(CurrentWidgetID, {3, 7})
                else
                    SetIcon(CurrentWidgetID, {3, 9})
                end
            else
                XGUIEng.ShowWidget(CurrentWidgetID, 0)
            end
        end
    end

    do
        function GUI_BuildingButtons.BuyBattalionClicked(_unitType)
            local PlayerID  = GUI.GetPlayerID()
            local BarrackID = GUI.GetSelectedEntity()
            local BarrackEntityType = Logic.GetEntityType(BarrackID)
            local KnightType = Logic.GetEntityType(Logic.GetKnightID(GUI.GetPlayerID()))

            if (KnightType == Entities.U_KnightSabatta or KnightType == Entities.U_KnightRedPrince or BarrackEntityType == Entities.B_Barracks_RedPrince or BarrackEntityType == Entities.B_BarracksArchers_Redprince) and XGUIEng.IsModifierPressed(Keys.ModifierControl) == false then
                if _unitType == Entities.U_MilitarySword then
                    _unitType = Entities.U_MilitarySword_RedPrince
                elseif _unitType == Entities.U_MilitaryBow then
                    _unitType = Entities.U_MilitaryBow_RedPrince
                end
            elseif (KnightType == Entities.U_KnightKhana or BarrackEntityType == Entities.B_Barracks_Khana or BarrackEntityType == Entities.B_BarracksArchers_Khana) and XGUIEng.IsModifierPressed(Keys.ModifierControl) == false then
                if _unitType == Entities.U_MilitarySword then
                    _unitType = Entities.U_MilitarySword_Khana
                elseif _unitType == Entities.U_MilitaryBow then
                    _unitType = Entities.U_MilitaryBow_Khana
                end
            end

            if GUI_BuildingButtons.GetLimitReached(_unitType) and EnableRights == true then
                Message(XGUIEng.GetStringTableText("Feedback_TextLines/TextLine_EntityLimitReached"))
                return
            end

            local Costs = {Logic.GetUnitCost(BarrackID, _unitType)}

            local CanBuyBoolean, CanNotBuyString = AreCostsAffordable(Costs)

            local CanProduce = Logic.CanProduceUnits(BarrackID, _unitType)

            if CanBuyBoolean == true and CanProduce == false then
                CanBuyBoolean = false
                CanNotBuyString = XGUIEng.GetStringTableText("Feedback_TextLines/TextLine_NotEnoughRoomToBuyMilitary")
            end

            local CurrentSoldierCount = Logic.GetCurrentSoldierCount(PlayerID)
            local CurrentSoldierLimit = Logic.GetCurrentSoldierLimit(PlayerID)

            local SoldierSize
            if _unitType == Entities.U_Thief or _unitType == Entities.U_MilitaryCavalry then
                SoldierSize = 1
            else
                SoldierSize = Logic.GetBattalionSize(BarrackID)
            end

            if (CurrentSoldierCount + 3) > CurrentSoldierLimit then
                CanBuyBoolean = false
                CanNotBuyString = XGUIEng.GetStringTableText("Feedback_TextLines/TextLine_SoldierLimitReached")
            end

            if CanBuyBoolean == true then
                Sound.FXPlay2DSound("ui\\menu_click")
                if _unitType == Entities.U_Thief then
                    GUI.BuyThief(PlayerID)
                else
                    GUI.ProduceUnits(BarrackID, _unitType)
                    StartKnightVoiceForPermanentSpecialAbility(Entities.U_KnightChivalry)
                end
            else
                Message(CanNotBuyString)
            end
        end

        function GUI_BuildingButtons.BuyBattalionMouseOver(_unitType, _technologyType)
            local CurrentWidgetID = XGUIEng.GetCurrentWidgetID()
            local CurrentWidgetName = XGUIEng.GetWidgetNameByID(CurrentWidgetID)
            local BarrackID = GUI.GetSelectedEntity()
            local EntityLimitString = GUI_BuildingButtons.GetLimitString(_unitType)
            local TechnologyType = _technologyType
            local Costs = {Logic.GetUnitCost(BarrackID, _unitType)}   

            local TooltipStringDisabled
    
            if XGUIEng.IsButtonDisabled(CurrentWidgetID) == 1 and _unitType == Entities.U_Thief then
                if GUI_BuildingButtons.GetLimitReached(Entities.U_Thief) then
                    --GUI.AddNote("Entity limit reached")
                    TooltipStringDisabled = "EntityLimitReached"
                    TechnologyType = nil
                else
                    --GUI.AddNote("Technology locked")
                    TooltipStringDisabled = CurrentWidgetName
                end
            end
    
            --Workaround for cavalry because costs are multiplied by BattalionSize in barracks entity definition
            --[[
            if _unitType == Entities.U_MilitaryCavalry then
                for i = 2, #Costs, 2 do
                    Costs[i] = Costs[i] / 6
                end
            end
            --]]
            GUI_Tooltip.TooltipBuy(Costs, CurrentWidgetName, TooltipStringDisabled, TechnologyType, nil, nil, EntityLimitString)
        end

        function GUI_BuildingButtons.BuyBattalionUpdate(_unitType, _barrackType, _technologyType)
            local PlayerID = GUI.GetPlayerID()
            local CurrentWidgetID = XGUIEng.GetCurrentWidgetID()
            local BarrackID = GUI.GetSelectedEntity()
            local BarrackEntityType = Logic.GetEntityType(BarrackID)
            local TechnologyState = Logic.TechnologyGetState(PlayerID, _technologyType)

            if Logic.IsConstructionComplete(BarrackID) == 0 then
                XGUIEng.ShowWidget(CurrentWidgetID,0)
            else
                local KnightType = Logic.GetEntityType(Logic.GetKnightID(GUI.GetPlayerID()))

                if (KnightType == Entities.U_KnightSabatta or KnightType == Entities.U_KnightRedPrince 
                    or BarrackEntityType == Entities.B_Barracks_RedPrince or BarrackEntityType == Entities.B_BarracksArchers_Redprince) then
                    if _unitType == Entities.U_MilitarySword then
                        SetIcon(CurrentWidgetID, g_TexturePositions.Entities[Entities.U_MilitarySword_RedPrince])
                    elseif _unitType == Entities.U_MilitaryBow then
                        SetIcon(CurrentWidgetID, g_TexturePositions.Entities[Entities.U_MilitaryBow_RedPrince])
                    else
                        SetIcon(CurrentWidgetID, g_TexturePositions.Entities[_unitType])
                    end
                elseif (KnightType == Entities.U_KnightKhana or BarrackEntityType == Entities.B_Barracks_Khana or BarrackEntityType == Entities.B_BarracksArchers_Khana) then
                    if _unitType == Entities.U_MilitarySword then
                        SetIcon(CurrentWidgetID, g_TexturePositions.Entities[Entities.U_MilitarySword_Khana])
                    elseif _unitType == Entities.U_MilitaryBow then
                        SetIcon(CurrentWidgetID, g_TexturePositions.Entities[Entities.U_MilitaryBow_Khana])
                    else
                        SetIcon(CurrentWidgetID, g_TexturePositions.Entities[_unitType])
                    end
                end

                if _barrackType == BarrackEntityType or Logic.IsEntityInCategory(BarrackID, EntityCategories.Headquarters) == 1 then
                    XGUIEng.ShowWidget(CurrentWidgetID,1)
                else
                    -- These are a bit special...
                    if (_barrackType == Entities.B_Barracks and (BarrackEntityType == Entities.B_Barracks_RedPrince or BarrackEntityType == Entities.B_Barracks_Khana))
                     or (_barrackType == Entities.B_BarracksArchers and (Entities.B_BarracksArchers_Redprince or BarrackEntityType == Entities.B_BarracksArchers_Khana)) then
                        XGUIEng.ShowWidget(CurrentWidgetID,1)
                    else
                        XGUIEng.ShowWidget(CurrentWidgetID,0)
                    end
                end
        
                --Check entity limit (especially thieves)
                if GUI_BuildingButtons.GetLimitReached(_unitType) then
                    XGUIEng.DisableButton(CurrentWidgetID, 1)
                    return
                end        
        
                --Don't check tech when ignoring rights (per cheat)
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
        end
    end

    do
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

                if Logic.IsEntityInCategory(EntityID, EntityCategories.SpecialBuilding ) == 0 then
                    StartKnightVoiceForPermanentSpecialAbility(Entities.U_KnightWisdom)
                    StartKnightVoiceForPermanentSpecialAbility(Entities.U_KnightPraphat)
                end

                if XGUIEng.GetCurrentWidgetID() ~= 0 then
                    SaveButtonPressed(XGUIEng.GetCurrentWidgetID())
                end
            else
                Message(CanNotBuyString)
            end
        end
    end

    do
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
    end

end