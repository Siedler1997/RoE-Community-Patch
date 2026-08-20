
-----------------------------------------------------------------------------------------
-- Overwrites for Interaction
-----------------------------------------------------------------------------------------

function InitOverwriteInteractionEx2()

    do
        function GUI_Interaction.InteractiveObjectUpdateEx1(Widget, EntityType)
            local PlayerID = GUI.GetPlayerID()
            if EntityType == Entities.B_Cistern then
                SetIcon(Widget, GUI_Interaction.Icon.GeologistWater)
                if Logic.TechnologyGetState(PlayerID, Technologies.R_RefillCistern) == TechnologyStates.Locked then
	                XGUIEng.DisableButton(Widget, 1)
                else
	                XGUIEng.DisableButton(Widget, 0)
                end
            elseif EntityType == Entities.R_StoneMine then
                SetIcon(Widget, GUI_Interaction.Icon.GeologistStone)
                if Logic.TechnologyGetState(PlayerID, Technologies.R_RefillStoneMine) == TechnologyStates.Locked then
	                XGUIEng.DisableButton(Widget, 1)
                else
	                XGUIEng.DisableButton(Widget, 0)
                end
            elseif EntityType == Entities.R_IronMine then
                SetIcon(Widget, GUI_Interaction.Icon.GeologistIron)
                if Logic.TechnologyGetState(PlayerID, Technologies.R_RefillIronMine) == TechnologyStates.Locked then
	                XGUIEng.DisableButton(Widget, 1)
                else
	                XGUIEng.DisableButton(Widget, 0)
                end
            elseif EntityType == Entities.I_X_TradePostConstructionSite then
                SetIcon(Widget, GUI_Interaction.Icon.Tradepost)
            else
                SetIcon(Widget, GUI_Interaction.Icon.Interaction)
            end
        end
    end

    do
        function GUI_Interaction.InteractiveObjectMouseOver()
            local PlayerID = GUI.GetPlayerID()
            local ButtonNumber = tonumber(XGUIEng.GetWidgetNameByID(XGUIEng.GetCurrentWidgetID()))
            local ObjectID = g_Interaction.ActiveObjectsOnScreen[ButtonNumber]
            local EntityType = Logic.GetEntityType(ObjectID)

            local CurrentWidgetID = XGUIEng.GetCurrentWidgetID()
            local Costs = {Logic.InteractiveObjectGetEffectiveCosts(ObjectID, PlayerID)}
            local IsAvailable = Logic.InteractiveObjectGetAvailability(ObjectID)
            local TechnologyType

            local TooltipTextKey
            local TooltipDisabledTextKey

            -- interaction tooltip
    
            if EntityType == Entities.B_Cistern or EntityType == Entities.R_StoneMine or EntityType == Entities.R_IronMine then
                TooltipTextKey = "InteractiveObjectGeologist"
                if EntityType == Entities.B_Cistern then
                    TechnologyType = Technologies.R_RefillCistern
                elseif EntityType == Entities.R_StoneMine then
                    TechnologyType = Technologies.R_RefillStoneMine
                elseif EntityType == Entities.R_IronMine then
                    TechnologyType = Technologies.R_RefillIronMine
                end
            elseif EntityType == Entities.I_X_TradePostConstructionSite then
                TooltipTextKey = "InteractiveObjectTradepost"
            else
                if IsAvailable == true then
                    TooltipTextKey = "InteractiveObjectAvailable"
                else
                    TooltipTextKey = "InteractiveObjectNotAvailable"
                end
            end
   

            -- interaction tooltip - disabled
            if Logic.InteractiveObjectHasPlayerEnoughSpaceForRewards(ObjectID, PlayerID) == false then
                TooltipDisabledTextKey = "InteractiveObjectAvailableReward"
            end

            local CheckSettlement
            -- Only check first good (no support for mixed deliveries)
            if Costs and Costs[1] and Logic.GetGoodCategoryForGoodType(Costs[1]) ~= GoodCategories.GC_Resource then
                CheckSettlement = true
            end
    
            GUI_Tooltip.TooltipBuy(Costs, TooltipTextKey, TooltipDisabledTextKey, TechnologyType, CheckSettlement)
        end
    end

    do
        function GUI_Interaction.InteractiveObjectUpdate()
            local PlayerID = GUI.GetPlayerID()

            if g_Interaction.ActiveObjects == nil then
                return
            end

            for i = 1, #g_Interaction.ActiveObjects do
                local ObjectID = g_Interaction.ActiveObjects[i]
                local X, Y = GUI.GetEntityInfoScreenPosition(ObjectID)
    	        local ScreenSizeX, ScreenSizeY = GUI.GetScreenSize()

                if X ~= 0
                and Y ~= 0
                and X > -50 and Y > -50 and X < (ScreenSizeX + 50) and Y < (ScreenSizeY + 50) then
                    local IsInTable = false

                    for i = 1, #g_Interaction.ActiveObjectsOnScreen do
                        if g_Interaction.ActiveObjectsOnScreen[i] == ObjectID then
                            IsInTable = true
                        end
                    end

                    if IsInTable == false then
                        table.insert(g_Interaction.ActiveObjectsOnScreen, ObjectID)
                    end
                else
                    for i = 1, #g_Interaction.ActiveObjectsOnScreen do
                        if g_Interaction.ActiveObjectsOnScreen[i] == ObjectID then
                            table.remove(g_Interaction.ActiveObjectsOnScreen, i)
                        end
                    end
                end
            end

            for i = 1, #g_Interaction.ActiveObjectsOnScreen do
                local Widget = "/InGame/Root/Normal/InteractiveObjects/" .. i

                if XGUIEng.IsWidgetExisting(Widget) == 1 then
                    --Update the position
                    local ObjectID = g_Interaction.ActiveObjectsOnScreen[i]
                    local EntityType = Logic.GetEntityType(ObjectID)
	        
                    local X, Y = GUI.GetEntityInfoScreenPosition(ObjectID)
                    local WidgetSize = {XGUIEng.GetWidgetScreenSize(Widget)}
	                XGUIEng.SetWidgetScreenPosition(Widget, X - (WidgetSize[1]/2), Y - (WidgetSize[2]/2))
	        
                    local BaseCosts = {Logic.InteractiveObjectGetCosts(ObjectID)}
                    local EffectiveCosts = {Logic.InteractiveObjectGetEffectiveCosts(ObjectID, PlayerID)}
                    local IsAvailable = Logic.InteractiveObjectGetAvailability(ObjectID)
            
                    local Disable = false
            
                    if BaseCosts[1] ~= nil
                    and EffectiveCosts[1] == nil
                    and IsAvailable == true then
                        Disable = true -- cart is underway
                    end
            
                    local HasSpace = Logic.InteractiveObjectHasPlayerEnoughSpaceForRewards(ObjectID, PlayerID)
            
                    if HasSpace == false then
                        Disable = true
                    end

                    if Disable == true then
                        XGUIEng.DisableButton(Widget, 1)
                    else
                        XGUIEng.DisableButton(Widget, 0)
                    end

                    -- interaction icon
                    if GUI_Interaction.InteractiveObjectUpdateEx1 ~= nil then
                        GUI_Interaction.InteractiveObjectUpdateEx1(Widget, EntityType)
                    end

	                XGUIEng.ShowWidget(Widget, 1)
                --[[
	            else
	                GUI.AddNote("Debug: There should not be more than 2 interactive objects visible onscreen at the same time.")
                --]]
	            end
	        end

	        for i = #g_Interaction.ActiveObjectsOnScreen + 1, 2 do
	            local Widget = "/InGame/Root/Normal/InteractiveObjects/" .. i
	            XGUIEng.ShowWidget(Widget, 0)
	        end
        end
    end

    do
        local OldGUI_Interaction_SetPlayerIcon = GUI_Interaction.SetPlayerIcon
        function GUI_Interaction.SetPlayerIcon(_PlayerIconContainer, _PlayerID)
            local LogoWidget = _PlayerIconContainer .. "/Logo"
            local PatternWidget = _PlayerIconContainer .. "/Pattern"

            if _PlayerID == GUI.GetPlayerID() then
                local CoASet = Profile.IsKeyValid("Profile", "PatternTexture")
                if CoASet then
                    XGUIEng.SetMaterialTexture(LogoWidget, 0, "Frames2.png")
                    XGUIEng.SetMaterialTexture(PatternWidget, 0, "CoA_Small.png")
                    g_CoatOfArm.UpdateGender(true, nil, LogoWidget)
                    g_CoatOfArm.UpdatePattern(true, nil, nil, PatternWidget)
                else
                    OldGUI_Interaction_SetPlayerIcon(_PlayerIconContainer, _PlayerID)
                end
            else
                OldGUI_Interaction_SetPlayerIcon(_PlayerIconContainer, _PlayerID)
            end
        end
    end

end


