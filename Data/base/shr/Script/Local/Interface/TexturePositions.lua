

function InitTexturePositions()

    g_TexturePositions = {}

    g_TexturePositions.Goods = {
    [Goods.G_Banner]                        = {3, 3},
    [Goods.G_Beer]                          = {2, 13},
    [Goods.G_Bow]                           = {5, 4},
    [Goods.G_Bread]                         = {2, 5},
    [Goods.G_Broom]                         = {1, 3},
    [Goods.G_Candle]                        = {3, 2},
    [Goods.G_Carcass]                       = {1, 14},
    [Goods.G_CatapultAmmunition]            = {1, 10},
    [Goods.G_Cheese]                        = {2, 7},
    [Goods.G_Clothes]                       = {1, 11},
    [Goods.G_Cow]                           = {3, 16},
    [Goods.G_Dye]                           = {5, 11},
    [Goods.G_EntBaths]                      = {2, 14},
    [Goods.G_EntTheatre]                    = {16, 2},
    [Goods.G_EntertainmentBard]             = {5, 12},
    [Goods.G_EntertainmentCathedral]        = {4, 14},
    [Goods.G_Gold]                          = {1, 8},
    [Goods.G_Grain]                         = {1, 13},
    [Goods.G_Herb]                          = {2, 2},
    [Goods.G_Honeycomb]                     = {2, 1},
    [Goods.G_Information]                   = {5, 6},
    [Goods.G_Iron]                          = {2, 4},
    [Goods.G_Leather]                       = {1, 12},
    [Goods.G_MedicinLadyHealing]            = {11, 2},
    [Goods.G_Medicine]                      = {2, 10},
    [Goods.G_Milk]                          = {2, 16},
    [Goods.G_None]                          = {8, 16},
    [Goods.G_Ornament]                      = {1, 5},
    [Goods.G_PlayMaterial]                  = {16, 2},
    [Goods.G_PoorBow]                       = {2, 11},
    [Goods.G_PoorSword]                     = {2, 12},
    [Goods.G_RawFish]                       = {1, 15},
    [Goods.G_Salt]                          = {5, 10},
    [Goods.G_Sausage]                       = {2, 6},
    [Goods.G_Sheep]                         = {4, 1},
    [Goods.G_SiegeEnginePart]               = {2, 15},
    [Goods.G_Sign]                          = {3, 1},
    [Goods.G_SmokedFish]                    = {2, 8},
    [Goods.G_Soap]                          = {2, 9},
    [Goods.G_Stone]                         = {1, 10},
    [Goods.G_Sword]                         = {5, 5},
    [Goods.G_TorchAmmunition]               = {11, 4},
    [Goods.G_BombAmmunition]                = {11, 4},
    [Goods.G_Water]                         = {1, 16},
    [Goods.G_Wood]                          = {1, 9},
    [Goods.G_Wool]                          = {2, 3},
    [Goods.G_Regalia]                       = {16, 4}
    
    }

    g_TexturePositions.Entities = {
    [Entities.U_KnightChivalry]             = {6, 9},
    [Entities.U_KnightHealing]              = {6, 5},
    [Entities.U_KnightPlunder]              = {6, 12},
    [Entities.U_KnightSabatta]              = {6, 10},
    [Entities.U_KnightRedPrince]            = {6, 8},
    [Entities.U_KnightSong]                 = {6, 7},
    [Entities.U_KnightTrading]              = {6, 6},
    [Entities.U_KnightWisdom]               = {6, 11},
    [Entities.U_Thief]                      = {5, 13},
    [Entities.U_AmmunitionCart]             = {10, 4},
    [Entities.U_BatteringRamCart]           = {9, 5},
    [Entities.U_CatapultCart]               = {9, 4},
    [Entities.U_TrebuchetCart]              = {9, 4},
    [Entities.U_SiegeTowerCart]             = {9, 6},
    [Entities.U_MilitaryBallista]           = {10, 5},
    [Entities.U_MilitaryBandit_Melee_ME]    = {9, 9},
    [Entities.U_MilitaryBandit_Melee_NA]    = {9, 11},
    [Entities.U_MilitaryBandit_Melee_NE]    = {9, 13},
    [Entities.U_MilitaryBandit_Melee_SE]    = {9, 15},
    [Entities.U_MilitaryBandit_Ranged_ME]   = {9, 10},
    [Entities.U_MilitaryBandit_Ranged_NA]   = {9, 12},
    [Entities.U_MilitaryBandit_Ranged_NE]   = {9, 14},
    [Entities.U_MilitaryBandit_Ranged_SE]   = {9, 16},
    [Entities.U_MilitaryBatteringRam]       = {9, 2},
    [Entities.U_MilitaryBow]                = {9, 8},
    [Entities.U_MilitaryCatapult]           = {9, 1},
    [Entities.U_MilitaryTrebuchet]          = {9, 1},
    [Entities.U_Trebuchet]                  = {9, 1},
    [Entities.U_MilitarySiegeTower]         = {9, 3},
    [Entities.U_MilitarySword]              = {9, 7},
    [Entities.U_MilitaryTrap]               = {10, 6},
    [Entities.U_MilitarySword_RedPrince]    = {9, 7},
    [Entities.U_MilitaryBow_RedPrince]      = {9, 8},
    [Entities.U_Medicus]                    = {2, 10},
    [Entities.U_MilitaryLeader]             = {7, 11},

    [Entities.U_TaxCollector]               = {14, 13},
    [Entities.U_GoldCart]                   = {7, 1},
    [Entities.U_GoldCart_Mission]           = {7, 1},
    [Entities.U_Noblemen_Cart]              = {7, 1},
    [Entities.U_RegaliaCart]                = {7, 1},
    [Entities.U_ThiefCart]                  = {7, 1},
    [Entities.U_PrisonCart]                 = {7, 1},
    [Entities.U_ResourceMerchant]           = {7, 1},
    [Entities.U_Marketer]                   = {7, 1},
    [Entities.U_FireEater]                  = {5, 12},--TODO: to be deleted
    [Entities.U_Entertainer_NA_FireEater]   = {5, 12},
    [Entities.U_Entertainer_NA_StiltWalker] = {5, 12},
    [Entities.U_Entertainer_NE_StrongestMan_Barrel] = {5, 12},
    [Entities.U_Entertainer_NE_StrongestMan_Stone]  = {5, 12},

    [Entities.A_X_Sheep01]                  = {4, 1},
    [Entities.A_X_Cow01]                    = {3, 16},
    [Entities.A_ME_Bear]                    = {13, 8},
    [Entities.A_ME_Bear_black]              = {13, 8},
    [Entities.A_NE_PolarBear]               = {13, 8},
    
    [Entities.A_NA_Lion_Female]             = {13, 8},
    [Entities.A_NA_Lion_Male]               = {13, 8},

    [Entities.R_IronMine]                   = {8, 14},
    [Entities.R_StoneMine]                  = {8, 10},

    [Entities.B_Outpost_ME]                 = {12, 3},
    [Entities.B_Outpost_NE]                 = {12, 3},
    [Entities.B_Outpost_NA]                 = {12, 3},
    [Entities.B_Outpost_SE]                 = {12, 3},
    [Entities.B_BuildingPlot_8x8]           = {12, 3}, --Outpost building site; hack for tutorial
    [Entities.B_Castle_ME]                  = {3, 14},
    [Entities.B_Castle_NE]                  = {3, 14},
    [Entities.B_Castle_SE]                  = {3, 14},
    [Entities.B_Castle_NA]                  = {3, 14},
    [Entities.B_StoreHouse]                 = {3, 13},
    [Entities.B_NPC_StoreHouse_ME]          = {3, 13},
    [Entities.B_NPC_StoreHouse_NE]          = {3, 13},
    [Entities.B_NPC_StoreHouse_SE]          = {3, 13},
    [Entities.B_NPC_StoreHouse_NA]          = {3, 13},
    [Entities.B_Cathedral]                  = {3, 12},
    [Entities.B_PalisadeGate]               = {3, 7},
    [Entities.B_PalisadeSegment]            = {3, 7},
    [Entities.B_WallGate_NE]                = {3, 10},
    [Entities.B_WallGate_ME]                = {3, 10},
    [Entities.B_WallGate_SE]                = {3, 10},
    [Entities.B_WallGate_NA]                = {3, 10},
    [Entities.B_WallGateTurret_NE]          = {3, 10},
    [Entities.B_WallGateTurret_ME]          = {3, 10},
    [Entities.B_WallGateTurret_SE]          = {3, 10},
    [Entities.B_WallGateTurret_NA]          = {3, 10},
    
    [Entities.B_Marketplace_ME]             = {5, 14},
    [Entities.B_Marketplace_SE]             = {5, 14},
    [Entities.B_Marketplace_NA]             = {5, 14},
    [Entities.B_Marketplace_NE]             = {5, 14},
    
    [Entities.B_Bakery]                     = g_TexturePositions.Goods[Goods.G_Bread],
    [Entities.B_BannerMaker]                = g_TexturePositions.Goods[Goods.G_Banner],
    [Entities.B_Barracks]                   = g_TexturePositions.Goods[Goods.G_Sword],
    [Entities.B_BarracksArchers]            = g_TexturePositions.Goods[Goods.G_Bow],
    [Entities.B_Baths]                      = g_TexturePositions.Goods[Goods.G_EntBaths],
    [Entities.B_Beehive]                    = {14, 3},
    [Entities.B_Beekeeper]                  = g_TexturePositions.Goods[Goods.G_Honeycomb],
    [Entities.B_Blacksmith]                 = g_TexturePositions.Goods[Goods.G_Ornament],
    [Entities.B_BowMaker]                   = g_TexturePositions.Goods[Goods.G_PoorBow],
    [Entities.B_BroomMaker]                 = g_TexturePositions.Goods[Goods.G_Broom],
    [Entities.B_Butcher]                    = g_TexturePositions.Goods[Goods.G_Sausage],
    [Entities.B_CandleMaker]                = g_TexturePositions.Goods[Goods.G_Candle],
    [Entities.B_Carpenter]                  = g_TexturePositions.Goods[Goods.G_Sign],
    [Entities.B_CattleFarm]                 = g_TexturePositions.Goods[Goods.G_Milk],
    [Entities.B_CattlePasture]              = {4, 16},
    [Entities.B_Dairy]                      = g_TexturePositions.Goods[Goods.G_Cheese],
    [Entities.B_FishingHut]                 = g_TexturePositions.Goods[Goods.G_RawFish],
    [Entities.B_GrainFarm]                  = g_TexturePositions.Goods[Goods.G_Grain],
    [Entities.B_GrainField_ME]              = {14, 2},
    [Entities.B_GrainField_NA]              = {14, 2},
    [Entities.B_GrainField_NE]              = {14, 2},
    [Entities.B_GrainField_SE]              = {14, 2},
    [Entities.B_HerbGatherer]               = g_TexturePositions.Goods[Goods.G_Herb],
    [Entities.B_HuntersHut]                 = g_TexturePositions.Goods[Goods.G_Carcass],
    [Entities.B_IronMine]                   = g_TexturePositions.Goods[Goods.G_Iron],
    [Entities.B_Pharmacy]                   = g_TexturePositions.Goods[Goods.G_Medicine],
    [Entities.B_SheepFarm]                  = g_TexturePositions.Goods[Goods.G_Wool],
    [Entities.B_SheepPasture]               = {4, 16},
    [Entities.B_SiegeEngineWorkshop]        = g_TexturePositions.Goods[Goods.G_SiegeEnginePart],
    [Entities.B_SmokeHouse]                 = g_TexturePositions.Goods[Goods.G_SmokedFish],
    [Entities.B_Soapmaker]                  = g_TexturePositions.Goods[Goods.G_Soap],
    [Entities.B_StoneQuarry]                = g_TexturePositions.Goods[Goods.G_Stone],
    [Entities.B_SwordSmith]                 = g_TexturePositions.Goods[Goods.G_PoorSword],
    [Entities.B_Tanner]                     = g_TexturePositions.Goods[Goods.G_Leather],
    [Entities.B_Tavern]                     = g_TexturePositions.Goods[Goods.G_Beer],
    [Entities.B_Theatre]                    = g_TexturePositions.Goods[Goods.G_PlayMaterial],
    [Entities.B_Weaver]                     = g_TexturePositions.Goods[Goods.G_Clothes],
    [Entities.B_Woodcutter]                 = g_TexturePositions.Goods[Goods.G_Wood],
    [Entities.B_NPC_Tent_Information]       = {13,4},

    [Entities.B_SpecialEdition_Column]            = {15, 8},
    [Entities.B_SpecialEdition_Pavilion]          = {15, 11},
    [Entities.B_SpecialEdition_StatueDario]       = {15, 10},
    [Entities.B_SpecialEdition_StatueFamily]      = {15, 9},
    [Entities.B_SpecialEdition_StatueProduction]  = {15, 13},
    [Entities.B_SpecialEdition_StatueSettler]     = {15, 12},
    
    [Entities.I_X_CloisterBuildingsSite]    = {14, 15},
    
    -- Just dummy icons, but maybe good enough?
    [Entities.B_NPC_BanditsHQ_ME] = {13, 4},
    [Entities.B_NPC_BanditsHQ_NE] = {13, 4},
    [Entities.B_NPC_BanditsHQ_SE] = {13, 4},
    [Entities.B_NPC_BanditsHQ_NA] = {13, 4},
   
    }



    g_TexturePositions.EntityCategories = {
    [EntityCategories.GC_Food_Supplier]         = {1, 1},
    [EntityCategories.GC_Clothes_Supplier]      = {1, 2},
    [EntityCategories.GC_Hygiene_Supplier]      = {16, 1},
    [EntityCategories.GC_Entertainment_Supplier]= {2, 13}    --{1, 4} -- Show met instead of global entertainment icon, because player has to produce met
    }
    
    g_TexturePositions.Needs = {
    [Needs.Nutrition]       =   {1, 1},
    [Needs.Clothes]         =   {1, 2},
    [Needs.Hygiene]         =   {16, 1},
    [Needs.Entertainment]   =   {1, 4},
    [Needs.Wealth]          =   {16, 3},
    [Needs.Prosperity]      =   {1, 6}
    }
 
    g_TexturePositions.Technologies = {
    [Technologies.R_Construction]   = {3, 4},
    [Technologies.R_Wall]           = {3, 9},
    [Technologies.R_Pallisade]      = {3, 7},
    [Technologies.R_Trail]          = {3, 6},    
    [Technologies.R_Street]         = {3, 5},
    
    [Technologies.R_Military]       = {1, 7},    
    [Technologies.R_SwordSmith]     = {2, 12},
    [Technologies.R_BowMaker]       = {2, 11}, 
    [Technologies.R_Barracks]       = {5, 5},
    [Technologies.R_BarracksArchers]= {5, 4},
    
    [Technologies.R_SiegeEngineWorkshop]    = {2, 15},
    [Technologies.R_BatteringRam]           = g_TexturePositions.Entities[Entities.U_BatteringRamCart],
    [Technologies.R_Ballista]               = g_TexturePositions.Entities[Entities.U_MilitaryBallista],
    [Technologies.R_Catapult]               = g_TexturePositions.Entities[Entities.U_MilitaryCatapult],
    [Technologies.R_SiegeTower]             = g_TexturePositions.Entities[Entities.U_MilitarySiegeTower],
    [Technologies.R_AmmunitionCart]         = g_TexturePositions.Entities[Entities.U_AmmunitionCart],
    
    [Technologies.R_Gathering]    = {3, 4},
    [Technologies.R_SheepFarm]    = {2, 3},
    [Technologies.R_Beekeeper]    = {2, 1},
    [Technologies.R_HerbGatherer] = {2, 2},
    [Technologies.R_Woodcutter]   = {1, 9},
    [Technologies.R_StoneQuarry]  = {1, 10},
    [Technologies.R_IronMine]     = {2, 4},
    [Technologies.R_HuntersHut]   = {1, 14},
    [Technologies.R_FishingHut]   = {1, 15},
    [Technologies.R_CattleFarm]   = {2, 16},
    [Technologies.R_GrainFarm]    = {1, 13},
    
    [Technologies.R_Nutrition]  = g_TexturePositions.Needs[Needs.Nutrition],
    [Technologies.R_Bakery]     = {2, 5},
    [Technologies.R_Dairy]      = {2, 7},
    [Technologies.R_Butcher]    = {2, 6},
    [Technologies.R_SmokeHouse] = {2, 8},
    
    [Technologies.R_Clothes]    = g_TexturePositions.Needs[Needs.Clothes],
    [Technologies.R_Weaver]     = {1, 11},
    [Technologies.R_Tanner]     = {1, 12},

    [Technologies.R_Hygiene]    = g_TexturePositions.Needs[Needs.Hygiene],
    [Technologies.R_Soapmaker]  = {2, 9},
    [Technologies.R_BroomMaker] = {1, 3},
    
    [Technologies.R_Entertainment]  = g_TexturePositions.Needs[Needs.Entertainment],
    [Technologies.R_Tavern]         = {2, 13}, 
    [Technologies.R_Theater]        = {16, 2},
    [Technologies.R_Baths]          = {2, 14},
    
    [Technologies.R_Wealth]         = g_TexturePositions.Needs[Needs.Wealth],
    [Technologies.R_BannerMaker]    = {3, 3},
    [Technologies.R_Carpenter]      = {3, 1},
    [Technologies.R_Blacksmith]     = {1, 5},
    [Technologies.R_CandleMaker]    = {3, 2},
    
    [Technologies.R_Medicine]       = {2, 10},
    
    [Technologies.R_Prosperity] = g_TexturePositions.Needs[Needs.Prosperity],
    [Technologies.R_Taxes]      = {1, 6},
    
    [Technologies.R_Festival]   = {4, 15},
    --[Technologies.R_Trade]      =
    [Technologies.R_Sermon]     = {4, 14},
    [Technologies.R_Thieves]    = {5, 13},
    [Technologies.R_Victory]    = {7, 5},
    [Technologies.R_KnockDown]  = {3, 15}
    }

    g_TexturePositions.KnightTitles = {
    [KnightTitles.Knight]           =   {10, 16},
    [KnightTitles.Mayor]            =   {10, 15},
    [KnightTitles.Baron]            =   {10, 14},
    [KnightTitles.Earl]             =   {10, 13},
    [KnightTitles.Marquees]         =   {10, 12},
    [KnightTitles.Duke]             =   {10, 11},
    [KnightTitles.Archduke]         =   {10, 10}
    }

    g_TexturePositions.QuestTypes       = {
    [Objective.Deliver]                 = {7, 1},
    [Objective.Protect]                 = {7, 2},
    [Objective.DestroyPlayers]          = {7, 3},
    [Objective.DestroyAllPlayerUnits]   = {7, 3},
    [Objective.DestroyEntities]         = {7, 4},
    [Objective.Capture]                 = {7, 5},
    [Objective.Discover]                = {7, 6},
    ["CreateMilitary"]                  = {7, 11},
    ["CreateOther"]                     = {8, 1},
    [Objective.Diplomacy]               = {7, 8},
    --[Objective.KnightTitle]             = {7, 9}, use specific Knight Title icons instead
    [Objective.Object]                  = {14, 10},
    [Objective.Claim]                   = {12, 3},
    [Objective.Steal]                   = {5, 13},
    ["SatisfyNeedNutrition"]            = g_TexturePositions.Needs[Needs.Nutrition],
    ["SatisfyNeedClothes"]              = g_TexturePositions.Needs[Needs.Clothes],
    ["SatisfyNeedHygiene"]              = g_TexturePositions.Needs[Needs.Hygiene],
    ["SatisfyNeedMedicine"]             = {2, 10},
    ["SatisfyNeedEntertainment"]        = g_TexturePositions.Needs[Needs.Entertainment],
    [Objective.SettlersNumber]          = {5, 16},
    [Objective.Distance]                = {7, 10},
    [Objective.Spouses]                 = {5, 15},
    [Objective.Custom]                  = {16, 5},
    [Objective.Custom2]                 = {16, 5},
    [Objective.BuildRoad]               = {3, 6},
    [Objective.NoChange]                = {16, 5}
    
    }

    g_TexturePositions.PlayerCategories = {
    [PlayerCategories.City]             = {13, 1},
    [PlayerCategories.Village]          = {13, 2},
    [PlayerCategories.Cloister]         = {13, 3},
    [PlayerCategories.BanditsCamp]      = {13, 4},
    [PlayerCategories.Harbour]          = {13, 5},
    ["Vikings"]                         = {13, 7}
    }

    g_TexturePositions.SoldierStrength  = {
    [1]                                 = {15, 1},
    [2]                                 = {15, 2},
    [3]                                 = {15, 3},
    [4]                                 = {15, 4},
    [5]                                 = {15, 5}
    }
    
end