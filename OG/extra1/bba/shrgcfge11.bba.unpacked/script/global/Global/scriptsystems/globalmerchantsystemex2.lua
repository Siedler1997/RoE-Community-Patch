-----------------------------------------------------------------------------------------
-- Overwrites for GlobalMerchantSystem
-----------------------------------------------------------------------------------------

function InitOverwriteGlobalMerchantSystemEx2()

    --------------------------------------------------------------------------
    --  GlobalMerchantSystem
    --------------------------------------------------------------------------
    do 
        local OldInitGlobalMerchantSystem = InitGlobalMerchantSystem
        
        InitGlobalMerchantSystem = function()
        
            -- call old initializeer
            OldInitGlobalMerchantSystem()
            
            -- add new stuff
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

        end
    end

end