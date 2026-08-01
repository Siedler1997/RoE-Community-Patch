
-----------------------------------------------------------------------------------------
-- Overwrites for TexturePositions
-----------------------------------------------------------------------------------------

function InitOverwriteTexturePositionsEx2()

    do 
        local OldInitTexturePositions = InitTexturePositions
        InitTexturePositions = function()
            
            --call old initializer
            OldInitTexturePositions()
            
            -- Goods
            g_TexturePositions.Goods[Goods.G_Regalia] =  {16, 4}
            g_TexturePositions.Goods[Goods.G_PoorSpear] =  {2, 1, 2}
            g_TexturePositions.Goods[Goods.G_Spear] =  {2, 2, 2}
            
            -- Entity Types
            g_TexturePositions.Entities[Entities.B_Outpost_AS] = {12, 3}
            g_TexturePositions.Entities[Entities.B_SpearMaker] =  g_TexturePositions.Goods[Goods.G_PoorSpear]
            g_TexturePositions.Entities[Entities.B_BarracksSpearmen] =  g_TexturePositions.Goods[Goods.G_Spear]
            g_TexturePositions.Entities[Entities.B_BarracksCavalry] =  {2, 3, 2}
            
            g_TexturePositions.Entities[Entities.U_NPC_Castellan_ME] = {7, 2, 1}
            g_TexturePositions.Entities[Entities.U_NPC_Castellan_NE] = {7, 2, 1}
            g_TexturePositions.Entities[Entities.U_NPC_Castellan_SE] = {7, 2, 1}
            g_TexturePositions.Entities[Entities.U_NPC_Castellan_NA] = {7, 2, 1}
            g_TexturePositions.Entities[Entities.U_NPC_Castellan_AS] = {7, 2, 1}

            g_TexturePositions.Entities[Entities.U_TrebuchetCart] = {3, 3, 2}
            g_TexturePositions.Entities[Entities.U_MilitaryTrebuchet] = {3, 1, 2}
            g_TexturePositions.Entities[Entities.U_MilitarySword_RedPrince] = {1, 1, 2}
            g_TexturePositions.Entities[Entities.U_MilitaryBow_RedPrince] = {1, 2, 2}
            g_TexturePositions.Entities[Entities.U_Bear]    = {13, 8}
            g_TexturePositions.Entities[Entities.U_BlackBear]    = {13, 8}
            g_TexturePositions.Entities[Entities.U_PolarBear]    = {13, 8}
            g_TexturePositions.Entities[Entities.U_Wolf_Grey]    = {13, 8}
            g_TexturePositions.Entities[Entities.U_Wolf_White]    = {13, 8}
            g_TexturePositions.Entities[Entities.U_Wolf_Black]    = {13, 8}
            g_TexturePositions.Entities[Entities.U_Wolf_Brown]    = {13, 8}
            g_TexturePositions.Entities[Entities.U_Lion_Male]    = {13, 8}
            g_TexturePositions.Entities[Entities.U_Lion_Female]    = {13, 8}
            g_TexturePositions.Entities[Entities.U_Tiger]    = {1, 8, 1}
            g_TexturePositions.Entities[Entities.U_Tiger_White]    = {1, 8, 1}
            g_TexturePositions.Entities[Entities.U_Cat1]    = {13, 8}
            g_TexturePositions.Entities[Entities.U_Cat2]    = {13, 8}
            g_TexturePositions.Entities[Entities.U_Cat3]    = {13, 8}
            g_TexturePositions.Entities[Entities.U_Cat4]    = {13, 8}
            g_TexturePositions.Entities[Entities.U_Dog1]    = {13, 8}
            g_TexturePositions.Entities[Entities.U_Dog2]    = {13, 8}
            g_TexturePositions.Entities[Entities.U_Dog3]    = {13, 8}
            g_TexturePositions.Entities[Entities.A_AS_Tiger_White] = {1, 8, 1}
            g_TexturePositions.Entities[Entities.B_GuardTower_ME]    = {12, 3}
            g_TexturePositions.Entities[Entities.B_GuardTower_NE]    = {12, 3}
            g_TexturePositions.Entities[Entities.B_GuardTower_SE]    = {12, 3}
            g_TexturePositions.Entities[Entities.B_GuardTower_NA]    = {12, 3}
            g_TexturePositions.Entities[Entities.B_GuardTower_AS]    = {12, 3}
            g_TexturePositions.Entities[Entities.B_WatchTower_ME]    = {7, 6}
            g_TexturePositions.Entities[Entities.B_WatchTower_NE]    = {7, 6}
            g_TexturePositions.Entities[Entities.B_WatchTower_SE]    = {7, 6}
            g_TexturePositions.Entities[Entities.B_WatchTower_NA]    = {7, 6}
            g_TexturePositions.Entities[Entities.B_WatchTower_AS]    = {7, 6}
            g_TexturePositions.Entities[Entities.B_Beautification_Cathedral] = {7, 3, 1}
            g_TexturePositions.Entities[Entities.U_MilitarySpear] = {1, 4, 2}
            g_TexturePositions.Entities[Entities.U_Helbardier] = {2, 2, 2}
            g_TexturePositions.Entities[Entities.U_MilitaryCavalry] = {1, 5, 2}
            g_TexturePositions.Entities[Entities.U_CannonCart] = {3, 2, 2}
            g_TexturePositions.Entities[Entities.U_MilitaryCannon] = {3, 1, 2}
            g_TexturePositions.Entities[Entities.U_MagicOx] = {7, 3}
            g_TexturePositions.Entities[Entities.U_Dragon] = {7, 3}
            
            -- Technologies
            g_TexturePositions.Technologies[Technologies.R_WatchTower]                      = {7, 6}
            g_TexturePositions.Technologies[Technologies.R_Plaza]                           = {5, 14}
            g_TexturePositions.Technologies[Technologies.R_SpecialEdition2]                 = {16, 4}
            g_TexturePositions.Technologies[Technologies.R_SpearMaker]    = {2, 1, 2}
            g_TexturePositions.Technologies[Technologies.R_BarracksSpearmen]    = {2, 2, 2}
            g_TexturePositions.Technologies[Technologies.R_BarracksCavalry]    = {2, 3, 2}
            g_TexturePositions.Technologies[Technologies.R_Cannon] = g_TexturePositions.Entities[Entities.U_MilitaryCannon]
            g_TexturePositions.Technologies[Technologies.R_Beautification_Cathedral] = {7, 3, 1}

        end
    end

end