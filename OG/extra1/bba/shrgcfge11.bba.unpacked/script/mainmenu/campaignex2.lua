--
-- Unused because of unmodded Campaign.lua always sets Framework.SetCampaignName("c01") on map start
--


-- Add base campaign again after ex1 completly overwrites Campaign.lua
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

CampaignData["c00"] = {
    NumberOfMaps = 16,
    MapNumbersWithVideos = { 1, 4, 8, 12, 16 },
    BackgroundBaseName = "Campaign/S6_Campaign_Act", 
    BackgroundChangeAtMaps = { 4, 8, 12 }
}

------------------------------------------------------------------------------------------------------------
function ShowCampaignMap(guiElement)

	local map = Framework.GetCurrentMapName()

	local filename = "Maps\\Campaign\\c00\\"..map.."\\campaignmap.png"

    XGUIEng.SetMaterialTexture(guiElement,0,filename)		-- ???

end