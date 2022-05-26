--++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
-- Selection
--++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++

GUI_Selection = {}

g_Selection = {}
g_Selection.MaxDoubleClickTime   = 400
g_Selection.LastClickTime        = -9999
g_Selection.LastSelectionGroup   = -1


g_SelectionChangedSource = {}
g_SelectionChangedSource.User    = 0  --(selecting and deselecting with mouse)
g_SelectionChangedSource.Logic   = 1  --(entites deselected or removed from logic (dying))
g_SelectionChangedSource.Script  = 2  --(selection changed by a script call to the logic)
g_SelectionChangedSource.Upgrade = 3  --(entities exchanged (building upgrade, �))


function GUI_Selection.RightClicked()
    --GUI_Construction.CloseContextSensitiveMenu()
end


function GameCallback_GUI_SelectionChanged(_Source)

    local SelectedEntities = {GUI.GetSelectedEntities()}

    local SoundToPlay = ""

    g_Tooltip.FadeInCurrentWidgetID = nil

    -- go back to the normal camera if we're not in the throne room
    local CurrentCameraBehaviour = Camera.GetCameraBehaviour()

    --if CurrentCameraBehaviour ~= 5 then
    if CurrentCameraBehaviour == 1 then
       ShowCloseUpView(0)
       g_LastSelectedInhabitant = nil
       Camera.SwitchCameraBehaviour(0)
       Camera.RTS_FollowEntity(0)
       --FlagInhabitants()
    end

    --no idea, why this only works, if is done before all other stuff
    --to what does the above refer?

    XGUIEng.ShowWidget("/InGame/Root/Normal/AlignBottomRight/Selection/MultiSelection",0)

    GUI_Construction.CloseContextSensitiveMenu()

    local PlayerID = GUI.GetPlayerID()
    local EntityID = GUI.GetSelectedEntity()
    local EntityType = Logic.GetEntityType(EntityID)

    if EntityID ~= nil then

        XGUIEng.UnHighLightGroup("/InGame", "MenuButtons")

        XGUIEng.ShowWidget("/InGame/Root/Normal/BuildingButtons",0)
        
        XGUIEng.ShowWidget("/InGame/Root/Normal/AlignBottomRight/KnightTitleMenu",0)
        XGUIEng.ShowWidget("/InGame/Root/Normal/AlignTopCenter/KnightTitleMenuBig",0)

        XGUIEng.ShowWidget("/InGame/Root/Normal/AlignBottomRight/SalesDialog",0)

        GUI.CancelState()

        if Logic.IsBuilding(EntityID) == 1 then

            SoundToPlay =  "ui\\menu_click_select_building"

            XGUIEng.ShowWidget("/InGame/Root/Normal/AlignBottomRight/Selection",1)
            XGUIEng.ShowAllSubWidgets("/InGame/Root/Normal/AlignBottomRight/Selection",0)

            XGUIEng.ShowWidget("/InGame/Root/Normal/AlignBottomRight/DialogButtons",1)
            XGUIEng.ShowAllSubWidgets("/InGame/Root/Normal/AlignBottomRight/DialogButtons",0)

            XGUIEng.ShowWidget("/InGame/Root/Normal/BuildingButtons",1)
            XGUIEng.ShowAllSubWidgets("/InGame/Root/Normal/BuildingButtons",1)
            XGUIEng.ShowWidget("/InGame/Root/Normal/AlignBottomRight/Selection/BuildingButtonsPositionUpdater",1)

            if g_OnGameStartPresentationMode == true then return end -- RETURN BECAUSE WE DO NOT WANT TO SHOW DETAILS IN PRESENTATION

            XGUIEng.ShowWidget("/InGame/Root/Normal/AlignBottomRight/Selection/Info",1)

            if Logic.IsEntityInCategory(EntityID, EntityCategories.OuterRimBuilding) == 1
            or Logic.IsEntityInCategory(EntityID, EntityCategories.CityBuilding) == 1 then

                XGUIEng.ShowWidget("/InGame/Root/Normal/AlignBottomRight/Selection/Business",1)
                XGUIEng.ShowAllSubWidgets("/InGame/Root/Normal/AlignBottomRight/Selection/Business",1)
                XGUIEng.ShowAllSubWidgets("/InGame/Root/Normal/AlignBottomRight/Selection/Business/City",1)
                XGUIEng.ShowWidget("/InGame/Root/Normal/AlignBottomRight/Selection/Needs",1)
                XGUIEng.ShowWidget("/InGame/Root/Normal/AlignBottomRight/DialogButtons/Building",1)

                --XGUIEng.ShowWidget("/InGame/Root/Normal/BuildingInfo/JumpToButtons",1)

                --FlagInhabitants(EntityID)

                --if EntityType == Entities.B_HuntersHut then
                --    XGUIEng.ShowWidget("/InGame/Root/Normal/AlignBottomRight/DialogButtons/Hunter", 1)
                --end

                --different layouts
                if Logic.IsEntityInCategory(EntityID, EntityCategories.OuterRimBuilding) == 1 then
                    XGUIEng.ShowAllSubWidgets("/InGame/Root/Normal/AlignBottomRight/Selection/Needs",0)
                    XGUIEng.ShowWidget("/InGame/Root/Normal/AlignBottomRight/Selection/Needs/BGOuterRim", 1)
                    XGUIEng.ShowWidget("/InGame/Root/Normal/AlignBottomRight/Selection/Needs/CaptionNeeds", 1)
                    XGUIEng.ShowWidget("/InGame/Root/Normal/AlignBottomRight/Selection/Needs/Nutrition", 1)

                    XGUIEng.ShowWidget("/InGame/Root/Normal/AlignBottomRight/Selection/BGMedium",1)

                    XGUIEng.ShowWidget("/InGame/Root/Normal/AlignBottomRight/Selection/Business/City", 0)

                    local AnchorNeedsForMediumX, AnchorNeedsForMediumY = XGUIEng.GetWidgetLocalPosition("/InGame/Root/Normal/AlignBottomRight/Selection/AnchorNeedsForMedium")
                    XGUIEng.SetWidgetLocalPosition("/InGame/Root/Normal/AlignBottomRight/Selection/Needs", AnchorNeedsForMediumX, AnchorNeedsForMediumY)

                    local AnchorInfoForMediumX, AnchorInfoForMediumY = XGUIEng.GetWidgetLocalPosition("/InGame/Root/Normal/AlignBottomRight/Selection/AnchorInfoForMedium")
                    XGUIEng.SetWidgetLocalPosition("/InGame/Root/Normal/AlignBottomRight/Selection/Info", AnchorInfoForMediumX, AnchorInfoForMediumY)

                    local AnchorBusinessAndSettlerForMediumX, AnchorBusinessAndSettlerForMediumY = XGUIEng.GetWidgetLocalPosition("/InGame/Root/Normal/AlignBottomRight/Selection/AnchorBusinessAndSettlerForMedium")
                    XGUIEng.SetWidgetLocalPosition("/InGame/Root/Normal/AlignBottomRight/Selection/Business", AnchorBusinessAndSettlerForMediumX, AnchorBusinessAndSettlerForMediumY)
                    XGUIEng.SetWidgetLocalPosition("/InGame/Root/Normal/AlignBottomRight/Selection/Settler", AnchorBusinessAndSettlerForMediumX, AnchorBusinessAndSettlerForMediumY)
                else
                    XGUIEng.ShowAllSubWidgets("/InGame/Root/Normal/AlignBottomRight/Selection/Needs",1)
                    XGUIEng.ShowWidget("/InGame/Root/Normal/AlignBottomRight/Selection/Needs/BGOuterRim", 0)

                    XGUIEng.ShowWidget("/InGame/Root/Normal/AlignBottomRight/Selection/BGBig", 1)

                    XGUIEng.ShowWidget("/InGame/Root/Normal/AlignBottomRight/Selection/Business/OuterRim", 0)

                    if EntityType == Entities.B_Barracks
                    or EntityType == Entities.B_BarracksArchers
                    or EntityType == Entities.B_SiegeEngineWorkshop then
                        XGUIEng.ShowWidget("/InGame/Root/Normal/AlignBottomRight/Selection/Business/City/Money", 0)
                        XGUIEng.ShowWidget("/InGame/Root/Normal/AlignBottomRight/Selection/Needs/Prosperity", 0)
                    end

                    local AnchorNeedsForBigX, AnchorNeedsForBigY = XGUIEng.GetWidgetLocalPosition("/InGame/Root/Normal/AlignBottomRight/Selection/AnchorNeedsForBig")
                    XGUIEng.SetWidgetLocalPosition("/InGame/Root/Normal/AlignBottomRight/Selection/Needs", AnchorNeedsForBigX, AnchorNeedsForBigY)

                    local AnchorInfoForBigX, AnchorInfoForBigY = XGUIEng.GetWidgetLocalPosition("/InGame/Root/Normal/AlignBottomRight/Selection/AnchorInfoForBig")
                    XGUIEng.SetWidgetLocalPosition("/InGame/Root/Normal/AlignBottomRight/Selection/Info", AnchorInfoForBigX, AnchorInfoForBigY)

                    local AnchorBusinessAndSettlerForBigX, AnchorBusinessAndSettlerForBigY = XGUIEng.GetWidgetLocalPosition("/InGame/Root/Normal/AlignBottomRight/Selection/AnchorBusinessAndSettlerForBig")
                    XGUIEng.SetWidgetLocalPosition("/InGame/Root/Normal/AlignBottomRight/Selection/Business", AnchorBusinessAndSettlerForBigX, AnchorBusinessAndSettlerForBigY)
                    XGUIEng.SetWidgetLocalPosition("/InGame/Root/Normal/AlignBottomRight/Selection/Settler", AnchorBusinessAndSettlerForBigX, AnchorBusinessAndSettlerForBigY)
                end
            elseif Logic.GetHeadquarters(PlayerID) == EntityID then
                XGUIEng.ShowWidget("/InGame/Root/Normal/AlignBottomRight/Selection/BGSmall",1)
                XGUIEng.ShowWidget("/InGame/Root/Normal/AlignBottomRight/Selection/Castle",1)
                
                if g_HideSoldierPayment ~= nil then
                    
                    XGUIEng.ShowWidget("/InGame/Root/Normal/AlignBottomRight/Selection/Castle/Treasury/Payment",0)
                    XGUIEng.ShowWidget("/InGame/Root/Normal/AlignBottomRight/Selection/Castle/LimitSoldiers",0)
                    
                end
                
                GUI_BuildingInfo.PaymentLevelSliderUpdate()
                GUI_BuildingInfo.TaxationLevelSliderUpdate()

                local AnchorInfoForSmallX, AnchorInfoForSmallY = XGUIEng.GetWidgetLocalPosition("/InGame/Root/Normal/AlignBottomRight/Selection/AnchorInfoForSmall")
                XGUIEng.SetWidgetLocalPosition("/InGame/Root/Normal/AlignBottomRight/Selection/Info", AnchorInfoForSmallX, AnchorInfoForSmallY)
            elseif Logic.GetStoreHouse(PlayerID) == EntityID then
                XGUIEng.ShowWidget("/InGame/Root/Normal/AlignBottomRight/Selection/BGBig",1)
                XGUIEng.ShowWidget("/InGame/Root/Normal/AlignBottomRight/Selection/Storehouse",1)
                XGUIEng.ShowWidget("/InGame/Root/Normal/AlignBottomRight/DialogButtons/PlayerButtons",1)
                XGUIEng.ShowWidget("/InGame/Root/Normal/AlignBottomRight/Selection/Storehouse/AmountContainer",0)

                GUI_Trade.StorehouseSelected()

                g_Trade.GoodType = 0
                g_Trade.GoodAmount = 0

                local AnchorInfoForBigX, AnchorInfoForBigY = XGUIEng.GetWidgetLocalPosition("/InGame/Root/Normal/AlignBottomRight/Selection/AnchorInfoForBig")
                XGUIEng.SetWidgetLocalPosition("/InGame/Root/Normal/AlignBottomRight/Selection/Info", AnchorInfoForBigX, AnchorInfoForBigY)
            elseif Logic.GetCathedral(PlayerID) == EntityID then
                XGUIEng.ShowWidget("/InGame/Root/Normal/AlignBottomRight/Selection/BGSmall",1)
                XGUIEng.ShowWidget("/InGame/Root/Normal/AlignBottomRight/Selection/Cathedral",1)
                XGUIEng.ShowWidget("/InGame/Root/Normal/AlignBottomRight/DialogButtons/Building",1)

                local AnchorInfoForSmallX, AnchorInfoForSmallY = XGUIEng.GetWidgetLocalPosition("/InGame/Root/Normal/AlignBottomRight/Selection/AnchorInfoForSmall")
                XGUIEng.SetWidgetLocalPosition("/InGame/Root/Normal/AlignBottomRight/Selection/Info", AnchorInfoForSmallX, AnchorInfoForSmallY)
            else
                XGUIEng.ShowWidget("/InGame/Root/Normal/AlignBottomRight/Selection/Info",0)
            end

        elseif Logic.IsKnight(EntityID) == true then

            --SoundToPlay = "ui\\knight_select"

            XGUIEng.ShowWidget("/InGame/Root/Normal/AlignBottomRight/Selection",1)
            XGUIEng.ShowAllSubWidgets("/InGame/Root/Normal/AlignBottomRight/Selection",0)
            XGUIEng.ShowWidget("/InGame/Root/Normal/AlignBottomRight/Selection/BGKnight",1)

            XGUIEng.ShowWidget("/InGame/Root/Normal/AlignBottomRight/DialogButtons",1)
            XGUIEng.ShowAllSubWidgets("/InGame/Root/Normal/AlignBottomRight/DialogButtons",0)
            XGUIEng.ShowWidget("/InGame/Root/Normal/AlignBottomRight/DialogButtons/Knight",1)

            --show ClaimTerritory only for the first knight, not for the additional ones in map 15
            if Logic.GetKnightID(PlayerID) == EntityID then
                if Tutorial == nil
                or Tutorial ~= nil and Tutorial.IsClaimButtonShown ~= false then
                    XGUIEng.ShowWidget("/InGame/Root/Normal/AlignBottomRight/DialogButtons/Knight/ClaimTerritory",1)
                end
            else
                XGUIEng.ShowWidget("/InGame/Root/Normal/AlignBottomRight/DialogButtons/Knight/ClaimTerritory",0)
            end
            
            if EntityType == Entities.U_NPC_Castellan_ME or EntityType == Entities.U_NPC_Castellan_NE
                or EntityType == Entities.U_NPC_Castellan_NA or EntityType == Entities.U_NPC_Castellan_SE then
                XGUIEng.ShowWidget("/InGame/Root/Normal/AlignBottomRight/DialogButtons/Knight/StartAbility",0)
            else
                XGUIEng.ShowWidget("/InGame/Root/Normal/AlignBottomRight/DialogButtons/Knight/StartAbility",1)
            end

            XGUIEng.ShowWidget("/InGame/Root/Normal/AlignBottomRight/DialogButtons/Military",1)
            XGUIEng.ShowAllSubWidgets("/InGame/Root/Normal/AlignBottomRight/DialogButtons/Military",1)
            GUI_Military.StrengthUpdate()

            GUI_MultiSelection.CreateMultiSelection(_Source)

        elseif EntityType == Entities.U_Thief then

            XGUIEng.ShowWidget("/InGame/Root/Normal/AlignBottomRight/Selection",1)
            XGUIEng.ShowAllSubWidgets("/InGame/Root/Normal/AlignBottomRight/Selection",0)
            XGUIEng.ShowWidget("/InGame/Root/Normal/AlignBottomRight/Selection/BGMilitary",1)

            XGUIEng.ShowWidget("/InGame/Root/Normal/AlignBottomRight/DialogButtons",1)
            XGUIEng.ShowAllSubWidgets("/InGame/Root/Normal/AlignBottomRight/DialogButtons",0)
            XGUIEng.ShowWidget("/InGame/Root/Normal/AlignBottomRight/DialogButtons/Thief",1)
            XGUIEng.ShowAllSubWidgets("/InGame/Root/Normal/AlignBottomRight/DialogButtons/Thief",1)

            GUI_MultiSelection.CreateMultiSelection(_Source)
            
        elseif EntityType == Entities.U_Bear or EntityType == Entities.U_BlackBear or EntityType == Entities.U_PolarBear
            or EntityType == Entities.U_Wolf_Grey or EntityType == Entities.U_Wolf_White or EntityType == Entities.U_Wolf_Black or EntityType == Entities.U_Wolf_Brown
            or EntityType == Entities.U_Lion_Male or EntityType == Entities.U_Lion_Female then
            XGUIEng.ShowWidget("/InGame/Root/Normal/AlignBottomRight/Selection",1)
            XGUIEng.ShowAllSubWidgets("/InGame/Root/Normal/AlignBottomRight/Selection",0)
            XGUIEng.ShowWidget("/InGame/Root/Normal/AlignBottomRight/Selection/BGMilitary",1)
            
            XGUIEng.ShowWidget("/InGame/Root/Normal/AlignBottomRight/DialogButtons",1)
            XGUIEng.ShowAllSubWidgets("/InGame/Root/Normal/AlignBottomRight/DialogButtons",0)
            XGUIEng.ShowWidget("/InGame/Root/Normal/AlignBottomRight/DialogButtons/Military",1)
            XGUIEng.ShowAllSubWidgets("/InGame/Root/Normal/AlignBottomRight/DialogButtons/Military",0)
            XGUIEng.ShowWidget("/InGame/Root/Normal/AlignBottomRight/DialogButtons/Military/StandGround",1)
            XGUIEng.ShowWidget("/InGame/Root/Normal/AlignBottomRight/DialogButtons/Military/Attack",1)
            
            GUI_MultiSelection.CreateMultiSelection(_Source)

        elseif EntityType == Entities.U_AmmunitionCart then

            --SoundToPlay = "ui\\siege_select"

            XGUIEng.ShowWidget("/InGame/Root/Normal/AlignBottomRight/Selection",1)
            XGUIEng.ShowAllSubWidgets("/InGame/Root/Normal/AlignBottomRight/Selection",0)
            XGUIEng.ShowWidget("/InGame/Root/Normal/AlignBottomRight/Selection/BGMilitary",1)

            XGUIEng.ShowWidget("/InGame/Root/Normal/AlignBottomRight/DialogButtons",1)
            XGUIEng.ShowAllSubWidgets("/InGame/Root/Normal/AlignBottomRight/DialogButtons",0)
            XGUIEng.ShowWidget("/InGame/Root/Normal/AlignBottomRight/DialogButtons/AmmunitionCart",1)

            GUI_MultiSelection.CreateMultiSelection(_Source)

        elseif (EntityType == Entities.U_CatapultCart
        or EntityType == Entities.U_SiegeTowerCart
        or EntityType == Entities.U_BatteringRamCart) then

            --SoundToPlay = "ui\\siege_select"

            XGUIEng.ShowWidget("/InGame/Root/Normal/AlignBottomRight/Selection",1)
            XGUIEng.ShowAllSubWidgets("/InGame/Root/Normal/AlignBottomRight/Selection",0)
            XGUIEng.ShowWidget("/InGame/Root/Normal/AlignBottomRight/Selection/BGMilitary",1)

            XGUIEng.ShowWidget("/InGame/Root/Normal/AlignBottomRight/DialogButtons",1)
            XGUIEng.ShowAllSubWidgets("/InGame/Root/Normal/AlignBottomRight/DialogButtons",0)
            XGUIEng.ShowWidget("/InGame/Root/Normal/AlignBottomRight/DialogButtons/SiegeEngineCart",1)

            GUI_MultiSelection.CreateMultiSelection(_Source)

        elseif Logic.IsEntityInCategory(EntityID,EntityCategories.Leader) == 1 then

            --SoundToPlay = "ui\\military_select"

            XGUIEng.ShowWidget("/InGame/Root/Normal/AlignBottomRight/Selection",1)
            XGUIEng.ShowAllSubWidgets("/InGame/Root/Normal/AlignBottomRight/Selection",0)
            XGUIEng.ShowWidget("/InGame/Root/Normal/AlignBottomRight/Selection/BGMilitary",1)

            XGUIEng.ShowWidget("/InGame/Root/Normal/AlignBottomRight/DialogButtons",1)
            XGUIEng.ShowAllSubWidgets("/InGame/Root/Normal/AlignBottomRight/DialogButtons",0)
            XGUIEng.ShowWidget("/InGame/Root/Normal/AlignBottomRight/DialogButtons/Military",1)
            XGUIEng.ShowAllSubWidgets("/InGame/Root/Normal/AlignBottomRight/DialogButtons/Military",1)
            GUI_Military.StrengthUpdate()

            GUI_MultiSelection.CreateMultiSelection(_Source)

        elseif EntityType == Entities.U_TradeGatherer then
            --no selection menu
            XGUIEng.ShowWidget("/InGame/Root/Normal/AlignBottomRight/Selection",0)

        elseif (Logic.IsEntityInCategory(EntityID,EntityCategories.HeavyWeapon) == 1
        and EntityType ~= Entities.U_MilitaryBallista) then

            --SoundToPlay = "ui\\siege_select"

            XGUIEng.ShowWidget("/InGame/Root/Normal/AlignBottomRight/Selection",1)
            XGUIEng.ShowAllSubWidgets("/InGame/Root/Normal/AlignBottomRight/Selection",0)
            XGUIEng.ShowWidget("/InGame/Root/Normal/AlignBottomRight/Selection/BGMilitary",1)

            XGUIEng.ShowWidget("/InGame/Root/Normal/AlignBottomRight/DialogButtons",1)
            XGUIEng.ShowAllSubWidgets("/InGame/Root/Normal/AlignBottomRight/DialogButtons",0)
            XGUIEng.ShowWidget("/InGame/Root/Normal/AlignBottomRight/DialogButtons/Military",1)
            XGUIEng.ShowAllSubWidgets("/InGame/Root/Normal/AlignBottomRight/DialogButtons/Military",1)
            GUI_Military.StrengthUpdate()

            if (EntityType == Entities.U_MilitaryCatapult
            or EntityType == Entities.U_MilitarySiegeTower
            or EntityType == Entities.U_MilitaryBatteringRam) then
                XGUIEng.ShowWidget("/InGame/Root/Normal/AlignBottomRight/DialogButtons/SiegeEngine",1)
            end

            GUI_MultiSelection.CreateMultiSelection(_Source)

        elseif EntityType == Entities.U_MilitaryBallista then

            --SoundToPlay = "ui\\siege_select"

            XGUIEng.ShowWidget("/InGame/Root/Normal/AlignBottomRight/Selection",1)
            XGUIEng.ShowAllSubWidgets("/InGame/Root/Normal/AlignBottomRight/Selection",0)
            XGUIEng.ShowWidget("/InGame/Root/Normal/AlignBottomRight/Selection/BGMilitary",1)
            XGUIEng.ShowWidget("/InGame/Root/Normal/AlignBottomRight/DialogButtons",0)

            if #SelectedEntities == 1 then
                XGUIEng.ShowWidget("/InGame/Root/Normal/BuildingButtons",1)
                XGUIEng.ShowAllSubWidgets("/InGame/Root/Normal/BuildingButtons",1)
                XGUIEng.ShowWidget("/InGame/Root/Normal/AlignBottomRight/Selection/BuildingButtonsPositionUpdater",1)
            end

            GUI_MultiSelection.CreateMultiSelection(_Source)

        elseif EntityType == Entities.U_MilitaryTrap then

            XGUIEng.ShowWidget("/InGame/Root/Normal/AlignBottomRight/Selection",1)
            XGUIEng.ShowAllSubWidgets("/InGame/Root/Normal/AlignBottomRight/Selection",0)

            if #SelectedEntities == 1 then
                XGUIEng.ShowWidget("/InGame/Root/Normal/BuildingButtons",1)
                XGUIEng.ShowAllSubWidgets("/InGame/Root/Normal/BuildingButtons",1)
                XGUIEng.ShowWidget("/InGame/Root/Normal/AlignBottomRight/Selection/BuildingButtonsPositionUpdater",1)
            end

        elseif (Logic.IsGoodMerchant(EntityID) == 1
        or Logic.IsResoureMerchant(EntityID) == 1
        or Logic.IsEntertainer(EntityID))
        and EntityType ~= Entities.U_TradeGatherer then

            XGUIEng.ShowWidget("/InGame/Root/Normal/AlignBottomRight/Selection",1)
            XGUIEng.ShowAllSubWidgets("/InGame/Root/Normal/AlignBottomRight/Selection",0)
            XGUIEng.ShowWidget("/InGame/Root/Normal/AlignBottomRight/Selection/BGMilitary",1)
            XGUIEng.ShowWidget("/InGame/Root/Normal/AlignBottomRight/DialogButtons",1)
            XGUIEng.ShowAllSubWidgets("/InGame/Root/Normal/AlignBottomRight/DialogButtons",0)
            XGUIEng.ShowWidget("/InGame/Root/Normal/AlignBottomRight/DialogButtons/MerchantCart",1)

            local GoodType, GoodAmount = Logic.GetMerchantCargo(EntityID)

            if Logic.GetIndexOnOutStockByGoodType(Logic.GetStoreHouse(PlayerID), GoodType) == -1
            and GoodType ~= Goods.G_Gold then
                XGUIEng.ShowWidget("/InGame/Root/Normal/AlignBottomRight/DialogButtons/MerchantCart/SendBack", 1)
            else
                XGUIEng.ShowWidget("/InGame/Root/Normal/AlignBottomRight/DialogButtons/MerchantCart/SendBack", 0)
            end

        
        elseif Logic.IsWall(EntityID) == true or Logic.IsGate(EntityID) == true then

            XGUIEng.ShowWidget("/InGame/Root/Normal/AlignBottomRight/Selection",1)
            XGUIEng.ShowAllSubWidgets("/InGame/Root/Normal/AlignBottomRight/Selection",0)
            XGUIEng.ShowWidget("/InGame/Root/Normal/AlignBottomRight/DialogButtons",0)

            XGUIEng.ShowWidget("/InGame/Root/Normal/BuildingButtons",1)
            XGUIEng.ShowAllSubWidgets("/InGame/Root/Normal/BuildingButtons",1)
            XGUIEng.ShowWidget("/InGame/Root/Normal/AlignBottomRight/Selection/BuildingButtonsPositionUpdater",1)

            if Logic.IsEntityInCategory(EntityID,EntityCategories.Turret) == 1 then

                --select weapon if he has one
                -- TODO: we assume that there is only one wepapon slot
                local WeaponID = Logic.GetAutomaticWeapon(EntityID, 0)
                if WeaponID ~= 0 then
                    GUI.SetSelectedEntity(WeaponID)
                end
            end

--            local Trap = Logic.GetTrap(EntityID)
--
--            if Trap ~= nil
--            and Trap ~= 0 then
--                GUI.SetSelectedEntity(Trap)
--            end
        elseif Logic.IsSettler(EntityID) == 1 then
            XGUIEng.ShowWidget("/InGame/Root/Normal/AlignBottomRight/Selection",1)
            XGUIEng.ShowAllSubWidgets("/InGame/Root/Normal/AlignBottomRight/Selection",0)
            XGUIEng.ShowWidget("/InGame/Root/Normal/AlignBottomRight/Selection/Info",1)
            XGUIEng.ShowWidget("/InGame/Root/Normal/AlignBottomRight/Selection/Settler",1)

            PlaySettlersVoice(EntityID)

            if (Logic.IsWorker(EntityID) == 1
            or Logic.IsSpouse(EntityID) == true)
            and EntityType ~= Entities.U_OutpostConstructionWorker
            and EntityType ~= Entities.U_WallConstructionWorker
            and Logic.GetSettlersWorkBuilding(EntityID) ~= 0 then

                XGUIEng.ShowWidget("/InGame/Root/Normal/AlignBottomRight/DialogButtons",1)
                XGUIEng.ShowAllSubWidgets("/InGame/Root/Normal/AlignBottomRight/DialogButtons",0)
                XGUIEng.ShowWidget("/InGame/Root/Normal/AlignBottomRight/DialogButtons/Building",1)

                XGUIEng.ShowWidget("/InGame/Root/Normal/AlignBottomRight/Selection/Needs",1)

                --different layouts
                local BuildingID = Logic.GetSettlersWorkBuilding(EntityID)

                if Logic.IsEntityInCategory(BuildingID, EntityCategories.OuterRimBuilding) == 1 then
                    XGUIEng.ShowAllSubWidgets("/InGame/Root/Normal/AlignBottomRight/Selection/Needs",0)
                    XGUIEng.ShowWidget("/InGame/Root/Normal/AlignBottomRight/Selection/Needs/BGOuterRim", 1)
                    XGUIEng.ShowWidget("/InGame/Root/Normal/AlignBottomRight/Selection/Needs/CaptionNeeds", 1)
                    XGUIEng.ShowWidget("/InGame/Root/Normal/AlignBottomRight/Selection/Needs/Nutrition", 1)
                    XGUIEng.ShowWidget("/InGame/Root/Normal/AlignBottomRight/Selection/Needs/BGCity",0)

                    XGUIEng.ShowWidget("/InGame/Root/Normal/AlignBottomRight/Selection/BGMedium",1)

                    local AnchorNeedsForMediumX, AnchorNeedsForMediumY = XGUIEng.GetWidgetLocalPosition("/InGame/Root/Normal/AlignBottomRight/Selection/AnchorNeedsForMedium")
                    XGUIEng.SetWidgetLocalPosition("/InGame/Root/Normal/AlignBottomRight/Selection/Needs", AnchorNeedsForMediumX, AnchorNeedsForMediumY)

                    local AnchorInfoForMediumX, AnchorInfoForMediumY = XGUIEng.GetWidgetLocalPosition("/InGame/Root/Normal/AlignBottomRight/Selection/AnchorInfoForMedium")
                    XGUIEng.SetWidgetLocalPosition("/InGame/Root/Normal/AlignBottomRight/Selection/Info", AnchorInfoForMediumX, AnchorInfoForMediumY)

                    local AnchorBusinessAndSettlerForMediumX, AnchorBusinessAndSettlerForMediumY = XGUIEng.GetWidgetLocalPosition("/InGame/Root/Normal/AlignBottomRight/Selection/AnchorBusinessAndSettlerForMedium")
                    XGUIEng.SetWidgetLocalPosition("/InGame/Root/Normal/AlignBottomRight/Selection/Settler", AnchorBusinessAndSettlerForMediumX, AnchorBusinessAndSettlerForMediumY)
                else
                    XGUIEng.ShowAllSubWidgets("/InGame/Root/Normal/AlignBottomRight/Selection/Needs",1)
                    XGUIEng.ShowWidget("/InGame/Root/Normal/AlignBottomRight/Selection/Needs/BGOuterRim", 0)

                    XGUIEng.ShowWidget("/InGame/Root/Normal/AlignBottomRight/Selection/BGBig", 1)

                    local AnchorNeedsForBigX, AnchorNeedsForBigY = XGUIEng.GetWidgetLocalPosition("/InGame/Root/Normal/AlignBottomRight/Selection/AnchorNeedsForBig")
                    XGUIEng.SetWidgetLocalPosition("/InGame/Root/Normal/AlignBottomRight/Selection/Needs", AnchorNeedsForBigX, AnchorNeedsForBigY)

                    local AnchorInfoForBigX, AnchorInfoForBigY = XGUIEng.GetWidgetLocalPosition("/InGame/Root/Normal/AlignBottomRight/Selection/AnchorInfoForBig")
                    XGUIEng.SetWidgetLocalPosition("/InGame/Root/Normal/AlignBottomRight/Selection/Info", AnchorInfoForBigX, AnchorInfoForBigY)

                    local AnchorBusinessAndSettlerForBigX, AnchorBusinessAndSettlerForBigY = XGUIEng.GetWidgetLocalPosition("/InGame/Root/Normal/AlignBottomRight/Selection/AnchorBusinessAndSettlerForBig")
                    XGUIEng.SetWidgetLocalPosition("/InGame/Root/Normal/AlignBottomRight/Selection/Settler", AnchorBusinessAndSettlerForBigX, AnchorBusinessAndSettlerForBigY)
                end
            else
                XGUIEng.ShowWidget("/InGame/Root/Normal/AlignBottomRight/Selection/BGSmall",1)
                XGUIEng.ShowWidget("/InGame/Root/Normal/AlignBottomRight/DialogButtons",1)
                XGUIEng.ShowAllSubWidgets("/InGame/Root/Normal/AlignBottomRight/DialogButtons",0)

                if EntityType == Entities.U_Priest then
                    XGUIEng.ShowWidget("/InGame/Root/Normal/AlignBottomRight/DialogButtons/Building",1)
                end

                local AnchorInfoForSmallX, AnchorInfoForSmallY = XGUIEng.GetWidgetLocalPosition("/InGame/Root/Normal/AlignBottomRight/Selection/AnchorInfoForSmall")
                XGUIEng.SetWidgetLocalPosition("/InGame/Root/Normal/AlignBottomRight/Selection/Info", AnchorInfoForSmallX, AnchorInfoForSmallY)

                local AnchorBusinessAndSettlerForSmallX, AnchorBusinessAndSettlerForSmallY = XGUIEng.GetWidgetLocalPosition("/InGame/Root/Normal/AlignBottomRight/Selection/AnchorBusinessAndSettlerForSmall")
                XGUIEng.SetWidgetLocalPosition("/InGame/Root/Normal/AlignBottomRight/Selection/Settler", AnchorBusinessAndSettlerForSmallX, AnchorBusinessAndSettlerForSmallY)
            end
        end
    else
        XGUIEng.ShowWidget("/InGame/Root/Normal/AlignBottomRight/Selection",0)
        XGUIEng.ShowWidget("/InGame/Root/Normal/AlignBottomRight/SalesDialog",0)
        XGUIEng.ShowWidget("/InGame/Root/Normal/BuildingButtons",0)
        XGUIEng.ShowWidget("/InGame/Root/Normal/AlignBottomRight/KnightTitleMenu",0)
        XGUIEng.ShowWidget("/InGame/Root/Normal/AlignTopCenter/KnightTitleMenuBig",0)
        XGUIEng.ShowWidget("/InGame/Root/Normal/AlignBottomRight/DialogButtons",0)

        --clear the multi selection
        if _Source ~= g_SelectionChangedSource.Script then
            GUI_MultiSelection.CreateEX()
        end
    end

    if SoundToPlay ~= ""
    and _Source == g_SelectionChangedSource.User then
        Sound.FXPlay2DSound( SoundToPlay )
    end

end


------------------------------------------------------------------------------------------------

--StateInitialized = false
--PlaceBuildingStateActivated = false

function GameCallback_GUI_StateChanged( _StateNameID, _Armed )

    if _StateNameID == GUI.GetStateNameByID( "PlaceWall" )
    or _StateNameID == GUI.GetStateNameByID( "PlaceWallGate" )
    or _StateNameID == GUI.GetStateNameByID( "PlaceBuilding" )
    or _StateNameID == GUI.GetStateNameByID( "PlaceRoad" ) then
        --PlaceBuildingStateActivated = true
    else
        --PlaceBuildingStateActivated = false
    end

    if _StateNameID == GUI.GetStateNameByID( "Selection" ) then
        XGUIEng.UnHighLightGroup("/InGame", "Construction")
    end

    if _Armed == 1 then
        if g_CloseUpView.Active == true then
            --SetBackCloseUpView()
        end
    end
end

------------------------------------------------------------------------------------------------

function GUI_Selection.AddGroupToSelection(_GroupID)

    if GUI.GetSelectionGroupSize(_GroupID) > 0 then

        local SelectedEntities = { GUI.GetSelectedEntities() }

        GUI.RestoreSelectionGroup(_GroupID)

        for i = 1, #SelectedEntities do
            GUI.SelectEntity(SelectedEntities[i])
        end
        GUI_MultiSelection.CreateMultiSelection(g_SelectionChangedSource.User)
    end
end

------------------------------------------------------------------------------------------------

function GUI_Selection.SelectionGroupClicked(_GroupID)

    -- select
    local GroupSize = GUI.GetSelectionGroupSize(_GroupID)

    if (GroupSize > 0) then
        if XGUIEng.IsModifierPressed(Keys.ModifierControl) then
            GUI_MultiSelection.StoreSelectionGroup(_GroupID)
        elseif XGUIEng.IsModifierPressed(Keys.ModifierShift) then
            GUI_Selection.AddGroupToSelection(_GroupID)
        else
            GUI_Selection.ActivateSelectionGroup(_GroupID)
        end
    else
        GUI_MultiSelection.StoreSelectionGroup(_GroupID)
    end
end

------------------------------------------------------------------------------------------------

function GUI_Selection.SelectionGroupUpdate(_GroupID)

    local X,Y = XGUIEng.GetWidgetLocalPosition(XGUIEng.GetCurrentWidgetID())

    local GroupSize = GUI.GetSelectionGroupSize(_GroupID)
    if (GroupSize > 0) then
        XGUIEng.SetWidgetLocalPosition(XGUIEng.GetCurrentWidgetID(), X, 20)
    else
        XGUIEng.SetWidgetLocalPosition(XGUIEng.GetCurrentWidgetID(), X, 0)
    end
end

------------------------------------------------------------------------------------------------

function GUI_Selection.ActivateSelectionGroup(_GroupID)

    -- check if the group has member
    if GUI.GetSelectionGroupSize(_GroupID) <= 0 then
        return
    end

    -- restore the selection group
    GUI.RestoreSelectionGroup(_GroupID)

    --update the Multiselection
    GUI_MultiSelection.CreateEX()

    -- fake double click
    if  _GroupID == g_Selection.LastSelectionGroup and
        (Framework.GetTimeMs() - g_Selection.LastClickTime) < g_Selection.MaxDoubleClickTime then

        -- yes, jump to first entity of the selection
        local EntityID = GUI.GetSelectedEntity()

        if (EntityID ~= 0) then
            local EntityPosition = GetPosition(EntityID)
            Camera.RTS_SetLookAtPosition(EntityPosition.X, EntityPosition.Y)
        end
    end

    -- update the last click time
    g_Selection.LastClickTime = Framework.GetTimeMs()
    g_Selection.LastSelectionGroup = _GroupID

end
