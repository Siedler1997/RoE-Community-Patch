
-----------------------------------------------------------------------------------------
-- Overwrites for LocalVictoryCondition
-----------------------------------------------------------------------------------------

function InitOverwriteLocalVictoryConditionEx2()

    do
        local OldVictory = Victory
        function Victory( _VictoryAndDefeatType)
            if g_Victory ~= nil then
                return
            end

            local PlayerID = 1
	        StartEventMusic(MusicSystem.GameWon, PlayerID)

            OldVictory()
        end
    end
    
    do
        local OldDefeated = Defeated
        function Defeated(_PlayerID)
            if _PlayerID == GUI.GetPlayerID() then
		        StartEventMusic(MusicSystem.GameLost, _PlayerID)
                OldDefeated()
            end
        end
    end

end