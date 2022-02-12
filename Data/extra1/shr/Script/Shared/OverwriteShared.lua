
function InitSharedOverwrite()

-- be careful, this table must have the same order like the "CustomGame.KnightTypes"-table *really ugly*
    MPDefaultKnightNames = {"U_KnightSaraya",
    "U_KnightTrading",
    "U_KnightChivalry",
    "U_KnightWisdom",
    "U_KnightHealing",
    "U_KnightPlunder",
    "U_KnightSong" }

    
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
            
            -- Cistern
            table.insert(
                NeedsAndRightsByKnightTitle[KnightTitles.Mayor][TechnologiesTableIndex],
                Technologies.R_Cistern)
                
            -- Embellishments Marquees
            table.insert(
                NeedsAndRightsByKnightTitle[KnightTitles.Marquees][TechnologiesTableIndex],
                Technologies.R_Beautification_Brazier)
            
            table.insert(
                NeedsAndRightsByKnightTitle[KnightTitles.Marquees][TechnologiesTableIndex],
                Technologies.R_Beautification_Pillar)
            table.insert(
                NeedsAndRightsByKnightTitle[KnightTitles.Marquees][TechnologiesTableIndex],
                Technologies.R_Beautification_Shrine)
                
            -- Embellishments Duke
            table.insert(
                NeedsAndRightsByKnightTitle[KnightTitles.Duke][TechnologiesTableIndex],
                Technologies.R_Beautification_StoneBench)
            table.insert(
                NeedsAndRightsByKnightTitle[KnightTitles.Duke][TechnologiesTableIndex],
                Technologies.R_Beautification_Sundial)
            table.insert(
                NeedsAndRightsByKnightTitle[KnightTitles.Duke][TechnologiesTableIndex],
                Technologies.R_Beautification_Vase)
                
                
             -- Embellishments Archduke
            table.insert(
                NeedsAndRightsByKnightTitle[KnightTitles.Archduke][TechnologiesTableIndex],
                Technologies.R_Beautification_TriumphalArch)
                
            table.insert(
                NeedsAndRightsByKnightTitle[KnightTitles.Archduke][TechnologiesTableIndex],
                Technologies.R_Beautification_VictoryColumn)
                
                
             CreateTechnologyKnightTitleTable()
            
        end
        
    end
end

function GetPlayerCategoryType(_PlayerID)

    local PlayerCategory

    local CastleID = Logic.GetHeadquarters(_PlayerID)

    if CastleID ~= 0 then

        PlayerCategory = PlayerCategories.City

    else

        local StoreHouseID = Logic.GetStoreHouse(_PlayerID)

        if StoreHouseID ~= 0 then

            if Logic.GetEntityType(StoreHouseID) == Entities.B_NPC_Cloister_ME
            or Logic.GetEntityType(StoreHouseID) == Entities.B_NPC_Cloister_SE
            or Logic.GetEntityType(StoreHouseID) == Entities.B_NPC_Cloister_NA
            or Logic.GetEntityType(StoreHouseID) == Entities.B_NPC_Cloister_NE
            or Logic.GetEntityType(StoreHouseID) == Entities.B_NPC_Cloister_AS
            then

                PlayerCategory = PlayerCategories.Cloister

            elseif Logic.GetEntityType(StoreHouseID) == Entities.B_NPC_ShipsStorehouse then

                PlayerCategory = PlayerCategories.Harbour

            elseif Logic.IsEntityInCategory(StoreHouseID, EntityCategories.VillageStorehouse) == 1 then

                PlayerCategory = PlayerCategories.Village

            else

                PlayerCategory = PlayerCategories.BanditsCamp

            end
        end

    end

    return PlayerCategory

end



