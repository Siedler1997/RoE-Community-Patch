
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
        Script.Load("Script\\Shared\\ScriptSystems\\SharedMultiplayerEx2.lua" )
        InitSharedOverwrite()
        
        -- CP

        Script.Load( "Script\\MainMenu\\MainMenuEx2.lua" )
        Script.Load( "Script\\Local\\OverwriteFunctionsEx2.lua" )
        Script.Load( "Script\\Local\\Camera\\CameraAnimationEx2.lua" )
        Script.Load( "Script\\Local\\Camera\\CameraEx2.lua" )
        Script.Load( "Script\\Local\\Interface\\BuffsEx2.lua" )
        Script.Load( "Script\\Local\\Interface\\BuildingButtonsEx2.lua" )
        Script.Load( "Script\\Local\\Interface\\BuildingInfoEx2.lua" )
        Script.Load( "Script\\Local\\Interface\\CloseUpViewEx2.lua" )
        Script.Load( "Script\\Local\\Interface\\ConstructionEx2.lua" )
        Script.Load( "Script\\Local\\Interface\\FeedbackEx2.lua" )
        Script.Load( "Script\\Local\\Interface\\FeedbackSpeechEx2.lua" )
        Script.Load( "Script\\Local\\Interface\\GoodsEx2.lua" )
        Script.Load( "Script\\Local\\Interface\\HouseMenuEx2.lua" )
        Script.Load( "Script\\Local\\Interface\\InitInterfaceEx2.lua" )
        Script.Load( "Script\\Local\\Interface\\InteractionEx2.lua" )
        Script.Load( "Script\\Local\\Interface\\KnightEx2.lua" )
        --Script.Load( "Script\\Local\\Interface\\LoadScreenEx2.lua" )
        Script.Load( "Script\\Local\\Interface\\MilitaryEx2.lua" )
        Script.Load( "Script\\Local\\Interface\\MissionStatisticEx2.lua" )
        Script.Load( "Script\\Local\\Interface\\MultiselectionEx2.lua" )
        Script.Load( "Script\\Local\\Interface\\SelectionEx2.lua" )
        Script.Load( "Script\\Local\\Interface\\TexturePositionsEx2.lua" )
        Script.Load( "Script\\Local\\Interface\\ToolTipEx2.lua" )
        Script.Load( "Script\\Local\\Interface\\TradeEx2.lua" )
        Script.Load( "Script\\Local\\Interface\\WindowsEx2.lua" )
        Script.Load( "Script\\Local\\KeyBindings\\KeyBindingsEx2.lua" )
        Script.Load( "Script\\Local\\MainMapScript\\LocalMainMapScriptEx2.lua" )
        Script.Load( "Script\\Local\\ScriptSystems\\LocalMusicSystemEx2.lua" )
        Script.Load( "Script\\Local\\ScriptSystems\\LocalVictoryConditionEx2.lua" )

        InitLocalOverwriteEx2()
        InitOverwriteBuffsEx2()
        InitOverwriteCloseUpViewEx2()
        InitOverwriteFeedbackEx2()
        InitOverwriteFeedbackSpeechEx2()
        InitOverwriteTexturePositionsEx2()
        InitOverwriteCameraAnimationEx2()
        InitOverwriteInitInterfaceEx2()
        InitOverwriteBuildingButtonsEx2()
        InitOverwriteBuildingInfoEx2()
        InitOverwriteConstructionEx2()
        InitOverwriteGoodsEx2()
        InitOverwriteHouseMenuEx2()
        InitOverwriteInteractionEx2()
        InitOverwriteKnightEx2()
        --InitOverwriteLoadScreenEx2()
        InitOverwriteMilitaryEx2()
        InitOverwriteGUI_MissionStatisticEx2()
        InitOverwriteMultiselectionEx2()
        InitOverwriteSelectionEx2()
        InitOverwriteToolTipEx2()
        InitOverwriteTradeEx2()
        InitOverwriteWindowsEx2()
        InitOverwriteKeyBindingsEx2()
        InitOverwriteLocalMainMapScriptEx2()
        InitOverwriteLocalMusicSystemEx2()
        InitOverwriteLocalVictoryConditionEx2()
        
        Script.Load("Script\\Shared\\OverwriteSharedEx2.lua" )
        InitSharedOverwriteEx2()

    end
end

g_PatchIdentifierExtra1 = "mission-pack-master"
