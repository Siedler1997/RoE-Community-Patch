
-----------------------------------------------------------------
-- Overwrites
-----------------------------------------------------------------


do
    local OldGUI_Knight_GetKnightAbilityAndIcons = GUI_Knight.GetKnightAbilityAndIcons
    
    function GUI_Knight.GetKnightAbilityAndIcons(_KnightID)
    
        local Ability
        local AbilityIconPosition = {11,2}
        local KnightType = Logic.GetEntityType(_KnightID)
    
        if KnightType == Entities.U_KnightWisdom or KnightType == Entities.U_KnightSabatta then
            Ability = Abilities.AbilityConvert
            AbilityIconPosition = {11,6}
        elseif KnightType == Entities.U_KnightRedPrince then
            Ability = Abilities.AbilityTribute
            AbilityIconPosition = {1,4,1}
            --Unused: Custom icon for PR illness ability
            --AbilityIconPosition = {15,16}
        elseif KnightType == Entities.U_KnightSaraya or KnightType == Entities.U_KnightPraphat then
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

        --[[
        --Unused ability for Red Prince. Doesn't work in MP games, so he uses tribute instead
        if Logic.GetEntityType(KnightID) == Entities.U_KnightRedPrince then
        
            if TimeLeft < RechargeTime then
                DisableButton(CurrentWidgetID)
                return
            end
        
            if Logic.KnightConvertIsPossible(KnightID) == 0 and GetNearbyEnemyMarketplace(KnightID) < 0 then
                DisableButton(CurrentWidgetID)
                return
            end
        
            StartKnightVoiceForActionSpecialAbility(Entities.U_KnightRedPrince)
        
            EnableButton(CurrentWidgetID)
            return
        --]]
    
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
        
        if Ability == Abilities.AbilityFood then
            if Logic.GetEntityType(KnightID) == Entities.U_KnightTrading then
                GUI.AddBuff(Buffs.Buff_FoodDiversity)
            elseif Logic.GetEntityType(KnightID) == Entities.U_KnightPraphat then
                GUI.AddBuff(Buffs.Buff_ClothesDiversity)
            end
        elseif Ability == Abilities.Buff_EntertainmentDiversity then
            GUI.AddBuff(Buffs.Buff_EntertainmentDiversity)
        end

    --[[
    --Unused ability for Red Prince. Doesn't work in MP games, so he uses tribute instead
    elseif Logic.GetEntityType(KnightID) == Entities.U_KnightRedPrince then
        -- First Part: Spread illness at enemy marketplace
        local MarketplaceID = GetNearbyEnemyMarketplace(KnightID)
        if MarketplaceID > 0 then
            local EnemyPlayerId = Logic.EntityGetPlayer(MarketplaceID)
            -- Nur möglich, wenn der Gegner mindestens Baron ist und somit Zugang zur Apotheke hat
            if Logic.GetKnightTitle(EnemyPlayerId) >= 2 then
                local Buildings = {Logic.GetPlayerEntitiesInCategory(EnemyPlayerId, EntityCategories.CityBuilding)}
                for i = 1, #Buildings/2 do
                    -- Bis zu 50% der Gebäude können befallen werden
                    local BuildingID = Buildings[i]
                    if IsNear(MarketplaceID, BuildingID, 5000) then 
                        GUI.SendScriptCommand("Logic.MakeBuildingIll("..BuildingID..")")   --Bug: Bricht die Schleife ab (Error)
                    end  
                end
            else
                --ToDo: Hinweis, dass der Gegner noch nicht soweit ist
            end
        end
        
        -- Second Part: Deal light AOE-damage
        GUI.SendScriptCommand("Logic.HurtEntity("..KnightID..", "..(500)..")")
    --]]
    elseif Ability == Abilities.AbilityConvert then
        -- don't convert far beyond soldier limit
        if Logic.GetCurrentSoldierCount(PlayerID) >= Logic.GetCurrentSoldierLimit(PlayerID) then
            Message(XGUIEng.GetStringTableText("Feedback_TextLines/TextLine_SoldierLimitReached"))
            return
        end
    end

    GUI.StartKnightAbility(KnightID,Ability)

    Sound.FXPlay2DSound( "ui\\menu_click")

    HeroAbilityFeedback(KnightID)
    
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
        
        if Logic.GetKnightTitle(_PlayerID) == 6 then
            StartEventMusic(MusicSystem.EventPromotion2Music, _PlayerID)
        else
            StartEventMusic(MusicSystem.EventPromotionMusic, _PlayerID)
        end
    end

    XGUIEng.ShowWidget("/InGame/Root/Normal/AlignBottomRight/KnightTitleMenu", 0)
    XGUIEng.ShowWidget("/InGame/Root/Normal/AlignTopCenter/KnightTitleMenuBig", 0)
    g_TimeOfPromotionPossible = nil
    g_WantsPromotionMessageInterval = 30
end


-- Gibt die EntityId eines feindlichen Marktplatzes in der Nähe zurück
function GetNearbyEnemyMarketplace(_KnightID)
    local playerId = Logic.EntityGetPlayer(_KnightID)
    local marketplace = -1

    for i = 1, 8 do
        if playerId ~= i then
            if Diplomacy_GetRelationBetween(playerId, i) == DiplomacyStates.Enemy then
                local MarketplaceID = Logic.GetMarketplace(i)
                if IsNear(_KnightID, MarketplaceID, 1000) then
                    nearby = true
                    marketplace = MarketplaceID
                end
            end
        end
    end
    return marketplace
end

-- Gibt den Spezialeinheiten-Typ einer bestimmten Ritters-Gebäudes-Kombination zurück
function GetKnightSpecialBattalionType(_knightId, _buildingId, _tier, _special)
    local KnightType = Logic.GetEntityType(_knightId)
    local BuildingType = Logic.GetEntityType(_buildingId)
    local BattalionType = 0
    
    if BuildingType == Entities.B_Barracks or BuildingType == Entities.B_Barracks_RedPrince or BuildingType == Entities.B_Barracks_Khana then
        if _tier == 1 then
            if _special == true then 
                if KnightType == Entities.U_KnightTrading then
                    BattalionType = Entities.U_MilitaryBandit_Ranged_SE     --U_Military_TradeMilitia_Range
                elseif KnightType == Entities.U_KnightPlunder then
                    BattalionType = Entities.U_MilitaryBandit_Ranged_ME     --U_Military_Outlaw_Range
                elseif KnightType == Entities.U_KnightWisdom then
                    BattalionType = Entities.U_MilitaryBandit_Ranged_NA     --U_Military_Nomad_Range
                elseif KnightType == Entities.U_KnightSong then
                    BattalionType = Entities.U_MilitaryBandit_Ranged_NE     --U_Military_Viking_Range
                elseif KnightType == Entities.U_KnightRedPrince then
                    BattalionType = Entities.U_MilitaryBow_RedPrince
                elseif KnightType == Entities.U_KnightSaraya then
                    BattalionType = Entities.U_MilitaryBandit_Ranged_AS     --U_Military_Exile_Range
                elseif KnightType == Entities.U_KnightKhana then
                    BattalionType = Entities.U_MilitaryBow_Khana
                end
            else
                BattalionType = Entities.U_MilitarySword
            end
        elseif _tier == 2 then
            if _special == true then 
                if KnightType == Entities.U_KnightHealing then
                    BattalionType = Entities.U_MilitaryCavalry      --U_Military_Paladin
                end
            else
                BattalionType = Entities.U_MilitaryCavalry
            end
        end
    elseif (BuildingType == Entities.B_BarracksArchers or BuildingType == Entities.B_BarracksArchers_Redprince or BuildingType == Entities.B_BarracksArchers_Khana) and _tier == 1 then
        if _special == true then 
            if KnightType == Entities.U_KnightTrading then
                BattalionType = Entities.U_MilitaryBandit_Melee_SE     --U_Military_TradeMilitia_Range
            elseif KnightType == Entities.U_KnightPlunder then
                BattalionType = Entities.U_MilitaryBandit_Melee_ME     --U_Military_Outlaw_Range
            elseif KnightType == Entities.U_KnightWisdom then
                BattalionType = Entities.U_MilitaryBandit_Melee_NA     --U_Military_Nomad_Range
            elseif KnightType == Entities.U_KnightSong then
                BattalionType = Entities.U_MilitaryBandit_Melee_NE     --U_Military_Viking_Range
            elseif KnightType == Entities.U_KnightRedPrince then
                BattalionType = Entities.U_MilitarySword_RedPrince
            elseif KnightType == Entities.U_KnightSaraya then
                BattalionType = Entities.U_MilitaryBandit_Melee_AS     --U_Military_Exile_Range
            elseif KnightType == Entities.U_KnightKhana then
                BattalionType = Entities.U_MilitarySword_Khana
            end
        else
            BattalionType = Entities.U_MilitaryBow
        end
    elseif BuildingType == Entities.B_BarracksSpearmen and _tier == 1 then
        if _special == true then 
            if KnightType == Entities.U_KnightChivalry then
                BattalionType = Entities.U_MilitarySpear    --U_Military_Helbardier
            end
        else
            BattalionType = Entities.U_MilitarySpear
        end
    elseif BuildingType == Entities.B_StoreHouse and _tier == 1 and _special == false then
        BattalionType = Entities.U_AmmunitionCart
    elseif Logic.IsEntityInCategory(_buildingId, EntityCategories.Headquarters) == 1 and _tier == 1 then
        if _special == true then
            if KnightType == Entities.U_KnightSabatta then
                BattalionType = Entities.U_Thief    --U_Assassin
            end
        else
            BattalionType = Entities.U_Thief
        end
    end

    return BattalionType
end

function GetBattalionBuyTooltipString(_BattalionType)
    local TooltipString

    if _BattalionType == Entities.U_MilitarySword then
        TooltipString = "BuySwordfighters"
    elseif _BattalionType == Entities.U_MilitaryBow then
        TooltipString = "BuyBowmen"
    elseif _BattalionType == Entities.U_MilitarySpear then
        TooltipString = "BuySpearmen"
    elseif _BattalionType == Entities.U_MilitaryCavalry then
        TooltipString = "BuyCavalry"
    elseif _BattalionType == Entities.U_AmmunitionCart then
        TooltipString = "BuyAmmunitionCart"
    elseif _BattalionType == Entities.U_Thief then
        TooltipString = "BuyThief"
    elseif _BattalionType == Entities.U_Military_Helbardier then
        TooltipString = "BuyHelbardier"
    elseif _BattalionType == Entities.U_Military_Paladin then
        TooltipString = "BuyPaladin"
    elseif _BattalionType == Entities.U_Military_TradeMilitia_Melee then
        TooltipString = "BuyTradeMilitiaMelee"
    elseif _BattalionType == Entities.U_Military_TradeMilitia_Range then
        TooltipString = "BuyTradeMilitiaRange"
    elseif _BattalionType == Entities.U_Military_Outlaw_Melee then
        TooltipString = "BuyOutlawMelee"
    elseif _BattalionType == Entities.U_Military_Outlaw_Range then
        TooltipString = "BuyOutlawRange"
    elseif _BattalionType == Entities.U_Military_Nomad_Melee then
        TooltipString = "BuyNomadMelee"
    elseif _BattalionType == Entities.U_Military_Nomad_Range then
        TooltipString = "BuyNomadRange"
    elseif _BattalionType == Entities.U_Military_Viking_Melee then
        TooltipString = "BuyVikingMelee"
    elseif _BattalionType == Entities.U_Military_Viking_Range then
        TooltipString = "BuyVikingRange"
    elseif _BattalionType == Entities.U_Assassin then
        TooltipString = "BuyAssassin"
    elseif _BattalionType == Entities.U_MilitarySword_RedPrince then
        TooltipString = "BuyGuardMelee"
    elseif _BattalionType == Entities.U_MilitaryBow_RedPrince then
        TooltipString = "BuyGuardRange"
    elseif _BattalionType == Entities.U_Military_Exile_Melee then
        TooltipString = "BuyExileMelee"
    elseif _BattalionType == Entities.U_Military_Exile_Range then
        TooltipString = "BuyExileRange"
    elseif _BattalionType == Entities.U_Military_Cannon then
        TooltipString = "BuyCannon"
    elseif _BattalionType == Entities.U_MilitarySword_Khana then
        TooltipString = "BuyFanaticMelee"
    elseif _BattalionType == Entities.U_MilitaryBow_Khana then
        TooltipString = "BuyFanaticRange"
    end

    return TooltipString
end