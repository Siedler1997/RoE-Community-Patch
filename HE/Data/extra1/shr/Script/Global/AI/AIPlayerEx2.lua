Script.Load("Script\\Global\\AI\\AISkirmishEx2.lua")

------------------------------------------------------------------------------------------------------------------------
--ToDo: There is no way to let the game call that Callback :(
function GameCallback_AIDefendArmyNeedsSpearmen(_PlayerID, _Number)

    if (AIPlayerTable[_PlayerID] ~= nil) then
        
        AISkirmish_AIDefendArmyNeedsSpearmen(AIPlayerTable[_PlayerID], _Number)
        
    end    

end
