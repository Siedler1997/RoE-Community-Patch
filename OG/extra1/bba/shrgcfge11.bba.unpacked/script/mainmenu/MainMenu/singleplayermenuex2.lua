
----------------------------------------------------------------------------------------------------
function g_MainMenuSingleplayer:Back()

    g_MenuPage.Back(self) 
    XGUIEng.ShowWidget("/InGame/Background/Title", 1)
    XGUIEng.ShowWidget("/InGame/Background/TitleSmall", 0)
    XGUIEng.ShowWidget("/InGame/Singleplayer/CampaignMenu", 0)
    Framework.SetLoadScreenNeedButton(0)

end