
function GUI_MissionStatistic.SetBG()
    -- set same BG as loading screen
    local Tex
    local MapName = Framework.GetCurrentMapName()
    local MapType, Campaign = Framework.GetCurrentMapTypeAndCampaignName()
    local ClimateZoneName = Framework.GetMapClimateZone(MapName, MapType, Campaign)

    if ClimateZoneName == "Generic"
    or ClimateZoneName == "MiddleEurope" then
        Tex = "me"
    elseif ClimateZoneName == "NorthEurope" then
        Tex = "ne"
    elseif ClimateZoneName == "SouthEurope" then
        Tex = "se"
    elseif ClimateZoneName == "NorthAfrica" then
        Tex = "na"
    elseif ClimateZoneName == "Asia" then
        Tex = "as"
    end

    local KnightBG = 0
    local KnightID = Logic.GetKnightID(GUI.GetPlayerID())
    local KnightType = Logic.GetEntityType(KnightID)

    if     KnightType == Entities.U_KnightTrading  then KnightBG = 1
    elseif KnightType == Entities.U_KnightHealing  then KnightBG = 2
    elseif KnightType == Entities.U_KnightChivalry then KnightBG = 3
    elseif KnightType == Entities.U_KnightWisdom   then KnightBG = 4
    elseif KnightType == Entities.U_KnightPlunder  then KnightBG = 5
    elseif KnightType == Entities.U_KnightSong     then KnightBG = 6
    elseif KnightType == Entities.U_KnightSaraya   then KnightBG = 7
    elseif KnightType == Entities.U_KnightSabatta   then KnightBG = 8
    elseif KnightType == Entities.U_KnightRedPrince   then KnightBG = 9
    elseif KnightType == Entities.U_KnightPraphat   then KnightBG = 10
    elseif KnightType == Entities.U_KnightKhana   then KnightBG = 11
    end

    local Filename

    if KnightBG == 0 then
        Filename = "loadscreens\\" .. Tex .. ".png"
    else
        Filename = "loadscreens\\" .. Tex .. KnightBG .. ".png"
    end

    XGUIEng.SetMaterialTexture("/InGame/MissionStatistic/BG", 0, Filename)
end
