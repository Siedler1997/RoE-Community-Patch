
-----------------------------------------------------------------
-- Overwrites
-----------------------------------------------------------------


do
    local OldGameCallback_LocalLoadScriptFiles = GameCallback_LocalLoadScriptFiles
    
    GameCallback_LocalLoadScriptFiles = function()
    
        OldGameCallback_LocalLoadScriptFiles()
    
        Script.Load( "Script\\Shared\\ScriptSystems\\SharedConstantsEx1.lua" )
        
        Script.Load("Script\\Local\\Interface\\FeedbackEx1.lua")
        Script.Load("Script\\Local\\Interface\\BuildingButtonsEx1.lua")
        Script.Load("Script\\Local\\Interface\\KnightEx1.lua")        
        Script.Load("Script\\Local\\Interface\\MissionStatisticEx1.lua")
        Script.Load("Script\\Local\\Interface\\SelectionEx1.lua")
        Script.Load("Script\\Local\\Interface\\InteractionEx1.lua")
        Script.Load("Script\\Local\\Interface\\ConstructionEx1.lua")
        Script.Load("Script\\Local\\Interface\\TimeEx1.lua")
        Script.Load("Script\\Local\\Interface\\TradeEx1.lua")
        Script.Load("Script\\Local\\Interface\\Geologist.lua")
        Script.Load("Script\\Local\\Interface\\Tradepost.lua")
        
        
        Script.Load("Script\\Local\\MainMapScript\\LocalMainMapScriptEx1.lua" )
        
        -- overwrite functions
        Script.Load("Script\\Local\\OverwriteFunctions.lua" )
        InitLocalOverwrite()
        
        Script.Load("Script\\Shared\\OverwriteShared.lua" )
        InitSharedOverwrite()
        
        
    end
end

do
    local OldGameCallback_LocalSetDefaultValues = GameCallback_LocalSetDefaultValues
    
    function GameCallback_LocalSetDefaultValues()
        
        OldGameCallback_LocalSetDefaultValues()
       
        KnightGender[Entities.U_KnightSaraya] = "female"
        KnightGender[Entities.U_KnightKhana] = "female"
        KnightGender[Entities.U_KnightPraphat] = "male"
        KnightGender[Entities.U_NPC_Castellan_AS] = "male"
    end
end    

g_PatchIdentifierExtra1 = "mission-pack-master"
