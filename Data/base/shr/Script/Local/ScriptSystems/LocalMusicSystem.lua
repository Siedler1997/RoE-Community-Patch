--++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
-- Musik Script
--++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++

MusicSystem = {}
MusicSystem.MusicOn = true

function InitMusicSystem()

    MusicSystem.EventFestivalMusic      = "config\\sound\\PlaylistEventFestival.xml"
    MusicSystem.EventPromotionMusic     = "config\\sound\\PlaylistEventPromotion.xml"
    MusicSystem.EventPromotion2Music    = "config\\sound\\PlaylistEventPromotion2.xml"
    MusicSystem.EventBlaze              = "config\\sound\\PlaylistEventBlaze.xml"
    MusicSystem.EventSinging            = "config\\sound\\PlaylistEventSinging.xml"
    MusicSystem.GameWon                 = "config\\sound\\PlaylistEventGameWon.xml"
    MusicSystem.GameLost                = "config\\sound\\PlaylistEventGameLost.xml"

    MusicSystem.EventEpidemic           = "config\\sound\\PlaylistEventPlague.xml"
    MusicSystem.EventAnimalPlague       = "config\\sound\\PlaylistEventPlague.xml"
    MusicSystem.EventPlague             = "config\\sound\\PlaylistEventPlague.xml"
    MusicSystem.EventLocust             = "config\\sound\\PlaylistEventBlaze.xml"
    MusicSystem.EventVikings            = "config\\sound\\PlaylistEventBlaze.xml"
    MusicSystem.EventStorm              = "config\\sound\\PlaylistEventBlaze.xml"
    MusicSystem.AttackingWolves         = "config\\sound\\PlaylistEventBlaze.xml"
        
end



function StartEventMusic(_Music, _PlayerID)

    if _PlayerID == GUI.GetPlayerID() then
        Sound.MusicStartEventPlaylist(_Music)
    end

end


function StopEventMusic(_Music, _PlayerID)

    if _PlayerID == GUI.GetPlayerID() then
       Sound.MusicStopEventPlaylist(_Music)
    end
    
end
