CampaignDialog.SelectedMapName = ""
----------------------------------------------------------------------------------------------------------------------
local OldOpenCampaignMap = OpenCampaignMap
function OpenCampaignMap()
    CampaignDialog.SelectedMapName = ""
    OldOpenCampaignMap()
end 
----------------------------------------------------------------------------------------------------------------------
function CampaignDialog_BackOnLeftClick()
	CloseCampaignMap()
	XGUIEng.ShowAllSubWidgets("/InGame/Singleplayer",0)
	
    XGUIEng.ShowWidget("/InGame/Singleplayer/ContainerBottom",1)
    XGUIEng.ShowWidget("/InGame/Singleplayer/CampaignMenu",1)
    
    DisplayLoadBottomButtons("/InGame/Singleplayer/ContainerBottom/BackCampaignMenu")

	XGUIEng.DisableButton("/InGame/Singleplayer/CampaignMenu/PlayCPCampaign",1)
end
----------------------------------------------------------------------------------------------------------------------
function CampaignMap_StartMission(_map)
    local trueMapId = _map;
    local campName = Framework.GetCampaignName()
    if campName == "c01" then
        trueMapId = trueMapId + CampaignData["c00"].NumberOfMaps
    elseif campName == "c02" then
        trueMapId = trueMapId + CampaignData["c00"].NumberOfMaps + CampaignData["c01"].NumberOfMaps
    end  
    
    --Workaround, um alle Missionen starten zu können
    local Maps = CreateMapTable(-1, campName)
    CampaignDialog.SelectedMapName = Maps[1+_map]

    --assert(Framework.GetCampaignName() == "c01", "Value: " .. _map + mapId)
    --
    CampaignDialog.Starting = true
    Input.NoneMode()
    Framework.SetCampaignMap(trueMapId)
    
    g_MainMenu.CampaignStateSequence = 1
    g_MainMenu.VideoTimer = 0
        
	InitializeFader()
	FadeOut(1, CampaignMap_FadeInCallback)
    --
    --XGUIEng.SetText("/InGame/Singleplayer/Campaign/Tooltip/Text", "{center}" .. table.getn(CreateMapTable(-1, Framework.GetCampaignName()))
end
----------------------------------------------------------------------------------------------------------------------
function CampaignMap_FadeInCallback()
    CloseCampaignMap()
    
	XGUIEng.ShowAllSubWidgets("/InGame",0)

	Framework.ResetProgressBar()
	InitLoadScreen(true, -1, CampaignDialog.SelectedMapName, Framework.GetCampaignName(), 1)

	InitializeFader()
	FadeIn(1,CampaignMap_StartMapCallback)	
end
----------------------------------------------------------------------------------------------------------------------
function CampaignMap_StartMapCallback()

    local CampaignName = Framework.GetCampaignName()
    --local CampaignMap  = Framework.GetCampaignMap()

    if false and CampaignName == "c01" then
        Framework.StartMap(CampaignDialog.SelectedMapName, -1, CampaignName ) --  -1 = Campaign!
    else
        Framework.StartMapWithKnightChoice(CampaignDialog.SelectedMapName, -1, CampaignName ) --  -1 = Campaign!
    end
	
	--InitLoadScreen(true, -1, CampaignDialog.SelectedMapName, Framework.GetCampaignName(), 1)
end