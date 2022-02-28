----------------------------------------------------------------------------------------------------
--SharedMultiplayer.lua
-- shared between global file multiplayer.lua and in menu AspectGameConfig.lua/CreateGamePage.lua
----------------------------------------------------------------------------------------------------
MPDefaultPlayerColors = {1,2,3,4}
--MPDefaultPlayerColors = {1,2,3,4,17,18,19,23}

MPDefaultKnightNames = {"U_KnightTrading", "U_KnightHealing", "U_KnightChivalry", 
                         "U_KnightWisdom","U_KnightPlunder", "U_KnightSong",
                         "U_KnightSabatta", "U_KnightRedPrince"}

MPDefaultVictoryConditions = {"Default", "InvadeMarketplace", "KnightTitle", "DestroyOnlySpecialBuilding"}
--MPDefaultVictoryConditions = {"Default", "KnightTitle", "CastleDefense"}

MPDefaultResourceModificators = {"Standard", "UpperLimitResources"}


----------------------------------------------------------------------------------------------------
function GetMPValidPlayerColors(_MapName, _MapType)

    local PlayerColors = {Framework.GetValidPlayerColors(_MapName, _MapType)}
    
    if #PlayerColors == 0 then
        return unpack(MPDefaultPlayerColors) -- unpack : this lua function just list all the elements of a table 
    else                                     -- example : if table={1,2,3} unpack(table) will return 1,2,3
        return unpack(PlayerColors) --this way, you just have to store the result in a table when calling this function  :  result = { function() }
    end
end
----------------------------------------------------------------------------------------------------
function GetMPValidKnightNames(_MapName, _MapType)

    local KnightNames = {Framework.GetValidKnightNames(_MapName, _MapType)}
    
    if #KnightNames == 0 then
        return unpack(MPDefaultKnightNames)
    else
       return unpack(KnightNames)
    end
    

end
----------------------------------------------------------------------------------------------------
function GetMPValidVictoryConditions(_MapName, _MapType)

    local VictoryConditions = {Framework.GetValidVictoryConditions(_MapName, _MapType)}
    
    if #VictoryConditions == 0 then
       return unpack(MPDefaultVictoryConditions) 
    else
        return unpack(VictoryConditions)
    end
end
----------------------------------------------------------------------------------------------------
function GetMPValidResourceModificators(_MapName, _MapType)

    local ResourceModificators = {Framework.GetValidResourceModificators(_MapName, _MapType)}
    
    if #ResourceModificators == 0 then
        return unpack(MPDefaultResourceModificators)
    else
        return unpack(ResourceModificators)         
    end
end
----------------------------------------------------------------------------------------------------
