--CampaignMenu



g_MainMenuCampaign = g_MenuPage:CreateNewMenupage("/InGame/Singleplayer/CampaignMenu")
----------------------------------------------------------------------------------------------------
function g_MainMenuCampaign:Show(_BottomPage, _PopAndKeepOldPage)

    --g_MenuPage.Show(self,_BottomPage, _PopAndKeepOldPage ) 
	--XGUIEng.PopPage()
    --XGUIEng.PushPage("/InGame/Singleplayer/CampaignMenu",false)
    XGUIEng.ShowWidget("/InGame/Background/Title", 0)
    XGUIEng.ShowWidget("/InGame/Background/TitleSmall", 1)
    
    XGUIEng.ShowAllSubWidgets("/InGame/Singleplayer",0)
    XGUIEng.ShowWidget("/InGame/Singleplayer/CampaignMenu",1)
    
    --XGUIEng.PushPage("/InGame/Singleplayer/ContainerBottom",false)
    XGUIEng.ShowWidget("/InGame/Singleplayer/ContainerBottom",1)
    DisplayLoadBottomButtons("/InGame/Singleplayer/ContainerBottom/BackCampaignMenu")
    
	XGUIEng.DisableButton("/InGame/Singleplayer/CampaignMenu/PlayCPCampaign",1)
end
----------------------------------------------------------------------------------------------------
function g_MainMenuCampaign:Back()
	--XGUIEng.PopPage()
    XGUIEng.ShowWidget("/InGame/Singleplayer/CampaignMenu",0)
	--XGUIEng.PopPage()

	XGUIEng.ShowAllSubWidgets("/InGame/Singleplayer",0)
    XGUIEng.ShowWidget("/InGame/Singleplayer/ContainerBottom",1)
    XGUIEng.ShowWidget("/InGame/Singleplayer/RightMenu",1)
    
    DisplayLoadBottomButtons("/InGame/Singleplayer/ContainerBottom/BackMenu")
end
----------------------------------------------------------------------------------------------------
function g_MainMenuCampaign:PlayBaseCampaign()
    Framework.SetCampaignName("c00")
    

	OpenCampaignMap()
end
----------------------------------------------------------------------------------------------------
function g_MainMenuCampaign:PlayAddOnCampaign()
    Framework.SetCampaignName("c01")

	OpenCampaignMap()
end
----------------------------------------------------------------------------------------------------
function g_MainMenuCampaign:PlayCPCampaign()
    --Framework.SetCampaignName("c01")

	OpenCampaignMap()
end 