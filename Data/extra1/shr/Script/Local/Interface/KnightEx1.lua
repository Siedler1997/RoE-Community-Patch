
-----------------------------------------------------------------
-- Overwrites
-----------------------------------------------------------------


do
    local OldGUI_Knight_GetKnightAbilityAndIcons = GUI_Knight.GetKnightAbilityAndIcons
    
    function GUI_Knight.GetKnightAbilityAndIcons(_KnightID)
    
        local Ability
        local AbilityIconPosition = {11,2}
        local KnightType = Logic.GetEntityType(_KnightID)
    
        if KnightType == Entities.U_KnightSaraya then
            Ability = Abilities.AbilityTribute
            -- Wrong icon still!
            AbilityIconPosition = {11,1}
        else
            Ability, AbilityIconPosition = OldGUI_Knight_GetKnightAbilityAndIcons(_KnightID)
        end
    
        return Ability, AbilityIconPosition
    end
end    


do
    local OldGUI_Knight_StartAbilityUpdate = GUI_Knight.StartAbilityUpdate

    function GUI_Knight.StartAbilityUpdate()
    
        local CurrentWidgetID = XGUIEng.GetCurrentWidgetID()
    
        -- check if we have selected a knight
        local KnightID = GUI.GetSelectedEntity()
        if (KnightID == nil) or (Logic.IsKnight(KnightID) == false) then
            return
        end
    
        local Ability, IconPosition = GUI_Knight.GetKnightAbilityAndIcons(KnightID)
    
        SetIcon(CurrentWidgetID, IconPosition)
    
        local RechargeTime = Logic.KnightGetAbilityRechargeTime(KnightID, Ability)
        local TimeLeft = Logic.KnightGetAbiltityChargeSeconds(KnightID, Ability)
    
        if Ability == Abilities.AbilityTribute then
            
            -- tribute department ---------------------------------------------------------------------
            -- check recharge time
            if TimeLeft < RechargeTime then
                DisableButton(CurrentWidgetID)
                return
            end
    
            if Logic.KnightTributeIsPossible(KnightID) == false then
                DisableButton(CurrentWidgetID)
                return
            else
                StartKnightVoiceForActionSpecialAbility(Entities.U_KnightSaraya, true)
                StartKnightVoiceForActionSpecialAbility(Entities.U_KnightPraphat, true)
            end
    
            EnableButton(CurrentWidgetID)
            return    
        end
    
        return OldGUI_Knight_StartAbilityUpdate()    
    end
end    
