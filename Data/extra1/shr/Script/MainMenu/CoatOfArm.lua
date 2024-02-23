-----------------------------------------------------------------------------------------------------
-- CoatOfArm.lua
-----------------------------------------------------------------------------------------------------

g_CoatOfArm = {}

g_CoatOfArm.CurrentGender = 0
g_CoatOfArm.CurrentPatternIndex = 0
g_CoatOfArm.CurrentColorSchemeIndex = 0

g_CoatOfArm.NumberOfPatterns = 16
 
g_CoatOfArm.Coords = {}
g_CoatOfArm.Coords.Big = { 0,0,128,176 }
--[[
g_CoatOfArm.Coords.Big.Male = {--"logo"   = {1024,0,1224,200},--size w=128 h=176
                               {0,0,128,176}, {128,0,256,176}, {256,0,384,176}, {384,0,512,176}, {512,0,640,176},
                               {640,0,768,176}, {768,0,896,176}, {896,0,1024,176}, {1024,0,1152,176}, {1152,0,1280,176},
                               {1280,0,1408,176}, {1408,0,1536,176}, {1536,0,1664,176}, {1664,0,1792,176}, {1792,0,1920,176}, {1920,0,2048,176}
                               }
g_CoatOfArm.Coords.Big.Female = {--"logo"   = {1024,256,1224,456},
                               {4096,0,4224,176}, {4224,0,4352,176}, {4352,0,4480,176}, {4480,0,4608,176}, {4608,0,4736,176},
                               {4736,0,4864,176}, {4864,0,4992,176}, {4992,0,5120,176}, {5120,0,5248,176}, {5248,0,5376,176},
                               {5376,0,5504,176}, {5504,0,5632,176}, {5632,0,5760,176}, {5760,0,5888,176}, {5888,0,6016,176}, {6016,0,6144,176}
                                }      
--]]
--g_CoatOfArm.Coords.Big.Male = { 0,0,128,176 }
--g_CoatOfArm.Coords.Big.Female = {4096,0,4224,176 }

g_CoatOfArm.Coords.Small = { 0,0,64,88 } 

--[[
g_CoatOfArm.Coords.Small.Male = {--"logo"   = {832,512,932,612},--size w=64 h=88
                               {960,512,1024,600}, {1024,512,1088,600}, {1088,512,1152,600}, {1152,512,1216,600}, {1216,512,1280,600},
                               {960,600,1024,688}, {1024,600,1088,688}, {1088,600,1152,688}, {1152,600,1216,688}, {1216,600,1280,688},
                               {960,864,1024,952}, {1024,864,1088,952}, {1088,864,1152,952}, {1152,864,1216,952}, {1216,864,1280,952}
                               }
g_CoatOfArm.Coords.Small.Female = {--"logo"   = {832,640,932,740},
                                  {960,688,1024,776}, {1024,688,1088,776}, {1088,688,1152,776}, {1152,688,1216,776}, {1216,688,1280,776},
                                  {960,776,1024,864}, {1024,776,1088,864}, {1088,776,1152,864}, {1152,776,1216,864}, {1216,776,1280,864},
                                  {960,952,1024,1040}, {1024,952,1088,1040}, {1088,952,1152,1040}, {1152,952,1216,1040}, {1216,952,1280,1040}
                                }    
--]]
--g_CoatOfArm.Coords.Small.Male = { 0,0,64,88 }
--g_CoatOfArm.Coords.Small.Female = { 2048,0,2112,88 } 


--g_CoatOfArm.NumberOfPatterns = #g_CoatOfArm.Coords.Big.Male

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
function g_CoatOfArm.Init()

	--XGUIEng.PushPage( "/InGame/COA", false )
    XGUIEng.ShowWidget(g_CoatOfArm.Widget.COA,1)
end
-----------------------------------------------------------------------------------------------------
function g_CoatOfArm.UpdateGender( _IsSmall, _OptionalGender,  _OptionalWidget )
    
    local Widget = _OptionalWidget or XGUIEng.GetCurrentWidgetID()
    
    local Gender = _OptionalGender
    
    if Gender == nil then
         Gender = Profile.GetInteger("Profile", "LogoTexture", 0)

	end
	
	if Gender<0 or Gender>1 then
	    Gender=0
	    Profile.SetInteger("Profile", "LogoTexture", Gender)
	    Profile.SetString("Profile", "Gender", "male")
	end
    
    g_CoatOfArm.CurrentGender = Gender	
	
	if g_CoatOfArm.CurrentGender == 0 then --male
	    if _IsSmall then
	        XGUIEng.SetMaterialUV(Widget, 1, 832,512,932,612)	        
	    else
	        XGUIEng.SetMaterialUV(Widget, 1, 1024,0,1224,200)
	    end
	else -- female
	    if _IsSmall then
	        XGUIEng.SetMaterialUV(Widget, 1, 832,640,932,740)	        
	    else
	        XGUIEng.SetMaterialUV(Widget, 1, 1024,256,1224,456)
	    end	end
	
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