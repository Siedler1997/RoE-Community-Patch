g_AspectGameConfig = {}

g_AspectGameConfig.ValidColors = {}
g_AspectGameConfig.ValidKnightNames = {}
g_AspectGameConfig.ValidVictoryConditions = {}
g_AspectGameConfig.ValidResourceModificators = {}

g_AspectGameConfig.SlotModeInvalid = 0
g_AspectGameConfig.SlotModeHuman   = 1
g_AspectGameConfig.SlotModeCPU     = 2 --only for DevM
g_AspectGameConfig.SlotModeClosed  = 3

g_AspectGameConfig.PreviousCountDown = -1

function g_AspectGameConfig.StartHostAndClientCommon()

    XGUIEng.ShowAllSubWidgets("/InGame/Multiplayer",0)
    XGUIEng.ShowWidget("/InGame/Multiplayer/ContainerBottom",1)
    XGUIEng.ShowWidget("/InGame/Multiplayer/MPGameSettings",1)

    g_MapAndHeroPreview.DoUpdate = true

    g_ChannelChat.LeaveChat()

    g_MainMenuChat.EmptyChatLog()

    g_UserNotificationCallback = g_MainMenuChat.UserNotificationCallback

    local MapName, MapType, MapExtraNo = Network.GetCurrentMap()

    g_AspectGameConfig.MaxPlayers = Framework.GetMapMaxPlayers(MapName, MapType)

    g_AspectGameConfig.ValidColors = {GetMPValidPlayerColors(MapName, MapType)}
    g_AspectGameConfig.ValidKnightNames = {GetMPValidKnightNames(MapName, MapType)}
    g_AspectGameConfig.ValidVictoryConditions = {GetMPValidVictoryConditions(MapName, MapType)}--GiBo: not used because of checkbox
    g_AspectGameConfig.ValidResourceModificators = {GetMPValidResourceModificators(MapName, MapType)}


    g_AspectGameConfig.InitResourceList()
    g_AspectGameConfig.InitVictoryList()

    for i=1, 4 do
        if i <= g_AspectGameConfig.MaxPlayers then
            XGUIEng.ShowWidget("/InGame/Multiplayer/MPGameSettings/ClientServerSettings/PlayerSlots/Slot" .. i, 1)

            g_AspectGameConfig.InitHeroList(i)
            g_AspectGameConfig.InitTeamList(i)

        else
            XGUIEng.ShowWidget("/InGame/Multiplayer/MPGameSettings/ClientServerSettings/PlayerSlots/Slot" .. i, 0)
        end
    end

    g_MapAndHeroPreview.ShowMapAndHeroWindows(1)
    local MapName, MapType = Network.GetCurrentMap()
    g_MapAndHeroPreview.SelectMap(MapName, MapType)
    g_MapAndHeroPreview.InitPlayerSlots(MapName, MapType)

    XGUIEng.SetFocus("/InGame/Multiplayer/MPGameSettings/Chat/MessageContainer/Message")

end
----------------------------------------------------------------------------------------------------------------------
function g_AspectGameConfig.StartHostGame()

    g_MapAndHeroPreview.ShowMapWindow(0)--instead of g_CreateGamePage.CreateGame() in case of errors

    g_AspectGameConfig.StartHostAndClientCommon()

    g_MainMenuMultiplayer:DisplayBottomButtons("/InGame/Multiplayer/ContainerBottom/StartGame",
                                               "/InGame/Multiplayer/ContainerBottom/Cancel")

end
----------------------------------------------------------------------------------------------------------------------
function g_AspectGameConfig.StartClientGame()

	if Network.IsQuickmatch() then
		g_MapAndHeroPreview.ShowMapWindow(0)
	end
    g_AspectGameConfig.StartHostAndClientCommon()

    g_MainMenuMultiplayer:DisplayBottomButtons("/InGame/Multiplayer/ContainerBottom/Cancel")

    g_AspectGameConfig.DisableWidget("/InGame/Multiplayer/MPGameSettings/ClientServerSettings/ResourceModificatorCheckBox",0,1)

    g_AspectGameConfig.DisableWidget("/InGame/Multiplayer/MPGameSettings/ClientServerSettings/VictoryConditionsCheckBoxes/DestroySpecialBuildingCheckBox",0,1)
    g_AspectGameConfig.DisableWidget("/InGame/Multiplayer/MPGameSettings/ClientServerSettings/VictoryConditionsCheckBoxes/ManyEnnemiesCheckBox",0,1)
    g_AspectGameConfig.DisableWidget("/InGame/Multiplayer/MPGameSettings/ClientServerSettings/VictoryConditionsCheckBoxes/ArchdukeCheckBox",0,1)

end
----------------------------------------------------------------------------------------------------------------------
function g_AspectGameConfig.Back()

	Network.SetIsQuickmatch(0)

    XGUIEng.SetAllButtonsDisabled()

    Network.LeaveGame()

end
----------------------------------------------------------------------------------------------------------------------
function g_AspectGameConfig.GameLeft()

	Network.SetIsQuickmatch(0)

    g_MapAndHeroPreview.ShowMapAndHeroWindows(0)

    g_UserNotificationCallback = nil
    g_OnlinePage.Show()

	XGUIEng.SetAllButtonsEnabledRequest()

end
----------------------------------------------------------------------------------------------------------------------
function g_AspectGameConfig.Kicked()
    g_AspectGameConfig.GameLeft()

    MessageText = XGUIEng.GetStringTableText("UI_Texts/" .. "MultiplayerError_Kicked")

    g_ErrorPage.CreateError(MessageText)
end
----------------------------------------------------------------------------------------------------------------------
function g_AspectGameConfig.HostLeft()
    g_AspectGameConfig.GameLeft()

    MessageText = XGUIEng.GetStringTableText("UI_Texts/" .. "MultiplayerError_HostLeft")

    g_ErrorPage.CreateError(MessageText)
end
----------------------------------------------------------------------------------------------------------------------
function g_AspectGameConfig.KickPlayer(_SlotID)

    Sound.FXPlay2DSound( "ui\\menu_click")

    if Network.GetLocalPlayerNetworkSlotID() ~= 1 or _SlotID == 1 then --only the server can kick, and the server can not be kicked
        return
    end

    Network.SessionHostKickPlayer(_SlotID)


end
----------------------------------------------------------------------------------------------------------------------
function g_AspectGameConfig.Update()

    g_AspectGameConfig.StartGameButtonUpdate()

    g_AspectGameConfig.UpdateResourceModificatorButton()
    g_AspectGameConfig.UpdateVictoryConditionButton()

    for i = 1, g_AspectGameConfig.MaxPlayers do
        g_AspectGameConfig.UpdatePlayerColor(i)
        g_AspectGameConfig.UpdatePlayerSlotButton(i)
        g_AspectGameConfig.UpdatePlayerKickButton(i)
        g_AspectGameConfig.UpdateKnightButton(i)
        g_AspectGameConfig.UpdateNetworkSlotTeamButton(i)
        g_AspectGameConfig.UpdatePlayerSlotReadyButton(i)
    end

    g_AspectGameConfig.UpdateLadderMatch()
    g_AspectGameConfig.UpdateCountdownWidget()

end
----------------------------------------------------------------------------------------------------------------------
function g_AspectGameConfig.UpdatePlayerSlotButton(_PlayerSlot)
    local Widget = "/InGame/Multiplayer/MPGameSettings/ClientServerSettings/PlayerSlots/Slot" .. _PlayerSlot .."/Name/PlayerName"

    local CurrentSlotConfig = Network.GetSlotConfigForNetworkSlotID(_PlayerSlot)

    local DisplayText
    if CurrentSlotConfig == g_AspectGameConfig.SlotModeHuman then
        if Network.IsNetworkSlotIDUsed(_PlayerSlot) == true then
            DisplayText = "{center}" .. Network.GetNameForNetworkSlotID(_PlayerSlot)
        else
            DisplayText = "{center}" .. XGUIEng.GetStringTableText("UI_Texts/MainMenuMultiFreeSlot_center")
        end
    elseif CurrentSlotConfig == g_AspectGameConfig.SlotModeCPU then
        DisplayText = "{center}" .. "CPU"
    elseif CurrentSlotConfig == g_AspectGameConfig.SlotModeClosed then
        DisplayText = "{center}" .. XGUIEng.GetStringTableText("UI_Texts/MainMenuMultiClosed_center")
    end

    XGUIEng.SetText( Widget , DisplayText)

    if Network.GetLocalPlayerNetworkSlotID() == 1 then

        if CurrentSlotConfig == g_AspectGameConfig.SlotModeHuman
            and Network.IsNetworkSlotIDUsedByHumanPlayer(_PlayerSlot) then

            g_AspectGameConfig.DisableWidget(Widget, 1, 1)
        else
            g_AspectGameConfig.DisableWidget(Widget, 1, 0)
        end

    else
        g_AspectGameConfig.DisableWidget(Widget, 1, 1)
    end

end
----------------------------------------------------------------------------------------------------------------------
function g_AspectGameConfig.UpdatePlayerKickButton(_PlayerSlot)

    if _PlayerSlot == 1 then --can't kick the server ! (no button)
        return
    end

    local Widget = "/InGame/Multiplayer/MPGameSettings/ClientServerSettings/PlayerSlots/Slot" .. _PlayerSlot .."/Kick"
    local CurrentSlotConfig = Network.GetSlotConfigForNetworkSlotID(_PlayerSlot)

    if Network.GetLocalPlayerNetworkSlotID() == 1 then
        XGUIEng.ShowWidget(Widget, 1)
        if CurrentSlotConfig == g_AspectGameConfig.SlotModeHuman
            and Network.IsNetworkSlotIDUsedByHumanPlayer(_PlayerSlot) then

            g_AspectGameConfig.DisableWidget(Widget, 0, 0)
        else
            g_AspectGameConfig.DisableWidget(Widget, 0, 1)
        end

    else
        XGUIEng.ShowWidget(Widget, 0)
        g_AspectGameConfig.DisableWidget(Widget, 0, 1)

    end

end
----------------------------------------------------------------------------------------------------------------------
function g_AspectGameConfig.PlayerSlotButtonPressed(_PlayerSlot)

    Sound.FXPlay2DSound( "ui\\menu_click")

    local CurrentSlotConfig = Network.GetSlotConfigForNetworkSlotID(_PlayerSlot)

    --CPU allow only on DevM

    if CurrentSlotConfig == g_AspectGameConfig.SlotModeCPU-1 then
        if not Framework.IsDevM() then
            Network.SetSlotConfigForNetworkSlotID(_PlayerSlot, (CurrentSlotConfig % 3) + 2)
        else
            Network.SetSlotConfigForNetworkSlotID(_PlayerSlot, (CurrentSlotConfig % 3) + 1)
        end
    else
        Network.SetSlotConfigForNetworkSlotID(_PlayerSlot, (CurrentSlotConfig % 3) + 1)
    end

end
----------------------------------------------------------------------------------------------------------------------
function g_AspectGameConfig.ReadyButton()
    if Network.IsLocalPlayerReady() then
        Network.SetLocalPlayerIsReady(false)
    else
        Network.SetLocalPlayerIsReady(true)
    end
end
----------------------------------------------------------------------------------------------------------------------
function g_AspectGameConfig.UpdatePlayerColor(_SlotID)

    local ColorWidgetID = XGUIEng.GetWidgetID("/InGame/Multiplayer/MPGameSettings/ClientServerSettings/PlayerSlots/Slot".. _SlotID .."/Color")

    local CurrentColorID = Network.GetPlayerColorIndexForNetworkSlotID(_SlotID)

    local R, G, B

    if CurrentColorID == 0 then
        R, G, B = XGUIEng.GetPlayerColor(0)
    else
        R, G, B = XGUIEng.GetPlayerColor(g_AspectGameConfig.ValidColors[CurrentColorID])
    end

    XGUIEng.SetMaterialColor(ColorWidgetID, 0, R, G, B, 255)
    XGUIEng.SetMaterialColor(ColorWidgetID, 1, R, G, B, 255)
    XGUIEng.SetMaterialColor(ColorWidgetID, 2, R, G, B, 255)
    XGUIEng.SetMaterialColor(ColorWidgetID, 3, R, G, B, 128)

    g_AspectGameConfig.SetGameOptionDisableState(_SlotID,ColorWidgetID)
end
----------------------------------------------------------------------------------------------------------------------
function g_AspectGameConfig.PlayerColorPressed(_SlotID)

    Sound.FXPlay2DSound( "ui\\menu_click")

    local NextColor = Network.GetNextFreePlayerColorIndex(Network.GetPlayerColorIndexForNetworkSlotID( _SlotID) + 1)

    if NextColor < 1 then
        NextColor = Network.GetNextFreePlayerColorIndex(1)
        if NextColor == -1 then
           return
        end
    end

    if NextColor >= g_AspectGameConfig.ValidColors[1] and NextColor <= g_AspectGameConfig.ValidColors[#g_AspectGameConfig.ValidColors] then

        Network.SetPlayerColorIndexForNetworkSlotID(_SlotID, NextColor)
        --g_AspectGameConfig.GetTruePlayerColor(NextColor)
    end
end

function g_AspectGameConfig.GetTruePlayerColor(_NextColor)
    g_MainMenuChat.AddToChatLog("NextColor: " .. NextColor)
    return _NextColor
end
----------------------------------------------------------------------------------------------------------------------
function g_AspectGameConfig.InitHeroList(_SlotID)

    local HeroListBoxID = XGUIEng.GetWidgetID("/InGame/Multiplayer/MPGameSettings/ClientServerSettings/PlayerSlots/Slot".. _SlotID .."/HeroComboBoxContainer/ListBoxWidget")

    XGUIEng.ListBoxPopAll(HeroListBoxID, true)

    for i=1,#g_AspectGameConfig.ValidKnightNames do
        XGUIEng.ListBoxPushItem(HeroListBoxID,  XGUIEng.GetStringTableText("UI_ObjectNames/" .. g_AspectGameConfig.ValidKnightNames[i]) )
    end

    --select first slot
    XGUIEng.ListBoxSetSelectedIndex(HeroListBoxID, 0)
    local HeroComboBoxID = XGUIEng.GetWidgetID("/InGame/Multiplayer/MPGameSettings/ClientServerSettings/PlayerSlots/Slot".. _SlotID .."/HeroComboBoxContainer/ListBoxWidget")
    Network.SetKnightIndexForNetworkSlotID(_SlotID, XGUIEng.ListBoxGetSelectedIndex(HeroComboBoxID)+1)
    g_MapAndHeroPreview.SelectKnight( XGUIEng.ListBoxGetSelectedIndex(HeroComboBoxID) )

end
----------------------------------------------------------------------------------------------------------------------
function g_AspectGameConfig.OnHeroListBoxSelectionChange(_SlotID)

    Sound.FXPlay2DSound( "ui\\menu_click")

    local HeroComboBoxID = XGUIEng.GetWidgetID("/InGame/Multiplayer/MPGameSettings/ClientServerSettings/PlayerSlots/Slot".. _SlotID .."/HeroComboBoxContainer/ListBoxWidget")
    Network.SetKnightIndexForNetworkSlotID(_SlotID, XGUIEng.ListBoxGetSelectedIndex(HeroComboBoxID)+1)

    if Network.GetLocalPlayerNetworkSlotID() == _SlotID then
        g_MapAndHeroPreview.SelectKnight( XGUIEng.ListBoxGetSelectedIndex(HeroComboBoxID) )
    end

end
----------------------------------------------------------------------------------------------------------------------
function g_AspectGameConfig.UpdateKnightButton(_SlotID)

    local HeroListBoxID = XGUIEng.GetWidgetID("/InGame/Multiplayer/MPGameSettings/ClientServerSettings/PlayerSlots/Slot".. _SlotID .."/HeroComboBoxContainer/ListBoxWidget")
    local HeroComboBoxID = XGUIEng.GetWidgetID("/InGame/Multiplayer/MPGameSettings/ClientServerSettings/PlayerSlots/Slot".. _SlotID .."/HeroComboBox/ComboBoxWidget")

    g_AspectGameConfig.SetGameOptionDisableState(_SlotID, HeroComboBoxID, 1)

    if Network.IsNetworkSlotIDUsed(_SlotID) == true then

        local KnightIndex = Network.GetKnightIndexForNetworkSlotID(_SlotID)-1
        if KnightIndex < 0 then
            KnightIndex = 0
            Network.SetKnightIndexForNetworkSlotID(_SlotID, 1)
        end

        XGUIEng.ListBoxSetSelectedIndex(HeroListBoxID, KnightIndex)
    else
        XGUIEng.ListBoxSetSelectedIndex(HeroListBoxID, 0)
    end

end
----------------------------------------------------------------------------------------------------------------------
function g_AspectGameConfig.InitVictoryList()

    local VC1CheckBoxID = XGUIEng.GetWidgetID("/InGame/Multiplayer/MPGameSettings/ClientServerSettings/VictoryConditionsCheckBoxes/DestroySpecialBuildingCheckBox")
    local VC2CheckBoxID = XGUIEng.GetWidgetID("/InGame/Multiplayer/MPGameSettings/ClientServerSettings/VictoryConditionsCheckBoxes/ManyEnnemiesCheckBox")
    local VC3CheckBoxID = XGUIEng.GetWidgetID("/InGame/Multiplayer/MPGameSettings/ClientServerSettings/VictoryConditionsCheckBoxes/ArchdukeCheckBox")

    XGUIEng.CheckBoxSetIsChecked(VC1CheckBoxID,true)
    XGUIEng.CheckBoxSetIsChecked(VC2CheckBoxID,true)
    XGUIEng.CheckBoxSetIsChecked(VC3CheckBoxID,true)

    g_AspectGameConfig.OnClickVictoryConditionCheckBox(1)
    g_AspectGameConfig.OnClickVictoryConditionCheckBox(2)
    g_AspectGameConfig.OnClickVictoryConditionCheckBox(3)

end
----------------------------------------------------------------------------------------------------------------------
function g_AspectGameConfig.OnClickVictoryConditionCheckBox(_index)-- _index = 1 for SB destroy/ =2 for many ennemies / =3 for archduke

    if Network.GetLocalPlayerNetworkSlotID() ~= 1 then
        return
    end

    local VC1CheckBoxID = XGUIEng.GetWidgetID("/InGame/Multiplayer/MPGameSettings/ClientServerSettings/VictoryConditionsCheckBoxes/DestroySpecialBuildingCheckBox")
    local VC2CheckBoxID = XGUIEng.GetWidgetID("/InGame/Multiplayer/MPGameSettings/ClientServerSettings/VictoryConditionsCheckBoxes/ManyEnnemiesCheckBox")
    local VC3CheckBoxID = XGUIEng.GetWidgetID("/InGame/Multiplayer/MPGameSettings/ClientServerSettings/VictoryConditionsCheckBoxes/ArchdukeCheckBox")

    if  XGUIEng.CheckBoxIsChecked(VC2CheckBoxID) and
        XGUIEng.CheckBoxIsChecked(VC3CheckBoxID) then

        Network.SetVictoryConditionIndex(1)--Default (all conditions)

    elseif     XGUIEng.CheckBoxIsChecked(VC2CheckBoxID) and
           not XGUIEng.CheckBoxIsChecked(VC3CheckBoxID) then

        Network.SetVictoryConditionIndex(2)--InvadeMarketplace

    elseif not XGUIEng.CheckBoxIsChecked(VC2CheckBoxID) and
               XGUIEng.CheckBoxIsChecked(VC3CheckBoxID) then

        Network.SetVictoryConditionIndex(3)--KnightTitle

    else
        Network.SetVictoryConditionIndex(4)--DestroyOnlySpecialBuilding
    end

end
----------------------------------------------------------------------------------------------------------------------
function g_AspectGameConfig.UpdateVictoryConditionButton()

    local VC1CheckBoxID = XGUIEng.GetWidgetID("/InGame/Multiplayer/MPGameSettings/ClientServerSettings/VictoryConditionsCheckBoxes/DestroySpecialBuildingCheckBox")
    local VC2CheckBoxID = XGUIEng.GetWidgetID("/InGame/Multiplayer/MPGameSettings/ClientServerSettings/VictoryConditionsCheckBoxes/ManyEnnemiesCheckBox")
    local VC3CheckBoxID = XGUIEng.GetWidgetID("/InGame/Multiplayer/MPGameSettings/ClientServerSettings/VictoryConditionsCheckBoxes/ArchdukeCheckBox")


    if Network.GetLocalPlayerNetworkSlotID() ~= 1 then
        g_AspectGameConfig.DisableWidget( VC1CheckBoxID, 0, 1)
        g_AspectGameConfig.DisableWidget( VC2CheckBoxID, 0, 1)
        g_AspectGameConfig.DisableWidget( VC3CheckBoxID, 0, 1)

        XGUIEng.CheckBoxSetIsChecked(VC1CheckBoxID,true)

        if Network.GetVictoryConditionIndex() == 1 then     --Default (all conditions)

            XGUIEng.CheckBoxSetIsChecked(VC2CheckBoxID,true)
            XGUIEng.CheckBoxSetIsChecked(VC3CheckBoxID,true)

        elseif Network.GetVictoryConditionIndex() == 2 then --InvadeMarketplace

            XGUIEng.CheckBoxSetIsChecked(VC2CheckBoxID,true)
            XGUIEng.CheckBoxSetIsChecked(VC3CheckBoxID,false)

        elseif Network.GetVictoryConditionIndex() == 3 then --KnightTitle

            XGUIEng.CheckBoxSetIsChecked(VC2CheckBoxID,false)
            XGUIEng.CheckBoxSetIsChecked(VC3CheckBoxID,true)

        else                                                --DestroyOnlySpecialBuilding

            XGUIEng.CheckBoxSetIsChecked(VC2CheckBoxID,false)
            XGUIEng.CheckBoxSetIsChecked(VC3CheckBoxID,false)

        end

    else
        g_AspectGameConfig.DisableWidget( VC1CheckBoxID, 0, 1)
        g_AspectGameConfig.DisableWidget( VC2CheckBoxID, 0, 0)
        g_AspectGameConfig.DisableWidget( VC3CheckBoxID, 0, 0)
    end

end
----------------------------------------------------------------------------------------------------------------------
function g_AspectGameConfig.InitResourceList()

    local ResourceCheckBoxID = XGUIEng.GetWidgetID("/InGame/Multiplayer/MPGameSettings/ClientServerSettings/ResourceModificatorCheckBox")
    XGUIEng.CheckBoxSetIsChecked(ResourceCheckBoxID,false)

    g_AspectGameConfig.UpdateResourceModificatorButton()
end
----------------------------------------------------------------------------------------------------------------------
function g_AspectGameConfig.OnClickResourceCheckBox()

    Sound.FXPlay2DSound( "ui\\menu_click")

    if Network.GetLocalPlayerNetworkSlotID() ~= 1 then
        return
    end

    local ResourceCheckBoxID = XGUIEng.GetWidgetID("/InGame/Multiplayer/MPGameSettings/ClientServerSettings/ResourceModificatorCheckBox")

    if XGUIEng.CheckBoxIsChecked(ResourceCheckBoxID) == false then
        Network.SetResourceModificatorIndex(1)
    else
        Network.SetResourceModificatorIndex(2)
    end
end
----------------------------------------------------------------------------------------------------------------------
function g_AspectGameConfig.OnClickPrivateSessionCheckBox()

    Sound.FXPlay2DSound( "ui\\menu_click")

    local PrivateSessionCheckBoxID = XGUIEng.GetWidgetID("/InGame/Multiplayer/CreateGame/Container/PrivateSessionCheckBox")
    if XGUIEng.CheckBoxIsChecked(PrivateSessionCheckBoxID) then
        Network.SetPrivateSession(true)
    else
        Network.SetPrivateSession(false)
    end
end

----------------------------------------------------------------------------------------------------------------------
function g_AspectGameConfig.UpdateResourceModificatorButton()

    local ResourceCheckBoxID = XGUIEng.GetWidgetID("/InGame/Multiplayer/MPGameSettings/ClientServerSettings/ResourceModificatorCheckBox")

    if Network.GetLocalPlayerNetworkSlotID() ~= 1 then
        g_AspectGameConfig.DisableWidget( ResourceCheckBoxID, 0, 1)

        if Network.GetResourceModificatorIndex() == 1 then
            XGUIEng.CheckBoxSetIsChecked(ResourceCheckBoxID,false)
        else
            XGUIEng.CheckBoxSetIsChecked(ResourceCheckBoxID,true)
        end

    else
        g_AspectGameConfig.DisableWidget( ResourceCheckBoxID, 0, 0)
    end

end
----------------------------------------------------------------------------------------------------------------------
function g_AspectGameConfig.StartGameButtonUpdate()
    if Network.HostCanStartMPMap() and Network.GetCurrentCountdownValue() == -1 then
        XGUIEng.SetText( "/InGame/Multiplayer/ContainerBottom/StartGame", XGUIEng.GetStringTableText("UI_Texts/MainMenuStartGame_center"))
        XGUIEng.DisableButton( "/InGame/Multiplayer/ContainerBottom/StartGame", 0)
    elseif Network.GetLocalPlayerNetworkSlotID() == 1 and Network.GetCurrentCountdownValue() > -1  then
        XGUIEng.SetText( "/InGame/Multiplayer/ContainerBottom/StartGame", XGUIEng.GetStringTableText("UI_Texts/MainMenuCancelStart_center"))
        XGUIEng.DisableButton( "/InGame/Multiplayer/ContainerBottom/StartGame", 0)
    else
        XGUIEng.SetText( "/InGame/Multiplayer/ContainerBottom/StartGame", XGUIEng.GetStringTableText("UI_Texts/MainMenuStartGame_center"))
        XGUIEng.DisableButton( "/InGame/Multiplayer/ContainerBottom/StartGame", 1)
    end

    --for all players, not only the host
    if Network.GetCurrentCountdownValue() == -1 then
        XGUIEng.DisableButton( "/InGame/Multiplayer/ContainerBottom/Cancel", 0)
    end

end
----------------------------------------------------------------------------------------------------------------------
function g_AspectGameConfig.UpdateCountdownWidget()

    if Network.GetCurrentCountdownValue() > -1 then

        --Disable all buttons
        for i=1, 4 do
            local widget = "/InGame/Multiplayer/MPGameSettings/ClientServerSettings/PlayerSlots/Slot" .. i

            g_AspectGameConfig.DisableWidget(widget .. "/Color", 0, 1)

            g_AspectGameConfig.DisableWidget(widget .. "/Name/PlayerName", 1, 1)
            g_AspectGameConfig.DisableWidget(widget .. "/HeroComboBox/ComboBoxWidget", 1, 1)
            g_AspectGameConfig.DisableWidget(widget .. "/TeamComboBox/ComboBoxWidget", 1, 1)
            g_AspectGameConfig.DisableWidget(widget .. "/ReadyCheckBox", 0, 1)

            --disable map preview buttons
            XGUIEng.DisableButton( "/InGame/Map/ContainerMap/PlayerPositions/Pos" .. i, 1)
            if i~=1 then
                g_AspectGameConfig.DisableWidget(widget .. "/Kick", 0, 1)
            end
        end

        --disable server buttons
        g_AspectGameConfig.DisableWidget("/InGame/Multiplayer/MPGameSettings/ClientServerSettings/ResourceModificatorCheckBox",0,1)

        g_AspectGameConfig.DisableWidget("/InGame/Multiplayer/MPGameSettings/ClientServerSettings/VictoryConditionsCheckBoxes/DestroySpecialBuildingCheckBox",0,1)
        g_AspectGameConfig.DisableWidget("/InGame/Multiplayer/MPGameSettings/ClientServerSettings/VictoryConditionsCheckBoxes/ManyEnnemiesCheckBox",0,1)
        g_AspectGameConfig.DisableWidget("/InGame/Multiplayer/MPGameSettings/ClientServerSettings/VictoryConditionsCheckBoxes/ArchdukeCheckBox",0,1)


        --disable even the cancel button
        XGUIEng.DisableButton( "/InGame/Multiplayer/ContainerBottom/Cancel", 1)


        --show count down
        if Network.GetCurrentCountdownValue() ~= g_AspectGameConfig.PreviousCountDown then

            g_AspectGameConfig.PreviousCountDown = Network.GetCurrentCountdownValue()
            g_MainMenuChat.AddToChatLog("{@color:none}" .. " . . . . . . . . . . " .. Network.GetCurrentCountdownValue() .. " . . . . . . . . . . ")

            --Setzt die Spielerfarbe auf den gewünschten Wert
            if Network.GetCurrentCountdownValue() == 0 then
                for i = 1, 4 do
                    Network.SetPlayerColorIndexForNetworkSlotID(i, g_AspectGameConfig.ValidColors[Network.GetPlayerColorIndexForNetworkSlotID(i)])
                end
            end
        end

    end

end
----------------------------------------------------------------------------------------------------------------------
function g_AspectGameConfig.UpdateLadderMatch()
    g_MapAndHeroPreview.UpdateLadderMatch()
end
----------------------------------------------------------------------------------------------------------------------
function g_AspectGameConfig.UpdatePlayerSlotReadyButton(_PlayerSlot)

    local widget = "/InGame/Multiplayer/MPGameSettings/ClientServerSettings/PlayerSlots/Slot" .. _PlayerSlot .. "/ReadyCheckBox"

    if Network.IsNetworkSlotIDUsedByHumanPlayer(_PlayerSlot) == true then
        if Network.GetIsReadyForNetworkSlotID(_PlayerSlot) then
            XGUIEng.CheckBoxSetIsChecked( widget , true)
        else
            XGUIEng.CheckBoxSetIsChecked( widget , false)
        end

        if Network.GetLocalPlayerNetworkSlotID() == _PlayerSlot then
            if Network.CanLocalPlayerSetReady() and _PlayerSlot ~= 1 then
                g_AspectGameConfig.DisableWidget( widget, 0, 0)
            else
                g_AspectGameConfig.DisableWidget( widget, 0, 1)
            end
        else
            g_AspectGameConfig.DisableWidget( widget, 0, 1)
        end
    else
        XGUIEng.CheckBoxSetIsChecked( widget , false)
        g_AspectGameConfig.DisableWidget( widget, 0, 1)
    end

end
----------------------------------------------------------------------------------------------------------------------
function g_AspectGameConfig.SetGameOptionDisableState(_PlayerSlot, _Widget, _Type) --_Type : 0 : button / 1: combobox

    _Type = _Type or 0

    _Widget = _Widget or XGUIEng.GetCurrentWidgetID()

    if Network.IsNetworkSlotIDUsed(_PlayerSlot) == true then
        if Network.GetLocalPlayerNetworkSlotID() == _PlayerSlot
            or (Network.GetLocalPlayerNetworkSlotID() == 1
                and Network.GetSlotConfigForNetworkSlotID(_PlayerSlot) == g_AspectGameConfig.SlotModeCPU) then

            g_AspectGameConfig.DisableWidget( _Widget, _Type, 0)
        else
            g_AspectGameConfig.DisableWidget( _Widget, _Type, 1)
        end
    else
       g_AspectGameConfig.DisableWidget( _Widget, _Type, 1)
    end
end
----------------------------------------------------------------------------------------------------------------------
function g_AspectGameConfig.DisableWidget(_Widget, _Type, _Value)

    if _Type == 0 then

        XGUIEng.DisableButton( _Widget, _Value)
        if _Value==1 then
            XGUIEng.SetHandleEvents( _Widget, 0)
        else
            XGUIEng.SetHandleEvents( _Widget, 1)
        end

    elseif _Type == 1 then

        local  MotherWidget = XGUIEng.GetWidgetsMotherID(_Widget)
        local BGBottomWidget = XGUIEng.GetWidgetPathByID(MotherWidget) .. "/BGBottom"

        if _Value == 0 then
            XGUIEng.SetMaterialColor( BGBottomWidget, 0,255,255,255,255)
            _Value = 1
        elseif _Value == 1 then
            XGUIEng.SetMaterialColor( BGBottomWidget, 0,200,200,200,255)
            _Value = 0
        end

        XGUIEng.SetHandleEvents(_Widget, _Value)

    end

end
----------------------------------------------------------------------------------------------------------------------
function g_AspectGameConfig.OnClickNetworkSlotReadyButton(_PlayerSlot)

    Sound.FXPlay2DSound( "ui\\menu_click")

    if Network.GetLocalPlayerNetworkSlotID() == _PlayerSlot then
        if Network.IsLocalPlayerReady() then
            Network.SetLocalPlayerIsReady(false)
        else
            Network.SetLocalPlayerIsReady(true)
        end
    end
end
----------------------------------------------------------------------------------------------------------------------
function g_AspectGameConfig.InitTeamList(_SlotID)

    local TeamListBoxID = XGUIEng.GetWidgetID("/InGame/Multiplayer/MPGameSettings/ClientServerSettings/PlayerSlots/Slot".. _SlotID .."/TeamComboBoxContainer/ListBoxWidget")

    XGUIEng.ListBoxPopAll(TeamListBoxID, true)

    for i=1,g_AspectGameConfig.MaxPlayers do
        XGUIEng.ListBoxPushItem(TeamListBoxID,  XGUIEng.GetStringTableText("UI_Texts/MainMenuMultiTeam") .. " " .. i)
    end

    local TeamIndex = Network.GetTeamIdForNetworkSlotID(_SlotID)-1
    XGUIEng.ListBoxSetSelectedIndex(TeamListBoxID, TeamIndex)

    local TeamComboBoxID = XGUIEng.GetWidgetID("/InGame/Multiplayer/MPGameSettings/ClientServerSettings/PlayerSlots/Slot".. _SlotID .."/TeamComboBoxContainer/ListBoxWidget")
end
----------------------------------------------------------------------------------------------------------------------
function g_AspectGameConfig.OnTeamListBoxSelectionChange(_SlotID)

    Sound.FXPlay2DSound( "ui\\menu_click")

    local TeamComboBoxID = XGUIEng.GetWidgetID("/InGame/Multiplayer/MPGameSettings/ClientServerSettings/PlayerSlots/Slot".. _SlotID .."/TeamComboBoxContainer/ListBoxWidget")
    Network.SetTeamIdForNetworkSlotID(_SlotID, XGUIEng.ListBoxGetSelectedIndex(TeamComboBoxID)+1)

end
----------------------------------------------------------------------------------------------------------------------
function g_AspectGameConfig.UpdateNetworkSlotTeamButton(_PlayerSlot)

    local TeamListBoxID = XGUIEng.GetWidgetID("/InGame/Multiplayer/MPGameSettings/ClientServerSettings/PlayerSlots/Slot" .. _PlayerSlot .. "/TeamComboBoxContainer/ListBoxWidget")
    local TeamComboBoxID  = XGUIEng.GetWidgetID("/InGame/Multiplayer/MPGameSettings/ClientServerSettings/PlayerSlots/Slot" .. _PlayerSlot .. "/TeamComboBox/ComboBoxWidget")

    XGUIEng.ShowWidget( TeamComboBoxID , 1)

    g_AspectGameConfig.SetGameOptionDisableState(_PlayerSlot, TeamComboBoxID, 1)


    TeamIndex = Network.GetTeamIdForNetworkSlotID(_PlayerSlot)-1
    XGUIEng.ListBoxSetSelectedIndex(TeamListBoxID, TeamIndex)


end
----------------------------------------------------------------------------------------------------------------------
function g_AspectGameConfig.OnClickChooseStart(_SlotID)
    if g_AspectGameConfig.CurrentStartPositionSelectionPlayerID == nil then
        g_AspectGameConfig.CurrentStartPositionSelectionPlayerID = Network.GetLocalPlayerNetworkSlotID()
    end

    if _SlotID == g_AspectGameConfig.CurrentStartPositionSelectionPlayerID then
        g_AspectGameConfig.CurrentStartPositionSelectionPlayerID = Network.GetLocalPlayerNetworkSlotID()
    else
        g_AspectGameConfig.CurrentStartPositionSelectionPlayerID = _SlotID
    end
end
----------------------------------------------------------------------------------------------------------------------
function g_AspectGameConfig.UpdateChooseStartButton(_SlotID)
    if g_AspectGameConfig.CurrentStartPositionSelectionPlayerID == nil then
        g_AspectGameConfig.CurrentStartPositionSelectionPlayerID = Network.GetLocalPlayerNetworkSlotID()
    end

    if _SlotID == g_AspectGameConfig.CurrentStartPositionSelectionPlayerID then
        XGUIEng.HighLightButton(XGUIEng.GetCurrentWidgetID(), 1)
    else
        XGUIEng.HighLightButton(XGUIEng.GetCurrentWidgetID(), 0)
    end

    g_AspectGameConfig.SetGameOptionDisableState(_SlotID)
end
----------------------------------------------------------------------------------------------------------------------
function g_AspectGameConfig.StartButtonPressed()
	if not Network.IsLeavingSession() then
		if not Network.IsCountdownRunning() then
			Network.HostStartMPMap()
		else
			Network.SetLocalPlayerIsReady(true) --any other way to stop the launch ?
		end
	end
end
----------------------------------------------------------------------------------------------------------------------
function g_AspectGameConfig.InviteButtonPressed()
	if not Network.IsLeavingSession() then
		if Network.IsCountdownRunning() then
			Network.SetLocalPlayerIsReady(true) --any other way to stop the launch ?
		end
		Network.ShowFriends()
	end
end