
g_Camera.RPGCamEnabled = false

function EnableRPGMode(_entityToFollow)
    XGUIEng.ShowWidget("/InGame/Root/Normal",0)
    --[[
    Camera.RTS_FollowEntity(_entityToFollow)

	Camera.RTS_SetZoomFactorMin(0)
	Camera.RTS_SetZoomFactorMax(0.1)
	    
	Camera.RTS_SetZoomFactor(0.0)





    gvCamera.ZoomDistanceMin = 1800
        gvCamera.ZoomDistanceMax = 9000
        
    	gvCamera.ZoomAngleMax = 47
        gvCamera.ZoomAngleMin = 26
        
        gvCamera.ZoomFOVMin = 45  
        gvCamera.ZoomFOVMax = 48
    --]]
    lockMyCameraToPosition(_entityToFollow, 360, 0.1, 47)
    g_Camera.RPGCamEnabled = true
end

function lockMyCameraToPosition(_entity, _rotation, _zoomFactor, _zoomAngle )
    local posX1, posY1 = Logic.GetEntityPosition(Logic.GetEntityIDByName(_entity));
    local rotation1 = _rotation
    local zoomFactorMin = _zoomFactor - 0.000001
    local zoomFactorMax = _zoomFactor + 0.000001
    local zoomAngle1 = _zoomAngle
    
    local entityID = _entity
    
    if not GameCallback_Camera_GetBorderscrollFactor_OrigFocus then
        GameCallback_Camera_GetBorderscrollFactor_OrigFocus = GameCallback_Camera_GetBorderscrollFactor
        GameCallback_Camera_GetBorderscrollFactor = function() end
    end
    Camera.RTS_FollowEntity(entityID)
    Camera.RTS_SetRotationAngle(rotation1)
    Camera.RTS_SetZoomFactorMax(zoomFactorMax)
    Camera.RTS_SetZoomFactorMin(zoomFactorMin)
    Camera.RTS_SetZoomAngle(zoomAngle1)
    
end

function DisableRPGMode()
    XGUIEng.ShowWidget("/InGame/Root/Normal",1)

    g_Camera.RPGCamEnabled = false
end