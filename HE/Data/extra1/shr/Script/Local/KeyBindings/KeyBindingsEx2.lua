
function KeyBindings_TestFunc()
    if g_Camera.RPGCamEnabled ~= true then
        local PlayerID = GUI.GetPlayerID()
        local KnightID = GUI.GetSelectedEntity()

        EnableRPGMode(KnightID)
    else
        DisableRPGMode()
    end
end

-----------------------------------------------------------------------------------------
-- Overwrites for KeyBindings
-----------------------------------------------------------------------------------------

function InitOverwriteKeyBindingsEx2()

    do
        local OldDebugKeyBindings_Init = DebugKeyBindings_Init
        function DebugKeyBindings_Init()
            -- Screen shot
            Input.KeyBindDown(Keys.Print, "Game.SaveScreenShot()", 2)
            Input.KeyBindDown(Keys.Snapshot, "Game.SaveScreenShot()", 2)

            -- Change building skin
            Input.KeyBindDown(Keys.C, "GUI_Construction.SwitchBuildingCategory()", 2)

            OldDebugKeyBindings_Init()
        end
    end

end