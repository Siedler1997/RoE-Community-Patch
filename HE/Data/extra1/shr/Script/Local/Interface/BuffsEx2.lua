
-----------------------------------------------------------------------------------------
-- Overwrites for Buffs
-----------------------------------------------------------------------------------------

function InitOverwriteBuffsEx2()

    do
        local OldInitBuffs = InitBuffs
        InitBuffs = function()
    
            -- call old initializer
            OldInitBuffs()
        
            -- new buffs
            g_Buffs.Widgets[Buffs.Buff_MedicineDiversity or -1] = "/InGame/Root/Normal/AlignTopLeft/TopBar/Buffs/Buff_MedicineDiversity"
        
        end
    end

end