---------------------------------------------------------------------------------------------------
-- Globals
---------------------------------------------------------------------------------------------------
g_MainMenuProfile = g_MenuPage:CreateNewMenupage("/InGame/Profile")

g_ProfileNew = g_MenuPage:CreateNewMenupage("/InGame/Profile/NewProfile")

g_ProfileWidget = {}
    g_ProfileWidget.Main = "/InGame/Profile"
    g_ProfileWidget.Bottom = "/InGame/Profile/ContainerBottom"
    g_ProfileWidget.Right = "/InGame/Profile/RightMenu"
    g_ProfileWidget.New  = "/InGame/Profile/NewProfile"
    g_ProfileWidget.List = "/InGame/Profile/ProfileList"

g_MainMenuProfile.IndexOfCurrentGender = 0                  -- 0..1
g_MainMenuProfile.IndexOfCurrentSelectedCoAColorScheme = 0  -- 0..1
g_MainMenuProfile.IndexOfCurrentProfile = 0                 -- 0..n
g_MainMenuProfile.IndexOfCurrentGender = 0                  -- 0..1
g_MainMenuProfile.IndexOfCurrentPreferredColor = 1          -- 1..18

g_MainMenuProfile.ChangingProfile = 0
g_MainMenuProfile.TempGender = 0    				        -- 0..1
g_MainMenuProfile.TempPattern = 0					        -- 0..1
g_MainMenuProfile.TempCoAColorScheme = 0    		        -- 0..1
g_MainMenuProfile.TempPreferredColor = 1    		        -- 1..18
g_MainMenuProfile.BottomCleared = 0
g_MainMenuProfile.ExitCancelVisibile = 0
g_MainMenuProfile.CreateAcceptVisibile = 0


---------------------------------------------------------------------------------------------------
-- Main buttons
---------------------------------------------------------------------------------------------------
function g_MainMenuProfile:Show(_BottomPage, _PopAndKeepOldPage)

    g_MenuPage.Show(self, _BottomPage, _PopAndKeepOldPage)
    XGUIEng.ShowWidget("/InGame/Background/Title", 0)
    XGUIEng.ShowWidget("/InGame/Background/TitleSmall", 1)

    XGUIEng.SliderSetValueMax("/InGame/Profile/NewProfile/Arms/Slider", g_CoatOfArm.NumberOfPatterns - 1)

    XGUIEng.ShowAllSubWidgets(g_ProfileWidget.Main, 0)

    XGUIEng.ShowWidget(g_ProfileWidget.List, 1)
    XGUIEng.ShowWidget(g_ProfileWidget.Right, 1)
    XGUIEng.ShowWidget(g_ProfileWidget.Bottom, 1)

    self:DisplayBottomButtons(g_ProfileWidget.Bottom .. "/BackMenu", g_ProfileWidget.Bottom .. "/ChooseProfile")

    self:UpdateProfileList()
    g_MainMenuProfile.CurrentProfile = Options.GetStringValue("Profile", "Current")


    self.IsFirstLaunch = false
end
---------------------------------------------------------------------------------------------------
function g_MainMenuProfile:Back()

    g_MenuPage.Back(self)
    XGUIEng.ShowWidget("/InGame/Background/Title", 1)
    XGUIEng.ShowWidget("/InGame/Background/TitleSmall", 0)

end
---------------------------------------------------------------------------------------------------
function g_MainMenuProfile:BackToMainMenu()

    Profile.SelectProfile(g_MainMenuProfile.CurrentProfile)

    self:Back()

end
---------------------------------------------------------------------------------------------------
function g_MainMenuProfile:OnChooseProfile()

	local WidgetName = g_ProfileWidget.List .. "/ComboBoxContainer/ListBoxName"

	self.IndexOfCurrentProfile = XGUIEng.ListBoxGetSelectedIndex(WidgetName)
	if self.IndexOfCurrentProfile < 0 then
		self.IndexOfCurrentProfile = 0
	end

	local Name = XGUIEng.ListBoxGetSelectedText(WidgetName)

	Profile.SelectProfile(Name)

    -- Then come back to the main menu
    self:Back()

end
---------------------------------------------------------------------------------------------------
function g_MainMenuProfile:OnChangeProfile()

    self.ChangingProfile = 1

    local CurrentProfile = Options.GetStringValue("Profile", "Current")
	local ProfileToChange = XGUIEng.ListBoxGetSelectedText(g_ProfileWidget.List .."/ComboBoxContainer/ListBoxName")

	Profile.SelectProfile(ProfileToChange)

    XGUIEng.ShowWidget(g_ProfileWidget.List, 0)
    XGUIEng.ShowWidget(g_ProfileWidget.Right, 0)
    XGUIEng.ShowWidget(g_ProfileWidget.New, 1)

    --self:DisplayBottomButtons2(g_ProfileWidget.Bottom .. "/Cancel", g_ProfileWidget.Bottom .. "/AcceptChanges")
    self:DisplayBottomButtons2(g_ProfileWidget.Bottom .. "/Cancel")

    XGUIEng.SetText("/InGame/Profile/NewProfile/ProfileNameInput", ProfileToChange, 1)
    XGUIEng.SetHandleEvents("/InGame/Profile/NewProfile/ProfileNameInput", 0)
    XGUIEng.SetMaterialColor("/InGame/Profile/NewProfile/BGName/BGbottom",0,200,200,200,255)

    local gender = Profile.GetString("Profile", "Gender")
	self:ChoseGender(gender)
    if gender == "male" then
	    self:DisplayGender(0)
    else
	    self:DisplayGender(1)
    end

    local SelectedPattern = Profile.GetInteger("Profile", "PatternTexture", 0) - self.TempGender * g_CoatOfArm.NumberOfPatterns
    self:ChosePattern(SelectedPattern)

    local coAColorScheme = Profile.GetInteger("Profile", "CoAColorScheme", 0)
	--self:ChoseCoAColorScheme(coAColorScheme)
	self:DisplayCoAColorScheme(coAColorScheme)
    g_MainMenuProfile:DisplayPreferredColor(Profile.GetInteger("Profile", "PreferredPlayerColor", 1))

	Profile.SelectProfile(CurrentProfile)

	self.HasChanged = false

end
---------------------------------------------------------------------------------------------------
function g_MainMenuProfile:OnDeleteProfile()

	local SelectedProfile = XGUIEng.ListBoxGetSelectedText(g_ProfileWidget.List .."/ComboBoxContainer/ListBoxName")

	if SelectedProfile ~= g_MainMenuProfile.CurrentProfile then
	    OpenRequesterDialog(XGUIEng.GetStringTableText("UI_Texts/ConfirmDeleteProfile"),
	                        XGUIEng.GetStringTableText("UI_Texts/MainMenuDeleteProfile_center"),
	                        "g_MainMenuProfile:DeleteProfile()")
	else
		OpenDialog(XGUIEng.GetStringTableText("UI_Texts/InfoCannotDeleteCurrentProfile"),
		           XGUIEng.GetStringTableText("UI_Texts/MainMenuDeleteProfile_center"))

	end

end
---------------------------------------------------------------------------------------------------
function g_MainMenuProfile:OnNewProfile()

    XGUIEng.ShowWidget(g_ProfileWidget.List, 0)
    XGUIEng.ShowWidget(g_ProfileWidget.Right, 0)

    XGUIEng.ShowWidget(g_ProfileWidget.New, 1)

    self:DisplayBottomButtons2(g_ProfileWidget.Bottom .. "/Cancel", g_ProfileWidget.Bottom .. "/CreateNew")

	XGUIEng.PrepareTextInputWidgetForFileNameInput("/InGame/Profile/NewProfile/ProfileNameInput")
    XGUIEng.SetText("/InGame/Profile/NewProfile/ProfileNameInput", XGUIEng.GetStringTableText("UI_Texts/Player"), 1 )
    XGUIEng.SetMaterialColor("/InGame/Profile/NewProfile/BGName/BGbottom",0,255,255,255,255)

    self.IndexOfCurrentGender = 0
    self:DisplayGender(self.IndexOfCurrentGender)
    self.IndexOfCurrentSelectedPattern = 0
    self:ChosePattern(self.IndexOfCurrentSelectedPattern)
    self.IndexOfCurrentSelectedCoAColorScheme = 0
    g_MainMenuProfile:DisplayCoAColorScheme(0)
    g_MainMenuProfile:DisplayPreferredColor(1)

end
---------------------------------------------------------------------------------------------------
-- bottom buttons
---------------------------------------------------------------------------------------------------
function g_MainMenuProfile:OnCancel()

	if self.ChangingProfile == 1 then
		self.ChangingProfile = 0
		XGUIEng.SetHandleEvents("/InGame/Profile/NewProfile/ProfileNameInput", 1)
	end
    self:BackToProfileMenu()

end
---------------------------------------------------------------------------------------------------
function g_MainMenuProfile:OnCreateNew()

    local Name = XGUIEng.GetText("/InGame/Profile/NewProfile/ProfileNameInput")

    if not Profile.IsValidProfileName(Name) then
        --ToDo: Add proper text message -> needs new text key
        OpenDialog(XGUIEng.GetStringTableText("UI_Texts/InfoCantCreateProfile"),
                   XGUIEng.GetStringTableText("UI_Texts/MainMenuCreateNew_center") )
        return false
    end
    
    local NameLower = string.lower(Name)
    XGUIEng.SetText("/InGame/Profile/NewProfile/ProfileNameInput", NameLower, 1)


    local ExistingNameLower

    local ExistingName
    local Gender
    local Pattern
    for i=1,Profile.GetProfileCount() do
		ExistingName, Gender, Pattern = Profile.GetProfileData(i)
		ExistingNameLower = string.lower(ExistingName)
        if ExistingNameLower == NameLower then
			OpenDialog(XGUIEng.GetStringTableText("UI_Texts/InfoNameAllreadyExist"),
			           XGUIEng.GetStringTableText("UI_Texts/MainMenuCreateNew_center") )
			return false
		end
    end

    if Profile.CreateNewProfile( Name ) then

        --name
        Profile.SetString("Profile", "Name", Name)

        --gender
        if self.IndexOfCurrentGender == 0 then
            self:ChoseGender("male")
        else
            self:ChoseGender("female")
        end
        
        self:ChoseCoAColorScheme(self.IndexOfCurrentCoAColorScheme)
        self:ChosePreferredColor(self.IndexOfCurrentPreferredColor)

        --Arms
        self:ChosePattern(self.IndexOfCurrentSelectedPattern)	-- may be redundant but we have to call this function
    																-- if we have changed the gender without changing the arms
        Profile.SetInteger("Profile", "PatternTexture", self.IndexOfCurrentSelectedPattern + self.IndexOfCurrentGender * g_CoatOfArm.NumberOfPatterns)

        Profile.SelectProfile(Name)

        self:BackToProfileMenu()

        return true

    else
        OpenDialog(XGUIEng.GetStringTableText("UI_Texts/InfoCantCreateProfile"),
                   XGUIEng.GetStringTableText("UI_Texts/MainMenuCreateNew_center") )
        return false
    end

end

function g_MainMenuProfile:OnCreateFirst()

    if g_MainMenuProfile:OnCreateNew() then

        self:Back()

    end

end
---------------------------------------------------------------------------------------------------
function g_MainMenuProfile:OnAcceptChanges()

	self.ChangingProfile = 0

    XGUIEng.SetHandleEvents("/InGame/Profile/NewProfile/ProfileNameInput", 1)

    local CurrentProfile = Options.GetStringValue("Profile", "Current")
	local ProfileToChange = XGUIEng.GetText("/InGame/Profile/NewProfile/ProfileNameInput")

	Profile.SelectProfile(ProfileToChange)

    --gender
    if self.TempGender == 0 then
        self:ChoseGender("male")
    else
        self:ChoseGender("female")
    end
    
    self:ChoseCoAColorScheme(self.TempCoAColorScheme)
    self:ChosePreferredColor(self.TempPreferredColor)

    --Arms
    self:ChosePattern(self.TempPattern)
    Profile.SetInteger("Profile", "PatternTexture", self.IndexOfCurrentSelectedPattern + self.TempGender * g_CoatOfArm.NumberOfPatterns)

	Profile.SelectProfile(CurrentProfile);

    self:BackToProfileMenu()
end
---------------------------------------------------------------------------------------------------
-- custom functions
---------------------------------------------------------------------------------------------------
function g_MainMenuProfile:BackToProfileMenu()

    XGUIEng.ShowWidget(g_ProfileWidget.List, 1)
    XGUIEng.ShowWidget(g_ProfileWidget.Right, 1)

    XGUIEng.ShowWidget(g_ProfileWidget.New, 0)

    self:DisplayBottomButtons(g_ProfileWidget.Bottom .. "/BackMenu", g_ProfileWidget.Bottom .. "/ChooseProfile")

    self:UpdateProfileList()

    self.BottomCleared = 0
    self.ExitCancelVisibile = 0
    self.CreateAcceptVisibile = 0
end
---------------------------------------------------------------------------------------------------
function g_MainMenuProfile:DisplayBottomButtons(_Button1, _Button2)

    --Hide all buttons
    XGUIEng.ShowAllSubWidgets(g_ProfileWidget.Bottom, 0)

    --show buttons and background
    XGUIEng.ShowWidget(_Button1, 1)

    -- single or double BackGround
    if _Button2 ~= nil then
        XGUIEng.ShowWidget(g_ProfileWidget.Bottom .. "/BGDouble", 1)
        XGUIEng.ShowWidget(_Button2, 1)
    else
        XGUIEng.ShowWidget(g_ProfileWidget.Bottom .. "/BG", 1)
    end
    
end

-- Eine Abwandlung der Funktion, nur für Create/Edit Profile
function g_MainMenuProfile:DisplayBottomButtons2(_Button1, _Button2)
    if self.BottomCleared == 0 then
        self.BottomCleared = 1
        XGUIEng.ShowAllSubWidgets(g_ProfileWidget.Bottom, 0)
    end
    
    if self.ExitCancelVisibile == 0 then
        self.ExitCancelVisibile = 1
        XGUIEng.ShowWidget(_Button1, 1)
    end

    if _Button2 == nil then
        XGUIEng.ShowWidget(g_ProfileWidget.Bottom .. "/BG", 1)
        XGUIEng.ShowWidget(g_ProfileWidget.Bottom .. "/BGDouble", 0)
        
        self.CreateAcceptVisibile = 0
        XGUIEng.ShowWidget(g_ProfileWidget.Bottom .. "/CreateFirst", 0)
        XGUIEng.ShowWidget(g_ProfileWidget.Bottom .. "/CreateNew", 0)
        XGUIEng.ShowWidget(g_ProfileWidget.Bottom .. "/AcceptChanges", 0)
    else
        XGUIEng.ShowWidget(g_ProfileWidget.Bottom .. "/BGDouble", 1)
        XGUIEng.ShowWidget(g_ProfileWidget.Bottom .. "/BG", 0)

        if self.CreateAcceptVisibile == 0 then
            self.CreateAcceptVisibile = 1
            XGUIEng.ShowWidget(_Button2, 1)
        end
    end
end
---------------------------------------------------------------------------------------------------
function g_MainMenuProfile:DisplayGender( _SelectedGender)

    if self.ChangingProfile == 1 then
		self.TempGender = _SelectedGender
	else
		self.IndexOfCurrentGender = _SelectedGender --or 0
	end

	if _SelectedGender == 0 then
        XGUIEng.CheckBoxSetIsChecked("/InGame/Profile/NewProfile/GenderRadios/Lord/CheckBox", true)
        XGUIEng.CheckBoxSetIsChecked("/InGame/Profile/NewProfile/GenderRadios/Lady/CheckBox", false)
    else
        XGUIEng.CheckBoxSetIsChecked("/InGame/Profile/NewProfile/GenderRadios/Lord/CheckBox", false)
        XGUIEng.CheckBoxSetIsChecked("/InGame/Profile/NewProfile/GenderRadios/Lady/CheckBox", true)
    end

end
---------------------------------------------------------------------------------------------------
function g_MainMenuProfile:FirstLaunch()

    self.IsFirstLaunch = true

    XGUIEng.ShowWidget(g_ProfileWidget.List, 0)
    XGUIEng.ShowWidget(g_ProfileWidget.Right, 0)

    XGUIEng.ShowWidget(g_ProfileWidget.New, 1)

    self:DisplayBottomButtons(g_ProfileWidget.Bottom .. "/CreateFirst", g_ProfileWidget.Bottom .. "/Exit")

    XGUIEng.PrepareTextInputWidgetForFileNameInput("/InGame/Profile/NewProfile/ProfileNameInput");
    XGUIEng.SetText("/InGame/Profile/NewProfile/ProfileNameInput", XGUIEng.GetStringTableText("UI_Texts/Player"), 1)
    self.IndexOfCurrentGender = 0
    self:DisplayGender(self.IndexOfCurrentGender)
    self.IndexOfCurrentSelectedPattern = 0
    self:ChosePattern(self.IndexOfCurrentSelectedPattern)
    self.IndexOfCurrentCoAColorScheme = 0
    self:DisplayCoAColorScheme(self.IndexOfCurrentCoAColorScheme)
    self.IndexOfCurrentPreferredColor = 1
    self:DisplayPreferredColor(self.IndexOfCurrentPreferredColor)

end
---------------------------------------------------------------------------------------------------
function g_MainMenuProfile:UpdateProfileList()
    local CurrentProfile = Options.GetStringValue("Profile", "Current")

    local NameListBoxID = XGUIEng.GetWidgetID(g_ProfileWidget.List .."/ComboBoxContainer/ListBoxName")
    XGUIEng.ListBoxPopAll(NameListBoxID)

    local ProfileCount = Profile.GetProfileCount()
    local Name
    local Gender
    local Pattern
    for i=1,ProfileCount do
		Name, Gender, Pattern = Profile.GetProfileData(i)
        XGUIEng.ListBoxPushItem(NameListBoxID, Name)
    end


    XGUIEng.ListBoxSetSelectedIndexByText(NameListBoxID, CurrentProfile)
	self.IndexOfCurrentProfile = XGUIEng.ListBoxGetSelectedIndex(NameListBoxID)

end
---------------------------------------------------------------------------------------------------
function g_MainMenuProfile:OnListBoxNameSelectionChange()

    self.IndexOfCurrentProfile = XGUIEng.ListBoxGetSelectedIndex(g_ProfileWidget.List .."/ComboBoxContainer/ListBoxName")

    local ProfileName = XGUIEng.ListBoxGetSelectedText(g_ProfileWidget.List .."/ComboBoxContainer/ListBoxName")

    Profile.SelectProfile(ProfileName)

end
---------------------------------------------------------------------------------------------------
function g_MainMenuProfile:DeleteProfile()

	local Name = XGUIEng.ListBoxGetSelectedText(g_ProfileWidget.List .."/ComboBoxContainer/ListBoxName")

    Profile.SelectProfile(g_MainMenuProfile.CurrentProfile)
    Profile.DeleteProfile(Name)

    self:BackToProfileMenu()
end
---------------------------------------------------------------------------------------------------
function g_MainMenuProfile:OnGenderSelectionChange(_SelectedIndex)

    local CurrentWidget
    local OtherWidget

    	if _SelectedIndex == 0 then
            CurrentWidget = "/InGame/Profile/NewProfile/GenderRadios/Lord/CheckBox"
            OtherWidget   = "/InGame/Profile/NewProfile/GenderRadios/Lady/CheckBox"
        else
            OtherWidget   = "/InGame/Profile/NewProfile/GenderRadios/Lord/CheckBox"
            CurrentWidget = "/InGame/Profile/NewProfile/GenderRadios/Lady/CheckBox"
        end

    if XGUIEng.CheckBoxIsChecked(CurrentWidget) == true then

        self.HasChanged = true

    	if self.ChangingProfile == 1 then
    		self.TempGender = _SelectedIndex
    	else
    	    self.IndexOfCurrentGender = _SelectedIndex
    	end

        XGUIEng.CheckBoxSetIsChecked(OtherWidget,false)
    else
        XGUIEng.CheckBoxSetIsChecked(CurrentWidget,true)
    end

end
---------------------------------------------------------------------------------------------------
function g_MainMenuProfile:ChoseGender(_Gender)

	Profile.SetString("Profile", "Gender", _Gender)

	if (_Gender == "male") then
		Profile.SetInteger("Profile", "LogoTexture", 0)
	else -- "female"
		Profile.SetInteger("Profile", "LogoTexture", 1)
	end

end
---------------------------------------------------------------------------------------------------
function g_MainMenuProfile:ChosePattern(_PatternNumber)

    XGUIEng.SliderSetValueAbs("/InGame/Profile/NewProfile/Arms/Slider", _PatternNumber)

	if self.ChangingProfile == 1 then
		self.TempPattern = _PatternNumber
	else
		self.IndexOfCurrentSelectedPattern = _PatternNumber
	end

--    for i =1,2 do
--        XGUIEng.ShowWidget(g_ProfileWidget.New .. "/Arms/CoA" .. i .. "/BG", 0)
--    end
--
--    XGUIEng.ShowWidget(g_ProfileWidget.New .. "/Arms/CoA" .. _PatternNumber .. "/BG", 1)


end
---------------------------------------------------------------------------------------------------
function g_MainMenuProfile:OnPatternSliderValueChange()

    self.HasChanged = true

    local SliderIndex = XGUIEng.SliderGetValueAbs("/InGame/Profile/NewProfile/Arms/Slider")

	if self.ChangingProfile == 1 then
		self.TempPattern = SliderIndex
	else
		self.IndexOfCurrentSelectedPattern = SliderIndex
	end

end
---------------------------------------------------------------------------------------------------
function g_MainMenuProfile:UpdateProfileName()
    local Name = XGUIEng.GetText("/InGame/Profile/NewProfile/ProfileNameInput")

    if Name == "" then
        if self.IsFirstLaunch then
            self:DisplayBottomButtons2(g_ProfileWidget.Bottom .. "/Exit")
        else
            self:DisplayBottomButtons2(g_ProfileWidget.Bottom .. "/Cancel")
        end
    else
        if self.IsFirstLaunch then
            self:DisplayBottomButtons2(g_ProfileWidget.Bottom .. "/Exit", g_ProfileWidget.Bottom .. "/CreateFirst")
        else
            if self.ChangingProfile == 1 then
                if self.HasChanged then
                    self:DisplayBottomButtons2(g_ProfileWidget.Bottom .. "/Cancel", g_ProfileWidget.Bottom .. "/AcceptChanges")
                else --no changes yet
                    self:DisplayBottomButtons2(g_ProfileWidget.Bottom .. "/Cancel")
                end
            else
                self:DisplayBottomButtons2(g_ProfileWidget.Bottom .. "/Cancel", g_ProfileWidget.Bottom .. "/CreateNew")
            end
        end
    end
end

---------------------------------------------------------------------------------------------------
function g_MainMenuProfile:UpdatePattern(_Pattern)

    local IndexGender
    local IndexPattern
    local IndexColorScheme
    local IndexPreferredColor
    if self.ChangingProfile == 1 then
		IndexGender = self.TempGender
		IndexPattern = self.TempPattern
		IndexColorScheme = self.TempCoAColorScheme
		IndexPreferredColor = self.TempPreferredColor
	else
		IndexGender = self.IndexOfCurrentGender
		IndexPattern = self.IndexOfCurrentSelectedPattern
		IndexColorScheme = self.IndexOfCurrentCoAColorScheme
		IndexPreferredColor = self.IndexOfCurrentPreferredColor
	end

    local PatternTexture = IndexGender * g_CoatOfArm.NumberOfPatterns + (IndexPattern)
    g_CoatOfArm.UpdatePattern( false, PatternTexture, IndexGender, nil, IndexColorScheme, IndexPreferredColor )

    --for i=0,4 do
    --    XGUIEng.SetMaterialTexture(WidgetID, i, "graphics\\Textures\\GUI\\" .. PatternTexture .. ".png")
    --end

end
---------------------------------------------------------------------------------------------------
function g_MainMenuProfile:UpdateLogo(_Pattern)

    local IndexGender
    if self.ChangingProfile == 1 then
		IndexGender = self.TempGender
	else
		IndexGender = self.IndexOfCurrentGender
	end

    local WidgetID = XGUIEng.GetWidgetID(g_ProfileWidget.New .. "/Arms/CoA/Logo")

    local LogoTexture = IndexGender

    g_CoatOfArm.UpdateGender( false, LogoTexture )
    --XGUIEng.SetMaterialTexture(WidgetID, 0, "graphics\\Textures\\GUI\\" .. LogoTexture .. ".png")

end
---------------------------------------------------------------------------------------------------
function g_MainMenuProfile:DisplayCoAColorScheme( _SelectedCoAColorScheme)

    if self.ChangingProfile == 1 then
		self.TempCoAColorScheme = _SelectedCoAColorScheme
	else
		self.IndexOfCurrentCoAColorScheme = _SelectedCoAColorScheme --or 0
	end

	if _SelectedCoAColorScheme == 0 then
        XGUIEng.CheckBoxSetIsChecked("/InGame/Profile/NewProfile/CoARadios/Bright/BrightCheckBox", true)
        XGUIEng.CheckBoxSetIsChecked("/InGame/Profile/NewProfile/CoARadios/Dark/DarkCheckBox", false)
    else
        XGUIEng.CheckBoxSetIsChecked("/InGame/Profile/NewProfile/CoARadios/Bright/BrightCheckBox", false)
        XGUIEng.CheckBoxSetIsChecked("/InGame/Profile/NewProfile/CoARadios/Dark/DarkCheckBox", true)
    end

end
---------------------------------------------------------------------------------------------------
function g_MainMenuProfile:OnCoAColorSchemeSelectionChange(_SelectedIndex)

    local CurrentWidget
    local OtherWidget

    	if _SelectedIndex == 0 then
            CurrentWidget = "/InGame/Profile/NewProfile/CoARadios/Bright/BrightCheckBox"
            OtherWidget   = "/InGame/Profile/NewProfile/CoARadios/Dark/DarkCheckBox"
        else
            OtherWidget   = "/InGame/Profile/NewProfile/CoARadios/Bright/BrightCheckBox"
            CurrentWidget = "/InGame/Profile/NewProfile/CoARadios/Dark/DarkCheckBox"
        end

    if XGUIEng.CheckBoxIsChecked(CurrentWidget) == true then

        self.HasChanged = true

    	if self.ChangingProfile == 1 then
    		self.TempCoAColorScheme = _SelectedIndex
    	else
    	    self.IndexOfCurrentCoAColorScheme = _SelectedIndex
    	end

        XGUIEng.CheckBoxSetIsChecked(OtherWidget,false)
    else
        XGUIEng.CheckBoxSetIsChecked(CurrentWidget,true)
    end

end
---------------------------------------------------------------------------------------------------
function g_MainMenuProfile:ChoseCoAColorScheme(_CoAColorScheme)

    Profile.SetInteger("Profile", "CoAColorScheme", _CoAColorScheme)

end

---------------------------------------------------------------------------------------------------
function g_MainMenuProfile:DisplayPreferredColor( _SelectedPreferredColor)

    if self.ChangingProfile == 1 then
		self.TempPreferredColor = _SelectedPreferredColor
	else
		self.IndexOfCurrentPreferredColor = _SelectedPreferredColor --or 1
	end

	if _SelectedPreferredColor == 1 then
        XGUIEng.CheckBoxSetIsChecked("/InGame/Profile/NewProfile/PreferredColorRadios/Blue/BlueCheckBox", true)
        XGUIEng.CheckBoxSetIsChecked("/InGame/Profile/NewProfile/PreferredColorRadios/Yellow/YellowCheckBox", false)
    else
        XGUIEng.CheckBoxSetIsChecked("/InGame/Profile/NewProfile/PreferredColorRadios/Blue/BlueCheckBox", false)
        XGUIEng.CheckBoxSetIsChecked("/InGame/Profile/NewProfile/PreferredColorRadios/Yellow/YellowCheckBox", true)
    end

end
---------------------------------------------------------------------------------------------------
function g_MainMenuProfile:OnPreferredColorSelectionChange(_SelectedIndex)

    local CurrentWidget
    local OtherWidget

    	if _SelectedIndex == 1 then
            CurrentWidget = "/InGame/Profile/NewProfile/PreferredColorRadios/Blue/BlueCheckBox"
            OtherWidget   = "/InGame/Profile/NewProfile/PreferredColorRadios/Yellow/YellowCheckBox"
        else
            OtherWidget   = "/InGame/Profile/NewProfile/PreferredColorRadios/Blue/BlueCheckBox"
            CurrentWidget = "/InGame/Profile/NewProfile/PreferredColorRadios/Yellow/YellowCheckBox"
        end

    if XGUIEng.CheckBoxIsChecked(CurrentWidget) == true then

        self.HasChanged = true

    	if self.ChangingProfile == 1 then
    		self.TempPreferredColor = _SelectedIndex
    	else
    	    self.IndexOfCurrentPreferredColor = _SelectedIndex
    	end

        XGUIEng.CheckBoxSetIsChecked(OtherWidget,false)
    else
        XGUIEng.CheckBoxSetIsChecked(CurrentWidget,true)
    end

end
---------------------------------------------------------------------------------------------------
function g_MainMenuProfile:ChosePreferredColor(_PreferredColor)

    Profile.SetInteger("Profile", "PreferredPlayerColor", _PreferredColor)

end