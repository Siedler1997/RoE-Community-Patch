--CampaignMenu



g_MainMenuCampaign = g_MenuPage:CreateNewMenupage("/InGame/Singleplayer/CampaignMenu")
----------------------------------------------------------------------------------------------------
function g_MainMenuCampaign:Show(_BottomPage, _PopAndKeepOldPage)

    --g_MenuPage.Show(self,_BottomPage, _PopAndKeepOldPage ) 
    XGUIEng.PushPage("/InGame/Singleplayer/CampaignMenu",false)
    XGUIEng.ShowWidget("/InGame/Background/Title", 0)
    XGUIEng.ShowWidget("/InGame/Background/TitleSmall", 1)
    
    XGUIEng.ShowAllSubWidgets("/InGame/Singleplayer",0)
    XGUIEng.ShowWidget("/InGame/Singleplayer/CampaignMenu",1)
    
    XGUIEng.PushPage("/InGame/Singleplayer/ContainerBottom",false)
    XGUIEng.ShowWidget("/InGame/Singleplayer/ContainerBottom",1)
    DisplayLoadBottomButtons("/InGame/Singleplayer/ContainerBottom/BackCampaignMenu")
    
	XGUIEng.DisableButton("/InGame/Singleplayer/CampaignMenu/PlayCPCampaign",1)
end
----------------------------------------------------------------------------------------------------
function g_MainMenuCampaign:Back()
	XGUIEng.PopPage()
    XGUIEng.ShowWidget("/InGame/Singleplayer/CampaignMenu",0)
	XGUIEng.PopPage()

	XGUIEng.ShowAllSubWidgets("/InGame/Singleplayer",0)
    XGUIEng.ShowWidget("/InGame/Singleplayer/ContainerBottom",1)
    XGUIEng.ShowWidget("/InGame/Singleplayer/RightMenu",1)
    
    DisplayLoadBottomButtons("/InGame/Singleplayer/ContainerBottom/BackMenu")
end
----------------------------------------------------------------------------------------------------
function g_MainMenuCampaign:PlayBaseCampaign()
    Framework.SetCampaignName("c00")
    
    Framework.AddCampaignMap("c00_m01_Vestholm")
    Framework.AddCampaignMap("c00_m02_Challia")
    Framework.AddCampaignMap("c00_m03_Gallos")
    Framework.AddCampaignMap("c00_m04_Narfang")
    Framework.AddCampaignMap("c00_m05_Drengir")
    Framework.AddCampaignMap("c00_m06_Rekkyr")
    Framework.AddCampaignMap("c00_m07_Geth")
    Framework.AddCampaignMap("c00_m08_Seydiir")
    Framework.AddCampaignMap("c00_m09_Husran")
    Framework.AddCampaignMap("c00_m10_Juahar")
    Framework.AddCampaignMap("c00_m11_Tios")
    Framework.AddCampaignMap("c00_m12_Sahir")
    Framework.AddCampaignMap("c00_m13_Montecito")
    Framework.AddCampaignMap("c00_m14_Gueranna")
    Framework.AddCampaignMap("c00_m15_Vestholm")
    Framework.AddCampaignMap("c00_m16_Rossotorres")

	OpenCampaignMap()
end
----------------------------------------------------------------------------------------------------
function g_MainMenuCampaign:PlayAddOnCampaign()
    Framework.SetCampaignName("c01")
    
    Framework.AddCampaignMap("c01_m01_Basrima")
    Framework.AddCampaignMap("c01_m02_Hendalla")
    Framework.AddCampaignMap("c01_m03_Amesthan")
    Framework.AddCampaignMap("c01_m04_Almerabad")
    Framework.AddCampaignMap("c01_m05_Idukun")
    Framework.AddCampaignMap("c01_m06_Praphatstan")
    Framework.AddCampaignMap("c01_m07_Nakhata")
    Framework.AddCampaignMap("c01_m08_Thela")

	OpenCampaignMap()
end
----------------------------------------------------------------------------------------------------
function g_MainMenuCampaign:PlayCPCampaign()
    --Framework.SetCampaignName("c01")

	OpenCampaignMap()
end 