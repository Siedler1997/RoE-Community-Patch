Script.Load("Script\\MainMenu\\Fader.lua" )

g_MissionTexts = {}
g_MissionTexts.Title = "Basrima"
g_MissionTexts.Objectives = "Mission: {cr}Choose a knight and send him to Basrima before he decides to split."
g_VoiceId = ""
g_CampaignMaps = {  "c01_m01_Basrima",
                    "c01_m02_Hendalla",
                    "c01_m03_Amesthan",
                    "c01_m04_Almerabad",
                    "c01_m05_Idukun",
                    "c00_m06_Rekkyr",
                    "c01_m06_Praphatstan",
                    "c01_m07_Nakhata",
                    "c01_m08_Thela" }


SelectionWidget = "/InGame/ThroneRoom/Main/Selection"
MapWidget = "/InGame/ThroneRoom/Main/Map"

g_KnightResponses = {}
g_KnightResponses[Entities.U_KnightTradingStanding]     = 0
g_KnightResponses[Entities.U_KnightHealingStanding]     = 0
g_KnightResponses[Entities.U_KnightChivalryStanding]    = 0
g_KnightResponses[Entities.U_KnightWisdomStanding]      = 0
g_KnightResponses[Entities.U_KnightPlunderStanding]     = 0
g_KnightResponses[Entities.U_KnightSongStanding]        = 0

g_KnightTypes = {}
g_KnightTypes[Entities.U_KnightTradingStanding]     = Entities.U_KnightTrading
g_KnightTypes[Entities.U_KnightHealingStanding]     = Entities.U_KnightHealing
g_KnightTypes[Entities.U_KnightChivalryStanding]    = Entities.U_KnightChivalry
g_KnightTypes[Entities.U_KnightWisdomStanding]      = Entities.U_KnightWisdom
g_KnightTypes[Entities.U_KnightPlunderStanding]     = Entities.U_KnightPlunder
g_KnightTypes[Entities.U_KnightSongStanding]        = Entities.U_KnightSong

g_KnightIds = {}
g_KnightIds[Entities.U_KnightTradingStanding]     = 00
g_KnightIds[Entities.U_KnightHealingStanding]     = 00
g_KnightIds[Entities.U_KnightChivalryStanding]    = 00
g_KnightIds[Entities.U_KnightWisdomStanding]      = 00
g_KnightIds[Entities.U_KnightPlunderStanding]     = 00
g_KnightIds[Entities.U_KnightSongStanding]        = 00

g_KnightYaws = {}
g_KnightYaws[Entities.U_KnightTradingStanding]     = -20
g_KnightYaws[Entities.U_KnightHealingStanding]     = -10
g_KnightYaws[Entities.U_KnightChivalryStanding]    = - 5
g_KnightYaws[Entities.U_KnightWisdomStanding]      =   5
g_KnightYaws[Entities.U_KnightPlunderStanding]     =  20
g_KnightYaws[Entities.U_KnightSongStanding]        =  20

g_KnightEyes = {}
g_KnightEyes[Entities.U_KnightTradingStanding]     = 30
g_KnightEyes[Entities.U_KnightHealingStanding]     = 27
g_KnightEyes[Entities.U_KnightChivalryStanding]    = 30
g_KnightEyes[Entities.U_KnightWisdomStanding]      = 30
g_KnightEyes[Entities.U_KnightPlunderStanding]     = 27
g_KnightEyes[Entities.U_KnightSongStanding]        = 30

g_KnightIdles = {}
g_KnightIdles[Entities.U_KnightTradingStanding]     = "Idle01_KnightTrading"
g_KnightIdles[Entities.U_KnightHealingStanding]     = "Idle01_KnightHealing"
g_KnightIdles[Entities.U_KnightChivalryStanding]    = "Idle01_KnightChivalry"
g_KnightIdles[Entities.U_KnightWisdomStanding]      = "Idle01_KnightWisdom"
g_KnightIdles[Entities.U_KnightPlunderStanding]     = "Idle01_KnightPlunder"
g_KnightIdles[Entities.U_KnightSongStanding]        = "Idle01_KnightSong"


g_Throneroom = {

	Widget = {
		Campaign = "/InGame/ThroneRoom/Main/Campaign",
		Skip = "/InGame/ThroneRoom/Main/Skip",
		Back = "/InGame/ThroneRoom/Main/BackButton",
		Start = "/InGame/ThroneRoom/Main/StartButton"
	},
	CenterEntity = 0,
	Knight = {
		SelectedIndex = 0,
		SelectedEntityId = 0,
		HoverIndex = 0,
		HoverEntityId = 0,
		FirstKnight = 0
	},
	Campaign = {
		IsOpen = false
	},
	Camera = {
		TimeStamp = 0,
		Duration = 0,
		YawBase = -270,
		BasePitch = -2,
		CurrentPitch = -2,
		TargetPitch = -2,
		CurrentYaw = -270,
		TargetYaw = -270,
		--------------------
		ZPositionBase = 2165,
		--------------------
		BaseX = 1219,
		BaseY = 2898,
		BaseZ = 2145,
		--------------------
		CurrentX = 1219,
		CurrentY = 2898,
		CurrentZ = 2145,

		StartX = 1219,
		StartY = 2898,
		StartZ = 2145,
		--------------------
		TargetX = 1219,
		TargetY = 2898,
		TargetZ = 2145,
		--------------------
		LookAtX = 1649,
		LookAtY = 2898,
		LookAtZ = 2145,
		--------------------
		BaseLookAtX = 1649,
		BaseLookAtY = 2898,
		BaseLookAtZ = 2145,
		--------------------
		FoV = 75,
		StartFov = 75,
		CurrentFov = 75,
		TargetFov = 75
	},
	CutScene = {
		IsRunning = true,
		Counter = 0,
		Program = {},
		Briefing = {},
		JobId = 0,
		PC = 0,
		Bars1 = "/InGame/ThroneRoomBars",
		Bars2 = "/InGame/ThroneRoomBars_2"
	},
	IngameKnightType = 0
}

function Show2Buttons()
	XGUIEng.ShowWidget("/InGame/ThroneRoom/Main/DialogBottomRight3pcs", 0)
	XGUIEng.ShowWidget("/InGame/ThroneRoom/Main/DialogBottomRight", 1)
	XGUIEng.ShowWidget("/InGame/ThroneRoom/Main/KnightInfoButton", 0)
end

function Show3Buttons()
	XGUIEng.ShowWidget("/InGame/ThroneRoom/Main/DialogBottomRight3pcs", 1)
	XGUIEng.ShowWidget("/InGame/ThroneRoom/Main/DialogBottomRight", 0)
	XGUIEng.ShowWidget("/InGame/ThroneRoom/Main/KnightInfoButton", 1)
end


function RemoveTraitorFromThroneRoom()

    --Traitor can only be get in local state because Profile is not available in global state
    Traitor = Entities[Logic.GetEntityTypeName(LocalGetTraitor()) .. "Standing"]

    GUI.SendScriptCommand("RemoveKnight(" .. Traitor ..")", true)

end

---------------------------------------------------------------------------------------------------------------------------------
function ResetThroneRoomCamera()

	GUI.SendScriptCommand("StopAllAnimations()",true)

	Camera.SwitchCameraBehaviour(5)

	g_Throneroom.Camera.Duration = 0

	g_Throneroom.Camera.CurrentX = g_Throneroom.Camera.BaseX
	g_Throneroom.Camera.CurrentY = g_Throneroom.Camera.BaseY
	g_Throneroom.Camera.CurrentZ = g_Throneroom.Camera.BaseZ

	g_Throneroom.Camera.TargetX = g_Throneroom.Camera.CurrentX
	g_Throneroom.Camera.TargetY = g_Throneroom.Camera.CurrentY
	g_Throneroom.Camera.TargetZ = g_Throneroom.Camera.CurrentZ

	Camera.ThroneRoom_SetPosition(g_Throneroom.Camera.BaseX,g_Throneroom.Camera.BaseY,g_Throneroom.Camera.BaseZ)

	g_Throneroom.Camera.LookAtX = g_Throneroom.Camera.BaseLookAtX
	g_Throneroom.Camera.LookAtY = g_Throneroom.Camera.BaseLookAtY
	g_Throneroom.Camera.LookAtZ = g_Throneroom.Camera.BaseLookAtZ

	Camera.ThroneRoom_SetLookAt(g_Throneroom.Camera.BaseLookAtX,g_Throneroom.Camera.BaseLookAtY,g_Throneroom.Camera.BaseLookAtZ)

	g_Throneroom.Camera.FoV = 75

	g_Throneroom.Camera.CurrentFov = 75

	g_Throneroom.Camera.StartFov = 75

	g_Throneroom.Camera.TargetFov = 75

	Camera.ThroneRoom_SetFOV(g_Throneroom.Camera.FoV)

	g_KnightResponses[Entities.U_KnightTradingStanding]     = 0
	g_KnightResponses[Entities.U_KnightHealingStanding]     = 0
	g_KnightResponses[Entities.U_KnightChivalryStanding]    = 0
	g_KnightResponses[Entities.U_KnightWisdomStanding]      = 0
	g_KnightResponses[Entities.U_KnightPlunderStanding]     = 0
	g_KnightResponses[Entities.U_KnightSongStanding]        = 0

end
---------------------------------------------------------------------------------------------------------------------------------
function Mission_LocalOnMapStart()

    XGUIEng.PopPage()

    --hide 3dOnScreenDisplay for throneroom
    XGUIEng.ShowWidget("/InGame/Root/3dOnScreenDisplay", 0)

    Input.KeyBindDown(Keys.Escape, "OnSkipButtonPressed()", 14)

	-- Turns terrain rendering off
	Display.SetRenderTerrain(-1)

	g_Throneroom.CenterEntity = Logic.GetEntityIDByName("CampaignMapTable")

	Display.SetRenderDecals(0)

	--XGUIEng.ShowWidget(SelectionWidget,0)

	XGUIEng.ShowWidget(MapWidget,0)

	g_Camera.FadeInOffset = 100

	XGUIEng.ShowWidget("/InGame/Root/Normal", 0)

	XGUIEng.ShowWidget("/InGame/ThroneRoom", 1)

	XGUIEng.ShowWidget("/InGame/ThroneRoomBars", 1)
	XGUIEng.ShowWidget("/InGame/ThroneRoomBars_Dodge", 1)

	XGUIEng.PushPage("/InGame/ThroneRoomBars", false)

	XGUIEng.PushPage("/InGame/ThroneRoomBars_2", false)

	XGUIEng.PushPage("/InGame/ThroneRoom/Main", false)

	XGUIEng.PushPage("/InGame/ThroneRoomBars_Dodge", false)

	XGUIEng.PushPage("/InGame/ThroneRoomBars_2_Dodge", false)

	GUI.ForbidContextSensitiveCommandsInSelectionState()

	StartSimpleHiResJob("CheckSelectionStatus")

	ResetThroneRoomCamera()

	Display.SetExplicitEnvironmentSettings("ThroneRoom.xml")

	ResetThroneRoome()

	LoadThroneRoomScript()

	if CreateThroneRoomCutscene ~= nil then

		CreateThroneRoomCutscene()

	else

		g_Throneroom.CutScene.Program =
		{
			{	1,EndCutscene				}
		}

	end

	if g_Throneroom.MissionGiver == nil then

	     g_Throneroom.MissionGiver = Entities.U_KnightChivalryStanding

    end

	InitializeFader()

	Briefing()

	g_VoiceId = ""

	StartCutScene()

	g_VoiceId = "ImportantStuff"

    XGUIEng.SetText("/LoadScreen/LoadScreen/ButtonStart", XGUIEng.GetStringTableText("UI_Texts/ThroneRoomBriefing_center"))
    XGUIEng.PushPage("/LoadScreen/LoadScreen", false)	 

end
----------------------------------------------------------------------------------------------------------------------
function CloseThroneRoom()

	GUI.SendScriptCommand("StopAllAnimations()",true)

--	XGUIEng.ShowWidget("/InGame/ThroneRoomBars",0)
--	XGUIEng.ShowWidget("/InGame/ThroneRoomBars_Dodge",0)

	GUI.SendScriptCommand("RemoveKnightCursor()",true)

	XGUIEng.PopPage() -- "/InGame/ThroneRoom/Main", false

	XGUIEng.PopPage() -- "/InGame/ThroneRoomBars", false

end
----------------------------------------------------------------------------------------------------------------------
function LoadThroneRoomScript()

	local campaign = Framework.GetCampaignName()

	local map = Framework.GetCurrentMapName()

	Script.Load("Maps\\Campaign\\"..campaign.."\\"..map.."\\throneroom.lua")

end
---------------------------------------------------------------------------------------------------------------------------------
function SetNameAndBriefingText()

    local MapName = "Map_" .. Framework.GetCurrentMapName()

    local Name = XGUIEng.GetStringTableText(MapName .. "/MapName")

    if Name == "" then

        Name = MapName

    end

	XGUIEng.SetText("/InGame/ThroneRoom/Main/MissionBriefing/Title", Name)

	local Description = XGUIEng.GetStringTableText(MapName .. "/MapDescription")

	if Description == "" then

        Description = "Description for map " .. MapName .. " missing (" ..MapName .. "/MapDescription )"

    end

    XGUIEng.SetText("/InGame/ThroneRoom/Main/MissionBriefing/Objectives", Description)

end
---------------------------------------------------------------------------------------------------------------------------------
function HideNameAndBriefingText()

    XGUIEng.SetText("/InGame/ThroneRoom/Main/MissionBriefing/Objectives", " ")
    XGUIEng.SetText("/InGame/ThroneRoom/Main/MissionBriefing/Title", " ")

end
---------------------------------------------------------------------------------------------------------------------------------
function ResetThroneRoome()

	g_Throneroom.Knight.HoverIndex = 0

	g_Throneroom.Knight.HoverEntityId = 0

	g_Throneroom.Knight.SelectedIndex = 0

	g_Throneroom.Knight.SelectedEntityId = 0

	g_Throneroom.Campaign.IsOpen = 0

	g_Throneroom.Knight.FirstKnight = 0

end
---------------------------------------------------------------------------------------------------------------------------------
function GetKnightIndex(EntityID)

	if EntityID ~= 0 and EntityID ~= nil then

		if Logic.IsKnight(EntityID) then

			local name = Logic.GetEntityName(EntityID)

			local id = string.sub(name,2)

			return id

		end

	end

	return 0

end
---------------------------------------------------------------------------------------------------------------------------------
function ThroneRoomCameraControl()

	if UpdateFader() == false then

		return

	end

	if g_Throneroom.Campaign.IsOpen == 1 then

		return

	end

	----

	if g_Throneroom.Camera.Duration <= 0 then

		g_Throneroom.Camera.CurrentX = g_Throneroom.Camera.CurrentX + (g_Throneroom.Camera.TargetX - g_Throneroom.Camera.CurrentX) * 0.05
		g_Throneroom.Camera.CurrentY = g_Throneroom.Camera.CurrentY + (g_Throneroom.Camera.TargetY - g_Throneroom.Camera.CurrentY) * 0.05
		g_Throneroom.Camera.CurrentZ = g_Throneroom.Camera.CurrentZ + (g_Throneroom.Camera.TargetZ - g_Throneroom.Camera.CurrentZ) * 0.05

		g_Throneroom.Camera.CurrentFov = g_Throneroom.Camera.CurrentFov + (g_Throneroom.Camera.TargetFov - g_Throneroom.Camera.CurrentFov) * 0.05

	else

		local time = Framework.TimeGetTime()

		local progress = (time - g_Throneroom.Camera.TimeStamp) / g_Throneroom.Camera.Duration

		g_Throneroom.Camera.CurrentX = LERP(g_Throneroom.Camera.StartX,g_Throneroom.Camera.TargetX,progress)
		g_Throneroom.Camera.CurrentY = LERP(g_Throneroom.Camera.StartY,g_Throneroom.Camera.TargetY,progress)
		g_Throneroom.Camera.CurrentZ = LERP(g_Throneroom.Camera.StartZ,g_Throneroom.Camera.TargetZ,progress)

		g_Throneroom.Camera.CurrentFov = LERP(g_Throneroom.Camera.StartFov,g_Throneroom.Camera.TargetFov,progress)

		if progress >= 1 then

			g_Throneroom.Camera.Duration = 0

			g_Throneroom.Camera.CurrentX = g_Throneroom.Camera.TargetX
			g_Throneroom.Camera.CurrentY = g_Throneroom.Camera.TargetY
			g_Throneroom.Camera.CurrentZ = g_Throneroom.Camera.TargetZ

			g_Throneroom.Camera.CurrentFov = g_Throneroom.Camera.TargetFov

		end

	end

	----

	Camera.ThroneRoom_SetFOV(g_Throneroom.Camera.CurrentFov)

	Camera.ThroneRoom_SetPosition(g_Throneroom.Camera.CurrentX,g_Throneroom.Camera.CurrentY,g_Throneroom.Camera.CurrentZ)

	Camera.ThroneRoom_SetLookAt(g_Throneroom.Camera.LookAtX,g_Throneroom.Camera.LookAtY,g_Throneroom.Camera.LookAtZ)

	----

	local screenX, screenY = XGUIEng.GetWidgetScreenSize("/InGame/ThroneRoom")

	if g_Throneroom.Knight.SelectedEntityId ~= 0 then

		local entityX,entityY = GUI.GetEntityInfoScreenPosition(g_Throneroom.Knight.SelectedEntityId)

		local widgetWidth,widgetHeight = XGUIEng.GetWidgetSize(SelectionWidget)

		XGUIEng.ShowWidget(SelectionWidget,0)

		XGUIEng.SetWidgetScreenPosition(SelectionWidget,entityX -widgetWidth /4,entityY + screenY *0.07)

	end

end
---------------------------------------------------------------------------------------------------------------------------------
function ShowKnightToolTip()

	if g_Throneroom.CutScene.IsRunning == 1 then

		return

	end

	if g_Throneroom.Knight.HoverEntityId ~= 0 then

	    local EntityType = Logic.GetEntityType(g_Throneroom.Knight.HoverEntityId)

	    local EntityTypeName = Logic.GetEntityTypeName(GetInGameKnightType(EntityType))

	    local KnightName = XGUIEng.GetStringTableText("Names/" .. EntityTypeName)

	    local KnightDesc = XGUIEng.GetStringTableText("UI_ObjectDescription/".. EntityTypeName)
-- {@color: 255,123,123}
	    if KnightName == "" then

	        KnightName = EntityTypeName

        end

        if KnightDesc == "" then

            KnightDesc = "description missing"

        end

		XGUIEng.SetText("/InGame/ThroneRoom/Main/TitleContainer/Title", "{center}" .. KnightName)
		XGUIEng.SetText("/InGame/ThroneRoom/Main/TitleContainer/TitleBlack", "{center}" .. KnightName)
		XGUIEng.SetText("/InGame/ThroneRoom/Main/TitleContainer/TitleWhite", "{center}" .. KnightName)
		XGUIEng.SetText("/InGame/ThroneRoom/KnightInfo/Title", "{center}"..KnightName)
		XGUIEng.SetText("/InGame/ThroneRoom/KnightInfo/TitleWhite", "{center}"..KnightName)
		XGUIEng.SetText("/InGame/ThroneRoom/KnightInfo/TitleBlack", "{center}"..KnightName)
		XGUIEng.SetText("/InGame/ThroneRoom/Main/HeroDesc/HelpText/Main", KnightDesc)
		XGUIEng.SetText("/InGame/ThroneRoom/KnightInfo/Text", KnightDesc)
		XGUIEng.ShowWidget("/InGame/ThroneRoom/Main/TitleContainer", 1)
		XGUIEng.ShowWidget("/InGame/ThroneRoom/Main/DialogTopChooseKnight",0)

	end

end
---------------------------------------------------------------------------------------------------------------------------------
function HideKnightToolTip()

	XGUIEng.ShowWidget("/InGame/ThroneRoom/Main/TitleContainer", 0)

end
---------------------------------------------------------------------------------------------------------------------------------
function ShowKnightTitles()

    if g_Throneroom.Knight.SelectedEntityId ~= 0 then

        --reset previous knight titles
        HideKnightTitles()

        local EntityType = Logic.GetEntityType(g_Throneroom.Knight.SelectedEntityId)
	    local KnightTypeName = Logic.GetEntityTypeName(GetInGameKnightType(EntityType))

        if KnightTypeName == nil then
            return
        end

        local ThisKnightTitles = {}

        for i=1,#g_CampaignMaps do

            local MapName = string.lower(g_CampaignMaps[i])
            local Prestige

            --retreive titles from the current selected knight
            if Profile.PrestigeAndTitleExist(KnightTypeName, MapName) then
				Prestige, ThisKnightTitles[i] = Profile.GetPrestigeAndTitle(KnightTypeName, MapName)
			end
        end


     
        local count = 1     
        for j=1,#g_CampaignMaps do
            
            if ThisKnightTitles[j] ~= nil then                 
                local widget = "/InGame/ThroneRoom/KnightInfo/KnightTitles" .. "/" .. count
                count = count + 1
                
                XGUIEng.ShowWidget(widget, 1)
                SetIcon(widget .. "/Title", g_TexturePositions.KnightTitles[ThisKnightTitles[j]], 44 )

                local TitleName = GUI_Knight.GetTitleNameByTitleID(GetInGameKnightType(EntityType), ThisKnightTitles[j])
                local fulltitle =  TitleName .. " " .. XGUIEng.GetStringTableText("UI_Texts/KnightTitleOf") .. " " .. Tool_GetLocalizedMapName(g_CampaignMaps[j])

                XGUIEng.SetText(widget .. "/Text", fulltitle )                 
            end
        end

        XGUIEng.ShowWidget("/InGame/ThroneRoom/Main/HeroDesc/KnightTitles", 1)

    end
end

---------------------------------------------------------------------------------------------------------------------------------
function HideKnightTitles()

    for j=1,16 do
--        local widget = "/InGame/ThroneRoom/Main/HeroDesc/KnightTitles" .. "/" .. j
        local widget = "/InGame/ThroneRoom/KnightInfo/KnightTitles" .. "/" .. j
        XGUIEng.ShowWidget(widget, 0)
    end

    XGUIEng.ShowWidget("/InGame/ThroneRoom/Main/HeroDesc/KnightTitles", 0)
end


---------------------------------------------------------------------------------------------------------------------------------
function OnMouseOverKnightTitle()

    local ActualWidget = XGUIEng.GetCurrentWidgetID()


    --if XGUIEng.IsWidgetShown(ActualWidget) ~= 0 then
        local MotherWidgetName = XGUIEng.GetWidgetNameByID(XGUIEng.GetWidgetsMotherID(ActualWidget))


        local MapName = XGUIEng.GetStringTableText("Map_".. g_CampaignMaps[MotherWidgetName+0] .. "/MapName") -- +0 to convert from string to integer


        local KnightType = Logic.GetEntityType(g_Throneroom.Knight.SelectedEntityId)
	    local KnightTypeName = Logic.GetEntityTypeName(GetInGameKnightType(KnightType))

        local TitleName = ""

        local Map = string.lower(g_CampaignMaps[MotherWidgetName+0])
        if Profile.PrestigeAndTitleExist(KnightTypeName, Map) then

			local Prestige, TitleIndex = Profile.GetPrestigeAndTitle(KnightTypeName, Map)
            TitleName = GUI_Knight.GetTitleNameByTitleID(GetInGameKnightType(KnightType), TitleIndex)

		end

        XGUIEng.SetText("/InGame/ThroneRoom/Main/HeroDesc/HelpTextKnightTitle/KnightTitle", MapName .. " : " .. TitleName)
        XGUIEng.ShowWidget("/InGame/ThroneRoom/Main/HeroDesc/HelpTextKnightTitle/KnightTitle",1)
        XGUIEng.SetText("/InGame/ThroneRoom/KnightInfo/HelpTextKnightTitle/KnightTitle", MapName .. " : " .. TitleName)
        XGUIEng.ShowWidget("/InGame/ThroneRoom/KnightInfo/HelpTextKnightTitle/KnightTitle",1)
   -- end

end
---------------------------------------------------------------------------------------------------------------------------------
function OnMouseOutKnightTitle()
    XGUIEng.SetText("/InGame/ThroneRoom/Main/HeroDesc/HelpTextKnightTitle/KnightTitle", " ")
    XGUIEng.ShowWidget("/InGame/ThroneRoom/Main/HeroDesc/HelpTextKnightTitle/KnightTitle",0)
    XGUIEng.SetText("/InGame/ThroneRoom/KnightInfo/HelpTextKnightTitle/KnightTitle", " ")
    XGUIEng.ShowWidget("/InGame/ThroneRoom/KnightInfo/HelpTextKnightTitle/KnightTitle",0)

end
---------------------------------------------------------------------------------------------------------------------------------
function GetInGameKnightType( _KnightEntityTypeStanding )

    return g_KnightTypes[_KnightEntityTypeStanding]

end
---------------------------------------------------------------------------------------------------------------------------------
function ComputeDistance(EntityID)

   local entityX,entityY = GUI.GetEntityInfoScreenPosition(EntityID)

   local mouseX,mouseY = GUI.GetMousePosition()

   return ABS(mouseX - entityX)

end
---------------------------------------------------------------------------------------------------------------------------------
function CheckMouseOverStatus()

	if g_Throneroom.CutScene.IsRunning == 1 then

		return

	end

	local mouseX,mouseY = GUI.GetMousePosition()

	local screenX, screenY = XGUIEng.GetWidgetScreenSize("/InGame/ThroneRoom")

	if mouseY <= screenY * 0.35 then

		g_Throneroom.Knight.HoverIndex = 0

		g_Throneroom.Knight.HoverEntityId = 0

    	return

	end

	if mouseY > screenY * 0.75 then

		g_Throneroom.Knight.HoverIndex = 0

		g_Throneroom.Knight.HoverEntityId = 0

    	return

	end

	local KnightList = {}

	local name = ""

	local knightIndex = 0

	for i = 0, 5 do

		name = "k"..tostring(i +1)

		if not Logic.IsEntityDestroyed(name) then

			local knight = Logic.GetEntityIDByName(name)

			KnightList[knightIndex] = knight

			knightIndex = knightIndex +1

		end

	end

	local bestDistance = 1500 -- default distance!
	local bestKnight = -1

	for i = 0, #KnightList do

		local entityId = KnightList[i]

		local distance = ComputeDistance(entityId)

		if distance < bestDistance or bestDistance == -1 then

			bestKnight = entityId

			bestDistance = distance

		end

	end

	local KnightIndex = tonumber(GetKnightIndex(bestKnight))

	if(KnightIndex ~= 0) then

		g_Throneroom.Knight.HoverIndex = KnightIndex

		g_Throneroom.Knight.HoverEntityId = bestKnight

	else

		g_Throneroom.Knight.HoverIndex = 0

		g_Throneroom.Knight.HoverEntityId = 0

		XGUIEng.ShowWidget("/InGame/ThroneRoom/Main/TitleContainer",0)

	end

end
---------------------------------------------------------------------------------------------------------------------------------
function KnightResponse()

	local EntityType = Logic.GetEntityType(g_Throneroom.Knight.SelectedEntityId)

    if EntityType == 0 then
        return
    end

    local TextKey
    local StringTable

	if g_KnightResponses[EntityType] > 0 then

		local responses = { "GenericResponse01","GenericResponse02","GenericResponse03" }

		local InGameKnightTypeName = Logic.GetEntityTypeName( GetInGameKnightType( EntityType ) )
        local InGameKnightName = string.gsub(InGameKnightTypeName, "U_", "")

		StringTable = "Generic_" .. InGameKnightName .. "_speech"
		TextKey = responses[math.random(#responses)] .. "_" .. InGameKnightName

    else

        if g_Throneroom.Responses ~= nil then

    		for i = 1, #g_Throneroom.Responses do

    		    if EntityType == g_Throneroom.Responses[i][1] then

    		        StringTable = "Map_" .. Framework.GetCurrentMapName() .. "_speech"
    		        TextKey = g_Throneroom.Responses[i][2]

    	    	end

    	    end

        end

	end

	g_KnightResponses[EntityType] = g_KnightResponses[EntityType] +1

    if TextKey ~= nil then


        --start voice and animation

        GUI.SendScriptCommand("SetAnimation(" .. EntityType .. ",'" .. TextKey .. "', '" .. StringTable .. "')",true)

        --set text in interface
        SetText( TextKey , StringTable)
    end

end
---------------------------------------------------------------------------------------------------------------------------------
function ThroneRoomSelectKnight(index,entity)

	g_Throneroom.Knight.SelectedIndex = index

	g_Throneroom.Knight.SelectedEntityId = entity

	g_Throneroom.Knight.HoverIndex = index

	g_Throneroom.Knight.HoverEntityId = entity

    KnightResponse()

	UpdateButtonStates()

	GUI.SendScriptCommand("AddKnightCursor("..g_Throneroom.Knight.SelectedEntityId..")",true)

    ShowKnightToolTip()

    ShowKnightTitles()

end
---------------------------------------------------------------------------------------------------------------------------------
function ThroneRoomLeftClick()

	if g_Throneroom.CutScene.IsRunning == 1 then

		return

	end

	CheckMouseOverStatus()

	if g_Throneroom.Knight.HoverEntityId ~= 0 then

		if g_Throneroom.Knight.HoverEntityId == g_Throneroom.Knight.SelectedEntityId then

			return

		end

		if g_Throneroom.Knight.SelectedIndex ~= 0 then

			local EntityType = Logic.GetEntityType(g_Throneroom.Knight.SelectedEntityId)

			local animation = g_KnightIdles[EntityType]

			GUI.SendScriptCommand("PlayAnimation("..EntityType..",'Idle01','"..animation.."')",true)

		end

		ThroneRoomSelectKnight(g_Throneroom.Knight.HoverIndex,g_Throneroom.Knight.HoverEntityId)

		--	deploy start button

		--	local screenX, screenY = XGUIEng.GetWidgetScreenSize("/InGame/ThroneRoom")

		--	local entityX,entityY = GUI.GetEntityInfoScreenPosition(g_Throneroom.Knight.SelectedEntityId)

		--	local widgetWidth,widgetHeight = XGUIEng.GetWidgetSize(SelectionWidget)

		--	XGUIEng.SetWidgetScreenPosition(g_Throneroom.Widget.Start,entityX -widgetWidth /4,screenY * 0.2)

	end

    ShowKnightToolTip()

    ShowKnightTitles()

end
---------------------------------------------------------------------------------------------------------------------------------
function CheckSelectionStatus()

	if g_Throneroom.Campaign.IsOpen == 1 then

		return

	end

	if g_Throneroom.CutScene.IsRunning == 1 then

		return

	end

	if(g_Throneroom.Knight.SelectedIndex ~= 0) then

	    local EntityType = Logic.GetEntityType(g_Throneroom.Knight.SelectedEntityId)

	    local EntityTypeName = Logic.GetEntityTypeName(GetInGameKnightType(EntityType))

	    local KnightName = XGUIEng.GetStringTableText("Names/" .. EntityTypeName)

	    if KnightName == "" then

	        KnightName = EntityTypeName

	    end

		XGUIEng.SetText(SelectionWidget,"{center}" .. KnightName)

	end

	CheckMouseOverStatus()

end
---------------------------------------------------------------------------------------------------------------------------------
function OnSkipButtonPressed()

	if g_Throneroom.CutScene.IsRunning == 1 then
       	FadeOut(0.5,EndCutscene)
	end
end
---------------------------------------------------------------------------------------------------------------------------------
function OnStartButtonPressed()

    if Framework.BeforeStartMap() == false then
        OpenRequesterDialog(XGUIEng.GetStringTableText("UI_Texts/NoValidCDFound"), "", "OnStartButtonPressed()", 1)
        return
    end

    Input.NoneMode()
    XGUIEng.DisableButton(g_Throneroom.Widget.Start, 1);
	FadeOut(0.5,ThroneRoomStartGameFadeIn)

end










function LMS_SetOrRestore3DPortrait(_Widget, _Actor)
    local Widget = _Widget

    Actor = GetKnightActor(_Actor)
    SetPortraitWithCameraSettings(Widget, Actor)
    GUI.PortraitWidgetPlayAnimation(Widget, "Idle01", "Idle") -- widgetname, animation, animation group (Idle or LipSync, case sensitive !!!)
end


function Start3DPortraitVoice(_IngameKnightType)

    g_Throneroom.PortraitWidget = "/InGame/ThroneRoom/KnightInfo/LeftFrame/Portrait"

    local KnightTypeName = string.gsub(Logic.GetEntityTypeName(_IngameKnightType), "U_", "")

    local TextPermanentAbility = "Generic_" .. KnightTypeName .. "_speech_Hint_SpecialAbilityPermanetly"
    local TextActionAbility = "Generic_" .. KnightTypeName .. "_speech_Hint_SpecialAbilityAction"

    g_Throneroom.SelectedKnightPermanetAbilityText = TextPermanentAbility
    g_Throneroom.SelectedKnightActionAbilityText = TextActionAbility

    local FaceAnimation = string.lower(g_Throneroom.SelectedKnightPermanetAbilityText)

    local Duration  = GUI.PortraitWidgetPlayAnimation(g_Throneroom.PortraitWidget, FaceAnimation, "LipSync")

    g_Throneroom.PortraitNextSpeechStartTime = Logic.GetTime() + Duration  + 1

    g_Throneroom.StartSpeechJob = StartSimpleJob("StartPortraitSpeechAfterSomeSeconds")

end


function StartPortraitSpeechAfterSomeSeconds()

    if Logic.GetTime() >= g_Throneroom.PortraitNextSpeechStartTime then
        local FaceAnimation = string.lower(g_Throneroom.SelectedKnightActionAbilityText)
        GUI.PortraitWidgetPlayAnimation(g_Throneroom.PortraitWidget, FaceAnimation, "LipSync")
        return true
    end

end



local firstcallOnKnightInfoPressed

function OnKnightInfoPressed()

	Sound.StopVoice("ImportantStuff")

	local EntityType = Logic.GetEntityType(g_Throneroom.Knight.SelectedEntityId)

	if EntityType == 0 then
	    return
	end

	local IngameKnightType = GetInGameKnightType(EntityType)

	LMS_SetOrRestore3DPortrait("/InGame/ThroneRoom/KnightInfo/LeftFrame/Portrait", IngameKnightType)

	if XGUIEng.IsWidgetShown("/InGame/ThroneRoom/KnightInfo") ~= 0 then
		XGUIEng.ShowWidget("/InGame/ThroneRoom/KnightInfo",0)
		EndJob(g_Throneroom.StartSpeechJob)
	else
		XGUIEng.ShowWidget("/InGame/ThroneRoom/KnightInfo",1)
		XGUIEng.PushPage("/InGame/ThroneRoom/KnightInfo", false)
		Start3DPortraitVoice(IngameKnightType)
	end
end


---------------------------------------------------------------------------------------------------------------------------------
function ThroneRoomStartGameFadeIn()

    --show 3dOnScreenDisplay after exiting throneroom
    XGUIEng.ShowWidget("/InGame/Root/3dOnScreenDisplay", 1)

	CloseThroneRoom()

	g_Camera.FadeInOffset = -1

	GUI.PermitContextSensitiveCommandsInSelectionState()

	GUI.ClearSelection()

	XGUIEng.PopPage()

	Display.SetRenderTerrain(1)

	local EntityType = Logic.GetEntityType(g_Throneroom.Knight.SelectedEntityId)

	g_Throneroom.IngameKnightType = GetInGameKnightType(EntityType)

	local KnightID = 1
	if      g_Throneroom.IngameKnightType == Entities.U_KnightHealing then  KnightID = 2
	elseif  g_Throneroom.IngameKnightType == Entities.U_KnightChivalry then KnightID = 3
	elseif  g_Throneroom.IngameKnightType == Entities.U_KnightWisdom then   KnightID = 4
	elseif  g_Throneroom.IngameKnightType == Entities.U_KnightPlunder then  KnightID = 5
	elseif  g_Throneroom.IngameKnightType == Entities.U_KnightSong then	    KnightID = 6
    end

    Framework.SetLoadScreenNeedButton(1)
	Framework.ResetProgressBar()
	InitLoadScreen(false, -1, Framework.GetCurrentMapName(), Framework.GetCampaignName(), KnightID)

	InitializeFader()
	FadeIn(1, ThroneRoomStartGame)
end
---------------------------------------------------------------------------------------------------------------------------------
function ThroneRoomStartGame()
	Framework.CloseKnightChoiceAndStartMission(g_Throneroom.IngameKnightType)
end
---------------------------------------------------------------------------------------------------------------------------------
function OnBackButtonPressed()

	GUI.PermitContextSensitiveCommandsInSelectionState()

	Profile.SetInteger("Profile", "Campaign", 1)

	Framework.SetCampaignMode(1)--return to campaign map

	Framework.CloseGame()

	CloseThroneRoom()

end
---------------------------------------------------------------------------------------------------------------------------------
function OnBriefingButtonPressed()

	if g_Throneroom.CutScene.IsRunning == 1 then

		return
		
	end 
	
	Sound.StopVoice("ImportantStuff")
	
    FadeOut(0.5,StartCutScene)	
	
end
---------------------------------------------------------------------------------------------------------------------------------
function EnableAllButtons(flag)

	local state = 1

	if flag == 1 then

		state = 0
	else
	end



	XGUIEng.DisableButton("/InGame/ThroneRoom/Main/StartButton",state)
	--XGUIEng.DisableButton("/InGame/ThroneRoom/Main/Campaign",state)
	XGUIEng.DisableButton("/InGame/ThroneRoom/Main/Briefing",state)
	XGUIEng.DisableButton("/InGame/ThroneRoom/Main/BackButton",state)
	XGUIEng.DisableButton("/InGame/ThroneRoom/Main/Skip",state)

	XGUIEng.ShowWidget("/InGame/ThroneRoom/Main/StartButton", flag)
	--XGUIEng.ShowWidget("/InGame/ThroneRoom/Main/Campaign", flag)
	XGUIEng.ShowWidget("/InGame/ThroneRoom/Main/Briefing", flag)
	XGUIEng.ShowWidget("/InGame/ThroneRoom/Main/BackButton", flag)
	XGUIEng.ShowWidget("/InGame/ThroneRoom/Main/Skip", flag)

end
---------------------------------------------------------------------------------------------------------------------------------
function EnableCampaignButton(button,flag)

	local state = 1

	if flag == 1 then

		state = 0

	end

	XGUIEng.DisableButton(button,state)

	XGUIEng.ShowWidget(button,flag)

end
---------------------------------------------------------------------------------------------------------------------------------
function UpdateButtonStates()

	EnableAllButtons(0)

	if g_Throneroom.Campaign.IsOpen == 1 then

		--EnableCampaignButton(g_Throneroom.Widget.Campaign,1)

		return

	end

	EnableCampaignButton(g_Throneroom.Widget.Back,1)

	if(g_Throneroom.Knight.SelectedIndex ~= 0) then

		EnableCampaignButton(g_Throneroom.Widget.Start,1)

	end

	if g_Throneroom.CutScene.IsRunning == 0 then
		Show3Buttons()
		EnableCampaignButton("/InGame/ThroneRoom/Main/Briefing",1)

		--EnableCampaignButton(g_Throneroom.Widget.Campaign,1)

	else
		Show2Buttons()
		EnableCampaignButton(g_Throneroom.Widget.Skip,1)

	end

end
---------------------------------------------------------------------------------------------------------------------------------
function OnCampaignButtonPressed()

	if g_Throneroom.Campaign.IsOpen == 1 then

		OnCloseMapPressed()

	else

		g_Throneroom.Campaign.IsOpen = 1

		SetCampaignMap("/InGame/ThroneRoom/Main/Map/BG")

		XGUIEng.ShowWidget(MapWidget,1)
		--XGUIEng.ShowWidget("/InGame/ThroneRoom/Main/Map/BG", 0)

	end

	UpdateButtonStates()

end
---------------------------------------------------------------------------------------------------------------------------------
function OnCloseMapPressed()

	g_Throneroom.Campaign.IsOpen = 0

	XGUIEng.DisableButton(g_Throneroom.Widget.Start,0)

	XGUIEng.DisableButton("/InGame/ThroneRoom/Main/BackButton",0)

	XGUIEng.ShowWidget(MapWidget,0)

end
---------------------------------------------------------------------------------------------------------------------------------
function SetCampaignMap(widget)

	local map = Framework.GetHighestCampaignMap()

	local campaign = Framework.GetCampaignName()

	local filename = "campaign\\"..campaign.."\\"..map..".dds"

    XGUIEng.SetMaterialTexture(widget,0,filename)

end
---------------------------------------------------------------------------------------------------------------------------------
function ShowLeft()

	g_Throneroom.Camera.TargetYaw = g_Throneroom.Camera.YawBase -20

	g_Throneroom.Camera.TargetPitch = g_Throneroom.Camera.BasePitch

	g_Throneroom.Camera.TargetX = g_Throneroom.Camera.BaseX
	g_Throneroom.Camera.TargetY = g_Throneroom.Camera.BaseY
	g_Throneroom.Camera.TargetZ = g_Throneroom.Camera.BaseZ

end
---------------------------------------------------------------------------------------------------------------------------------
function ShowRight()

	g_Throneroom.Camera.TargetYaw = g_Throneroom.Camera.YawBase +20

	g_Throneroom.Camera.TargetPitch = g_Throneroom.Camera.BasePitch

	g_Throneroom.Camera.TargetX = g_Throneroom.Camera.BaseX
	g_Throneroom.Camera.TargetY = g_Throneroom.Camera.BaseY
	g_Throneroom.Camera.TargetZ = g_Throneroom.Camera.BaseZ

end
---------------------------------------------------------------------------------------------------------------------------------
function UnmarkAll()

	GUI.SendScriptCommand("DestroySelection()",true)

end
---------------------------------------------------------------------------------------------------------------------------------
function MarkPosition(x,y)

	if y == nil then

		local commando = "AddSelection('"..x.."')"

		GUI.SendScriptCommand(commando,true)

	else

		GUI.SendScriptCommand("AddSelection("..x..","..y..")",true)

	end

end
---------------------------------------------------------------------------------------------------------------------------------
function UnmarkPosition(x,y)

	if y == nil then

		GUI.SendScriptCommand("RemoveSelection('"..x.."')",true)

	else

		GUI.SendScriptCommand("RemoveSelection("..x..","..y..")",true)

	end

end

---------------------------------------------------------------------------------------------------------------------------------
function SetFirstKnightToSelect(_KnightType)

	if g_Throneroom.Knight.FirstKnight == 0 then

		g_Throneroom.Knight.FirstKnight = _KnightType

	end

end
---------------------------------------------------------------------------------------------------------------------------------
function StartVoiceAndAnimation( _Textkey, _KnightType )

    local StringTable = "Map_" .. Framework.GetCurrentMapName() .. "_speech"

	if g_Throneroom.Knight.FirstKnight == 0 then

		g_Throneroom.Knight.FirstKnight = _KnightType

	end

    local duration = Display.GetFaceFxDuration(_KnightType,"LipSync",StringTable .. "_" .. _Textkey)

    if duration ~= -1 then

        g_Throneroom.CutScene.Program[g_Throneroom.CutScene.PC][1] = math.ceil(duration)

    end

    --just to be sure:
    _Textkey = string.lower(_Textkey)

    GUI.SendScriptCommand("SetAnimation(" .. _KnightType .. ",'" .. _Textkey .. "')",true)

    --get table from map and set text

    SetText( _Textkey, StringTable)

end

---------------------------------------------------------------------------------------------------------------------------------
function SetText( _Textkey, _StringTable)

    local MessageText = XGUIEng.GetStringTableText(_StringTable .. "/" .. _Textkey)

    if MessageText == "" then
        MessageText = _Textkey .. " (key ?)"
    end

    XGUIEng.SetText("/InGame/ThroneRoom/Main/MissionBriefing/Text", MessageText)
end
---------------------------------------------------------------------------------------------------------------------------------
function ShowCenter()

	g_Throneroom.Camera.TargetYaw = g_Throneroom.Camera.YawBase +0

	g_Throneroom.Camera.TargetPitch = g_Throneroom.Camera.BasePitch

	g_Throneroom.Camera.TargetX = g_Throneroom.Camera.BaseX
	g_Throneroom.Camera.TargetY = g_Throneroom.Camera.BaseY
	g_Throneroom.Camera.TargetZ = g_Throneroom.Camera.BaseZ

end
---------------------------------------------------------------------------------------------------------------------------------
large = 0
small = 1
function SetBarType(type) -- 0=large,1=small

	HideKnightToolTip()
	HideKnightTitles()

	if type == small then

		XGUIEng.ShowWidget(g_Throneroom.CutScene.Bars1,0)
		XGUIEng.ShowWidget(g_Throneroom.CutScene.Bars2,1)
		XGUIEng.ShowWidget("/InGame/ThroneRoomBars_Dodge",0)
		XGUIEng.ShowWidget("/InGame/ThroneRoomBars_2_Dodge",1)

	else

		XGUIEng.ShowWidget(g_Throneroom.CutScene.Bars1,1)
		XGUIEng.ShowWidget(g_Throneroom.CutScene.Bars2,1)
		XGUIEng.ShowWidget("/InGame/ThroneRoomBars_Dodge",1)
		XGUIEng.ShowWidget("/InGame/ThroneRoomBars_2_Dodge",0)


	end

end
---------------------------------------------------------------------------------------------------------------------------------
function ShowTable(size)

	SetBarType(small)

	local mapX,mapY = Logic.GetEntityPosition(g_Throneroom.CenterEntity)

	g_Throneroom.Camera.TimeStamp = Framework.TimeGetTime()

	g_Throneroom.Camera.Duration = 2

    if size == 640 then

    	g_Throneroom.Camera.TargetX = mapX - 55
    	g_Throneroom.Camera.TargetY = mapY
    	g_Throneroom.Camera.TargetZ = g_Throneroom.Camera.BaseZ + 47

    	g_Throneroom.Camera.LookAtX = mapX -10
    	g_Throneroom.Camera.LookAtY = mapY
    	g_Throneroom.Camera.LookAtZ = g_Throneroom.Camera.BaseZ - 50

    	g_Throneroom.Camera.FoV = 70
    	g_Throneroom.Camera.StartFoV = 75
    	g_Throneroom.Camera.TargetFoV = 70

    end

    if size == 704 then

    	g_Throneroom.Camera.TargetX = mapX - 60
    	g_Throneroom.Camera.TargetY = mapY
    	g_Throneroom.Camera.TargetZ = g_Throneroom.Camera.BaseZ + 50

    	g_Throneroom.Camera.LookAtX = mapX -12
    	g_Throneroom.Camera.LookAtY = mapY
    	g_Throneroom.Camera.LookAtZ = g_Throneroom.Camera.BaseZ - 50

    	g_Throneroom.Camera.FoV = 70
    	g_Throneroom.Camera.StartFoV = 75
    	g_Throneroom.Camera.TargetFoV = 70

    end

    if size == 768 then

    	g_Throneroom.Camera.TargetX = mapX - 68
    	g_Throneroom.Camera.TargetY = mapY
    	g_Throneroom.Camera.TargetZ = g_Throneroom.Camera.BaseZ + 55

    	g_Throneroom.Camera.LookAtX = mapX -12
    	g_Throneroom.Camera.LookAtY = mapY
    	g_Throneroom.Camera.LookAtZ = g_Throneroom.Camera.BaseZ - 50

    	g_Throneroom.Camera.FoV = 70
    	g_Throneroom.Camera.StartFoV = 75
    	g_Throneroom.Camera.TargetFoV = 70

    end

    if size == 960 then

    	g_Throneroom.Camera.TargetX = mapX - 85
    	g_Throneroom.Camera.TargetY = mapY
    	g_Throneroom.Camera.TargetZ = g_Throneroom.Camera.BaseZ + 70

    	g_Throneroom.Camera.LookAtX = mapX -14
    	g_Throneroom.Camera.LookAtY = mapY
    	g_Throneroom.Camera.LookAtZ = g_Throneroom.Camera.BaseZ - 50

    	g_Throneroom.Camera.FoV = 70
    	g_Throneroom.Camera.StartFoV = 75
    	g_Throneroom.Camera.TargetFoV = 70

    end


    SetCamera(g_Throneroom.Camera.TargetX,g_Throneroom.Camera.TargetY,g_Throneroom.Camera.TargetZ,g_Throneroom.Camera.LookAtX,g_Throneroom.Camera.LookAtY,g_Throneroom.Camera.LookAtZ,g_Throneroom.Camera.TargetFoV)

end
---------------------------------------------------------------------------------------------------------------------------------
function ConvertTypeToId(knight)

	local result = -1

	for i = 0, 5 do

		name = "k"..tostring(i +1)

		if not Logic.IsEntityDestroyed(name) then

			local knightId = Logic.GetEntityIDByName(name)

			local knightType = Logic.GetEntityType(knightId)

			if knightType == knight then

				result = knightId

				return result

			end

		end

	end

	return result

end
---------------------------------------------------------------------------------------------------------------------------------
function SetCamera(x,y,z,xat,yat,zat,fov)

	g_Throneroom.Camera.FoV = fov

	g_Throneroom.Camera.StartFov = fov
	g_Throneroom.Camera.TargetFov = fov
	g_Throneroom.Camera.CurrentFov = fov

	g_Throneroom.Camera.LookAtX = xat
	g_Throneroom.Camera.LookAtY = yat
	g_Throneroom.Camera.LookAtZ = zat

	g_Throneroom.Camera.CurrentX = x
	g_Throneroom.Camera.CurrentY = y
	g_Throneroom.Camera.CurrentZ = z

	g_Throneroom.Camera.StartX = x
	g_Throneroom.Camera.StartY = y
	g_Throneroom.Camera.StartZ = z

	g_Throneroom.Camera.TargetX = x
	g_Throneroom.Camera.TargetY = y
	g_Throneroom.Camera.TargetZ = z

end
---------------------------------------------------------------------------------------------------------------------------------
function SetCameraTarget(x,y,z)

	g_Throneroom.Camera.TargetX = x
	g_Throneroom.Camera.TargetY = y
	g_Throneroom.Camera.TargetZ = z

end
---------------------------------------------------------------------------------------------------------------------------------
function ExtremeCloseUpAtKnight(knight)

	local result = ConvertTypeToId(knight)

	if result == -1 then

		return

	end

	g_Throneroom.Camera.Duration = 0

	local mapX,mapY = Logic.GetEntityPosition(result)

	SetCamera(g_Throneroom.Camera.BaseX,g_Throneroom.Camera.BaseY,g_Throneroom.Camera.BaseZ,mapX,mapY,g_Throneroom.Camera.BaseZ +g_KnightEyes[knight],2)

end
---------------------------------------------------------------------------------------------------------------------------------
function CloseUpAtKnight(knight)

	local result = ConvertTypeToId(knight)

	if result == -1 then

		return

	end

	g_Throneroom.Camera.Duration = 0

	local mapX,mapY = Logic.GetEntityPosition(result)

	SetCamera(g_Throneroom.Camera.BaseX,g_Throneroom.Camera.BaseY,g_Throneroom.Camera.BaseZ +g_KnightEyes[knight],mapX,mapY,g_Throneroom.Camera.BaseZ +g_KnightEyes[knight],8)

end
---------------------------------------------------------------------------------------------------------------------------------
function DollyShotAtKnight(knight)

	local result = ConvertTypeToId(knight)

	if result == -1 then

		return

	end

	local mapX,mapY = Logic.GetEntityPosition(result)

	g_Throneroom.Camera.Duration = 5.0

	g_Throneroom.Camera.TimeStamp = Framework.TimeGetTime()

	SetCamera(mapX -340,mapY +120,g_Throneroom.Camera.BaseZ +g_KnightEyes[knight],mapX,mapY,g_Throneroom.Camera.BaseZ +g_KnightEyes[knight],20)

	SetCameraTarget(mapX +240,mapY +120,g_Throneroom.Camera.BaseZ +g_KnightEyes[knight])

end
---------------------------------------------------------------------------------------------------------------------------------
function VertigoEffectAtKnight(duration,knight)

	local result = ConvertTypeToId(knight)

	if result == -1 then

		return

	end

	local mapX,mapY = Logic.GetEntityPosition(result)

	local camX = g_Throneroom.Camera.CurrentX
	local camY = g_Throneroom.Camera.CurrentY

--	camX = camX + (camX - mapX) *.01
--	camY = camY + (camY - mapY) *.01

	mapX = mapX + (camX - mapX) *0.214
	mapY = mapY + (camY - mapY) *0.214

	g_Throneroom.Camera.Duration = duration

	g_Throneroom.Camera.TimeStamp = Framework.TimeGetTime()

	SetCamera(camX,camY,g_Throneroom.Camera.BaseZ +g_KnightEyes[knight],mapX,mapY,g_Throneroom.Camera.BaseZ +g_KnightEyes[knight],20)

	SetCameraTarget(mapX,mapY,g_Throneroom.Camera.BaseZ +g_KnightEyes[knight])

	g_Throneroom.Camera.StartFov = 20

	g_Throneroom.Camera.TargetFov = 120

end
---------------------------------------------------------------------------------------------------------------------------------
function MediumShotAtKnight(knight)

	local result = ConvertTypeToId(knight)

	if result == -1 then

		return

	end

	g_Throneroom.Camera.Duration = 0

	local mapX,mapY = Logic.GetEntityPosition(result)

	SetCamera(g_Throneroom.Camera.BaseX,g_Throneroom.Camera.BaseY,g_Throneroom.Camera.BaseZ,mapX,mapY,g_Throneroom.Camera.BaseZ +0,35)

end
---------------------------------------------------------------------------------------------------------------------------------
function LookAtKnight(knight,fov)

	local result = ConvertTypeToId(knight)

	if result == -1 then

		return

	end

	g_Throneroom.Camera.Duration = 0

	local mapX,mapY = Logic.GetEntityPosition(result)

	SetCamera(g_Throneroom.Camera.BaseX,g_Throneroom.Camera.BaseY,g_Throneroom.Camera.BaseZ,mapX,mapY,g_Throneroom.Camera.BaseZ +0,fov)

end
---------------------------------------------------------------------------------------------------------------------------------
function ShowKnight(knight)

	g_Throneroom.Camera.Duration = 0

	g_Throneroom.Camera.TargetYaw = g_Throneroom.Camera.YawBase +g_KnightYaws[knight]

	g_Throneroom.Camera.TargetPitch = g_Throneroom.Camera.BasePitch

	g_Throneroom.Camera.TargetX = g_Throneroom.Camera.BaseX
	g_Throneroom.Camera.TargetY = g_Throneroom.Camera.BaseY
	g_Throneroom.Camera.TargetZ = g_Throneroom.Camera.BaseZ

end
---------------------------------------------------------------------------------------------------------------------------------
function StartCutScene()

	Sound.StopVoice(g_VoiceId)
    
    XGUIEng.SetText("/InGame/ThroneRoom/Main/MissionBriefing/Text", " ")
    
    ThroneRoomSelectKnight(0,0)

	SetBarType(large)

    --InitializeFader()
	FadeIn(5)

	GUI.SendScriptCommand("StopAllAnimations()",true)

	ShowCenter()

	g_Throneroom.CutScene.Counter = 0

	g_Throneroom.CutScene.IsRunning = 1

	g_Throneroom.CutScene.JobId = StartSimpleJob("Cutscene")

	UpdateButtonStates()

    HideNameAndBriefingText()
    HideKnightToolTip()
    HideKnightTitles()

    XGUIEng.ShowWidget("/InGame/ThroneRoom/Main/DialogTopChooseKnight",0)

	XGUIEng.ShowWidget("/InGame/ThroneRoom/Main/DialogBottomRight3pcs", 0)
	XGUIEng.ShowWidget("/InGame/ThroneRoom/Main/KnightInfoButton", 0)
	XGUIEng.ShowWidget("/InGame/ThroneRoom/Main/Briefing", 0)
	XGUIEng.ShowWidget("/InGame/ThroneRoom/Main/BackButton", 0)


end
---------------------------------------------------------------------------------------------------------------------------------
function EndCutscene()

	XGUIEng.ShowWidget("/InGame/ThroneRoom/Main/DialogBottomRight3pcs", 1)
	XGUIEng.ShowWidget("/InGame/ThroneRoom/Main/KnightInfoButton", 1)
	XGUIEng.ShowWidget("/InGame/ThroneRoom/Main/Briefing", 1)
	XGUIEng.ShowWidget("/InGame/ThroneRoom/Main/BackButton", 1)


    SetBarType(large)

    GUI.SendScriptCommand("StopAllAnimations()",true)

    ResetThroneRoomCamera()

    ShowCenter()

    EndJob(g_Throneroom.CutScene.JobId)

    g_Throneroom.CutScene.IsRunning = 0

    UnmarkAll()

    UpdateButtonStates()

    --InitializeFader()
    FadeIn(2)

	XGUIEng.ShowWidget("/InGame/ThroneRoom/Main/DialogTopChooseKnight",1)
	XGUIEng.ShowWidget("/InGame/ThroneRoom/Main/TitleContainer",0)

	SetNameAndBriefingText()
	XGUIEng.SetText("/InGame/ThroneRoom/Main/MissionBriefing/Text", " ")

	if g_Throneroom.Knight.FirstKnight ~= 0 and g_Throneroom.Knight.SelectedEntityId == 0 then

		local Amount, ID = Logic.GetPlayerEntities(1,g_Throneroom.Knight.FirstKnight,1,0)

		ThroneRoomSelectKnight(tonumber(GetKnightIndex(ID)),ID)

	end

end
---------------------------------------------------------------------------------------------------------------------------------
function Briefing()

	for i = 1, #g_Throneroom.CutScene.Briefing do

		local commando = g_Throneroom.CutScene.Briefing[i]

		GUI.SendScriptCommand(commando,true)

	end

end
---------------------------------------------------------------------------------------------------------------------------------
function GetCutSceneDelay() -- time to wait before starting the real cutscene
    return 4
end
---------------------------------------------------------------------------------------------------------------------------------
function Idle()
--do not delete
end

---------------------------------------------------------------------------------------------------------------------------------
function Cutscene()

	EnableCampaignButton(g_Throneroom.Widget.Start,0)

	local timer = 0

	for i = 1, #g_Throneroom.CutScene.Program do

		g_Throneroom.CutScene.PC = i

		timer = timer + g_Throneroom.CutScene.Program[i][1]

		if g_Throneroom.CutScene.Counter == timer - g_Throneroom.CutScene.Program[i][1] then

			g_Throneroom.CutScene.Program[i][2](g_Throneroom.CutScene.Program[i][3],g_Throneroom.CutScene.Program[i][4])

		end


	end

	if g_Throneroom.Campaign.IsOpen == 0 then

		g_Throneroom.CutScene.Counter = g_Throneroom.CutScene.Counter +1

	end

end

--D_X_CampaignMap_E_House
--D_X_CampaignMap_E_Selection
--D_X_CampaignMap01





-- EGUIX::CVideoPlayBackCustomWidget
-- XGUIENG.StartVideoPlayback
