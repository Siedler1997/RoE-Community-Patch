
-----------------------------------------------------------------------------------------
-- Overwrites for Multiselection
-----------------------------------------------------------------------------------------

function InitOverwriteMultiselectionEx2()
    LeaderSortOrder = {
        Entities.U_MilitarySword,
        Entities.U_MilitaryBow,
        Entities.U_MilitarySword_RedPrince,
        Entities.U_MilitaryBow_RedPrince,
        Entities.U_MilitarySword_Khana,
        Entities.U_MilitaryBow_Khana,
        Entities.U_MilitarySpear,
        Entities.U_MilitaryBandit_Melee_ME,
        Entities.U_MilitaryBandit_Melee_NA,
        Entities.U_MilitaryBandit_Melee_NE,
        Entities.U_MilitaryBandit_Melee_SE,
        Entities.U_MilitaryBandit_Melee_AS,
        Entities.U_MilitaryBandit_Ranged_ME,
        Entities.U_MilitaryBandit_Ranged_NA,
        Entities.U_MilitaryBandit_Ranged_NE,
        Entities.U_MilitaryBandit_Ranged_SE,
        Entities.U_MilitaryBandit_Ranged_AS,
        Entities.U_MilitaryCatapult,
        Entities.U_MilitaryCannon,
        Entities.U_MilitarySiegeTower,
        Entities.U_MilitaryBatteringRam,
        Entities.U_MilitaryTrebuchet,
        Entities.U_CatapultCart,
        Entities.U_CannonCart,
        Entities.U_SiegeTowerCart,
        Entities.U_BatteringRamCart,
        Entities.U_TrebuchetCart,
        Entities.U_Thief,
        Entities.U_Bear,
        Entities.U_BlackBear,
        Entities.U_PolarBear,
        Entities.U_Lion_Male,
        Entities.U_Lion_Female,
        Entities.U_Wolf_Grey,
        Entities.U_Wolf_White,
        Entities.U_Wolf_Black,
        Entities.U_Wolf_Brown,
        Entities.U_Tiger,
        Entities.U_Tiger_White,
        Entities.U_Cat1,
        Entities.U_Cat2,
        Entities.U_Cat3,
        Entities.U_Cat4,
        Entities.U_Dog1,
        Entities.U_Dog2,
        Entities.U_Dog3,
        Entities.U_Dragon
    }

    do
        function GUI_MultiSelection.IconUpdate()

            local CurrentWidgetID = XGUIEng.GetCurrentWidgetID()    
            local CurrentMotherID = XGUIEng.GetWidgetsMotherID(CurrentWidgetID)
            local CurrentMotherName = XGUIEng.GetWidgetNameByID(CurrentMotherID)
            local Index = CurrentMotherName + 0
            local CurrentMotherPath = XGUIEng.GetWidgetPathByID(CurrentMotherID)
            local HealthWidgetPath = CurrentMotherPath .. "/Health"

            local EntityID = g_MultiSelection.EntityList[Index]
    
            if Logic.IsEntityAlive(EntityID) then
                --hack because of bug that a button can't be highlighted inside his click function
                if GUI.IsEntitySelected(EntityID) == false
                and XGUIEng.IsButtonHighLighted(CurrentWidgetID) == 1 then
                    XGUIEng.HighLightButton(CurrentWidgetID, 0)
                end
        
                local HealthState = Logic.GetEntityHealth(EntityID)
                local EntityMaxHealth = Logic.GetEntityMaxHealth(EntityID)
                local EntityType = Logic.GetEntityType(EntityID)

                if Logic.IsLeader(EntityID) == 1 then
                    local SoldierType = Logic.LeaderGetSoldiersType(EntityID)
                    SetIcon(CurrentWidgetID, g_TexturePositions.Entities[SoldierType])
            
                    HealthState = Logic.LeaderGetNumberOfSoldiers(EntityID)
                    EntityMaxHealth = Logic.LeaderGetMaxNumberOfSoldiers(EntityID)
        
                elseif Logic.IsEntityInCategory(EntityID, EntityCategories.HeavyWeapon) == 1 then
                    if (EntityType == Entities.U_CatapultCart
                    or EntityType == Entities.U_SiegeTowerCart
                    or EntityType == Entities.U_BatteringRamCart
                    or EntityType == Entities.U_AmmunitionCart
                    or EntityType == Entities.U_MilitaryBallista
                    or EntityType == Entities.U_TrebuchetCart
                    or EntityType == Entities.U_Trebuchet
                    or EntityType == Entities.U_CannonCart
                    or Logic.GetNumSoldiersAttachedToWarMachine(EntityID) > 0) then
                        SetIcon(CurrentWidgetID, g_TexturePositions.Entities[EntityType])
            
                    else
                        local uPos = g_TexturePositions.Entities[EntityType][1]
                        local vPos = g_TexturePositions.Entities[EntityType][2]
                        local file = 0

                        --Set file (if set, otherwise default)
                        if #g_TexturePositions.Entities[EntityType] >= 3 then
                            file = g_TexturePositions.Entities[EntityType][3]
                        end
                
                        SetIcon(CurrentWidgetID, {uPos + 1, vPos, file})
                    end
                else
                    SetIcon(CurrentWidgetID, g_TexturePositions.Entities[EntityType])
                end
        
                HealthState = math.floor(HealthState / EntityMaxHealth * 100)

                if HealthState < 50 then
                    local green = math.floor(2*255* (HealthState/100))
                    XGUIEng.SetMaterialColor(HealthWidgetPath,0,255,green, 20,255)
                else
                    local red = 2*255 - math.floor(2*255* (HealthState/100))
                    XGUIEng.SetMaterialColor(HealthWidgetPath,0,red, 255, 20,255)
                end

                XGUIEng.SetProgressBarValues(HealthWidgetPath,HealthState, 100)
            else
                XGUIEng.ShowWidget(CurrentMotherID, 0)
        
                --update the Multiselection
                GUI_MultiSelection.CreateEX()               
            end
        end
    end

    do
        function GUI_MultiSelection.IconMouseOver()
            local CurrentWidgetID = XGUIEng.GetCurrentWidgetID()    
            local CurrentMotherID = XGUIEng.GetWidgetsMotherID(CurrentWidgetID)
            local CurrentMotherName = XGUIEng.GetWidgetNameByID(CurrentMotherID)
            local Index = tonumber(CurrentMotherName)
            local EntityID = g_MultiSelection.EntityList[Index]

            if EntityID == nil
            or EntityID == 0 then
                return
            end

            local EntityType
    
            if Logic.IsLeader(EntityID) == 1 then
                EntityType = Logic.LeaderGetSoldiersType(EntityID)
            else
                EntityType = Logic.GetEntityType(EntityID)
            end
    
            local EntityTypeName = Logic.GetEntityTypeName(EntityType)
            local TooltipTextKey = "Abilities_" .. EntityTypeName

            if (EntityType == Entities.U_MilitaryCatapult
            or EntityType == Entities.U_MilitarySiegeTower
            or EntityType == Entities.U_MilitaryBatteringRam
            or EntityType == Entities.U_MilitaryTrebuchet
            or EntityType == Entities.U_MilitaryCannon)
            and Logic.GetNumSoldiersAttachedToWarMachine(EntityID) == 0 then
                TooltipTextKey = TooltipTextKey .. "_NoSoldiersAttached"
            end

            GUI_Tooltip.TooltipNormal(TooltipTextKey)
        end
    end

end