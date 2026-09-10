
-----------------------------------------------------------------------------------------
-- Overwrites for Windows
-----------------------------------------------------------------------------------------

function InitOverwriteWindowsEx2()

    do
        local OldGUI_Window_Close = GUI_Window.Close
        function GUI_Window.Close()
                    
            -- stop the event music
            local PlayerID = GUI.GetPlayerID()
            StopEventMusic(MusicSystem.GameWon, PlayerID)
            StopEventMusic(MusicSystem.GameLost, PlayerID)
            
            OldGUI_Window_Close()
        end
    end

end