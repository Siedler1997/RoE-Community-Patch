
GUI_BuildingInfo = {}


function GUI_BuildingInfo.SoldiersLimitUpdate()
    local CurrentWidgetID = XGUIEng.GetCurrentWidgetID()
    local PlayerID = GUI.GetPlayerID()
    local SoldiersLimit = Logic.GetCurrentSoldierLimit(PlayerID)
    
    local SoldiersLimitText = XGUIEng.GetStringTableText("UI_Texts/SoldiersLimit_colon")
    local Text = "{center}" .. SoldiersLimitText .. " " .. SoldiersLimit
    XGUIEng.SetText(CurrentWidgetID, Text)
end


function GUI_BuildingInfo.SettlersLimitUpdate()
    local CurrentWidgetID = XGUIEng.GetCurrentWidgetID()
    local PlayerID = GUI.GetPlayerID()
    local SettlersLimit = Logic.GetMaxNumberOfEmployedWorkers(PlayerID)
    
    local SettlersLimitText = XGUIEng.GetStringTableText("UI_Texts/SettlersLimit_colon")
    local Text = "{center}" .. SettlersLimitText .. " " .. SettlersLimit
    XGUIEng.SetText(CurrentWidgetID, Text)
end


function GUI_BuildingInfo.StorageLimitUpdate()
    local CurrentWidgetID = XGUIEng.GetCurrentWidgetID()
    local PlayerID = GUI.GetPlayerID()
    local StorehouseID = Logic.GetStoreHouse(PlayerID)
    local StorageLimit = Logic.GetMaxAmountOnStock(StorehouseID)

    local StorageLimitText = XGUIEng.GetStringTableText("UI_Texts/StorageLimit_colon")
    local Text = "{center}" .. StorageLimitText .. " " .. StorageLimit
    XGUIEng.SetText(CurrentWidgetID, Text)
end


function GUI_BuildingInfo.SermonSeatsLimitUpdate()
    local PlayerID = GUI.GetPlayerID()
    local CurrentWidgetID = XGUIEng.GetCurrentWidgetID()
    local SermonSeats = Logic.GetSermonSettlerLimit(PlayerID)

    local SermonSeatsText = XGUIEng.GetStringTableText("UI_Texts/SermonSeats_colon")
    local Text = "{center}" .. SermonSeatsText .. " " .. SermonSeats
    XGUIEng.SetText(CurrentWidgetID, Text)
end


function GUI_BuildingInfo.SermonSeatsUsedUpdate()
    local PlayerID = GUI.GetPlayerID()
    local IsSermonActiveBoolean = Logic.IsSermonActive(PlayerID)
    
    if IsSermonActiveBoolean == true then
        local SermonSeatsUsed = Logic.GetNumberOfSettlersInSermon(PlayerID)
        local Text = "{center}" .. SermonSeatsUsed
        XGUIEng.SetText("/InGame/Root/Normal/AlignBottomRight/Selection/Cathedral/CurrentSermonSeatsUsed/SeatsUsed", Text)
        
        XGUIEng.ShowWidget("/InGame/Root/Normal/AlignBottomRight/Selection/Cathedral/CurrentSermonSeatsUsed", 1)
    else
        XGUIEng.ShowWidget("/InGame/Root/Normal/AlignBottomRight/Selection/Cathedral/CurrentSermonSeatsUsed", 0)
    end
end


function GUI_BuildingInfo.UpdateDebugInfo()

    local Text = ""
    local CurrentWidgetID = XGUIEng.GetCurrentWidgetID()

    if Debug_EnableDebugOutput then
        local EntityID = GUI.GetSelectedEntity()
        
        if Logic.IsEntityInCategory(EntityID, EntityCategories.OuterRimBuilding) == 1 
        or Logic.IsEntityInCategory(EntityID, EntityCategories.CityBuilding) == 1 then                    
            local Cycles = GetNumberOfWorkCyclesThatCanBeDoneAtBuilding(EntityID)
            
            Text = "Can work " .. Cycles .. " times"
            
            if Logic.IsEntityInCategory(EntityID, EntityCategories.OuterRimBuilding) == 1 then
                Text = "Can deliver " .. Cycles .. " times"
            end
            
            if Cycles >  3 then
                Text = "needs boosted"
            end
            
            if Cycles <= 0 then
                Text = "check needs"
            end
        end
    end
    
    XGUIEng.SetText(CurrentWidgetID, Text)
end


function GetNumberOfWorkCyclesThatCanBeDoneAtBuilding(_BuildingID)

   local Cycles = 100
    
   for i=1,4 do

        local Need = 0

        if i == 1 then
            Need = Needs.Nutrition
        elseif i == 2 then
            Need = Needs.Hygiene
        elseif i == 3 then
            Need = Needs.Entertainment
        elseif i == 4 then
            Need = Needs.Clothes
        end
        
        if Logic.IsNeedActive(_BuildingID,Need) then
            
            local CriticalThreshold = Logic.GetNeedCriticalThreshold(_BuildingID, Need)
            local AttentionThreshold = Logic.GetNeedAttentionThreshold(_BuildingID, Need)
            local State = Logic.GetNeedState(_BuildingID, Need)
            
            local CyclesUntilAttention = State - AttentionThreshold
            
            if CyclesUntilAttention < Cycles then
                Cycles = CyclesUntilAttention
            end
        end
    end
    
    return math.floor((Cycles+0.1)*10)
    
end


function GUI_BuildingInfo.UpdateActiveNeedsGUI()
    --XGUIEng.ShowAllSubWidgets("/InGame/Root/Normal/BuildingInfo/Needs/ActiveNeeds",1)
    --XGUIEng.ShowAllSubWidgets("/InGame/Root/Normal/BuildingExtendedInfo/Needs",1)
    --XGUIEng.ShowAllSubWidgets("/InGame/Root/Normal/GoodsAndResources",1)
end


function GUI_BuildingInfo.GetBuildingTaskTimes(_EntityID)

    --TaskTimes
    local BuildingTaskTimes = {Logic.GetTaskLogMonthFractionsUsed(_EntityID, 0)}

    local WorkTime
    local RoutesTime
    local NeedsTime
    local IdleTime

    if table.getn(BuildingTaskTimes) ~= 0 then
        --work: 8-LogTypeWork
        WorkTime = Round(BuildingTaskTimes[8 * 2 + 2] * 100)

        --routes: 9-LogTypeDeliver or 10-LogTypeFetchResource, depending on whether it's a Outer Rim or City building
        RoutesTime = Round(BuildingTaskTimes[9 * 2 + 2] * 100 + BuildingTaskTimes[10 * 2 + 2] * 100)

        --needs: 2-LogTypeNutritionFetch, 4-LogTypeHygieneFetch, 6-LogTypeEntertainmentFetch
        NeedsTime = Round(BuildingTaskTimes[2 * 2 + 2] * 100 + BuildingTaskTimes[4 * 2 + 2] * 100 + BuildingTaskTimes[6 * 2 + 2] * 100)

        --idle: 0-LogTypeInvalid, 1-LogTypeUnknown, 3-LogTypeNutritionWait, 5-LogTypeHygieneWait, 7-LogTypeEntertainmentWait, 11-LogTypeWaitForSpace
        --local IdleTime = Round(BuildingTaskTimes[0 * 2 + 2] * 100 + BuildingTaskTimes[1 * 2 + 2] * 100 + BuildingTaskTimes[3 * 2 + 2] * 100
        --+ BuildingTaskTimes[5 * 2 + 2] * 100 + BuildingTaskTimes[7 * 2 + 2] * 100 + BuildingTaskTimes[11 * 2 + 2] * 100)

        --idle: 3-LogTypeNutritionWait, 5-LogTypeHygieneWait, 7-LogTypeEntertainmentWait, 11-LogTypeWaitForSpace
        IdleTime = Round(BuildingTaskTimes[3 * 2 + 2] * 100
            + BuildingTaskTimes[5 * 2 + 2] * 100 + BuildingTaskTimes[7 * 2 + 2] * 100 + BuildingTaskTimes[11 * 2 + 2] * 100)
    end

    return WorkTime, RoutesTime, NeedsTime, IdleTime
end


function GUI_BuildingInfo.CurrentTaskUpdate()

    local EntityID = GUI.GetSelectedEntity()
    if EntityID == 0 or EntityID == nil then
        return
    end

    --local NumOfTasksInHistory = Logic.GetNoOfTasksInHistory() - 1;
    local NumOfTasksInHistory = Logic.GetNoOfTasksInHistory() - 3;
    local Text = ""

    for HistoryIndex = 0, NumOfTasksInHistory do
        

        -- get TaskType, DestinationEntityType, GoodType and ErrorCode for this history entry
        local TaskType, DestinationEntityType, GoodType, Amount, ErrorCode, FleeReason, IdleReason = 
            Logic.GetTaskHistoryEntry(EntityID, (NumOfTasksInHistory-HistoryIndex))
        
        local HistoryTaskTypeName = Logic.GetHistoryTaskTypeName(TaskType)
        
        --if ErrorCode > 0 then
        --    Text = Text .. "{@color:220,64,16,255}Error: " .. HistoryTaskTypeName
        --else
        if TaskType > 0 and HistoryTaskTypeName ~= "TaskTypeInvalid" then
            -- color the older entries greyer, the current entry normal
            if (HistoryIndex ~= NumOfTasksInHistory) then
                Text = Text .. "{@color:51,51,120,100}"
            else
                Text = Text .. "{@color:none}"
            end

            -- create task type name with text
            local HistoryTaskTypeText = XGUIEng.GetStringTableText("UI_TaskHistory/" .. HistoryTaskTypeName)

            -- take TaskName if no entry exists
            if HistoryTaskTypeText == "" then
                HistoryTaskTypeText = HistoryTaskTypeName .. "{cr}[no text key]"
            end

            -- display idle reason, if available
            if IdleReason == HistoryIdleReasons.IdleReasonNone then
                Text = Text .. "\"" .. HistoryTaskTypeText .. "\""
            else
                local IdleReasonName = Logic.GetHistoryIdleReasonName(IdleReason)
                local IdleReasonText = XGUIEng.GetStringTableText("UI_TaskHistory/" .. IdleReasonName)

                if IdleReasonText == "" then
                    IdleReasonText = IdleReasonName .. "{cr}[no text key]"
                end

                Text = Text .. "\"" .. IdleReasonText .. "\""
            end
            if HistoryIndex ~= NumOfTasksInHistory then
                Text = Text .. "{cr}{@color:51,51,120,100}-------------------{cr}"
            end
        end
        
        --end
    end

    XGUIEng.SetText(XGUIEng.GetCurrentWidgetID(), Text)
    XGUIEng.SliderSetToMax("/InGame/Root/Normal/AlignBottomRight/Selection/Settler/CurrentTaskSlider")
end


function GUI_BuildingInfo.BuildingNameUpdate()

    local CurrentWidgetID = XGUIEng.GetCurrentWidgetID()

    local EntityID = GUI.GetSelectedEntity()

    if EntityID == 0 or EntityID == nil then
        return
    end
    
    local EntityType = Logic.GetEntityType(EntityID)
    
    if Logic.IsLeader(EntityID) == 1 then
        EntityType = Logic.LeaderGetSoldiersType(EntityID)        
    end

    local EntityName = Logic.GetEntityTypeName(EntityType)

    local BuildingName = XGUIEng.GetStringTableText("UI_ObjectNames/" .. EntityName)

    if BuildingName == "" then
        BuildingName = EntityName
    end

    --if Logic.IsKnight(EntityID) then
    --    local TitleName = GUI_Knight.GetCurrentKnightTitleName(GUI.GetPlayerID())
    --    BuildingName = TitleName .. " " ..BuildingName
    --end
    
    XGUIEng.SetText(CurrentWidgetID, "{center}" .. BuildingName)
end

--------------------------------------------------------------------------------
-- Needs Window

function GUI_BuildingInfo.NeedUpdate()

    local CurrentWidgetID = XGUIEng.GetCurrentWidgetID()
    local CurrentWidgetName = XGUIEng.GetWidgetNameByID(CurrentWidgetID)
    local MotherWidgetID = XGUIEng.GetWidgetsMotherID(CurrentWidgetID)
    local MotherWidgetName = XGUIEng.GetWidgetNameByID(MotherWidgetID)
    local NeedsName
    
    if MotherWidgetName == "Decoration" then
        NeedsName = "Wealth"
    elseif MotherWidgetName == "Cleanliness" then
        NeedsName = "Hygiene"
    else
        NeedsName = MotherWidgetName
    end
    
    local Need = Needs[NeedsName]
    local BuildingID = GetBuildingIDAlsoWhenWorkerIsSelected()
    
    if Logic.IsNeedActive(BuildingID, Need) == true then
        -- color the icon
        local IsNeedCritical = Logic.IsNeedCritical(BuildingID, Need)
        local IsNeedAttention = Logic.IsNeedAttention(BuildingID, Need)
        local HasFoundNoGoodForNeed = Logic.GetFoundNoGoodForNeed(BuildingID, Need)
                    
        if IsNeedCritical == true and HasFoundNoGoodForNeed == true then
            XGUIEng.SetMaterialColor(CurrentWidgetID,0,240,10,10,255)
        elseif IsNeedAttention == true and HasFoundNoGoodForNeed == true then
            XGUIEng.SetMaterialColor(CurrentWidgetID,0,255,220,20,255)
        else
            XGUIEng.SetMaterialColor(CurrentWidgetID,0,255,255,255,255)
        end

        if CurrentWidgetName == "Bar" then
            local State = Logic.GetNeedState(BuildingID, Need)
            local AttentionThreshold   = Logic.GetNeedAttentionThreshold(BuildingID, Need)
            local CriticalThreshold = Logic.GetNeedCriticalThreshold(BuildingID, Need)

            --trade goods can be more effective. So if the current state is higher 0.7 we know the settlers has comsumed a trade good
            local Maximum = 0.8
            local CurrentState = State
            
            --for outer rim the threshold higher, so we substract the difference, so the bar shows the same scale as city buildings
            if Logic.IsEntityInCategory(BuildingID, EntityCategories.OuterRimBuilding) == 1 then                    
                Maximum = Maximum - CriticalThreshold
                CurrentState = CurrentState - CriticalThreshold
            end             
            
            XGUIEng.SetProgressBarValues(CurrentWidgetID,CurrentState,Maximum)
            
            --debug info
            local ValueWidget = XGUIEng.GetWidgetPathByID(XGUIEng.GetWidgetsMotherID(CurrentWidgetID)) .. "/Value"

            if Debug_EnableDebugOutput then
                local Value = Round(State* 10) 
                local ThresholdValue = Round(AttentionThreshold*10)
                local CriticalValue = Round(CriticalThreshold*10)

                XGUIEng.SetText(ValueWidget, "{center}" .. Value .. "/" ..ThresholdValue .. "/" .. CriticalValue)
            else
                XGUIEng.SetText(ValueWidget, "")
            end
        end
    else
        XGUIEng.SetMaterialColor(CurrentWidgetID,0,255,255,255,50)
    end
end


function GUI_BuildingInfo.ProsperityUpdate()
    
    local CurrentWidgetID = XGUIEng.GetCurrentWidgetID()
    local EntityID = GetBuildingIDAlsoWhenWorkerIsSelected()
    
    --if not (EnableRights == nil
    --or EnableRights == false
    --or Logic.TechnologyGetState(GUI.GetPlayerID(),Technologies.R_Prosperity) == TechnologyStates.Researched) then
    
    if Logic.IsNeedActive(EntityID, Needs.Prosperity) == false then
        XGUIEng.SetTextAlpha(CurrentWidgetID, 100)
        local Text = XGUIEng.GetStringTableText("UI_Texts/ProsperityNotActive_center")
        XGUIEng.SetText(CurrentWidgetID, Text)
        return
    else
        XGUIEng.SetTextAlpha(CurrentWidgetID, 255)
    end
    
    if Logic.GetBuildingProsperityIndex(EntityID) == 1 then
        local Text = XGUIEng.GetStringTableText("UI_Texts/ProsperityRich_center")
        XGUIEng.SetText(CurrentWidgetID, Text)
    else
        local Text = XGUIEng.GetStringTableText("UI_Texts/ProsperityPoor_center")
        XGUIEng.SetText(CurrentWidgetID, Text)
    end
    
    
end


function GUI_BuildingInfo.UpgradeUpdate()

    local CurrentWidgetID = XGUIEng.GetCurrentWidgetID()
    local BuildingID = GetBuildingIDAlsoWhenWorkerIsSelected()--GUI.GetSelectedEntity()

    local UpgradeLevel = Logic.GetUpgradeLevel(BuildingID)
    local UpgradeLimit = Logic.GetMaxUpgradeLevel(BuildingID)

    local Text = XGUIEng.GetStringTableText("UI_Texts/BuildingUpgradeLevel")

    if UpgradeLimit ~= 0 then
        Text = "{center}" .. Text .. " " .. UpgradeLevel+1 .."/" .. UpgradeLimit+1
    else
        Text = "{center}" .. Text .. " 1/1"
    end

    if Logic.IsSettler(GUI.GetSelectedEntity()) == 1 then
        Text = ""
    end
    
    XGUIEng.SetText(CurrentWidgetID, Text)
end


function GUI_BuildingInfo.TaxesUpdate()

    local CurrentWidgetID = XGUIEng.GetCurrentWidgetID()

    local EntityID = GetBuildingIDAlsoWhenWorkerIsSelected()--GUI.GetSelectedEntity()
    --local GoldAmount = Logic.GetTaxAmountForBuilding(EntityID)
    local GoldAmount = Logic.GetBuildingTaxAmount(EntityID)

    XGUIEng.SetText(CurrentWidgetID, "{right}" .. GoldAmount)
end


function GUI_BuildingInfo.EarningsUpdate()

    local CurrentWidgetID = XGUIEng.GetCurrentWidgetID()
    local MotherWidgetID = XGUIEng.GetWidgetsMotherID(CurrentWidgetID)
    local EntityID = GetBuildingIDAlsoWhenWorkerIsSelected()--GUI.GetSelectedEntity()
    local Earnings = Logic.GetBuildingProductEarnings(EntityID)
    local MaxEarnings = Logic.GetMaxBuildingEarnings(EntityID)
    
    if Logic.IsEntityInCategory(EntityID, EntityCategories.OuterRimBuilding) == 1 then
        XGUIEng.ShowWidget(MotherWidgetID,0)
    end
    
    if Earnings == nil then
        Earnings = 0
    end

    XGUIEng.SetText(CurrentWidgetID, "{right}" .. Earnings .. "/" .. MaxEarnings)
end


function GUI_BuildingInfo.JumpToBuildingClicked()

    Sound.FXPlay2DSound( "ui\\menu_click")

    local SelectedEntityID = GUI.GetSelectedEntity()
    local BuildingID = Logic.GetSettlersWorkBuilding(SelectedEntityID)

    if BuildingID == nil or BuildingID == 0 then
        BuildingID = SelectedEntityID
    end

    local x,y = Logic.GetEntityPosition(BuildingID)
    
    GUI.SetSelectedEntity(BuildingID)
    Camera.RTS_SetLookAtPosition(x,y)
end


g_LastSelectedInhabitant = nil

function GUI_BuildingInfo.JumpToWorkerClicked()
    local LastSelected = g_LastSelectedInhabitant
    
    Sound.FXPlay2DSound( "ui\\menu_click")

    local SelectedEntityID = GUI.GetSelectedEntity()
    local InhabitantsBuildingID = 0
    local IsSettlerSelected

    if Logic.IsBuilding(SelectedEntityID) == 1 then
        InhabitantsBuildingID = SelectedEntityID
        IsSettlerSelected = false
    else
        if Logic.IsWorker(SelectedEntityID) == 1
        or Logic.IsSpouse(SelectedEntityID) == true
        or Logic.GetEntityType(SelectedEntityID) == Entities.U_Priest then
            InhabitantsBuildingID = Logic.GetSettlersWorkBuilding(SelectedEntityID)
            IsSettlerSelected = true
        end
    end

    if InhabitantsBuildingID ~= 0 then
        local WorkersAndSpousesInBuilding = {Logic.GetWorkersAndSpousesForBuilding(InhabitantsBuildingID)}
        local InhabitantID
        
        if g_CloseUpView.Active == false
        and IsSettlerSelected == true then
            InhabitantID = SelectedEntityID
        else
            local InhabitantPosition = 1
            
            for i = 1, #WorkersAndSpousesInBuilding do
                if WorkersAndSpousesInBuilding[i] == g_LastSelectedInhabitant then
                    InhabitantPosition = i + 1
                    break
                end
            end

            InhabitantID = WorkersAndSpousesInBuilding[InhabitantPosition]
            
            if InhabitantID == 0 then
                InhabitantID = WorkersAndSpousesInBuilding[InhabitantPosition + 1]
            end
        end

        if InhabitantID == nil then
            local x,y = Logic.GetEntityPosition(InhabitantsBuildingID)
            --Camera.RTS_SetLookAtPosition(x,y)
            
            g_LastSelectedInhabitant = nil
            ShowCloseUpView(0, x, y)
            GUI.SetSelectedEntity(InhabitantsBuildingID)
        else
            GUI.SetSelectedEntity(InhabitantID)
            ShowCloseUpView(InhabitantID)
            g_LastSelectedInhabitant = InhabitantID
        end
    end
end


--------------------------------------------------------------------------------
-- Production Window

function GUI_BuildingInfo.InStockTypeUpdate(_index)

    local EntityID = GetBuildingIDAlsoWhenWorkerIsSelected()
    local CurrentWidgetID = XGUIEng.GetCurrentWidgetID()

    local MotherContainer= XGUIEng.GetWidgetsMotherID(CurrentWidgetID)

    local AmountWidgetName = XGUIEng.GetWidgetPathByID(MotherContainer) .. "/Amount"

    if EntityID == 0 or EntityID == nil then
        return
    end

    local NumGoodTypes = Logic.GetNumberOfGoodTypesOnInStock(EntityID)

    if NumGoodTypes == nil or NumGoodTypes == 0 or _index + 1 > NumGoodTypes then
        XGUIEng.ShowWidget(MotherContainer, 0)
        return
    else
        XGUIEng.ShowWidget(MotherContainer, 1)
    end

    local GoodAmount = Logic.GetAmountOnInStockByIndex(EntityID, _index)
    local GoodType = Logic.GetGoodTypeOnInStockByIndex(EntityID, _index)

    SetIcon(CurrentWidgetID, g_TexturePositions.Goods[GoodType])

    XGUIEng.SetText(AmountWidgetName, "{center}" .. GoodAmount)
end


function GUI_BuildingInfo.InstockTooltipMouseOver(_index)

    local EntityID = GetBuildingIDAlsoWhenWorkerIsSelected()
    local GoodType = Logic.GetGoodTypeOnInStockByIndex(EntityID, _index)
    local GoodTypeName = Logic.GetGoodTypeName(GoodType)
    
    GUI_Tooltip.TooltipNormal(GoodTypeName)
end


function GUI_BuildingInfo.OutstockTooltipMouseOver()

    local EntityID = GetBuildingIDAlsoWhenWorkerIsSelected()
    local GoodType = Logic.GetGoodTypeOnOutStockByIndex(EntityID, 0)
    local GoodTypeName = Logic.GetGoodTypeName(GoodType)

    GUI_Tooltip.TooltipNormal(GoodTypeName)
end


function GUI_BuildingInfo.GathererTooltipMouseOver()

    local EntityID = GetBuildingIDAlsoWhenWorkerIsSelected()--GUI.GetSelectedEntity()
    local CurrentWidgetID = XGUIEng.GetCurrentWidgetID()
    
    local GoodType, Amount = Logic.GetBuildingProduct(EntityID)
    
    local GoodTypeName = Logic.GetGoodTypeName(GoodType)
    
    --UpdateTooltip("Source_" .. GoodTypeName)
end


function GUI_BuildingInfo.OutStockTypeUpdate()

    local EntityID = GetBuildingIDAlsoWhenWorkerIsSelected()--GUI.GetSelectedEntity()
    local CurrentWidgetID = XGUIEng.GetCurrentWidgetID()
    local MotherContainer= XGUIEng.GetWidgetsMotherID(CurrentWidgetID)

    local AmountWidgetName = XGUIEng.GetWidgetPathByID(MotherContainer) .. "/OutstockAmount"

    if EntityID == 0 or EntityID == nil then
        return
    end

    local NumGoodTypes = Logic.GetNumberOfGoodTypesOnOutStock(EntityID)

    if NumGoodTypes == nil or NumGoodTypes == 0 then
        XGUIEng.ShowWidget(MotherContainer, 0)
        return
    else
        XGUIEng.ShowWidget(MotherContainer, 1)
    end

    local GoodAmount = Logic.GetAmountOnOutStockByIndex(EntityID, 0)
    local GoodType = Logic.GetGoodTypeOnOutStockByIndex(EntityID, 0)
    local GoodTypeName = Logic.GetGoodTypeName(GoodType)

    local GoodLimit = Logic.GetMaxAmountOnStock(EntityID)

    SetIcon(CurrentWidgetID, g_TexturePositions.Goods[GoodType])

    XGUIEng.SetText(AmountWidgetName, "{center}" .. GoodAmount .. "/" .. GoodLimit)
end


function GUI_BuildingInfo.WealthObjectUpdate()

    local CurrentWidgetID = XGUIEng.GetCurrentWidgetID()
    local WidgetName = XGUIEng.GetWidgetNameByID(CurrentWidgetID)

    local GoodType = Goods[WidgetName]
    local EntityID = GetBuildingIDAlsoWhenWorkerIsSelected()
    local MaxTime = Logic.GetMaxTimeTillBuildingWealthGoodExpires(GoodType)
    local TimeLeft = Logic.GetTimeTillBuildingWealthGoodExpires(EntityID, GoodType)

    if Logic.IsNeedActive(EntityID, Needs.Wealth) == false then
        XGUIEng.SetMaterialColor(CurrentWidgetID, 0, 120,120,120,50)
    elseif TimeLeft == 0 then
        XGUIEng.SetMaterialColor(CurrentWidgetID, 0, 120,120,120,180)
    else
        XGUIEng.SetMaterialColor(CurrentWidgetID, 0, 255,255,255,255)
    end
end


function GetBuildingIDAlsoWhenWorkerIsSelected()

    local EntityID = GUI.GetSelectedEntity()
    
    if  Logic.IsWorker(EntityID) == 1
    or Logic.IsSpouse(EntityID) == true then
        EntityID = Logic.GetSettlersWorkBuilding(EntityID)    
        if EntityID == 0 then
            --XGUIEng.ShowWidget("/InGame/Root/Normal/BuildingInfo",0)
            --XGUIEng.ShowWidget("/InGame/Root/Normal/AlignBottomRight/Selection/Info",0)
        end
    end

    return EntityID
end


function GUI_BuildingInfo.BuildingStoppedUpdate()

    local EntityID = GUI.GetSelectedEntity()

    if Logic.IsBuildingStopped(EntityID) == true then
        XGUIEng.SetMaterialColor(XGUIEng.GetCurrentWidgetID(),0,255, 255, 255,255)
    else
        XGUIEng.SetMaterialColor(XGUIEng.GetCurrentWidgetID(),0,255, 255, 255,0)
    end
end


--Taxation
function GUI_BuildingInfo.TaxesAmountUpdate()
    local CurrentWidgetID = XGUIEng.GetCurrentWidgetID()
    local PlayerID = GUI.GetPlayerID()

    local TaxationLevel = Logic.GetTaxationLevel(PlayerID)
    local OverallTaxes = Logic.GetEstimatedTax(PlayerID, TaxationLevel)

    XGUIEng.SetText(CurrentWidgetID, "{center}+ " .. OverallTaxes)
end


function GUI_BuildingInfo.TaxationLevelSliderChanged()
    local CurrentWidgetID = XGUIEng.GetCurrentWidgetID()
    local PlayerID = GUI.GetPlayerID()
    local TaxationLevel = Logic.GetTaxationLevel(PlayerID)
    local TaxationSliderLevel = XGUIEng.SliderGetValueAbs(CurrentWidgetID)
     
    if TaxationLevel ~= TaxationSliderLevel then
        GUI.SetTaxationLevel(PlayerID, TaxationSliderLevel)
    end
end


function GUI_BuildingInfo.TaxationLevelSliderUpdate()
    local CurrentWidgetID = XGUIEng.GetWidgetID("/InGame/Root/Normal/AlignBottomRight/Selection/Castle/Treasury/Taxes/TaxesSlider")
    local PlayerID = GUI.GetPlayerID()
    local TaxationLevel = Logic.GetTaxationLevel(PlayerID)
    local TaxationSliderLevel = XGUIEng.SliderGetValueAbs(CurrentWidgetID)
    
    if TaxationLevel ~= TaxationSliderLevel then
        XGUIEng.SliderSetValueAbs(CurrentWidgetID, TaxationLevel)
    end
end


-- Payment
function GUI_BuildingInfo.PaymentLevelSliderChanged()
    local CurrentWidgetID = XGUIEng.GetCurrentWidgetID()
    local PlayerID = GUI.GetPlayerID()
    local PaymentLevel = PlayerSoldierPaymentLevel[PlayerID]
    local PaymentSliderLevel = XGUIEng.SliderGetValueAbs(CurrentWidgetID)

    if PaymentLevel ~= PaymentSliderLevel then
        GUI.SetSoldierPaymentLevel(PaymentSliderLevel)
    end
end


function GUI_BuildingInfo.PaymentLevelSliderUpdate()
    local CurrentWidgetID = XGUIEng.GetWidgetID("/InGame/Root/Normal/AlignBottomRight/Selection/Castle/Treasury/Payment/PaymentSlider")
    local PlayerID = GUI.GetPlayerID()
    local PaymentLevel = PlayerSoldierPaymentLevel[PlayerID]
    local PaymentSliderLevel = XGUIEng.SliderGetValueAbs(CurrentWidgetID)
    
    if PaymentLevel ~= PaymentSliderLevel then
        XGUIEng.SliderSetValueAbs(CurrentWidgetID, PaymentLevel)
    end
end


function GUI_BuildingInfo.CastleSlidersUpdate()
    local PlayerID = GUI.GetPlayerID()
    local MotherContainerPath = XGUIEng.GetWidgetPathByID(XGUIEng.GetWidgetsMotherID(XGUIEng.GetCurrentWidgetID()))
    local TaxationSliderPath = MotherContainerPath .. "/Taxes/TaxesSlider"
    local PaymentSliderPath = MotherContainerPath .. "/Payment/PaymentSlider"
    
    if EnableRights == nil
    or EnableRights == false
    or Logic.TechnologyGetState(PlayerID, Technologies.R_Taxes) == TechnologyStates.Researched then
        XGUIEng.DisableSlider(TaxationSliderPath, 0)
    else
        XGUIEng.DisableSlider(TaxationSliderPath, 1)
    end

    if EnableRights == nil
    or EnableRights == false
    or Logic.TechnologyGetState(PlayerID, Technologies.R_Military) == TechnologyStates.Researched then
        XGUIEng.DisableSlider(PaymentSliderPath, 0)
    else
        XGUIEng.DisableSlider(PaymentSliderPath, 1)
    end
end




--marked for deletion, except if someone wants these buttons in the game again

--function GUI_BuildingInfo.StartStopHuntUpdate(_Index)
--    local CurrentWidgetID = XGUIEng.GetCurrentWidgetID()
--    local BuildingID = GUI.GetSelectedEntity()
--
--    local Category = Logic.GetOptionalHuntableCategory(BuildingID, _Index)
--
--    --Change icon
--    local Icon
--
--    if Logic.GetOptionalHuntableState(BuildingID, _Index) == false then
--        Icon = {4, 3} --don't hunt sheep
--    else
--        Icon = {4, 1} --hunt sheep
--    end
--
--    if Category == EntityCategories.CattlePasture then
--        if Logic.GetOptionalHuntableState(BuildingID, _Index) == false then
--            Icon = {4, 2} --don't hunt cows
--        else
--            Icon = {3, 16} --hunt cows
--        end
--    end
--
--    SetIcon(CurrentWidgetID, Icon)
--end
--
--
--function GUI_BuildingInfo.StartStopHuntClicked(_Index)
--    
--    Sound.FXPlay2DSound( "ui\\menu_click")
--
--    local CurrentWidgetID = XGUIEng.GetCurrentWidgetID()
--    local BuildingID = GUI.GetSelectedEntity()
--
--    local State = false
--
--    if Logic.GetOptionalHuntableState(BuildingID, _Index) == false then
--        State = true
--    end
--
--    GUI.SetOptionalHuntableState(BuildingID, _Index, State)
--end
