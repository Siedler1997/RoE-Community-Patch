
-----------------------------------------------------------------------------------------
-- Overwrites for CameraAnimation
-----------------------------------------------------------------------------------------

function InitOverwriteCameraAnimationEx2()

	do
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
	end

end