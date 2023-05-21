

GUI_Construction = {}

g_Construction = {}


--[[ Type_Road = 1,
Type_Building = 2,
Type_Wall = 3,
Type_WallGate = 4 ]]

function g_Construction.IsPlacingRoad()
    
    if g_Construction.CurrentPlacementType == nil then
    
        return false
    
    end
    
    return g_Construction.CurrentPlacementType == 1
    
end

function g_Construction.ClearCurrentPlacementType()
    g_Construction.CurrentPlacementType = nil
end

function CanPlaceByCosts(_BuildingType)
    local AmountOfTypes, FirstBuildingType = Logic.GetBuildingTypesInUpgradeCategory(_BuildingType)
    return AreCostsAffordable({Logic.GetEntityTypeFullCost(FirstBuildingType)})
end


function GameCallback_GUI_DeleteEntityStateBuilding(_BuildingID, _State)
    -- Note: The state is 1 if demolition is ordered, 0 if canceled
    -- this Callback isn't called when the KnockDown click fails

    if _State == 1 then
        Sound.FXPlay2DSound( "ui\\menu_right_knock_down")
    else
        Sound.FXPlay2DSound( "ui\\menu_click")
    end
end


function GameCallback_GUI_DeleteStateInvalidClick()
    
    local BuildingID = GUI.GetMouseOverEntity()

    if Logic.IsBuilding(BuildingID) == 1 then
        local BuildingPlayerID = Logic.EntityGetPlayer(BuildingID)

        if BuildingPlayerID == GUI.GetPlayerID() then
            if g_NoKnockDownDueToStrikeEntity == BuildingID
            and g_NoKnockDownDueToStrikeTime > Logic.GetTime() - 5 then
                local Text = XGUIEng.GetStringTableText("Feedback_TextLines/TextLine_KnockDownStriking")
                Message(Text)
            end
        end
    end
end


function GameCallback_Feedback_NoKnockDownDueToStrike(_PlayerID, _EntityID)

    if _PlayerID == GUI.GetPlayerID() then
        g_NoKnockDownDueToStrikeTime = Logic.GetTime()
        g_NoKnockDownDueToStrikeEntity = _EntityID
    end
end





-- M = click message, T = hovering text
-- PlacementStateBlocked                M
-- PlacementStateBuildingBaseOccupied
-- PlacementStateCostCheckFailed        M
-- PlacementStateDirectLinkExists       ->Blocked
-- PlacementStateFogOfWar
-- PlacementStateInfertile              T
-- PlacementStateOK
-- PlacementStateOtherRoad              ->Blocked
-- PlacementStateRoadTooShort
-- PlacementStateTooSteep               T
-- PlacementStateTurretTypeMismatch
-- PlacementStateTurretsTooClose
-- PlacementStateUnknownProblem
-- PlacementStateUnreachable            T
-- PlacementStateUnreachableFromKeep    T
-- PlacementStateWrongBuildingBase
-- PlacementStateWrongCityLevel
-- PlacementStateWrongTerrain
-- PlacementStateWrongTerritory         T
-- PlacementStateMiddleTurretInvalid    ->Blocked


function GameCallback_GUI_PlacementState(_State, _Type)
    -- Note: do _not_ use PlacementStates.PlacementStateOK. It's 0, but
    -- because 0 is "invalid ID" for exported ID managers, something tried
    -- to be clever and added PlacementStateOK at the end of the IDs. Using
    -- it _will_ lead to wrong results.

    PlacementState = _State

    g_Construction.CurrentPlacementType = _Type
    
    
    
    -- debug information
    if Debug_EnableDebugOutput then
        local Text = GetNameOfKeyInTable(PlacementStates, PlacementState)
        GUI.AddNote(Text)
        
        if _Type ~= nil then
            GUI.AddNote("Placing type: " .. _Type)
        end
    
    end
end


-- while hovering in build mode, display text for WrongTerritory, Unreachable / UnreachableFromKeep, TooSteep, Infertile
function GUI_Construction.PlacementUpdate()

    local TerritoryName = ""
    local TerritoryNameColor = ""
    local TerritoryReason = ""
    local OtherReason = ""

    if PlacementState == PlacementStates.PlacementStateWrongTerritory then
        local PlayerID = GUI.GetPlayerID()
        local TerritoryPlayerID
        local x,y = GUI.Debug_GetMapPositionUnderMouse()
        local TerritoryID
        local FoWState

        if x ~= -1 then
            TerritoryID = Logic.GetTerritoryAtPosition(x,y)
            FoWState = Logic.GetFoWState(PlayerID, x, y)

            if TerritoryID ~= nil then
                TerritoryName = GetTerritoryName(TerritoryID)
                TerritoryPlayerID = Logic.GetTerritoryPlayerID(TerritoryID)
            end
        end
        
        

        -- map border
        if TerritoryID == 0 then
            TerritoryName = ""

        -- undiscovered territory
        elseif FoWState == 0 then
            TerritoryName = XGUIEng.GetStringTableText("UI_Texts/TerritoryNotDiscoveredYet_Capitalized")

        -- neutral territory
        elseif TerritoryPlayerID == 0 then
            TerritoryNameColor = "{@color:255,255,255,255}"
            --TerritoryReason = "Claim neutral Territories with the Knight"
            TerritoryReason = XGUIEng.GetStringTableText("UI_Texts/PlacementNotPossible_WrongTerritory_Neutral")

        else
            local R, G, B = GUI.GetPlayerColor(TerritoryPlayerID)
            TerritoryNameColor = "{@color:" .. R .. ",".. G ..",".. B .. ",255}"

            
            
            -- this case comes when trying to place an Outpost on an own territory
            if TerritoryPlayerID == PlayerID then
                if not g_Construction.IsPlacingRoad() then 
                    TerritoryReason = XGUIEng.GetStringTableText("UI_Texts/PlacementNotPossible_WrongTerritory_Own")
                else
                    TerritoryNameColor = ""
                    TerritoryName = ""
                end
            -- other player's territory
            else
                TerritoryReason = XGUIEng.GetStringTableText("UI_Texts/PlacementNotPossible_WrongTerritory_OtherFaction")
            end
        end

    elseif PlacementState == PlacementStates.PlacementStateUnreachable then
        OtherReason = XGUIEng.GetStringTableText("UI_Texts/PlacementNotPossible_Unreachable")

    elseif PlacementState == PlacementStates.PlacementStateUnreachableFromKeep then
        OtherReason = XGUIEng.GetStringTableText("UI_Texts/PlacementNotPossible_UnreachableFromKeep")

    elseif PlacementState == PlacementStates.PlacementStateTooSteep then
        OtherReason = XGUIEng.GetStringTableText("UI_Texts/PlacementNotPossible_TooSteep")

    elseif PlacementState == PlacementStates.PlacementStateInfertile then
        OtherReason = XGUIEng.GetStringTableText("UI_Texts/PlacementNotPossible_Infertile")
    end

    XGUIEng.SetText("/Ingame/Root/Normal/PlacementStatus/TerritoryName0", "{center}" .. TerritoryNameColor .. TerritoryName)

    for i = 1, 3 do
        XGUIEng.SetText("/Ingame/Root/Normal/PlacementStatus/TerritoryName" .. i, "{center}" .. TerritoryName)
        XGUIEng.SetText("/Ingame/Root/Normal/PlacementStatus/TerritoryReason" .. i, "{center}" .. TerritoryReason)
        --XGUIEng.SetText("/Ingame/Root/Normal/PlacementStatus/OtherReason" .. i, "{center}" .. OtherReason)
        XGUIEng.SetText("/Ingame/Root/Normal/PlacementStatus/OtherReason" .. i, "{center}" .. "")
    end

    if OtherReason ~= "" then
        local ContainerWidget = "/InGame/Root/Normal/TextMessages/MessageContainer"

        for i = 1, 4 do
            XGUIEng.SetText(ContainerWidget .. "/Message" .. i, "{center}" .. OtherReason)
        end

        XGUIEng.ShowWidget(ContainerWidget, 1)
        g_MessageTime = Framework.GetTimeMs() - 4000
    end
end


-- on "failed" clicks, display messages for Blocked, CostCheckFailed; DirectLinkExists and OtherRoad are like Blocked
function GameCallback_GUI_AfterWallPlacementFailed(_SegmentType, _TurretType)

    local Costs = {Logic.GetCostForWall(_SegmentType, _TurretType, StartTurretX, StartTurretY, EndTurretX, EndTurretY)}
    GUI_Construction.PlacementFailed(Costs)
end


function GameCallback_GUI_AfterWallGatePlacement_Failed()

    --currently there's no way to get costs
    GUI_Construction.PlacementFailed(nil)
end


function GameCallback_GUI_AfterRoadPlacementFailed(_Length)
    local Meters = _Length / 100
    local MetersPerUnit = Logic.GetRoadMetersPerRoadUnit()
    local Costs = {Logic.GetRoadCostPerRoadUnit()}

    -- round
    for i = 2, table.getn(Costs), 2 do
        Costs[i] = math.ceil(Costs[i] * (Meters / MetersPerUnit))

        if Costs[i] == 0 then
            Costs[i] = 1
        end
    end

    GUI_Construction.PlacementFailed(Costs)
end

function GameCallback_GUI_AfterRoadStartFailed()
    GUI_Construction.PlacementFailed()
end

function GameCallback_GUI_AfterBuildingPlacementFailed()

    -- since being in PlaceBuilding mode and then having not enough resources is a super-rare case, it's sufficient
    -- to unspecifically say "no resources"
    GUI_Construction.PlacementFailed(nil)
end


function GUI_Construction.PlacementFailed(_Costs)

    if PlacementState == PlacementStates.PlacementStateBlocked
    or PlacementState == PlacementStates.PlacementStateDirectLinkExists
    or PlacementState == PlacementStates.PlacementStateMiddleTurretInvalid
    or PlacementState == PlacementStates.PlacementStateOtherRoad then
        local Text = XGUIEng.GetStringTableText("Feedback_TextLines/TextLine_PlacementStateBlocked")
        Message(Text)

    elseif PlacementState == PlacementStates.PlacementStateCostCheckFailed then

        if _Costs ~= nil then
            local CanBuyBoolean, CanNotBuyString = AreCostsAffordable(_Costs)

            if CanBuyBoolean == false then
                Message(CanNotBuyString)
            end
        else
            local CanNotBuyStringTableText = XGUIEng.GetStringTableText("Feedback_TextLines/TextLine_NotEnough_Resources")
            Message(CanNotBuyStringTableText)
        end

    -- if there's no Message() because there's a hovering text, still play the sound
    else
        Sound.FXPlay2DSound( "ui\\menu_click_negative")
    end
end


----

function GUI_Construction.TestSettlerLimit(_BuildingType)--return true if can construct, false if can't construct because of settlerlimit
    local PlayerID = GUI.GetPlayerID()

    -- check for settlers limit, but not for these buildings:
    if _BuildingType == UpgradeCategories.GrainField_MiddleEurope
    or _BuildingType == UpgradeCategories.GrainField_NorthAfrica
    or _BuildingType == UpgradeCategories.GrainField_NorthEurope
    or _BuildingType == UpgradeCategories.GrainField_SouthEurope

    or _BuildingType == UpgradeCategories.BeeHive
    or _BuildingType == UpgradeCategories.CattlePasture
    or _BuildingType == UpgradeCategories.SheepPasture

    or _BuildingType == UpgradeCategories.Outpost_MiddleEurope
    or _BuildingType == UpgradeCategories.Outpost_NorthAfrica
    or _BuildingType == UpgradeCategories.Outpost_NorthEurope
    or _BuildingType == UpgradeCategories.Outpost_SouthEurope

    or _BuildingType == UpgradeCategories.SpecialEdition_Column
    or _BuildingType == UpgradeCategories.SpecialEdition_Pavilion
    or _BuildingType == UpgradeCategories.SpecialEdition_StatueDario
    or _BuildingType == UpgradeCategories.SpecialEdition_StatueFamily
    or _BuildingType == UpgradeCategories.SpecialEdition_StatueProduction
    or _BuildingType == UpgradeCategories.SpecialEdition_StatueSettler
    
    then

        return true

    elseif Logic.GetNumberOfEmployedWorkers(PlayerID) >= Logic.GetMaxNumberOfEmployedWorkers(PlayerID) then
        local MessageText = XGUIEng.GetStringTableText("Feedback_TextLines/TextLine_SettlerLimitReached")
        Message(MessageText)
        return false        
    end

    return true

end

function GUI_Construction.BuildClicked(_BuildingType)
    PlacementState = 0

    XGUIEng.UnHighLightGroup("/InGame", "Construction")

    if not GUI_Construction.TestSettlerLimit(_BuildingType) then
        return
    end

    local CanPlace, CanNotPlaceString = CanPlaceByCosts(_BuildingType)

    if CanPlace == false then
        Message(CanNotPlaceString)
    else
        Sound.FXPlay2DSound( "ui\\menu_select")
        GUI.CancelState()

        GUI.ActivatePlaceBuildingState(_BuildingType)

        XGUIEng.ShowWidget("/Ingame/Root/Normal/PlacementStatus",1)
        GUI_Construction.CloseContextSensitiveMenu()

        -- save last placement
        g_LastPlacedParam = _BuildingType
        g_LastPlacedFunction = GUI_Construction.BuildClicked

        -- tell the tutorial, that this button has been pressed by the player
        if XGUIEng.GetCurrentWidgetID() ~= 0 then
            SaveButtonPressed(XGUIEng.GetCurrentWidgetID())
        end
    end
end


function GUI_Construction.BuildUpdate(_TechnologyType, _BuildingsMenuBool)
    local CurrentWidgetID = XGUIEng.GetCurrentWidgetID()
    local IsHighLighted = XGUIEng.IsButtonHighLighted(CurrentWidgetID)

    local PlayerID = GUI.GetPlayerID()

    if _TechnologyType == nil then
        _TechnologyType = 0
    end

    -- if no right system: enable widget
    if EnableRights ~= true then
        -- don't show statues in Demo
        if Framework.CheckIDV() == true
        and _TechnologyType == Technologies.R_SpecialEdition then
            XGUIEng.ShowWidget(CurrentWidgetID, 0)
            return
        end

        XGUIEng.DisableButton(CurrentWidgetID, 0)

        if IsHighLighted == 1 then
            XGUIEng.HighLightButton(CurrentWidgetID, 1)
        end

        return
    end

    -- nil, true: ok, false: hide widget
    if Activated[_TechnologyType] == false then
        XGUIEng.ShowWidget(CurrentWidgetID, 0)
        return
    end

    -- if technology is locked: hide widget
    if _TechnologyType ~= 0 and Logic.TechnologyGetState(PlayerID, _TechnologyType) == TechnologyStates.Locked then
        if _BuildingsMenuBool ~= true then
            XGUIEng.ShowWidget(CurrentWidgetID, 0)
        else
            XGUIEng.ShowWidget(XGUIEng.GetWidgetsMotherID(CurrentWidgetID), 0)
        end
        return
    end

    -- if technology is researched: enable widget
    local DisableButton = 1
    if _TechnologyType ~= 0 and Logic.TechnologyGetState(PlayerID, _TechnologyType) == TechnologyStates.Researched then
        DisableButton = 0
    end

    XGUIEng.DisableButton(CurrentWidgetID, DisableButton)

    -- this hack is necessary because DisableButton(X, 0) sets a button to normal
    if IsHighLighted == 1 then
        XGUIEng.HighLightButton(CurrentWidgetID, 1)
    end
end


function GUI_Construction.RefreshBuildingButtons()
    XGUIEng.ShowAllSubWidgets("/InGame/Root/Normal/BuildingButtons", 1)

    -- categories
    XGUIEng.ShowAllSubWidgets("/InGame/Root/Normal/AlignBottomRight/BuildMenu/Categories", 1)

    -- sub menus
    XGUIEng.ShowAllSubWidgets("/InGame/Root/Normal/AlignBottomRight/BuildMenu/SubMenus/Entertainment/Buttons", 1)
    XGUIEng.ShowAllSubWidgets("/InGame/Root/Normal/AlignBottomRight/BuildMenu/SubMenus/Security/Buttons", 1)
    XGUIEng.ShowAllSubWidgets("/InGame/Root/Normal/AlignBottomRight/BuildMenu/SubMenus/Wealth/Buttons", 1)
    XGUIEng.ShowAllSubWidgets("/InGame/Root/Normal/AlignBottomRight/BuildMenu/SubMenus/Cleanliness/Buttons", 1)
    XGUIEng.ShowAllSubWidgets("/InGame/Root/Normal/AlignBottomRight/BuildMenu/SubMenus/Clothes/Buttons", 1)
    XGUIEng.ShowAllSubWidgets("/InGame/Root/Normal/AlignBottomRight/BuildMenu/SubMenus/Food/Buttons", 1)
    XGUIEng.ShowAllSubWidgets("/InGame/Root/Normal/AlignBottomRight/BuildMenu/SubMenus/Gatherer/Buttons", 1)
    XGUIEng.ShowAllSubWidgets("/InGame/Root/Normal/AlignBottomRight/BuildMenu/SubMenus/Construction/Buttons", 1)
    
    --XGUIEng.ShowAllSubWidgets("/InGame/Root/Normal/AlignBottomRight/BuildMenu/SubMenus/SpecialEdition/Buttons", 1)
    

    -- special edition
    if EnableRights ~= true or Activated[Technologies.R_SpecialEdition] == true then
        XGUIEng.ShowWidget("/InGame/Root/Normal/AlignBottomRight/BuildMenu/BG", 0)
        XGUIEng.ShowWidget("/InGame/Root/Normal/AlignBottomRight/BuildMenu/BG_SE", 1)
    else
        XGUIEng.ShowWidget("/InGame/Root/Normal/AlignBottomRight/BuildMenu/BG", 1)
        XGUIEng.ShowWidget("/InGame/Root/Normal/AlignBottomRight/BuildMenu/BG_SE", 0)
    end

    XGUIEng.ShowWidget("/InGame/Root/Normal/AlignBottomRight/BuildMenu/SubMenus/Construction/BG", 1)
    XGUIEng.ShowWidget("/InGame/Root/Normal/AlignBottomRight/BuildMenu/SubMenus/Construction/BG_EX", 0)
    XGUIEng.ShowWidget("/InGame/Root/Normal/AlignBottomRight/BuildMenu/SubMenus/Construction/Buttons/B_Cistern", 0)
    
    -- production menu
    XGUIEng.ShowAllSubWidgets("/InGame/Root/Normal/AlignBottomRight/HouseMenu/Dialog/City", 1)
    XGUIEng.ShowAllSubWidgets("/InGame/Root/Normal/AlignBottomRight/HouseMenu/Dialog/OuterRim", 1)
    XGUIEng.ShowAllSubWidgets("/InGame/Root/Normal/AlignBottomRight/HouseMenu/Dialog/Special", 1)
end

function GUI_Construction.HideMissionCDWidgets(_WidgetName)

    if _WidgetName == "SpecialEdition" then
        XGUIEng.ShowWidget("/InGame/Root/Normal/AlignBottomRight/BuildMenu/SubMenus/SpecialEdition/BGVert", 0)
        XGUIEng.ShowWidget("/InGame/Root/Normal/AlignBottomRight/BuildMenu/SubMenus/SpecialEdition/BGVert (1)", 0)
        XGUIEng.ShowWidget("/InGame/Root/Normal/AlignBottomRight/BuildMenu/SubMenus/SpecialEdition/BGVert (2)", 0)
        XGUIEng.ShowWidget("/InGame/Root/Normal/AlignBottomRight/BuildMenu/SubMenus/SpecialEdition/ButtonsAddon", 0)
    end
end

function GUI_Construction.CategoryClicked()
    local CurrentWidgetID = XGUIEng.GetCurrentWidgetID()

    local WidgetName = XGUIEng.GetWidgetNameByID(CurrentWidgetID)
    
    local MenuToOpen = "/InGame/Root/Normal/AlignBottomRight/BuildMenu/SubMenus/" .. WidgetName

    if XGUIEng.IsWidgetShown(MenuToOpen) == 1 then
        Sound.FXPlay2DSound("ui\\menu_close")
        XGUIEng.ShowWidget(MenuToOpen, 0)
        XGUIEng.HighLightButton(CurrentWidgetID, 0)
        XGUIEng.SetButtonState(CurrentWidgetID, 2, 0)
    else
        HideOtherMenus()

        XGUIEng.HighLightButton(CurrentWidgetID, 1)

        Sound.FXPlay2DSound("ui\\menu_open")
        XGUIEng.ShowAllSubWidgets("/InGame/Root/Normal/AlignBottomRight/BuildMenu/SubMenus", 0)
        XGUIEng.ShowWidget(MenuToOpen, 1)

        -- tell the tutorial, that this button has been pressed by the player
        SaveButtonPressed(XGUIEng.GetCurrentWidgetID())
        
        GUI_Construction.HideMissionCDWidgets(WidgetName)
        
    end
end


function GUI_Construction.CloseContextSensitiveMenu()
    XGUIEng.ShowAllSubWidgets("/InGame/Root/Normal/AlignBottomRight/BuildMenu/SubMenus",0)
    XGUIEng.UnHighLightGroup("/InGame", "MenuButtons")
end

------------------------------------------------------------------------------------------------

function GUI_Construction.BuildStreetClicked(_IsTrail)
    Sound.FXPlay2DSound( "ui\\menu_select")

    PlacementState = 0

    GUI.CancelState()
    GUI.ClearSelection()

    if _IsTrail == nil then
        _IsTrail = false
    end

    GUI.ActivatePlaceRoadState(_IsTrail)

    XGUIEng.ShowWidget("/Ingame/Root/Normal/PlacementStatus", 1)
    GUI_Construction.CloseContextSensitiveMenu()

    -- save last placement
    g_LastPlacedParam = _IsTrail
    g_LastPlacedFunction = GUI_Construction.BuildStreetClicked
end

------------------------------------------------------------------------------------------------

function GUI_Construction.BuildWallClicked(_BuildingType)
    Sound.FXPlay2DSound( "ui\\menu_select")

    PlacementState = 0

    if _BuildingType == nil then
        _BuildingType = GetUpgradeCategoryForClimatezone("WallSegment")
    end

    GUI.CancelState()
    GUI.ClearSelection()

    GUI.ActivatePlaceWallState(_BuildingType)

    XGUIEng.ShowWidget("/Ingame/Root/Normal/PlacementStatus", 1)
    GUI_Construction.CloseContextSensitiveMenu()

    -- save last placement
    g_LastPlacedParam = _BuildingType
    g_LastPlacedFunction = GUI_Construction.BuildWallClicked
end

-------------------------------------------------------------------------------
function GUI_Construction.BuildWallGateClicked(_BuildingType)
    PlacementState = 0

    if _BuildingType == nil then
        _BuildingType = GetUpgradeCategoryForClimatezone("WallGate")
    end

    local CanPlace, CanNotPlaceString = CanPlaceByCosts(_BuildingType)

    if CanPlace == false then
        Message(CanNotPlaceString)
    else
        Sound.FXPlay2DSound( "ui\\menu_select")

        GUI.CancelState()
        GUI.ClearSelection()

        GUI.ActivatePlaceWallGateState(_BuildingType)

        XGUIEng.ShowWidget("/Ingame/Root/Normal/PlacementStatus", 1)
        GUI_Construction.CloseContextSensitiveMenu()

        -- save last placement
        g_LastPlacedParam = _BuildingType
        g_LastPlacedFunction = GUI_Construction.BuildWallGateClicked
    end
end

------------------------------------------------------------------------------------------------

function GUI_Construction.BuildNPCWallClicked()
    GUI_Construction.BuildWallClicked(GetUpgradeCategoryForClimatezone("WallSegment_NPC"))
end

function GUI_Construction.BuildKnightStatueClicked()
    local KnightId = Logic.GetKnightID(GUI.GetPlayerID())
    if KnightId ~= nil then
        local KnightType = Logic.GetEntityTypeName(Logic.GetEntityType(KnightId))
        local UpgradeCategoryName = "Beautification_" ..KnightType
        local UpgradeCategory = UpgradeCategories[UpgradeCategoryName]
    
        GUI_Construction.BuildClicked(UpgradeCategory)
    else
        GUI_Construction.BuildClicked(UpgradeCategories.Beautification_U_KnightGeneric)
    end
end

function GUI_Construction.BuildPlazaClicked()
    local buildingType = GetUpgradeCategoryForClimatezone("Beautification_Plaza")
    PlacementState = 0

    XGUIEng.UnHighLightGroup("/InGame", "Construction")

    if not GUI_Construction.TestSettlerLimit(buildingType) then
        return
    end

    local CanPlace, CanNotPlaceString = CanPlaceByCosts(buildingType)

    if CanPlace == false then
        Message(CanNotPlaceString)
    else
        Sound.FXPlay2DSound( "ui\\menu_select")
        GUI.CancelState()

        GUI.ActivatePlaceBuildingState(buildingType)

        XGUIEng.ShowWidget("/Ingame/Root/Normal/PlacementStatus",1)
        GUI_Construction.CloseContextSensitiveMenu()

        -- save last placement
        g_LastPlacedParam = buildingType
        g_LastPlacedFunction = GUI_Construction.BuildClicked

        -- tell the tutorial, that this button has been pressed by the player
        if XGUIEng.GetCurrentWidgetID() ~= 0 then
            SaveButtonPressed(XGUIEng.GetCurrentWidgetID())
        end
    end
end

------------------------------------------------------------------------------------------------

function GUI_Construction.KnockDownClicked()
    Sound.FXPlay2DSound( "ui\\menu_right_knock_down")

    GUI.CancelState()
    GUI.ClearSelection()
    GUI.ActivateDeleteEntityState()

    if XGUIEng.GetCurrentWidgetID() ~= 0 then
        SaveButtonPressed(XGUIEng.GetCurrentWidgetID())
    end

    GUI_Construction.CloseContextSensitiveMenu()
end

------------------------------------------------------------------------------------------------

function GameCallback_GUI_ConstructBuildAbort()
    g_Construction.ClearCurrentPlacementType()
    XGUIEng.ShowWidget("/Ingame/Root/Normal/PlacementStatus", 0)
    XGUIEng.UnHighLightGroup("/InGame", "Construction")
end


function GameCallback_GUI_AfterBuildingPlacement()
    g_Construction.ClearCurrentPlacementType()
    Sound.FXPlay2DSound( "ui\\menu_place_building")
    GUI.CancelState()

    XGUIEng.ShowWidget("/Ingame/Root/Normal/PlacementStatus", 0)

    XGUIEng.UnHighLightGroup("/InGame", "Construction")
end


function GameCallBack_GUI_ConstructWallAbort()
    g_Construction.ClearCurrentPlacementType()
    -- do not cancel the state explicitly within the abort callback. this leads to cancel recursion.
    XGUIEng.ShowWidget("/InGame/Root/Normal/TooltipCostsOnly", 0)
    XGUIEng.ShowWidget("/Ingame/Root/Normal/PlacementStatus", 0)
    XGUIEng.UnHighLightGroup("/InGame", "Construction")
end


function GameCallBack_GUI_ConstructWallSegmentStartTurret(_X, _Y)
    
    StartTurretX = _X
    StartTurretY = _Y
end


function GameCallBack_GUI_ConstructWallSegmentEndTurret(_X, _Y)
    EndTurretX = _X
    EndTurretY = _Y
end


function GameCallBack_GUI_ConstructWallSegmentCountChanged(_SegmentType, _TurretType)

    local Costs = {Logic.GetCostForWall(_SegmentType, _TurretType, StartTurretX, StartTurretY, EndTurretX, EndTurretY)}

    GUI_Tooltip.TooltipCostsOnly(Costs)

    XGUIEng.ShowWidget("/InGame/Root/Normal/TooltipCostsOnly", 1)
end


function GameCallback_GUI_AfterWallPlacement()
    Sound.FXPlay2DSound( "ui\\menu_place_building")
    XGUIEng.ShowWidget("/InGame/Root/Normal/TooltipCostsOnly", 0)
    XGUIEng.ShowWidget("/Ingame/Root/Normal/PlacementStatus", 0)
end


function GameCallback_GUI_AfterRoadPlacement()
    Sound.FXPlay2DSound( "ui\\menu_place_building")
    XGUIEng.ShowWidget("/InGame/Root/Normal/TooltipCostsOnly",0)
    XGUIEng.UnHighLightGroup("/InGame", "Construction")
end


function GameCallBack_GUI_BuildRoadCostChanged(_Length)

    local Meters = _Length / 100
    local MetersPerUnit = Logic.GetRoadMetersPerRoadUnit()
    local Costs = {Logic.GetRoadCostPerRoadUnit()}

    -- round
    for i = 2, table.getn(Costs), 2 do
        Costs[i] = math.ceil(Costs[i] * (Meters / MetersPerUnit))

        if Costs[i] == 0 then
            Costs[i] = 1
        end
    end

    GUI_Tooltip.TooltipCostsOnly(Costs)

    XGUIEng.ShowWidget("/InGame/Root/Normal/TooltipCostsOnly", 1)
end


function GameCallback_GUI_ConstructRoadAbort()
    XGUIEng.ShowWidget("/InGame/Root/Normal/TooltipCostsOnly", 0)
    XGUIEng.ShowWidget("/Ingame/Root/Normal/PlacementStatus", 0)
    XGUIEng.UnHighLightGroup("/InGame", "Construction")
end


function GameCallback_GUI_AfterWallGatePlacement()
    Sound.FXPlay2DSound( "ui\\menu_place_building")
    GUI.CancelState()
    XGUIEng.UnHighLightGroup("/InGame", "Construction")
    XGUIEng.ShowWidget("/Ingame/Root/Normal/PlacementStatus", 0)
end




function GameCallback_GUI_Wall_Started(_PlayerID, _X, _Y)
end

function GameCallback_GUI_Street_Started(_PlayerID, _X, _Y)
end

function GameCallback_Wall_Placed_Local(_PlayerID, _X, _Y)
end

function GameCallback_Street_Placed_Local(_PlayerID, _X, _Y)
end


-- *****************************************************************************
-- Helper
-- *****************************************************************************

function ActivateSpecial(_TechnologyType, _Activate)
    Activated[_TechnologyType] = _Activate
    Activated[Technologies.R_SpecialEdition] = Activated[Technologies.R_SpecialEdition] or _Activate
end

-- *****************************************************************************
-- Initialization
-- *****************************************************************************

function GUI_Construction.Init()
    Activated = {}

    ActivateSpecial(Technologies.R_SpecialEdition_Column,           not Framework.CheckIDV() and IsSpecialEdition())
    ActivateSpecial(Technologies.R_SpecialEdition_Pavilion,         not Framework.CheckIDV() and (IsSpecialEdition() or IsCodeActivated("0025722953")) )
    ActivateSpecial(Technologies.R_SpecialEdition_StatueDario,      not Framework.CheckIDV() and IsSpecialEdition())
    ActivateSpecial(Technologies.R_SpecialEdition_StatueFamily,     not Framework.CheckIDV() and (IsSpecialEdition() or IsCodeActivated("1703848010")) )
    ActivateSpecial(Technologies.R_SpecialEdition_StatueProduction, not Framework.CheckIDV() and IsSpecialEdition())
    ActivateSpecial(Technologies.R_SpecialEdition_StatueSettler,    not Framework.CheckIDV() and IsSpecialEdition())

    GUI_Construction.RefreshBuildingButtons()
end

function GUI_Construction.BuildTowerClicked(_entityType)
    local UCat = GetUpgradeCategoryForClimatezone(_entityType)
    --Logic.DEBUG_AddNote("DEBUG: _widget = " .. _widget .." ; BuildingType = " ..BuildingType)
    
    GUI_Construction.BuildClicked(UCat)
end