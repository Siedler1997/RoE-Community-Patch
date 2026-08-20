
CustomGame.Widget.FilterList1 = "/InGame/Singleplayer/CustomGame/ContainerSelection/Filter1ComboBoxContainer/ListBox"
CustomGame.Widget.FilterList2 = "/InGame/Singleplayer/CustomGame/ContainerSelection/Filter2ComboBoxContainer/ListBox"

CustomGame.KnightTypes = {
    "U_KnightSaraya",
    "U_KnightTrading",
    "U_KnightChivalry",
    "U_KnightWisdom",
    "U_KnightHealing",
    "U_KnightPlunder",
    "U_KnightSong",
    "U_KnightSabatta",
    "U_KnightRedPrince",
    "U_KnightPraphat",
    "U_KnightKhana"
    }            
----------------------------------------------------------------------------------------------------
function CustomGame_AddMaps(_Maps, _MapType, _MapMode)
    table.sort(_Maps)
	for i = 1 , #_Maps do	
	
	    if (Framework.GetMultiplayerMapMode(_Maps[i], _MapType) == 0) then
	    
	        local NewMapEntry = {}
	        NewMapEntry.Name = _Maps[i]
	        NewMapEntry.MapType = _MapType
		
		    local map,description,size,mode = Framework.GetMapNameAndDescription(NewMapEntry.Name, NewMapEntry.MapType)

            if _MapMode == 0 or mode == "" then
		        table.insert(CustomGame.Maps, NewMapEntry)
            elseif _MapMode == 1 and mode == XGUIEng.GetStringTableText("UI_Texts/MapType_Scripted") then
		        table.insert(CustomGame.Maps, NewMapEntry)
            elseif _MapMode == 2 and mode == XGUIEng.GetStringTableText("UI_Texts/MapType_FreeSettle") then
		        table.insert(CustomGame.Maps, NewMapEntry)
            end
            
		    --table.insert(CustomGame.Maps, NewMapEntry)
		end
		
	end    
end
----------------------------------------------------------------------------------------------------
function OpenCustomGameDialog()
	XGUIEng.ShowAllSubWidgets(CustomGame.Widget.Dialog,1)
	XGUIEng.PushPage(CustomGame.Widget.Dialog,false)

    XGUIEng.ShowWidget("/InGame/Singleplayer/RightMenu",0)
    
    g_MapAndHeroPreview.ShowMapAndHeroWindows(1)
    XGUIEng.DisableButton("/InGame/Singleplayer/ContainerBottom/StartGame",0)
	XGUIEng.DisableButton("/InGame/Singleplayer/ContainerBottom/Cancel",0)
    DisplayLoadBottomButtons("/InGame/Singleplayer/ContainerBottom/StartGame",
                             "/InGame/Singleplayer/ContainerBottom/Cancel")        
	CustomGame.Maps = {}

    CustomGame_FillMapTable(0, 0)

    CustomGame_FillHeroComboBox()
    CustomGame_FillFilterComboBoxes()
end
----------------------------------------------------------------------------------------------------
function CustomGame_SelectMap(map)
    if map ~= nil then
        XGUIEng.ListBoxSetSelectedIndex(CustomGame.Widget.MapList,map)    
	
	    CustomGame.SelectedMap = CustomGame.Maps[map +1].Name
	    CustomGame.SelectedMapType = CustomGame.Maps[map +1].MapType
	
        CustomGame_FillHeroComboBox(true)
    
        g_MapAndHeroPreview.SelectMap(CustomGame.SelectedMap, CustomGame.SelectedMapType)
    else
	    CustomGame.SelectedMap = ""
	    CustomGame.SelectedMapType = ""

        g_MapAndHeroPreview.SelectMap()
    end
end
----------------------------------------------------------------------------------------------------
function CustomGame_FillMapTable(_mapSourceFilter, _mapTypeFilter)
    local startButton = XGUIEng.GetWidgetID("/InGame/Singleplayer/ContainerBottom/StartGame")
    XGUIEng.ListBoxPopAll(CustomGame.Widget.MapList)
    XGUIEng.ListBoxPopAll(CustomGame.Widget.ClimateZoneList)
    XGUIEng.ListBoxPopAll(CustomGame.Widget.SizeList)
    XGUIEng.ListBoxPopAll(CustomGame.Widget.ModeList)

    for i=1, #CustomGame.Maps do
        CustomGame.Maps[i] = nil
    end

    local Maps = CreateMapTable(0, nil)
    local CustomMaps = CreateMapTable(3, nil)
    
    if _mapSourceFilter == 0 or _mapSourceFilter == 1 then
        CustomGame_AddMaps(Maps, 0, _mapTypeFilter)
    end
    if _mapSourceFilter == 0 or _mapSourceFilter == 2 then
        CustomGame_AddMaps(CustomMaps, 3, _mapTypeFilter)
    end
    
    if #CustomGame.Maps > 0 then
        -- update listbox
        for i = 1 , #CustomGame.Maps do 
		
		    local MapEntry = CustomGame.Maps[i]
		
		    --mapname
		    XGUIEng.ListBoxPushItem(CustomGame.Widget.MapList,Tool_GetLocalizedMapName(MapEntry.Name, MapEntry.MapType))
		
		    --climate
		    local LocalizedClimateZone = XGUIEng.GetStringTableText("UI_ObjectNames/ClimateZone_" .. Framework.GetMapClimateZone(MapEntry.Name, MapEntry.MapType))
		    XGUIEng.ListBoxPushItem(CustomGame.Widget.ClimateZoneList, LocalizedClimateZone)
		
		    --size
		    local map,description,size,mode = Framework.GetMapNameAndDescription(MapEntry.Name, MapEntry.MapType)
		    XGUIEng.ListBoxPushItem(CustomGame.Widget.SizeList, Tool_GetLocalizedSizeString(size))
		
		    --mode
  		    XGUIEng.ListBoxPushItem(CustomGame.Widget.ModeList, mode ) --mode is allready translated in C++ code... see StSc
  		
	    end
    
        CustomGame_SelectMap(0)
        
        XGUIEng.DisableButton(startButton, 0)
    else
        CustomGame_SelectMap(nil)

        XGUIEng.DisableButton(startButton, 1)
    end
end
----------------------------------------------------------------------------------------------------
function CustomGame_FillFilterComboBoxes()
    local Filter1ComboBoxID = XGUIEng.GetWidgetID(CustomGame.Widget.FilterList1)
    
    XGUIEng.ListBoxPopAll(Filter1ComboBoxID)
    XGUIEng.ListBoxPushItem(Filter1ComboBoxID, XGUIEng.GetStringTableText("UI_Texts/MapSource_All"))
    XGUIEng.ListBoxPushItem(Filter1ComboBoxID, XGUIEng.GetStringTableText("UI_Texts/MapSource_Default"))
    XGUIEng.ListBoxPushItem(Filter1ComboBoxID, XGUIEng.GetStringTableText("UI_Texts/MapSource_Custom"))
    
    XGUIEng.ListBoxSetSelectedIndex(Filter1ComboBoxID, 0)


    local Filter2ComboBoxID = XGUIEng.GetWidgetID(CustomGame.Widget.FilterList2)
    
    XGUIEng.ListBoxPopAll(Filter2ComboBoxID)
    XGUIEng.ListBoxPushItem(Filter2ComboBoxID, XGUIEng.GetStringTableText("UI_Texts/MapType_All"))
    XGUIEng.ListBoxPushItem(Filter2ComboBoxID, XGUIEng.GetStringTableText("UI_Texts/MapType_Scripted"))
    XGUIEng.ListBoxPushItem(Filter2ComboBoxID, XGUIEng.GetStringTableText("UI_Texts/MapType_FreeSettle"))
    
    XGUIEng.ListBoxSetSelectedIndex(Filter2ComboBoxID, 0)


    --CustomGame_OnFilter1ListBoxSelectionChange()
end
----------------------------------------------------------------------------------------------------
function CustomGame_OnFilterListBoxSelectionChange()
	local Filter1ComboBoxID = XGUIEng.GetWidgetID(CustomGame.Widget.FilterList1)
	local Index1 = XGUIEng.ListBoxGetSelectedIndex(Filter1ComboBoxID)
	local Filter2ComboBoxID = XGUIEng.GetWidgetID(CustomGame.Widget.FilterList2)
	local Index2 = XGUIEng.ListBoxGetSelectedIndex(Filter2ComboBoxID)

    CustomGame_FillMapTable(Index1, Index2)
end