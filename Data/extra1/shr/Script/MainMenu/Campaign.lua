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

    --
    --

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

	local map = Framework.GetCampaignMap()

	local filename = "Maps\\Campaign\\c00\\"..map.."\\campaignmap.png"

    XGUIEng.SetMaterialTexture(guiElement,0,filename)		-- ???

end