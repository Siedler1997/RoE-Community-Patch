
-- ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
-- Input documentation
-- ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
--
-- Input.NoneMode()
-- Deactivate input system
--
-- Input.MenuMode()
-- Switch input system to menu mode
--
-- Input.GameMode()
-- Switch input system to game mode
--
-- Input.CutsceneMode()
-- Switch input system to cutscene mode
--
-- Input.VideoMode()
-- Switch input system to video mode
--
-- Input.ChatMode()
-- Switch input system to chat mode
--
-- ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
--
-- Input.IsDebugMode()
--
-- Is Debug Mode enabled?
--
-- ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
--
-- Input.EnableDebugMode()
--
-- Enables Debug Mode.
-- Param 1: 0 = False, 1-2-3 = True (order must be 1-2-3 to enable mode)
--
-- ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
--
-- Input.GetCommandMask()
--
-- Gets the Command Mask.
-- Returns: Mask: 0 = None, 1 = Menu, 2 = Game, 4 = Cutscene, 8 = Video, 16 = Chat
--
-- ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
--
-- Input.SetCommandMask()
--
-- Sets the Command Mask.
-- Param 1: Mask: 0 = None, 1 = Menu, 2 = Game, 4 = Cutscene, 8 = Video, 16 = Chat
--
-- ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
--
-- Input.KeyBindUp()
-- Input.KeyBindDown()
--
-- Binds a script command to a key up/down event.
-- Param 1: KeyData: KeyCode + KeyModifiers
-- Param 2: ScriptCommand
-- Param 3: Mask: 0 = None, 1 = Menu, 2 = Game, 4 = Cutscene, 8 = Video, 16 = Chat
-- Param 4: DebugCommand: True/False. Default is False
--
-- ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++






-- ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
-- KeyBindingsDev.lua
-- ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++

Script.Load("Script\\Local\\KeyBindings\\KeyBindingsDev.lua")


-- ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
-- Debug_EnableDebugOutput
-- ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++

Debug_EnableDebugOutput = false


-- ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
-- DebugKeyBindings_Init
-- ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++

function DebugKeyBindings_Init()

    -----------------------------------------------------------------------------------------------
    -- Screen shot
    -----------------------------------------------------------------------------------------------

    -- Input.KeyBindDown(Keys.F12, "Game.SaveScreenShot()", 31)

    -- snapshot key event is received only if key is released
    -- Input.KeyBindUp(Keys.Snapshot, "Game.SaveScreenShot()", 31)

    -----------------------------------------------------------------------------------------------
    -- Game functions
    -----------------------------------------------------------------------------------------------

    Input.KeyBindDown(Keys.Pause, "KeyBindings_TogglePause()", 2)

    Input.KeyBindDown(Keys[XGUIEng.GetStringTableText("KeyBindings/KeyKnockDown")],       "KeyBindings_KnockDown()", 2)
    Input.KeyBindDown(Keys[XGUIEng.GetStringTableText("KeyBindings/KeyBuildStreet")],     "KeyBindings_BuildStreet()", 2)
    Input.KeyBindDown(Keys[XGUIEng.GetStringTableText("KeyBindings/KeyBuildTrail")],      "KeyBindings_BuildTrail()", 2)
    Input.KeyBindDown(Keys[XGUIEng.GetStringTableText("KeyBindings/KeyBuildLastPlaced")], "KeyBindings_BuildLastPlaced()", 2)

    Input.KeyBindDown(Keys[XGUIEng.GetStringTableText("KeyBindings/KeyMenuDiplomacy")],   "KeyBindings_MenuDiplomacy()", 2)
    Input.KeyBindDown(Keys[XGUIEng.GetStringTableText("KeyBindings/KeyMenuProduction")],  "KeyBindings_MenuProduction()", 2)
    Input.KeyBindDown(Keys[XGUIEng.GetStringTableText("KeyBindings/KeyMenuPromotion")],   "KeyBindings_MenuPromotion()", 2)
    Input.KeyBindDown(Keys[XGUIEng.GetStringTableText("KeyBindings/KeyMenuWeather")],     "KeyBindings_MenuWeather()", 2)

    Input.KeyBindDown(Keys[XGUIEng.GetStringTableText("KeyBindings/KeyBuildingUpgrade")],   "KeyBindings_BuildingUpgrade()", 2)

    Input.KeyBindDown(Keys[XGUIEng.GetStringTableText("KeyBindings/KeyMilitaryAttack")],      "KeyBindings_MilitaryAttack()", 2)
    Input.KeyBindDown(Keys[XGUIEng.GetStringTableText("KeyBindings/KeyMilitaryStandGround")], "KeyBindings_MilitaryStandGround()", 2)

    Input.KeyBindDown(Keys[XGUIEng.GetStringTableText("KeyBindings/KeyJumpMarketplace")], "KeyBindings_JumpMarketplace()", 2)
    Input.KeyBindDown(Keys[XGUIEng.GetStringTableText("KeyBindings/KeyJumpMinimapEvent")], "GUI_FeedbackSpeech.ButtonClicked()", 2)

    Input.KeyBindDown(Keys[XGUIEng.GetStringTableText("KeyBindings/KeyToggleOutstockInformations")],  "KeyBindings_ToggleOutstockInformations()", 2)

    Input.KeyBindDown(Keys[XGUIEng.GetStringTableText("KeyBindings/KeyToggleGameSpeed")],  "KeyBindings_ToggleGameSpeed()", 2)

    -----------------------------------------------------------------------------------------------
    -- Group Selection
    -----------------------------------------------------------------------------------------------

    Input.KeyBindDown(Keys.D0, "KeyBindings_ToggleThroughMilitaryUnits()", 2)

    Input.KeyBindDown(Keys.D1, "GUI_Selection.ActivateSelectionGroup(1)", 2)
    Input.KeyBindDown(Keys.D2, "GUI_Selection.ActivateSelectionGroup(2)", 2)
    Input.KeyBindDown(Keys.D3, "GUI_Selection.ActivateSelectionGroup(3)", 2)
    Input.KeyBindDown(Keys.D4, "GUI_Selection.ActivateSelectionGroup(4)", 2)
    Input.KeyBindDown(Keys.D5, "GUI_Selection.ActivateSelectionGroup(5)", 2)
    Input.KeyBindDown(Keys.D6, "GUI_Selection.ActivateSelectionGroup(6)", 2)
    Input.KeyBindDown(Keys.D7, "GUI_Selection.ActivateSelectionGroup(7)", 2)
    Input.KeyBindDown(Keys.D8, "GUI_Selection.ActivateSelectionGroup(8)", 2)
    Input.KeyBindDown(Keys.D9, "GUI_Selection.ActivateSelectionGroup(9)", 2)

    Input.KeyBindDown(Keys.ModifierShift + Keys.D1, "GUI_Selection.AddGroupToSelection(1)", 2)
    Input.KeyBindDown(Keys.ModifierShift + Keys.D2, "GUI_Selection.AddGroupToSelection(2)", 2)
    Input.KeyBindDown(Keys.ModifierShift + Keys.D3, "GUI_Selection.AddGroupToSelection(3)", 2)
    Input.KeyBindDown(Keys.ModifierShift + Keys.D4, "GUI_Selection.AddGroupToSelection(4)", 2)
    Input.KeyBindDown(Keys.ModifierShift + Keys.D5, "GUI_Selection.AddGroupToSelection(5)", 2)
    Input.KeyBindDown(Keys.ModifierShift + Keys.D6, "GUI_Selection.AddGroupToSelection(6)", 2)
    Input.KeyBindDown(Keys.ModifierShift + Keys.D7, "GUI_Selection.AddGroupToSelection(7)", 2)
    Input.KeyBindDown(Keys.ModifierShift + Keys.D8, "GUI_Selection.AddGroupToSelection(8)", 2)
    Input.KeyBindDown(Keys.ModifierShift + Keys.D9, "GUI_Selection.AddGroupToSelection(9)", 2)

    Input.KeyBindDown(Keys.ModifierControl + Keys.D1, "GUI_MultiSelection.StoreSelectionGroup(1)", 2)
    Input.KeyBindDown(Keys.ModifierControl + Keys.D2, "GUI_MultiSelection.StoreSelectionGroup(2)", 2)
    Input.KeyBindDown(Keys.ModifierControl + Keys.D3, "GUI_MultiSelection.StoreSelectionGroup(3)", 2)
    Input.KeyBindDown(Keys.ModifierControl + Keys.D4, "GUI_MultiSelection.StoreSelectionGroup(4)", 2)
    Input.KeyBindDown(Keys.ModifierControl + Keys.D5, "GUI_MultiSelection.StoreSelectionGroup(5)", 2)
    Input.KeyBindDown(Keys.ModifierControl + Keys.D6, "GUI_MultiSelection.StoreSelectionGroup(6)", 2)
    Input.KeyBindDown(Keys.ModifierControl + Keys.D7, "GUI_MultiSelection.StoreSelectionGroup(7)", 2)
    Input.KeyBindDown(Keys.ModifierControl + Keys.D8, "GUI_MultiSelection.StoreSelectionGroup(8)", 2)
    Input.KeyBindDown(Keys.ModifierControl + Keys.D9, "GUI_MultiSelection.StoreSelectionGroup(9)", 2)

    -----------------------------------------------------------------------------------------------
    -- Chat functions
    -----------------------------------------------------------------------------------------------

    Input.KeyBindDown(Keys.Enter,  "KeyBindings_StartChat()", 2)
    Input.KeyBindDown(Keys.Escape, "KeyBindings_AbortChatMessage()", 16)

    -----------------------------------------------------------------------------------------------
    -- Save, Load etc.
    -----------------------------------------------------------------------------------------------

    Input.KeyBindDown(Keys.F10, "KeyBindings_OpenInGameMenu()", 2)
    Input.KeyBindDown(Keys.ModifierControl + Keys.S, "KeyBindings_SaveGame_Neu()", 2)
    Input.KeyBindDown(Keys.ModifierControl + Keys.L, "KeyBindings_LoadGame()", 2)

    -----------------------------------------------------------------------------------------------
    -- Misc
    -----------------------------------------------------------------------------------------------

    Input.KeyBindDown(Keys.Escape, "Game.Escape(GUI.GetPlayerID())", 14)

    if Framework.CheckIDV() then
        Input.KeyBindDown(Keys.ModifierAlt + Keys.F4, "EndScreen_Show()", 31)
    end

    -----------------------------------------------------------------------------------------------
    -- Debug functions
    -----------------------------------------------------------------------------------------------

    Input.KeyBindDown(Keys.ModifierControl + Keys.C, "KeyBindings_ToggleClock()", 2, true)
    Input.KeyBindDown(Keys.ModifierControl + Keys.V, "KeyBindings_Victory()", 2, true)

    Input.KeyBindDown(Keys.ModifierControl + Keys.ModifierShift + Keys.D, "LuaDebugger.Break()", 2, true)
    Input.KeyBindDown(Keys.ModifierControl + Keys.ModifierShift + Keys.ModifierAlt + Keys.R, "Sound.Reinit()", 2, true)

    Input.KeyBindDown(Keys.ModifierAlt + Keys.ModifierControl + Keys.ModifierShift + Keys.F8, "ReplaySaveGames.IssueReplaySaveCmd()", 2, true)

    -----------------------------------------------------------------------------------------------
    -- Debug error functions
    -----------------------------------------------------------------------------------------------

    Input.KeyBindDown(Keys.ModifierAlt + Keys.ModifierControl + Keys.ModifierShift + Keys.F12, "KeyBindings_DbgBindErrorFunctions()", 2, true)

    -----------------------------------------------------------------------------------------------
    -- Cheats
    -----------------------------------------------------------------------------------------------

    Input.KeyBindDown(Keys.ModifierControl + Keys.ModifierShift + Keys.Divide,   "KeyBindings_EnableDebugMode(1)", 2)
    Input.KeyBindDown(Keys.ModifierControl + Keys.ModifierShift + Keys.Multiply, "KeyBindings_EnableDebugMode(2)", 2)
    Input.KeyBindDown(Keys.ModifierControl + Keys.ModifierShift + Keys.Subtract, "KeyBindings_EnableDebugMode(3)", 2)
    Input.KeyBindDown(Keys.ModifierControl + Keys.ModifierShift + Keys.Add,      "Input.EnableDebugMode(0)", 2)

    Input.KeyBindDown(Keys.ModifierControl + Keys.ModifierShift + Keys.F9,       "KeyBindings_ToggleDebugOutput()", 2, true)

    --Input.KeyBindDown(Keys.ModifierControl + Keys.NumPad5, "KeyBindings_CreateBattalionOnMousePositionForActiveGUIPlayer(Entities.U_MilitarySword_RedPrince)", 2, true)
    Input.KeyBindDown(Keys.ModifierControl + Keys.NumPad5, "KeyBindings_CreateBattalionOnMousePositionForActiveGUIPlayer(Entities.U_MilitarySpear)", 2, true)
    Input.KeyBindDown(Keys.ModifierControl + Keys.NumPad4, "KeyBindings_CreateBattalionOnMousePositionForActiveGUIPlayer(Entities.U_MilitaryBow)", 2, true)
    Input.KeyBindDown(Keys.ModifierControl + Keys.NumPad6, "KeyBindings_CreateEntityAtMousePositionForActiveGUIPlayer(Entities.U_CatapultCart)", 2, true)
    Input.KeyBindDown(Keys.ModifierControl + Keys.NumPad7, "KeyBindings_CreateEntityAtMousePositionForActiveGUIPlayer(Entities.U_MagicOx)", 2, true)
    --Input.KeyBindDown(Keys.ModifierControl + Keys.NumPad8, "KeyBindings_CreateEntityAtMousePositionForActiveGUIPlayer(Entities.U_SiegeTowerCart)", 2, true)
    Input.KeyBindDown(Keys.ModifierControl + Keys.NumPad8, "KeyBindings_ToggleRights()", 2, true)
    --Input.KeyBindDown(Keys.ModifierControl + Keys.NumPad8, "KeyBindings_TestFunc()", 2, true)
    Input.KeyBindDown(Keys.ModifierControl + Keys.NumPad9, "KeyBindings_CreateEntityAtMousePositionForActiveGUIPlayer(Entities.U_Dragon)", 2, true)
    --Input.KeyBindDown(Keys.ModifierControl + Keys.NumPad9, "KeyBindings_CreateEntityAtMousePositionForActiveGUIPlayer(Entities.B_NPC_Spicetrader)", 2, true)
    --Input.KeyBindDown(Keys.ModifierControl + Keys.NumPad9, "KeyBindings_CreateEntityAtMousePositionForActiveGUIPlayer(Entities.B_Beautification_Dragon)", 2, true)
    --Input.KeyBindDown(Keys.ModifierControl + Keys.NumPad9, "KeyBindings_CreateEntityAtMousePositionForActiveGUIPlayer(Entities.U_Dragon)", 2, true)
    

    -----------------------------------------------------------------------------------------------
    -- Camera debug
    -----------------------------------------------------------------------------------------------

    Input.KeyBindDown(Keys.ModifierControl + Keys.NumPad0, "Camera_ToggleDefault()", 2, true)
    Input.KeyBindDown(Keys.ModifierControl + Keys.NumPad1, "ToggleFocusCamera()", 2, true)

    Input.KeyBindDown(Keys.ModifierControl + Keys.ModifierAlt+ Keys.NumPad8, "Display.UseCloseUpSettings()", 2, true)
    Input.KeyBindDown(Keys.ModifierControl + Keys.ModifierAlt+ Keys.NumPad9, "Display.UseStandardSettings()", 2, true)

    -----------------------------------------------------------------------------------------------
    -- Game functions
    -----------------------------------------------------------------------------------------------

    Input.KeyBindDown(Keys.Multiply, "Game.GameTimeReset(GUI.GetPlayerID())", 2, true)
    Input.KeyBindDown(Keys.Subtract, "Game.GameTimeSlowDown(GUI.GetPlayerID())", 2, true)
    Input.KeyBindDown(Keys.Add,      "Game.GameTimeSpeedUp(GUI.GetPlayerID())", 2, true)

    -----------------------------------------------------------------------------------------------
    -- GUI
    -----------------------------------------------------------------------------------------------

    Input.KeyBindDown(Keys.ModifierControl + Keys.ModifierAlt + Keys.D1, "GUI.ClearSelection(); GUI.SetControlledPlayer(1)", 2, true)
    Input.KeyBindDown(Keys.ModifierControl + Keys.ModifierAlt + Keys.D2, "GUI.ClearSelection(); GUI.SetControlledPlayer(2)", 2, true)
    Input.KeyBindDown(Keys.ModifierControl + Keys.ModifierAlt + Keys.D3, "GUI.ClearSelection(); GUI.SetControlledPlayer(3)", 2, true)
    Input.KeyBindDown(Keys.ModifierControl + Keys.ModifierAlt + Keys.D4, "GUI.ClearSelection(); GUI.SetControlledPlayer(4)", 2, true)
    Input.KeyBindDown(Keys.ModifierControl + Keys.ModifierAlt + Keys.D5, "GUI.ClearSelection(); GUI.SetControlledPlayer(5)", 2, true)
    Input.KeyBindDown(Keys.ModifierControl + Keys.ModifierAlt + Keys.D6, "GUI.ClearSelection(); GUI.SetControlledPlayer(6)", 2, true)
    Input.KeyBindDown(Keys.ModifierControl + Keys.ModifierAlt + Keys.D7, "GUI.ClearSelection(); GUI.SetControlledPlayer(7)", 2, true)
    Input.KeyBindDown(Keys.ModifierControl + Keys.ModifierAlt + Keys.D8, "GUI.ClearSelection(); GUI.SetControlledPlayer(8)", 2, true)

    -----------------------------------------------------------------------------------------------
    -- Cheats
    -----------------------------------------------------------------------------------------------

    Input.KeyBindDown(Keys.ModifierControl + Keys.F1, "KeyBindings_AddGoodToHeadquarters(Goods.G_Gold, 50)", 2, true)
    Input.KeyBindDown(Keys.ModifierControl + Keys.F2, "KeyBindings_AddGoodToHeadquarters(Goods.G_Wood, 10)", 2, true)
    Input.KeyBindDown(Keys.ModifierControl + Keys.F3, "KeyBindings_AddGoodToHeadquarters(Goods.G_Stone, 10)", 2, true)
    Input.KeyBindDown(Keys.ModifierControl + Keys.F4, "KeyBindings_AddGoodToHeadquarters(Goods.G_Grain, 10)", 2, true)
    Input.KeyBindDown(Keys.ModifierControl + Keys.F5, "KeyBindings_AddGoodToHeadquarters(Goods.G_Milk, 10)", 2, true)
    Input.KeyBindDown(Keys.ModifierControl + Keys.F6, "KeyBindings_AddGoodToHeadquarters(Goods.G_Herb, 10)", 2, true)
    Input.KeyBindDown(Keys.ModifierControl + Keys.F7, "KeyBindings_AddGoodToHeadquarters(Goods.G_Wool, 10)", 2, true)

    Input.KeyBindDown(Keys.ModifierShift + Keys.F1, "KeyBindings_AddGoodToHeadquarters(Goods.G_Honeycomb, 10)", 2, true)
    Input.KeyBindDown(Keys.ModifierShift + Keys.F2, "KeyBindings_AddGoodToHeadquarters(Goods.G_Iron, 10)", 2, true)
    Input.KeyBindDown(Keys.ModifierShift + Keys.F3, "KeyBindings_AddGoodToHeadquarters(Goods.G_RawFish, 10)", 2, true)
    Input.KeyBindDown(Keys.ModifierShift + Keys.F4, "KeyBindings_AddGoodToHeadquarters(Goods.G_Carcass, 10)", 2, true)

    Input.KeyBindDown(Keys.ModifierControl + Keys.F8, "KeyBindings_AddGoodsToHeadquarters()", 2, true)

    Input.KeyBindDown(Keys.ModifierControl + Keys.ModifierShift + Keys.F1, "KeyBindings_AddGoodToSupermarket(Goods.G_Bread, 10)", 2, true)
    Input.KeyBindDown(Keys.ModifierControl + Keys.ModifierShift + Keys.F2, "KeyBindings_AddGoodToSupermarket(Goods.G_Soap, 10)", 2, true)
    Input.KeyBindDown(Keys.ModifierControl + Keys.ModifierShift + Keys.F3, "KeyBindings_AddGoodToSupermarket(Goods.G_Beer, 10)", 2, true)
    Input.KeyBindDown(Keys.ModifierControl + Keys.ModifierShift + Keys.F4, "KeyBindings_AddGoodToSupermarket(Goods.G_Medicine, 10)", 2, true)
    Input.KeyBindDown(Keys.ModifierControl + Keys.ModifierShift + Keys.F5, "KeyBindings_AddGoodToSupermarket(Goods.G_Cheese, 10)", 2, true)
    Input.KeyBindDown(Keys.ModifierControl + Keys.ModifierShift + Keys.F6, "KeyBindings_AddGoodToSupermarket(Goods.G_Sausage, 10)", 2, true)

    Input.KeyBindDown(Keys.ModifierControl + Keys.ModifierShift + Keys.F8, "KeyBindings_AddGoodsToSupermarket()", 2, true)

    Input.KeyBindDown(Keys.ModifierAlt + Keys.F10, "KeyBindings_SetBuildingOnFire()", 2, true)
    Input.KeyBindDown(Keys.ModifierAlt + Keys.F11, "KeyBindings_HurtEntity()", 2, true)

    Input.KeyBindDown(Keys.ModifierControl + Keys.F9, "KeyBindings_ModifySettlerState( Needs.Nutrition, 0.2)", 2, true)
    Input.KeyBindDown(Keys.ModifierShift + Keys.F9, "KeyBindings_ModifySettlerState( Needs.Nutrition, -0.2)", 2, true)
    Input.KeyBindDown(Keys.ModifierControl + Keys.F10, "KeyBindings_ModifySettlerState( Needs.Clothes, 0.2)", 2, true)
    Input.KeyBindDown(Keys.ModifierShift + Keys.F10, "KeyBindings_ModifySettlerState( Needs.Clothes, -0.2)", 2, true)
    Input.KeyBindDown(Keys.ModifierControl + Keys.F11, "KeyBindings_ModifySettlerState( Needs.Hygiene, 0.2)", 2, true)
    Input.KeyBindDown(Keys.ModifierShift + Keys.F11, "KeyBindings_ModifySettlerState( Needs.Hygiene, -0.2)", 2, true)
    Input.KeyBindDown(Keys.ModifierControl + Keys.F12, "KeyBindings_ModifySettlerState( Needs.Entertainment, 0.2)", 2, true)
    Input.KeyBindDown(Keys.ModifierShift + Keys.F12, "KeyBindings_ModifySettlerState( Needs.Entertainment, -0.2)", 2, true)

    Input.KeyBindDown(Keys.ModifierAlt + Keys.F5, "KeyBindings_ActivateNeed(Needs.Nutrition)", 2, true)
    Input.KeyBindDown(Keys.ModifierAlt + Keys.F6, "KeyBindings_ActivateNeed(Needs.Clothes)", 2, true)
    Input.KeyBindDown(Keys.ModifierAlt + Keys.F7, "KeyBindings_ActivateNeed(Needs.Hygiene)", 2, true)
    Input.KeyBindDown(Keys.ModifierAlt + Keys.F8, "KeyBindings_ActivateNeed(Needs.Entertainment)", 2, true)
    Input.KeyBindDown(Keys.ModifierAlt + Keys.F9, "KeyBindings_CheatWife()", 2, true)
    Input.KeyBindDown(Keys.ModifierAlt + Keys.ModifierControl + Keys.F10, "KeyBindings_ModifyEarnings(1)", 2, true)

    Input.KeyBindDown(Keys.ModifierAlt + Keys.F12, "KeyBindings_ToggleRights()", 2, true)

    Input.KeyBindDown(Keys.ModifierAlt + Keys.NumPad1, "KeyBindings_RemoveGoodsFromOutStock(1)", 2, true)
    Input.KeyBindDown(Keys.ModifierAlt + Keys.NumPad2, "KeyBindings_AddGoodsToOutStock(1)", 2, true)

    Input.KeyBindDown(Keys.ModifierControl + Keys.ModifierShift + Keys.F,   "KeyBindings_ToggleFOW()", 2, true)

    -----------------------------------------------------------------------------------------------
    -- Render settings (use always Ctrl + Shift key)
    -----------------------------------------------------------------------------------------------

    Input.KeyBindDown(Keys.ModifierControl + Keys.ModifierShift + Keys.D1, "Game.ShowFPS(-1)", 2, true)
    Input.KeyBindDown(Keys.ModifierControl + Keys.ModifierShift + Keys.D2, "Display.EditWeatherOverride()", 2, true)

    Input.KeyBindDown(Keys.ModifierControl + Keys.ModifierShift + Keys.G,  "Game.GUIActivate(-1)", 2, true)

    Input.KeyBindDown(Keys.ModifierControl + Keys.ModifierShift + Keys.V,  "Display.ShowTerritoryDiagnosticGrid()", 2, true)
    Input.KeyBindDown(Keys.ModifierControl + Keys.ModifierShift + Keys.B,  "Display.ShowBlockingDiagnosticGrid()", 2, true)
    Input.KeyBindDown(Keys.ModifierControl + Keys.ModifierShift + Keys.N,  "Display.HideDiagnosticGrid()", 2, true)
    Input.KeyBindDown(Keys.ModifierControl + Keys.ModifierShift + Keys.M,  "Display.ToggleDiagnosticGridWireframe()", 2, true)

    Input.KeyBindDown(Keys.ModifierControl + Keys.ModifierShift + Keys.A,  "Display.SetRenderObjectsAlphaTestPass(-1); Display.SetRenderObjectsAlphaBlendPass(-1)", 2, true)
    Input.KeyBindDown(Keys.ModifierControl + Keys.ModifierShift + Keys.S,  "Display.SetRenderShadows(-1)", 2, true)
    Input.KeyBindDown(Keys.ModifierControl + Keys.ModifierShift + Keys.T,  "Display.SetRenderTerrain(-1)", 2, true)
    Input.KeyBindDown(Keys.ModifierControl + Keys.ModifierShift + Keys.R,  "Display.SetRenderRoads(-1)", 2, true)
    Input.KeyBindDown(Keys.ModifierControl + Keys.ModifierShift + Keys.E,  "Display.SetRenderSpeedTrees(-1)", 2, true)
    Input.KeyBindDown(Keys.ModifierControl + Keys.ModifierShift + Keys.W,  "Display.SetRenderWater(-1)", 2, true)
    Input.KeyBindDown(Keys.ModifierControl + Keys.ModifierShift + Keys.P,  "Display.SetRenderParticles(-1)", 2, true)
    Input.KeyBindDown(Keys.ModifierControl + Keys.ModifierShift + Keys.Q,  "Display.SetRenderBorderPins(-1)", 2, true)
    Input.KeyBindDown(Keys.ModifierControl + Keys.ModifierShift + Keys.H,  "Display.SetRenderBatches(-1)", 2, true)
    Input.KeyBindDown(Keys.ModifierControl + Keys.ModifierShift + Keys.X,  "Display.SetEffectOption(\"SimpleWater\", -1)", 2, true)
    Input.KeyBindDown(Keys.ModifierControl + Keys.ModifierShift + Keys.Y,  "Display.SetRenderSky(-1)", 2, true)
    Input.KeyBindDown(Keys.ModifierControl + Keys.ModifierShift + Keys.C,  "Display.SetRenderClutter(-1)", 2, true)
    Input.KeyBindDown(Keys.ModifierControl + Keys.ModifierShift + Keys.U,  "Display.SetRenderFogOfWar(-1)", 2, true)
    Input.KeyBindDown(Keys.ModifierControl + Keys.ModifierShift + Keys.K,  "Display.SetRenderDecals(-1)", 2, true)
    Input.KeyBindDown(Keys.ModifierControl + Keys.ModifierShift + Keys.O,  "Display.SetRenderUseOrnamentalItemsSystem(-1)", 2, true)

    Input.KeyBindDown(Keys.ModifierControl + Keys.ModifierShift + Keys.L,  "Display.ReloadAllEffects()", 2, true)

    -----------------------------------------------------------------------------------------------
    -- Render settings 2 (use always Ctrl + Shift + Alt key)
    -----------------------------------------------------------------------------------------------

    Input.KeyBindDown(Keys.ModifierControl + Keys.ModifierShift + Keys.ModifierAlt + Keys.A, "Display.UseExplicitEnvironmentSettings()", 2, true)
    Input.KeyBindDown(Keys.ModifierControl + Keys.ModifierShift + Keys.ModifierAlt + Keys.S, "Display.UseExplicitEnvironmentSettings(); Display.ToggleScatteringDialog()", 2, true)
    Input.KeyBindDown(Keys.ModifierControl + Keys.ModifierShift + Keys.ModifierAlt + Keys.D, "Display.UseExplicitEnvironmentSettings(); Display.ToggleLightDialog()", 2, true)
    Input.KeyBindDown(Keys.ModifierControl + Keys.ModifierShift + Keys.ModifierAlt + Keys.F, "Display.UseExplicitEnvironmentSettings(); Display.ToggleCloudLayer0Dialog()", 2, true)
    Input.KeyBindDown(Keys.ModifierControl + Keys.ModifierShift + Keys.ModifierAlt + Keys.G, "Display.UseExplicitEnvironmentSettings(); Display.ToggleCloudLayer1Dialog()", 2, true)
    Input.KeyBindDown(Keys.ModifierControl + Keys.ModifierShift + Keys.ModifierAlt + Keys.H, "Display.UseExplicitEnvironmentSettings(); Display.ToggleCloudLayer2Dialog()", 2, true)

    -----------------------------------------------------------------------------------------------
    -- Script Console (use always Ctrl + Shift + Alt key)
    -----------------------------------------------------------------------------------------------

    Input.KeyBindDown(Keys.ModifierControl + Keys.ModifierShift + Keys.ModifierAlt + Keys.C, "Display.ToggleScriptConsole()", 2, true)

    -----------------------------------------------------------------------------------------------
    -- Development key bindings for overloading
    -----------------------------------------------------------------------------------------------

    KeyBindingsDev_Init()

end


-- ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
-- Helper
-- ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++

function IsTechnologyUsable(_TechnologyType)
    local PlayerID = GUI.GetPlayerID()

    if _TechnologyType == nil then
        _TechnologyType = 0
    end

    if EnableRights ~= true then
        return true
    end

    if Activated[_TechnologyType] == false then
        return false
    end

    if _TechnologyType ~= 0 and Logic.TechnologyGetState(PlayerID, _TechnologyType) == TechnologyStates.Locked then
        return false
    end

    if _TechnologyType ~= 0 and Logic.TechnologyGetState(PlayerID, _TechnologyType) == TechnologyStates.Researched then
        return true
    end

    return false
end

function IsButtonEnabled(_Widget)
    return XGUIEng.IsWidgetShownEx(_Widget) == 1 and XGUIEng.IsButtonDisabled(_Widget) == 0
end


-- ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
-- Local Functions
-- ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++

function KeyBindings_KnockDown()
    if IsButtonEnabled("/InGame/Root/Normal/AlignBottomRight/BuildMenu/Categories/KnockDown") then
        GUI_Construction.KnockDownClicked()
    end
end


function KeyBindings_BuildStreet()
    if IsTechnologyUsable(Technologies.R_Street) then
        GUI_Construction.BuildStreetClicked()
    end
end


function KeyBindings_BuildTrail()
    if IsTechnologyUsable(Technologies.R_Trail) then
        GUI_Construction.BuildStreetClicked(true)
    end
end


function KeyBindings_TogglePause()

    if g_Throneroom ~= nil
    or Framework and Framework.IsNetworkGame()
    or GUI_Window.IsOpen("MainMenu")
    or GUI_Window.IsOpen("MissionEndScreen")
    or XGUIEng.IsWidgetShownEx("/InGame/MissionStatistic") == 1
    or XGUIEng.IsWidgetShownEx("/LoadScreen/LoadScreen") == 1 then
        return
    end

    if Display.GetFramesRendered() < 10 then
        return
    end

    local Speed = Game.GameTimeGetFactor()
    if Speed == 0 then
        Game.GameTimeSetFactor( GUI.GetPlayerID(), 1 )
    else
        Game.GameTimeSetFactor( GUI.GetPlayerID(), 0 )
    end

end


function KeyBindings_SaveGame()
    --[[
    if g_Throneroom ~= nil
    or Framework and Framework.IsNetworkGame()
    or XGUIEng.IsWidgetShownEx("/InGame/MissionStatistic") == 1
    or GUI_Window.IsOpen("MissionEndScreen")
    or XGUIEng.IsWidgetShownEx("/LoadScreen/LoadScreen") == 1
    or XGUIEng.IsWidgetShownEx("/InGame/Dialog") == 1 then
        return
    end

    OpenDialog("{cr}{cr}" .. XGUIEng.GetStringTableText("UI_Texts/Saving_center") .. "{cr}{cr}" .. "QuickSave", XGUIEng.GetStringTableText("UI_Texts/MainMenuSaveGame_center"))
    XGUIEng.ShowWidget("/InGame/Dialog/Ok", 0);
    
    Dialog_SetUpdateCallback( KeyBindings_SaveGame_Delayed )
    --]]
end

function KeyBindings_SaveGame_Neu()
    
    if g_Throneroom ~= nil
    or Framework and Framework.IsNetworkGame()
    or XGUIEng.IsWidgetShownEx("/InGame/MissionStatistic") == 1
    or GUI_Window.IsOpen("MissionEndScreen")
    or XGUIEng.IsWidgetShownEx("/LoadScreen/LoadScreen") == 1
    or XGUIEng.IsWidgetShownEx("/InGame/Dialog") == 1 then
        return
    end

    OpenDialog("{cr}{cr}" .. XGUIEng.GetStringTableText("UI_Texts/Saving_center") .. "{cr}{cr}" .. "QuickSave", XGUIEng.GetStringTableText("UI_Texts/MainMenuSaveGame_center"))
    XGUIEng.ShowWidget("/InGame/Dialog/Ok", 0);
    
    Dialog_SetUpdateCallback( KeyBindings_SaveGame_Delayed )
    
end

function KeyBindings_SaveGame_Delayed()

    Framework.SaveGame("QuickSave","Quick saved game")
    
end

function KeyBindings_LoadGame()

    if g_Throneroom ~= nil
    or Framework and Framework.IsNetworkGame()
    or GUI_Window.IsOpen("MissionEndScreen")
    or XGUIEng.IsWidgetShownEx("/InGame/MissionStatistic") == 1
    or XGUIEng.IsWidgetShownEx("/LoadScreen/LoadScreen") == 1 then
        return
    end

    if Framework.BeforeStartMap() == false then
        OpenRequesterDialog(XGUIEng.GetStringTableText("UI_Texts/NoValidCDFound"), "", "KeyBindings_LoadGame()", 1)
        return
    end

    Framework.LoadGameAndExitCurrentGame("QuickSave")

end


function KeyBindings_OpenInGameMenu()

    if g_Throneroom ~= nil
    or GUI_Window.IsOpen("MissionEndScreen")
    or XGUIEng.IsWidgetShownEx("/InGame/MissionStatistic") == 1
    or XGUIEng.IsWidgetShownEx("/LoadScreen/LoadScreen") == 1  then
        return
    end

    GUI_Window.Toggle("MainMenu")

end


function GameCallback_GameSpeedChanged( _Speed )

    if Logic.GetTime() >= 2 then

        GUI_Minimap.ToggleGameSpeedUpdate( _Speed )

        if _Speed == 0 then
            local Text = XGUIEng.GetStringTableText("UI_Texts/GamePaused")

            if Framework.IsDevM() == true then
                GUI.AddNote(Text)
            end

            if Debug_EnableDebugOutput or g_OnGameStartPresentationMode then
                return
            end

            XGUIEng.ShowWidget("/InGame/Root/Normal/PauseScreen",1)

        else
            if Framework.IsDevM() == true then
                GUI.AddNote("DevMachine Debug: Game continues (speed " .. _Speed .. ")")
            end

            if Debug_EnableDebugOutput or g_OnGameStartPresentationMode then
                return
            end

            XGUIEng.ShowWidget("/InGame/Root/Normal/PauseScreen",0)
        end
    end
end


gvKeyBindings_OnScreenInformationFlag = 1

function KeyBindings_ToggleOnScreenInformation()
    GUI.Debug_OnScreenInformation_ShowAllInformation(gvKeyBindings_OnScreenInformationFlag)
    gvKeyBindings_OnScreenInformationFlag = 1 - gvKeyBindings_OnScreenInformationFlag
end


function KeyBindings_ToggleFOW()

    GUI.SendScriptCommand("Cheats_ToggleFoW()")

    local PlayerID = GUI.GetPlayerID()
    if Framework.IsNetworkGame() == true then
        GUI.SendScriptCommand("GUI.AddNote(\"Player " .. Logic.GetPlayerName(PlayerID) .. " called Cheats_ToggleFoW\")", false)
    end

end


function KeyBindings_AddGoodToHeadquarters(_GoodType, _Amount)

    local PlayerID = GUI.GetPlayerID()
    GUI.SendScriptCommand("Cheats_AddGoodToPlayer(" .. PlayerID .. ", " .. _GoodType .. ", " .. _Amount .. ")")

    if Framework.IsNetworkGame() == true then
        GUI.SendScriptCommand("GUI.AddNote(\"Player " .. Logic.GetPlayerName(PlayerID) .. " called Cheats_AddGoodToPlayer\")", false)
    end

end


function KeyBindings_AddGoodsToHeadquarters()

    local PlayerID = GUI.GetPlayerID()
    GUI.SendScriptCommand("Cheats_AddGoodsToPlayer(" .. PlayerID .. ")")

    if Framework.IsNetworkGame() == true then
        GUI.SendScriptCommand("GUI.AddNote(\"Player " .. Logic.GetPlayerName(PlayerID) .. " called Cheats_AddGoodsToPlayer\")", false)
    end

end


function KeyBindings_AddGoodToSupermarket(_GoodType, _Amount)

    local PlayerID = GUI.GetPlayerID()
    GUI.SendScriptCommand("Cheats_AddGoodToSupermarket(" .. PlayerID .. ", " .. _GoodType .. ", " .. _Amount .. ")")

    if Framework.IsNetworkGame() == true then
        GUI.SendScriptCommand("GUI.AddNote(\"Player " .. Logic.GetPlayerName(PlayerID) .. " called Cheats_AddGoodToSupermarket\")", false)
    end

end


function KeyBindings_AddGoodsToSupermarket()

    local PlayerID = GUI.GetPlayerID()
    GUI.SendScriptCommand("Cheats_AddGoodsToSupermarket(" .. PlayerID .. ")")

    if Framework.IsNetworkGame() == true then
        GUI.SendScriptCommand("GUI.AddNote(\"Player " .. Logic.GetPlayerName(PlayerID) .. " called Cheats_AddGoodsToSupermarket\")", false)
    end
end


function KeyBindings_SetBuildingOnFire()

    local EntityID = GUI.GetSelectedEntity()

    if (EntityID ~= nil) and (EntityID ~= 0) then
        if Logic.IsBuilding(EntityID) == 1 then
            local PlayerID = GUI.GetPlayerID()
            GUI.SendScriptCommand("Cheats_SetBuildingOnFire(" .. EntityID .. ")")
            if Framework.IsNetworkGame() == true then
                GUI.SendScriptCommand("GUI.AddNote(\"Player " .. Logic.GetPlayerName(PlayerID) .. " called Cheats_SetBuildingOnFire\")", false)
            end
        else
            GUI.AddNote("Debug: Selected entity isn't a building!")
        end
    else
        GUI.AddNote("Debug: No entity selected!")
    end

end


function KeyBindings_HurtEntity()

    local EntityID = GUI.GetSelectedEntity()

    if (EntityID ~= nil) and (EntityID ~= 0) then
        GUI.SendScriptCommand("Cheats_HurtEntity(" .. EntityID .. ")")

        local PlayerID = GUI.GetPlayerID()
        if Framework.IsNetworkGame() == true then
            GUI.SendScriptCommand("GUI.AddNote(\"Player " .. Logic.GetPlayerName(PlayerID) .. " called Cheats_HurtEntity\")", false)
        end
    end

end


function KeyBindings_ModifySettlerState( _Need, _Value)

    local EntityID = GUI.GetSelectedEntity()

    if (EntityID ~= nil) and (EntityID ~= 0) then

        GUI.SendScriptCommand("Cheats_ModifyNeedState(" .. EntityID .. ", " .. _Need ..", " .. _Value .. ")")

        local PlayerID = GUI.GetPlayerID()
        if Framework.IsNetworkGame() == true then
            GUI.SendScriptCommand("GUI.AddNote(\"Player " .. Logic.GetPlayerName(PlayerID) .. " called Cheats_Modify State\")", false)
        end
    else
        GUI.AddNote("Debug: No entity selected!")
    end

end


function KeyBindings_AddOrRemoveLuxuryGood(_Add)

    local EntityID = GUI.GetSelectedEntity()

    if (EntityID ~= nil) and (EntityID ~= 0) then
        if Logic.IsSettler(EntityID) == 1 then
            if _Add then
                GUI.SendScriptCommand("Cheats_AddLuxuryGood(" .. EntityID .. ")")
            else
                GUI.SendScriptCommand("Cheats_RemoveLuxuryGood(" .. EntityID .. ")")
            end

            local PlayerID = GUI.GetPlayerID()

            if Framework.IsNetworkGame() == true then
                GUI.SendScriptCommand("GUI.AddNote(\"Player " .. Logic.GetPlayerName(PlayerID) .. " called Cheats_. . . LuxuryGood\")", false)
            end
        else
            GUI.AddNote("Debug: Selected entity isn't a settler!")
        end
    else
        GUI.AddNote("Debug: No entity selected!")
    end

end


VolumesTable = {}
VolumesTable.MuteSound = false
VolumesTable.MuteMusic = false
VolumesTable.SpeechVolume       = Sound.GetSpeechVolume()
VolumesTable.FXVolume           = Sound.GetFXVolume()
VolumesTable.FXAtmoVolume       = Sound.GetFXAtmoVolume()
VolumesTable.FXSoundpointVolume = Sound.GetFXSoundpointVolume()
VolumesTable.MusicVolume        = Sound.GetMusicVolume()


function KeyBindings_ToggleMusic()

    if (VolumesTable.MuteMusic == false) then
        Sound.SetMusicVolume(0)
        GUI.AddNote("Debug: Music Off")
        VolumesTable.MuteMusic = true
    else
        Sound.SetMusicVolume(VolumesTable.MusicVolume )
        GUI.AddNote("Debug: Music On")
        VolumesTable.MuteMusic = false
    end

end


function KeyBindings_ToggleSound()

    if (VolumesTable.MuteSound == false) then

        -- turn off
        Sound.SetSpeechVolume(0)
        Sound.SetFXVolume(0)
        Sound.SetFXAtmoVolume(0)
        Sound.SetFXSoundpointVolume(0)

        -- gui note
        GUI.AddNote("Debug: Sound Off")
        VolumesTable.MuteSound = true

    else

        -- reset orginal volume
        Sound.SetSpeechVolume       (VolumesTable.SpeechVolume)
        Sound.SetFXVolume           (VolumesTable.FXVolume)
        Sound.SetFXAtmoVolume       (VolumesTable.FXAtmoVolume)
        Sound.SetFXSoundpointVolume (VolumesTable.FXSoundpointVolume)

        -- gui note
        GUI.AddNote("Debug: Sound On")
        VolumesTable.MuteSound = false

    end

end



function KeyBindings_ToggleSoundAtmoSets()

    if (Sound.GetFXAtmoVolume() == 0) then
        Sound.SetFXAtmoVolume(1)
        GUI.AddNote("Debug: ATMOSET ON")
    else
        Sound.SetFXAtmoVolume(0)
        GUI.AddNote("Debug: ATMOSET OFF")
    end

end

function KeyBindings_DbgCppException()

    GUI.AddNote("Debug C++ exception...")

    Framework.DbgCppException()

end


function KeyBindings_DbgException()

    GUI.AddNote("Debug exception...")

    Framework.DbgException()

end


function KeyBindings_DbgError()

    GUI.AddNote("Debug error...")
    Framework.DbgError()

end


function KeyBindings_DbgPureVirtualFunctionCall()

    GUI.AddNote("Debug pure virtual function call...")
    Framework.DbgPureVirtualFunctionCall()

end


function KeyBindings_DbgStackOverflow()

    GUI.AddNote("Debug stack overflow...")
    Framework.DbgStackOverflow()

end


function KeyBindings_DbgBindErrorFunctions()

    Input.KeyBindDown(Keys.ModifierAlt + Keys.ModifierControl + Keys.ModifierShift + Keys.D1, "KeyBindings_DbgCppException()", 2, true)
    Input.KeyBindDown(Keys.ModifierAlt + Keys.ModifierControl + Keys.ModifierShift + Keys.D2, "KeyBindings_DbgException()", 2, true)
    Input.KeyBindDown(Keys.ModifierAlt + Keys.ModifierControl + Keys.ModifierShift + Keys.D3, "KeyBindings_DbgError()", 2, true)
    Input.KeyBindDown(Keys.ModifierAlt + Keys.ModifierControl + Keys.ModifierShift + Keys.D4, "KeyBindings_DbgPureVirtualFunctionCall()", 2, true)
    Input.KeyBindDown(Keys.ModifierAlt + Keys.ModifierControl + Keys.ModifierShift + Keys.D5, "KeyBindings_DbgStackOverflow()", 2, true)

end


function KeyBindings_CheatWife()

    GUI.SendScriptCommand("Cheats_CheatWife(" .. GUI.GetPlayerID() .. ")")

    local PlayerID = GUI.GetPlayerID()
    if Framework.IsNetworkGame() == true then
        GUI.SendScriptCommand("GUI.AddNote(\"Player " .. Logic.GetPlayerName(PlayerID) .. " called Cheats_CheatWife\")", false)
    end

end


function KeyBindings_ActivateNeed(_Need)

    GUI.SendScriptCommand("Cheats_ActivateNeed(" .. GUI.GetPlayerID() .. "," .. _Need .. ")")

    local PlayerID = GUI.GetPlayerID()
    if Framework.IsNetworkGame() == true then
        GUI.SendScriptCommand("GUI.AddNote(\"Player " .. Logic.GetPlayerName(PlayerID) .. " called Cheats_ActivateNeed\")", false)
    end

end



function KeyBindings_ModifyEarnings(_Value)

    local EntityID = GUI.GetSelectedEntity()

    if (EntityID ~= nil) and (EntityID ~= 0) then

        GUI.SendScriptCommand("Cheats_ModifyEarnings(" .. EntityID .. "," .. _Value .. ")")

        local PlayerID = GUI.GetPlayerID()
        if Framework.IsNetworkGame() == true then
            GUI.SendScriptCommand("GUI.AddNote(\"Player " .. Logic.GetPlayerName(PlayerID) .. " called Cheats_ModifyEarnings\")", false)
        end


    end

end


function KeyBindings_RemoveGoodsFromOutStock(_amount)

    local EntityID = GUI.GetSelectedEntity()
    if EntityID ~= nil then
        GUI.SendScriptCommand("Cheats_RemoveGoodsFromOutStock(" .. EntityID .. ", " .. _amount ..")")

        local PlayerID = GUI.GetPlayerID()
        if Framework.IsNetworkGame() == true then
            GUI.SendScriptCommand("GUI.AddNote(\"Player " .. Logic.GetPlayerName(PlayerID) .. " called Cheats_RemoveGoodsFromOutStock\")", false)
        end
    end
end


function KeyBindings_AddGoodsToOutStock(_amount)

    local EntityID = GUI.GetSelectedEntity()
    GUI.SendScriptCommand("Cheats_AddGoodsToOutStock(" .. EntityID .. "," ..  _amount ..")")

    local PlayerID = GUI.GetPlayerID()
    if Framework.IsNetworkGame() == true then
        GUI.SendScriptCommand("GUI.AddNote(\"Player " .. Logic.GetPlayerName(PlayerID) .. " called Cheats_AddGoodsToOutStock\")", false)
    end

end


function KeyBindings_CreateEntityAtMousePositionForActiveGUIPlayer(_EntityType)

    local x,y = GUI.Debug_GetMapPositionUnderMouse()
    if x~= -1 then
        local PlayerID = GUI.GetPlayerID()

        GUI.SendScriptCommand("Cheats_CreateEntityAtMousePositionForActiveGUIPlayer("    .. _EntityType .. ","
                                                                                         .. PlayerID .. ","
                                                                                         .. x .. ","
                                                                                         .. y .. ")")

        if Framework.IsNetworkGame() == true then
            GUI.SendScriptCommand("GUI.AddNote(\"Player " .. Logic.GetPlayerName(PlayerID) .. " called Cheats_CreateEntityAtMousePositionForActiveGUIPlayer\")", false)
        end

    end
end


function KeyBindings_StopGuard()
    local EntityID = GUI.GetSelectedEntity()
    GUI.StopGuardEntity(EntityID)
end


function KeyBindings_StopOperating()

    local EntityID = GUI.GetSelectedEntity()

    if EntityID ~= nil then
        GUI.DetachFromWarMachine(EntityID)
    end

end


function KeyBindings_CreateBattalionOnMousePositionForActiveGUIPlayer(_BattalionType)

    local x,y = GUI.Debug_GetMapPositionUnderMouse()
    if x~= -1 then
        local PlayerID = GUI.GetPlayerID()

        GUI.SendScriptCommand("Cheats_CreateBattalionOnMousePositionForActiveGUIPlayer("    .. _BattalionType .. ","
                                                                                            .. PlayerID .. ","
                                                                                            .. x .. ","
                                                                                            .. y .. ")")

        if Framework.IsNetworkGame() == true then
            GUI.SendScriptCommand("GUI.AddNote(\"Player " .. Logic.GetPlayerName(PlayerID) .. " called Cheats_CreateBattalionOnMousePositionForActiveGUIPlayer\")", false)
        end

    end
end


-- TODO [DiMe] This function shouldn't be here...

function GameCallback_Escape()
    Camera.CancelCutscene()
    CutsceneLength = 0
    g_EscapeHasBeenPressed = true
    CameraAnimation.Abort()
end


function KeyBindings_ToggleRights()
    if EnableRights == nil or EnableRights == false then
        EnableRights = true
    else
        EnableRights = false
    end
    GUI_Construction.RefreshBuildingButtons()
end


function KeyBindings_ToggleClock()
    if XGUIEng.IsWidgetShown("/InGame/Root/Normal/AlignTopLeft/GameClock") == 1 then
        XGUIEng.ShowWidget("/InGame/Root/Normal/AlignTopLeft/GameClock",0)
    else
        XGUIEng.ShowWidget("/InGame/Root/Normal/AlignTopLeft/GameClock",1)
    end
end


function KeyBindings_StartChat()
    if Framework.IsNetworkGame()
    and Logic.PlayerGetGameState(GUI.GetPlayerID()) ~= 3 then
        GUI_Chat.Enable()
    end
end


function KeyBindings_AbortChatMessage()
    GUI_Chat.Abort()
end

function KeyBindings_EnableDebugMode(_Sequence)

    -- disable cheats
    if _Sequence == 0 then
        Input.EnableDebugMode(0)
        return
    end

    -- activation of cheats is forbidden in tages runtime and multiplayer games
    if Framework.IsTagesRuntime() and Framework.IsNetworkGame() then
        return
    end

    Input.EnableDebugMode(_Sequence)

end

function KeyBindings_SendThiefDeliverToCastle()
    local ThiefID = GUI.GetSelectedEntity()

    if ThiefID ~= nil
    and Logic.IsEntityInCategory(ThiefID, EntityCategories.Thief) == 1 then
        local PlayerID = GUI.GetPlayerID()
        GUI.SendThiefDeliverToCastle(PlayerID, ThiefID)
    end
end


KeyBindingsLastSelectedMilitaryUnitCounter  = 1
KeyBindingsLastSelectedMilitaryUnitEntityID = 0

function KeyBindings_ToggleThroughMilitaryUnits()

    Sound.FXPlay2DSound( "ui\\mini_toggle_batallion")

    local PlayerID = GUI.GetPlayerID()

    local AllMilitaryUnits = { Logic.GetPlayerEntitiesInCategory(PlayerID, EntityCategories.Leader) }

    local SiegeEngineCarts = { Logic.GetPlayerEntitiesInCategory(PlayerID, EntityCategories.HeavyWeapon) }

    local Thieves = { Logic.GetPlayerEntitiesInCategory(PlayerID, EntityCategories.Thief) }

    for j=1, #SiegeEngineCarts do
        local CartID = SiegeEngineCarts[j]
        table.insert(AllMilitaryUnits, CartID)
    end

    for j=1, #Thieves do
        local ThiefID = Thieves[j]
        table.insert(AllMilitaryUnits, ThiefID)
    end

    local MilitaryUnits = {}

    for j=1, #AllMilitaryUnits do
        local SelectableEntityID = GUI.GetSelectableEntity(AllMilitaryUnits[j])
        --if GUI.IsEntityInAnyNormalSelectionGroup(SelectableEntityID) == false then
            if SelectableEntityID ~= 0 then
                local Found = false
                for k = 1, #MilitaryUnits do
                    if MilitaryUnits[k] == SelectableEntityID then
                        Found = true
                        break
                    end
                end
                if Found == false then
                    table.insert(MilitaryUnits, SelectableEntityID)
                end
            end
        --end
    end

    if #MilitaryUnits == 0 then
        return
    end

    for k = 1, #MilitaryUnits do
        if MilitaryUnits[k] == KeyBindingsLastSelectedMilitaryUnitEntityID then
            KeyBindingsLastSelectedMilitaryUnitCounter = k
            break
        end
    end

    KeyBindingsLastSelectedMilitaryUnitCounter = KeyBindingsLastSelectedMilitaryUnitCounter + 1

    if KeyBindingsLastSelectedMilitaryUnitCounter > table.getn(MilitaryUnits) then
        KeyBindingsLastSelectedMilitaryUnitCounter = 1
    end

    KeyBindingsLastSelectedMilitaryUnitEntityID = MilitaryUnits[KeyBindingsLastSelectedMilitaryUnitCounter]

    local x,y = Logic.GetEntityPosition(KeyBindingsLastSelectedMilitaryUnitEntityID)

    Camera.RTS_SetLookAtPosition(x,y)
    GUI.SetSelectedEntity(KeyBindingsLastSelectedMilitaryUnitEntityID)
end


function DisplaySettlerTask()

    local SettlerID = GUI.GetSelectedEntity()

    if SettlerID ~= nil

    and ( Logic.IsSettler(SettlerID) == 1 or Logic.IsLeader(SettlerID) == 1 or Logic.IsKnight(SettlerID) == true ) then

        local Tasklist = Logic.GetCurrentTaskList(SettlerID)

        if Tasklist == nil then
            Tasklist = "NO TL ?? Leader selected?"
        end

        local Log = ""

        if Logic.IsSettler(SettlerID) == 1 then
            Log = ": " .. Logic.GetLoggerTaskTypeName(Logic.GetWorkerLogCurrentTask(SettlerID))
        end

        GUI.AddNote("Debug: " .. SettlerID .. "-> " .. Tasklist .. Log)

    end

end


function KeyBindings_ToggleDebugOutput()

    if Arg_TestTask == nil then

        Arg_TestTask = StartSimpleJob("DisplaySettlerTask")

    else

        EndJob(Arg_TestTask)

        Arg_TestTask = nil

    end

    Debug_EnableDebugOutput = not Debug_EnableDebugOutput


    local Flag = 0

    if XGUIEng.IsWidgetShown("/ingame/root/3dOnscreenDebug") == 0 then
        Flag = 1
    end

    XGUIEng.ShowWidget("/ingame/root/3dOnscreenDebug",Flag)
    GUI.Debug_OnScreenDebug_ShowBuildingInfo(0)
    GUI.Debug_OnScreenDebug_ShowSettlerInfo(0)
    GUI.Debug_OnScreenInformation_ShowAllInformation(Flag)

end


g_ShowOnScreenInformationFlag = 0

function KeyBindings_ToggleOutstockInformations()

    g_ShowOnScreenInformationFlag = math.mod(g_ShowOnScreenInformationFlag + 1, 2)

    GUI.Debug_OnScreenInformation_ShowAllInformation(g_ShowOnScreenInformationFlag)
end


function KeyBindings_Victory()

    GUI.AddNote("Debug: Victory cheated")

    GUI.SendScriptCommand("OnLastQuestInCampaignMapFinished()",true)
    GUI.SendScriptCommand("Victory(-1)",true)

end


function KeyBindings_BuildLastPlaced()
    if g_LastPlacedFunction ~= nil then
        g_LastPlacedFunction(g_LastPlacedParam)
    end
end


function KeyBindings_BuildingUpgrade()
    if IsButtonEnabled("/InGame/Root/Normal/BuildingButtons/Upgrade") then
        GUI_BuildingButtons.UpgradeClicked()
    elseif IsButtonEnabled("/InGame/Root/Normal/BuildingButtons/UpgradeSpecialBuilding") then
        GUI_BuildingButtons.UpgradeClicked()
    elseif IsButtonEnabled("/InGame/Root/Normal/BuildingButtons/UpgradeTurret") then
        GUI_BuildingButtons.UpgradeTurretClicked()
    end
end


function KeyBindings_BuildingStartStop()
    if IsButtonEnabled("/InGame/Root/Normal/BuildingButtons/StartStopBuilding") then
        GUI_BuildingButtons.StartStopBuildingClicked()
    end
end


function KeyBindings_MilitaryAttack()
    if IsButtonEnabled("/InGame/Root/Normal/AlignBottomRight/DialogButtons/Military/Attack") then
        GUI_Military.AttackClicked()
    end
end


function KeyBindings_MilitaryStandGround()
    if IsButtonEnabled("/InGame/Root/Normal/AlignBottomRight/DialogButtons/Military/StandGround") then
        GUI_Military.StandGroundClicked()
    end
end


function KeyBindings_MenuDiplomacy()
    if IsButtonEnabled("/InGame/Root/Normal/AlignBottomRight/MapFrame/DiplomacyMenuButton") then
        ToggleDiplomacyMenu()
    end
end


function KeyBindings_MenuProduction()
    if IsButtonEnabled("/InGame/Root/Normal/AlignBottomRight/MapFrame/ProductionMenuButton") then
        ToggleHouseMenu()
    end
end


function KeyBindings_MenuPromotion()
    if IsButtonEnabled("/InGame/Root/Normal/AlignBottomRight/MapFrame/KnightTitle") then
        GUI_Knight.KnightTitleClicked()
    end
end


function KeyBindings_MenuWeather()
    if IsButtonEnabled("/InGame/Root/Normal/AlignBottomRight/MapFrame/WeatherMenuButton") then
        GUI_Window.ToggleWeatherMenu()
    end
end


function KeyBindings_JumpMarketplace()
    local PlayerID = GUI.GetPlayerID()
    local MarketplaceID = Logic.GetMarketplace(PlayerID)
    if MarketplaceID ~= 0 then
        local X, Y = Logic.GetEntityPosition(MarketplaceID)
        Camera.RTS_SetLookAtPosition(X, Y)
    end
end

function KeyBindings_ToggleGameSpeed()
    GUI_Minimap.ToggleGameSpeedClicked()
end

function Keybindings_EnableQuestDebugging()
    Input.KeyBindDown(Keys.ModifierControl + Keys.ModifierShift + Keys.Q, "KeyBindings_QuestTrace()", 2)
    Input.KeyBindDown(Keys.ModifierControl + Keys.ModifierShift + Keys.W, "KeyBindings_DumpQuestStatus()", 2)
end

function KeyBindings_DumpQuestStatus()
    GUI.SendScriptCommand( "DEBUG_DumpQuestStatus()" )
end

function KeyBindings_QuestTrace()
    g_QuestSysTraceActive = not g_QuestSysTraceActive
    GUI.AddNote( "Quest trace: " .. (g_QuestSysTraceActive and "Enabled" or "Disabled") )
end

function KeyBindings_TestFunc()
    if g_Camera.RPGCamEnabled ~= true then
        local PlayerID = GUI.GetPlayerID()
        local KnightID = GUI.GetSelectedEntity()

        EnableRPGMode(KnightID)
    else
        DisableRPGMode()
    end
end