--------------------------------------------------------------------------
--        ***************** GLOBAL SCRIPT MAIN *****************
--------------------------------------------------------------------------

local OldGameCallback_LoadScriptFiles = GameCallback_LoadScriptFiles

GameCallback_LoadScriptFiles = function() 
    
    OldGameCallback_LoadScriptFiles()        

    Script.Load( "Script\\Shared\\ScriptSystems\\SharedConstantsEx1.lua" )
    
    Script.Load( "Script\\Global\\ScriptSystems\\GlobalQuestSystemEx1.lua" )
    Script.Load( "Script\\Global\\ScriptSystems\\GlobalGameCallBacksEx1.lua" )

    -- load overwrite functions
    Script.Load("Script\\Global\\OverwriteFunctions.lua" )
    InitGlobalOverwrite()
   
    Script.Load("Script\\Shared\\OverwriteShared.lua" )
    InitSharedOverwrite()

    -- CP
    Script.Load("Script\\Shared\\OverwriteSharedEx2.lua" )
    Script.Load("Script\\Shared\\ScriptSystems\\SharedMultiplayerEx2.lua" )
    InitSharedOverwriteEx2()

    Script.Load( "Script\\Global\\MainMapScript\\GlobalMainMapScriptEx2.lua" )
    Script.Load( "Script\\Global\\Multiplayer\\MultiplayerEx2.lua" )
    Script.Load( "Script\\Global\\ScriptSystems\\GlobalEndStatisticSystemEx2.lua" )
    Script.Load( "Script\\Global\\ScriptSystems\\GlobalFreeSettleModeSystemEx2.lua" )
    Script.Load( "Script\\Global\\ScriptSystems\\GlobalMerchantSystemEx2.lua" )
    Script.Load( "Script\\Global\\ScriptSystems\\GlobalQuestSystemEx2.lua" )
    InitOverwriteGlobalMainMapScriptEx2()
    InitOverwriteMultiplayerEx2()
    InitOverwriteGlobalEndStatisticSystemEx2()
    InitOverwriteGlobalFreeSettleModeSystemEx2()
    InitOverwriteGlobalMerchantSystemEx2()
    InitOverwriteGlobalQuestSystemEx2()

end

g_PatchIdentifierExtra1 = "mission-pack-master"



