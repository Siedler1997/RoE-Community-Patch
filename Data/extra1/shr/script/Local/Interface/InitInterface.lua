--------------------------------------------------------------------------
--        *****************INTERFACE *****************
--------------------------------------------------------------------------

-- load sub scripts
Script.Load("Script\\Local\\Interface\\FeedbackWidgets.lua")
Script.Load("Script\\Local\\Interface\\FeedbackSpeech.lua")
Script.Load("Script\\Local\\Interface\\TexturePositions.lua")
Script.Load("Script\\Local\\Interface\\Construction.lua")
Script.Load("Script\\Local\\Interface\\Feedback.lua")
Script.Load("Script\\Local\\Interface\\Goods.lua")
Script.Load("Script\\Local\\Interface\\Selection.lua")
Script.Load("Script\\Local\\Interface\\Time.lua")
Script.Load("Script\\Local\\Interface\\Knight.lua")
Script.Load("Script\\Local\\Interface\\BuildingButtons.lua")
Script.Load("Script\\Local\\Interface\\CloseUpView.lua")
Script.Load("Script\\Local\\Interface\\Merchant.lua")
Script.Load("Script\\Local\\Interface\\Tooltip.lua")
Script.Load("Script\\Local\\Interface\\Trade.lua")
Script.Load("Script\\Local\\Interface\\Chat.lua")
Script.Load("Script\\Local\\Interface\\CityOverview.lua")
Script.Load("Script\\Local\\Interface\\BuildingInfo.lua")
Script.Load("Script\\Local\\Interface\\GoodPriorities.lua")
Script.Load("Script\\Local\\Interface\\Windows.lua")
Script.Load("Script\\Local\\Interface\\Multiselection.lua")
Script.Load("Script\\Local\\Interface\\Military.lua")
Script.Load("Script\\Local\\Interface\\Minimap.lua")
Script.Load("Script\\Local\\Interface\\Buffs.lua")
Script.Load("Script\\Local\\Interface\\QuestLog.lua")
Script.Load("Script\\Local\\Interface\\Interaction.lua")
Script.Load("Script\\Local\\Interface\\Thief.lua")
Script.Load("Script\\Local\\Interface\\Hints.lua")

Script.Load("Script\\Local\\Interface\\DiplomacyMenu.lua")
Script.Load("Script\\Local\\Interface\\HouseMenu.lua")
Script.Load("Script\\Local\\Interface\\MissionStatistic.lua")



--for different versions
Script.Load("Script\\Local\\Interface\\InterfaceDev.lua")
--------------------------------------------------------------------------
--				TOOLS
--------------------------------------------------------------------------

function ColorYellow()
    return "{@color:255, 255, 0}"
end


function ColorRed()
    return "{@color:220, 0, 0}"
end


function ColorGreen()
    return "{@color:0, 255, 0}"
end


function ColorNone()
    return "{@color:none}"
end


function SetIcon(_Widget, _Coordinates, _OptionalIconSize )
    if _Coordinates == nil then

        if Debug_EnableDebugOutput then
            GUI.AddNote("Bug: no valid Icon available. Caused by invalid EntityType or GoodType, or a missing entry in TexturePositions.lua")

            if type(_Widget) == "string" then
                _Widget = XGUIEng.GetWidgetID(_Widget)
            end

            local WidgetPath = XGUIEng.GetWidgetPathByID(_Widget)
            GUI.AddNote("Widget: " .. WidgetPath)
        end

        _Coordinates = {16, 16}
        --return
    end

    local IsButton = XGUIEng.IsButton(_Widget)
    local WidgetState

    if IsButton == 1 then
        WidgetState = 7
    else
        WidgetState = 1
    end

    local IconSize

    if _Coordinates[1] == 16 and _Coordinates[2]==16 then
        XGUIEng.SetMaterialAlpha(_Widget, WidgetState, 0)
    else
        XGUIEng.SetMaterialAlpha(_Widget, WidgetState, 255)
        
        if _Coordinates[3] == nil
        or _Coordinates[3] == 0 then
		        if _OptionalIconSize == nil
		        or _OptionalIconSize == 64 then
		            IconSize = 64
		            XGUIEng.SetMaterialTexture(_Widget, WidgetState, "IconsBig.png")
		        elseif _OptionalIconSize == 44 then
		            IconSize = 44
		            XGUIEng.SetMaterialTexture(_Widget, WidgetState, "Icons.png")
		        elseif _OptionalIconSize == 128 then
		            IconSize = 128
		            XGUIEng.SetMaterialTexture(_Widget, WidgetState, "IconsVeryBig.png")
		        end
		    else
		        if _OptionalIconSize == nil
		        or _OptionalIconSize == 64 then
		            IconSize = 64
		            XGUIEng.SetMaterialTexture(_Widget, WidgetState, "IconsBig2.png")
		        elseif _OptionalIconSize == 44 then
		            IconSize = 44
		            XGUIEng.SetMaterialTexture(_Widget, WidgetState, "Icons2.png")
		        elseif _OptionalIconSize == 128 then
                    --TODO HeAc: Create IconsVeryBig2 then uncomment
                    
                    --IconSize = 128
		            --XGUIEng.SetMaterialTexture(_Widget, WidgetState, "IconsVeryBig.png") -- TODO: veryBig2 not implemented yet
                    IconSize = 64
                    XGUIEng.SetMaterialTexture(_Widget, WidgetState, "IconsBig2.png")
		        end
		    end


        local u0 = (_Coordinates[1] - 1) * IconSize
        local v0 = (_Coordinates[2] - 1) * IconSize
        local u1 = _Coordinates[1] * IconSize
        local v1 = _Coordinates[2] * IconSize

        XGUIEng.SetMaterialUV(_Widget, WidgetState, u0, v0, u1, v1)
    end
end


function SetPlayerIcon(_PlayerID, _IconWidget, _ColorWidget, _OptionalIconSize)
    local PlayerCategory = GetPlayerCategoryType(_PlayerID)
    local PlayerIcon = g_TexturePositions.PlayerCategories[PlayerCategory]

    if PlayerCategory == nil then
        PlayerIcon = g_TexturePositions.PlayerCategories["Vikings"]
    end

    if _PlayerID == 0 then
        PlayerIcon = {13, 6}
    end

    SetIcon(_IconWidget, PlayerIcon, _OptionalIconSize)

    local R, G, B = GUI.GetPlayerColor(_PlayerID)

    if _PlayerID == 0
    or PlayerCategory == PlayerCategories.Harbour then
        R, G, B = 255, 255, 255
    end

    XGUIEng.SetMaterialColor(_ColorWidget, 0, R, G, B, 255)
end


function GetNameOfDiplomacyState(_DiplomacyState)
    local DiplomacyStateName

    if _DiplomacyState == 2 then
        DiplomacyStateName = XGUIEng.GetStringTableText("UI_Texts/DiplomacyStateAllied")

    elseif _DiplomacyState == 1 then
        DiplomacyStateName = XGUIEng.GetStringTableText("UI_Texts/DiplomacyStateTradeContact")

    elseif _DiplomacyState == 0 then
        DiplomacyStateName = XGUIEng.GetStringTableText("UI_Texts/DiplomacyStateEstablishedContact")

    elseif _DiplomacyState == -1 then
        DiplomacyStateName = XGUIEng.GetStringTableText("UI_Texts/DiplomacyStateUndecided")

    elseif _DiplomacyState == -2 then
        DiplomacyStateName = XGUIEng.GetStringTableText("UI_Texts/DiplomacyStateEnemy")
    end

    return DiplomacyStateName
end


function JumpToPositionOrCreateMinimapMarker(_PositionTableOrTerritoryID, _ShowOnlyOnMinimap)

    local X, Y
    local SignalType

    if type(_PositionTableOrTerritoryID) == "table" then
        X, Y = _PositionTableOrTerritoryID.X, _PositionTableOrTerritoryID.Y
        SignalType = 7
    else
        X, Y = GUI.ComputeTerritoryPosition(_PositionTableOrTerritoryID)
        SignalType = 5
    end

    local PlayerID = GUI.GetPlayerID()
    local IsInFoW = Logic.IsMapPositionExplored(PlayerID, X, Y)

    if IsInFoW == 1 and _ShowOnlyOnMinimap ~= true then
        Camera.RTS_SetLookAtPosition(X, Y)
        Camera.SwitchCameraBehaviour(0)
        --CameraAnimation.MoveCameraToPosition(X, Y)
    else
        GUI.CreateMinimapSignalRGBA(nil, X, Y, 255, 255, 255, 255, SignalType)
    end
end


function HideOtherMenus()
    GUI_Construction.CloseContextSensitiveMenu()
    XGUIEng.ShowWidget("/InGame/Root/Normal/AlignBottomRight/KnightTitleMenu", 0)
    XGUIEng.ShowWidget("/InGame/Root/Normal/AlignTopCenter/KnightTitleMenuBig", 0)
    XGUIEng.ShowWidget("/InGame/Root/Normal/AlignBottomRight/DiplomacyMenu/Dialog", 0)
    XGUIEng.ShowWidget("/InGame/Root/Normal/AlignBottomRight/HouseMenu/Dialog", 0)
    XGUIEng.ShowWidget("/InGame/Root/Normal/AlignBottomRight/WeatherMenu", 0)
end


--tutorial marker
function TutorialMarkerUpdate()

    if TutorialMarkerAlpha == nil then
        TutorialMarkerAlpha = 155
        TutorialMarkerDirection = -1
    end

    local CurrentWidgetID = XGUIEng.GetCurrentWidgetID()
    local Marker = "/InGame/Root/TutorialMarker"


    local WidgetSizeX, WidgetSizeY  = XGUIEng.GetWidgetScreenSize(TutorialMarkerTargetWidget)
    local MarkerSizeX, MarkerSizeY  = XGUIEng.GetWidgetScreenSize(Marker)

    local WidgetScreenPosX, WidgetScreenPosY = XGUIEng.GetWidgetScreenPosition(TutorialMarkerTargetWidget)

    local x = WidgetScreenPosX - ((MarkerSizeX - WidgetSizeX)/2)
    local y = WidgetScreenPosY - ((MarkerSizeY - WidgetSizeY)/2)

    XGUIEng.SetWidgetScreenPosition(Marker,x,y)


    TutorialMarkerAlpha = TutorialMarkerAlpha + (20 * TutorialMarkerDirection)

    if TutorialMarkerAlpha < 0 then
        TutorialMarkerAlpha = 0
        TutorialMarkerDirection = 1
    end

    if TutorialMarkerAlpha > 155 then
        TutorialMarkerAlpha = 155
        TutorialMarkerDirection = -1
    end

    --not nice, but it works
    if TutorialMarkerTargetWidgets ~= nil then
        for i=1, #TutorialMarkerTargetWidgets do

            local NextTargetWidget = TutorialMarkerTargetWidgets[i+1]

            local Mother = XGUIEng.GetWidgetsMotherID(NextTargetWidget)
            local GrandMother = XGUIEng.GetWidgetsMotherID(Mother)

            if      i +1 <= #TutorialMarkerTargetWidgets
                and XGUIEng.IsWidgetShown(NextTargetWidget) == 1
                and XGUIEng.IsWidgetShown(Mother) == 1
                and XGUIEng.IsWidgetShown(GrandMother) == 1 then


                ActivateTutorialMarker(NextTargetWidget)
                break
            else
                ActivateTutorialMarker(TutorialMarkerTargetWidgets[i])
                break
            end

        end
    else
        ActivateTutorialMarker(TutorialMarkerTargetWidget)
    end


    if      XGUIEng.IsWidgetShownEx(TutorialMarkerTargetWidget) == 0
        or GUI.GetCurrentStateName() == "PlaceWall"
        or GUI.GetCurrentStateName() == "PlaceWallGate"
        or GUI.GetCurrentStateName() == "PlaceBuilding"
        or GUI.GetCurrentStateName() == "PlaceRoad" then

        TutorialMarkerAlpha = 0
    end


    XGUIEng.SetMaterialColor(CurrentWidgetID, 0,255,255,255,TutorialMarkerAlpha)

end


function ActivateTutorialMarkerEx(_WidgetTable, _SecondWidget, _ThirdWidget)

    local WidgetTable = {}

    --HACK: Global state can not call a local function with a table
    if _SecondWidget ~= nil then
        WidgetTable = {_WidgetTable, _SecondWidget, _ThirdWidget}
    else
        WidgetTable = _WidgetTable
    end

    TutorialMarkerTargetWidgets = WidgetTable

    ActivateTutorialMarker(WidgetTable[1])

end


function ActivateTutorialMarker(_WidgetID)

    local Marker = "/InGame/Root/TutorialMarker"

    XGUIEng.ShowWidget(Marker, 1)

    TutorialMarkerTargetWidget = _WidgetID


end


function DeactivateTutorialMarker()

    local Marker = "/InGame/Root/TutorialMarker"
    XGUIEng.ShowWidget(Marker, 0)
    TutorialMarkerTargetWidgets = nil

end


function SaveButtonPressed(_CurrentWidgetID)

    local ButtonName = XGUIEng.GetWidgetPathByID(_CurrentWidgetID)

    Hints.ButtonClicked = ButtonName

    if Tutorial ~= nil then
        Tutorial.ButtonClicked = ButtonName
    end

end
--tutorial marker end


--special mission timer and counters
function RestoreMissionTimersAfterLoad()

    if g_MissionTimerEndTime ~= nil then
        XGUIEng.ShowWidget("/InGame/Root/Normal/MissionTimer", 1)
    end

    if g_MissionGoodOrEntityCounterAmountToReach ~= nil then

        StartMissionGoodOrEntityCounter(g_MissionGoodOrEntityCounterIcon, g_MissionGoodOrEntityCounterAmountToReach)

    end
end


function ShowMissionTimer(_TimeInSeconds)

    local CurrentTime = math.floor(Logic.GetTime())
    g_MissionTimerEndTime = CurrentTime + _TimeInSeconds

    XGUIEng.ShowWidget("/InGame/Root/Normal/MissionTimer", 1)
end

function HideMissionTimer()
    XGUIEng.ShowWidget("/InGame/Root/Normal/MissionTimer", 0)
end


function MissionTimerUpdate()
    local CurrentTime = math.floor(Logic.GetTime())
    local TimeLeft = g_MissionTimerEndTime - CurrentTime

    if TimeLeft < 0 then
        XGUIEng.ShowWidget("/InGame/Root/Normal/MissionTimer", 0)
        g_MissionTimerEndTime = nil
    else
        local TimeString = ConvertSecondsToString(TimeLeft)
        local Text = "{center}" .. TimeString
        XGUIEng.SetText("/InGame/Root/Normal/MissionTimer/Timer", Text)
    end
end


function StartMissionGoodCounter(_GoodType, _AmountToReach)
    local Icon = g_TexturePositions.Goods[_GoodType]
    StartMissionGoodOrEntityCounter(Icon, _AmountToReach)
end


function StartMissionEntityCounter(_EntityType, _AmountToReach)

    local Icon

    --hack for patch for map township rebellion: use a certain icon when entitytype is nil

    if _EntityType ~= nil then
        Icon = g_TexturePositions.Entities[_EntityType]
    else
        Icon = g_TexturePositions.QuestTypes["CreateMilitary"]
    end

    StartMissionGoodOrEntityCounter(Icon, _AmountToReach)
end


function StartMissionGoodOrEntityCounter(_Icon, _AmountToReach)
    SetIcon("/InGame/Root/Normal/MissionGoodOrEntityCounter/Icon", _Icon)

    g_MissionGoodOrEntityCounterAmountToReach = _AmountToReach
    g_MissionGoodOrEntityCounterIcon = _Icon

    XGUIEng.ShowWidget("/InGame/Root/Normal/MissionGoodOrEntityCounter", 1)
end


function MissionGoodOrEntityCounterUpdate()

    local CurrentAmount = MissionCounter.CurrentAmount
    local AmountToReach = g_MissionGoodOrEntityCounterAmountToReach

    if CurrentAmount > AmountToReach then
        XGUIEng.ShowWidget("/InGame/Root/Normal/MissionGoodOrEntityCounter", 0)
        g_MissionGoodOrEntityCounterAmountToReach = nil
    else
        local Text = "{center}" .. CurrentAmount .. "/" .. AmountToReach
        XGUIEng.SetText("/InGame/Root/Normal/MissionGoodOrEntityCounter/Counter", Text)
    end
end


function MissionGoodOrEntityCounterMouseOver()

    GUI_Tooltip.TooltipNormal(nil, nil, true)
end


function MissionTimerMouseOver()

    GUI_Tooltip.TooltipNormal(nil, nil, true)
end


function Play2DSound(_PlayerID, _Sound )

    if GUI.GetPlayerID() == _PlayerID then
        Sound.FXPlay2DSound("ui\\" .. _Sound )
    end
end

--special mission timer and counters end




--currently unused
--function JumpToPlayer(_PlayerID)
--    local CameraEntityID = Logic.GetKnightID(_PlayerID)
--
--    if CameraEntityID == nil or CameraEntityID == 0 then
--        CameraEntityID = Logic.GetHeadquarters(_PlayerID)
--    end
--
--    if CameraEntityID == nil or CameraEntityID == 0 then
--        CameraEntityID = Logic.GetStoreHouse(_PlayerID)
--    end
--
--    if _PlayerID == -1 then
--        local ShipsStorehouses = {Logic.GetEntities(Entities.B_NPC_ShipsStorehouse, 1)}
--        CameraEntityID = ShipsStorehouses[2]
--    end
--
--    if CameraEntityID ~= nil and CameraEntityID ~= 0 then
--        local pos = GetPosition(CameraEntityID)
--        Camera.RTS_SetLookAtPosition(pos.X, pos.Y)
--        Camera.SwitchCameraBehaviour(0)
--        --CameraAnimation.MoveCameraToPosition(pos.X, pos.Y)
--    else
--        GUI.AddNote("Debug: No Castle, Storehouse or Knight to jump to!")
--    end
--end
