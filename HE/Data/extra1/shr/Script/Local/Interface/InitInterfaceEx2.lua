
-----------------------------------------------------------------------------------------
-- Overwrites for InitInterface
-----------------------------------------------------------------------------------------

function InitOverwriteInitInterfaceEx2()

    function SetIcon(_Widget, _Coordinates, _OptionalIconSize )

        if _Coordinates == nil then

            if Debug_EnableDebugOutput then
                GUI.AddNote("Bug: no valid Icon available. Caused by invalid EntityType or GoodType, or a missing entry in TexturePositions.lua")

                if type(_Widget) == "string" then
                    _Widget = XGUIEng.GetWidgetID(_Widget)
                end

                local WidgetPath = XGUIEng.GetWidgetPathByID(_Widget)
                GUI.AddNote("Widget: " .. WidgetPath)
            end

            _Coordinates = {16, 16}
            --return
        end

        local IsButton = XGUIEng.IsButton(_Widget)
        local WidgetState

        if IsButton == 1 then
            WidgetState = 7
        else
            WidgetState = 1
        end

        local IconSize
    
        local UVOverride = false
        local u0, v0, u1, v1
    
        if _Coordinates[1] == 16 and _Coordinates[2]==16 then
            XGUIEng.SetMaterialAlpha(_Widget, WidgetState, 0)
        else
            XGUIEng.SetMaterialAlpha(_Widget, WidgetState, 255)
        
            if _Coordinates[3] == nil or _Coordinates[3] == 0 then
		        if _OptionalIconSize == nil or _OptionalIconSize == 64 then
		            IconSize = 64
		            XGUIEng.SetMaterialTexture(_Widget, WidgetState, "IconsBig.png")
		        elseif _OptionalIconSize == 44 then
		            IconSize = 44
		            XGUIEng.SetMaterialTexture(_Widget, WidgetState, "Icons.png")
		        elseif _OptionalIconSize == 128 then
		            IconSize = 128
		            
                    -- For salt & dye we need a bit of a hack...
                    if  _Coordinates[1] == 5 and _Coordinates[2] == 10 then -- salt
                        XGUIEng.SetMaterialTexture(_Widget, WidgetState, "IconsBig2.png")
                        UVOverride = true
                        u0 = 128
                        v0 = 256 
                        u1 = u0 + IconSize
                        v1 = v0 + IconSize
                    elseif _Coordinates[1] == 5 and _Coordinates[2] == 11 then -- dye
                        XGUIEng.SetMaterialTexture(_Widget, WidgetState, "IconsBig2.png")
                        UVOverride = true
                        u0 = 256
                        v0 = 256 
                        u1 = u0 + IconSize
                        v1 = v0 + IconSize                                                 
                    else 
                        XGUIEng.SetMaterialTexture(_Widget, WidgetState, "IconsVeryBig.png")
                    end
		        end
		    elseif _Coordinates[3] == 1 then
		        if _OptionalIconSize == nil or _OptionalIconSize == 64 then
		            IconSize = 64
		            XGUIEng.SetMaterialTexture(_Widget, WidgetState, "IconsBig2.png")
		        elseif _OptionalIconSize == 44 then
		            IconSize = 44
		            XGUIEng.SetMaterialTexture(_Widget, WidgetState, "Icons2.png")
		        elseif _OptionalIconSize == 128 then
                    IconSize = 128
                    
                    -- For muscical instruments, gems & olibanum we need a bit of a hack...
                    if  _Coordinates[1] == 1 and _Coordinates[2] == 1 then -- gems
                        XGUIEng.SetMaterialTexture(_Widget, WidgetState, "IconsBig2.png")
                        UVOverride = true
                        u0 = 128
                        v0 = 384 
                        u1 = u0 + IconSize
                        v1 = v0 + IconSize
                    elseif  _Coordinates[1] == 1 and _Coordinates[2] == 2 then -- olibanum
                        XGUIEng.SetMaterialTexture(_Widget, WidgetState, "IconsBig2.png")
                        UVOverride = true
                        u0 = 256
                        v0 = 384 
                        u1 = u0 + IconSize
                        v1 = v0 + IconSize
                    elseif  _Coordinates[1] == 1 and _Coordinates[2] == 3 then -- musicalinst
                        XGUIEng.SetMaterialTexture(_Widget, WidgetState, "IconsBig2.png")
                        UVOverride = true
                        u0 = 384
                        v0 = 384 
                        u1 = u0 + IconSize
                        v1 = v0 + IconSize
                    else 
                        XGUIEng.SetMaterialTexture(_Widget, WidgetState, "IconsVeryBig.png")
                    end
		        end
            else
		        if _OptionalIconSize == nil or _OptionalIconSize == 64 then
		            IconSize = 64
		            XGUIEng.SetMaterialTexture(_Widget, WidgetState, "IconsBig3.png")
		        elseif _OptionalIconSize == 44 then
		            IconSize = 44
		            XGUIEng.SetMaterialTexture(_Widget, WidgetState, "Icons3.png")
		        elseif _OptionalIconSize == 128 then
                    IconSize = 128
                    XGUIEng.SetMaterialTexture(_Widget, WidgetState, "IconsVeryBig2.png")
                end
		    end
            
            
            if not UVOverride then
            
                u0 = (_Coordinates[1] - 1) * IconSize
                v0 = (_Coordinates[2] - 1) * IconSize
                u1 = _Coordinates[1] * IconSize
                v1 = _Coordinates[2] * IconSize

            end
        
            XGUIEng.SetMaterialUV(_Widget, WidgetState, u0, v0, u1, v1)
        end

    end

end