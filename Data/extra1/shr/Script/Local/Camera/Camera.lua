--------------------------------------------------------------------------------
-- Camera scripting
--------------------------------------------------------------------------------

g_Camera = {}
g_Camera.RPGCamEnabled = false
--g_Camera.FadeInOffset = 0

FocusCamera = {}
FocusCamera.Activated = false
FocusCamera.MinZoomFactor = 0.0
FocusCamera.MaxZoomFactor = 0.5


-----------------------------------------------------------------------------------------------------------
function GameCallback_Camera_GetBorderscrollFactor()

    RealZoomFactor =  1.0 / (Camera.RTS_GetZoomFactorMax() - Camera.RTS_GetZoomFactorMin()) * (Camera.RTS_GetZoomFactor() - Camera.RTS_GetZoomFactorMin())

    return (1 + RealZoomFactor) * 0.5;

end

--------------------------------------------------------------------------------
-- GameCallBack from mouse wheel to calculate the zoom and the angle of the camera
--------------------------------------------------------------------------------
function GameCallback_Camera_CalculateZoom( _ZoomFactor )

	-- local Min = 0.0
	-- local Max = 0.5
	-- local Range = Max - Min
	
	-- local RealZoom = (_ZoomFactor - Min) * (1 / Range)
	
    -- [ArCl] AnSu / KoBo : Move this somewhere else so I can remove this callback
    
	if g_CameraShaker ~= nil and g_CameraShaker.Trigger == 1 then
	    ShakeCamera()
	end

    -- [ArCl] Any changes to Distance, Angle, FOV made here will have no effect anymore
    -- Ask me if something has to change on the camera settings
    
	--if gvCamera.DefaultFlag >= 1 then
				
        -- local ZoomDistance = gvCamera.ZoomDistanceMin + (gvCamera.ZoomDistanceMax - gvCamera.ZoomDistanceMin) *  RealZoom*RealZoom
        -- local Angle = gvCamera.ZoomAngleMin + (gvCamera.ZoomAngleMax - gvCamera.ZoomAngleMin) * (RealZoom*RealZoom)
        -- local FoV = gvCamera.ZoomFOVMin + (gvCamera.ZoomFOVMax - gvCamera.ZoomFOVMin) * RealZoom
        
        --if (PlaceBuildingStateActivated == true) then
        --
        --    Angle = 75
        --    
        --    --ZoomDistance = gvCamera.ZoomDistanceMin + gvCamera.ZoomDistanceMax
        --    
        --    FoV = gvCamera.ZoomFOVMax
        --
        --end
        
        --if g_PostCardMode == true then
        --    
        --    Angle = 19
        --    
        --    ZoomDistance = 12000
        --    
        --    FoV = 58
        --    
        --end
        
        -- Camera.RTS_SetZoomDistance(ZoomDistance)
        -- Camera.RTS_SetZoomAngle(Angle)
        -- Camera.RTS_SetFOV(FoV)
           
        -- if (GUI ~= nil) then    
        --    GUI.OnScreenSetVerticalOffset((1-RealZoom) * -300)
        -- end
        
        --GUI.AddNote(RealZoom .. "->" .. math.floor(ZoomDistance) .. " , " .. math.floor(Angle) .. " , " .. math.floor(FoV))
	   
	--end
	
	-- update camera modes
	--if (TopView_UpdateCamera ~= nil) then
	--	TopView_UpdateCamera( RealZoom )
	--
	--	--AnSu: hack, because I have no other idea how to check the zoom distance (callback is not called in max zoom out anymore :-(
    --    if TopView.TriggerID == nil then
    --        TopView.TriggerID = Trigger.RequestTrigger(Events.LOGIC_EVENT_EVERY_TURN,"","TopView_UpdateCamera",1)
    --    end
	--end
end


--------------------------------------------------------------------------------
-- Init camera
--------------------------------------------------------------------------------

function Camera_InitParams()
	
	-- Init Camera
	do 
    	Camera.RTS_SetUpdateZMode(0)    	
    	Camera.RTS_SetRotationSpeed(90)
    	Camera.RTS_SetZoomSpeed(1)	
    	Camera.RTS_SetRestriction(-1000)    	
    	Camera.RTS_SetZoomFactor(0.5)
    	
    	local ScrollSpeed = g_DefaultScrollSpeed
    	local BorderScrollSize = g_DefaultBorderScrollSize
    	local ZoomWheelSpeed = g_DefaultZoomStateWheelSpeed
    	
    	if Options ~= nil then
    	    ScrollSpeed = Options.GetFloatValue("Game", "ScrollSpeed", g_DefaultScrollSpeed)
    	    BorderScrollSize = Options.GetFloatValue("Game", "BorderScrolling", g_DefaultBorderScrollSize)
    	    ZoomWheelSpeed = Options.GetFloatValue("Game", "ZoomSpeed", g_DefaultZoomStateWheelSpeed)
    	end
    	    	
    	Camera.RTS_SetScrollSpeed(ScrollSpeed)
    	Camera.RTS_SetBorderScrollSize(BorderScrollSize)
    	Camera.RTS_SetZoomWheelSpeed(ZoomWheelSpeed)
    	
    end
    
    -- Set camera limits ( needed for GameCallback_Camera_CalculateZoom )
    do 
        gvCamera = {}
        gvCamera.ZoomDistanceMin = 1800
        gvCamera.ZoomDistanceMax = 9000
        
    	gvCamera.ZoomAngleMax = 47
        gvCamera.ZoomAngleMin = 26
        
        gvCamera.ZoomFOVMin = 45  
        gvCamera.ZoomFOVMax = 48
        
    	
    	-- Default camera flag
    	gvCamera.DefaultFlag = 1
    end
	
	-- Init Focus Camera
	do 
    	FocusCamera.Activated = true
    	Camera.RTS_SetZoomFactorMin(FocusCamera.MinZoomFactor)
    	Camera.RTS_SetZoomFactorMax(FocusCamera.MaxZoomFactor)
    end
	
	-- Init close up cam
	Camera.CloseUp_SetDistanceMinMax(1000, 1000)
	Camera.CloseUp_SetDistance(1000)
	
	-- calculate the zoom
	GameCallback_Camera_CalculateZoom(Camera.RTS_GetZoomFactor())
		
end

--------------------------------------------------------------------------------
-- shake camera (called by Hurtentity callback and earthquake event)
--------------------------------------------------------------------------------
function ShakeCamera()

    local x,y = Camera.RTS_GetLookAtPosition()
    
    --do not  shake, when camera is far away
    if not g_CameraShaker.WholeMap and math.abs(g_CameraShaker.PosX - x) > 3000 
    and math.abs(g_CameraShaker.PosY - y) > 3000 then        
        return
    end
    
    local CurrentDuration = Logic.GetTimeMs() - g_CameraShaker.StartTime
    
    local ShakeImpact = (1 - ( CurrentDuration / g_CameraShaker.Length ) ) * 80 * ( g_CameraShaker.ImpactModifier or 1 )
    --GUI.AddNote(CurrentDuration ..":".. ShakeImpact)
        
    if math.mod(CurrentDuration/100,2) ~= 0 then        
        x = x + XGUIEng.GetRandom(ShakeImpact)
        y = y + XGUIEng.GetRandom(ShakeImpact)
    else
        x = x - XGUIEng.GetRandom(ShakeImpact)
        y = y - XGUIEng.GetRandom(ShakeImpact)
    end
    
    Camera.RTS_SetLookAtPosition(x,y)
    
    if CurrentDuration >= g_CameraShaker.Length then
        g_CameraShaker.Trigger = 0        
    end
    
end


--------------------------------------------------------------------------------
-- Enable/disable default camera (called by key binding)
--------------------------------------------------------------------------------

function Camera_ToggleDefault(_OptionalState)

    if _OptionalState ~= nil then
        if _OptionalState == gvCamera.DefaultFlag then
            return
        end
    end
	
	if gvCamera.DefaultFlag == 1 then

        Camera.SwitchCameraBehaviour(0)
        GUI.AddNote( "RTS camera" )
        Camera_InitParams()
        gvCamera.DefaultFlag = 0
	
    else
    	-- switch camera
        local PosX, PosY = Camera.RTS_GetLookAtPosition();	    
	    Camera.FreeView_SetPosition(PosX, PosY);	    
	    Camera.SwitchCameraBehaviour(2)
    	GUI.AddNote( "Free view camera" )
	    gvCamera.DefaultFlag = 1
	end
	
end


--------------------------------------------------------------------------------
-- GameCallback_Camera_MoveCameraToPosition [AnSu] what is this for?
--------------------------------------------------------------------------------

function GameCallback_Camera_MoveCameraToPosition(_PositionX, _PositionY)

    Camera.SwitchCameraBehaviour(0)
	Camera.RTS_SetLookAtPosition(_PositionX, _PositionY)

end

--------------------------------------------------------------------------------
-- ToggleFocusCamera (called by keybinding)
--------------------------------------------------------------------------------

function ToggleFocusCamera()

	-- Toggle Focus Camera
	if (FocusCamera.Activated == true) then
	
	    FocusCamera.Activated = false
		Camera.RTS_SetZoomFactorMin(0.0)
	    Camera.RTS_SetZoomFactorMax(1.0)
	    
	    Camera.RTS_SetZoomFactor(0.5)
	
    else

        FocusCamera.Activated = true
    	Camera.RTS_SetZoomFactorMin(FocusCamera.MinZoomFactor)
	    Camera.RTS_SetZoomFactorMax(FocusCamera.MaxZoomFactor)
	    
	    Temp = (FocusCamera.MaxZoomFactor - FocusCamera.MinZoomFactor) / 2
	    Camera.RTS_SetZoomFactor(Temp)

    end
end

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