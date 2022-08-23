
-----------------------------------------------------------------
-- Overwrites
-----------------------------------------------------------------


do
    local OldGUI_Knight_GetKnightAbilityAndIcons = GUI_Knight.GetKnightAbilityAndIcons
    
    function GUI_Knight.GetKnightAbilityAndIcons(_KnightID)
    
        local Ability
        local AbilityIconPosition = {11,2}
        local KnightType = Logic.GetEntityType(_KnightID)
    
        if KnightType == Entities.U_KnightSaraya or KnightType == Entities.U_KnightPraphat then
            Ability = Abilities.AbilityTribute
            -- Wrong icon still!
            AbilityIconPosition = {11,1}
        elseif KnightType == Entities.U_KnightKhana then
            Ability = Abilities.AbilityTorch
            AbilityIconPosition = {11,4}
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
                StartKnightVoiceForActionSpecialAbility(Entities.U_KnightRedPrince, true)
                StartKnightVoiceForActionSpecialAbility(Entities.U_KnightSaraya, true)
                StartKnightVoiceForActionSpecialAbility(Entities.U_KnightPraphat, true)
            end
    
            EnableButton(CurrentWidgetID)
            return    
        end
    
        return OldGUI_Knight_StartAbilityUpdate()    
    end
end    

do
    --local OldGUI_Knight_StartAbilityUpdate = GUI_Knight.StartAbilityUpdate
    function GUI_Knight.GetKnightTooltipTextKey(_KnightID, _Ability)
        local KnightType = Logic.GetEntityType(_KnightID)
        local TooltipTextKey
        if KnightType == Entities.U_KnightSabatta then
            TooltipTextKey = "AbilityConvertCrimsonSabatt"
        elseif KnightType == Entities.U_KnightRedPrince then
            TooltipTextKey = "AbilityPlagueRedPrince"
        elseif KnightType == Entities.U_KnightKhana then
            TooltipTextKey = "AbilityKhana"
        elseif KnightType == Entities.U_KnightPraphat then
            TooltipTextKey = "AbilityPraphat"
        else
            for key, value in pairs (Abilities) do
                if value == _Ability then
                    TooltipTextKey = key
                end
            end
        end
        return TooltipTextKey
    end
end
