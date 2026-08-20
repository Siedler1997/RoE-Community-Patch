
-----------------------------------------------------------------------------------------
-- Overwrites for LocalMusicSystem
-----------------------------------------------------------------------------------------

function InitOverwriteLocalMusicSystemEx2()

    do
        local OldInitMusicSystem = InitMusicSystem
        function InitMusicSystem()
            OldInitMusicSystem()

            MusicSystem.EventPromotionMusic     = "config\\sound\\PlaylistEventPromotion.xml"
            MusicSystem.EventPromotion2Music    = "config\\sound\\PlaylistEventPromotion2.xml"

            MusicSystem.EventEpidemic           = "config\\sound\\PlaylistEventPlague.xml"
            MusicSystem.EventAnimalPlague       = "config\\sound\\PlaylistEventPlague.xml"
            MusicSystem.EventPlague             = "config\\sound\\PlaylistEventPlague.xml"
        end
    end
end