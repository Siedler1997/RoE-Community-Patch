
GUI_MultiSelection = {}


function InitMultiselection()
    g_MultiSelection = {}
    g_MultiSelection.EntityList = {}
    g_MultiSelection.Highlighted = {}
    --g_MultiSelection.IgnoreCreate = 0
    
    LeaderSortOrder = {}
    LeaderSortOrder[1] = Entities.U_MilitarySword
    LeaderSortOrder[2] = Entities.U_MilitaryBow
    LeaderSortOrder[3] = Entities.U_MilitarySword_RedPrince
    LeaderSortOrder[4] = Entities.U_MilitaryBow_RedPrince
    LeaderSortOrder[5] = Entities.U_MilitaryBandit_Melee_ME
    LeaderSortOrder[6] = Entities.U_MilitaryBandit_Melee_NA
    LeaderSortOrder[7] = Entities.U_MilitaryBandit_Melee_NE
    LeaderSortOrder[8] = Entities.U_MilitaryBandit_Melee_SE
    LeaderSortOrder[9] = Entities.U_MilitaryBandit_Ranged_ME
    LeaderSortOrder[10] = Entities.U_MilitaryBandit_Ranged_NA
    LeaderSortOrder[11] = Entities.U_MilitaryBandit_Ranged_NE
    LeaderSortOrder[12] = Entities.U_MilitaryBandit_Ranged_SE
    LeaderSortOrder[13] = Entities.U_MilitaryCannon
    LeaderSortOrder[14] = Entities.U_MilitaryCatapult
    LeaderSortOrder[15] = Entities.U_MilitarySiegeTower
    LeaderSortOrder[16] = Entities.U_MilitaryBatteringRam
    LeaderSortOrder[17] = Entities.U_MilitaryTrebuchet
    LeaderSortOrder[18] = Entities.U_CatapultCart
    LeaderSortOrder[19] = Entities.U_CannonCart
    LeaderSortOrder[20] = Entities.U_SiegeTowerCart
    LeaderSortOrder[21] = Entities.U_BatteringRamCart
    LeaderSortOrder[22] = Entities.U_TrebuchetCart
    LeaderSortOrder[23] = Entities.U_Thief
    LeaderSortOrder[24] = Entities.U_Bear
    LeaderSortOrder[25] = Entities.U_BlackBear
    LeaderSortOrder[26] = Entities.U_PolarBear
    LeaderSortOrder[27] = Entities.U_Lion_Male
    LeaderSortOrder[28] = Entities.U_Lion_Female
    LeaderSortOrder[29] = Entities.U_Wolf_Grey
    LeaderSortOrder[30] = Entities.U_Wolf_White
    LeaderSortOrder[31] = Entities.U_Wolf_Black
    LeaderSortOrder[32] = Entities.U_Wolf_Brown
end


function GUI_MultiSelection.SelectAllPlayerUnitsClicked()
    Sound.FXPlay2DSound("ui\\menu_click")
    GUI.ClearSelection()
    
    local PlayerID = GUI.GetPlayerID()
    
    for i = 1, #LeaderSortOrder do
        local EntitiesOfThisType = GetPlayerEntities(PlayerID, LeaderSortOrder[i])
        
        for j = 1, #EntitiesOfThisType do
            GUI.SelectEntity(EntitiesOfThisType[j])
        end
    end

    local Knights = {}
    Logic.GetKnights(PlayerID, Knights) --fill the Knights table ><
    
    for k = 1, #Knights do --several knights because of map 15
        GUI.SelectEntity(Knights[k])
    end

--    GUI.SelectEntity(Logic.GetKnightID(PlayerID))
    
    
    GUI_MultiSelection.CreateMultiSelection(g_SelectionChangedSource.User)
end


function GUI_MultiSelection.SelectAllClicked()
    Sound.FXPlay2DSound("ui\\menu_click")
    GUI.ClearSelection()

    for i = 1, #g_MultiSelection.EntityList do
        GUI.SelectEntity(g_MultiSelection.EntityList[i])
    end
    
    GUI_MultiSelection.HighlightSelectedEntities()
end


function GUI_MultiSelection.HighlightSelectedEntities()

    XGUIEng.UnHighLightGroup("/InGame", "MultiSelection")

    for i = 1, #g_MultiSelection.EntityList do
        local ButtonName = "/InGame/Root/Normal/AlignBottomRight/Selection/MultiSelection/" .. i
        XGUIEng.ShowWidget(ButtonName, 1)       
        
        if GUI.IsEntitySelected(g_MultiSelection.EntityList[i]) then
            ButtonName = ButtonName .. "/Icon"
            XGUIEng.HighLightButton(ButtonName, 1)
            g_MultiSelection.Highlighted[i] = true
        else
            g_MultiSelection.Highlighted[i] = false
        end
    end
    
    local TotalSelectedNumber = #{GUI.GetSelectedEntities()}
    local TotalButtonsNumber = #g_MultiSelection.EntityList

    if TotalSelectedNumber == TotalButtonsNumber then
        XGUIEng.ShowWidget("/InGame/Root/Normal/AlignBottomRight/Selection/MultiSelection/Controls/MultiselectionSelectAllAgain", 0)
    else
        XGUIEng.ShowWidget("/InGame/Root/Normal/AlignBottomRight/Selection/MultiSelection/Controls/MultiselectionSelectAllAgain", 1)
    end
    
    if TotalButtonsNumber ~= 1 then
        XGUIEng.ShowWidget("/InGame/Root/Normal/AlignBottomRight/Selection/MultiSelection/Controls/MultiselectionTooltip", 1)
    else
        XGUIEng.ShowWidget("/InGame/Root/Normal/AlignBottomRight/Selection/MultiSelection/Controls/MultiselectionTooltip", 0)
    end
end


-- Function creates a new multi-selection (in any case)
function GUI_MultiSelection.CreateEX()
    XGUIEng.ShowWidget("/InGame/Root/Normal/AlignBottomRight/Selection/MultiSelection", 1)

    g_MultiSelection.EntityList = { GUI.GetSelectedEntities() }
    GUI_MultiSelection.SortMultiSelection()
    GUI_MultiSelection.HighlightSelectedEntities()
end


function GUI_MultiSelection.CreateMultiSelection(_Source)

    XGUIEng.ShowWidget("/InGame/Root/Normal/AlignBottomRight/Selection/MultiSelection", 1)
    
    if  _Source ~= g_SelectionChangedSource.User then
        return -- ### RETURN ###
    end
    
    local SelectedEntities = { GUI.GetSelectedEntities() }
    
    if (#SelectedEntities == 1 and GUI_MultiSelection.IsEntityInMultiSelection(GUI.GetSelectedEntity()) == false )
    or #SelectedEntities > 1 then
        GUI_MultiSelection.CreateEX()
    else
        GUI_MultiSelection.HighlightSelectedEntities()
    end
end


function GUI_MultiSelection.AreAllSelectedEntitiesInMultiSelection()

    -- First check that the selection status for all entities in the multi-selection fits
    
    for j = 1, #g_MultiSelection.EntityList do
        if GUI.IsEntitySelected(g_MultiSelection.EntityList[j]) ~= g_MultiSelection.Highlighted[j] then
            return false -- ### RETURN ###
        end
    end
    
    -- Now check that all selected entities are in the multi-selection
    
    local SelectedEntities = { GUI.GetSelectedEntities() }
    
    for i = 1, #SelectedEntities do
        local EntityID = SelectedEntities[i]
        local Found = false

        for j = 1, #g_MultiSelection.EntityList do
            if g_MultiSelection.EntityList[j] == EntityID then
                Found = true
                break -- ### BREAK ###
            end
        end
            
        if Found == false then
        
            return false -- ### RETURN ###

        end
    end

    return true -- ### RETURN ###
end


function GUI_MultiSelection.IsEntityInMultiSelection(_EntityID )

    for i=1, #g_MultiSelection.EntityList do
        local EntityID = g_MultiSelection.EntityList[i]
        if EntityID == _EntityID then
            return true -- ### RETURN ###
        end
    end

    return false -- ### RETURN ###
end


function GUI_MultiSelection.SortMultiSelection()

    local SortedMultiSelectionTable = {}

    --ToDo(?): sort by manned and unmanned
    
    --first comes the knight
    for key,EntityIDInMultiselection in pairs (g_MultiSelection.EntityList) do

        if Logic.GetKnightID(GUI.GetPlayerID()) == EntityIDInMultiselection then
            table.insert(SortedMultiSelectionTable, EntityIDInMultiselection)            
            --GUI.AddNote("Index knight: " ..key)
        end
    end

    --then the leaders in the definced LeaderSortOrder
    for k=1,#LeaderSortOrder do
        for key,EntityIDInMultiselection in pairs (g_MultiSelection.EntityList) do
        
            local EntityTypeInMultiselection = Logic.GetEntityType(EntityIDInMultiselection)

            if Logic.IsEntityInCategory(EntityIDInMultiselection,EntityCategories.Leader) == 1 then
                EntityTypeInMultiselection = Logic.LeaderGetSoldiersType(EntityIDInMultiselection)
            end

            if EntityTypeInMultiselection == LeaderSortOrder[k] then
                table.insert(SortedMultiSelectionTable, EntityIDInMultiselection)                                
                --GUI.AddNote("Index: ".. key .."->" ..Logic.GetEntityTypeName(EntityTypeInMultiselection))
            end
        end
    end

    --and now the rest
    for key,EntityIDInMultiselection in pairs (g_MultiSelection.EntityList) do
        local EntityTypeInMultiselection = Logic.GetEntityType(EntityIDInMultiselection)

        if Logic.IsEntityInCategory(EntityIDInMultiselection,EntityCategories.Leader) == 1 then
            EntityTypeInMultiselection = Logic.LeaderGetSoldiersType(EntityIDInMultiselection)
        end

        local EntityIsNotInSortedYet = false

        for i=1, #LeaderSortOrder do
            if      Logic.GetKnightID(GUI.GetPlayerID()) == EntityIDInMultiselection
                or EntityTypeInMultiselection == LeaderSortOrder[i] then
                    EntityIsNotInSortedYet = true                    
                    --GUI.AddNote("Not sorted index: ".. key .."->" ..Logic.GetEntityTypeName(EntityTypeInMultiselection))
            end
        end

        if EntityIsNotInSortedYet == false then
            table.insert(SortedMultiSelectionTable, EntityIDInMultiselection)                        
            --GUI.AddNote(Logic.GetEntityTypeName(EntityTypeInMultiselection))
        end
    end

    -- because UI can not display more the 36 units for now
    while #SortedMultiSelectionTable > 36 do
        GUI.DeselectEntity(SortedMultiSelectionTable[#SortedMultiSelectionTable])
        table.remove(SortedMultiSelectionTable)
    end
    
    -- because multiselection interface it at the right side
    local InvertedSortedMultiSelectionTable = {}
    
    for j=0,#SortedMultiSelectionTable-1 do
        local LastIDInTable = SortedMultiSelectionTable[#SortedMultiSelectionTable  - j]
        table.insert(InvertedSortedMultiSelectionTable, LastIDInTable)       
        
        --GUI.AddNote("Index: " .. #SortedMultiSelectionTable  - j .. "->"..Logic.GetEntityTypeName(Logic.GetEntityType(LastIDInTable)))
    end

    --save the new table
    g_MultiSelection.EntityList = InvertedSortedMultiSelectionTable
end


function GUI_MultiSelection.IconUpdate()

    local CurrentWidgetID = XGUIEng.GetCurrentWidgetID()    
    local CurrentMotherID = XGUIEng.GetWidgetsMotherID(CurrentWidgetID)
    local CurrentMotherName = XGUIEng.GetWidgetNameByID(CurrentMotherID)
    local Index = CurrentMotherName + 0
    local CurrentMotherPath = XGUIEng.GetWidgetPathByID(CurrentMotherID)
    local HealthWidgetPath = CurrentMotherPath .. "/Health"

    local EntityID = g_MultiSelection.EntityList[Index]
    
    if Logic.IsEntityAlive(EntityID) then
        --hack because of bug that a button can't be highlighted inside his click function
        if GUI.IsEntitySelected(EntityID) == false
        and XGUIEng.IsButtonHighLighted(CurrentWidgetID) == 1 then
            XGUIEng.HighLightButton(CurrentWidgetID, 0)
        end
        
        local HealthState = Logic.GetEntityHealth(EntityID)
        local EntityMaxHealth = Logic.GetEntityMaxHealth(EntityID)
        local EntityType = Logic.GetEntityType(EntityID)

        if Logic.IsLeader(EntityID) == 1 then
            local SoldierType = Logic.LeaderGetSoldiersType(EntityID)
            SetIcon(CurrentWidgetID, g_TexturePositions.Entities[SoldierType])
            
            HealthState = Logic.LeaderGetNumberOfSoldiers(EntityID)
            EntityMaxHealth = Logic.LeaderGetMaxNumberOfSoldiers(EntityID)
        
        elseif Logic.IsEntityInCategory(EntityID, EntityCategories.HeavyWeapon) == 1 then
            if (EntityType == Entities.U_CatapultCart
            or EntityType == Entities.U_SiegeTowerCart
            or EntityType == Entities.U_BatteringRamCart
            or EntityType == Entities.U_AmmunitionCart
            or EntityType == Entities.U_MilitaryBallista
            or EntityType == Entities.U_TrebuchetCart
            or EntityType == Entities.U_Trebuchet
            or Logic.GetNumSoldiersAttachedToWarMachine(EntityID) > 0) then
                SetIcon(CurrentWidgetID, g_TexturePositions.Entities[EntityType])
            
            else
                local uPos = g_TexturePositions.Entities[EntityType][1]
                local vPos = g_TexturePositions.Entities[EntityType][2]
                
                SetIcon(CurrentWidgetID, {uPos + 1, vPos})
            end
        else
            SetIcon(CurrentWidgetID, g_TexturePositions.Entities[EntityType])
        end
        
        HealthState = math.floor(HealthState / EntityMaxHealth * 100)

        if HealthState < 50 then
            local green = math.floor(2*255* (HealthState/100))
            XGUIEng.SetMaterialColor(HealthWidgetPath,0,255,green, 20,255)
        else
            local red = 2*255 - math.floor(2*255* (HealthState/100))
            XGUIEng.SetMaterialColor(HealthWidgetPath,0,red, 255, 20,255)
        end

        XGUIEng.SetProgressBarValues(HealthWidgetPath,HealthState, 100)
    else
        XGUIEng.ShowWidget(CurrentMotherID, 0)
        
        --update the Multiselection
        GUI_MultiSelection.CreateEX()               
    end
end


function GUI_MultiSelection.IconMouseOver()
    local CurrentWidgetID = XGUIEng.GetCurrentWidgetID()    
    local CurrentMotherID = XGUIEng.GetWidgetsMotherID(CurrentWidgetID)
    local CurrentMotherName = XGUIEng.GetWidgetNameByID(CurrentMotherID)
    local Index = tonumber(CurrentMotherName)
    local EntityID = g_MultiSelection.EntityList[Index]

    if EntityID == nil
    or EntityID == 0 then
        return
    end

    local EntityType
    
    if Logic.IsLeader(EntityID) == 1 then
        EntityType = Logic.LeaderGetSoldiersType(EntityID)
    else
        EntityType = Logic.GetEntityType(EntityID)
    end
    
    local EntityTypeName = Logic.GetEntityTypeName(EntityType)
    local TooltipTextKey = "Abilities_" .. EntityTypeName

    if (EntityType == Entities.U_MilitaryCatapult
    or EntityType == Entities.U_MilitarySiegeTower
    or EntityType == Entities.U_MilitaryBatteringRam
    or EntityType == Entities.U_MilitaryTrebuchet)
    and Logic.GetNumSoldiersAttachedToWarMachine(EntityID) == 0 then
        TooltipTextKey = TooltipTextKey .. "_NoSoldiersAttached"
    end

    GUI_Tooltip.TooltipNormal(TooltipTextKey)
end


function GUI_MultiSelection.IconClicked()

    Sound.FXPlay2DSound("ui\\menu_click")    

    local CurrentWidgetID = XGUIEng.GetCurrentWidgetID()
    local SelectedEntities = g_MultiSelection.EntityList
    local CurrentMotherID = XGUIEng.GetWidgetsMotherID(CurrentWidgetID)
    local CurrentMotherName = XGUIEng.GetWidgetNameByID(CurrentMotherID)
    local Index = CurrentMotherName + 0

    local EntityID = SelectedEntities[Index]
    
    if EntityID == nil then
        return -- ### RETURN ###
    end
    
    if XGUIEng.IsModifierPressed(Keys.ModifierShift) then
        
        local EntitiesToModify
        
        if XGUIEng.IsModifierPressed(Keys.ModifierControl) == true then
            EntitiesToModify = GUI_MultiSelection.GetAllEntitiesOfTheSameTypeInMultiSelection(EntityID)
        else
            EntitiesToModify = {EntityID}
        end
        
        local ModifyFunction
        
        if GUI.IsEntitySelected(EntityID) == true then
            ModifyFunction = GUI.DeselectEntity
        else
            ModifyFunction = GUI.SelectEntity
        end
        
        for i = 1, #EntitiesToModify do
            ModifyFunction(EntitiesToModify[i])
        end
        
        --KoBo: changed this behaviour
        --table.remove(g_MultiSelection.EntityList, Index)
        
        GUI_MultiSelection.HighlightSelectedEntities()
        
        XGUIEng.ShowWidget("/InGame/Root/Normal/AlignBottomRight/Selection/MultiSelection", 1)
    else
        if XGUIEng.IsModifierPressed(Keys.ModifierControl) == true then
            GUI_MultiSelection.SelectAllEntitiesOfTheSameTypeInMultiSelection(EntityID)
        else
            GUI.SetSelectedEntity(EntityID)
            
            GUI_MultiSelection.HighlightSelectedEntities()
            
            if ((Framework.GetTimeMs() - g_Selection.LastClickTime ) < g_Selection.MaxDoubleClickTime) then
                local pos = GetPosition(EntityID)
                Camera.RTS_SetLookAtPosition(pos.X, pos.Y)
            end
        
            -- update the last click time
            g_Selection.LastClickTime = Framework.GetTimeMs()
        end
    end
end


function GUI_MultiSelection.SelectAllEntitiesOfTheSameTypeInMultiSelection(_EntityID)

    local EntitiesToSelect = GUI_MultiSelection.GetAllEntitiesOfTheSameTypeInMultiSelection(_EntityID)

    GUI.ClearSelection()

    for l=1, #EntitiesToSelect do
        GUI.SelectEntity(EntitiesToSelect[l])
    end
    
    GUI_MultiSelection.HighlightSelectedEntities()
end


function GUI_MultiSelection.GetAllEntitiesOfTheSameTypeInMultiSelection(_EntityID)

    local EntitiesOfThisType = {}

    local TargetEntityType = Logic.GetEntityType(_EntityID)

    if Logic.IsEntityInCategory(_EntityID,EntityCategories.Leader) == 1 then
        TargetEntityType = Logic.LeaderGetSoldiersType(_EntityID)
    end

    for i=1, #g_MultiSelection.EntityList do
        local EntityIDInMultiselection = g_MultiSelection.EntityList[i]

        local EntityTypeInMultiselection = Logic.GetEntityType(EntityIDInMultiselection)

        if Logic.IsEntityInCategory(EntityIDInMultiselection,EntityCategories.Leader) == 1 then
            EntityTypeInMultiselection = Logic.LeaderGetSoldiersType(EntityIDInMultiselection)
        end

        if TargetEntityType == EntityTypeInMultiselection then
            table.insert(EntitiesOfThisType, EntityIDInMultiselection)
        end
    end
    
    return EntitiesOfThisType
end


function GUI_MultiSelection.StoreSelectionGroup(_Index)

    GUI.StoreSelectionGroup(10, true)

    if GUI.GetSelectedEntity() ~= nil then
        GUI.ClearSelection()

        for i=1, #g_MultiSelection.EntityList do
            GUI.SelectEntity(g_MultiSelection.EntityList[i])
        end
    end

    GUI.StoreSelectionGroup(_Index)
    GUI.RestoreSelectionGroup(10)
    GUI.ClearSelectionGroup(10)
end


function GameCallback_GUI_EntityIDChanged(_Parameter1, _Parameter2, _Parameter3, _Parameter4)

--GUI.AddNote(_Parameter1)
--GUI.AddNote(_Parameter2)
--GUI.AddNote(_Parameter3)
--GUI.AddNote(_Parameter4)
end
