
g_CPVersion = "CP 0.1";

-- Return the first index with the given value (or nil if not found).
-- Source: https://stackoverflow.com/a/69651531
function GetIndexOfItem(array, value)
    for i, v in ipairs(array) do
        if v == value then
            return i
        end
    end
    return nil
end

--Lighter version of base CalculateTraitorAndPoints from local script
function CalculateTraitor()

    --get Title and prestige points of each knight and take the knight with the lowest as traitor
    -- save traitor in GBD

    --I do not like this, but I have no other idea how to get this data:
    local BaseKnightTypes = {"U_KnightChivalry",
                        "U_KnightHealing",
                        "U_KnightSong",
                        "U_KnightTrading",
                        "U_KnightPlunder",
                        "U_KnightWisdom"
                    }

    local BaseCampaignMaps = {"c00_m01_Vestholm",
                            "c00_m02_Challia",
                            "c00_m03_Gallos",
                            "c00_m04_Narfang",
                            "c00_m05_Drengir",
                            "c00_m06_Rekkyr",
                            "c00_m07_Geth",
                            "c00_m08_Seydiir",
                            "c00_m09_Husran",
                            "c00_m10_Juahar",
                            "c00_m11_Tios",
                            "c00_m12_Sahir"
                            --Ignore these. Only the missions up to here are important for calculation
                            --[[
                            "c00_m13_Montecito",
                            "c00_m14_Gueranna",
                            "c00_m15_Vestholm",
                            "c00_m16_Rossotorres"
                            --]] 
                        }

    local Traitor
    local LowestTitle = 1000
    
    for i=1, #BaseKnightTypes do
        local KnightTypeName = BaseKnightTypes[i]
        local SumOfTitle = 0  

        --get the sum titles and prestigepoints of knight in all maps
        for j=1,#BaseCampaignMaps do
            local MapName = string.lower(BaseCampaignMaps[j])
			if Profile.PrestigeAndTitleExist(KnightTypeName, MapName) then
				local PointsInMap, Title = Profile.GetPrestigeAndTitle(KnightTypeName, MapName)
                SumOfTitle = SumOfTitle + Title
		    end
        end

        if SumOfTitle < LowestTitle then
            Traitor = KnightTypeName
            LowestTitle = SumOfTitle
        end
    end
    
    return Traitor
    
end

-----------------------------------------------------------------------------------------
-- Generic shared overwrites
-----------------------------------------------------------------------------------------
function InitSharedOverwriteEx2()

    -- InitKnightTitleTables
    do
        local OldInitKnightTitleTables = InitKnightTitleTables
        
        InitKnightTitleTables = function()
       
            local SavedFunction = CreateTechnologyKnightTitleTable
            
            CreateTechnologyKnightTitleTable = function() end
        
            OldInitKnightTitleTables()
            
            CreateTechnologyKnightTitleTable = SavedFunction
            
            SavedFunction = nil
            
            local TechnologiesTableIndex = 4

            -- New beautification menus

            -- Remove some vanilla beautifications from their old titles
            table.remove(
                NeedsAndRightsByKnightTitle[KnightTitles.Knight][TechnologiesTableIndex],
                Technologies.R_SpecialEdition_Pavilion)
            table.remove(
                NeedsAndRightsByKnightTitle[KnightTitles.Earl][TechnologiesTableIndex],
                Technologies.R_SpecialEdition_StatueSettler)
            table.remove(
                NeedsAndRightsByKnightTitle[KnightTitles.Marquees][TechnologiesTableIndex],
                Technologies.R_SpecialEdition_StatueProduction)
            table.remove(
                NeedsAndRightsByKnightTitle[KnightTitles.Marquees][TechnologiesTableIndex],
                Technologies.R_SpecialEdition_Column)

            -- Player has to unlock second beautification menu
            table.insert(
                NeedsAndRightsByKnightTitle[KnightTitles.Marquees][TechnologiesTableIndex],
                Technologies.R_SpecialEdition2)   

            --Add new beautifications
            -- Ritter
            table.insert(
                NeedsAndRightsByKnightTitle[KnightTitles.Knight][TechnologiesTableIndex],
                Technologies.R_Beautification_Misc)
            table.insert(
                NeedsAndRightsByKnightTitle[KnightTitles.Knight][TechnologiesTableIndex],
                Technologies.R_Beautification_Cart)
            table.insert(
                NeedsAndRightsByKnightTitle[KnightTitles.Knight][TechnologiesTableIndex],
                Technologies.R_Beautification_Graveyard)

            -- Landvogt
            table.insert(
                NeedsAndRightsByKnightTitle[KnightTitles.Mayor][TechnologiesTableIndex],
                Technologies.R_Beautification_Signpost)
            table.insert(
                NeedsAndRightsByKnightTitle[KnightTitles.Mayor][TechnologiesTableIndex],
                Technologies.R_Beautification_WoodBench)
            table.insert(
                NeedsAndRightsByKnightTitle[KnightTitles.Mayor][TechnologiesTableIndex],
                Technologies.R_SpecialEdition_Pavilion)
                
            -- Baron
            table.insert(
                NeedsAndRightsByKnightTitle[KnightTitles.Baron][TechnologiesTableIndex],
                Technologies.R_Beautification_Military)
            table.insert(
                NeedsAndRightsByKnightTitle[KnightTitles.Baron][TechnologiesTableIndex],
                Technologies.R_Beautification_PrisonCage)
            table.insert(
                NeedsAndRightsByKnightTitle[KnightTitles.Baron][TechnologiesTableIndex],
                Technologies.R_Beautification_ExecutionerPlace)
            
            -- Graf
            table.insert(
                NeedsAndRightsByKnightTitle[KnightTitles.Earl][TechnologiesTableIndex],
                Technologies.R_Beautification_Flowerpot_Round)
            table.insert(
                NeedsAndRightsByKnightTitle[KnightTitles.Earl][TechnologiesTableIndex],
                Technologies.R_SpecialEdition_StatueFamily)
            table.insert(
                NeedsAndRightsByKnightTitle[KnightTitles.Earl][TechnologiesTableIndex],
                Technologies.R_Beautification_BrothersInArms)        
            
            -- Marquis
            table.insert(
                NeedsAndRightsByKnightTitle[KnightTitles.Marquees][TechnologiesTableIndex],
                Technologies.R_Beautification_StoneBench)
            table.insert(
                NeedsAndRightsByKnightTitle[KnightTitles.Marquees][TechnologiesTableIndex],
                Technologies.R_Beautification_Brazier)
            table.insert(
                NeedsAndRightsByKnightTitle[KnightTitles.Marquees][TechnologiesTableIndex],
                Technologies.R_SpecialEdition_Column)
            table.insert(
                NeedsAndRightsByKnightTitle[KnightTitles.Marquees][TechnologiesTableIndex],
                Technologies.R_Beautification_Shrine)
            table.insert(
                NeedsAndRightsByKnightTitle[KnightTitles.Marquees][TechnologiesTableIndex],
                Technologies.R_Beautification_Lantern)

            -- Herzog
            table.insert(
                NeedsAndRightsByKnightTitle[KnightTitles.Duke][TechnologiesTableIndex],
                Technologies.R_Beautification_Vase)
            table.insert(
                NeedsAndRightsByKnightTitle[KnightTitles.Duke][TechnologiesTableIndex],
                Technologies.R_Beautification_Pavilion)
            table.insert(
                NeedsAndRightsByKnightTitle[KnightTitles.Duke][TechnologiesTableIndex],
                Technologies.R_Beautification_Knight)
            table.insert(
                NeedsAndRightsByKnightTitle[KnightTitles.Duke][TechnologiesTableIndex],
                Technologies.R_Beautification_Sundial)

            -- Erzherzog
            table.insert(
                NeedsAndRightsByKnightTitle[KnightTitles.Archduke][TechnologiesTableIndex],
                Technologies.R_Beautification_TriumphalArch)
            table.insert(
                NeedsAndRightsByKnightTitle[KnightTitles.Archduke][TechnologiesTableIndex],
                Technologies.R_Beautification_VictoryColumn)

--[[
            table.insert(
                NeedsAndRightsByKnightTitle[KnightTitles.Marquees][TechnologiesTableIndex],
                Technologies.R_Beautification_Pillar)
            table.insert(
                NeedsAndRightsByKnightTitle[KnightTitles.Archduke][TechnologiesTableIndex],
                Technologies.R_Beautification_SteamMachine)
--]]

            table.insert(
                NeedsAndRightsByKnightTitle[KnightTitles.Knight][TechnologiesTableIndex],
                Technologies.R_NPC_Cloister_Wall)
            table.insert(
                NeedsAndRightsByKnightTitle[KnightTitles.Baron][TechnologiesTableIndex],
                Technologies.R_Plaza)
            table.insert(
                NeedsAndRightsByKnightTitle[KnightTitles.Earl][TechnologiesTableIndex],
                Technologies.R_WatchTower)

            -- Spearmen
            table.insert(
                NeedsAndRightsByKnightTitle[KnightTitles.Mayor][TechnologiesTableIndex],
                Technologies.R_SpearMaker)
            table.insert(
                NeedsAndRightsByKnightTitle[KnightTitles.Mayor][TechnologiesTableIndex],
                Technologies.R_BarracksSpearmen)
               
            --Cavalry
            table.insert(
                NeedsAndRightsByKnightTitle[KnightTitles.Marquees][TechnologiesTableIndex],
                Technologies.R_BarracksCavalry)
                
            --Cannon
            table.insert(
                NeedsAndRightsByKnightTitle[KnightTitles.Archduke][TechnologiesTableIndex],
                Technologies.R_Cannon)
                
            --Great Cathedral
            table.insert(
                NeedsAndRightsByKnightTitle[KnightTitles.Archduke][TechnologiesTableIndex],
                Technologies.R_Beautification_Cathedral)
                
             CreateTechnologyKnightTitleTable()
            
        end
        
    end

end

