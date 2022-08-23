-- **********************************************************************
-- Feedback functions
-- **********************************************************************

function GameCallback_Feedback_BanditsCampDestroyed(_PlayerID, _EntityID, _Xcm, _Ycm)
    -- note: _EntityID is merely interesting if you have stored EntityIDs to compare
    -- it with.  By the time you get this call, that _EntityID may already have 
    -- become invalid!
    --GUI.AddNote("BanditCamp of player " .. _PlayerID .. " with ID " .. _EntityID .. " at (" .. _Xcm .. "," .. _Ycm .. ") destroyed.")
    
    DiplomacyMenu_Update(_PlayerID)
end

function GameCallback_Feedback_TradeGatheringFailed(_PlayerID, _EntityID, _GoodType)

    --GUI.AddNote("GameCallback_Feedback_TradeGatheringFailed()")
end


function GameCallback_Feedback_BuildingCeasesToBurn(_PlayerID, _EntityID)

    if _PlayerID == GUI.GetPlayerID() then
        XGUIEng.ShowAllSubWidgets("/InGame/Root/Normal/BuildingButtons", 1)
    end
end


function GameCallback_Feedback_ResourceCartArrived(_PlayerID, _Amount, _Type, _EntityID)

    if _PlayerID == GUI.GetPlayerID() then
        GUI_FeedbackSpeech.Add("SpeechOnly_ArrivedResourceCart", g_FeedbackSpeech.Categories.ArrivedResourceCart, nil, nil)
    end
end


function GameCallback_Feedback_GoodCartArrived(_PlayerID, _Amount, _GoodType, _EntityID)

    if _PlayerID == GUI.GetPlayerID() then
        local Speech = "Minimap_ArrivedGoodsCart"

        if _GoodType == Goods.G_Medicine then
            Speech = "Minimap_ArrivedMedicus"
        end

        GUI_FeedbackSpeech.Add(Speech, g_FeedbackSpeech.Categories.ArrivedGoodsCartOrEntertainer, _EntityID, nil)
    end
end


function GameCallback_Feedback_EntertainerCartReturned(_PlayerID, _Amount, _EntityID)

    if _PlayerID == GUI.GetPlayerID() then
        GUI_FeedbackSpeech.Add("Minimap_ArrivedEntertainer", g_FeedbackSpeech.Categories.ArrivedGoodsCartOrEntertainer, _EntityID, nil)
    end
end


function ScriptCallback_Feedback_EnemiesOnMarketplace(_MarketplacePlayerID, _EnemyPlayerID, _MarketplaceEntityID)

    if _MarketplacePlayerID == GUI.GetPlayerID() then
        GUI_FeedbackSpeech.Add("Minimap_ImpendingLoseDueToEnemiesOnMarketplace", g_FeedbackSpeech.Categories.EnemiesOnMarketplace, _MarketplaceEntityID, _EnemyPlayerID)
    end
end


function ScriptCallback_Feedback_SpecialBuildingDamaged(_HurtPlayerID, _HurtingPlayerID, _HurtEntityID)

    if _HurtPlayerID == GUI.GetPlayerID() then
        local CurrentHealth = Logic.GetEntityHealth(_HurtEntityID)
        local MaxHealth = Logic.GetEntityMaxHealth(_HurtEntityID)
        local DamageFraction = CurrentHealth / MaxHealth

        if DamageFraction < 0.5 then
            GUI_FeedbackSpeech.Add("Minimap_ImpendingLoseDueToSpecialBuilding", g_FeedbackSpeech.Categories.SpecialBuildingToBeDestroyed, _HurtEntityID, _HurtingPlayerID)
        end
    end
end


function GameCallback_Feedback_SettlerFlees(_FleePlayerID, _FleeEntityID, _FrighteningPlayerID, _FrighteningEntityID)

    if _FleePlayerID == GUI.GetPlayerID() then
        GUI_FeedbackSpeech.Add(nil, g_FeedbackSpeech.Categories.ScaredSettler, _FleeEntityID, _FrighteningPlayerID)
    end
end


function GameCallback_Feedback_SoldiersConverted(_ConvertedPlayerID, _ConvertingPlayerID, _ConvertedEntityID, _ConvertingEntityID)
    local PlayerID = GUI.GetPlayerID()

    if PlayerID == _ConvertedPlayerID then
        GUI_FeedbackSpeech.AreaCheckedAdd("Minimap_ConvertedBatallion", g_FeedbackSpeech.AreaCategories.ConvertedByLordWisdom, _ConvertedEntityID, _ConvertingPlayerID)
    end
end


function GameCallback_Feedback_PredatorsStoleOutstock(_PackMemberID, _BuildingID, _BuildingPlayerID)

    if _BuildingPlayerID == GUI.GetPlayerID() then
        GUI_FeedbackSpeech.Add("Minimap_PreyedUponByPredators", g_FeedbackSpeech.Categories.PredatorsPreyOnFood, _BuildingID, 0)
    end
end


function GameCallback_Feedback_PredatorsAttackedLivestock(_LivestockID, _LivestockPlayerID, _LivestockType, _PositionX, _PositionY, _PredatorID, _PredatorType)

    if _LivestockPlayerID == GUI.GetPlayerID() then

        local EntityInfo = {
            ["ID"] = _LivestockID,
            ["Type"] = _LivestockType,
            ["PosX"] = _PositionX,
            ["PosY"] = _PositionY}

        GUI_FeedbackSpeech.Add("Minimap_AttackedHerdsByPredators", g_FeedbackSpeech.Categories.PredatorsPreyOnFood, EntityInfo, 0)
    end
end


function GameCallback_Feedback_EntityDiscovered(_PlayerID, _EntityID)

    if _PlayerID == GUI.GetPlayerID() then
        if Logic.IsEntityDestroyed(_EntityID) == true then
            return
        end

        -- this is used by the Diplomacy Menu to show only players that were discovered
        local EntityPlayerID = Logic.EntityGetPlayer(_EntityID)

        if g_DiscoveredPlayers == nil then
            g_DiscoveredPlayers = {}
        end

        g_DiscoveredPlayers[EntityPlayerID] = true
    end
end


function GameCallback_Feedback_EntityCaptured(_OldEntityID, _OldPlayerID, _NewEntityID, _NewPlayerID)

    local PlayerID = GUI.GetPlayerID()
    local CartSender = Logic.GetMerchantCartSender(_NewEntityID)

    if _OldPlayerID == PlayerID
    or CartSender == PlayerID then

        local Speech
        local CapturingPlayerCategory = GetPlayerCategoryType(_NewPlayerID)

        if CapturingPlayerCategory == PlayerCategories.BanditsCamp then
            Speech = "Minimap_CartCapturedBandits"
        else
            Speech = "Minimap_CartCaptured"
        end

        GUI_FeedbackSpeech.AreaCheckedAdd(Speech, g_FeedbackSpeech.AreaCategories.CartCaptured, _NewEntityID, _NewPlayerID)

        local EntityType = Logic.GetEntityType(_NewEntityID)

        if EntityType  == Entities.U_GoldCart
        and _OldPlayerID == PlayerID then
            local GoodType, GoodAmount = Logic.GetMerchantCargo(_NewEntityID)
            GoodAmount = GoodAmount * -1
            GUI_FeedbackWidgets.GoldAdd(GoodAmount, _NewEntityID)
        end
    end
end


function GameCallback_Feedback_MineAmountChanged(_MineID, _GoodType, _TerritoryID, _TerritoryOwningPlayerID, _Amount)

    local PlayerID = GUI.GetPlayerID()

    if _TerritoryOwningPlayerID == PlayerID then

        local Speech

        if _Amount == 0 then
            if _GoodType == Goods.G_Stone then
                Speech = "Minimap_StoneMineDepleted"
            elseif _GoodType == Goods.G_Iron then
                Speech = "Minimap_IronMineDepleted"
            end

        elseif _Amount == 30 then
            if _GoodType == Goods.G_Stone then
                Speech = "Minimap_StoneMineDepletedSoon"
            elseif _GoodType == Goods.G_Iron then
                Speech = "Minimap_IronMineDepletedSoon"
            end
        end

        if Speech ~= nil then
            GUI_FeedbackSpeech.Add(Speech, g_FeedbackSpeech.Categories.StoneOrIronMineDepleted, _MineID, nil)
        end
    end
end


-- ----------------------------------------------------------------------
-- Thieves
-- ----------------------------------------------------------------------

-- should this be removed?
-- what about cheat safety of feedback messages?
function GameCallback_Feedback_OnThiefStealBuilding(_ThiefID, _ThiefPlayerID, _BuildingID, _BuildingPlayerID)

end


function GameCallback_Feedback_ThiefDeliverEarnings(_ThiefPlayerID, _ThiefID, _GoldAmount)

    if _ThiefPlayerID == GUI.GetPlayerID() then
        GUI_FeedbackWidgets.GoldAdd(_GoldAmount, _ThiefID)
    end

end


function GameCallback_Feedback_ThiefDeliverInformations(_ThiefPlayerID, _InformationID, _InformationPlayerID, _ThiefID, _BuildingID)

    if _ThiefPlayerID == GUI.GetPlayerID() then
        local Speech

        if _InformationID == 1 then
            Speech = "Minimap_ThiefDeliveredInformationCastle"
        elseif _InformationID == 2 then
            Speech = "Minimap_ThiefDeliveredInformationCathedral"
        elseif _InformationID == 3 then
            Speech = "Minimap_ThiefDeliveredInformationStorehouse"
        end

        GUI_FeedbackSpeech.Add(Speech, g_FeedbackSpeech.Categories.OwnThiefDeliveredInformation, _ThiefID, nil)
    end

end


function GameCallback_Feedback_ThiefDetected(_ThiefPlayerID, _ThiefEntityID, _DetectPlayerID)

    if _DetectPlayerID == GUI.GetPlayerID() then
        GUI_FeedbackSpeech.AreaCheckedAdd("Minimap_ForeignThiefDetected", g_FeedbackSpeech.AreaCategories.ForeignThiefDetected, _ThiefEntityID, _ThiefPlayerID)

    elseif _ThiefPlayerID == GUI.GetPlayerID() then
        GUI_FeedbackSpeech.AreaCheckedAdd("Minimap_OwnThiefDetected", g_FeedbackSpeech.AreaCategories.OwnThiefExposed, _ThiefEntityID, _DetectPlayerID)
    end
end


-- ----------------------------------------------------------------------
-- GameCallback_Feedback_NewCouplesAfterFestival
-- ----------------------------------------------------------------------

function GameCallback_Feedback_NewCouplesAfterFestival(_PlayerID, _NewCouples, _FestivalAbilityIsActive,_NewCouplesByThordal)

    -- stop the event music
    local PlayerID = GUI.GetPlayerID()
    StopEventMusic(MusicSystem.EventFestivalMusic, PlayerID)
    StopEventMusic(MusicSystem.EventPromotionMusic, PlayerID)
    StopEventMusic(MusicSystem.EventPromotion2Music, PlayerID)

    -- feedback for new couples
    
    if 		_PlayerID == GUI.GetPlayerID()
    	and Logic.GetCurrentTurn() > 10
    	and _NewCouples > 0 then
    	
        GUI_FeedbackWidgets.CityAdd(_NewCouples - _NewCouplesByThordal, nil, {4, 15})
    
    	if _NewCouplesByThordal > 0 then  -- output the additional amount always, when thordal is the selected knight?
    	
    		GUI_FeedbackWidgets.CityAdd(_NewCouplesByThordal, nil, {6, 7})
    		
    	end
        
    end
end

-- ----------------------------------------------------------------------
-- GameCallback_Feedback_TaxCollectorRaided
-- ----------------------------------------------------------------------

function GameCallback_Feedback_TaxCollectorRaided(_TaxCollectorPlayerID, _AttackerPlayerID, _AttackerID, _GoldAmount, _TaxCollectorID)

   if _TaxCollectorPlayerID == GUI.GetPlayerID()
   and Logic.GetCurrentTurn() > 10 then
        if _GoldAmount ~= 0 then
            _GoldAmount = _GoldAmount * -1
            GUI_FeedbackWidgets.GoldAdd(_GoldAmount, _TaxCollectorID)
        end

   elseif _AttackerPlayerID == GUI.GetPlayerID()
    and Logic.GetCurrentTurn() > 10 then
        if _GoldAmount ~= 0 then
            GUI_FeedbackWidgets.GoldAdd(_GoldAmount, _TaxCollectorID)
        end
    end
end

-- ----------------------------------------------------------------------
-- GameCallback_Feedback_GoldPlundered_NoBuilding
-- ----------------------------------------------------------------------

function GameCallback_Feedback_NothingToPlunder_NoBuilding(_PlayerId,_EntityId)

end

-- ----------------------------------------------------------------------
-- GameCallback_Feedback_GoldPlundered_NoGold
-- ----------------------------------------------------------------------

function GameCallback_Feedback_NothingToPlunder_NoGold(_SourcePlayerId,_SourceEntityId,_TargetPlayerId,_TargetEntityId)

end

-- ----------------------------------------------------------------------
-- GameCallback_Feedback_GoldPlundered
-- ----------------------------------------------------------------------

function GameCallback_Feedback_GoldPlundered(_PlundererPlayerID, _PlunderedPlayerID, _PlunderedEntityID, _GoldAmount, _PlundererEntityID)

    if _PlundererPlayerID == GUI.GetPlayerID() then
        GUI_FeedbackWidgets.GoldAdd(_GoldAmount, _PlundererEntityID)
    end

    if _PlunderedPlayerID == GUI.GetPlayerID() then
        _GoldAmount = _GoldAmount * -1
        GUI_FeedbackWidgets.GoldAdd(_GoldAmount, _PlundererEntityID, nil, {8, 4})

        GUI_FeedbackSpeech.AreaCheckedAdd("Minimap_PlunderedByLadyPlunder", g_FeedbackSpeech.AreaCategories.PlunderedByLadyPlunder, _PlunderedEntityID, _PlundererPlayerID)
    end
end

-- ----------------------------------------------------------------------
-- GameCallback_Feedback_TaxCollectorCannotReachTreasury
-- ----------------------------------------------------------------------

function GameCallback_Feedback_TaxCollectorCannotReachTreasury(_PlayerID, _EntityID)

end

-- ----------------------------------------------------------------------
-- GameCallback_Feedback_TaxCollectionFinished
-- ----------------------------------------------------------------------

function GameCallback_Feedback_TaxCollectionFinished(_PlayerID, _TotalTaxAmountCollected, _AdditionalTaxesByAbility)

    if _PlayerID == GUI.GetPlayerID() then

        if  Logic.GetCurrentTurn() > 10 then

            if _TotalTaxAmountCollected > 0 then
                local AmountWithoutAdditional = _TotalTaxAmountCollected - _AdditionalTaxesByAbility

                GUI_FeedbackWidgets.GoldAdd(AmountWithoutAdditional, nil)

                if _AdditionalTaxesByAbility > 0 then
                    GUI_FeedbackWidgets.GoldAdd(_AdditionalTaxesByAbility, Logic.GetKnightID(_PlayerID))
                    StartKnightVoiceForPermanentSpecialAbility(Entities.U_KnightPlunder)
                    StartKnightVoiceForPermanentSpecialAbility(Entities.U_KnightRedPrince)
                end
            end

            local SoldierAmount = Logic.GetCurrentSoldierCount(_PlayerID)
            local PayPerSoldier = SoldierPay[PlayerSoldierPaymentLevel[_PlayerID]]
            local AmountToPay = SoldierAmount * PayPerSoldier

            if AmountToPay > 0 then
                AmountToPay = AmountToPay * -1
                GUI_FeedbackWidgets.GoldAdd(AmountToPay, nil, {1, 7})
            end
        end
    end
end


function GameCallback_Feedback_GoldCartReturned(_PlayerID, _TotalAmount, _AdditionalAmountByAbility, _GoldCartEntityID)

    if _PlayerID == GUI.GetPlayerID() then

        local AmountWithoutAdditional = _TotalAmount - _AdditionalAmountByAbility

        GUI_FeedbackWidgets.GoldAdd(AmountWithoutAdditional, nil, {7, 1})

        if _AdditionalAmountByAbility > 0 then
            GUI_FeedbackWidgets.GoldAdd(_AdditionalAmountByAbility, Logic.GetKnightID(_PlayerID))
        end
    end
end


function GameCallback_Feedback_GainedCollect(_PlayerID, _TotalCollectedAmount, _AdditionalCollectedByAbility)

    if _PlayerID == GUI.GetPlayerID() then
        local AmountWithoutAdditional = _TotalCollectedAmount - _AdditionalCollectedByAbility

        GUI_FeedbackWidgets.GoldAdd(AmountWithoutAdditional, nil, {4, 14})

        if _AdditionalCollectedByAbility > 0 then
            GUI_FeedbackWidgets.GoldAdd(_AdditionalCollectedByAbility, Logic.GetKnightID(_PlayerID))
        end
    end
end


-- ----------------------------------------------------------------------
-- GameCallback_Feedback_NoPathFound
-- ----------------------------------------------------------------------

function GameCallback_Feedback_NoPathFound(_PlayerID, _EntityID)

end

-- ----------------------------------------------------------------------
-- GameCallback_Feedback_EntityHurt
-- ----------------------------------------------------------------------

function GameCallback_Feedback_EntityHurt(_HurtPlayerID, _HurtEntityID,
                                          _HurtingPlayerID, _HurtingEntityID,
                                          _DamageReceived, _DamageDealt)

    local HurtEntityType = Logic.GetEntityType(_HurtEntityID)

    if HurtEntityType == nil
    or HurtEntityType == 0 then
        return
    end

    local PlayerID = GUI.GetPlayerID()

    -- tell player once about the action special ability of wisdom and marcus
    if Logic.GetEntityType(_HurtingEntityID) == Entities.U_KnightWisdom
    or Logic.GetEntityType(_HurtingEntityID) == Entities.U_KnightChivalry
    or Logic.GetEntityType(_HurtingEntityID) == Entities.U_KnightSabatta then
        
        if Logic.GetHeadquarters(_HurtPlayerID) ~= 0 then
            StartKnightVoiceForActionSpecialAbility(Logic.GetEntityType(_HurtingEntityID))
        end
        
    end

    local SpeechTextKey
    local FeedbackSpeechCategory
    local FeedbackSpeechAddFunction = GUI_FeedbackSpeech.AreaCheckedAdd
    local OptionalScreenCheck, OptionalGenericAttackedCheck = true, true

    -- performance problem?
    if PlayerID ~= _HurtPlayerID
    and Diplomacy_GetRelationBetween(_HurtPlayerID, PlayerID) >= DiplomacyStates.TradeContact then
        SpeechTextKey = "Minimap_AttackedAlly"
        FeedbackSpeechCategory = g_FeedbackSpeech.Categories.AttackedAlly
        FeedbackSpeechAddFunction = GUI_FeedbackSpeech.Add
        OptionalGenericAttackedCheck = false
        FeedbackSpeechAddFunction(SpeechTextKey, FeedbackSpeechCategory, _HurtEntityID, _HurtingPlayerID, OptionalScreenCheck, OptionalGenericAttackedCheck)

    elseif PlayerID == _HurtPlayerID then
        if Logic.IsKnight(_HurtEntityID) == true then
            SpeechTextKey = "Minimap_AttackedKnight"
            FeedbackSpeechCategory = g_FeedbackSpeech.AreaCategories.AttackedKnight

        elseif Logic.IsEntityInCategory(_HurtEntityID, EntityCategories.Thief) == 1 then
            SpeechTextKey = "Minimap_AttackedThief"
            FeedbackSpeechCategory = g_FeedbackSpeech.AreaCategories.AttackedThief

        elseif Logic.IsEntityInCategory(_HurtEntityID, EntityCategories.Military) == 1 then
            SpeechTextKey = "Minimap_AttackedMilitary"
            FeedbackSpeechCategory = g_FeedbackSpeech.AreaCategories.AttackedMilitary

        elseif HurtEntityType == Entities.U_TaxCollector then
            SpeechTextKey = "Minimap_AttackedTaxCollector"
            FeedbackSpeechCategory = g_FeedbackSpeech.AreaCategories.AttackedTaxCollector

        elseif (HurtEntityType == Entities.U_GoldCart
        or HurtEntityType == Entities.U_ResourceMerchant
        or HurtEntityType == Entities.U_Marketer) then
            SpeechTextKey = "Minimap_AttackedCart"
            FeedbackSpeechCategory = g_FeedbackSpeech.AreaCategories.AttackedCart

        elseif Logic.IsBuilding(_HurtEntityID) == 1 then

            XGUIEng.ShowAllSubWidgets("/InGame/Root/Normal/BuildingButtons", 1)

            if Logic.IsEntityInCategory(_HurtEntityID, EntityCategories.OuterRimBuilding) == 1 then
                SpeechTextKey = "Minimap_AttackedOuterRimBuilding"
                FeedbackSpeechCategory = g_FeedbackSpeech.AreaCategories.AttackedBuildingOrWall

            elseif Logic.IsEntityInCategory(_HurtEntityID, EntityCategories.CityBuilding) == 1 then
                SpeechTextKey = "Minimap_AttackedCityBuilding"
                FeedbackSpeechCategory = g_FeedbackSpeech.AreaCategories.AttackedBuildingOrWall

            elseif Logic.IsEntityInCategory(_HurtEntityID, EntityCategories.Outpost) == 1 then
                SpeechTextKey = "Minimap_AttackedOutpost"
                -- no area check
                FeedbackSpeechCategory = g_FeedbackSpeech.Categories.AttackedOutpost
                FeedbackSpeechAddFunction = GUI_FeedbackSpeech.Add
                OptionalScreenCheck, OptionalGenericAttackedCheck = false, false

            elseif Logic.GetHeadquarters(PlayerID) == _HurtEntityID then
                SpeechTextKey = "Minimap_AttackedCastle"
                -- no area check
                FeedbackSpeechCategory = g_FeedbackSpeech.Categories.AttackedCastle
                FeedbackSpeechAddFunction = GUI_FeedbackSpeech.Add
                OptionalScreenCheck, OptionalGenericAttackedCheck = false, false
                ScriptCallback_Feedback_SpecialBuildingDamaged(_HurtPlayerID, _HurtingPlayerID, _HurtEntityID)

            elseif Logic.GetStoreHouse(PlayerID) == _HurtEntityID then
                SpeechTextKey = "Minimap_AttackedStorehouse"
                -- no area check
                FeedbackSpeechCategory = g_FeedbackSpeech.Categories.AttackedStorehouse
                FeedbackSpeechAddFunction = GUI_FeedbackSpeech.Add
                OptionalScreenCheck, OptionalGenericAttackedCheck = false, false
                ScriptCallback_Feedback_SpecialBuildingDamaged(_HurtPlayerID, _HurtingPlayerID, _HurtEntityID)

            elseif Logic.GetCathedral(PlayerID) == _HurtEntityID then
                SpeechTextKey = "Minimap_AttackedCathedral"
                -- no area check
                FeedbackSpeechCategory = g_FeedbackSpeech.Categories.AttackedCathedral
                FeedbackSpeechAddFunction = GUI_FeedbackSpeech.Add
                OptionalScreenCheck, OptionalGenericAttackedCheck = false, false
                ScriptCallback_Feedback_SpecialBuildingDamaged(_HurtPlayerID, _HurtingPlayerID, _HurtEntityID)

            else
                SpeechTextKey = "Minimap_AttackedGenericBuilding"
                FeedbackSpeechCategory = g_FeedbackSpeech.AreaCategories.AttackedBuildingOrWall

            end

        elseif Logic.IsWall(_HurtEntityID) == true then
            if (HurtEntityType == Entities.B_PalisadeGate
            or HurtEntityType == Entities.B_PalisadeSegment) then
                SpeechTextKey = "Minimap_AttackedPalisades"
                FeedbackSpeechCategory = g_FeedbackSpeech.AreaCategories.AttackedBuildingOrWall

            else
                SpeechTextKey = "Minimap_AttackedWalls"
                FeedbackSpeechCategory = g_FeedbackSpeech.AreaCategories.AttackedBuildingOrWall

            end

        else
            SpeechTextKey = "Minimap_AttackedGenericUnit"
            FeedbackSpeechCategory = g_FeedbackSpeech.AreaCategories.AttackedMilitary

        end

        FeedbackSpeechAddFunction(SpeechTextKey, FeedbackSpeechCategory, _HurtEntityID, _HurtingPlayerID, OptionalScreenCheck, OptionalGenericAttackedCheck)
    end

    if _HurtPlayerID == GUI.GetPlayerID()
    and Logic.IsWall(_HurtEntityID) == true
    and Logic.IsEntityInCategory(_HurtingEntityID, EntityCategories.HeavyWeapon) == 1
    and Logic.IsEntityInCategory(_HurtEntityID, EntityCategories.PalisadeSegment) == 0 then
        g_CameraShaker = {}
        g_CameraShaker.StartTime = Logic.GetTimeMs()
        g_CameraShaker.Length = 400
        g_CameraShaker.Trigger = 1
        g_CameraShaker.PosX , g_CameraShaker.PosY = Logic.GetEntityPosition(_HurtEntityID)
    end

    if Debug_EnableDebugOutput and (_HurtingPlayerID == GUI.GetPlayerID()) then

        local MoralFactor  = Logic.GetPlayerMorale(_HurtingPlayerID)
        local TerritoryBonus = Logic.GetTerritoryBonus(_HurtingEntityID)
        local HeightDamageModifier = Logic.GetHeightDamageModifier(_HurtingEntityID)

        local ShieldFactor = Logic.GetShieldFactor(_HurtEntityID)

        local HurtingEnityTypeName = Logic.GetEntityTypeName(Logic.GetEntityType(_HurtingEntityID))
        local HurtEnityTypeName = Logic.GetEntityTypeName(Logic.GetEntityType(_HurtEntityID))

        local Text = HurtingEnityTypeName .. "(" .._HurtingPlayerID .. ") ->  "
        ..  HurtEnityTypeName.. "(" .._HurtPlayerID .. ")[" .. ShieldFactor ..
        "] Damage received: " .. _DamageReceived ..  " [" .. _DamageDealt .. "] Moral: " .. MoralFactor .."  Territory: " .. TerritoryBonus .. " Height: " .. HeightDamageModifier

        GUI.AddNote(Text)
    end
end


function GameCallback_Feedback_EntityKilled(_KilledEntityID, _KilledPlayerID, _KillingEntityID, _KillingPlayerID,
    _KilledEntityType, _KillingEntityType, _KilledEntityPosX, _KilledEntityPosY)

    if Logic.GetTime() < 1 then
        return
    end

    local EntityInfo = {
        ["ID"] = _KilledEntityID,
        ["Type"] = _KilledEntityType,
        ["PosX"] = _KilledEntityPosX,
        ["PosY"] = _KilledEntityPosY}

    local PlayerID = GUI.GetPlayerID()

    local SpeechTextKey
    local FeedbackSpeechCategory
    local FeedbackSpeechAddFunction = GUI_FeedbackSpeech.AreaCheckedAdd
    local OptionalScreenCheck, OptionalGenericAttackedCheck = true, false

    if PlayerID == _KilledPlayerID then
    
        if Logic.IsKnight(_KilledEntityID) == true then
            SpeechTextKey = "Minimap_DestroyedKnight"
            -- no area check
            FeedbackSpeechCategory = g_FeedbackSpeech.Categories.DestroyedKnight
            FeedbackSpeechAddFunction = GUI_FeedbackSpeech.Add
            OptionalScreenCheck, OptionalGenericAttackedCheck = false, false

        elseif Logic.IsEntityTypeInCategory(_KilledEntityType, EntityCategories.Thief) == 1 then
            SpeechTextKey = "Minimap_DestroyedThief"
            FeedbackSpeechCategory = g_FeedbackSpeech.AreaCategories.DestroyedThief

        elseif Logic.IsEntityTypeInCategory(_KilledEntityType, EntityCategories.Military) == 1 then
            SpeechTextKey = "Minimap_DestroyedMilitary"
            FeedbackSpeechCategory = g_FeedbackSpeech.AreaCategories.DestroyedMilitary

        elseif _KilledEntityType == Entities.U_TaxCollector then
            SpeechTextKey = "Minimap_DestroyedTaxCollector"
            FeedbackSpeechCategory = g_FeedbackSpeech.AreaCategories.DestroyedTaxCollector

        elseif (_KilledEntityType == Entities.U_GoldCart
        or _KilledEntityType == Entities.U_ResourceMerchant
        or _KilledEntityType == Entities.U_Marketer) then
            SpeechTextKey = "Minimap_DestroyedCart"
            FeedbackSpeechCategory = g_FeedbackSpeech.AreaCategories.DestroyedCart

        elseif Logic.IsEntityTypeInCategory(_KilledEntityType, EntityCategories.AttackableBuilding) == 1 then

            if Logic.IsEntityTypeInCategory(_KilledEntityType, EntityCategories.OuterRimBuilding) == 1 then
                SpeechTextKey = "Minimap_DestroyedOuterRimBuilding"
                FeedbackSpeechCategory = g_FeedbackSpeech.AreaCategories.DestroyedBuildingOrWall

            elseif Logic.IsEntityTypeInCategory(_KilledEntityType, EntityCategories.CityBuilding) == 1 then
                SpeechTextKey = "Minimap_DestroyedCityBuilding"
                FeedbackSpeechCategory = g_FeedbackSpeech.AreaCategories.DestroyedBuildingOrWall

            elseif Logic.IsEntityTypeInCategory(_KilledEntityType, EntityCategories.Outpost) == 1 then
                SpeechTextKey = "Minimap_DestroyedOutpost"
                -- no area check
                FeedbackSpeechCategory = g_FeedbackSpeech.Categories.DestroyedOutpost
                FeedbackSpeechAddFunction = GUI_FeedbackSpeech.Add
                OptionalScreenCheck, OptionalGenericAttackedCheck = false, false

                -- HACK to save the outpost EntityID
                g_FeedbackSpeech.LastDestroyedOutpostInfo = EntityInfo
                g_FeedbackSpeech.LastDestroyedOutpostTime = Logic.GetTime()
                g_FeedbackSpeech.LastDestroyedOutpostTerritoryID = GetTerritoryUnderEntity(EntityInfo.ID)
                g_FeedbackSpeech.LastDestroyedOutpostCausingPlayerID = _KillingPlayerID

                -- return, because "Outpost destroyed" message before/after "Territory lost" message is confusing
                return

            elseif Logic.IsEntityTypeInCategory(_KilledEntityType, EntityCategories.Headquarters) == 1 then
                SpeechTextKey = "Minimap_DestroyedCastle"
                -- no area check
                FeedbackSpeechCategory = g_FeedbackSpeech.Categories.DestroyedSpecialBuilding
                FeedbackSpeechAddFunction = GUI_FeedbackSpeech.Add
                OptionalScreenCheck, OptionalGenericAttackedCheck = false, false

            elseif Logic.IsEntityTypeInCategory(_KilledEntityType, EntityCategories.Storehouse) == 1 then
                SpeechTextKey = "Minimap_DestroyedStorehouse"
                -- no area check
                FeedbackSpeechCategory = g_FeedbackSpeech.Categories.DestroyedSpecialBuilding
                FeedbackSpeechAddFunction = GUI_FeedbackSpeech.Add
                OptionalScreenCheck, OptionalGenericAttackedCheck = false, false

            elseif Logic.IsEntityTypeInCategory(_KilledEntityType, EntityCategories.Cathedrals) == 1 then
                SpeechTextKey = "Minimap_DestroyedCathedral"
                -- no area check
                FeedbackSpeechCategory = g_FeedbackSpeech.Categories.DestroyedSpecialBuilding
                FeedbackSpeechAddFunction = GUI_FeedbackSpeech.Add
                OptionalScreenCheck, OptionalGenericAttackedCheck = false, false

            else
                SpeechTextKey = "Minimap_DestroyedGenericBuilding"
                FeedbackSpeechCategory = g_FeedbackSpeech.AreaCategories.DestroyedBuildingOrWall

            end

        elseif Logic.IsEntityTypeInCategory(_KilledEntityType, EntityCategories.PalisadeSegment) == 1 then
            SpeechTextKey = "Minimap_DestroyedPalisades"
            FeedbackSpeechCategory = g_FeedbackSpeech.AreaCategories.DestroyedBuildingOrWall

        elseif Logic.IsEntityTypeInCategory(_KilledEntityType, EntityCategories.Wall) == 1 then
            SpeechTextKey = "Minimap_DestroyedWalls"
            FeedbackSpeechCategory = g_FeedbackSpeech.AreaCategories.DestroyedBuildingOrWall

        else
            SpeechTextKey = "Minimap_DestroyedGenericUnit"
            FeedbackSpeechCategory = g_FeedbackSpeech.AreaCategories.DestroyedMilitary

        end

        FeedbackSpeechAddFunction(SpeechTextKey, FeedbackSpeechCategory, EntityInfo, _KillingPlayerID, OptionalScreenCheck, OptionalGenericAttackedCheck)

    end
end

function GameCallback_Feedback_EntityDrowned(_KilledEntityID, _KilledPlayerID, _KilledEntityType, _KilledEntityPosX, _KilledEntityPosY)

    -- TODO: for now we use _EntityKilled to get the job done, but it might be
    -- good idea to provide special handling for drowning.

    GameCallback_Feedback_EntityKilled(_KilledEntityID, _KilledPlayerID, 0, nil, _KilledEntityType, 0, _KilledEntityPosX, _KilledEntityPosY)
end


function GameCallback_Feedback_PlayerLost( _PlayerID )
    DiplomacyMenu_Update(_PlayerID)
    Defeated( _PlayerID )
end


-- ----------------------------------------------------------------------
-- GameCallback_Feedback_MerchantDiscovered
-- ----------------------------------------------------------------------

function GameCallback_Feedback_MerchantDiscovered(_PlayerID, _EntityID)

    if _PlayerID == GUI.GetPlayerID() then

        local EntityPlayerID = Logic.EntityGetPlayer(_EntityID)

        -- this is used by the Diplomacy Menu to show only players that were discovered
        if g_DiscoveredPlayers == nil then
            g_DiscoveredPlayers = {}
        end

        g_DiscoveredPlayers[EntityPlayerID] = true
    end
end



-- ----------------------------------------------------------------------
-- GameCallback_Feedback_DepotLimitReached
-- ----------------------------------------------------------------------

function GameCallback_Feedback_DepotLimitReached(_PlayerID, _EntityID)

    if _PlayerID == GUI.GetPlayerID()
    and Logic.GetCurrentTurn() > 10 then
        local StorehouseID = Logic.GetStoreHouse(_PlayerID)
        GUI_FeedbackSpeech.Add("Minimap_StorehouseFull", g_FeedbackSpeech.Categories.DepotLimit, StorehouseID, nil)
    end
end

-- ----------------------------------------------------------------------
-- GameCallback_Feedback_GathererCannotFindResource
-- ----------------------------------------------------------------------

function GameCallback_Feedback_GathererCannotFindResource(_PlayerID, _EntityID, _GoodType, _SeasonallyUnavailable)

    if _PlayerID == GUI.GetPlayerID()
    and _SeasonallyUnavailable ~= 1 --this means that a fisher can't fish due to frozen water; don't throw message
    and Logic.GetCurrentTurn() > 150 then

        local SpeechTextKey

        if _GoodType == Goods.G_Stone then
            SpeechTextKey = "Minimap_GatherStone"
        elseif _GoodType == Goods.G_Iron then
            SpeechTextKey = "Minimap_GatherIron"
        elseif _GoodType == Goods.G_Wood then
            SpeechTextKey = "Minimap_GatherWood"
        elseif _GoodType == Goods.G_Carcass then
            SpeechTextKey = "Minimap_GatherGameAnimals"
        elseif _GoodType == Goods.G_RawFish then
            SpeechTextKey = "Minimap_GatherFish"
        elseif _GoodType == Goods.G_Herb then
            SpeechTextKey = "Minimap_GatherHerbs"
        end

        GUI_FeedbackSpeech.Add(SpeechTextKey, g_FeedbackSpeech.Categories.SettlersCannotGather, _EntityID, nil)
    end
end

-- ----------------------------------------------------------------------
-- GameCallback_Feedback_NoHarvestableEntityInFarmRange
-- ----------------------------------------------------------------------

function GameCallback_Feedback_NoHarvestableEntityInFarmRange(_PlayerID, _EntityID, _FarmAnimalCategory, _SeasonallyUnavailable)

    if _PlayerID == GUI.GetPlayerID()
    and Logic.GetCurrentTurn() > 150 then
        local SpeechTextKey

        if _FarmAnimalCategory == EntityCategories.GrainField then
            SpeechTextKey = "Minimap_FarmGrain"

            if _SeasonallyUnavailable == 1 then --this means that a farmer can't harvest due to winter; don't throw message
                return
            end
        elseif _FarmAnimalCategory == EntityCategories.BeeHive then
            SpeechTextKey = "Minimap_FarmHoney"

            if _SeasonallyUnavailable == 1 then
                return
            end
        elseif _FarmAnimalCategory == EntityCategories.CattlePasture then
            SpeechTextKey = "Minimap_FarmCattle"
        elseif _FarmAnimalCategory == EntityCategories.SheepPasture then
            SpeechTextKey = "Minimap_FarmSheep"
        end

        GUI_FeedbackSpeech.Add(SpeechTextKey, g_FeedbackSpeech.Categories.SettlersCannotGather, _EntityID, nil)
    end
end

-- ----------------------------------------------------------------------
-- GameCallback_Feedback_StartGuarding
-- ----------------------------------------------------------------------
function GameCallback_Feedback_StartGuarding(_GuardID, _GuardPlayerID,
    _GuardedID, _GuardedPlayerID)

    -- do something useful here
end

-- ----------------------------------------------------------------------
-- GameCallback_Feedback_StartGuarding
-- ----------------------------------------------------------------------
function GameCallback_Feedback_EventSetPlayerColorDataProcessed()
    Display.UpdatePlayerColors()
end


-- **********************************************************************
-- More callbacks
-- **********************************************************************

function GameCallback_Feedback_OnBuildingConstructionComplete(_PlayerID, _EntityID)

    local PlayerID = GUI.GetPlayerID()
    local EntityType = Logic.GetEntityType(_EntityID)

    if _PlayerID == PlayerID then
        XGUIEng.ShowAllSubWidgets("/InGame/Root/Normal/BuildingButtons",1)
    end

    if _PlayerID == PlayerID
    and Logic.GetTime() > 1 then

        if  EntityType ~= Entities.B_Outpost_ME and
            EntityType ~= Entities.B_Outpost_NE and
            EntityType ~= Entities.B_Outpost_NA and
            EntityType ~= Entities.B_Outpost_SE and
            EntityType ~= Entities.B_TableBeer  and
            EntityType ~= Entities.B_TableFood  then

            Sound.FXPlay2DSound( "ui\\menu_building_ready")
        end
    end
end


function GameCallback_Feedback_OnBuildingUpgradeFinished(_PlayerID, _EntityID, _NewUpgradeLevel)
    local PlayerID = GUI.GetPlayerID()

    if _PlayerID == PlayerID then
        XGUIEng.ShowAllSubWidgets("/InGame/Root/Normal/BuildingButtons", 1)

        if _EntityID == Logic.GetHeadquarters(PlayerID) then
            Sound.FXPlay2DSound( "ui\\menu_left_upgrade_castle")
        end

        if _EntityID == Logic.GetCathedral(PlayerID) then
            Sound.FXPlay2DSound( "ui\\menu_left_upgrade_cathedral")
        end

        if _EntityID == Logic.GetStoreHouse(PlayerID) then
            Sound.FXPlay2DSound( "ui\\menu_left_upgrade_store")
        end
    end
end

function GameCallback_LocalSetRallyPoint(_PlayerID)

    if GUI.GetPlayerID() == _PlayerID then
        Sound.FXPlay2DSound( "ui\\menu_rallypoint_set")
    end

end

function GameCallback_Feedback_KnightTitleChanged (_PlayerID, _NewTitle, _OldTitle)

    if Logic.GetTime() > 1  then
        if GUI.GetPlayerID() == _PlayerID then
            Sound.FXPlay2DSound( "ui\\menu_left_new_title" )
        end
    end
end


function GameCallback_Feedback_TerritoryOwnershipChanged(_TerritoryID, _NewPlayerID, _OldPlayerID)

    local PlayerID = GUI.GetPlayerID()
    local OutpostID = Logic.GetTerritoryAcquiringBuildingID(_TerritoryID)
    local CurrentTime = Logic.GetTime()

    if CurrentTime < 1 then
        return
    end

    if _NewPlayerID == PlayerID then
        GUI_FeedbackSpeech.Add("Minimap_TerritoryClaimed", g_FeedbackSpeech.Categories.TerritoryClaimed, OutpostID, nil)

    elseif _OldPlayerID == PlayerID then

        if g_FeedbackSpeech.LastDestroyedOutpostTime ~= nil
        and g_FeedbackSpeech.LastDestroyedOutpostTime > CurrentTime - 2
        and g_FeedbackSpeech.LastDestroyedOutpostTerritoryID == _TerritoryID then
            if OutpostID == 0 then
                OutpostID = g_FeedbackSpeech.LastDestroyedOutpostInfo
            end

            if _NewPlayerID == 0 then
                _NewPlayerID = g_FeedbackSpeech.LastDestroyedOutpostCausingPlayerID
            end
        end

        -- if _NewPlayerID is still 0, that means that there was no destroyed outpost, which means that the outpost was taken over
        -- (or knocked down; there's no message for that)
        if _NewPlayerID == 0 then
            g_FeedbackSpeech.OutpostTakenOverOldPlayerID = _OldPlayerID
            g_FeedbackSpeech.OutpostTakenOverTime = CurrentTime
            g_FeedbackSpeech.OutpostTakenOverTerritoryID = _TerritoryID
            return
        end

        GUI_FeedbackSpeech.Add("Minimap_TerritoryLost", g_FeedbackSpeech.Categories.TerritoryLost, OutpostID, _NewPlayerID)

    -- when an outpost is taken over, there are 2 callbacks:
    -- OldPlayer -> 0
    -- 0 -> NewPlayer
    -- on the second callback, play the "Territory lost" message for the OldPlayer
    elseif g_FeedbackSpeech.OutpostTakenOverOldPlayerID ~= nil
    and g_FeedbackSpeech.OutpostTakenOverOldPlayerID == PlayerID
    and g_FeedbackSpeech.OutpostTakenOverTime > CurrentTime - 2
    and g_FeedbackSpeech.OutpostTakenOverTerritoryID == _TerritoryID then

        GUI_FeedbackSpeech.Add("Minimap_TerritoryLost", g_FeedbackSpeech.Categories.TerritoryLost, OutpostID, _NewPlayerID)
        g_FeedbackSpeech.OutpostTakenOverOldPlayerID = nil
        g_FeedbackSpeech.OutpostTakenOverTime = nil
        g_FeedbackSpeech.OutpostTakenOverTerritoryID = nil
    end
end


function GameCallback_Feedback_OnBuildingBurning(_PlayerID, _EntityID)

    if _PlayerID  == GUI.GetPlayerID()
    and Logic.IsFireAlarmActiveAtBuilding(_EntityID) == false then
        XGUIEng.ShowAllSubWidgets("/InGame/Root/Normal/BuildingButtons", 1)
        GUI_FeedbackSpeech.Add("Minimap_BuildingBurning", g_FeedbackSpeech.Categories.BuildingBurning, _EntityID, nil)

    end
end


function GameCallback_WaitingForPlayers()

    XGUIEng.ShowWidget("/InGame/Root/Normal/WaitingForPlayerScreen",1)

    local Text = XGUIEng.GetStringTableText("UI_Texts/WaitingForPlayer_center")
    XGUIEng.SetText("/InGame/Root/Normal/WaitingForPlayerScreen/Caption", Text)
end


function GameCallback_StopWaitingForPlayers()

    XGUIEng.ShowWidget("/InGame/Root/Normal/WaitingForPlayerScreen",0)
end


function UpdateWaitForPlayers()

    XGUIEng.ListBoxPopAll("/InGame/Root/Normal/WaitingForPlayerScreen/PlayersList")

    local MaxPlayers = 8
    for CurrentSlotID = 1, MaxPlayers, 1 do
        if Network.IsNetworkSlotIDUsed(CurrentSlotID) then
            local CurrentPlayerID = Logic.GetSlotPlayerID(CurrentSlotID)
            if Logic.PlayerGetIsHumanFlag(CurrentPlayerID)
            and Network.IsWaitingForNetworkSlotID(CurrentSlotID) then
                XGUIEng.ListBoxPushItem("/InGame/Root/Normal/WaitingForPlayerScreen/PlayersList", "{center}" .. Logic.GetPlayerName(CurrentPlayerID))
            end
        end
    end
end


-- **********************************************************************
-- Callbacks for GUI feedback
-- **********************************************************************


function GameCallback_Feedback_AddOuterRimWorkerMissingResourceGood (_PlayerID, _EntityID, _GoodType)
end


function GameCallback_Feedback_RemoveOuterRimWorkerMissingResourceGood(_PlayerID, _EntityID, _GoodType)
end

---

function GameCallback_Feedback_AddCityWorkerMissingResourceGood(_PlayerID, _EntityID, _GoodType)

    if _PlayerID ~= GUI.GetPlayerID() then
        return
    end

    if g_Goods.MissingResources == nil then
        g_Goods.MissingResources = {}
    end

    g_Goods.MissingResources[_GoodType] = Logic.GetTime()
end


function GameCallback_Feedback_RemoveCityWorkerMissingResourceGood(_PlayerID, _EntityID, _GoodType)
end

---

function GameCallback_Feedback_AddSettlerMissingNeedGood(_PlayerID, _EntityID, _GoodCategory)

    if _PlayerID ~= GUI.GetPlayerID() then
        return
    end

    if g_Goods.MissingNeeds == nil then
        g_Goods.MissingNeeds = {}
    end

    if g_Goods.MissingNeeds[_GoodCategory] == nil then
        g_Goods.MissingNeeds[_GoodCategory] = 0
    end

    g_Goods.MissingNeeds[_GoodCategory] = g_Goods.MissingNeeds[_GoodCategory] + 1

    if _GoodCategory == GoodCategories.GC_Food then
        StartKnightVoiceForActionSpecialAbility(Entities.U_KnightTrading)
    elseif _GoodCategory == GoodCategories.GC_Entertainment then
        StartKnightVoiceForActionSpecialAbility(Entities.U_KnightSong)
    elseif _GoodCategory == GoodCategories.GC_Medicine then
        StartKnightVoiceForActionSpecialAbility(Entities.U_KnightHealing)
    end
end


function GameCallback_Feedback_RemoveSettlerMissingNeedGood(_PlayerID, _EntityID, _GoodCategory)
end







-- **********************************************************************
-- Missing / unknown game callbacks
-- **********************************************************************

function EGUIX_ApplicationCallback_Feedback_KeyStroke()

end


function EGUIX_ApplicationCallback_Feedback_ButtonClicked()

    Sound.FXPlay2DSound( "klick_rnd_1" )

end


function GameCallback_Feedback_NeedCriticalAtBuilding()

end


function GameCallback_Feedback_OnTechnologyResearched(PlayerID, TechType)

end


function GameCallback_Feedback_PlayerStateChanged( _PlayerID, _State )

end


function GameCallback_FulfillTribute(_PlayerID, _TributeID )
    return 1 -- tribute is allowed
end







--CLEANUP: MARKED FOR DELETION--

--KoBo: unnecessary(?) CallBacks


function GameCallback_Feedback_BuildingBurnedDown()

end


function GameCallback_Feedback_BuildingKnockedDown()

end


function GameCallback_GUI_DeleteEntityAbort()

end


function GameCallback_UserSetDefaultValues()

end


function GameCallback_Feedback_OnSermonFinished(_PlayerID, _NumSettlers)

end


function Feedback_BuildingRequiresFood(_BuildingID)
    if GUI.GetPlayerID() == Logic.EntityGetPlayer(_BuildingID)
    and Logic.GetTime() > 1 then
        --and math.mod(BuildingNeeds.NutritionActivationCounter, 3) == 0 then

        --GUI.ShortMessages_AddMessageEntity(
        --            1000,
        --            "A building with the need for FOOD has been finished. Take care to produce enough food!",
        --            "graphics\\textures\\gui\\msg\\Critical_Food.png",
        --            "Feedback_SelectAndJumptToEntityIfValid(" .. _BuildingID .. ")",
        --            _BuildingID,
        --            false)
    end
end


function Feedback_BuildingRequiresClothes(_BuildingID)
    if Logic.GetTime() > 1
    and GUI.GetPlayerID() == Logic.EntityGetPlayer(_BuildingID) then
        --and math.mod(BuildingNeeds.ClothesActivationCounter,3) == 0 then

        --GUI.ShortMessages_AddMessageEntity(
        --            1001,
        --            "Settlers in a building have the need for CLOTHES now. Take care to produce enogh clothes!",
        --            "graphics\\textures\\gui\\msg\\Critical_Clothes.png",
        --            "Feedback_SelectAndJumptToEntityIfValid(" .. _BuildingID .. ")",
        --            _BuildingID,
        --            false)
    end
end


function Feedback_BuildingRequiresCleanliness(_BuildingID)
    if Logic.GetTime() > 1
    and GUI.GetPlayerID() == Logic.EntityGetPlayer(_BuildingID) then
        --and math.mod(BuildingNeeds.HygieneActivationCounter,3) == 0 then

        --GUI.ShortMessages_AddMessageEntity(
        --            1001,
        --            "Settlers in a building have the need for CLEANLINESS now. Take care to produce enough soap!",
        --            "graphics\\textures\\gui\\msg\\Critical_Hygiene.png",
        --            "Feedback_SelectAndJumptToEntityIfValid(" .. _BuildingID .. ")",
        --            _BuildingID,
        --            false)
    end
end


function Feedback_BuildingRequiresEntertainment(_BuildingID)
    if Logic.GetTime() > 1
    and GUI.GetPlayerID() == Logic.EntityGetPlayer(_BuildingID) then
        --and math.mod(BuildingNeeds.EntertainmentActivationCounter,3) == 0 then

        --GUI.ShortMessages_AddMessageEntity(
        --            1002,
        --            "Settlers in a building have the need for ENTERTAINMENT now. Take care to supply your settlers with entertainment!",
        --            "graphics\\textures\\gui\\msg\\Critical_Entert.png",
        --            "Feedback_SelectAndJumptToEntityIfValid(" .. _BuildingID .. ")",
        --            _BuildingID,
        --            false)
    end
end


function Feedback_BuildingRequiresWealth(_BuildingID)
    if Logic.GetTime() > 1
    and GUI.GetPlayerID() == Logic.EntityGetPlayer(_BuildingID) then
    --and math.mod(BuildingNeeds.WealthActivationCounter,3) == 0 then

        --GUI.ShortMessages_AddMessageEntity(
        --            1002,
        --            "Settlers in a building have the need for WEALTH now. Build Handcrafting buildings to produce decorative objects.",
        --            "graphics\\textures\\gui\\msg\\Critical_Entert.png",
        --            "Feedback_SelectAndJumptToEntityIfValid(" .. _BuildingID .. ")",
        --            _BuildingID,
        --            false)
    end
end


function GameCallback_Feedback_SettlerSpawned(_PlayerID, _EntityID)

    --if _PlayerID == GUI.GetPlayerID() then
    --    -- GUI.AddNote("SettlerSpawned: " .. _EntityID)
    --end
    --
    ----count spouses for player 1
    --if _PlayerID == 1 and Framework.IsNetworkGame() == false then
    --
    --    Feedback_LastSpawnedSettlerID = _EntityID;
    --
    --    -- spouses needs an own entitycategory
    --
    --    local EnityType = Logic.GetEntityType(_EntityID)
    --
    --    if (EnityType == Entities.U_Spouse01) or (EnityType == Entities.U_Spouse02) or (EnityType == Entities.U_Spouse03) then
    --        if FirstSpouseInTheCity == nil then
    --
    --            GUI.ShortMessages_AddMessageEntity(
    --                g_FeedbackCategory.NewSpouse,
    --                "Congratulation! The first settler attracted a spouse.",
    --                "graphics\\textures\\gui\\msg\\info.png",
    --                "Feedback_SelectAndJumptToEntityIfValid(" .. _EntityID .. ")",
    --                _EntityID,
    --                false)
    --
    --            Sound.FXPlay2DSound( "Jingles\\jingle_Spouse", 0 )
    --
    --            FirstSpouseInTheCity = true
    --        end
    --    end
    --end
end


function GameCallback_Feedback_OnKnightComatose(_PlayerID, _EntityID)
    --should be unnecessary due to EntityKilled callback
end


function GameCallback_Feeback_BuildingDestroyed(_BuildingID, _PlayerID, _KnockedDown, _X, _Y, _Z)

    --should be unnecessary due to EntityKilled callback
    --if GUI.GetPlayerID() == _PlayerID
    --and _KnockedDown ~= 1 then
    --
    --    local X, Y = Logic.GetEntityPosition(_BuildingID)
    --
    --    GUI.ShortMessages_AddMessagePosition(
    --        g_FeedbackCategory.BuildingDeytroyed,
    --        "A building has been destroyed!", "graphics\\textures\\gui\\msg\\building_destroyed.png", nil, X, Y, 50)
    --end
end


--function GameCallback_Feedback_NumberOfWorkersIncreased(_PlayerID, _NewNumWorkers)
--
--    ScriptCallback_Feedback_NumberOfWorkersIncreased(_PlayerID, _NewNumWorkers)
--
--
--end

function GameCallback_Feedback_EndOfMonth(_LastMonth, _NewMonth)

    return 0
end


function GameCallback_Feedback_TreasuryLimitReached(_PlayerID, _EntityID)

end


function ScriptCallback_Feedback_EndOfMonth(_LastMonth, _NewMonth)

end


function GameCallback_Feedback_ResourceDiscovered(_PlayerID, _EntityID, _GoodType)

end


function GameCallback_Feedback_NumberOfWorkersIncreased(_PlayerID, _NewNumWorkers)
end


function ScriptCallback_Feedback_NumberOfWorkersIncreased(_PlayerID, _NewNumWorkers)

end

-- ----------------------------------------------------------------------
-- GameCallback_Feedback_WorkerStarved
-- ----------------------------------------------------------------------

function GameCallback_Feedback_WorkerStarved(_PlayerID, _EntityID)
--
--    if _PlayerID == GUI.GetPlayerID() then
--
--        local WorkPlaceID = Logic.GetSettlersWorkBuilding(_EntityID)
--          local EntityType = Logic.GetEntityType(_EntityID)
--      local EntityTypeName = XGUIEng.GetStringTableText("Names/" .. Logic.GetEntityTypeName(EntityType))
--
--        if (WorkPlaceID ~= 0) then
--
--            -- this settler has a workplace
--          local Text = ""
--
--          if (EntityTypeName ~= nil) then
--              Text = "A " .. EntityTypeName .. " has starved. The people in his building are in mourning"
--            else
--              Text = "A" .. EntityType .. " has starved. The people in his building are in mourning"
--            end
--
--            GUI.ShortMessages_AddMessageEntity(
--                        g_FeedbackCategory.WorkerLimitReached,
--                        Text,
--                        "graphics\\textures\\gui\\msg\\settler_died_hunger.png",
--                        "Feedback_SelectAndJumptToEntityIfValid(" .. WorkPlaceID .. ")",
--                        WorkPlaceID,
--                        false)
--
--            Sound.FXPlay2DSound( "Jingles\\jingle_starving", 0 )
--
--        else
--
--            -- this settler was prolly a beggar without a workplace
--          local Text = ""
--
--          if (EntityTypeName ~= nil) then
--              Text = "A " .. EntityTypeName .. " has starved."
--            else
--              Text = "A" .. EntityType .. " has starved."
--            end
--
--            GUI.ShortMessages_AddMessage(
--                        g_FeedbackCategory.WorkerLimitReached,
--                        Text,
--                        "graphics\\textures\\gui\\msg\\settler_died_hunger.png",
--                        "Feedback_SelectAndJumptToEntityIfValid(" .. WorkPlaceID .. ")")
--
--            Sound.FXPlay2DSound( "Jingles\\jingle_starving", 0 )
--
--        end
--    end
--
--    if _PlayerID == 1 and Framework.IsNetworkGame() == false then
--
--        --statistics for new prestige system
--        Statistic.SettlersDieOfStarvation = Statistic.SettlersDieOfStarvation + 1
--
--    end
--
end

-- ----------------------------------------------------------------------
-- GameCallback_Feedback_WorkerDiedOfIllness
-- ----------------------------------------------------------------------

function GameCallback_Feedback_WorkerDiedOfIllness(_PlayerID, _EntityID)
--
--    if _PlayerID == GUI.GetPlayerID() then
--
--        local EntityType = Logic.GetEntityType(_EntityID)
--      local EntityTypeName = XGUIEng.GetStringTableText("Names/" .. Logic.GetEntityTypeName(EntityType))
--      local WorkPlaceID = Logic.GetSettlersWorkBuilding(_EntityID)
--
--      local Text = ""
--
--      if (EntityTypeName ~= nil) then
--          Text = "A " .. EntityTypeName .. " has died due to illness. The people in his building are in mourning."
--        else
--          Text = "A" .. EntityType .. " has died due to illness. The people in his building are in mourning."
--        end
--
--
--        GUI.ShortMessages_AddMessageEntity(
--            g_FeedbackCategory.WorkerLimitReached,
--            Text,
--            "graphics\\textures\\gui\\msg\\settler_died_illness.png",
--            "Feedback_SelectAndJumptToEntityIfValid(" .. WorkPlaceID .. ")",
--            WorkPlaceID,
--            false)
--        Sound.FXPlay2DSound( "Jingles\\jingle_illness", 0 )
--
--    end
--
--    if _PlayerID == 1 and Framework.IsNetworkGame() == false then
--
--        --statistics for new prestige system
--        Statistic.SettlersDiedOfIllness = Statistic.SettlersDiedOfIllness + 1
--
--    end
--
end

-- ----------------------------------------------------------------------
-- ScriptCallback_Feedback_NewTechnologyLimit
-- ----------------------------------------------------------------------

function ScriptCallback_Feedback_NewTechnologyLimit(_NewTechLimit)
--
--    local CastleID = Logic.GetHeadquarters(1)
--
--    GUI.ShortMessages_AddMessage(
--                    g_FeedbackCategory.NewTechnologyLimit,
--                    "You've gained enough prestige to research more technologies.",
--                    "graphics\\textures\\gui\\msg\\TechLimitRaised.png",
--                    nil)
--
--    Sound.FXPlay2DSound( "Jingles\\jingle_technology_new", 0 )
end

-- ----------------------------------------------------------------------
-- GameCallback_Feedback_FarmAnimalOutOfRange
-- ----------------------------------------------------------------------

function GameCallback_Feedback_FarmAnimalOutOfRange(_PlayerID, _EntityID)
--
--    if _PlayerID == GUI.GetPlayerID() and Logic.GetCurrentTurn() > 10
--    then
--        local EntityType = Logic.GetEntityType(_EntityID)
--      local EntityTypeName = XGUIEng.GetStringTableText("Names/" .. Logic.GetEntityTypeName(EntityType))
--
--
--        local Text = ""
--
--        if (EntityTypeName ~= nil) then
--            Text = "A " .. EntityTypeName .. " not in range of any farm"
--        else
--            Text = "A farm animal is out of range of any farm"
--        end
--
--
--        GUI.ShortMessages_AddMessageEntity(
--                    g_FeedbackCategory.FarmAnimalOutOfRange,
--                    Text,
--                    "graphics\\textures\\gui\\msg\\info.png",
--                    "Feedback_SelectAndJumptToEntityIfValid(" .. _EntityID .. ")",
--                    _EntityID,
--                    false,
--                    true)
--
--    end
end

-- ----------------------------------------------------------------------
-- GameCallback_Feedback_BuildingAutomaticallyUpgraded
-- ----------------------------------------------------------------------

function GameCallback_Feedback_BuildingAutomaticallyUpgraded(_PlayerID, _EntityID, _UpgradeLevel)
--
--    if _PlayerID == GUI.GetPlayerID() and Logic.GetCurrentTurn() > 10
--    then
--        local X, Y = Logic.GetEntityPosition(_EntityID)
--        GUI.ScriptSignal(X, Y, 4) --orange
--    end
end


function GameCallback_Feedback_OnNewBeggar(_PlayerID, _EntityID)
--
--    if _PlayerID == GUI.GetPlayerID() then
--        -- GUI.AddNote("OnNewBeggar: " .. _EntityID)
--    end
--
--    if _PlayerID == 1 and Framework.IsNetworkGame() == false then
--
--        if FirstBeggarInTheCity == nil then
--
--              GUI.ShortMessages_AddMessageEntity(
--                  g_FeedbackCategory.WorkerLimitReached,
--                  "A settler lost his workplace and is unemployed now!",
--                  "graphics\\textures\\gui\\msg\\info.png",
--                  "Feedback_SelectAndJumptToEntityIfValid(" .. _EntityID .. ")",
--                  _EntityID,
--                              false)
--
--            Sound.FXPlay2DSound( "Jingles\\jingle_beggar", 0 )
--
--            FirstBeggarInTheCity = true
--          end
--
--
--    end
--
end

function GameCallback_Feedback_FarmAnimalChangedPlayerID(_PlayerID, _NewEntityID, _OldEntityID)

end

function GameCallback_Feedback_WalkCommandTargetAdjusted(_WantedX, _WantedY)

end

