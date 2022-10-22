g_CreateGamePage = {}

g_CreateGamePage.Maps = {}

g_CreateGamePage.Widget = {}
g_CreateGamePage.Widget.MapList = "/InGame/Multiplayer/CreateGame/Container/ListBox/ListboxMain/ListBox"
g_CreateGamePage.Widget.ClimateZoneList = "/InGame/Multiplayer/CreateGame/Container/ListBox/ListboxMain/ClimateZoneListBox"
g_CreateGamePage.Widget.SizeList = "/InGame/Multiplayer/CreateGame/Container/ListBox/ListboxMain/SizeListBox"
g_CreateGamePage.Widget.MaxPlayersList = "/InGame/Multiplayer/CreateGame/Container/ListBox/ListboxMain/MaxPlayersListBox"
g_CreateGamePage.Widget.FilterList1 = "/InGame/Multiplayer/CreateGame/Container/Filter1ComboBoxContainer/ListBox"
g_CreateGamePage.Widget.FilterList2 = "/InGame/Multiplayer/CreateGame/Container/Filter2ComboBoxContainer/ListBox"


----------------------------------------------------------------------------------------------------
function g_CreateGamePage.AddMaps(_Maps, _MapType, _maxPlayerFilter)

    table.sort(_Maps)
	for i = 1 , #_Maps do

	    if (Framework.GetMultiplayerMapMode(_Maps[i], _MapType) > 0) then

	        local NewMapEntry = {}
	        NewMapEntry.Name = _Maps[i]
	        NewMapEntry.MapType = _MapType

            local maxPlayers = Framework.GetMapMaxPlayers(NewMapEntry.Name, NewMapEntry.MapType)
            if _maxPlayerFilter == 0 or _maxPlayerFilter == maxPlayers then
		        table.insert(g_CreateGamePage.Maps, NewMapEntry)
            end

		end

	end

end

----------------------------------------------------------------------------------------------------
function g_CreateGamePage.Show()

    XGUIEng.ShowAllSubWidgets("/InGame/Multiplayer",0)
    XGUIEng.ShowWidget("/InGame/Multiplayer/ContainerBottom",1)
    g_MainMenuMultiplayer:DisplayBottomButtons("/InGame/Multiplayer/ContainerBottom/Continue",
                                               "/InGame/Multiplayer/ContainerBottom/CancelCreate")

    XGUIEng.ShowWidget("/InGame/Multiplayer/CreateGame",1)

	if Network.IsQuickmatch() then
		XGUIEng.ShowWidget("/InGame/Multiplayer/CreateGame/Container/PrivateSession",0)
		XGUIEng.ShowWidget("/InGame/Multiplayer/CreateGame/Container/PrivateSessionCheckBox",0)
	else
		XGUIEng.ShowWidget("/InGame/Multiplayer/CreateGame/Container/PrivateSession",1)
		XGUIEng.ShowWidget("/InGame/Multiplayer/CreateGame/Container/PrivateSessionCheckBox",1)
	end

	local PrivateSessionCheckboxWidget = XGUIEng.GetWidgetID("/InGame/Multiplayer/CreateGame/Container/PrivateSessionCheckBox")
	local isPrivate = Network.GetPrivateSession()
	XGUIEng.CheckBoxSetIsChecked(PrivateSessionCheckboxWidget,isPrivate)

    g_MapAndHeroPreview.ShowMapWindow(1)

    g_CreateGamePage.Maps = {}

    g_CreateGamePage.FillFilterComboBoxes()
    g_CreateGamePage.FillMapTable(0, 0)

end
function InitNetworkGameConfig(_MapName, _MapType)

    local KnightNames = {GetMPValidKnightNames(_MapName, _MapType)}
    local PlayerColors = {GetMPValidPlayerColors(_MapName, _MapType)}
    local VictoryConditions = {GetMPValidVictoryConditions(_MapName, _MapType)}
    local ResourceModificators = {GetMPValidResourceModificators(_MapName, _MapType)}

    Network.SetNrOfKnights(table.maxn(KnightNames))
    Network.SetNrOfPlayerColors(table.maxn(PlayerColors))
    Network.SetNrOfVictoryConditions(table.maxn(VictoryConditions))
    Network.SetNrOfResourceModificators(table.maxn(ResourceModificators))

end

function g_CreateGamePage.CreateGame()

	XGUIEng.SetAllButtonsDisabled()

    g_MapAndHeroPreview.DoUpdate = false

    InitNetworkGameConfig(g_CreateGamePage.CurrentMap, g_CreateGamePage.CurrentMapType)
    local MaxPlayers = Framework.GetMapMaxPlayers(g_CreateGamePage.CurrentMap, g_CreateGamePage.CurrentMapType)
    local MapGUID = Framework.GetMapGUID(g_CreateGamePage.CurrentMap, g_CreateGamePage.CurrentMapType)

    Network.CreateGame(g_CreateGamePage.CurrentMap, g_CreateGamePage.CurrentMapType, MapGUID, MaxPlayers)

	XGUIEng.SetAllButtonsEnabledRequest()

end

function g_CreateGamePage.CreateGameUpdate()
    if Network.MatchmakingServiceIsInSession() == false and #g_CreateGamePage.Maps > 0 then
        XGUIEng.DisableButton("/InGame/Multiplayer/ContainerBottom/Continue", 0)
    else
        XGUIEng.DisableButton("/InGame/Multiplayer/ContainerBottom/Continue", 1)
    end
end

function CreateMapTable(_MapType, _Campaign)
    local Result = {}

    local CurrentIndex = 0
    local MapsPerIteration = 50
    local NewMaps

    repeat
        NewMaps = {Framework.GetMapNames(CurrentIndex, MapsPerIteration, _MapType, _Campaign)}
        for i,v in ipairs(NewMaps) do
            table.insert(Result, v)
        end
        CurrentIndex = CurrentIndex + MapsPerIteration
    until table.getn(NewMaps) < MapsPerIteration

    return Result
end



function g_CreateGamePage.MapSelectionChanged(map)
    --local MapEntry = g_CreateGamePage.Maps[XGUIEng.ListBoxGetSelectedIndex(g_CreateGamePage.Widget.MapList) + 1]
    
    if map ~= nil then
        XGUIEng.ListBoxSetSelectedIndex(g_CreateGamePage.Widget.MapList, map)    
	
	    g_CreateGamePage.CurrentMap = g_CreateGamePage.Maps[map +1].Name
	    g_CreateGamePage.CurrentMapType = g_CreateGamePage.Maps[map +1].MapType

        g_MapAndHeroPreview.SelectMap(g_CreateGamePage.CurrentMap, g_CreateGamePage.CurrentMapType)
        g_MapAndHeroPreview.InitPlayerSlots(g_CreateGamePage.CurrentMap, g_CreateGamePage.CurrentMapType)
    else
	    g_CreateGamePage.CurrentMap = ""
	    g_CreateGamePage.CurrentMapType = ""

        g_MapAndHeroPreview.SelectMap()
    end

end

function g_CreateGamePage.HostGameFailed(_ErrorName)

    MessageText = XGUIEng.GetStringTableText("UI_Texts/" .. "MultiplayerError_HostGameFailed") .. " " .. _ErrorName
    g_ErrorPage.CreateError(MessageText)

end

function g_CreateGamePage.FillMapTable(_mapSourceFilter, _maxPlayerFilter)
    local startButton = XGUIEng.GetWidgetID("/InGame/Multiplayer/ContainerBottom/Continue")
    XGUIEng.ListBoxPopAll(g_CreateGamePage.Widget.MapList)
    XGUIEng.ListBoxPopAll(g_CreateGamePage.Widget.ClimateZoneList)
    XGUIEng.ListBoxPopAll(g_CreateGamePage.Widget.SizeList)
    XGUIEng.ListBoxPopAll(g_CreateGamePage.Widget.MaxPlayersList)
    
    for i=1, #g_CreateGamePage.Maps do
        g_CreateGamePage.Maps[i] = nil
    end

    local MPMaps = CreateMapTable(2, nil)
    local CustomMPMaps = CreateMapTable(3, nil)

    local playerCount = 0
    if _maxPlayerFilter > 0 then
        playerCount = _maxPlayerFilter + 1
    end
    
    if _mapSourceFilter == 0 or _mapSourceFilter == 1 then
        g_CreateGamePage.AddMaps(MPMaps, 2, playerCount)
    end
    if _mapSourceFilter == 0 or _mapSourceFilter == 2 then
        g_CreateGamePage.AddMaps(CustomMPMaps, 3, playerCount)
    end
    
    if #g_CreateGamePage.Maps > 0 then
        for i, v in ipairs(g_CreateGamePage.Maps) do

            local MapEntry = g_CreateGamePage.Maps[i]

            local t1 = MapEntry.Name
            local t2 = MapEntry.MapType

            -- map name
            XGUIEng.ListBoxPushItem(g_CreateGamePage.Widget.MapList,Tool_GetLocalizedMapName(MapEntry.Name, MapEntry.MapType))

		    -- climate
		    local LocalizedClimateZone = XGUIEng.GetStringTableText("UI_ObjectNames/ClimateZone_" .. Framework.GetMapClimateZone(MapEntry.Name, MapEntry.MapType))
		    XGUIEng.ListBoxPushItem(g_CreateGamePage.Widget.ClimateZoneList, LocalizedClimateZone)

            -- size
            local map,description,size = Framework.GetMapNameAndDescription(MapEntry.Name, MapEntry.MapType)
            XGUIEng.ListBoxPushItem(g_CreateGamePage.Widget.SizeList, "{center}" .. Tool_GetLocalizedSizeString(size))

            -- maxplayers
            XGUIEng.ListBoxPushItem(g_CreateGamePage.Widget.MaxPlayersList,"{center}" .. Framework.GetMapMaxPlayers(MapEntry.Name, MapEntry.MapType) )

        end

        --XGUIEng.ListBoxSetSelectedIndex(g_CreateGamePage.Widget.MapList, 0)

        --g_CreateGamePage.MapSelectionChanged()
        
        g_CreateGamePage.MapSelectionChanged(0)
        XGUIEng.DisableButton(startButton, 0)
    else
        g_CreateGamePage.MapSelectionChanged(nil)
        XGUIEng.DisableButton(startButton, 1)
    end
end

function g_CreateGamePage.MapListOnSelectionChange()
	
	g_CreateGamePage.MapSelectionChanged(XGUIEng.ListBoxGetSelectedIndex(g_CreateGamePage.Widget.MapList))

end

function g_CreateGamePage.FillFilterComboBoxes()
    local Filter1ComboBoxID = XGUIEng.GetWidgetID(g_CreateGamePage.Widget.FilterList1)
    
    XGUIEng.ListBoxPopAll(Filter1ComboBoxID)
    XGUIEng.ListBoxPushItem(Filter1ComboBoxID, XGUIEng.GetStringTableText("UI_Texts/MapSource_All"))
    XGUIEng.ListBoxPushItem(Filter1ComboBoxID, XGUIEng.GetStringTableText("UI_Texts/MapSource_Default"))
    XGUIEng.ListBoxPushItem(Filter1ComboBoxID, XGUIEng.GetStringTableText("UI_Texts/MapSource_Custom"))
    
    XGUIEng.ListBoxSetSelectedIndex(Filter1ComboBoxID, 0)


    local Filter2ComboBoxID = XGUIEng.GetWidgetID(g_CreateGamePage.Widget.FilterList2)
    
    XGUIEng.ListBoxPopAll(Filter2ComboBoxID)
    XGUIEng.ListBoxPushItem(Filter2ComboBoxID, XGUIEng.GetStringTableText("UI_Texts/Multiplayer_MaxPlayerCount_All"))
    XGUIEng.ListBoxPushItem(Filter2ComboBoxID, XGUIEng.GetStringTableText("UI_Texts/Multiplayer_MaxPlayerCount_Two"))
    XGUIEng.ListBoxPushItem(Filter2ComboBoxID, XGUIEng.GetStringTableText("UI_Texts/Multiplayer_MaxPlayerCount_Three"))
    XGUIEng.ListBoxPushItem(Filter2ComboBoxID, XGUIEng.GetStringTableText("UI_Texts/Multiplayer_MaxPlayerCount_Four"))
    
    XGUIEng.ListBoxSetSelectedIndex(Filter2ComboBoxID, 0)


    --CustomGame_OnFilter1ListBoxSelectionChange()
end

function g_CreateGamePage.OnFilterListBoxSelectionChange()
	local Filter1ComboBoxID = XGUIEng.GetWidgetID(g_CreateGamePage.Widget.FilterList1)
	local Index1 = XGUIEng.ListBoxGetSelectedIndex(Filter1ComboBoxID)
	local Filter2ComboBoxID = XGUIEng.GetWidgetID(g_CreateGamePage.Widget.FilterList2)
	local Index2 = XGUIEng.ListBoxGetSelectedIndex(Filter2ComboBoxID)

    g_CreateGamePage.FillMapTable(Index1, Index2)
end