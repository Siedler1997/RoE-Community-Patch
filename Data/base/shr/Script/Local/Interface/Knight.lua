----------------------------------------------------------------------------------------------------------
-- Knight
----------------------------------------------------------------------------------------------------------

GUI_Knight = {}

g_LastGotPromotionMessageRandom = 0
g_ThordalSongId = -1

function StartKnightsPromotionCelebration( _PlayerID , _OldTitle, _FirstTime)

    if _PlayerID ~= GUI.GetPlayerID() or Logic.GetTime() < 5 then
        return
    end

    if _FirstTime == 1 then
        local KnightID = Logic.GetKnightID(_PlayerID)
        local MarketplaceID = Logic.GetMarketplace(_PlayerID)
        
        --CameraAnimation.QueueAnimation( CameraAnimation.MoveCameraToEntity, MarketplaceID)
        --CameraAnimation.QueueAnimation( CameraAnimation.ZoomCameraToFactor,  0.1 )
        --CameraAnimation.QueueAnimation( CameraAnimation.Stay ,  8 )
        
        --local TextKey = "Title_GotPromotion" .. _OldTitle + 1
        local Random
        
        repeat
            Random = 1 + XGUIEng.GetRandom(3)
        until Random ~= g_LastGotPromotionMessageRandom
        
        g_LastGotPromotionMessageRandom = Random
        
        local TextKey = "Title_GotPromotion" .. Random
        
        LocalScriptCallback_QueueVoiceMessage(_PlayerID, TextKey, false, _PlayerID)
        
        StartEventMusic(MusicSystem.EventFestivalMusic, _PlayerID)
    end

    XGUIEng.ShowWidget("/InGame/Root/Normal/AlignBottomRight/KnightTitleMenu", 0)
    XGUIEng.ShowWidget("/InGame/Root/Normal/AlignTopCenter/KnightTitleMenuBig", 0)
    g_TimeOfPromotionPossible = nil
    g_WantsPromotionMessageInterval = 30
end


function StartKnightVoiceForPermanentSpecialAbility(_KnightType)

    if _KnightType == Logic.GetEntityType(Logic.GetKnightID(GUI.GetPlayerID()))
    and PermanentAbilityIsExplained == nil then
        LocalScriptCallback_StartVoiceMessage(GUI.GetPlayerID(), "Hint_SpecialAbilityPermanetly", false, GUI.GetPlayerID())
        PermanentAbilityIsExplained  = true
    end
end


function StartKnightVoiceForActionSpecialAbility(_KnightType, _NoPriority)

    if ActionAbilityIsExplained == nil 
    and  _KnightType == Logic.GetEntityType(Logic.GetKnightID(GUI.GetPlayerID())) then
        LocalScriptCallback_StartVoiceMessage(GUI.GetPlayerID(), "Hint_SpecialAbilityAction", false, GUI.GetPlayerID(), _NoPriority)
        ActionAbilityIsExplained  = true
    end
end

g_TimeOfPromotionPossible = nil
g_LastWantsPromotionMessageRandom = 0
g_WantsPromotionMessageInterval = 30

function GUI_Knight.KnightPromoteUpdate()
    local CurrentTime = Logic.GetTime()
    
    if g_TimeOfPromotionPossible == nil then
        g_TimeOfPromotionPossible = CurrentTime
    end
    
    local PlayerID = GUI.GetPlayerID()
    local KnightID = Logic.GetKnightID(PlayerID)

    if KnightID == 0 then
        return
    end

    local CurrentTitle = Logic.GetKnightTitle(PlayerID)
    
    local IsLocked = IsKnightTitleLockedForPlayer( PlayerID, CurrentTitle + 1 )

    if not IsLocked then
    
        if CurrentTime > g_TimeOfPromotionPossible + g_WantsPromotionMessageInterval then
            
            local Random
            
            repeat
                Random = 1 + XGUIEng.GetRandom(3)
            until Random ~= g_LastWantsPromotionMessageRandom
            
            g_LastWantsPromotionMessageRandom = Random
            
            local TextKey = "Title_WantsPromotion" .. Random
            local PlayerID = GUI.GetPlayerID()
    
            LocalScriptCallback_QueueVoiceMessage(PlayerID, TextKey, false, PlayerID)
            g_TimeOfPromotionPossible = CurrentTime
            g_WantsPromotionMessageInterval = g_WantsPromotionMessageInterval * 2 + 60
        end
    end
    
end


function GUI_Knight.GetTitleNameByTitleID(_KnightType, _TitleIndex)

    local KeyName = "Title_" .. GetNameOfKeyInTable(KnightTitles, _TitleIndex) .. "_" .. KnightGender[_KnightType]

    local String = XGUIEng.GetStringTableText("UI_ObjectNames/" .. KeyName)

    if String == nil or String == "" then
        String = "Knight not in Gender Table? (localscript.lua)"
    end

    return String

end


function GUI_Knight.GetCurrentKnightTitleName(_PlayerID)

    local KnightID = Logic.GetKnightID(_PlayerID)
    local KnightType = Logic.GetEntityType(KnightID)
    local TitleIndex = Logic.GetKnightTitle(_PlayerID)

    local String = GUI_Knight.GetTitleNameByTitleID(KnightType, TitleIndex)

    return String

end


function GUI_Knight.GetKnightAbilityAndIcons(_KnightID)

    local Ability
    local AbilityIconPosition = {11,2}
    local KnightType = Logic.GetEntityType(_KnightID)

    if KnightType == Entities.U_KnightSong then
        Ability = Abilities.AbilityBard
        AbilityIconPosition = {11,1}
    elseif KnightType == Entities.U_KnightHealing then
        Ability = Abilities.AbilityHeal
        AbilityIconPosition = {11,2}
    elseif KnightType == Entities.U_KnightPlunder then
        Ability = Abilities.AbilityPlunder
        AbilityIconPosition = {11,3}
    elseif KnightType == Entities.U_KnightTrading then
        Ability = Abilities.AbilityFood
        AbilityIconPosition = {11,5}
    elseif KnightType == Entities.U_KnightChivalry then
        Ability = Abilities.AbilityTorch
        AbilityIconPosition = {11,4}
    elseif KnightType == Entities.U_KnightWisdom or KnightType == Entities.U_KnightSabatta then
        Ability = Abilities.AbilityConvert
        AbilityIconPosition = {11,6}
    elseif KnightType == Entities.U_KnightRedPrince then
        Ability = Abilities.AbilityConvert
        AbilityIconPosition = {15,16}
    end

    return Ability, AbilityIconPosition

end


function GUI_Knight.PromoteKnightClicked()

    local PlayerID = GUI.GetPlayerID()
    local KnightID = Logic.GetKnightID(PlayerID)

    if CanKnightBePromoted(PlayerID) or EnableRights  ~= true then
        if KnightID > 0 then
            if EnableRights then
                if DoesPlayerHaveStrikers(PlayerID) then
                    local MessageText = XGUIEng.GetStringTableText("Feedback_TextLines/TextLine_PromoteStrikingSettlers")
                    Message(MessageText)
                    return

                elseif IsKnightNearMarketplace(PlayerID) == false then
                    local MessageText = XGUIEng.GetStringTableText("Feedback_TextLines/TextLine_PromoteNearMarketplace")
                    Message(MessageText)
                    return
                end
            end
            
            if EnableRights then
                GUI.PromoteKnight()
            else -- cheating a title is not possible with PromoteKnight
                GUI.SetKnightTitle(Logic.GetKnightTitle(PlayerID) + 1)
            end
        end
    end

end


function GUI_Knight.PromoteKnightButtonUpdate()

    local CurrentWidgetID =  XGUIEng.GetCurrentWidgetID()
    local PlayerID = GUI.GetPlayerID()
    local KnightID = Logic.GetKnightID(PlayerID)

    if KnightID ~= 0 then
        local Progress = Logic.KnightGetResurrectionProgress(KnightID)

        if Progress ~= 1 then
            XGUIEng.DisableButton(CurrentWidgetID, 1)
        else
            XGUIEng.DisableButton(CurrentWidgetID, 0)
        end
    else
        XGUIEng.DisableButton(CurrentWidgetID, 1)
    end

end


function GUI_Knight.UpdateRequirements()

    local RequiredSettlers =  "/InGame/Root/Normal/AlignBottomRight/KnightTitleMenu/Requirements/Settlers"
    local RequiredGoods = "/InGame/Root/Normal/AlignBottomRight/KnightTitleMenu/Requirements/Goods"


    --this can be done in the gui editor later:
    local RequiredCathedral = "/InGame/Root/Normal/AlignBottomRight/KnightTitleMenu/Requirements/Cathedral"
    local RequiredStorehouse = "/InGame/Root/Normal/AlignBottomRight/KnightTitleMenu/Requirements/Storehouse"
    local RequiredCastle = "/InGame/Root/Normal/AlignBottomRight/KnightTitleMenu/Requirements/Castle"
    local RequiredRichBuildings = "/InGame/Root/Normal/AlignBottomRight/KnightTitleMenu/Requirements/RichBuildings"

    SetIcon(RequiredCathedral .. "/Icon", {4,5})
    SetIcon(RequiredStorehouse .. "/Icon", {4,6})
    SetIcon(RequiredCastle .. "/Icon", {4,7})
    SetIcon(RequiredRichBuildings .. "/Icon", {8,4})

    local PlayerID = GUI.GetPlayerID()
    local CurrentTitle = Logic.GetKnightTitle(PlayerID)

    local NextTitle = CurrentTitle + 1

    --Headline
    local KnightID = Logic.GetKnightID(PlayerID)
    local KnightType = Logic.GetEntityType(KnightID)

    XGUIEng.SetText("/InGame/Root/Normal/AlignBottomRight/KnightTitleMenu/NextKnightTitle", "{center}" .. GUI_Knight.GetTitleNameByTitleID(KnightType, NextTitle))
    XGUIEng.SetText("/InGame/Root/Normal/AlignBottomRight/KnightTitleMenu/NextKnightTitleWhite", "{center}" .. GUI_Knight.GetTitleNameByTitleID(KnightType, NextTitle))

    --show Settlers
    if KnightTitleRequirements[NextTitle].Settlers ~= nil then

        local IsFulfilled, CurrentAmount, NeededAmount = DoesNeededNumberOfSettlersForKnightTitleExist(PlayerID, NextTitle)

        XGUIEng.SetText(RequiredSettlers .. "/Amount", "{center}" .. CurrentAmount .. "/" .. NeededAmount)

        if IsFulfilled then
            XGUIEng.ShowWidget(RequiredSettlers .. "/Done", 1)
        else
            XGUIEng.ShowWidget(RequiredSettlers .. "/Done", 0)
        end

        XGUIEng.ShowWidget(RequiredSettlers, 1)
    else
        XGUIEng.ShowWidget(RequiredSettlers, 0)
    end

    -- set good or decoration type
    if KnightTitleRequirements[NextTitle].Good ~= nil then

        local IsFulfilled, CurrentAmount, NeededAmount = DoNeededNumberOfGoodsForKnightTitleExist(PlayerID, NextTitle)

        local EntityCategory = KnightTitleRequirements[NextTitle].Good[1]
        SetIcon(RequiredGoods .. "/Icon", g_TexturePositions.EntityCategories[EntityCategory])

        XGUIEng.SetText(RequiredGoods .. "/Amount", "{center}" .. CurrentAmount .. "/" .. NeededAmount)

        if IsFulfilled then
            XGUIEng.ShowWidget(RequiredGoods .. "/Done", 1)
        else
            XGUIEng.ShowWidget(RequiredGoods .. "/Done", 0)
        end

        XGUIEng.ShowWidget(RequiredGoods , 1)

    elseif KnightTitleRequirements[NextTitle].DecoratedBuildings ~= nil then

        local IsFulfilled, CurrentAmount, NeededAmount = DoNeededNumberOfDecoratedBuildingsForKnightTitleExist(PlayerID, NextTitle)

        if KnightTitleRequirements[NextTitle].DecoratedBuildings[1] == -1 then
            SetIcon(RequiredGoods.."/Icon"  , g_TexturePositions.Needs[Needs.Wealth])
        else
            local GoodType = KnightTitleRequirements[NextTitle].DecoratedBuildings[1]
            SetIcon(RequiredGoods.."/Icon"  , g_TexturePositions.Goods[GoodType])
        end

        XGUIEng.SetText(RequiredGoods .. "/Amount", "{center}" .. CurrentAmount .. "/" .. NeededAmount)

        if IsFulfilled then
            XGUIEng.ShowWidget(RequiredGoods .. "/Done", 1)
        else
            XGUIEng.ShowWidget(RequiredGoods .. "/Done", 0)
        end

        XGUIEng.ShowWidget(RequiredGoods, 1)
    else
        XGUIEng.ShowWidget(RequiredGoods, 0)
    end


    --show rich buildings
    if KnightTitleRequirements[NextTitle].RichBuildings ~= nil then

        local IsFulfilled, CurrentAmount, NeededAmount = DoNeededNumberOfRichBuildingsForKnightTitleExist(PlayerID, NextTitle)

        if NeededAmount == -1 then
            NeededAmount = Logic.GetNumberOfPlayerEntitiesInCategory(PlayerID, EntityCategories.CityBuilding)
        end

        XGUIEng.SetText(RequiredRichBuildings .. "/Amount", "{center}" .. CurrentAmount .. "/" .. NeededAmount)

        if IsFulfilled then
            XGUIEng.ShowWidget(RequiredRichBuildings .. "/Done", 1)
        else
            XGUIEng.ShowWidget(RequiredRichBuildings .. "/Done", 0)
        end

        XGUIEng.ShowWidget(RequiredRichBuildings, 1)
    else
        XGUIEng.ShowWidget(RequiredRichBuildings, 0)
    end

    --Castle
    if KnightTitleRequirements[NextTitle][EntityCategories.Headquarters] ~= nil then

        local IsFulfilled, CurrentAmount, NeededAmount = DoNeededSpecialBuildingUpgradeForKnightTitleExist(PlayerID, NextTitle, EntityCategories.Headquarters)

        XGUIEng.SetText(RequiredCastle .. "/Amount", "{center}" .. CurrentAmount + 1 .. "/" .. NeededAmount + 1)

        if IsFulfilled then
            XGUIEng.ShowWidget(RequiredCastle .. "/Done", 1)
        else
            XGUIEng.ShowWidget(RequiredCastle .. "/Done", 0)
        end
    else
        XGUIEng.ShowWidget(RequiredCastle, 0)
    end

    --Storehouse
    if KnightTitleRequirements[NextTitle][EntityCategories.Storehouse] ~= nil then

        local IsFulfilled, CurrentAmount, NeededAmount = DoNeededSpecialBuildingUpgradeForKnightTitleExist(PlayerID, NextTitle, EntityCategories.Storehouse)

        XGUIEng.SetText(RequiredStorehouse .. "/Amount", "{center}" .. CurrentAmount + 1 .. "/" .. NeededAmount + 1)

        if IsFulfilled then
            XGUIEng.ShowWidget(RequiredStorehouse .. "/Done", 1)
        else
            XGUIEng.ShowWidget(RequiredStorehouse .. "/Done", 0)
        end

        XGUIEng.ShowWidget(RequiredStorehouse, 1)
    else
        XGUIEng.ShowWidget(RequiredStorehouse, 0)
    end

    --Cathedral
    if KnightTitleRequirements[NextTitle][EntityCategories.Cathedrals] ~= nil then

        local IsFulfilled, CurrentAmount, NeededAmount = DoNeededSpecialBuildingUpgradeForKnightTitleExist(PlayerID, NextTitle, EntityCategories.Cathedrals)

        XGUIEng.SetText(RequiredCathedral .. "/Amount", "{center}" .. CurrentAmount + 1 .. "/" .. NeededAmount + 1)

        if IsFulfilled then
            XGUIEng.ShowWidget(RequiredCathedral .. "/Done", 1)
        else
            XGUIEng.ShowWidget(RequiredCathedral .. "/Done", 0)
        end

        XGUIEng.ShowWidget(RequiredCathedral, 1)
    else
        XGUIEng.ShowWidget(RequiredCathedral, 0)
    end

end


function GUI_Knight.UpdateNewNeedsAndRights()

    if TechnologiesNotShownForKnightTitle == nil then
        TechnologiesNotShownForKnightTitle = {}
        TechnologiesNotShownForKnightTitle[Technologies.R_Nutrition] = true
        TechnologiesNotShownForKnightTitle[Technologies.R_Clothes] = true
        TechnologiesNotShownForKnightTitle[Technologies.R_Hygiene] = true
        TechnologiesNotShownForKnightTitle[Technologies.R_Entertainment] = true
        TechnologiesNotShownForKnightTitle[Technologies.R_Wealth] = true
        TechnologiesNotShownForKnightTitle[Technologies.R_Prosperity] = true
        TechnologiesNotShownForKnightTitle[Technologies.R_Military] = true
        TechnologiesNotShownForKnightTitle[Technologies.R_SpecialEdition] = true
        TechnologiesNotShownForKnightTitle[Technologies.R_SpecialEdition_Column] = true
        TechnologiesNotShownForKnightTitle[Technologies.R_SpecialEdition_Pavilion] = true
        TechnologiesNotShownForKnightTitle[Technologies.R_SpecialEdition_StatueDario] = true
        TechnologiesNotShownForKnightTitle[Technologies.R_SpecialEdition_StatueFamily] = true
        TechnologiesNotShownForKnightTitle[Technologies.R_SpecialEdition_StatueProduction] = true
        TechnologiesNotShownForKnightTitle[Technologies.R_SpecialEdition_StatueSettler] = true
        TechnologiesNotShownForKnightTitle[Technologies.R_Victory] = true
    end


    local RewardBaseWidgetName = "/InGame/Root/Normal/AlignBottomRight/KnightTitleMenu/NewRights/RightsIcon"
    local NewNeedBaseWidgetName = "/InGame/Root/Normal/AlignBottomRight/KnightTitleMenu/NewRights/NeedsIcon"

    local PlayerID = GUI.GetPlayerID()
    local CurrentTitle = Logic.GetKnightTitle(PlayerID)

    local NextTitle = CurrentTitle + 1


    GUI_Knight.NextRightsForTitle = {}

    local AmountOfRights  = 0

    local TechnologyTypeTable = NeedsAndRightsByKnightTitle[NextTitle][4]

    if TechnologyTypeTable ~= nil then

        for i=1, #TechnologyTypeTable do

            local TechnologyType = TechnologyTypeTable[i]

            if      TechnologiesNotShownForKnightTitle[TechnologyType] ~= true
                and ( Logic.TechnologyGetState(PlayerID, TechnologyType) ~= TechnologyStates.Locked
                or EnableRights ~= true ) then

                local ButtonIndex = AmountOfRights + 1
                GUI_Knight.NextRightsForTitle[ButtonIndex] = TechnologyType

                AmountOfRights = AmountOfRights + 1
            end

        end
    end


    GUI_Knight.NextNeedsForTitle ={}

    local AmountOfNeeds = 0

    local NeedsTable = NeedsAndRightsByKnightTitle[NextTitle][2]

    if NeedsTable ~= nil then
        for i=1, #NeedsTable do

            local Need = NeedsTable[i]

            local ButtonIndex = AmountOfNeeds + 1
            GUI_Knight.NextNeedsForTitle[ButtonIndex] = Need

            AmountOfNeeds = AmountOfNeeds + 1

        end
    end


    for i=1, #GUI_Knight.NextRightsForTitle do
        local TechnologyType =  GUI_Knight.NextRightsForTitle[i]
        local Button = RewardBaseWidgetName .. i
        XGUIEng.ShowWidget(Button,1)
        SetIcon(Button, g_TexturePositions.Technologies[TechnologyType])
    end

    for i=#GUI_Knight.NextRightsForTitle+1, 8 do
        local Button = RewardBaseWidgetName .. i
        XGUIEng.ShowWidget(Button,0)
    end

    for i=1, #GUI_Knight.NextNeedsForTitle do
        local Need =  GUI_Knight.NextNeedsForTitle[i]
        local Button = NewNeedBaseWidgetName .. i
        XGUIEng.ShowWidget(Button,1)
        SetIcon(Button, g_TexturePositions.Needs[Need])
    end

    for i=#GUI_Knight.NextNeedsForTitle+1, 3 do
        local Button = NewNeedBaseWidgetName .. i
        XGUIEng.ShowWidget(Button,0)
    end

end


function GUI_Knight.RequiredGoodTooltip()

    local PlayerID = GUI.GetPlayerID()
    local CurrentTitle = Logic.GetKnightTitle(PlayerID)

    local NextTitle = CurrentTitle + 1

    if KnightTitleRequirements[NextTitle].Good ~= nil then

        local ToolTipKeyName

        if KnightTitleRequirements[NextTitle].Good[1] == EntityCategories.GC_Clothes_Supplier then
            ToolTipKeyName = "NeededClothes"
        elseif KnightTitleRequirements[NextTitle].Good[1] == EntityCategories.GC_Hygiene_Supplier then
            ToolTipKeyName = "NeededHygiene"
        elseif KnightTitleRequirements[NextTitle].Good[1] == EntityCategories.GC_Entertainment_Supplier then
            ToolTipKeyName = "NeededEntertainment"
        end

        GUI_Tooltip.TooltipNormal(ToolTipKeyName)

    elseif KnightTitleRequirements[NextTitle].DecoratedBuildings ~= nil then

        if KnightTitleRequirements[NextTitle].DecoratedBuildings[1] == -1 then
            GUI_Tooltip.TooltipNormal("NeededDecorationObjects")
        else
            GUI_Tooltip.TooltipNormal("NeededDecorationBanners")
        end
    end

end


function GUI_Knight.RewardTooltip(_ButtonIndex)

    local PlayerID = GUI.GetPlayerID()

    local TechnologyType = GUI_Knight.NextRightsForTitle[_ButtonIndex]

    local TechnologyTypeName =  GetNameOfKeyInTable(Technologies, TechnologyType)

    local Name = string.gsub(TechnologyTypeName, "R_", "")

    --take building tooltip
    local Key = "B_" .. Name

    --take unit tooltip
    if XGUIEng.GetStringTableText("UI_ObjectNames/" .. Key) == "" then
        Key = "U_" .. Name
    end

    --take StartFesival or StartSermon tooltip
    if XGUIEng.GetStringTableText("UI_ObjectNames/" .. Key) == "" then
        Key = "Start" .. Name
    end

    --take technology tooltip
    if XGUIEng.GetStringTableText("UI_ObjectNames/" .. Key) == "" then
        Key = "R_" .. Name
    end

    GUI_Tooltip.TooltipNormal(Key)

end


function GUI_Knight.NeedTooltip(_ButtonIndex)

    local PlayerID = GUI.GetPlayerID()

    local Need = GUI_Knight.NextNeedsForTitle[_ButtonIndex]

    local NeedTooltip = GetNameOfKeyInTable(Needs, Need) .."Tooltip"

    if NeedTooltip == "HygieneTooltip" then
        NeedTooltip = "CleanlinessTooltip"
    elseif NeedTooltip == "WealthTooltip" then
        NeedTooltip = "DecorationTooltip"
    end

    GUI_Tooltip.TooltipNormal(NeedTooltip)

end


function GUI_Knight.PromoteKnightUpdate()

    if XGUIEng.IsWidgetShown("/InGame/Root/Normal/AlignBottomRight/KnightTitleMenu") == 0 then
        return
    end

    local PlayerID = GUI.GetPlayerID()

    GUI_Knight.UpdateRequirements()
    GUI_Knight.UpdateNewNeedsAndRights()

    if EnableRights ~= true or CanKnightBePromoted( PlayerID ) then

        --set icon corresponding to knight title
        local NextTitle = Logic.GetKnightTitle(PlayerID) + 1
        local NextTitleName = GetNameOfKeyInTable(KnightTitles, NextTitle)
        local IconPosition = g_TexturePositions.KnightTitles[KnightTitles[NextTitleName]]
        SetIcon("/InGame/Root/Normal/AlignTopCenter/KnightTitleMenuBig/PromoteKnight", IconPosition)


        local PlayerID = GUI.GetPlayerID()
        local KnightID = Logic.GetKnightID(PlayerID)
        local CurrentTitle = Logic.GetKnightTitle(PlayerID)
        local KnightType = Logic.GetEntityType(KnightID)

        local CurrentTitleName  = GUI_Knight.GetTitleNameByTitleID( KnightType, CurrentTitle)
        local NextTitleName  = GUI_Knight.GetTitleNameByTitleID( KnightType, CurrentTitle+1)

        local KnightName = XGUIEng.GetStringTableText("Names/" .. Logic.GetEntityTypeName(KnightType) )

        --current title
        XGUIEng.SetText("/InGame/Root/Normal/AlignTopCenter/KnightTitleMenuBig/TheRest/Title/Name", "{center}" .. CurrentTitleName .. " " .. KnightName)
        XGUIEng.SetText("/InGame/Root/Normal/AlignTopCenter/KnightTitleMenuBig/TheRest/Title/NameWhite", "{center}" .. CurrentTitleName .. " " .. KnightName)

        --next title
        XGUIEng.SetText("/InGame/Root/Normal/AlignTopCenter/KnightTitleMenuBig/TheRest/NextTitle/Name", "{center}" .. XGUIEng.GetStringTableText("UI_Texts/PromoteTo_colon") .. " " .. NextTitleName)

        --main text
        local KeyName = "PromotionLetter_" .. GetNameOfKeyInTable(KnightTitles, CurrentTitle+1) .. "_" .. KnightGender[KnightType]
        XGUIEng.SetText("/InGame/Root/Normal/AlignTopCenter/KnightTitleMenuBig/TheRest/MainText",  XGUIEng.GetStringTableText("UI_Texts/" .. KeyName))

        --bottomtext
        local KeyName = "PromotionLetter_End_" .. Profile.GetString("Profile", "Gender")
        XGUIEng.SetText("/InGame/Root/Normal/AlignTopCenter/KnightTitleMenuBig/TheRest/EndText",  XGUIEng.GetStringTableText("UI_Texts/" .. KeyName))


        --hide the weather menu if open
        XGUIEng.ShowWidget("/InGame/Root/Normal/AlignBottomRight/WeatherMenu", 0)
        --and deselect the current selection, to avoid overlap between selection menu and KnightTitleMenuBig
        GUI.ClearSelection()

        --then show the big window
        XGUIEng.ShowWidget("/InGame/Root/Normal/AlignTopCenter/KnightTitleMenuBig",1)
        XGUIEng.ShowWidget("/InGame/Root/Normal/AlignBottomRight/KnightTitleMenu",1)

    else
        XGUIEng.ShowWidget("/InGame/Root/Normal/AlignTopCenter/KnightTitleMenuBig",0)
    end

end


function GUI_Knight.KnightTitleClicked()
    Sound.FXPlay2DSound("ui\\menu_click")

    local KnightTitleMenu = "/InGame/Root/Normal/AlignBottomRight/KnightTitleMenu"
    local KnightTitleMenuBig = "/InGame/Root/Normal/AlignTopCenter/KnightTitleMenuBig"

    local PlayerID = GUI.GetPlayerID()
    local CurrentTitle = Logic.GetKnightTitle(PlayerID)

    if CurrentTitle == KnightTitles.Archduke or IsKnightTitleLockedForPlayer( PlayerID, CurrentTitle + 1 ) then
        return
    end

    if XGUIEng.IsWidgetShown(KnightTitleMenu) == 1 then
        XGUIEng.ShowWidget(KnightTitleMenu,0)
        XGUIEng.ShowWidget(KnightTitleMenuBig,0)
    else
        HideOtherMenus()
        XGUIEng.ShowWidget(KnightTitleMenu,1)
    end

    if XGUIEng.GetCurrentWidgetID() ~= 0 then
        SaveButtonPressed(XGUIEng.GetCurrentWidgetID())
    end

end


function GUI_Knight.KnightTitleUpdate()

    local CurrentWidgetID =  XGUIEng.GetCurrentWidgetID()
    local PlayerID = GUI.GetPlayerID()
    local KnightID = Logic.GetKnightID(PlayerID)

    if KnightID == 0 then
        return
    end

    local CurrentTitle = Logic.GetKnightTitle(PlayerID)
    local CurrentTitleName = GetNameOfKeyInTable(KnightTitles, CurrentTitle)
    local IconPosition = g_TexturePositions.KnightTitles[KnightTitles[CurrentTitleName]]
    SetIcon(CurrentWidgetID, IconPosition)

    local IsLocked = IsKnightTitleLockedForPlayer( PlayerID, CurrentTitle + 1 )

    if CanKnightBePromoted(PlayerID) and not IsLocked then
        XGUIEng.ShowWidget("/InGame/Root/Normal/AlignBottomRight/MapFrame/KnightPromoteBG", 1)
    else
        XGUIEng.ShowWidget("/InGame/Root/Normal/AlignBottomRight/MapFrame/KnightPromoteBG", 0)
    end

    if CurrentTitle == KnightTitles.Archduke or IsLocked then
        XGUIEng.ShowWidget("/InGame/Root/Normal/AlignBottomRight/MapFrame/KnightFinal", 1)
        SetIcon("/InGame/Root/Normal/AlignBottomRight/MapFrame/KnightFinal/KnightFinalIcon", IconPosition)
        XGUIEng.SetHandleEvents(CurrentWidgetID,0)
    else
        XGUIEng.ShowWidget("/InGame/Root/Normal/AlignBottomRight/MapFrame/KnightFinal", 0)
        XGUIEng.SetHandleEvents(CurrentWidgetID,1)
    end

    if XGUIEng.IsWidgetShown("/InGame/Root/Normal/AlignBottomRight/KnightTitleMenu") then
        GUI_Knight.PromoteKnightUpdate()
    end

end


function GUI_Knight.KnightTitleMouseOver(_OptionalFinalTitleBoolean)

    local PlayerID = GUI.GetPlayerID()
    local KnightID = Logic.GetKnightID(PlayerID)

    if KnightID == 0 then
        return
    end

    local CurrentTitle = Logic.GetKnightTitle(PlayerID)
    local KnightType = Logic.GetEntityType(KnightID)

    if KnightID == nil
    or KnightID == 0 then
        KnightType = Entities.U_KnightTrading
    end

    local Prefix

    if _OptionalFinalTitleBoolean == true then
        Prefix = "Title_MenuFinal_"
    else
        Prefix = "Title_Menu_"
    end

    local KeyName = Prefix .. GetNameOfKeyInTable(KnightTitles, CurrentTitle) .. "_" .. KnightGender[KnightType]

    GUI_Tooltip.TooltipNormal(KeyName)

end


function GUI_Knight.JumpToButtonClicked()
    local PlayerID = GUI.GetPlayerID()
    local KnightID = Logic.GetKnightID(PlayerID)

    if KnightID > 0 then

        GUI.SetSelectedEntity(KnightID)
        GUI_MultiSelection.CreateMultiSelection(g_SelectionChangedSource.User)

        if ((Framework.GetTimeMs() - g_Selection.LastClickTime ) < g_Selection.MaxDoubleClickTime) then
            local pos = GetPosition(KnightID)
            Camera.RTS_SetLookAtPosition(pos.X, pos.Y)
        else
            Sound.FXPlay2DSound("ui\\mini_knight")
        end

        -- update the last click time
        g_Selection.LastClickTime = Framework.GetTimeMs()
    else
        GUI.AddNote("Debug: You do not have a knight")
    end

end


function GUI_Knight.KnightButtonUpdate()

    local CurrentWidgetID =  XGUIEng.GetCurrentWidgetID()
    local PlayerID = GUI.GetPlayerID()
    local KnightID = Logic.GetKnightID(PlayerID)

    if KnightID == 0 then
        return
    end

    local Progress = Logic.KnightGetResurrectionProgress(KnightID)

    if Progress == 1 then
        XGUIEng.DisableButton(CurrentWidgetID, 0)
    else
        XGUIEng.DisableButton(CurrentWidgetID, 1)
    end

end


function GUI_Knight.RespawnProgressUpdate()

    local CurrentWidgetID =  XGUIEng.GetCurrentWidgetID()
    local PlayerID = GUI.GetPlayerID()
    local KnightID = Logic.GetKnightID(PlayerID)

    if KnightID == 0 then
        return
    end

    local Progress = Logic.KnightGetResurrectionProgress(KnightID)

    if Progress == 1 then
        XGUIEng.SetMaterialColor(CurrentWidgetID, 0, 255, 255, 255, 0)
    else
        XGUIEng.SetMaterialColor(CurrentWidgetID, 0, 255, 255, 255, 150)

        Progress = math.floor(Progress * 100)

        XGUIEng.SetProgressBarValues(CurrentWidgetID, Progress + 10, 110) --visible from the start
    end

end


function GUI_Knight.ClaimTerritoryClicked()

    local PlayerID = GUI.GetPlayerID()
    local KnightID = GUI.GetSelectedEntity()
    local TerritoryID = GetTerritoryUnderEntity(KnightID)
    local TerritoryPlayerID = Logic.GetTerritoryPlayerID(TerritoryID)

    if TerritoryPlayerID ~= 0 then
        if TerritoryPlayerID == PlayerID then
            local MessageText = XGUIEng.GetStringTableText("Feedback_TextLines/TextLine_TerritoryAlreadyOwned")
            Message(MessageText)
        else
            local MessageText = XGUIEng.GetStringTableText("Feedback_TextLines/TextLine_TerritoryAlreadyClaimed")
            Message(MessageText)
        end

        return
    end

    local OutpostType = GetEntityTypeForClimatezone("B_Outpost")
    local Costs = {Logic.GetEntityTypeFullCost(OutpostType)}

    local TerritoryCost = Logic.GetTerritoryGoldPrice(TerritoryID)
    local IsTerritoryCostInserted = false

    --in case the outpost costs already contain gold
    for i = 1, #Costs, 2 do
        if Costs[i] == Goods.G_Gold then
            Costs[i + 1] = Costs[i + 1] + TerritoryCost
            IsTerritoryCostInserted = true
        end
    end

    --add the territory cost
    if IsTerritoryCostInserted == false then
        table.insert(Costs, Goods.G_Gold)
        table.insert(Costs, TerritoryCost)
    end

    local CanBuyBoolean, CanNotBuyString = AreCostsAffordable(Costs)

    if CanBuyBoolean == true then
        Sound.FXPlay2DSound( "ui\\menu_click")
        if TerritoryPlayerID == 0 then
            local UpgradeCategory = GetUpgradeCategoryForClimatezone("Outpost")
            GUI_Construction.BuildClicked(UpgradeCategory)
        end
    else
        Message(CanNotBuyString)
    end

end


function GUI_Knight.ClaimTerritoryMouseOver()

    local PlayerID = GUI.GetPlayerID()
    local CurrentWidgetID =  XGUIEng.GetCurrentWidgetID()

    local Costs = {}
    local EntityType = GetEntityTypeForClimatezone("B_Outpost")

    local KnightID = GUI.GetSelectedEntity()
    local TerritoryID = GetTerritoryUnderEntity(KnightID)

    local WoodCosts = Logic.GetEntityTypeCostOfGoodType(EntityType, Goods.G_Wood)
    local StoneCosts= Logic.GetEntityTypeCostOfGoodType(EntityType, Goods.G_Stone)
    local GoldCosts = Logic.GetEntityTypeCostOfGoodType(EntityType, Goods.G_Gold)
    local TerritoryCost = Logic.GetTerritoryGoldPrice(TerritoryID)
    GoldCosts = GoldCosts + TerritoryCost

    Costs = {Goods.G_Gold, GoldCosts, Goods.G_Wood, WoodCosts, Goods.G_Stone, StoneCosts}

    local TooltipTextKey = "B_Outpost_ME"
    local TooltipDisabledTextKey
    local TerritoryPlayerID = Logic.GetTerritoryPlayerID(TerritoryID)

    if TerritoryPlayerID ~= 0 then
        if TerritoryPlayerID == PlayerID then
            TooltipDisabledTextKey = "OutpostOnOwnTerritory"
        else
            TooltipDisabledTextKey = "OutpostOnOtherPlayersTerritory"
        end

        Costs = {}
    end

    GUI_Tooltip.TooltipBuy(Costs, TooltipTextKey, TooltipDisabledTextKey)

end


function GUI_Knight.ClaimTerritoryUpdate()

    local CurrentWidgetID =  XGUIEng.GetCurrentWidgetID()
    local KnightID = GUI.GetSelectedEntity()
    local TerritoryID = GetTerritoryUnderEntity(KnightID)
    local TerritoryPlayerID = Logic.GetTerritoryPlayerID(TerritoryID)

    if TerritoryPlayerID ~= 0 then
        XGUIEng.DisableButton(CurrentWidgetID, 1)
    else
        XGUIEng.DisableButton(CurrentWidgetID, 0)
    end

end


function GUI_Knight.AbilityProgressUpdate()
    local CurrentWidgetID =  XGUIEng.GetCurrentWidgetID()
    local PlayerID = GUI.GetPlayerID()
    local KnightID = Logic.GetKnightID(PlayerID)

    if KnightID == 0 then
        return
    end

    local Ability = GUI_Knight.GetKnightAbilityAndIcons(KnightID)

    local TotalRechargeTime = Logic.KnightGetAbilityRechargeTime(KnightID, Ability)
    local TimeAlreadyCharged = Logic.KnightGetAbiltityChargeSeconds(KnightID, Ability)


    if TimeAlreadyCharged == TotalRechargeTime then
        XGUIEng.SetMaterialColor(CurrentWidgetID, 0, 255, 255, 255, 0)
    else
        XGUIEng.SetMaterialColor(CurrentWidgetID, 0, 255, 255, 255, 150)

        local Progress = math.floor((TimeAlreadyCharged / TotalRechargeTime) * 100)

        XGUIEng.SetProgressBarValues(CurrentWidgetID, Progress + 10, 110) --visible from the start
    end

end


function GUI_Knight.StartAbilityClicked(_Ability)

    local PlayerID = GUI.GetPlayerID()
    local KnightID = GUI.GetSelectedEntity()

    if KnightID == nil
    or Logic.IsKnight(KnightID) == false then
        return
    end

    local Ability = GUI_Knight.GetKnightAbilityAndIcons(KnightID)

    if (Ability == Abilities.AbilityHeal
    or Ability == Abilities.AbilityBard
    or Ability == Abilities.AbilityFood) then
        local MarketplaceID = Logic.GetMarketplace(PlayerID)

        if Logic.CheckEntitiesDistance(KnightID, MarketplaceID, 2000) == false then
            local MessageText = XGUIEng.GetStringTableText("Feedback_TextLines/TextLine_PromoteNearMarketplace")
            Message(MessageText)
            return
        end
    elseif Logic.GetEntityType(KnightID) == Entities.U_KnightRedPrince then
        --Do custom RP action here
        GUI.AddNote("Debug: RP doesnt have an ability yet!")
        Sound.FXPlay2DSound( "ui\\menu_click")
        HeroAbilityFeedback(KnightID)
        return
    end

    GUI.StartKnightAbility(KnightID,Ability)

    Sound.FXPlay2DSound( "ui\\menu_click")

    HeroAbilityFeedback(KnightID)
    
end

function GUI_Knight.GetKnightTooltipTextKey(_KnightID, _Ability)
    local KnightType = Logic.GetEntityType(_KnightID)
    local TooltipTextKey
    if KnightType == Entities.U_KnightSabatta then
        TooltipTextKey = "AbilityConvertCrimsonSabatt"
    elseif KnightType == Entities.U_KnightRedPrince then
        TooltipTextKey = "AbilityPlagueRedPrince"
    else
        for key, value in pairs (Abilities) do
            if value == _Ability then
                TooltipTextKey = key
            end
        end
    end
    return TooltipTextKey
end

function GUI_Knight.StartAbilityMouseOver()

    local CurrentWidgetID = XGUIEng.GetCurrentWidgetID()
    local KnightID = GUI.GetSelectedEntity()
    local Ability = GUI_Knight.GetKnightAbilityAndIcons(KnightID)
    local TooltipTextKey = GUI_Knight.GetKnightTooltipTextKey(KnightID, Ability)

    if XGUIEng.IsButtonDisabled(CurrentWidgetID) == 1 then
        local DisabledTooltipTextKey = TooltipTextKey

        local RechargeTime = Logic.KnightGetAbilityRechargeTime(KnightID, Ability)
        local TimeLeft = Logic.KnightGetAbiltityChargeSeconds(KnightID, Ability)

        if TimeLeft < RechargeTime then
            DisabledTooltipTextKey = "AbilityNotReady"
        end

        GUI_Tooltip.TooltipNormal(TooltipTextKey, DisabledTooltipTextKey)
    else
        GUI_Tooltip.TooltipNormal(TooltipTextKey)
    end

end


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

    if Ability == Abilities.AbilityPlunder then
        -- plunder department ---------------------------------------------------------------------
        -- check recharge time
        if TimeLeft < RechargeTime then
            DisableButton(CurrentWidgetID)
            return
        end

        if Logic.KnightPlunderIsPossible(KnightID) == 0 then
            DisableButton(CurrentWidgetID)
            return
        else
            StartKnightVoiceForActionSpecialAbility(Entities.U_KnightPlunder)
        end

        EnableButton(CurrentWidgetID)
        return

    elseif Ability == Abilities.AbilityTorch then
        -- torch department ---------------------------------------------------------------------
        -- check recharge time
        if TimeLeft < RechargeTime then
            DisableButton(CurrentWidgetID)
            return
        end

        EnableButton(CurrentWidgetID)
        return

    elseif Ability == Abilities.AbilityConvert then
        -- convert department ---------------------------------------------------------------------
        -- check recharge time
        if TimeLeft < RechargeTime then
            DisableButton(CurrentWidgetID)
            return
        end

        if Logic.KnightConvertIsPossible(KnightID) == 0 then
            DisableButton(CurrentWidgetID)
            return
        end

        EnableButton(CurrentWidgetID)
        return
    end

    if TimeLeft == RechargeTime then
        XGUIEng.DisableButton(CurrentWidgetID, 0)
    end

    if TimeLeft < RechargeTime then
        XGUIEng.DisableButton(CurrentWidgetID, 1)
    end

end


function DisableButton(id)

    XGUIEng.DisableButton(id,1)

end


function EnableButton(id)

    XGUIEng.DisableButton(id,0)

end

g_MusicVolume = 0

function GameCallback_KnightBardBegin(_PlayerId)

	if GUI.GetPlayerID() ~= _PlayerId then
	
		return
		
	end

    MusicSystem.NextMusicStartTime = 0

--	g_MusicVolume = Sound.GetMusicVolume()

--	Sound.SetMusicVolume((Sound.GetSpeechVolume() * Sound.GetGlobalVolume()) * 100.0);

	local KnightID = Logic.GetKnightID(GUI.GetPlayerID())
	
	local x,y = Logic.GetEntityPosition(KnightID)

	g_ThordalSongId = Sound.FXPlay3DSound("units\\knight_sing",x,y,0,false,false,-1)

--    StartEventMusic(MusicSystem.EventSinging, GUI.GetPlayerID())
    
    PresentationCallback_KnightBardBegin()
end


function GameCallback_KnightBardEnd()

	if g_ThordalSongId ~= -1 then
		
		Sound.FXStop3DSound(g_ThordalSongId)
		g_ThordalSongId = -1
		
	end

--	Sound.SetMusicVolume(g_MusicVolume);

--    StopEventMusic(MusicSystem.EventSinging, GUI.GetPlayerID())

end


function GameCallback_KnightHealBegin()

    --Sound.FXPlay2DSound("VoiceLeader\\LEADER_NO_rnd_01")
end


function GameCallback_KnightHealEnd()

end
