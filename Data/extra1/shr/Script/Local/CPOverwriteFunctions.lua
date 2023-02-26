function InitLocalOverwriteCP()

end



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
    end
    _Coordinates[3] = _Coordinates[3] or 0;


    local IsButton = XGUIEng.IsButton(_Widget)
    local WidgetState
    if IsButton == 1 then
        WidgetState = 7
    else
        WidgetState = 1
    end
    local UVOverride = false
    local u0, v0, u1, v1
    if _Coordinates[1] == 16 and _Coordinates[2] == 16 then
        XGUIEng.SetMaterialAlpha(_Widget, WidgetState, 0)
    else
        XGUIEng.SetMaterialAlpha(_Widget, WidgetState, 255)

        -- Set icon Size
        local IconSize = 64;
        if _OptionalIconSize == 44 then
            IconSize = 44;
        end
        if _OptionalIconSize == 128 then
            IconSize = 128;
        end

        local MatrixSuffix = "";
        if _Coordinates[3] > 0 then
            MatrixSuffix = MatrixSuffix .. (_Coordinates[3]+1);
        end

        XGUIEng.SetMaterialTexture(_Widget, WidgetState, "IconsBig" ..MatrixSuffix.. ".png")
        if IconSize == 44 then
            XGUIEng.SetMaterialTexture(_Widget, WidgetState, "Icons" ..MatrixSuffix.. ".png")
        end
        if IconSize == 128 then
            XGUIEng.SetMaterialTexture(_Widget, WidgetState, "IconsVeryBig" ..MatrixSuffix.. ".png")
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

