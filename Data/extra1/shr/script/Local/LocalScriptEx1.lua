
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



        -- Community Patch Local Overwrite
        Script.Load("Script\\Local\\CPOverwriteFunctions.lua")
        InitLocalOverwriteCP()
        -- Community Patch Shared Overwrite
        Script.Load("Script\\Shared\\CPOverwriteFunctions.lua")
        InitSharedOverwriteCP()
    end
end

do
    local OldGameCallback_LocalSetDefaultValues = GameCallback_LocalSetDefaultValues
    
    function GameCallback_LocalSetDefaultValues()
        
        OldGameCallback_LocalSetDefaultValues()
       
        KnightGender[Entities.U_KnightSaraya] = "female"
        KnightGender[Entities.U_KnightKhana] = "female"
        KnightGender[Entities.U_KnightPraphat] = "male"
        KnightGender[Entities.U_NPC_Castellan_ME] = "male"
        KnightGender[Entities.U_NPC_Castellan_NE] = "male"
        KnightGender[Entities.U_NPC_Castellan_NA] = "male"
        KnightGender[Entities.U_NPC_Castellan_SE] = "male"
        KnightGender[Entities.U_NPC_Castellan_AS] = "male"
    end
end    

g_PatchIdentifierExtra1 = "mission-pack-master"
