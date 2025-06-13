

-----------------------------------------------------------------
-- Overwrites
-----------------------------------------------------------------
do

    local OldGameCallback_Feedback_GathererCannotFindResource = GameCallback_Feedback_GathererCannotFindResource
    
    GameCallback_Feedback_GathererCannotFindResource = function(_PlayerID, _EntityID, _GoodType, _SeasonallyUnavailable)
    
        -- Note: this assumes there is never! ice in the Asia setting
        if  GUI.GetPlayerID() == _PlayerID
            and
            _GoodType == Goods.G_RawFish 
            and 
            _SeasonallyUnavailable == 1
            and
            Logic.GetClimateZone() == ClimateZones.Asia 
        then
            if Debug_EnableDebugOutput then
                GUI.AddNote("Fisher doens't find fish b/c of monsoon") 
            end
            return
        end
        
        OldGameCallback_Feedback_GathererCannotFindResource(_PlayerID, _EntityID, _GoodType, _SeasonallyUnavailable)
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


function GameCallback_Feedback_EntityHurt(_HurtPlayerID, _HurtEntityID, _HurtingPlayerID, _HurtingEntityID, _DamageReceived, _DamageDealt)

    local HurtEntityType = Logic.GetEntityType(_HurtEntityID)

    if HurtEntityType == nil
    or HurtEntityType == 0 then
        return
    end

    local PlayerID = GUI.GetPlayerID()

    -- tell player once about the action special ability of wisdom and marcus
    if (Logic.GetEntityType(_HurtingEntityID) == Entities.U_KnightWisdom
    or Logic.GetEntityType(_HurtingEntityID) == Entities.U_KnightSabatta) and Logic.IsBuilding(_HurtEntityID) == 0
    or (Logic.GetEntityType(_HurtingEntityID) == Entities.U_KnightChivalry
    or Logic.GetEntityType(_HurtingEntityID) == Entities.U_KnightKhana) and Logic.IsBuilding(_HurtEntityID) == 1 then
        
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
                
            elseif Logic.GetEntityType(_HurtEntityID) == Entities.B_TradePost then
                
                SpeechTextKey = "Minimap_AttackedTradePost"
                -- no area check
                FeedbackSpeechCategory = g_FeedbackSpeech.Categories.AttackedTradePost
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

        elseif _KilledEntityType == Entities.U_Geologist then
            SpeechTextKey = "Minimap_DestroyedGeologist"
            -- no area check
            FeedbackSpeechCategory = g_FeedbackSpeech.Categories.DestroyedGeologist
            FeedbackSpeechAddFunction = GUI_FeedbackSpeech.Add
            OptionalScreenCheck, OptionalGenericAttackedCheck = false, false     

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
                
            elseif _KilledEntityType == Entities.B_TradePost then
                SpeechTextKey = "Minimap_DestroyedTradePost"
                -- no area check
                FeedbackSpeechCategory = g_FeedbackSpeech.Categories.DestroyedTradePost
                FeedbackSpeechAddFunction = GUI_FeedbackSpeech.Add
                OptionalScreenCheck, OptionalGenericAttackedCheck = false, false

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
-----------------------------------------------------------------
-- Add on stuff
-----------------------------------------------------------------


function GameCallback_Feedback_RawFishResourceWasFlooded(_EntityID)
    --GUI.AddNote("Fish resource not available b/c of monsoon")
end

function GameCallback_Feedback_CannotActivateTributeAbility(_PlayerID, _KnightID)
    
    local GUIPlayerID = GUI.GetPlayerID()
    
    if _PlayerID == GUIPlayerID then
        GUI.AddNote("Tribute Ability could not be activated")
    end   

end

function GameCallback_Feedback_TributeCartSent(_PlayerID, _KnightID, _TributePayingPlayerID, _GoodType, _Amount)
    
    local GUIPlayerID = GUI.GetPlayerID()
    
    if Debug_EnableDebugOutput then
    
        if _PlayerID == GUIPlayerID then
            GUI.AddNote("Debug: You made Player " ..  _TributePayingPlayerID .. " send a tribute cart containing " .. _Amount .. " " .. Logic.GetGoodTypeName(_GoodType))
        elseif _TributePayingPlayerID == GUIPlayerID then
            GUI.AddNote("Debug: Player " ..  _PlayerID .. "'s hero made you send a tribute cart containing " .. _Amount .. " " .. Logic.GetGoodTypeName(_GoodType))
        end        
   
    end

end

            
function GameCallback_Feedback_TradeNotExecuted(_PlayerID, _EntityID, _ErrorCode, _ErrorPlayerID, _ErrorGoodType)

    local GUIPlayerID = GUI.GetPlayerID()
    
    if GUIPlayerID ~= _PlayerID then

        return
        
    end

    if _ErrorCode == TradePost.Error_LackingTradeGood then
        if _PlayerID == _ErrorPlayerID then
            GUI_FeedbackSpeech.Add("Minimap_NoTradePostTradeThisMonth", g_FeedbackSpeech.Categories.TradePost_NoGoods, _EntityID, _PlayerID)
        end
        
        if Debug_EnableDebugOutput then
        
            if _PlayerID == _ErrorPlayerID then    
                GUI.AddNote("Debug: You are lacking " .. Logic.GetGoodTypeName(_ErrorGoodType) .. " for trade")                        
            else        
                GUI.AddNote("Debug: Your trade partner player " .. _ErrorPlayerID .. " is lacking " .. Logic.GetGoodTypeName(_ErrorGoodType) .. " for trade")                        
            end
        end
    end
    
end

function GameCallback_Feedback_TradeExecuted(_PlayerID, _TradepostID)
    
    local GUIPlayerID = GUI.GetPlayerID()
    
    if GUIPlayerID ~= _PlayerID then

        return
        
    end
    
    GUI_FeedbackSpeech.Add("Minimap_TradePostTradeNow", g_FeedbackSpeech.Categories.TradePost_TradeCartSent, _TradepostID)

end

--------------------------------------------------------------------------------
-- The purpose of this function is to inform the gamer about the discrepancy
-- in Script & Code diplomacy states. When a gamer attempts to move a military
-- unit into a neutral village (wall surrounded) the attempt will fail.
--------------------------------------------------------------------------------
function GameCallback_Feedback_WalkCommandTargetAdjusted(_WantedX, _WantedY)

    
    local PlayerID = GUI.GetPlayerID()
    local EntityID = GUI.GetSelectedEntity()
    local EntityType = Logic.GetEntityType(EntityID)
    
    if EntityID ~= nil then
         if Logic.IsKnight(EntityID) == true 
            or
            Logic.IsEntityInCategory(EntityID,EntityCategories.Leader) == 1
            or 
            Logic.IsEntityInCategory(EntityID,EntityCategories.HeavyWeapon) == 1
         then
            
            local FromPlayerSectorID = Logic.GetPlayerSectorID(
                PlayerID, PlayerSectorTypes.Thief, Logic.GetEntityPosition(EntityID))
                
            if FromPlayerSectorID ~= 0 then
                local ToPlayerSectorID = Logic.GetPlayerSectorID(
                PlayerID, PlayerSectorTypes.Thief, _WantedX, _WantedY)
                
                if ToPlayerSectorID ~= 0 then
                    
                    assert(FromPlayerSectorID ~= 0)
                    assert(ToPlayerSectorID ~= 0)
                    
                    if FromPlayerSectorID == ToPlayerSectorID then 
                        
                        local TerritoryID = Logic.GetTerritoryAtPosition(_WantedX, _WantedY)
                        
                        local TerritoryOwningPlayerID = Logic.GetTerritoryPlayerID(TerritoryID)
                        
                        if  TerritoryOwningPlayerID ~= PlayerID
                            and
                            Logic.GetDiplomacyState(TerritoryOwningPlayerID, PlayerID) == Diplomacy.Neutral 
                        then
                        
                            local ExplorationState = Logic.GetFoWState(PlayerID, _WantedX, _WantedY)
                            
                            if ExplorationState ~= nil and ExplorationState ~= 0 then
                        
                                if Debug_EnableDebugOutput then
                                    GUI.AddNote("You cannot enter this settlement")
                                end
                            
                                GUI_FeedbackSpeech.Add("SpeechOnly_CannotEnterTown", g_FeedbackSpeech.Categories.CannotEnterSettlement, EntityID)
                            end
                            
                        end
                    end
                end
            end
         end
    end
end


function GameCallback_Feedback_OnGeologistBought(_PlayerID, _EntityID)

    if (GUI.GetPlayerID() == _PlayerID) then
    
        GUI_FeedbackSpeech.Add("Minimap_CalledGeologist", g_FeedbackSpeech.Categories.GeologistCalled, _EntityID)
        
    end

end




function GameCallback_Feedback_OnObjectInteraction(_EntityID, _PlayerID, _ReplaceEntityID)

    local EntityType = Logic.GetEntityType(_ReplaceEntityID)    
    if (EntityType == Entities.D_AS_RockBarrier_Full) then
    
    	local x,y = Logic.GetEntityPosition(_ReplaceEntityID)
    	Sound.FXPlay3DSound("Misc\\RockBarrier_Fill", x, y, 0)

    end
    
end



function GameCallback_Feedback_OnGeologistRefill(_GeologistPlayerID, _RefilledObjectID, _GeologistID)

    if GUI.GetPlayerID() == _GeologistPlayerID then
    
        local EntityType = Logic.GetEntityType(_RefilledObjectID)
    
        if EntityType == Entities.B_Cistern then
            GUI_FeedbackSpeech.Add("Minimap_RepairedWellGeologist", g_FeedbackSpeech.Categories.GeologistRefilled, _RefilledObjectID)
        else        
            GUI_FeedbackSpeech.Add("Minimap_RessourcesFoundGeologist", g_FeedbackSpeech.Categories.GeologistRefilled, _RefilledObjectID)
        end
    
    end
    
end


do 
    local OldGameCallback_Feedback_OnBuildingConstructionComplete = GameCallback_Feedback_OnBuildingConstructionComplete
    
    function GameCallback_Feedback_OnBuildingConstructionComplete(_PlayerID, _BuildingID)
    
        local EntityType  = Logic.GetEntityType(_BuildingID)
        local GUIPlayerID = GUI.GetPlayerID()
        
        if  EntityType == Entities.B_TradePost 
            and
            GUIPlayerID == _PlayerID 
        then
            GUI_FeedbackSpeech.Add("Minimap_ErectedTradePost", g_FeedbackSpeech.Categories.TradePost_Constructed, _BuildingID)
            
            return
        end
        
        OldGameCallback_Feedback_OnBuildingConstructionComplete(_PlayerID, _BuildingID)
    
        GameCallback_GUI_SelectionChanged()

    end
    
end    



function GameCallback_Feedback_RefillableWellRanDry(_PlayerID, _EntityID)
    
    
    if GUI.GetPlayerID() == _PlayerID then
    
        if Debug_EnableDebugOutput then
            GUI.AddNote("A refillable well has run dry") 
        end
    
        GUI_FeedbackSpeech.Add("Minimap_WellNoWater", g_FeedbackSpeech.Categories.WellRanDry, _EntityID)
    end
end

function GameCallback_Feedback_ShallowWaterFlooded()
    
    if Debug_EnableDebugOutput then
        GUI.AddNote("Shallow water flooded") 
    end
    
    GUI_FeedbackSpeech.Add("SpeechOnly_RainySeason_Start", g_FeedbackSpeech.Categories.Monsoon)
end

function GameCallback_Feedback_ShallowWaterUnflooded()
    
    if Debug_EnableDebugOutput then
        GUI.AddNote("Shallow water unflooded") 
    end


    GUI_FeedbackSpeech.Add("SpeechOnly_RainySeason_End", g_FeedbackSpeech.Categories.Monsoon)
    
end

do 
    local OldGameCallback_Feedback_OnThiefStealBuilding = GameCallback_Feedback_OnThiefStealBuilding
    
    function GameCallback_Feedback_OnThiefStealBuilding(_ThiefID, _ThiefPlayerID, _BuildingID, _BuildingPlayerID)
    
        local EntityType  = Logic.GetEntityType(_BuildingID)
        local GUIPlayerID = GUI.GetPlayerID()
        
        if GUIPlayerID == _ThiefPlayerID and EntityType == Entities.B_Cistern then
        
            GUI_FeedbackSpeech.Add("ThiefSabotagesWell_Success", g_FeedbackSpeech.Categories.ThiefSabotagedWell, _BuildingID)
        
            return
        end
        
        
        OldGameCallback_Feedback_OnThiefStealBuilding(_ThiefID, _ThiefPlayerID, _BuildingID, _BuildingPlayerID)
    end
end

do
    local OldGameCallback_Feedback_AddSettlerMissingNeedGood = GameCallback_Feedback_AddSettlerMissingNeedGood
    
    function GameCallback_Feedback_AddSettlerMissingNeedGood(_PlayerID, _EntityID, _GoodCategory)
        if _PlayerID ~= GUI.GetPlayerID() then
            return
        end
        
        if _GoodCategory == GoodCategories.GC_Clothes then
            StartKnightVoiceForActionSpecialAbility(Entities.U_KnightPraphat)
        end
        
        OldGameCallback_Feedback_AddSettlerMissingNeedGood(_PlayerID, _EntityID, _GoodCategory)
    end
end