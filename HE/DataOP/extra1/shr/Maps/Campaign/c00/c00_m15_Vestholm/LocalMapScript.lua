CurrentMapIsCampaignMap = true

function Mission_LocalOnMapStart()
	StartStorm(false, true)
	Display.PlayEnvironmentSettingsSequence("ME_Storm.xml" ,10 )
    StartSimpleJob("SetStormDuringFakedRain")

    if g_OnGameStartPresentationMode == true then
        GUI.SetControlledPlayer(2)
        Input.KeyBindDown(Keys.V, "PresentationStartVikings()", 14, true)
    else

        local PosX, PosY = Logic.EntityGetPos(Logic.GetKnightID(1))
        Camera.RTS_SetLookAtPosition(PosX, PosY)
    end

end

function SetStormDuringFakedRain()
    if g_EventStormEnded ~= nil then
        return true
    end
    
    if math.mod(Logic.GetTime(),5) == 0 then
        Display.PlayEnvironmentSettingsSequence("ME_Storm.xml", 10)
    end
end

function PresentationStartVikings()
    GUI.SendScriptCommand("PresentationStartVikings()", true)
end

function Mission_LocalVictory()

    local x,y = 49244.957, 7473.205
    local RotationAngle = 81.411
    local ZoomFactor = 0.296

    Camera.RTS_SetRotationAngle(RotationAngle)
    Camera.RTS_SetLookAtPosition(x, y )
    Camera.RTS_SetZoomFactor(ZoomFactor)


    CameraAnimation.AllowAbort = false
    CameraAnimation.QueueAnimation( CameraAnimation.Stay ,  9999 )

end