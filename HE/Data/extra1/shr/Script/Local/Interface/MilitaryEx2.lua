
function GUI_Military.SuspendUpdate()
    local CurrentWidgetID = XGUIEng.GetCurrentWidgetID()
    local EntityID = GUI.GetSelectedEntity()

    if Framework.IsNetworkGame() == true then
        XGUIEng.DisableButton(CurrentWidgetID, 1)
    else
        local PlayerID = GUI.GetPlayerID()
        local SiegeEngineType = Logic.GetAvailableSiegeEngineTypes(EntityID)
        --Logic.CanCreateCartFromSiegeEngine(PlayerID, SiegeEngineID, CartType)
        if Logic.IsEntityInCategory(EntityID, EntityCategories.HeavyWeapon) == 1 
         and (Logic.IsSiegeEngineUnderConstruction(EntityID) == true
         or XGUIEng.IsWidgetShown("/InGame/Root/Normal/AlignBottomRight/Selection/SiegeEngine") == 1) then
            XGUIEng.DisableButton(CurrentWidgetID, 1)
        else
            XGUIEng.DisableButton(CurrentWidgetID, 0)
        end
    end
end

function GUI_Military.SuspendMouseOver()
    local TooltipTextKey
    local TooltipDisabledTextKey
    if Framework.IsNetworkGame() == true then
        TooltipDisabledTextKey = "ErectNoSoldiersAttached"
    else
        TooltipDisabledTextKey = "Suspend"
    end
    GUI_Tooltip.TooltipNormal(TooltipTextKey, TooltipDisabledTextKey)
end

function GUI_Military.SuspendClicked()
    local EntityID = GUI.GetSelectedEntity()
    local CurrentHealth = Logic.GetEntityHealth(EntityID)
    local MaxHealth = Logic.GetEntityMaxHealth(EntityID)
    --local soldiers = {Logic.GetSoldiersAttachedToLeader(_EntityID)}
    if Logic.IsKnight(EntityID) ~= true then
        --GUI.SendScriptCommand("Logic.DestroyEntity("..EntityID..")")
        
        if Logic.IsEntityInCategory(EntityID, EntityCategories.Leader) == 0 then
            GUI.SendScriptCommand("Logic.DestroyEntity("..EntityID..")")
        else
            local soldiers = {Logic.GetSoldiersAttachedToLeader(EntityID)}
            if soldiers[1] > 0 then
                GUI.SendScriptCommand("Logic.DestroyEntity("..soldiers[2]..")")
            end
        end
        Sound.FXPlay2DSound("ui\\menu_click")
        --[[
        if Logic.IsEntityInCategory(EntityID, EntityCategories.Leader) == 0 then
            --GUI.SendScriptCommand("Logic.DestroyEntity("..EntityID..")")
            GUI.SendScriptCommand("Logic.HurtEntity("..EntityID..", "..MaxHealth..")")
        else
            local MaxSoldiers = Logic.LeaderGetMaxNumberOfSoldiers(EntityID)
            local CurrentSoldiers = Logic.GetSoldiersAttachedToLeader(EntityID)

            --GUI.SendScriptCommand("Logic.DestroyGroupByLeader("..EntityID..")")
            GUI.SendScriptCommand("Logic.HurtEntity("..EntityID..", 20)")
        end
        --]]
    end
end

-----------------------------------------------------------------------------------------
-- Overwrites for Military
-----------------------------------------------------------------------------------------

function InitOverwriteMilitaryEx2()

    do
        function GUI_Military.StrengthUpdate()
            local CurrentWidgetID = "/InGame/Root/Normal/AlignBottomRight/DialogButtons/Military/SoldierStrength/SoldierStrengthIcon"
            local MotherWidget = XGUIEng.GetWidgetsMotherID(CurrentWidgetID)

            --show if Swordfighters or Bowmen in Selection
            local IsLeaderInSelection = false
            local SelectedEntities = {GUI.GetSelectedEntities()}
    
    
            --check if a leader is in the selection
            for i = 1, #SelectedEntities do
        
                local LeaderID = SelectedEntities[i]
        
                if Logic.IsLeader(LeaderID) == 1 then
                    IsLeaderInSelection = true
                    break
                end
        
            end
    
    
            if IsLeaderInSelection == false then
                XGUIEng.ShowWidget(MotherWidget, 0)
                return
            end

            local PlayerID = GUI.GetPlayerID()
            local Morale = Logic.GetPlayerMorale(PlayerID)
    
            local Icon = g_TexturePositions.SoldierStrength[3]

            if Morale < 0.8 then
                Icon = g_TexturePositions.SoldierStrength[1]
    
            elseif Morale < 1.1 then
                Icon = g_TexturePositions.SoldierStrength[2]
    
            elseif Morale > 1.7 then
                Icon = g_TexturePositions.SoldierStrength[5]
        
            elseif Morale > 1.4 then
                Icon = g_TexturePositions.SoldierStrength[4]
            end

            SetIcon(CurrentWidgetID, Icon)
    
            --position
            --[[
            if XGUIEng.IsWidgetShown("/InGame/Root/Normal/AlignBottomRight/Selection/BGMilitary") == 1 then
                XGUIEng.SetWidgetLocalPosition(MotherWidget, 39, 94)
            else
                XGUIEng.SetWidgetLocalPosition(MotherWidget, 39, 32)
            end
            --]]
            XGUIEng.SetWidgetLocalPosition(MotherWidget, 39, 32)
        end
    end

    do
        function GUI_Military.DisassembleUpdate()
    
            local CurrentWidgetID = XGUIEng.GetCurrentWidgetID()
            local PlayerID = GUI.GetPlayerID()
            local SiegeEngineID = GUI.GetSelectedEntity()
            local CanDisassembleBoolean = false
            --potential additional SiegeEngineCart types are ignored
            local CartType = Logic.GetAvailableSiegeCartType(SiegeEngineID)
            local DisassembleIcon
    
            if CartType == Entities.U_BatteringRamCart then
                DisassembleIcon = {12, 10}
            elseif CartType == Entities.U_CatapultCart or CartType == Entities.U_TrebuchetCart then
                DisassembleIcon = {12, 9}
            elseif CartType == Entities.U_SiegeTowerCart then
                DisassembleIcon = {12, 11}
            elseif CartType == Entities.U_CannonCart then
                DisassembleIcon = {3, 4, 2}
            end

            SetIcon(CurrentWidgetID, DisassembleIcon)

            if CartType ~= nil then
                CanDisassembleBoolean = Logic.CanCreateCartFromSiegeEngine(PlayerID, SiegeEngineID, CartType)
            end

            if CanDisassembleBoolean == false then
                XGUIEng.DisableButton(CurrentWidgetID, 1)
            else
                XGUIEng.DisableButton(CurrentWidgetID, 0)
            end
        end
    end

    do
        function GUI_Military.ErectMouseOver()
            local CurrentWidgetID = XGUIEng.GetCurrentWidgetID()
            local SiegeCartID = GUI.GetSelectedEntity()
            local SiegeEngineType = Logic.GetAvailableSiegeEngineTypes(SiegeCartID)
            local TooltipTextKey
    
            if SiegeEngineType == Entities.U_MilitaryBatteringRam then
                TooltipTextKey = "ErectBatteringRam"
            elseif SiegeEngineType == Entities.U_MilitaryCatapult then
                TooltipTextKey = "ErectCatapult"
            elseif SiegeEngineType == Entities.U_MilitarySiegeTower then
                TooltipTextKey = "ErectSiegeTower"
            elseif SiegeEngineType == Entities.U_MilitaryTrebuchet then
                TooltipTextKey = "ErectTrebuchet"
            elseif SiegeEngineType == Entities.U_MilitaryCannon then
                TooltipTextKey = "ErectCannon"
            end
    
            local TooltipDisabledTextKey
    
            if Logic.IsCartUnderConstruction(SiegeCartID) == true then
                TooltipDisabledTextKey = "Erect"
            else
                TooltipDisabledTextKey = "ErectNoSoldiersAttached"
            end

            GUI_Tooltip.TooltipNormal(TooltipTextKey, TooltipDisabledTextKey)
        end
    end

    do
        function GUI_Military.ErectUpdate()
    
            local CurrentWidgetID = XGUIEng.GetCurrentWidgetID()
            local SiegeCartID = GUI.GetSelectedEntity()
            local PlayerID = GUI.GetPlayerID()
            local SiegeEngineType = Logic.GetAvailableSiegeEngineTypes(SiegeCartID)
    
            --check if soldiers attached
            if Logic.CanCreateSiegeEngineFromCart(PlayerID, SiegeCartID, SiegeEngineType, true) == false then
                XGUIEng.DisableButton(CurrentWidgetID, 1)
            else
                XGUIEng.DisableButton(CurrentWidgetID, 0)
            end
    
            --potential additional SiegeEngine types are ignored
            local SiegeEngineType = Logic.GetAvailableSiegeEngineTypes(SiegeCartID)
            local ErectIcon
    
            if SiegeEngineType == Entities.U_MilitaryBatteringRam then
                ErectIcon = {12, 7}
            elseif SiegeEngineType == Entities.U_MilitaryCatapult or SiegeEngineType == Entities.U_MilitaryTrebuchet then
                ErectIcon = {12, 6}
            elseif SiegeEngineType == Entities.U_MilitarySiegeTower then
                ErectIcon = {12, 8}
            elseif SiegeEngineType == Entities.U_MilitaryCannon then
                ErectIcon = {3, 3, 2}
            end

            SetIcon(CurrentWidgetID, ErectIcon)
        end
    end

end