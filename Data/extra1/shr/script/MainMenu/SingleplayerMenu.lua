--SinglePlayerMenu



g_MainMenuSingleplayer = g_MenuPage:CreateNewMenupage("/InGame/Singleplayer")
----------------------------------------------------------------------------------------------------
function g_MainMenuSingleplayer:Show(_BottomPage, _PopAndKeepOldPage)
    
    g_MenuPage.Show(self,_BottomPage, _PopAndKeepOldPage ) 
    XGUIEng.ShowWidget("/InGame/Background/Title", 0)
    XGUIEng.ShowWidget("/InGame/Background/TitleSmall", 1)
    
    XGUIEng.ShowAllSubWidgets("/InGame/Singleplayer",0)
    XGUIEng.ShowWidget("/InGame/Singleplayer/ContainerBottom",1)
    XGUIEng.ShowWidget("/InGame/Singleplayer/RightMenu",1)
    
    DisplayLoadBottomButtons("/InGame/Singleplayer/ContainerBottom/BackMenu")
    Framework.SetLoadScreenNeedButton(1)
 
end
----------------------------------------------------------------------------------------------------
function g_MainMenuSingleplayer:Back()

    g_MenuPage.Back(self) 
    XGUIEng.ShowWidget("/InGame/Background/Title", 1)
    XGUIEng.ShowWidget("/InGame/Background/TitleSmall", 0)
    XGUIEng.ShowWidget("/InGame/Singleplayer/CampaignMenu", 0)
    Framework.SetLoadScreenNeedButton(0)

end
----------------------------------------------------------------------------------------------------
function g_MainMenuSingleplayer:PlayCampaign()

	OpenCampaignMap()

end
----------------------------------------------------------------------------------------------------
function g_MainMenuSingleplayer:CustomGame()
	
	OpenCustomGameDialog()
	
end
----------------------------------------------------------------------------------------------------
function g_MainMenuSingleplayer:ContinueGame()

	OpenLoadDialog()
    XGUIEng.ShowWidget("/InGame/Singleplayer/RightMenu", 0)
	DisplayLoadBottomButtons("/InGame/Singleplayer/ContainerBottom/LoadGame",
	                         "/InGame/Singleplayer/ContainerBottom/CancelLoad")

end 