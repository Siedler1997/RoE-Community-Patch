

-----------------------------------------------------------------
-- Overwrites for Feedback
-----------------------------------------------------------------

function InitOverwriteFeedbackEx2()

    do
        local OldGameCallback_Feedback_NewCouplesAfterFestival = GameCallback_Feedback_NewCouplesAfterFestival
        function GameCallback_Feedback_NewCouplesAfterFestival(_PlayerID, _NewCouples, _FestivalAbilityIsActive,_NewCouplesByThordal)

            -- stop the event music
            local PlayerID = GUI.GetPlayerID()
            StopEventMusic(MusicSystem.EventPromotionMusic, PlayerID)
            StopEventMusic(MusicSystem.EventPromotion2Music, PlayerID)

            OldGameCallback_Feedback_NewCouplesAfterFestival(_PlayerID, _NewCouples, _FestivalAbilityIsActive,_NewCouplesByThordal)
        end
    end

    do
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
    end

    do
        local OldGameCallback_Feedback_EntityHurt = GameCallback_Feedback_EntityHurt
        function GameCallback_Feedback_EntityHurt(_HurtPlayerID, _HurtEntityID, _HurtingPlayerID, _HurtingEntityID, _DamageReceived, _DamageDealt)
            local HurtEntityType = Logic.GetEntityType(_HurtEntityID)

            if HurtEntityType == nil or HurtEntityType == 0 then
                return
            end

            -- tell player once about the action special ability of these knights
            if ((Logic.GetEntityType(_HurtingEntityID) == Entities.U_KnightWisdom or Logic.GetEntityType(_HurtingEntityID) == Entities.U_KnightSabatta) and Logic.IsBuilding(_HurtEntityID) == 0)
            or ((Logic.GetEntityType(_HurtingEntityID) == Entities.U_KnightChivalry or Logic.GetEntityType(_HurtingEntityID) == Entities.U_KnightKhana) and Logic.IsBuilding(_HurtEntityID) == 1) then
                if Logic.GetHeadquarters(_HurtPlayerID) ~= 0 then
                    StartKnightVoiceForActionSpecialAbility(Logic.GetEntityType(_HurtingEntityID))
                end
            end

            --from here just call original callback
            OldGameCallback_Feedback_EntityHurt(_HurtPlayerID, _HurtEntityID, _HurtingPlayerID, _HurtingEntityID, _DamageReceived, _DamageDealt)
        end
    end

    do 
        local OldGameCallback_Feedback_OnBuildingConstructionComplete = GameCallback_Feedback_OnBuildingConstructionComplete
        function GameCallback_Feedback_OnBuildingConstructionComplete(_PlayerID, _BuildingID)
            OldGameCallback_Feedback_OnBuildingConstructionComplete(_PlayerID, _BuildingID)
            GameCallback_GUI_SelectionChanged()
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

end
 
