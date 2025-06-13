-----------------------------------------------------------------------------------------
-- Overwrites
-- it must be in a function because the mapeditor uses the overwritten functions too
-- but doesnt initializes the whole framework
-----------------------------------------------------------------------------------------

function InitGlobalOverwrite()

    do
        OldAIScriptHelper_GetTroopTypeOverride = AIScriptHelper_GetTroopTypeOverride
        AIScriptHelper_GetTroopTypeOverride = function( _Default, _OverrideType )
            if not _OverrideType or type( _OverrideType ) == "boolean" or _OverrideType < 3 then
                return OldAIScriptHelper_GetTroopTypeOverride( _Default, _OverrideType )
            end
    
            if _Default == Entities.U_MilitarySword then
                if _OverrideType == 3 then
                    return Entities.U_MilitarySword_Khana
                end
            
            elseif _Default == Entities.U_MilitaryBow then
                if _OverrideType == 3 then
                    return Entities.U_MilitaryBow_Khana
                end
            
            end
            
            assert( false, string.format( "No existing override for %s -> %s", tostring(_Default), tostring(_OverrideType) ) )
        end
    end
    
    --------------------------------------------------------------------------
    -- GlobalThiefSystem
    --------------------------------------------------------------------------
    do 
        local OldScriptCallback_OnThiefStealBuilding = ScriptCallback_OnThiefStealBuilding
        
        ScriptCallback_OnThiefStealBuilding = function(_ThiefID, _ThiefPlayerID, _SpawnBuildingID, _BuildingPlayerID)
            
            local BuildingType = Logic.GetEntityType(_SpawnBuildingID)
        
            if BuildingType == Entities.B_Cistern then
                Logic.Extra1_SetResourceAmount(_SpawnBuildingID, 0)
                
                return
            end
            
            return OldScriptCallback_OnThiefStealBuilding(_ThiefID, _ThiefPlayerID, _SpawnBuildingID, _BuildingPlayerID)
           
        end
    end
    
    --------------------------------------------------------------------------
    -- GlobalMerchantSystem
    --------------------------------------------------------------------------
    
    do 
        local OldInitGlobalMerchantSystem = InitGlobalMerchantSystem
        
        InitGlobalMerchantSystem = function()
        
            -- call old initializeer
            OldInitGlobalMerchantSystem()
            
            -- add new stuff
            
            MerchantSystem.BasePrices[Goods.G_Gems]              = 150
            MerchantSystem.BasePrices[Goods.G_Olibanum]          = 150
            MerchantSystem.BasePrices[Goods.G_MusicalInstrument] = 150
            
            MerchantSystem.BasePrices[Entities.U_MilitaryBandit_Ranged_AS] = 60
            MerchantSystem.BasePrices[Entities.U_MilitaryBandit_Melee_AS]  = 60
            MerchantSystem.BasePrices[Entities.U_MilitarySword_Khana] = 120
            MerchantSystem.BasePrices[Entities.U_MilitaryBow_Khana]  = 120
            
            MerchantSystem.RefreshRates[Entities.U_MilitaryBandit_Ranged_AS] = 150
            MerchantSystem.RefreshRates[Entities.U_MilitaryBandit_Melee_AS] = 150
            MerchantSystem.RefreshRates[Entities.U_MilitarySword_Khana] = 150
            MerchantSystem.RefreshRates[Entities.U_MilitaryBow_Khana] = 150
    
            MerchantSystem.RefreshRates[Goods.G_Gems]  = 150
            MerchantSystem.RefreshRates[Goods.G_Olibanum]  = 150
            MerchantSystem.RefreshRates[Goods.G_MusicalInstrument]  = 150
            
            -- CP
            MerchantSystem.BasePrices[Goods.G_PoorSpear]      = 60
            
            MerchantSystem.BasePrices[Entities.U_MilitarySword] = 120
            MerchantSystem.BasePrices[Entities.U_MilitaryBow]  = 120
            MerchantSystem.BasePrices[Entities.U_MilitarySword_RedPrince] = 120
            MerchantSystem.BasePrices[Entities.U_MilitaryBow_RedPrince]  = 120
            MerchantSystem.BasePrices[Entities.U_MilitarySword_Khana] = 120
            MerchantSystem.BasePrices[Entities.U_MilitaryBow_Khana]  = 120

            MerchantSystem.RefreshRates[Goods.G_PoorSpear]    = 150     
            
            MerchantSystem.RefreshRates[Entities.U_MilitarySword] = 150
            MerchantSystem.RefreshRates[Entities.U_MilitaryBow] = 150
            MerchantSystem.RefreshRates[Entities.U_MilitarySword_RedPrince] = 150
            MerchantSystem.RefreshRates[Entities.U_MilitaryBow_RedPrince] = 150
            MerchantSystem.RefreshRates[Entities.U_MilitarySword_Khana] = 150
            MerchantSystem.RefreshRates[Entities.U_MilitaryBow_Khana] = 150



            g_BuffForGood[Goods.G_Gems] = Buffs.Buff_Gems
            g_BuffForGood[Goods.G_Olibanum] = Buffs.Buff_Olibanum
            g_BuffForGood[Goods.G_MusicalInstrument] = Buffs.Buff_MusicalInstrument
            
        end
    end
    
    
    function GameCallback_OnGeologistRefill( _PlayerID, _TargetID, _GeologistID )
        Quest_OnGeologistRefill( _PlayerID, _TargetID, _GeologistID )
    end
    
    --------------------------------------------------------------------------
    -- Set mine resource amount by scriptname
    --------------------------------------------------------------------------
    
    do 
        local OldCreateTreasures = CreateTreasures
        
        CreateTreasures = function()
            OldCreateTreasures()
            
            local ListOfMines = { Entities.R_StoneMine, Entities.R_IronMine }
            
            for _, EntityType in ipairs(ListOfMines) do
                local MineIDs = {Logic.GetEntities(EntityType, 29)}
                table.remove( MineIDs, 1 )
                for _, MineID in ipairs( MineIDs ) do
                    local Amount, Capacity = string.match( Logic.GetEntityName(MineID), "^(%d+)/(%d+)$" )
                    
                    if Amount and Capacity then
                        Logic.SetResourceDoodadGoodAmount( MineID, Capacity )
                        Logic.Extra1_SetResourceAmount( MineID, Amount ) 
                    end
                end
            end
        end
    end

end


function SetupNPCPlayerHeadsAndName()
    
    local BanditColorCounter = 1
    local VillageColorCounter = 1
    local CloisterColorCounter = 1
    local CityColorCounter = 2
    
    
    for PlayerID = 1, 8 do
        
        if  Logic.PlayerGetIsHumanFlag(PlayerID) ~= true 
        and Logic.GetStoreHouse(PlayerID) ~= 0 then
        
            local PlayerName = ""
            local Head = "H_NPC_"
            local IndexColor = ""
            
            local PlayerCategory = GetPlayerCategoryType(PlayerID)
            
            local MapName = Framework.GetCurrentMapName()
            local MapType, Campaign = Framework.GetCurrentMapTypeAndCampaignName()
            local ClimateZoneName = Framework.GetMapClimateZone(MapName, MapType, Campaign)
            
            local Suffix = ""

            if ClimateZoneName == "Generic"
            or ClimateZoneName == "MiddleEurope" then
                Suffix = "_ME"
            elseif ClimateZoneName == "NorthEurope" then
                Suffix = "_NE"
            elseif ClimateZoneName == "SouthEurope" then
                Suffix = "_SE"
            elseif ClimateZoneName == "NorthAfrica" then
                Suffix = "_NA"
            elseif ClimateZoneName == "Asia" then
                Suffix = "_AS"
            end
            
            if PlayerCategory == PlayerCategories.BanditsCamp then
                
                Head = Head .. "Mercenary" ..Suffix
                IndexColor  = "BanditsColor" .. BanditColorCounter
                BanditColorCounter = BanditColorCounter + 1
                
            elseif PlayerCategory == PlayerCategories.Cloister then
                
                Head = Head .. "Monk" ..Suffix                
                IndexColor  = "CloisterColor" .. CloisterColorCounter
                CloisterColorCounter = CloisterColorCounter + 1
                
            elseif PlayerCategory == PlayerCategories.Village then
                
                Head = Head .. "Villager01" ..Suffix         
                IndexColor  = "VillageColor" .. VillageColorCounter   
                VillageColorCounter = VillageColorCounter + 1

            elseif PlayerCategory == PlayerCategories.City then
                
                Head = Head .. "Castellan" ..Suffix         
                IndexColor  = "CityColor" .. CityColorCounter   
                CityColorCounter = CityColorCounter + 1
            
            elseif PlayerCategory == PlayerCategories.Harbour then
                
                Head = Head .. "Generic_Trader"
                IndexColor  = "TravelingSalesmanColor"
                
            end            
            
            SetupPlayer(PlayerID, Head, "NPC Player has no name", IndexColor)
            
        end
    end
end



function GetBanditMilitaryTypesForClimateZoneForCurrentMap()

    local MapName = Framework.GetCurrentMapName()
    local MapType, Campaign = Framework.GetCurrentMapTypeAndCampaignName()
    
    local ClimateZoneName = Framework.GetMapClimateZone(MapName, MapType, Campaign)
    
    local OutlawMeleeType = Entities.U_MilitaryBandit_Melee_ME
    local OutlawRangedType = Entities.U_MilitaryBandit_Ranged_ME
    
    if ClimateZoneName == "MiddleEurope" then
        
        OutlawMeleeType = Entities.U_MilitaryBandit_Melee_ME
        OutlawRangedType = Entities.U_MilitaryBandit_Ranged_ME
        
    elseif ClimateZoneName == "NorthEurope" then
        
        OutlawMeleeType = Entities.U_MilitaryBandit_Melee_NE
        OutlawRangedType = Entities.U_MilitaryBandit_Ranged_NE
        
    elseif ClimateZoneName == "SouthEurope" then
        
        OutlawMeleeType = Entities.U_MilitaryBandit_Melee_SE
        OutlawRangedType = Entities.U_MilitaryBandit_Ranged_SE
        
    elseif ClimateZoneName == "NorthAfrica" then
        
        OutlawMeleeType = Entities.U_MilitaryBandit_Melee_NA
        OutlawRangedType = Entities.U_MilitaryBandit_Ranged_NA

    elseif ClimateZoneName == "Asia" then
        
        OutlawMeleeType = Entities.U_MilitaryBandit_Melee_AS
        OutlawRangedType = Entities.U_MilitaryBandit_Ranged_AS
        
    end

    return OutlawMeleeType, OutlawRangedType
end


