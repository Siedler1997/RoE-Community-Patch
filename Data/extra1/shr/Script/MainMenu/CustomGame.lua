----------------------------------------------------------------------------------------------------
-- CustomGameDialog
----------------------------------------------------------------------------------------------------
CustomGame = {}
CustomGame.Maps = {}
CustomGame.SelectedMap = ""
CustomGame.SelectedMapType = ""
CustomGame.Knight = 1
CustomGame.Widget = {}
CustomGame.Widget.Dialog = "/InGame/Singleplayer/CustomGame"
--CustomGame.Widget.Close = "/InGame/CustomGame/Close"
CustomGame.Widget.Start = "/InGame/Singleplayer/ContainerBottom/StartGame"
CustomGame.Widget.KnightsList = "/InGame/Singleplayer/CustomGame/ContainerSelection/HeroComboBoxContainer/ListBox"
CustomGame.Widget.MapList = "/InGame/Singleplayer/CustomGame/ContainerSelection/MapListBox"
CustomGame.Widget.ClimateZoneList = "/InGame/Singleplayer/CustomGame/ContainerSelection/ClimateZoneListBox"
CustomGame.Widget.SizeList = "/InGame/Singleplayer/CustomGame/ContainerSelection/SizeListBox"
CustomGame.Widget.ModeList = "/InGame/Singleplayer/CustomGame/ContainerSelection/ModeListBox"
CustomGame.Widget.FilterList1 = "/InGame/Singleplayer/CustomGame/ContainerSelection/Filter1ComboBoxContainer/ListBox"
CustomGame.Widget.FilterList2 = "/InGame/Singleplayer/CustomGame/ContainerSelection/Filter2ComboBoxContainer/ListBox"

CustomGame.StartMap = ""
CustomGame.StartMapType = ""
CustomGame.KnightTypes = {"U_KnightTrading",
                        "U_KnightHealing",
                        "U_KnightChivalry",
                        "U_KnightWisdom",
                        "U_KnightPlunder",
                        "U_KnightSong",
                        "U_KnightSabatta",
                        "U_KnightRedPrince"
                        }
                        
CustomGame.CurrentKnightList = CustomGame.KnightTypes
                        
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
function CloseCustomGameDialog()

	XGUIEng.ListBoxPopAll(CustomGame.Widget.MapList)

	XGUIEng.ShowWidget(CustomGame.Widget.Dialog,0)
    g_MapAndHeroPreview.ShowMapAndHeroWindows(0)
	
	XGUIEng.PopPage() -- [StSc] PopPage gets no parameters, it pops the topmost widget -- CustomGame.Widget.Dialog

end
----------------------------------------------------------------------------------------------------
function CustomGameDialog_CloseOnLeftClick()

	CloseCustomGameDialog()
	
	XGUIEng.ShowAllSubWidgets("/InGame/Singleplayer",0)
    XGUIEng.ShowWidget("/InGame/Singleplayer/ContainerBottom",1)
    XGUIEng.ShowWidget("/InGame/Singleplayer/RightMenu",1)
    
    DisplayLoadBottomButtons("/InGame/Singleplayer/ContainerBottom/BackMenu")

end 
----------------------------------------------------------------------------------------------------
function CustomGame_MapListOnSelectionChange()
	
	CustomGame_SelectMap(XGUIEng.ListBoxGetSelectedIndex(CustomGame.Widget.MapList))

end
----------------------------------------------------------------------------------------------------

function CustomGame_FillHeroComboBox(_TryToKeepSelectedKnight)
    
    local HeroComboBoxID = XGUIEng.GetWidgetID(CustomGame.Widget.KnightsList)
    
    local OldKnightName
    if _TryToKeepSelectedKnight then
        local Index = XGUIEng.ListBoxGetSelectedIndex(HeroComboBoxID)
        OldKnightName = CustomGame.CurrentKnightList[Index + 1]
    end
    
    XGUIEng.ListBoxPopAll(HeroComboBoxID)
    
    local KnightSelection = CustomGame.KnightTypes
    if CustomGame.SelectedMap and CustomGame.SelectedMapType then
        local KnightNames = {Framework.GetValidKnightNames(CustomGame.SelectedMap, CustomGame.SelectedMapType)}
        if #KnightNames > 0 then
            KnightSelection = KnightNames
        end
    end
    
    CustomGame.CurrentKnightList = KnightSelection
    
    for i=1,#KnightSelection do
        XGUIEng.ListBoxPushItem(HeroComboBoxID, XGUIEng.GetStringTableText("Names/" .. KnightSelection[i]) )
    end
    
    local SelectIndex = 0
    if _TryToKeepSelectedKnight then
        for TempIndex, Name in ipairs(KnightSelection) do
            if Name == OldKnightName then
                SelectIndex = TempIndex - 1
                break
            end
        end
    end
    
    XGUIEng.ListBoxSetSelectedIndex(HeroComboBoxID, SelectIndex)
    CustomGame_OnHeroListBoxSelectionChange()
end
----------------------------------------------------------------------------------------------------
function CustomGame_OnHeroListBoxSelectionChange()

	local HeroComboBoxID = XGUIEng.GetWidgetID(CustomGame.Widget.KnightsList)
	local Index = XGUIEng.ListBoxGetSelectedIndex(HeroComboBoxID)
    if CustomGame.CurrentKnightList == CustomGame.KnightTypes then
        CustomGame_SelectKnight(Index)
    else
        -- Need to translate the index from the partial selection list to the default full selection list
        local NewIndex = Index
        for TempIndex, Name in ipairs(CustomGame.KnightTypes) do
            if Name == CustomGame.CurrentKnightList[Index + 1] then
                NewIndex = TempIndex - 1
                break
            end
        end
        CustomGame_SelectKnight(NewIndex)
    end
    
end
----------------------------------------------------------------------------------------------------
function CustomGame_StartOnLeftClick()

    if Framework.BeforeStartMap() == false then
        OpenRequesterDialog(XGUIEng.GetStringTableText("UI_Texts/NoValidCDFound"), "", "CustomGame_StartOnLeftClick()", 1)
        return
    end

    Input.NoneMode()

	local knight = CustomGame.Knight 

	Framework.OpenSkirmishMode(1)

	DisplayOptions.SkirmishSetKnight(1,knight)

	InitializeFader()
	
	CustomGame.StartMap = CustomGame.SelectedMap             -- sniff, one uncontrolled command, and a new map is selected, so backup the startmap.
	CustomGame.StartMapType = CustomGame.SelectedMapType
	
	XGUIEng.DisableButton("/InGame/Singleplayer/ContainerBottom/StartGame",1)
	XGUIEng.DisableButton("/InGame/Singleplayer/ContainerBottom/Cancel",1)
	FadeOut(1,CustomGame_StartMapCallback)	

end
----------------------------------------------------------------------------------------------------
function CustomGame_StartMapCallback()

	CloseCustomGameDialog()
	XGUIEng.ShowAllSubWidgets("/InGame",0)

	Framework.ResetProgressBar()
    InitLoadScreen(false, CustomGame.StartMapType, CustomGame.StartMap, 0, DisplayOptions.SkirmishGetKnight(1) + 1)

	InitializeFader()
	FadeIn(1,CustomGame_StartMapCallback2)

end
----------------------------------------------------------------------------------------------------
function CustomGame_StartMapCallback2()	

	Framework.StartMap(CustomGame.StartMap,CustomGame.StartMapType,"")	

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
function CustomGame_SelectKnight(knight)

    CustomGame.Knight = knight 
    
    g_MapAndHeroPreview.SelectKnight(CustomGame.Knight)

end
----------------------------------------------------------------------------------------------------
function CustomGame_Update()

	UpdateFader()

end
----------------------------------------------------------------------------------------------------
function Tool_GetLocalizedMapName(_MapName, _MapType)
    
	local textkeyname = "Map_" .. _MapName
    
    local localizedMap = XGUIEng.GetStringTableText(textkeyname .."/MapName")
    
    if localizedMap ~= "" then
        return localizedMap
    end
    
    if (_MapType ~= nil) then
        
        local MapName, Description, Size, Mode = Framework.GetMapNameAndDescription(_MapName, _MapType)    
        if (MapName ~= "") then
        
            return MapName
        
        end        
     
    end
        
    return _MapName
  	   	
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
function CustomGame_OnFilterListBoxSelectionChange()
	local Filter1ComboBoxID = XGUIEng.GetWidgetID(CustomGame.Widget.FilterList1)
	local Index1 = XGUIEng.ListBoxGetSelectedIndex(Filter1ComboBoxID)
	local Filter2ComboBoxID = XGUIEng.GetWidgetID(CustomGame.Widget.FilterList2)
	local Index2 = XGUIEng.ListBoxGetSelectedIndex(Filter2ComboBoxID)

    CustomGame_FillMapTable(Index1, Index2)
end