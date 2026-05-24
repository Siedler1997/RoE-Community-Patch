
----------------------------------------------------------------------------------------------------------------------
--[[
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
--]]
----------------------------------------------------------------------------------------------------------------------
function g_AspectGameConfig.GetTruePlayerColor(_NextColor)
    g_MainMenuChat.AddToChatLog("NextColor: " .. NextColor)
    return _NextColor
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

            --Setzt die Spielerfarbe auf den gewuenschten Wert
            if Network.GetCurrentCountdownValue() == 0 then
                for i = 1, 4 do
                    Network.SetPlayerColorIndexForNetworkSlotID(i, g_AspectGameConfig.ValidColors[Network.GetPlayerColorIndexForNetworkSlotID(i)])
                end
            end
        end

    end

end
----------------------------------------------------------------------------------------------------------------------
function g_AspectGameConfig.OnTeamListBoxSelectionChange(_SlotID)

    Sound.FXPlay2DSound( "ui\\menu_click")

    local TeamComboBoxID = XGUIEng.GetWidgetID("/InGame/Multiplayer/MPGameSettings/ClientServerSettings/PlayerSlots/Slot".. _SlotID .."/TeamComboBoxContainer/ListBoxWidget")
    Network.SetTeamIdForNetworkSlotID(_SlotID, XGUIEng.ListBoxGetSelectedIndex(TeamComboBoxID)+1)

end