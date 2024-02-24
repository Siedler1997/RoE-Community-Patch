
Script.Load("Script\\Shared\\ScriptSystems\\SharedConstants.lua" )

g_GameOptions = g_MenuPage:CreateNewMenupage("/InGame/GameOptionsMain")

g_DefaultScrollSpeed            = 2600
g_DefaultBorderScrollSize       = 3
g_DefaultZoomStateWheelSpeed    = 4.2
g_DefaultPlayerColor            = 1

g_DefaultZoomModifierForSlider  = 100

-- *****************************************************************************
-- Initialization
-- *****************************************************************************
function g_GameOptions:OnShow()

    if Game ~= nil then
        XGUIEng.ShowWidget("/InGame/GameOptionsMain/Backdrop", 1)
        XGUIEng.ShowWidget("/InGame/GameOptionsMain/RightContainer/PlayerColor", 0)
        XGUIEng.ShowWidget("/InGame/GameOptionsMain/Tooltips/MainMenuSelectColor", 0)
    else
        XGUIEng.ShowWidget("/InGame/GameOptionsMain/Backdrop", 0)
        XGUIEng.ShowWidget("/InGame/GameOptionsMain/RightContainer/PlayerColor", 1)
        XGUIEng.ShowWidget("/InGame/GameOptionsMain/Tooltips/MainMenuSelectColor", 1)
    end
    
    g_MainMenuOptions:ShowHelper()

    -- Border scrolling
    do
        local WidgetID = XGUIEng.GetWidgetID("/InGame/GameOptionsMain/RightContainer/BorderScroll/CheckBox")
                      
        if (Camera.RTS_GetBorderScrollSize() > 0) then
            XGUIEng.CheckBoxSetIsChecked(WidgetID, true)
        else
            XGUIEng.CheckBoxSetIsChecked(WidgetID, false)
        end
    end

    -- Mouse scroll speed
    do
        local WidgetID = XGUIEng.GetWidgetID("/InGame/GameOptionsMain/RightContainer/KeyboardScrollSlider")    
        XGUIEng.SliderSetValueMin(WidgetID, 2)
        XGUIEng.SliderSetValueMax(WidgetID, 8)
        XGUIEng.SliderSetValueAbs(WidgetID, Camera.RTS_GetZoomWheelSpeed())
    end  
                
    -- Keyboard scroll speed                
    do
        local WidgetID = XGUIEng.GetWidgetID("/InGame/GameOptionsMain/RightContainer/MouseScrollSlider")    
        XGUIEng.SliderSetValueMin(WidgetID, 20)
        XGUIEng.SliderSetValueMax(WidgetID, 60)        
        XGUIEng.SliderSetValueAbs(WidgetID, Camera.RTS_GetScrollSpeed() / 100)
    end
     
    self.HasChanged = false
    self.RefreshLeftContainer()
    
end

-- *****************************************************************************
-- React to OK button
-- *****************************************************************************

function g_GameOptions:OnOK()

    -- Border scrolling
    do
        local WidgetID = XGUIEng.GetWidgetID("/InGame/GameOptionsMain/RightContainer/BorderScroll/CheckBox")          
        if (XGUIEng.CheckBoxIsChecked(WidgetID) == true) then        
            Camera.RTS_SetBorderScrollSize(g_DefaultBorderScrollSize)
        else        
            Camera.RTS_SetBorderScrollSize(0)                        
        end 
        
        Options.SetFloatValue("Game", "BorderScrolling", Camera.RTS_GetBorderScrollSize())
        
    end        

    -- Zoom speed
    do
        local WidgetID = XGUIEng.GetWidgetID("/InGame/GameOptionsMain/RightContainer/KeyboardScrollSlider")    
        Camera.RTS_SetZoomWheelSpeed(XGUIEng.SliderGetValueAbs(WidgetID))
        
        Options.SetFloatValue("Game", "ZoomSpeed", Camera.RTS_GetZoomWheelSpeed())
        
    end  
                
    -- Scroll speed                
    do
        local WidgetID = XGUIEng.GetWidgetID("/InGame/GameOptionsMain/RightContainer/MouseScrollSlider")                   
        Camera.RTS_SetScrollSpeed(XGUIEng.SliderGetValueAbs(WidgetID) * 100)
        
        Options.SetFloatValue("Game", "ScrollSpeed", Camera.RTS_GetScrollSpeed())
    end

    self:OnBackPressed()
    
end

-- *****************************************************************************
function g_GameOptions:OnBackPressed()

    g_MainMenuOptions:HideHelper()

    self:Back()

end
-- *****************************************************************************
function g_GameOptions:RestoreDefaults()

    -- Border scrolling
    do
        local WidgetID = XGUIEng.GetWidgetID("/InGame/GameOptionsMain/RightContainer/BorderScroll/CheckBox")
        
        if (g_DefaultBorderScrollSize > 0) then
            XGUIEng.CheckBoxSetIsChecked(WidgetID, true)
        else
            XGUIEng.CheckBoxSetIsChecked(WidgetID, false)
        end
    end

    -- Mouse scroll speed
    do
        local WidgetID = XGUIEng.GetWidgetID("/InGame/GameOptionsMain/RightContainer/KeyboardScrollSlider")    
        XGUIEng.SliderSetValueAbs(WidgetID, g_DefaultZoomStateWheelSpeed)                
    end  
                
    -- Keyboard scroll speed                
    do
        local WidgetID = XGUIEng.GetWidgetID("/InGame/GameOptionsMain/RightContainer/MouseScrollSlider")    
        XGUIEng.SliderSetValueAbs(WidgetID, g_DefaultScrollSpeed / 100)            
    end
    
    -- Player color
    do
        local WidgetID = XGUIEng.GetWidgetID("/InGame/GameOptionsMain/RightContainer/PlayerColor/CheckBox")
        
        if (g_DefaultPlayerColor > 1) then
            XGUIEng.CheckBoxSetIsChecked(WidgetID, true)
        else
            XGUIEng.CheckBoxSetIsChecked(WidgetID, false)
        end
    end
end

-- *****************************************************************************
-- Display  Ok button only if a change has been made
-- *****************************************************************************
function g_GameOptions:OnChange()

    self.HasChanged = true

end
-- *****************************************************************************
function g_GameOptions:UpdateBottomButtons()

    if self.HasChanged then
        XGUIEng.ShowWidget("/InGame/GameOptionsMain/BottomContainer/OKButton",1)
        XGUIEng.ShowWidget("/InGame/GameOptionsMain/BottomContainer/BGDouble",1)
        XGUIEng.ShowWidget("/InGame/GameOptionsMain/BottomContainer/BG",0)

    else
        XGUIEng.ShowWidget("/InGame/GameOptionsMain/BottomContainer/OKButton",0)
        XGUIEng.ShowWidget("/InGame/GameOptionsMain/BottomContainer/BGDouble",0)
        XGUIEng.ShowWidget("/InGame/GameOptionsMain/BottomContainer/BG",1)
    end

end



-- *****************************************************************************
-- Special window for special edition
-- *****************************************************************************
function IsSpecialEdition()
    return true
end

-- *****************************************************************************
function g_GameOptions:OnSubmit()
    local Names = {}
    Names["0025722953"] = "UI_ObjectNames/B_SpecialEdition_Column"
    Names["1703848010"] = "UI_ObjectNames/B_SpecialEdition_StatueFamily"
    local ActivationCode = XGUIEng.GetText("/InGame/GameOptionsMain/LeftContainer/Activation/TextActivationCode")
    if Names[ActivationCode] == nil then
        OpenDialog(XGUIEng.GetStringTableText("UI_Texts/MainMenuOptionsMsgFailed"),
                   XGUIEng.GetStringTableText("UI_Texts/MainMenuOptionsSubmit_center"))
    else
        Options.SetIntValue("Codes", ActivationCode, 1)
        local Name = XGUIEng.GetStringTableText(Names[ActivationCode])
        OpenDialog(XGUIEng.GetStringTableText("UI_Texts/MainMenuOptionsMsgSuccess_colon") .. " " .. Name,
                   XGUIEng.GetStringTableText("UI_Texts/MainMenuOptionsSubmit_center"))
    end
    self.RefreshLeftContainer()
end

-- *****************************************************************************
function g_GameOptions.RefreshLeftContainer()
    XGUIEng.ShowWidget("/InGame/GameOptionsMain/LeftContainer", 0)
    if Game == nil and IsSpecialEdition() == false and Framework.CheckIDV() == false then
        XGUIEng.ShowWidget("/InGame/GameOptionsMain/LeftContainer", 1)
        XGUIEng.ShowWidget("/InGame/GameOptionsMain/LeftContainer/Activation", 1)
        XGUIEng.SetText("/InGame/GameOptionsMain/LeftContainer/Activation/TextActivationCode", "")
    end
end
