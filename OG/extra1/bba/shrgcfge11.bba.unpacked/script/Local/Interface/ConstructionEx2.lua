
g_LastPlacedParam = -1

GUI_Construction.BuildingsWithSkins = {}
GUI_Construction.BuildingsWithSkins[UpgradeCategories.Beautification_Flowerpot_Round] = {
    UpgradeCategories.Beautification_Flowerpot_Round,
    UpgradeCategories.Beautification_Flowerpot_Square
}
GUI_Construction.BuildingsWithSkins[UpgradeCategories.SpecialEdition_StatueDario] = {
    UpgradeCategories.SpecialEdition_StatueDario,
    UpgradeCategories.Beautification_StatueDario
}
GUI_Construction.BuildingsWithSkins[UpgradeCategories.Beautification_BrothersInArms] = {
    UpgradeCategories.Beautification_BrothersInArms,
    UpgradeCategories.Beautification_StatueHorseman
}
GUI_Construction.BuildingsWithSkins[UpgradeCategories.Beautification_Signpost1] = {
    UpgradeCategories.Beautification_Signpost1,
    UpgradeCategories.Beautification_Signpost2,
    UpgradeCategories.Beautification_Signpost3
}
GUI_Construction.BuildingsWithSkins[UpgradeCategories.Beautification_Brazier] = {
    UpgradeCategories.Beautification_Brazier,
    UpgradeCategories.Beautification_Brazier1,
    --UpgradeCategories.Beautification_Brazier2,
    UpgradeCategories.Beautification_Brazier3
}
GUI_Construction.BuildingsWithSkins[UpgradeCategories.Beautification_WoodBench1] = {
    UpgradeCategories.Beautification_WoodBench1,
    UpgradeCategories.Beautification_WoodBench2,
    UpgradeCategories.Beautification_WoodBench3,
    UpgradeCategories.Beautification_WoodBench4,
    UpgradeCategories.Beautification_WoodBench5,
    UpgradeCategories.Beautification_WoodBench6
}
GUI_Construction.BuildingsWithSkins[UpgradeCategories.Beautification_Cart1] = {
    UpgradeCategories.Beautification_Cart1,
    UpgradeCategories.Beautification_Cart2,
    UpgradeCategories.Beautification_Cart3,
    UpgradeCategories.Beautification_Cart4,
    UpgradeCategories.Beautification_Cart5,
    UpgradeCategories.Beautification_Cart6
}
GUI_Construction.BuildingsWithSkins[UpgradeCategories.Beautification_Misc1] = {
    UpgradeCategories.Beautification_Misc1,
    UpgradeCategories.Beautification_Misc2,
    UpgradeCategories.Beautification_Misc3,
    UpgradeCategories.Beautification_Misc4,
    UpgradeCategories.Beautification_Misc5,
    UpgradeCategories.Beautification_Misc6,
    UpgradeCategories.Beautification_Misc7,
    UpgradeCategories.Beautification_Misc8
}
GUI_Construction.BuildingsWithSkins[UpgradeCategories.Beautification_Military1] = {
    UpgradeCategories.Beautification_Military1,
    UpgradeCategories.Beautification_Military2,
    UpgradeCategories.Beautification_Military3,
    UpgradeCategories.Beautification_Military4,
    UpgradeCategories.Beautification_Military5,
    UpgradeCategories.Beautification_Military6,
    UpgradeCategories.Beautification_Military7,
    UpgradeCategories.Beautification_Military8
}
GUI_Construction.BuildingsWithSkins[UpgradeCategories.SpecialEdition_StatueFamily] = {
    UpgradeCategories.SpecialEdition_StatueFamily,
    UpgradeCategories.SpecialEdition_StatueProduction,
    UpgradeCategories.SpecialEdition_StatueSettler
}
GUI_Construction.BuildingsWithSkins[UpgradeCategories.SpecialEdition_Column] = {
    UpgradeCategories.SpecialEdition_Column,
    UpgradeCategories.Beautification_Pillar
}

--don't check settlers limit for these buildings
GUI_Construction.TestSettlerLimitExceptions = {
    UpgradeCategories.GrainField_MiddleEurope,
    UpgradeCategories.GrainField_NorthAfrica,
    UpgradeCategories.GrainField_NorthEurope,
    UpgradeCategories.GrainField_SouthEurope,
    UpgradeCategories.GrainField_Asia,

    UpgradeCategories.BeeHive,
    UpgradeCategories.CattlePasture,
    UpgradeCategories.SheepPasture,
    UpgradeCategories.Cistern,

    UpgradeCategories.Outpost_MiddleEurope,
    UpgradeCategories.Outpost_NorthAfrica,
    UpgradeCategories.Outpost_NorthEurope,
    UpgradeCategories.Outpost_SouthEurope,
    UpgradeCategories.Outpost_Asia,

    UpgradeCategories.SpecialEdition_Column,
    UpgradeCategories.SpecialEdition_StatueFamily,
    UpgradeCategories.SpecialEdition_StatueProduction,
    UpgradeCategories.SpecialEdition_StatueSettler,

    UpgradeCategories.SpecialEdition_StatueDario,
    UpgradeCategories.Beautification_StatueDario,
    UpgradeCategories.SpecialEdition_Pavilion,
    UpgradeCategories.Beautification_Pavilion,

    UpgradeCategories.Beautification_Pillar,
    UpgradeCategories.Beautification_Shrine,
    UpgradeCategories.Beautification_StoneBench,
    UpgradeCategories.Beautification_Sundial,
    UpgradeCategories.Beautification_Vase,
    UpgradeCategories.Beautification_TriumphalArch,
    UpgradeCategories.Beautification_VictoryColumn,

    UpgradeCategories.Beautification_Brazier,
    UpgradeCategories.Beautification_Brazier1,
    UpgradeCategories.Beautification_Brazier3,
    
    UpgradeCategories.Beautification_Graveyard,
    UpgradeCategories.Beautification_ExecutionerPlace,
    UpgradeCategories.Beautification_PrisonCage,
    UpgradeCategories.Beautification_BrothersInArms,
    UpgradeCategories.Beautification_StatueHorseman,
    UpgradeCategories.Beautification_Lantern,

    UpgradeCategories.Beautification_Flowerpot_Round,
    UpgradeCategories.Beautification_Flowerpot_Square,
    
    UpgradeCategories.Beautification_WoodBench1,
    UpgradeCategories.Beautification_WoodBench2,
    UpgradeCategories.Beautification_WoodBench3,
    UpgradeCategories.Beautification_WoodBench4,
    UpgradeCategories.Beautification_WoodBench5,
    UpgradeCategories.Beautification_WoodBench6,
    
    UpgradeCategories.Beautification_Cart1,
    UpgradeCategories.Beautification_Cart2,
    UpgradeCategories.Beautification_Cart3,
    UpgradeCategories.Beautification_Cart4,
    UpgradeCategories.Beautification_Cart5,
    UpgradeCategories.Beautification_Cart6,
    
    UpgradeCategories.Beautification_Misc1,
    UpgradeCategories.Beautification_Misc2,
    UpgradeCategories.Beautification_Misc3,
    UpgradeCategories.Beautification_Misc4,
    UpgradeCategories.Beautification_Misc5,
    UpgradeCategories.Beautification_Misc6,
    UpgradeCategories.Beautification_Misc7,
    UpgradeCategories.Beautification_Misc8,

    UpgradeCategories.Beautification_Signpost1,
    UpgradeCategories.Beautification_Signpost2,
    UpgradeCategories.Beautification_Signpost3,
    
    UpgradeCategories.Beautification_Military1,
    UpgradeCategories.Beautification_Military2,
    UpgradeCategories.Beautification_Military3,
    UpgradeCategories.Beautification_Military4,
    UpgradeCategories.Beautification_Military5,
    UpgradeCategories.Beautification_Military6,
    UpgradeCategories.Beautification_Military7,
    UpgradeCategories.Beautification_Military8,
    
    UpgradeCategories.Beautification_U_KnightChivalry,
    UpgradeCategories.Beautification_U_KnightHealing,
    UpgradeCategories.Beautification_U_KnightPlunder,
    UpgradeCategories.Beautification_U_KnightSong,
    UpgradeCategories.Beautification_U_KnightTrading,
    UpgradeCategories.Beautification_U_KnightWisdom,
    UpgradeCategories.Beautification_U_KnightSabatta,
    UpgradeCategories.Beautification_U_KnightRedPrince,
    UpgradeCategories.Beautification_U_KnightSaraya,
    UpgradeCategories.Beautification_U_KnightPraphat,
    UpgradeCategories.Beautification_U_KnightKhana,
    UpgradeCategories.Beautification_U_KnightGeneric,

    UpgradeCategories.Plaza_MiddleEurope,
    UpgradeCategories.Plaza_NorthEurope,
    UpgradeCategories.Plaza_SouthEurop,
    UpgradeCategories.Plaza_NorthAfrica,
    UpgradeCategories.Plaza_Asia

    --not buildabel (for now)
    --UpgradeCategories.Beautification_Brazier2,
    --UpgradeCategories.Beautification_XmasTree,
}

function GUI_Construction.SwitchBuildingCategory()
    if g_Construction.CurrentPlacementType ~= nil then
        --local AmountOfTypes, FirstBuildingType = Logic.GetBuildingTypesInUpgradeCategory(g_LastPlacedParam)
        --GUI.AddNote("PlacementType: ".. g_Construction.CurrentPlacementType)
        if g_LastPlacedCategory ~= nil and g_LastPlacedCategory >= 0 and GUI_Construction.BuildingsWithSkins[g_LastPlacedCategory] ~= nil then
            --GUI.AddNote("DEBUG: " .. table.getn(GUI_Construction.BuildingsWithSkins[g_LastPlacedCategory]) .. " buildings.")
            --GUI.AddNote("DEBUG: Index of item: " .. indexOf(GUI_Construction.BuildingsWithSkins[g_LastPlacedCategory], g_LastPlacedParam) .. ".")
            local itemIndex = GetIndexOfItem(GUI_Construction.BuildingsWithSkins[g_LastPlacedCategory], g_LastPlacedParam)
            local nextItem
            if itemIndex < table.getn(GUI_Construction.BuildingsWithSkins[g_LastPlacedCategory]) then
                nextItem = GUI_Construction.BuildingsWithSkins[g_LastPlacedCategory][itemIndex+1]
            else
                nextItem = GUI_Construction.BuildingsWithSkins[g_LastPlacedCategory][1]
            end
            GUI_Construction.BuildClicked(nextItem, true)
        end
    end
end

function GUI_Construction.BuildNPCWallClicked()
    --GUI.AddNote("Text: " .. GUI.GetCurrentStateID())
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
    local buildingType = GetUpgradeCategoryForClimatezone("Plaza")
    PlacementState = 0

    XGUIEng.UnHighLightGroup("/InGame", "Construction")

    --No need to check settler limit here
    --[[
    if not GUI_Construction.TestSettlerLimit(buildingType) then
        return
    end
    --]]

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

function GUI_Construction.BuildTowerClicked(_entityType)
    local UCat = GetUpgradeCategoryForClimatezone(_entityType)
    --Logic.DEBUG_AddNote("DEBUG: _widget = " .. _widget .." ; BuildingType = " ..BuildingType)
    
    GUI_Construction.BuildClicked(UCat)
end

--Set visibility and position of cathedral build button and size of BG
function GUI_Construction.BuildWonderUpdate()
    local PlayerID = GUI.GetPlayerID()
    local bgWidget = "/InGame/Root/Normal/AlignBottomRight/BuildMenu/BG_SE"
    local cathedralWidget = "/InGame/Root/Normal/AlignBottomRight/BuildMenu/Categories/B_Beautification_Cathedral"
    if Logic.TechnologyGetState(PlayerID, Technologies.R_Beautification_Cathedral) == TechnologyStates.Researched or EnableRights ~= true then
        XGUIEng.ShowWidget(cathedralWidget, 1)
        XGUIEng.SetWidgetLocalPosition(bgWidget, 748, 85)
        XGUIEng.SetWidgetSize(bgWidget,52, 695)

        if Logic.GetNumberOfEntitiesOfTypeOfPlayer(PlayerID, Entities.B_Beautification_Cathedral) == 0 then
            XGUIEng.DisableButton(cathedralWidget, 0)
        else
            XGUIEng.DisableButton(cathedralWidget, 1)
        end
    else
        XGUIEng.ShowWidget(cathedralWidget, 0)
        XGUIEng.SetWidgetLocalPosition(bgWidget, 748, 145)
        XGUIEng.SetWidgetSize(bgWidget,52, 635)
    end
end

-----------------------------------------------------------------------------------------
-- Overwrites for Construction
-----------------------------------------------------------------------------------------

function InitOverwriteConstructionEx2()

    do
        local OldGUI_Construction_TestSettlerLimit = GUI_Construction.TestSettlerLimit
        GUI_Construction.TestSettlerLimit = function(_BuildingType)
    
            -- check for settlers limit, but not for these buildings:
            if GetIndexOfItem(GUI_Construction.TestSettlerLimitExceptions, _BuildingType) ~= nil then
                return true
            else
                return OldGUI_Construction_TestSettlerLimit(_BuildingType)
            end
        end
    end

    do
        local OldGUI_Construction_RefreshBuildingButtons = GUI_Construction.RefreshBuildingButtons
        function GUI_Construction.RefreshBuildingButtons()
            OldGUI_Construction_RefreshBuildingButtons()

            -- sub menus
            XGUIEng.ShowAllSubWidgets("/InGame/Root/Normal/AlignBottomRight/BuildMenu/SubMenus/SpecialEdition/ButtonsAddon", 1)
            XGUIEng.ShowAllSubWidgets("/InGame/Root/Normal/AlignBottomRight/BuildMenu/SubMenus/SpecialEdition2/Buttons", 1)
            XGUIEng.ShowAllSubWidgets("/InGame/Root/Normal/AlignBottomRight/BuildMenu/SubMenus/SpecialEdition2/ButtonsAddon", 1)
        end
    end

    do
        function GUI_Construction.BuildClicked(_BuildingType, _KeepCategory)
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
                if _KeepCategory ~= true then
                    if GUI_Construction.BuildingsWithSkins[g_LastPlacedParam] ~= nil then
                        g_LastPlacedCategory = _BuildingType
                    else
                        g_LastPlacedCategory = -1
                    end
                end

                -- tell the tutorial, that this button has been pressed by the player
                if XGUIEng.GetCurrentWidgetID() ~= 0 then
                    SaveButtonPressed(XGUIEng.GetCurrentWidgetID())
                end
            end
        end
    end

    do
        local OldGUI_Construction_BuildUpdate = GUI_Construction.BuildUpdate
        function GUI_Construction.BuildUpdate(_TechnologyType, _BuildingsMenuBool)
            OldGUI_Construction_BuildUpdate(_TechnologyType, _BuildingsMenuBool)

            --Update cathedral button too
            GUI_Construction.BuildWonderUpdate()
        end
    end

end