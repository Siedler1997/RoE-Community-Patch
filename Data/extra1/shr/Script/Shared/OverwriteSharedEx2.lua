
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
            table.insert(
                NeedsAndRightsByKnightTitle[KnightTitles.Archduke][TechnologiesTableIndex],
                Technologies.R_Beautification_Cathedral)
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
                
             CreateTechnologyKnightTitleTable()
            
        end
        
    end

end

