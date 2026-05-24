
g_MapAndHeroPreview.KnightTypes = CustomGame.KnightTypes

----------------------------------------------------------------------------------------------------
function g_MapAndHeroPreview.SelectMap(_Map, _MapType)

    if _Map ~= nil and _Map:len() > 0 then
	    XGUIEng.SetText(g_MapAndHeroPreview.Widget.MapName, "{center}" .. Tool_GetLocalizedMapName(_Map, _MapType))

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

        if _MapType == 2 then
            XGUIEng.ShowWidget(g_MapAndHeroPreview.Widget.PlayerPosition,1)
        else
            XGUIEng.ShowWidget(g_MapAndHeroPreview.Widget.PlayerPosition,0)
        end

    else
        XGUIEng.ShowWidget(g_MapAndHeroPreview.Widget.PlayerPosition,0)
        XGUIEng.SetMaterialTexture(g_MapAndHeroPreview.Widget.MapPreview,1,"BlackScreen.png")
        XGUIEng.ShowWidget(g_MapAndHeroPreview.Widget.MapPreview,1)
        
	    XGUIEng.SetText(g_MapAndHeroPreview.Widget.MapName, "{center}-")
  		XGUIEng.SetText(g_MapAndHeroPreview.Widget.MapDescription, XGUIEng.GetStringTableText("UI_Texts/MainMenu_NoMapSelected"))
    end

end