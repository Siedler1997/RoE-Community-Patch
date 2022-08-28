CampaignDialog = CampaignDialog or {}
CampaignDialog.Widget = {}
CampaignDialog.Widget.Dialog = "/InGame/Singleplayer/Campaign"
CampaignDialog.Widget.Frame = "/InGame/Singleplayer/Campaign/BG"
CampaignDialog.SelectedMission = -1
CampaignDialog.SelectedVideo = -1
CampaignDialog.Starting = false
----------------------------------------------------------------------------------------------------------------------
function OpenCampaignMap()
    
    assert( CampaignData )  -- Declared in Campaign.lua
    local CampaignName = Framework.GetCampaignName()
    CampaignDialog.Widget.Map = "/InGame/Singleplayer/Campaign/Maps_" .. CampaignName
    local Data = assert( CampaignData[CampaignName] )
    CampaignDialog.Data = Data

    -- Display the campaign map, but don't show (the unknown number of) additional campaign maps
	XGUIEng.ShowAllSubWidgets(CampaignDialog.Widget.Dialog, 0)
    XGUIEng.ShowWidget( CampaignDialog.Widget.Dialog, 1 )
	XGUIEng.ShowAllSubWidgets(CampaignDialog.Widget.Dialog .. "/BG",1)
	XGUIEng.ShowWidget(CampaignDialog.Widget.Dialog .. "/BG",1)
	XGUIEng.ShowAllSubWidgets(CampaignDialog.Widget.Dialog .. "/BGB",1)
	XGUIEng.ShowWidget(CampaignDialog.Widget.Dialog .. "/BGB",1)
	XGUIEng.ShowAllSubWidgets(CampaignDialog.Widget.Dialog .. "/Tooltip",1)
	XGUIEng.ShowWidget(CampaignDialog.Widget.Dialog .. "/Tooltip",1)
	XGUIEng.ShowAllSubWidgets(CampaignDialog.Widget.Dialog .. "/Updater",1)
	XGUIEng.ShowWidget(CampaignDialog.Widget.Dialog .. "/Updater",1)
	XGUIEng.ShowAllSubWidgets(CampaignDialog.Widget.Map,1)
    XGUIEng.ShowWidget( CampaignDialog.Widget.Map, 1 )
    
	XGUIEng.PushPage(CampaignDialog.Widget.Dialog,false)
    XGUIEng.PushPage("/InGame/Singleplayer/ContainerBottom",false)
    XGUIEng.ShowWidget("/InGame/Singleplayer/RightMenu",0)
    
    DisplayLoadBottomButtons("/InGame/Singleplayer/ContainerBottom/StartMission",
                             "/InGame/Singleplayer/ContainerBottom/CancelCampaign")

	local highestMap = Framework.GetHighestCampaignMapId() 

	if Framework.IsDevM() then	
		highestMap = Data.NumberOfMaps
	end
    assert( highestMap )
    
	CampaignMap_ShowBGMap(highestMap)
	
    CampaignDialog.SelectedVideo = -1  
 	CampaignDialog.SelectedMission = -1

	for i = 1, Data.NumberOfMaps do
	
		local widget = CampaignDialog.Widget.Map.."/"..i.."/map"
		local container = CampaignDialog.Widget.Map.."/"..i
		local bgCurr = CampaignDialog.Widget.Map.."/"..i.."/BGCurr"
	
		XGUIEng.SetText(widget,"{center}"..i)
		XGUIEng.SetActionFunction(widget,"CampaignMap_OnClicked("..(i -1)..")")
		
		if i-1 <= highestMap then
		
			XGUIEng.ShowWidget(container,1)
			XGUIEng.ShowWidget(bgCurr,0)
		else
			XGUIEng.ShowWidget(container,0)
		end
	
	end
    
	for i = 1, #Data.MapNumbersWithVideos do
	
		local widget = CampaignDialog.Widget.Map.."/v"..i.."/v"
		local widgetBG = CampaignDialog.Widget.Map.."/v"..i
	
		XGUIEng.SetActionFunction(widget,"CampaignMap_Video_OnClicked("..(i -1)..")")
		
		if Data.MapNumbersWithVideos[i] - 1 < highestMap then
		
			XGUIEng.ShowWidget(widgetBG,1)
		
		else
		
			XGUIEng.ShowWidget(widgetBG,0)
		
		end
	
	end

	if highestMap >= 0 and highestMap < Data.NumberOfMaps then
        --special BG for the last map
        XGUIEng.ShowWidget(CampaignDialog.Widget.Map.."/".. highestMap+1 .."/BGCurr",1)
	    CampaignMap_OnClicked(highestMap)--select last available map	
	else
        XGUIEng.ShowWidget(CampaignDialog.Widget.Map.."/".. Data.NumberOfMaps .."/BGCurr",1)
	    CampaignMap_OnClicked(Data.NumberOfMaps - 1)
    end	    
			
    CampaignMap_OnMouseOut()
    CampaignDialog.Starting  = false
end 
----------------------------------------------------------------------------------------------------------------------
function CloseCampaignMap()
	
	XGUIEng.PopPage() -- "/InGame/Singleplayer/ContainerBottom"
	XGUIEng.ShowWidget(CampaignDialog.Widget.Dialog,0)
	
	XGUIEng.PopPage() -- CampaignDialog.Widget.Dialog

end 
---------------------------------------------------------------------------------------------------------------------------------
function CampaignMap_ShowBGMap(_highestmap)

    local filename = assert( CampaignDialog.Data.BackgroundBaseName )
    
    for i = 1, #CampaignDialog.Data.BackgroundChangeAtMaps do
        if _highestmap < CampaignDialog.Data.BackgroundChangeAtMaps[i] then
            filename = filename .. i .. ".png"
            break
        end
    end

    if filename == CampaignDialog.Data.BackgroundBaseName then
        filename = filename .. (#CampaignDialog.Data.BackgroundChangeAtMaps + 1) .. ".png"
    end
    
    XGUIEng.SetMaterialTexture(CampaignDialog.Widget.Frame,0,filename)

end
----------------------------------------------------------------------------------------------------------------------
function CampaignDialog_BackOnLeftClick()

	CloseCampaignMap()
	XGUIEng.ShowAllSubWidgets("/InGame/Singleplayer",0)
	
    XGUIEng.ShowWidget("/InGame/Singleplayer/ContainerBottom",1)
    XGUIEng.ShowWidget("/InGame/Singleplayer/CampaignMenu",1)
    
    DisplayLoadBottomButtons("/InGame/Singleplayer/ContainerBottom/BackCampaignMenu")

end
----------------------------------------------------------------------------------------------------------------------
function CampaignMap_Video_OnClicked(video)
    
    Sound.FXPlay2DSound( "ui\\menu_click")
    
    for i = 1, CampaignDialog.Data.NumberOfMaps do
       XGUIEng.HighLightButton( CampaignDialog.Widget.Map.."/".. i .."/map", 0 )
	end
	
    for i = 1, #CampaignDialog.Data.MapNumbersWithVideos do
        XGUIEng.HighLightButton( CampaignDialog.Widget.Map.."/v"..i.."/v", 0 )
	end

    XGUIEng.HighLightButton( CampaignDialog.Widget.Map .. "/v" .. (video+1) .. "/v", 1 )

    CampaignDialog.SelectedMission = -1
    CampaignDialog.SelectedVideo = video

end
----------------------------------------------------------------------------------------------------------------------
function CampaignMap_OnClicked(map)

    Sound.FXPlay2DSound( "ui\\menu_click")
    
    for i = 1, CampaignDialog.Data.NumberOfMaps do
    	XGUIEng.HighLightButton(CampaignDialog.Widget.Map.."/"..i.."/map", 0)
	end
    for i = 1, #CampaignDialog.Data.MapNumbersWithVideos do
        XGUIEng.HighLightButton( CampaignDialog.Widget.Map.."/v"..i.."/v", 0 )
	end

    XGUIEng.HighLightButton(CampaignDialog.Widget.Map.."/"..(map+1).."/map", 1)

    CampaignDialog.SelectedVideo = -1
    CampaignDialog.SelectedMission = map
end 
----------------------------------------------------------------------------------------------------------------------
function CampaignMap_Update()
    if CampaignDialog.Starting then
        XGUIEng.DisableButton("/InGame/Singleplayer/ContainerBottom/StartMission",1)
    	XGUIEng.DisableButton("/InGame/Singleplayer/ContainerBottom/CancelCampaign",1)
    else
        XGUIEng.DisableButton("/InGame/Singleplayer/ContainerBottom/StartMission",0)
    	XGUIEng.DisableButton("/InGame/Singleplayer/ContainerBottom/CancelCampaign",0)
   end
    
   if  CampaignDialog.SelectedMission ~= -1 then

        DisplayLoadBottomButtons("/InGame/Singleplayer/ContainerBottom/StartMission",
                             "/InGame/Singleplayer/ContainerBottom/CancelCampaign")

    XGUIEng.SetText("/InGame/Singleplayer/ContainerBottom/StartMission", XGUIEng.GetStringTableText("UI_Texts/MainMenuStartMission_center"))

    elseif CampaignDialog.SelectedVideo ~= -1 then

    DisplayLoadBottomButtons("/InGame/Singleplayer/ContainerBottom/StartMission",
                             "/InGame/Singleplayer/ContainerBottom/CancelCampaign")
                             
    XGUIEng.SetText("/InGame/Singleplayer/ContainerBottom/StartMission", XGUIEng.GetStringTableText("UI_Texts/MainMenuPlayVideo_center"))

    else

    DisplayLoadBottomButtons("/InGame/Singleplayer/ContainerBottom/CancelCampaign")

    end

end
----------------------------------------------------------------------------------------------------------------------
-- This needs to be rewritten for use with new campaigns that have videos
function CampaignMap_PlayVideo(_video)
    CampaignDialog.Starting = true
	local gendername = Profile.GetString("Profile", "Gender")

    local Gender = 0
	if gendername == "female" then
		Gender = 1
	end
	
	Sound.MusicPause()
	Sound.MusicTrigger()
    
    if _video == 0 then
		
        Framework.PlayVideo("videos\\c00_intro", -1, false, false)		

    elseif _video == 1 then
		
		Framework.PlayVideo("videos\\c00_endofact1", Gender, false, false)
		
    elseif _video == 2 then
		
		Framework.PlayVideo("videos\\c00_endofact2", Gender, false, false)
		
    elseif _video == 3 then
		
		local Traitor = Profile.GetTraitor()


		if Traitor == "U_KnightTrading" then
			Framework.PlayVideos("videos\\c00_endofact3", "videos\\c00_endofact3_elias", Gender)
		elseif Traitor == "U_KnightHealing" then
			Framework.PlayVideos("videos\\c00_endofact3", "videos\\c00_endofact3_alandra", Gender)
		elseif Traitor == "U_KnightChivalry" then
			Framework.PlayVideos("videos\\c00_endofact3", "videos\\c00_endofact3_marcus", Gender)
		elseif Traitor == "U_KnightPlunder" then
			Framework.PlayVideos("videos\\c00_endofact3", "videos\\c00_endofact3_kestral", Gender)
		elseif Traitor == "U_KnightSong" then
			Framework.PlayVideos("videos\\c00_endofact3", "videos\\c00_endofact3_thordal", Gender)
		elseif Traitor == "U_KnightWisdom" then
			Framework.PlayVideos("videos\\c00_endofact3", "videos\\c00_endofact3_hakim", Gender)
		else
		    --shouldn't happen ... except for Dev Machine
			Framework.PlayVideos("videos\\c00_endofact3", "videos\\c00_endofact3_elias", Gender)
		end
		
    else
		
		local success = 0

		if Profile.IsKeyValid("Profile", "Success") then
		    success = Profile.GetInteger("Profile", "Success")
		end
		
		if success == 3491245 then
			Framework.PlayVideos("videos\\c00_endofact4", "videos\\c00_endofact4_final3", Gender)
		elseif success == 1278560 then
			Framework.PlayVideos("videos\\c00_endofact4", "videos\\c00_endofact4_final1", Gender)
		else
			Framework.PlayVideos("videos\\c00_endofact4", "videos\\c00_endofact4_final2", Gender)
		end
		
    end

	Sound.MusicResume()
	CampaignDialog.Starting = false
end
----------------------------------------------------------------------------------------------------------------------
function CampaignMap_StartMission(_map)
    --
    CampaignDialog.Starting = true
    Input.NoneMode()
    Framework.SetCampaignMap(_map)
    
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
	InitLoadScreen(true, -1, Framework.GetCampaignMap(), Framework.GetCampaignName(), 1)

	InitializeFader()
	FadeIn(1,CampaignMap_StartMapCallback)	
end
----------------------------------------------------------------------------------------------------------------------
function CampaignMap_StartMapCallback()

    local CampaignName = Framework.GetCampaignName()
    local CampaignMap  = Framework.GetCampaignMap()

    if false and CampaignName == "c01" then
        Framework.StartMap(CampaignMap, -1, CampaignName ) --  -1 = Campaign!
    else
        Framework.StartMapWithKnightChoice(CampaignMap, -1, CampaignName ) --  -1 = Campaign!
    end
	
end
----------------------------------------------------------------------------------------------------------------------
function CampaignMap_OnActionButtonLeftClick()

    if  CampaignDialog.SelectedMission ~= -1 then

        CampaignMap_StartMission(CampaignDialog.SelectedMission)
        
    elseif CampaignDialog.SelectedVideo ~= -1 then

        CampaignMap_PlayVideo(CampaignDialog.SelectedVideo)

    end

end
----------------------------------------------------------------------------------------------------------------------
function  CampaignMap_OnMouseOver()
    XGUIEng.ShowWidget("/InGame/Singleplayer/Campaign/Tooltip",1)
    
    local CurrentWidget = XGUIEng.GetCurrentWidgetID()
    
    --set position
    local x,y = XGUIEng.GetWidgetScreenPosition(CurrentWidget)
    local sizex,sizey = XGUIEng.GetWidgetScreenSize(CurrentWidget)
    local tooltipx,tooltipy =XGUIEng.GetWidgetScreenSize("/InGame/Singleplayer/Campaign/Tooltip")
    
    XGUIEng.SetWidgetScreenPosition("/InGame/Singleplayer/Campaign/Tooltip" ,
                                     x+sizex/2 - tooltipx/2,
                                     y- tooltipy )
    
    --display text : mapname
  
   local Campaign = Framework.GetCampaignName()
    local Maps = CreateMapTable(-1, Campaign)
    XGUIEng.SetText("/InGame/Singleplayer/Campaign/Tooltip/Text", "{center}Test_" .. #Maps)
    
    local MapIndex =  XGUIEng.GetWidgetNameByID(XGUIEng.GetWidgetsMotherID(CurrentWidget))
    local MapName = Tool_GetLocalizedMapName(Maps[0+MapIndex])    


   
    --XGUIEng.SetText("/InGame/Singleplayer/Campaign/Tooltip/Text", "{center}" .. MapName)
    --XGUIEng.SetText("/InGame/Singleplayer/Campaign/Tooltip/Text", "{center}Test_" .. Campaign)
end

----------------------------------------------------------------------------------------------------------------------
function  CampaignMap_OnMouseOut()

    XGUIEng.ShowWidget("/InGame/Singleplayer/Campaign/Tooltip",0)


end

