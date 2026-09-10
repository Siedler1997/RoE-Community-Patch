
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
            
            Input.KeyBindDown(Keys.ModifierControl + Keys.NumPad8, "KeyBindings_ToggleRights()", 2, true)
        end
    end

    do
        local OldKeyBindings_ToggleRights = KeyBindings_ToggleRights
        function KeyBindings_ToggleRights()
            OldKeyBindings_ToggleRights()

            --Refresh selection UI
            GameCallback_GUI_SelectionChanged()
        end
    end

end