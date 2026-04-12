-----------------------------------------------------------------------------------------------------
-- CoatOfArm.lua
-----------------------------------------------------------------------------------------------------

g_CoatOfArm.CurrentColorSchemeIndex = 0
g_CoatOfArm.NumberOfPatterns = 16
g_CoatOfArm.Coords.Big = { 0,0,128,176 }
g_CoatOfArm.Coords.Small = { 0,0,64,88 } 
g_CoatOfArm.ColorRGBList = {
    --City colors
    { r=17, g=7, b=216 },
    { r=216, g=7, b=7 },
    { r=25, g=185, b=8 },
    { r=16, g=194, b=220 },
    --village colors
    { r=39, g=62, b=11 },
    { r=199, g=7, b=216 },
    { r=28, g=102, b=103 },
    --cloister colors
    { r=193, g=134, b=198 },
    { r=134, g=198, b=152 },
    { r=184, g=171, b=97 },
    --bandit colors
    { r=184, g=171, b=97 },
    { r=185, g=116, b=8 },
    { r=103, g=65, b=28 },
    --red prince color
    { r=111, g=5, b=41 },
    --traveling salesman color
    { r=71, g=47, b=39 },
    --misc colors
    { r=139, g=223, b=255 },
    { r=255, g=150, b=214 },
    --new city colors
    { r=235, g=255, b=53 },
    { r=252, g=164, b=39 },
    { r=178, g=2, b=255 },
    --new cloister colors
    { r=230, g=230, b=230 },
    { r=115, g=209, b=65 },
    --new bandit colors
    { r=57, g=57, b=57 },
    { r=136, g=136, b=136 }
}
-----------------------------------------------------------------------------------------------------
function g_CoatOfArm.UpdatePattern( _IsSmall, _OptionalPattern, _OptionalGender, _OptionalWidget, _OptionalColorScheme, _OptionalPlayerColor )
    local Widget = _OptionalWidget or XGUIEng.GetCurrentWidgetID()
    local Pattern
    local colorScheme = 0
    local playerColor = 1
    
    if _OptionalPattern ~= nil then
        Pattern = _OptionalPattern - _OptionalGender * g_CoatOfArm.NumberOfPatterns
    else
        Pattern = Profile.GetInteger("Profile", "PatternTexture", 0) - g_CoatOfArm.CurrentGender * g_CoatOfArm.NumberOfPatterns
    end
    
    if Pattern >= g_CoatOfArm.NumberOfPatterns or 
       Pattern <  0  then
        
       Pattern = 0 
       Profile.SetInteger("Profile", "PatternTexture", g_CoatOfArm.CurrentGender * g_CoatOfArm.NumberOfPatterns)
    end

    g_CoatOfArm.CurrentPatternIndex = Pattern
    
    if Profile.GetInteger("Profile", "CoAColorScheme", 0) == 1 then
        colorScheme = 1
    end

    if _OptionalPlayerColor ~= nil then
        playerColor = _OptionalPlayerColor
    else
        playerColor = Profile.GetInteger("Profile", "PreferredPlayerColor", 1)
    end
            
    if _IsSmall then
        local x, y, length, height = unpack(g_CoatOfArm.Coords.Small)
        x = x + g_CoatOfArm.CurrentPatternIndex * 64
        length = length + g_CoatOfArm.CurrentPatternIndex * 64
        if g_CoatOfArm.CurrentGender == 1 then
            x = x + 2048
            length = length + 2048
        end
        if _OptionalColorScheme ~= nil then
            x = x + 1024 * _OptionalColorScheme
            length = length + 1024 * _OptionalColorScheme
        else
            x = x + 1024 * colorScheme
            length = length + 1024 * colorScheme
        end
        y = y + (playerColor-1) * 88
        height = y + 88
        XGUIEng.SetMaterialUV(Widget, 0, x, y, length, height)
    else
        local x, y, length, height = unpack(g_CoatOfArm.Coords.Big)
        x = x + g_CoatOfArm.CurrentPatternIndex * 128
        length = length + g_CoatOfArm.CurrentPatternIndex * 128
        if g_CoatOfArm.CurrentGender == 1 then
            x = x + 4096
            length = length + 4096
        end
        if _OptionalColorScheme ~= nil then
            x = x + 2048 * _OptionalColorScheme
            length = length + 2048 * _OptionalColorScheme
        else
            x = x + 2048 * colorScheme
            length = length + 2048 * colorScheme
        end
        y = y + (playerColor-1) * 176
        height = y + 176
        XGUIEng.SetMaterialUV(Widget, 0, x, y, length, height)
    end
end
-----------------------------------------------------------------------------------------------------
function g_CoatOfArm.UpdatePatternByPlayerColor(_IsSmall)
    local playerID = GUI.GetPlayerID()
    local r,g,b = GUI.GetPlayerColor(playerID)
    local colorIndex = 1
    for i, v in ipairs(g_CoatOfArm.ColorRGBList) do
        if v.r == r and v.g == g and v.b == b then
            colorIndex = i
            --return true;
        end
    end
    g_CoatOfArm.UpdatePattern(_IsSmall, nil, nil, nil, nil, colorIndex)
end