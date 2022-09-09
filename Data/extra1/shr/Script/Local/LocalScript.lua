--------------------------------------------------------------------------
--        ***************** LOCAL  SCRIPT MAIN *****************
--------------------------------------------------------------------------


-- Because of the way the Lua serialization currently (01.11.06) works we need
-- this one level indirection, otherwise after loading a Lua state, variables
-- holding references to C functions (e.g. Logic.XXX) are nil.
function LocalToGlobalLuaStateTableAccessRedirector(_Table, _Field)
    return Logic.DONT_EVER_CALL_THIS_MANUALLY_GetTableVarFromGlobalLuaState(_Table, _Field)
end

if Script ~= nil then
    Script.Load("Script\\Local\\Interface\\LoadScreen.lua")
end

function GameCallback_LocalLoadScriptFiles()
    
    Script.Load("Script\\Shared\\SaveGameUtils.lua")

    -- Init Network
    Script.Load("Script\\Local\\Multiplayer\\Multiplayer.lua" )
    
    -- Init Camera
    Script.Load( "Script\\Local\\Camera\\Camera.lua" )		
    Script.Load( "Script\\Local\\Camera\\CameraAnimation.lua" )
    
    -- Init Kybindings
    Script.Load( "Script\\Local\\KeyBindings\\KeyBindings.lua" )
    
    -- InitScriptTools
    Script.Load( "Script\\Local\\ScriptTools\\InitLocalScriptTools.lua" )		
    
    -- InitScriptSystems
    Script.Load( "Script\\Local\\ScriptSystems\\InitLocalScriptSystems.lua" )
    
    --Load Interface
    Script.Load("Script\\Local\\Interface\\InitInterface.lua" )		

    -- load MainMapScript
    Script.Load("Script\\Local\\MainMapScript\\LocalMainMapScript.lua" )

end

--------------------------------------------------------------------------------
-- Function called when local script was loaded the first time
--------------------------------------------------------------------------------

function GameCallback_LocalScriptLoadedFirstTime()


end




--------------------------------------------------------------------------------
-- Set default values and init stuff
--------------------------------------------------------------------------------

function GameCallback_LocalSetDefaultValues()

	-- Init network
    if Framework.IsNetworkGame() == true then
        GUI.SetControlledPlayer(Logic.GetSlotPlayerID(Network.GetLocalPlayerNetworkSlotID()))
	end	
		
	-- Reset selection
	GUI.ClearSelection()

    --save traitor in a global value 
    if Framework.IsNetworkGame() == false then    
	    GetTraitorAndSaveItToGlobalValue()
	end
	
	Camera_InitParams()
	
    DebugKeyBindings_Init()
    
    -- set camera to players castle or to spawn point
	do
	
	    local PlayerID = GUI.GetPlayerID()
	    local Amount, StartID = Logic.GetPlayerEntities(PlayerID, Entities.XD_StartPosition, 1)
        
        local x,y
        
        if StartID ~= nil then            
            x,y = Logic.GetEntityPosition(StartID)
	    else
    	    local Castle = Logic.GetHeadquarters(PlayerID)
            x,y = Logic.EntityGetPos(Castle)
    	end
    	
    	if x ~= 0 then
    	    Camera.RTS_SetLookAtPosition(x,y)
    	    Camera.RTS_SetRotationAngle(-45)
        end
        
    end
    
    --init tables for the knight title names (consts), so they can be localized
    do
        KnightGender = {}
        KnightGender[Entities.U_KnightTrading] = "male"
        KnightGender[Entities.U_KnightHealing] = "female"        
        KnightGender[Entities.U_KnightChivalry] = "male"
        KnightGender[Entities.U_KnightWisdom] = "male"
        KnightGender[Entities.U_KnightPlunder] = "female"
        KnightGender[Entities.U_KnightSong] = "male"
        KnightGender[Entities.U_KnightSabatta] = "female"                
        KnightGender[Entities.U_KnightRedPrince] = "male"
        KnightGender[Entities.U_NPC_Castellan_ME] = "male"
        KnightGender[Entities.U_NPC_Castellan_NE] = "male"
        KnightGender[Entities.U_NPC_Castellan_NA] = "male"
        KnightGender[Entities.U_NPC_Castellan_SE] = "male"
        
        
        -- this table is needed to lock special buildings and their upgrades in the campaign
        -- will be checken in BuildingButtons.lua in the interface
        TechnologyNeededForUpgrade = {}
	    TechnologyNeededForUpgrade[EntityCategories.Headquarters]   = {}
	    TechnologyNeededForUpgrade[EntityCategories.Headquarters][0] = Technologies.R_Castle
	    TechnologyNeededForUpgrade[EntityCategories.Headquarters][1] = Technologies.R_Castle_Upgrade_1
	    TechnologyNeededForUpgrade[EntityCategories.Headquarters][2] = Technologies.R_Castle_Upgrade_2
	    TechnologyNeededForUpgrade[EntityCategories.Headquarters][3] = Technologies.R_Castle_Upgrade_3
	    
	    
	    TechnologyNeededForUpgrade[EntityCategories.Storehouse]   = {}
	    TechnologyNeededForUpgrade[EntityCategories.Storehouse][0]  = Technologies.R_Storehouse
	    TechnologyNeededForUpgrade[EntityCategories.Storehouse][1]  = Technologies.R_Storehouse_Upgrade_1
	    TechnologyNeededForUpgrade[EntityCategories.Storehouse][2]  = Technologies.R_Storehouse_Upgrade_2
	    TechnologyNeededForUpgrade[EntityCategories.Storehouse][3]  = Technologies.R_Storehouse_Upgrade_3
	    
	    TechnologyNeededForUpgrade[EntityCategories.Cathedrals]   = {}
	    TechnologyNeededForUpgrade[EntityCategories.Cathedrals][0]  = Technologies.R_Cathedral
	    TechnologyNeededForUpgrade[EntityCategories.Cathedrals][1]  = Technologies.R_Cathedral_Upgrade_1
	    TechnologyNeededForUpgrade[EntityCategories.Cathedrals][2]  = Technologies.R_Cathedral_Upgrade_2
	    TechnologyNeededForUpgrade[EntityCategories.Cathedrals][3]  = Technologies.R_Cathedral_Upgrade_3
    end
    
end

--------------------------------------------------------------------------------
-- set params after save game load
--------------------------------------------------------------------------------

g_PatchIdentifierBase = "mission-pack-master"

function GameCallback_LocalRecreateGameLogic()
    
    if Logic.PatchLuaState then
        Logic.PatchLuaState(g_PatchIdentifierBase, "base-begin")
    end
    
    if Tutorial ~= nil then        
        Mission_LocalOnMapStart(true)        
    end
    
    DebugKeyBindings_Init()

    LocalSetKnightPicture()
    
    RestoreMissionTimersAfterLoad()
    
    QuestLog.UpdateQuestLog(_QuestIndex)--Put the questlog up to date
    
    if g_Minimap ~= nil
    and g_Minimap.Mode ~= nil then
        GUI.SetMiniMapMode(g_Minimap.Mode)
    end
    
    if g_Interaction ~= nil
    and g_Interaction.CurrentMessageQuestIndex ~= nil then
        g_Interaction.CurrentMessageQuestIndex = nil
        g_VoiceMessageIsRunning = false
        g_VoiceMessageEndTime = nil
    end
    
    if g_KnightCommandsVisible == true then
        XGUIEng.ShowWidget("/InGame/Root/Normal/AlignTopLeft/KnightCommands",1)
        XGUIEng.ShowAllSubWidgets("/InGame/Root/Normal/AlignTopLeft/KnightCommands",1)
    end
    
    HouseMenu.Widget.CurrentTab = 2
    
    -- Camera animation is hooked into the updated of the widget below. Make sure it is
    -- active so that camera animations will work.
    XGUIEng.ShowWidget("/InGame/Root/Normal/AnimatedCameraMovement", 1)
    
    GUI_Construction.RefreshBuildingButtons()--added to have the special edition buttons
	
	InitMinimap()
	InitMinimapColors()
	
	GUI.RebuildMinimapTerrain()
    
    GUI_Buffs.DisplayBuffs()    

    if Logic.PatchLuaState then
        Logic.PatchLuaState(g_PatchIdentifierBase, "base-end")
    end
end

--------------------------------------------------------------------------------
-- debug functions to add a gui note from game
--------------------------------------------------------------------------------

function GameCallback_DEBUG_AddNote(_Text)

    GUI.AddNote(_Text)

end


function LocalGetTraitor()
    
    local Traitor = Entities[Profile.GetTraitor()]
    
    if Traitor == nil then
        Traitor = Entities.U_KnightChivalry
    end
       
    return Traitor
    
end


function GetTraitorAndSaveItToGlobalValue()
    --the traitor is saved in the Profile, which can only be accessed through the local state
    --the traitor is also needed in the global state, so we save it in a global value in the global state    
    
    local Traitor = LocalGetTraitor()
    
    GUI.SendScriptCommand("SaveTraitorToGlobalValue(" .. Traitor .. ")", true)
    
end
