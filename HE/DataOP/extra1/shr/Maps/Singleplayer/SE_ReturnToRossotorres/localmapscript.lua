function Mission_LocalOnMapStart()

end		

function AddHiddenCitiesToPlayerDimplomacy()
    --By adding players into internal g_DiscoveredPlayers table, they appear in diplomacy window
    --Even without actually discovering them
    if g_DiscoveredPlayers == nil then
        g_DiscoveredPlayers = {}
    end

    g_DiscoveredPlayers[2] = true
    g_DiscoveredPlayers[4] = true
end