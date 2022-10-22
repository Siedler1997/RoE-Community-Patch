
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
    end

    local Filename

    if KnightBG == 0 then
        if KnightType == Entities.U_KnightKhana then
            Filename = "loadscreens\\chapter3.png"
        --[[
        elseif KnightType == Entities.U_KnightPraphat then
            Filename = "loadscreens\\Throneroom.png"
        elseif Tex == "me" then
            Filename = "loadscreens\\chapter1.png"
        --]]
        elseif Tex == "as" then
            Filename = "loadscreens\\Endscreen.png"
        else
            Filename = "loadscreens\\" .. Tex .. ".png"
        end
    else
        Filename = "loadscreens\\" .. Tex .. KnightBG .. ".png"
    end

    XGUIEng.SetMaterialTexture("/InGame/MissionStatistic/BG", 0, Filename)
end
