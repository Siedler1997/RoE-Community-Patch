-----------------------------------------------------------------
-- Overwrites
-----------------------------------------------------------------

-- look into SharedConstants.lua for the consts
GUI_Interaction.Icon = {}
GUI_Interaction.Icon.Tradepost = {3, 1, 1}
GUI_Interaction.Icon.Geologist = {8, 1, 1}
GUI_Interaction.Icon.Interaction = {14, 10}
GUI_Interaction.Icon.GeologistIron = {8, 2, 1}
GUI_Interaction.Icon.GeologistStone = {8, 3, 1}
GUI_Interaction.Icon.GeologistWater = {8, 4, 1}

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

function GUI_Interaction.DisplayQuestObjectiveEx1(Quest, QuestType, _rResultTable)

    local QuestObjectivesPath = "/InGame/Root/Normal/AlignBottomLeft/Message/QuestObjectives"

    if QuestType == Objective.Refill
    then
        _rResultTable.QuestObjectiveContainer = QuestObjectivesPath .. "/Need"
        
        local RefillID = Quest.Objectives[1].Data[1]
        local QuestTypeAdditionalCaptionKey, Icon
        local EntityType = Logic.GetEntityType( RefillID )
        
        if EntityType == Entities.B_Cistern then
            _rResultTable.QuestTypeCaption = XGUIEng.GetStringTableText("UI_Texts/QuestCaptionSendGeologistToRefillCistern")
            QuestTypeAdditionalCaptionKey = "UI_Texts/QuestRefillCistern"
            Icon = g_TexturePositions.Goods[Goods.G_Water]
        else
            _rResultTable.QuestTypeCaption = XGUIEng.GetStringTableText("UI_Texts/QuestCaptionSendGeologistToRefillMine")
            QuestTypeAdditionalCaptionKey = "UI_Texts/QuestRefillMine"
            Icon = g_TexturePositions.Entities[EntityType]
        end

        XGUIEng.SetText(_rResultTable.QuestObjectiveContainer .. "/Caption", _rResultTable.QuestTypeCaption )
        XGUIEng.SetTextKeyName(_rResultTable.QuestObjectiveContainer .. "/AdditionalCaption", QuestTypeAdditionalCaptionKey )
        local QuestTypeIcon = g_TexturePositions.QuestTypes[Objective.Refill]

        SetIcon(_rResultTable.QuestObjectiveContainer .. "/Icon", Icon or QuestTypeIcon)
        SetIcon(_rResultTable.QuestObjectiveContainer .. "/QuestTypeIcon", QuestTypeIcon)
        
        return true
    end

    return false
end


function GUI_Interaction.JumpToEntityClickedEx1(Quest, QuestType, EntityOrTerritoryList)
    
    if QuestType == Objective.Refill then
    
        local Entity = Quest.Objectives[1].Data[1] 
    
        table.insert(EntityOrTerritoryList, Entity)
        
        return true
    end
    
    return false
end

do

    local OldGUI_Interaction_UpdateButtons = GUI_Interaction.UpdateButtons
    
    function GUI_Interaction.UpdateButtons()
    
        local SendGoodsButton = XGUIEng.GetWidgetID("/InGame/Root/Normal/AlignBottomLeft/Message/MessagePortrait/Buttons/SendGoods")
        local JumpToEntityButton = XGUIEng.GetWidgetID("/InGame/Root/Normal/AlignBottomLeft/Message/MessagePortrait/Buttons/JumpToEntity")
    
        if g_Interaction.CurrentMessageQuestIndex == nil
        or g_Interaction.CurrentMessageQuestIndex == 0 then
            XGUIEng.ShowWidget(SendGoodsButton, 0)
            XGUIEng.ShowWidget(JumpToEntityButton, 0)
            return
        end
    
        local Quest, QuestType = GUI_Interaction.GetPotentialSubQuestAndType(g_Interaction.CurrentMessageQuestIndex)
        
        if QuestType == Objective.Refill
        and Quest.State == QuestState.Active then
            XGUIEng.ShowWidget(JumpToEntityButton, 1)
            XGUIEng.DisableButton(JumpToEntityButton, 0)
            XGUIEng.ShowWidget(SendGoodsButton, 0)
        else
            return OldGUI_Interaction_UpdateButtons()
        end
    end
end

do
    local OldIsEntityTypeNoCastellan = IsEntityTypeNoCastellan
    function IsEntityTypeNoCastellan( _EntityType )
        return _EntityType ~= Entities.U_NPC_Castellan_AS and OldIsEntityTypeNoCastellan( _EntityType )
    end
end

do
    local OldIsEntityTypeACloister = IsEntityTypeACloister
    function IsEntityTypeACloister( _EntityType )
        return _EntityType == Entities.B_NPC_Cloister_AS or OldIsEntityTypeACloister( _EntityType )
    end
end


function GUI_Interaction.InteractionSpeechFeedbackOverride(_ObjectID)

    local EntityType = Logic.GetEntityType(_ObjectID)
    
    if  EntityType == Entities.B_Cistern 
        or
        EntityType == Entities.R_StoneMine
        or
        EntityType == Entities.R_IronMine
    then
        -- feedback handled on geologist bought
        return true
    end
    
    return false
end

--[[ function GUI_Interaction.InteractionClickOverride(_ObjectID)

    local EntityType = Logic.GetEntityType(_ObjectID)
    
    if  EntityType == Entities.R_IronMine then
        Sound.FXPlay2DSound("ui\\ui_geologist_iron")
        --Sound.FXPlay2DSound("ui\\ui_yipieh")
        return true
    end
    
    if  EntityType == Entities.R_StoneMine then
        Sound.FXPlay2DSound("ui\\ui_geologist_stone")
        --Sound.FXPlay2DSound("ui\\ui_yipieh")
        return true
    end
   
    
    return false
end ]]


