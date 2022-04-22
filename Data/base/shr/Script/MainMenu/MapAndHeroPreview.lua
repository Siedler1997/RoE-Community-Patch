----------------------------------------------------------------------------------------------------
-- MapAndHeroPreview
----------------------------------------------------------------------------------------------------

g_MapAndHeroPreview = {}

g_MapAndHeroPreview.Widget = {}
g_MapAndHeroPreview.Widget.Knight            = "/InGame/Hero/ContainerHero"
g_MapAndHeroPreview.Widget.KnightName        = "/InGame/Hero/ContainerHero/HeroName"
g_MapAndHeroPreview.Widget.KnightDescription = "/InGame/Hero/ContainerHero/HeroDescription"
g_MapAndHeroPreview.Widget.KnightSlider      = "/InGame/Hero/ContainerHero/SliderWidget"

g_MapAndHeroPreview.Widget.Map               = "/InGame/Map/ContainerMap"
g_MapAndHeroPreview.Widget.MapPreview        = "/InGame/Map/ContainerMap/MapPreview"
g_MapAndHeroPreview.Widget.MapDescription    = "/InGame/Map/ContainerMap/MapDescription"
g_MapAndHeroPreview.Widget.MapSlider         = "/InGame/Map/ContainerMap/SliderWidget"
g_MapAndHeroPreview.Widget.MapName           = "/InGame/Map/ContainerMap/MapName"
g_MapAndHeroPreview.Widget.PlayerPosition    = "/InGame/Map/ContainerMap/PlayerPositions"
g_MapAndHeroPreview.Widget.LadderMatch       = "/InGame/Map/ContainerMap/LadderMatch"


g_MapAndHeroPreview.KnightTypes =
                        {"U_KnightTrading",
                        "U_KnightHealing",
                        "U_KnightChivalry",
                        "U_KnightWisdom",
                        "U_KnightPlunder",
                        "U_KnightSong",
                        "U_KnightSabatta",
                        "U_KnightRedPrince"
                        }

g_MapPage = g_MenuPage:CreateNewMenupage("/InGame/Map")
g_HeroPage = g_MenuPage:CreateNewMenupage("/InGame/Hero")

g_MapAndHeroPreview.DoUpdate = true

----------------------------------------------------------------------------------------------------
function g_MapAndHeroPreview.ShowMapAndHeroWindows(_Show)

    XGUIEng.ShowWidget(g_MapAndHeroPreview.Widget.PlayerPosition,0)

    if _Show == 1 then
        local OldTopPage = XGUIEng.GetTopPage()
        XGUIEng.PopPage()

        g_MapPage:Show(false, false)
        g_HeroPage:Show(false, false)

        XGUIEng.PushPage(OldTopPage, false)
    else
        local OldTopPage = XGUIEng.GetTopPage()
        XGUIEng.PopPage()
        g_HeroPage:Back()
        g_MapPage:Back()
        XGUIEng.PushPage(OldTopPage, false)
    end

end
----------------------------------------------------------------------------------------------------
function g_MapAndHeroPreview.ShowMapWindow(_Show)

    XGUIEng.ShowWidget(g_MapAndHeroPreview.Widget.PlayerPosition,0)

    if _Show == 1 then

        local OldTopPage = XGUIEng.GetTopPage()
        XGUIEng.PopPage()
        g_MapPage:Show(false, false)
        XGUIEng.PushPage(OldTopPage, false)

    else
        local OldTopPage = XGUIEng.GetTopPage()
        XGUIEng.PopPage()
        g_MapPage:Back()
        XGUIEng.PushPage(OldTopPage, false)
    end

end
----------------------------------------------------------------------------------------------------
function g_MapAndHeroPreview.ShowHeroWindow(_Show)

    if _Show == 1 then

        local OldTopPage = XGUIEng.GetTopPage()
        XGUIEng.PopPage()
        g_HeroPage:Show(false, false)
        XGUIEng.PushPage(OldTopPage, false, true)

    else
        local OldTopPage = XGUIEng.GetTopPage()
        XGUIEng.PopPage()
        g_HeroPage:Back()
        XGUIEng.PushPage(OldTopPage, false, true)
    end
end
----------------------------------------------------------------------------------------------------
function g_MapPage:OnShow()
    XGUIEng.ShowWidget(g_MapAndHeroPreview.Widget.LadderMatch, 0)
end
----------------------------------------------------------------------------------------------------
function g_MapAndHeroPreview.SelectMap(_Map, _MapType)

	XGUIEng.SetText(g_MapAndHeroPreview.Widget.MapName, "{center}" .. Tool_GetLocalizedMapName(_Map, _MapType))

    if _Map ~= nil and _Map:len() > 0 then

        local TextureName

        if _MapType == 0 then       -- singleplayer
            TextureName = "maps\\singleplayer\\".._Map.."\\"..Framework.GetMapPreviewMapTextureName(_Map,0)..".png"
        elseif _MapType == 1 then   -- user
            TextureName = "maps\\user\\".._Map.."\\"..Framework.GetMapPreviewMapTextureName(_Map,0)..".png"
        elseif _MapType == 2 then   -- multiplayer
            TextureName = "maps\\multiplayer\\".._Map.."\\"..Framework.GetMapPreviewMapTextureName(_Map,0)..".png"
        elseif _MapType == 3 then   -- external maps
            TextureName = "maps\\externalmap\\".._Map.."\\"..Framework.GetMapPreviewMapTextureName(_Map,0)..".png"
        end

        if TextureName ~= nil and TextureName:len() > 0 then

            XGUIEng.ShowWidget(g_MapAndHeroPreview.Widget.MapPreview,1)

            XGUIEng.SetMaterialTexture(g_MapAndHeroPreview.Widget.MapPreview,1,TextureName)

		    local map,description,size = Framework.GetMapNameAndDescription(_Map,_MapType)

  			XGUIEng.SetText(g_MapAndHeroPreview.Widget.MapDescription, Tool_GetLocalizedMapDescription(_Map, _MapType))
  			XGUIEng.SliderSetValueAbs(g_MapAndHeroPreview.Widget.MapSlider, 0)

        else

            XGUIEng.ShowWidget(g_MapAndHeroPreview.Widget.MapPreview, 0)

        end

    else

        XGUIEng.ShowWidget(g_MapAndHeroPreview.Widget.MapPreview,0)

    end

end
----------------------------------------------------------------------------------------------------
function g_MapAndHeroPreview.SelectKnight(_Knight)

    local KnightName = XGUIEng.GetStringTableText("Names/" .. g_MapAndHeroPreview.KnightTypes[_Knight+1])
    local KnightDesc = XGUIEng.GetStringTableText("UI_ObjectDescription/".. g_MapAndHeroPreview.KnightTypes[_Knight+1])

    if KnightName == "" then
        KnightName = EntityTypeName
    end

    if KnightDesc == "" then
        KnightDesc = "description missing"
    end

    XGUIEng.SetText(g_MapAndHeroPreview.Widget.KnightName, "{center}" .. KnightName)
    XGUIEng.SetText(g_MapAndHeroPreview.Widget.KnightDescription, KnightDesc)
    XGUIEng.SliderSetValueAbs(g_MapAndHeroPreview.Widget.KnightSlider, 0)

end
----------------------------------------------------------------------------------------------------
function Tool_GetLocalizedMapDescription(_MapName, _MapType)

	local textkeyname = "Map_" .. _MapName

    -- check for text key
    local localizedDesc = XGUIEng.GetStringTableText(textkeyname .."/MapDescription")
    if localizedDesc ~= "" then
        return localizedDesc
    end

    -- check for text key
    if _MapType ~= nil then

        local MapName, Description, Size, Mode = Framework.GetMapNameAndDescription(_MapName, _MapType)
        if Description ~= "" then

            return Description

        end

    end

    if _MapType == 3 then -- external maps

        return " "

    end

   	return ("!MBT! Description: " .. textkeyname)

end
----------------------------------------------------------------------------------------------------
-- Player Slots (for Multiplayer only)
----------------------------------------------------------------------------------------------------
function g_MapAndHeroPreview.InitPlayerSlots(_MapName, _MapType)

    XGUIEng.ShowWidget(g_MapAndHeroPreview.Widget.PlayerPosition,1)

    if _MapType == -1 then
        return
    end

    local MaxPlayers = Framework.GetMapMaxPlayers(_MapName, _MapType)

    for i = 1, 4 do
        if i <= MaxPlayers then

            XGUIEng.ShowWidget(g_MapAndHeroPreview.Widget.PlayerPosition .. "/Pos" .. i, 1)
            XGUIEng.SetText(g_MapAndHeroPreview.Widget.PlayerPosition .. "/Pos" .. i, " ")
            XGUIEng.DisableButton( g_MapAndHeroPreview.Widget.PlayerPosition .. "/Pos" .. i, 1)
            local RelativeWidth, RelativeHeight = Framework.GetMinimapStartingPosition(_MapName, _MapType, nil, i)
            local PositionWidgetWidth, PositionWidgetHeight = XGUIEng.GetWidgetSize(g_MapAndHeroPreview.Widget.PlayerPosition .. "/Pos" .. i)
            local MinimapWidgetWidth, MinimapWidgetHeight = XGUIEng.GetWidgetSize(g_MapAndHeroPreview.Widget.PlayerPosition)

            XGUIEng.SetWidgetLocalPosition(g_MapAndHeroPreview.Widget.PlayerPosition .. "/Pos" .. i,
                 (MinimapWidgetWidth * RelativeWidth) - (PositionWidgetWidth / 2),
                 (MinimapWidgetHeight * RelativeHeight) - (PositionWidgetHeight / 2))

        else
            XGUIEng.ShowWidget(g_MapAndHeroPreview.Widget.PlayerPosition .. "/Pos" .. i, 0)
        end

    end

end
----------------------------------------------------------------------------------------------------------------------
function g_MapAndHeroPreview.MapPosUpdate(_Position)

    if not g_MapAndHeroPreview.DoUpdate then
        return
    end

    local FoundSlotID = 0;
    local MapName, MapType, MapExtraNo = Network.GetCurrentMap()

    if (MapType == -1) or (MapExtraNo ~= Framework.GetGameExtraNo()) then
        return
    end

    local MaxPlayers = Framework.GetMapMaxPlayers(MapName, MapType)

    for i = 1, MaxPlayers do
        if _Position == Network.GetGamePlayerIDForNetworkSlotID(i) then
            local ColorTag = g_MainMenuChat.GetPlayerColorByID(i)
            XGUIEng.SetText(XGUIEng.GetCurrentWidgetID(), "{center}" .. ColorTag .. i .. ".")
            FoundSlotID = i
            break
        end
    end

    if FoundSlotID == 0 then
        XGUIEng.SetText(XGUIEng.GetCurrentWidgetID(), "")
        local NextSlotIDToPlace = g_MapAndHeroPreview.GetNextSlotIDToPlace()
        if NextSlotIDToPlace == 0 then
            XGUIEng.DisableButton( XGUIEng.GetCurrentWidgetID(), 1)
        else
            XGUIEng.DisableButton( XGUIEng.GetCurrentWidgetID(), 0)
        end
    else
        local CurrentSlotConfig = Network.GetSlotConfigForNetworkSlotID(FoundSlotID)

        if CurrentSlotConfig == g_AspectGameConfig.SlotModeCPU then
            if Network.GetLocalPlayerNetworkSlotID() == 1 then
                XGUIEng.DisableButton( XGUIEng.GetCurrentWidgetID(), 0)
            else
                XGUIEng.DisableButton( XGUIEng.GetCurrentWidgetID(), 1)
            end
        else
            if Network.GetLocalPlayerNetworkSlotID() == FoundSlotID then
                XGUIEng.DisableButton( XGUIEng.GetCurrentWidgetID(), 0)
            else
                XGUIEng.DisableButton( XGUIEng.GetCurrentWidgetID(), 1)
            end
        end
    end
end
----------------------------------------------------------------------------------------------------------------------
function g_MapAndHeroPreview.GetNextSlotIDToPlace()

    local FoundSlotID = 0;
    local MapName, MapType, MapExtraNo = Network.GetCurrentMap()
    
    if (MapType == -1) or (MapExtraNo ~= Framework.GetGameExtraNo()) then
        return
    end
    
    local MaxPlayers = Framework.GetMapMaxPlayers(MapName, MapType)

    for i = 1, MaxPlayers do
        local CurrentSlotConfig = Network.GetSlotConfigForNetworkSlotID(i)
	    if CurrentSlotConfig == g_AspectGameConfig.SlotModeCPU
	        or (CurrentSlotConfig == g_AspectGameConfig.SlotModeHuman and i == Network.GetLocalPlayerNetworkSlotID()) then

            if Network.GetGamePlayerIDForNetworkSlotID(i) <= 0 then
                FoundSlotID = i
                break
            end
        end
    end

    return FoundSlotID
end
----------------------------------------------------------------------------------------------------------------------
function g_MapAndHeroPreview.MapPosPressed(_Position)

    Sound.FXPlay2DSound("ui\\menu_click")

    local MapName, MapType, MapExtraNo = Network.GetCurrentMap()
    if (MapType == -1) or (MapExtraNo ~= Framework.GetGameExtraNo()) then
        return
    end
    local MaxPlayers = Framework.GetMapMaxPlayers(MapName, MapType)

    local FoundSlotID = 0;
    for i = 1, MaxPlayers do
        if _Position == Network.GetGamePlayerIDForNetworkSlotID(i) then
            FoundSlotID = i
            break
        end
    end

    if FoundSlotID > 0 then
        Network.SetGamePlayerIDForNetworkSlotID(FoundSlotID, 0)
    else
        Network.SetGamePlayerIDForNetworkSlotID(g_MapAndHeroPreview.GetNextSlotIDToPlace(), _Position)
    end

end

----------------------------------------------------------------------------------------------------
function Tool_GetLocalizedSizeString(_Size)

    local SizeX = tonumber(string.match(_Size, "(%d+)"))

    local SizeString

    if SizeX < 550 then
        SizeString = "Small"
    elseif SizeX < 650 then
        SizeString = "Medium"
    elseif SizeX < 750 then
        SizeString = "Large"
    else
        SizeString = "ExtraLarge"
    end

    return XGUIEng.GetStringTableText("UI_Texts/MapSize" .. SizeString)

end
----------------------------------------------------------------------------------------------------------------------
function g_MapAndHeroPreview.UpdateLadderMatch()
    local MatchType = Network.GetLadderMatchType()
    if MatchType == 0 then
        XGUIEng.ShowWidget(g_MapAndHeroPreview.Widget.LadderMatch, 0)
    else
        local Title
        XGUIEng.ShowWidget(g_MapAndHeroPreview.Widget.LadderMatch, 1)
        if MatchType == 1 then
            Title = XGUIEng.GetStringTableText("UI_Texts/MainMenuMultiLadderMatch_center")

            local u0 = 6*64
            local v0 = 2*64
            local u1 = 7*64-1
            local v1 = 3*64-1
    
            XGUIEng.SetMaterialTexture( "/InGame/Map/ContainerMap/LadderMatch/Icon1", 1, "IconsBig2.png")
            XGUIEng.SetMaterialUV( "/InGame/Map/ContainerMap/LadderMatch/Icon1", 1, u0, v0, u1, v1)
            XGUIEng.SetMaterialTexture( "/InGame/Map/ContainerMap/LadderMatch/Icon2", 1, "IconsBig2.png")
            XGUIEng.SetMaterialUV( "/InGame/Map/ContainerMap/LadderMatch/Icon2", 1, u0, v0, u1, v1)
        else
            Title = XGUIEng.GetStringTableText("UI_Texts/MainMenuMultiClanMatch_center")

            local u0 = 6*64
            local v0 = 1*64
            local u1 = 7*64-1
            local v1 = 2*64-1
    
            XGUIEng.SetMaterialTexture( "/InGame/Map/ContainerMap/LadderMatch/Icon1", 1, "IconsBig2.png")
            XGUIEng.SetMaterialUV( "/InGame/Map/ContainerMap/LadderMatch/Icon1", 1, u0, v0, u1, v1)
            XGUIEng.SetMaterialTexture( "/InGame/Map/ContainerMap/LadderMatch/Icon2", 1, "IconsBig2.png")
            XGUIEng.SetMaterialUV( "/InGame/Map/ContainerMap/LadderMatch/Icon2", 1, u0, v0, u1, v1)
        end
        XGUIEng.SetText(g_MapAndHeroPreview.Widget.LadderMatch .. "/Title", Title)
    end
end
----------------------------------------------------------------------------------------------------------------------