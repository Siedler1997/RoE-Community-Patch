-----------------------------------------------------------------------------------------
-- Overwrites for Multiplayer
-----------------------------------------------------------------------------------------

function InitOverwriteMultiplayerEx2()

    --------------------------------------------------------------------------
    --  Get player knight type for MP
    --------------------------------------------------------------------------
    do 
        function GetKnightTypeIDForMPGame(_KnightIndex, _PlayerID)
            local MapName = Framework.GetCurrentMapName()
            local MapType = Framework.GetCurrentMapTypeAndCampaignName()
    
            local KnightNames = {GetMPValidKnightNames(MapName, MapType)}
            local ValidKnightNames = {Framework.GetValidKnightNames(MapName, MapType)}

            -- MaMa: Have to handle _KnightIndex being a type rather than an index (when
            -- restarting map) -- I hope what I'm doing is right...
            -- Arguably, one could simply return an invalid index, assuming it is an
            -- entity type, but I decided to play it safe.
            --
            --Finally fixed...
            if _KnightIndex > 20 then
                --Ein Index von >20 bedeutet: type statt index (tritt bei Restart der Map auf)
                return _KnightIndex
            else
                if #ValidKnightNames == 0 then
                    return Entities[KnightNames[_KnightIndex]]
                else
                    return Entities[MPDefaultKnightNames[_KnightIndex]] 
                end
            end
            return -1
        end
    end

end