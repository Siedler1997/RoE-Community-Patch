-----------------------------------------------------------------------------------------------------
-- CoatOfArm.lua
-----------------------------------------------------------------------------------------------------

g_CoatOfArm = {}

g_CoatOfArm.CurrentGender = 0
g_CoatOfArm.CurrentPatternIndex = 0

g_CoatOfArm.NumberOfPatterns = 15
 
g_CoatOfArm.Coords = {}
g_CoatOfArm.Coords.Big = {}
g_CoatOfArm.Coords.Big.Male = {--"logo"   = {1024,0,1224,200},--size w=128 h=176
                               {1280,0,1408,176}, {1408,0,1536,176}, {1536,0,1664,176}, {1664,0,1792,176}, {1792,0,1920,176},
                               {1280,176,1408,352}, {1408,176,1536,352}, {1536,176,1664,352}, {1664,176,1792,352}, {1792,176,1920,352},
                               {1280,704,1408,880}, {1408,704,1536,880}, {1536,704,1664,880}, {1664,704,1792,880}, {1792,704,1920,880}
                               }

g_CoatOfArm.Coords.Big.Female = {--"logo"   = {1024,256,1224,456},
                                  {1280,352,1408,528}, {1408,352,1536,528}, {1536,352,1664,528}, {1664,352,1792,528}, {1792,352,1920,528},
                                  {1280,528,1408,704}, {1408,528,1536,704}, {1536,528,1664,704}, {1664,528,1792,704}, {1792,528,1920,704},
                                  {1280,880,1408,1056}, {1408,880,1536,1056}, {1536,880,1664,1056}, {1664,880,1792,1056}, {1792,880,1920,1056}
                                }      
g_CoatOfArm.Coords.Small = {}                                                       
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

g_CoatOfArm.NumberOfPatterns = #g_CoatOfArm.Coords.Big.Male


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
function g_CoatOfArm.UpdatePattern( _IsSmall, _OptionalPattern, _OptionalGender,  _OptionalWidget  )

    local Widget = _OptionalWidget or XGUIEng.GetCurrentWidgetID()
    local Pattern
    local newColor = Options.GetIntValue("Game", "AltPlayerColor", 0)
    
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
            
    if g_CoatOfArm.CurrentGender == 0 then
        if _IsSmall then
            local x, y, length, height = unpack(g_CoatOfArm.Coords.Small.Male[g_CoatOfArm.CurrentPatternIndex+1])
            if newColor > 1 then
                y = y + 528
                height = height + 528
            end
            
            XGUIEng.SetMaterialUV(Widget, 0, x, y, length, height )
        else
            local x, y, length, height = unpack(g_CoatOfArm.Coords.Big.Male[g_CoatOfArm.CurrentPatternIndex+1])
            if newColor > 1 then
                x = x + 640
                length = length + 640
            end
            
            XGUIEng.SetMaterialUV(Widget, 0, x, y, length, height )
        end
    else
        if _IsSmall then
            local x, y, length, height = unpack(g_CoatOfArm.Coords.Small.Female[g_CoatOfArm.CurrentPatternIndex+1])
            if newColor > 1 then
                y = y + 528
                height = height + 528
            end
            
            XGUIEng.SetMaterialUV(Widget, 0, x, y, length, height )
        else
            local x, y, length, height = unpack(g_CoatOfArm.Coords.Big.Female[g_CoatOfArm.CurrentPatternIndex+1])
            if newColor > 1 then
                x = x + 640
                length = length + 640
            end
            
            XGUIEng.SetMaterialUV(Widget, 0, x, y, length, height )
        end
    end


end




