--[[
Framework.SetCampaignName("c01")

Framework.AddCampaignMap("c01_m01_Basrima")
Framework.AddCampaignMap("c01_m02_Hendalla")
Framework.AddCampaignMap("c01_m03_Amesthan")
Framework.AddCampaignMap("c01_m04_Almerabad")
Framework.AddCampaignMap("c01_m05_Idukun")
Framework.AddCampaignMap("c01_m06_Praphatstan")
Framework.AddCampaignMap("c01_m07_Nakhata")
Framework.AddCampaignMap("c01_m08_Thela")
--]]

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
    
    Framework.AddCampaignMap("c01_m01_Basrima")
    Framework.AddCampaignMap("c01_m02_Hendalla")
    Framework.AddCampaignMap("c01_m03_Amesthan")
    Framework.AddCampaignMap("c01_m04_Almerabad")
    Framework.AddCampaignMap("c01_m05_Idukun")
    Framework.AddCampaignMap("c01_m06_Praphatstan")
    Framework.AddCampaignMap("c01_m07_Nakhata")
    Framework.AddCampaignMap("c01_m08_Thela")

CampaignData = CampaignData or {}
CampaignData["c00"] = {
    NumberOfMaps = 16,
    MapNumbersWithVideos = { 1, 4, 8, 12, 16 },
    BackgroundBaseName = "Campaign/S6_Campaign_Act", 
    BackgroundChangeAtMaps = { 4, 8, 12 }
}

CampaignData["c01"] = {
    NumberOfMaps = 8,
    MapNumbersWithVideos = {},
    BackgroundBaseName = "Campaign/Campaign", 
    BackgroundChangeAtMaps = { 3, 5 }
}
------------------------------------------------------------------------------------------------------------
function ShowCampaignMap(guiElement)

	local map = Framework.GetCurrentMapName()

	local filename = "Maps\\Campaign\\c00\\"..map.."\\campaignmap.png"

    XGUIEng.SetMaterialTexture(guiElement,0,filename)		-- ???

end