-----------------------------------------------------------------------------------------
-- Generic overwrites
-----------------------------------------------------------------------------------------
function InitLocalOverwriteEx2()

    do
        local OldGameCallback_LocalSetDefaultValues = GameCallback_LocalSetDefaultValues
    
        function GameCallback_LocalSetDefaultValues()
        
            OldGameCallback_LocalSetDefaultValues()
       
            KnightGender[Entities.U_KnightSaraya] = "female"
            KnightGender[Entities.U_KnightKhana] = "female"
            KnightGender[Entities.U_KnightPraphat] = "male"
            KnightGender[Entities.U_NPC_Castellan_ME] = "male"
            KnightGender[Entities.U_NPC_Castellan_NE] = "male"
            KnightGender[Entities.U_NPC_Castellan_NA] = "male"
            KnightGender[Entities.U_NPC_Castellan_SE] = "male"
            KnightGender[Entities.U_NPC_Castellan_AS] = "male"
        end
    end    

end

