if CameraAnimation == nil then

    CameraAnimation = {}
    CameraAnimation.Queue = {}
    CameraAnimation.AllowAbort = true
    CameraAnimation.Running = false
    XGUIEng.ShowWidget("/InGame/Root/Normal/AnimatedCameraMovement", 1)

    CameraAnimation.WidgetsToHide = {}

    CameraAnimation.WidgetsToHide[#CameraAnimation.WidgetsToHide + 1] = "/InGame/Root/Normal/AlignBottomRight/BuildMenu"
    CameraAnimation.WidgetsToHide[#CameraAnimation.WidgetsToHide + 1] = "/InGame/Root/Normal/AlignBottomRight/MapFrame"
    CameraAnimation.WidgetsToHide[#CameraAnimation.WidgetsToHide + 1] = "/InGame/Root/Normal/AlignTopRight"
    CameraAnimation.WidgetsToHide[#CameraAnimation.WidgetsToHide + 1] = "/InGame/Root/Normal/AlignBottomLeft/Message/MessagePortrait/Buttons"
    CameraAnimation.WidgetsToHide[#CameraAnimation.WidgetsToHide + 1] = "/InGame/Root/Normal/AlignBottomLeft/Message/MessagePortrait/SpeechStartAgainOrStop"
    CameraAnimation.WidgetsToHide[#CameraAnimation.WidgetsToHide + 1] = "/InGame/Root/3dOnScreenDisplay"

end

function CameraAnimation.IsRunning()
    return CameraAnimation.Running
end

function CameraAnimation.UpdateCamera()

    if XGUIEng.IsWidgetShown("/InGame/Root/Normal/AnimatedCameraMovement") == 0 then
        XGUIEng.ShowWidget("/InGame/Root/Normal/AnimatedCameraMovement", 1)
    end

    -- move to Position
    if CameraAnimation.CameraMoveToX ~= nil and CameraAnimation.CameraMoveToY ~= nil then

        local LookAtX, LookAtY = Camera.RTS_GetLookAtPosition()

        local Distance = CameraAnimation.GetMoveToLength()

        if CameraAnimation.CameraMoveToLastDistance >= Distance  then

            local DeltaTime = (Logic.GetTimeMs()/1000) - CameraAnimation.CameraStartTime
            local Speed = CameraAnimation.CameraMoveToSpeed

            local NewX = LookAtX + CameraAnimation.DirectionX * DeltaTime * Speed
            local NewY = LookAtY + CameraAnimation.DirectionY * DeltaTime * Speed

            Camera.RTS_SetLookAtPosition(NewX, NewY)

            CameraAnimation.CameraStartTime = Logic.GetTimeMs()/1000
            CameraAnimation.CameraMoveToLastDistance = Distance

        else

            Camera.RTS_SetLookAtPosition(CameraAnimation.CameraMoveToX, CameraAnimation.CameraMoveToY )

            CameraAnimation.CameraMoveToX = nil
            CameraAnimation.CameraMoveToY = nil

        end
    end

    -- zoom to factor
    if CameraAnimation.TargetZoomFactor ~= nil then

        local CurrentZoomFactor = Camera.RTS_GetZoomFactor()
        CurrentZoomFactor = (math.floor(CurrentZoomFactor * 100))/ 100

        if CameraAnimation.TargetZoomFactor ~= CurrentZoomFactor then

            local NewZoomFactor

            if CameraAnimation.TargetZoomFactor > CurrentZoomFactor then
                NewZoomFactor = CurrentZoomFactor + 0.011
            else
                NewZoomFactor = CurrentZoomFactor - 0.005
            end

            Camera.RTS_SetZoomFactor(NewZoomFactor)

        else

            CameraAnimation.TargetZoomFactor = nil

        end

    end

    -- rotate to factor
    if CameraAnimation.TargetRotationAngle ~= nil then

        local CurrentRotationAngle = Camera.RTS_GetRotationAngle()
        CurrentRotationAngle = math.floor(CurrentRotationAngle)

        if CurrentRotationAngle ~= CameraAnimation.TargetRotationAngle then

            local NewRotationAngle

            if CameraAnimation.TargetRotationAngle  > CurrentRotationAngle then
                NewRotationAngle = CurrentRotationAngle + 0.05
            else
                NewRotationAngle = CurrentRotationAngle - 0.05
            end

            Camera.RTS_SetRotationAngle(NewRotationAngle)

        else

            CameraAnimation.TargetRotationAngle = nil

        end
    end

    -- rotate around a point
    if CameraAnimation.ContinuousRotation ~= nil then

        if CameraAnimation.ContinuousRotationCyclesDone < CameraAnimation.ContinuousRotationCycles then

            local CurrentRotationAngle = Camera.RTS_GetRotationAngle()

            local NewRotationAngle = CurrentRotationAngle - 0.05
            Camera.RTS_SetRotationAngle(NewRotationAngle)

            if CameraAnimation.ContinuousRotationStartAngle + 0.05 == CurrentRotationAngle then
                CameraAnimation.ContinuousRotationCyclesDone = CameraAnimation.ContinuousRotationCyclesDone + 0.05
            end

        else
            CameraAnimation.ContinuousRotation = nil
        end

    end

    -- follow entity
    if CameraAnimation.FollowEntityStopTime ~= nil then

        if Logic.GetTime() >= CameraAnimation.FollowEntityStopTime then
            CameraAnimation.FollowEntityStopTime = nil
            CameraAnimation.FollowEntityID = nil
        else
            local x,y = Logic.GetEntityPosition(CameraAnimation.FollowEntityID )
            Camera.RTS_SetLookAtPosition( x,y )
        end
    end

    -- stay a certain time
    if CameraAnimation.StayTime ~= nil then
        if Logic.GetTime() >= CameraAnimation.StayTime then
            CameraAnimation.StayTime = nil
        end

    end


    if  CameraAnimation.TargetRotationAngle == nil
    and CameraAnimation.TargetZoomFactor == nil
    and CameraAnimation.CameraMoveToX == nil
    and CameraAnimation.CameraMoveToY == nil
    and CameraAnimation.ContinuousRotation == nil
    and CameraAnimation.FollowEntityStopTime == nil
    and CameraAnimation.StayTime == nil then

        CameraAnimation.DeactivateGUIForCameraAnimation( )
        CameraAnimation.StartNextAnimationInQueue()

    end

end

function CameraAnimation.FollowEntity( _EntityID, _Length )

    CameraAnimation.ActivateGUIForCameraAnimation(  )

    CameraAnimation.FollowEntityStopTime = Logic.GetTimeMs()/1000 + _Length

    CameraAnimation.FollowEntityID = _EntityID

end


function CameraAnimation.MoveCameraToEntity(_Entity, _Speed)

    if type(_Entity) == "string" then
		_Entity = Logic.GetEntityIDByName(_Entity)
	else
		_Entity = _Entity
	end

    local PosX, PosY = Logic.GetEntityPosition(_Entity)

    CameraAnimation.MoveCameraToPosition(PosX, PosY, _Speed)

end


function CameraAnimation.SetCameraToEntity(_Entity)

    if type(_Entity) == "string" then
		_Entity = Logic.GetEntityIDByName(_Entity)
	else
		_Entity = _Entity
	end

    local PosX, PosY = Logic.GetEntityPosition(_Entity)

    CameraAnimation.CameraMoveToX = PosX
    CameraAnimation.CameraMoveToY = PosY

    CameraAnimation.CameraMoveToLastDistance = -1

end

function CameraAnimation.MoveCameraToPosition(_x, _y, _Speed)

    CameraAnimation.ActivateGUIForCameraAnimation()

    CameraAnimation.CameraMoveToX = _x
    CameraAnimation.CameraMoveToY = _y
    CameraAnimation.CameraStartTime = Logic.GetTimeMs()/1000

    if _Speed == nil then
        _Speed = 3000
    end

    CameraAnimation.CameraMoveToSpeed = _Speed

    local LookAtX, LookAtY = Camera.RTS_GetLookAtPosition()

    local DirectionX = CameraAnimation.CameraMoveToX - LookAtX
    local DirectionY = CameraAnimation.CameraMoveToY - LookAtY

    local Length = math.sqrt(DirectionX*DirectionX + DirectionY*DirectionY)

    CameraAnimation.DirectionX = DirectionX / Length
    CameraAnimation.DirectionY = DirectionY / Length

    if Length == 0 then
        CameraAnimation.DirectionX = LookAtX
        CameraAnimation.DirectionY = LookAtY
    end

    CameraAnimation.CameraMoveToLastDistance = Length

end


function CameraAnimation.GetMoveToLength()

    local LookAtX, LookAtY = Camera.RTS_GetLookAtPosition()

    local DirectionX = CameraAnimation.CameraMoveToX - LookAtX
    local DirectionY = CameraAnimation.CameraMoveToY - LookAtY

    local Length = math.sqrt(DirectionX*DirectionX + DirectionY*DirectionY)

    return Length

end

function CameraAnimation.ZoomCameraToFactor( _ZoomFactor )

    CameraAnimation.ActivateGUIForCameraAnimation( )

    if _ZoomFactor < 0.05 then
        _ZoomFactor = 0.05
    end

    if _ZoomFactor > 0.5 then
        _ZoomFactor = 0.5
    end

    CameraAnimation.ZoomStartTime = Logic.GetTimeMs()/1000
    CameraAnimation.TargetZoomFactor = (math.floor(_ZoomFactor * 100))/ 100

end


function CameraAnimation.Stay( _Length )

    CameraAnimation.ActivateGUIForCameraAnimation( )

    CameraAnimation.StayTime = Logic.GetTimeMs()/1000 + _Length

end

function CameraAnimation.RotateCameraToAngle( _RotationAngle)

    CameraAnimation.ActivateGUIForCameraAnimation( )

    CameraAnimation.RotationStartTime = Logic.GetTimeMs()/1000
    CameraAnimation.TargetRotationAngle = _RotationAngle

end


function CameraAnimation.StartCameraRotation( _Cycles )

    CameraAnimation.ActivateGUIForCameraAnimation( )

    CameraAnimation.ContinuousRotation = true

    CameraAnimation.ContinuousRotationCycles = _Cycles
    CameraAnimation.ContinuousRotationCyclesDone = 0
    CameraAnimation.ContinuousRotationStartAngle = Camera.RTS_GetRotationAngle()

end


function CameraAnimation.ActivateGUIForCameraAnimation()

    Game.GameTimeReset(GUI.GetPlayerID())

    Input.CutsceneMode()

    GUI.CancelState()

    Camera.RTS_ResetKeyboardMovement()

    XGUIEng.ShowWidget("/InGame/Root/Normal/AnimatedCameraBars", 1)

    XGUIEng.ShowWidget("/InGame/Root/Normal/AlignBottomLeft/Message/MessagePortrait/JumpToSender",0)

    for i = 1, #CameraAnimation.WidgetsToHide do
        XGUIEng.ShowWidget(CameraAnimation.WidgetsToHide[i], 0)
    end
    XGUIEng.ShowWidget("/InGame/Root/Normal/AlignBottomRight/WeatherMenu", 0)--hide but not shown after
    XGUIEng.ShowWidget("/InGame/Root/Normal/AlignBottomRight/HouseMenu/Dialog", 0)
    XGUIEng.ShowWidget("/InGame/Root/Normal/AlignBottomRight/KnightTitleMenu", 0)
    XGUIEng.ShowWidget("/InGame/Root/Normal/AlignTopCenter/KnightTitleMenuBig", 0)
    XGUIEng.ShowWidget("/InGame/Root/Normal/AlignBottomRight/DiplomacyMenu/Dialog", 0)
    XGUIEng.ShowWidget("/InGame/Root/Normal/AlignTopLeft/KnightCommands",0)

    CameraAnimation.Running = true

    GUI.ForbidContextSensitiveCommandsInSelectionState()

    if CameraAnimation.SelectedEntities == nil then
        CameraAnimation.SelectedEntities = { GUI.GetSelectedEntities() }
    end

    GUI.ClearSelection()

    Camera.CloseUp_SetDistanceMinMax(2500, 2500)
    Camera.CloseUp_SetDistance(2500)

    -- deactivate borderscrolling
    Camera.RTS_SetBorderScrollSize(0)


end



function CameraAnimation.DeactivateGUIForCameraAnimation( )

    if XGUIEng.IsWidgetShown("/InGame/Root/Normal/AnimatedCameraBars") == 1 then

        Input.GameMode()

        XGUIEng.ShowWidget("/InGame/Root/Normal/AnimatedCameraBars", 0)

        for i = 1, #CameraAnimation.WidgetsToHide do
            XGUIEng.ShowWidget(CameraAnimation.WidgetsToHide[i], 1)
        end
        if g_KnightCommandsVisible == true then
            XGUIEng.ShowWidget("/InGame/Root/Normal/AlignTopLeft/KnightCommands",1)
        end

        CameraAnimation.Running = false

        GUI.PermitContextSensitiveCommandsInSelectionState()

        CameraAnimation.ReselectEntitiesAfterCameraAnimation()

        -- set back distances
        Camera.CloseUp_SetDistanceMinMax(1000, 1000)
        Camera.CloseUp_SetDistance(1000)

        -- activate borderscrolling again
        Camera.RTS_SetBorderScrollSize(3)
    end

end


function CameraAnimation.ReselectEntitiesAfterCameraAnimation()

    if CameraAnimation.SelectedEntities ~= nil then
        for i = 1, #CameraAnimation.SelectedEntities do
            local ID = CameraAnimation.SelectedEntities[i]
            GUI.SelectEntity(ID)
        end

        if #CameraAnimation.SelectedEntities > 1 then
            GUI_MultiSelection.CreateMultiSelection(g_SelectionChangedSource.User)
        end

        CameraAnimation.SelectedEntities = nil
    end

end

function CameraAnimation.QueueAnimation( _Command, _Parameter1 , _Parameter2, _Parameter3 )

    table.insert( CameraAnimation.Queue, {_Command, _Parameter1 , _Parameter2, _Parameter3})

end

function CameraAnimation.StartNextAnimationInQueue()

    if CameraAnimation.Queue[1] ~= nil then
        local Table = CameraAnimation.Queue[1]

        local AnimationFunction  = Table[1]
        local Parameter1 = Table[2]
        local Parameter2 = Table[3]
        local Parameter3 = Table[4]

        AnimationFunction(Parameter1, Parameter2, Parameter3)

        table.remove( CameraAnimation.Queue, 1)
    else
        CameraAnimation.AllowAbort = true
    end

end

function CameraAnimation.Abort()

    if CameraAnimation.AllowAbort then

        CameraAnimation.TargetRotationAngle = nil
        CameraAnimation.TargetZoomFactor = nil
        CameraAnimation.CameraMoveToX = nil
        CameraAnimation.CameraMoveToY = nil
        CameraAnimation.ContinuousRotation = nil
        CameraAnimation.FollowEntityStopTime = nil
        CameraAnimation.StayTime = nil

        CameraAnimation.Queue = {}

        CameraAnimation.DeactivateGUIForCameraAnimation( )

        ShowCloseUpView(0)
    end

end
