--------------------------------------------------------------------------
--        ***************** Feedback Speech *****************
--------------------------------------------------------------------------

GUI_FeedbackSpeech = {}


function InitFeedbackSpeech()

    g_FeedbackSpeech = {}
    g_FeedbackSpeech.NearbyRadius = 25 * 100
    g_FeedbackSpeech.ScreenRadius = 70 * 100

    g_FeedbackSpeech.SignalTypes = {}
    g_FeedbackSpeech.SignalTypes.DefaultYellow = {0, 255, 255, 0} --CreateMinimapSignalRGBA parameters: type, R, G, B
    g_FeedbackSpeech.SignalTypes.DefaultRed = {0, 255, 0, 0}
    g_FeedbackSpeech.SignalTypes.BigRed = {3, 255, 0, 0}
    g_FeedbackSpeech.SignalTypes.DestroyedRed = {4, 255, 0, 0}


    g_FeedbackSpeech.Categories = {

    --with IgnoreTime -1, these messages will always be added
    OwnThiefDeliveredInformation    = {["Prio"] = 1, ["IgnoreTime"] = -1, ["Sound"] = "ui\\menu_left_thief_info", ["SignalType"] = nil},
    StoneOrIronMineDepleted         = {["Prio"] = 1, ["IgnoreTime"] = -1, ["Sound"] = "ui\\menu_ressource_depleted", ["SignalType"] = g_FeedbackSpeech.SignalTypes.DefaultYellow},
    TerritoryClaimed                = {["Prio"] = 1, ["IgnoreTime"] = -1, ["Sound"] = "ui\\menu_left_claim_territory", ["SignalType"] = g_FeedbackSpeech.SignalTypes.DefaultYellow},
    TerritoryLost                   = {["Prio"] = 1, ["IgnoreTime"] = -1, ["Sound"] = "ui\\menu_left_lost_territory", ["SignalType"] = g_FeedbackSpeech.SignalTypes.DefaultRed},
    DestroyedKnight                 = {["Prio"] = 1, ["IgnoreTime"] = -1, ["Sound"] = "ui\\menu_knight_dead", ["SignalType"] = g_FeedbackSpeech.SignalTypes.DestroyedRed},
    DestroyedSpecialBuilding        = {["Prio"] = 1, ["IgnoreTime"] = -1, ["Sound"] = "ui\\menu_left_killed", ["SignalType"] = g_FeedbackSpeech.SignalTypes.DestroyedRed},
    DestroyedOutpost                = {["Prio"] = 2, ["IgnoreTime"] = -1, ["Sound"] = "ui\\menu_left_killed", ["SignalType"] = g_FeedbackSpeech.SignalTypes.DestroyedRed},

    EnemiesOnMarketplace            = {["Prio"] = 2, ["IgnoreTime"] = 50, ["Sound"] = "ui\\menu_left_enemies_on_marketplace", ["SignalType"] = g_FeedbackSpeech.SignalTypes.DefaultRed},
    SpecialBuildingToBeDestroyed    = {["Prio"] = 2, ["IgnoreTime"] = 50, ["Sound"] = "ui\\menu_left_specialbuilding_will_be_destroyed_soon", ["SignalType"] = g_FeedbackSpeech.SignalTypes.DefaultRed},
    ScaredSettler                   = {["Prio"] = 5, ["IgnoreTime"] = 150, ["Sound"] = "ui\\menu_left_settler_scared", ["SignalType"] = g_FeedbackSpeech.SignalTypes.DefaultYellow},

    CartsUnderway                   = {["Prio"] = 5, ["IgnoreTime"] = 4, ["Sound"] = nil, ["SignalType"] = nil},
    ArrivedResourceCart             = {["Prio"] = 5, ["IgnoreTime"] = 20, ["Sound"] = nil, ["SignalType"] = nil},
    ArrivedGoodsCartOrEntertainer   = {["Prio"] = 5, ["IgnoreTime"] = 20, ["Sound"] = nil, ["SignalType"] = g_FeedbackSpeech.SignalTypes.DefaultYellow},

    SettlersCannotGather            = {["Prio"] = 5, ["IgnoreTime"] = 150, ["Sound"] = nil, ["SignalType"] = g_FeedbackSpeech.SignalTypes.DefaultYellow},
    DepotLimit                      = {["Prio"] = 3, ["IgnoreTime"] = 150, ["Sound"] = nil, ["SignalType"] = g_FeedbackSpeech.SignalTypes.DefaultYellow},
    PredatorsPreyOnFood             = {["Prio"] = 4, ["IgnoreTime"] = 30, ["Sound"] = nil, ["SignalType"] = g_FeedbackSpeech.SignalTypes.DefaultYellow},
    BuildingBurning                 = {["Prio"] = 5, ["IgnoreTime"] = 20, ["Sound"] = "ui\\menu_left_building_burn", ["SignalType"] = g_FeedbackSpeech.SignalTypes.DefaultRed},
    AttackedCastle                  = {["Prio"] = 1, ["IgnoreTime"] = 30, ["Sound"] = "ui\\mini_under_attack", ["SignalType"] = g_FeedbackSpeech.SignalTypes.BigRed},
    AttackedCathedral               = {["Prio"] = 1, ["IgnoreTime"] = 30, ["Sound"] = "ui\\mini_under_attack", ["SignalType"] = g_FeedbackSpeech.SignalTypes.BigRed},
    AttackedStorehouse              = {["Prio"] = 1, ["IgnoreTime"] = 30, ["Sound"] = "ui\\mini_under_attack", ["SignalType"] = g_FeedbackSpeech.SignalTypes.BigRed},
    AttackedOutpost                 = {["Prio"] = 2, ["IgnoreTime"] = 30, ["Sound"] = "ui\\mini_under_attack", ["SignalType"] = g_FeedbackSpeech.SignalTypes.BigRed},
    AttackedAlly                    = {["Prio"] = 5, ["IgnoreTime"] = 150, ["Sound"] = "ui\\mini_under_attack", ["SignalType"] = g_FeedbackSpeech.SignalTypes.BigRed}
    }


    --unnecessary for -1 ignoretime and area categories, so those are left out in this table
    g_FeedbackSpeech.LastCategorySpeechTimes = {
    EnemiesOnMarketplace            = -100000,
    SpecialBuildingToBeDestroyed    = -100000,
    ScaredSettler                   = -100000,
    CartsUnderway                   = -100000,
    ArrivedResourceCart             = -100000,
    ArrivedGoodsCartOrEntertainer   = -100000,
    SettlersCannotGather            = -100000,
    DepotLimit                      = -100000,
    PredatorsPreyOnFood             = -100000,
    BuildingBurning                 = -100000,
    AttackedCastle                  = -100000,
    AttackedCathedral               = -100000,
    AttackedStorehouse              = -100000,
    AttackedOutpost                 = -100000,
    AttackedAlly                    = -100000
    }


    g_FeedbackSpeech.AreaCategories = {

    OwnThiefExposed                 = {["Prio"] = 2, ["AreaIgnoreTime"] = 10, ["Sound"] = "ui\\menu_left_thief_own", ["SignalType"] = g_FeedbackSpeech.SignalTypes.DefaultYellow},
    ForeignThiefDetected            = {["Prio"] = 2, ["AreaIgnoreTime"] = 10, ["Sound"] = "ui\\menu_left_thief_hostile", ["SignalType"] = g_FeedbackSpeech.SignalTypes.DefaultYellow},
    CartCaptured                    = {["Prio"] = 2, ["AreaIgnoreTime"] = 10, ["Sound"] = "ui\\menu_left_cart_captured", ["SignalType"] = g_FeedbackSpeech.SignalTypes.DefaultYellow},
    PlunderedByLadyPlunder          = {["Prio"] = 3, ["AreaIgnoreTime"] = 10, ["Sound"] = nil, ["SignalType"] = g_FeedbackSpeech.SignalTypes.DefaultYellow},
    ConvertedByLordWisdom           = {["Prio"] = 3, ["AreaIgnoreTime"] = 10, ["Sound"] = nil, ["SignalType"] = g_FeedbackSpeech.SignalTypes.DefaultYellow},

    AttackedKnight                  = {["Prio"] = 1, ["AreaIgnoreTime"] = 30, ["Sound"] = "ui\\mini_under_attack", ["LastAreas"] = "SharedAttacked", ["SignalType"] = g_FeedbackSpeech.SignalTypes.BigRed},
    AttackedCart                    = {["Prio"] = 2, ["AreaIgnoreTime"] = 20, ["Sound"] = "ui\\mini_under_attack", ["LastAreas"] = "SharedAttacked", ["SignalType"] = g_FeedbackSpeech.SignalTypes.BigRed},
    AttackedMilitary                = {["Prio"] = 4, ["AreaIgnoreTime"] = 40, ["Sound"] = "ui\\mini_under_attack", ["LastAreas"] = "SharedAttacked", ["SignalType"] = g_FeedbackSpeech.SignalTypes.BigRed},
    AttackedThief                   = {["Prio"] = 3, ["AreaIgnoreTime"] = 20, ["Sound"] = "ui\\mini_under_attack", ["LastAreas"] = "SharedAttacked", ["SignalType"] = g_FeedbackSpeech.SignalTypes.BigRed},
    AttackedBuildingOrWall          = {["Prio"] = 4, ["AreaIgnoreTime"] = 40, ["Sound"] = "ui\\mini_under_attack", ["LastAreas"] = "SharedAttacked", ["SignalType"] = g_FeedbackSpeech.SignalTypes.BigRed},
    AttackedTaxCollector            = {["Prio"] = 3, ["AreaIgnoreTime"] = 20, ["Sound"] = "ui\\mini_under_attack", ["LastAreas"] = "SharedAttacked", ["SignalType"] = g_FeedbackSpeech.SignalTypes.BigRed},

    DestroyedCart                   = {["Prio"] = 2, ["AreaIgnoreTime"] = 20, ["Sound"] = "ui\\menu_left_killed", ["LastAreas"] = "SharedDestroyed", ["SignalType"] = g_FeedbackSpeech.SignalTypes.DestroyedRed},
    DestroyedMilitary               = {["Prio"] = 4, ["AreaIgnoreTime"] = 20, ["Sound"] = "ui\\menu_left_killed", ["LastAreas"] = "SharedDestroyed", ["SignalType"] = g_FeedbackSpeech.SignalTypes.DestroyedRed},
    DestroyedThief                  = {["Prio"] = 3, ["AreaIgnoreTime"] = 20, ["Sound"] = "ui\\menu_left_killed", ["LastAreas"] = "SharedDestroyed", ["SignalType"] = g_FeedbackSpeech.SignalTypes.DestroyedRed},
    DestroyedBuildingOrWall         = {["Prio"] = 5, ["AreaIgnoreTime"] = 40, ["Sound"] = "ui\\menu_left_killed", ["LastAreas"] = "SharedDestroyed", ["SignalType"] = g_FeedbackSpeech.SignalTypes.DestroyedRed},
    DestroyedTaxCollector           = {["Prio"] = 3, ["AreaIgnoreTime"] = 20, ["Sound"] = "ui\\menu_left_tax_raid" , ["LastAreas"] = "SharedDestroyed", ["SignalType"] = g_FeedbackSpeech.SignalTypes.DestroyedRed}
    }
    --note that "destroyed" categories must not have higher priorities (lower number) than corresponding "attacked" categories, or the "destroyed"
    -- message could happen to speak before the "attacked" message


    g_FeedbackSpeech.LastAreas = {

    OwnThiefExposed                 = {},
    ForeignThiefDetected            = {},
    CartCaptured                    = {},
    PlunderedByLadyPlunder          = {},
    ConvertedByLordWisdom           = {},
    SharedAttacked                  = {},
    SharedDestroyed                 = {}
    }


    g_FeedbackSpeech.Queue = {}

    g_FeedbackSpeech.LastSpeechEndTime = nil

    g_FeedbackSpeech.LastSpeechEndTimeForButton = nil

    g_FeedbackSpeech.HasEvent = false
    g_FeedbackSpeech.ButtonEntityPosX = nil
    g_FeedbackSpeech.ButtonEntityPosY = nil


--  Unused:
--  SettlersStrike - Settlers strike due to Need (for Food, Clothes, Cleanliness, Mood)
--  SettlersIdle   - Settlers idle due to lack of resources for producing (generic)
--  SettlersIdle   - Settlers idle because they can't deliver their resources because the Storehouse is overfilled
--
--
--  Rules for managing the speech messages, minimap pop-up button and minimap dots:
--
--  Area Callback checks:
--  - Attacked messages won't play when the entity is visible onscreen. (Precise Check?)
--  - Attack Callbacks add the generic Minimap_AttackedGenericUnit "We are under attack!" message when there are multiple own
--   military units nearby (NearbyRadius).
--
--  - Area Callback checks will add a message if:
--   1. It's not in the same area (ScreenRadius which is roughly more than 1 screen) as the last message of the same AreaCategory.
--      There are different area variable sets for each AreaCategory, except that Attack messages share one area variable set.
--      There's another area variable set for attacked allied units.
--
--   2. Or: the specified time (according to the AreaCategory) has passed since the last message of the same AreaCategory from the same area.
--
--  Problem: 2 simultaneous battles in different areas can generate endless messages.
--  Solution: Save areas into LastAreasTable for each AreaCategory, with time.
--   Remove areas from LastAreasTable when there was no message from that area since 60 s. Removing them after 60 s doesn't affect
--   the messages, just removes unnecessary data.
--
--
--  Speech:
--  - When there are multiple speech messages from the same category in a short amount of time (amount is different for each category),
--   only the first will be played.
--  - Messages without a category will all be played.
--  - Multiple messages "overlapping" each other (starting while the former is still speaking) are avoided by queuing them.
--  - The messages in the queue will be sorted according to:
--   1. Their priority
--   2. The time they entered the queue
--  - Messages of prio 3 and lower will be dropped if they are delayed by 3 messages or more.
--
--  Ideal, but optional (not implemented):
--      - Will not start until the speaking (quest) knight portrait has finished (only if it's the knight).
--      - (Quest) knight portrait will not appear until the current feedback speech has finished.
--
--
--  Minimap unit pop-up button:
--  - The minimap unit pop-up button will immediately change according to the currently speaking message.
--  - When not replaced by another message, the minimap unit pop-up button is displayed for 10 seconds (which surely is longer than the speech) and
--   then fades out.
--
--
--  Minimap dots:
--  - All the affected entities' minimap dots will always and immediately be highlighted (e.g. when attacked), independent of the speech message.
--
--  Ideal, but optional (not clear how it is implemented):
--      - For attacked entities, the affected entities' minimap dots will stay highlighted (or blinking; done by script or code?) until there
--       are no enemies near or they have not been attacked for 10 seconds : Code

end


function GUI_FeedbackSpeech.AreaCheckedAdd(_SpeechTextKey, _AreaCategory, _EntityIDOrInfoTable, _CausingPlayerID, _OptionalScreenCheck, _OptionalGenericAttackedCheck)
    --don't add speech if:
    -- entity is from an area still in g_FeedbackSpeech.LastAreas table of the same message category
    -- and AreaIgnoreTime has not yet passed

    local EntityInfo

    if type(_EntityIDOrInfoTable) == "number" then
        local Type = Logic.GetEntityType(_EntityIDOrInfoTable)
        local PosX, PosY = Logic.GetEntityPosition(_EntityIDOrInfoTable)

        EntityInfo = {["ID"] = _EntityIDOrInfoTable,
            ["Type"] = Type,
            ["PosX"] = PosX,
            ["PosY"] = PosY}
    else
        EntityInfo = _EntityIDOrInfoTable
    end

    local AreasTable = g_FeedbackSpeech.LastAreas[_AreaCategory["LastAreas"]]

    if AreasTable == nil then
        local AreasTableName = GetNameOfKeyInTable(g_FeedbackSpeech.AreaCategories, _AreaCategory)
        AreasTable = g_FeedbackSpeech.LastAreas[AreasTableName]
    end

    local IsFromAreaInAreasTable = false
    local ShouldSpeechPlay = true
    local SpeechTime = Logic.GetTimeMs()

    for i = 1, #AreasTable do
        local AreaX = AreasTable[i].X
        local AreaY = AreasTable[i].Y
        local Radius = g_FeedbackSpeech.ScreenRadius

        if EntityInfo.PosX > AreaX - Radius
        and EntityInfo.PosX < AreaX + Radius
        and EntityInfo.PosY > AreaY - Radius
        and EntityInfo.PosY < AreaY + Radius then
            IsFromAreaInAreasTable = true

            local AreaIgnoreTime = _AreaCategory["AreaIgnoreTime"]
            local LastSpeechTime = AreasTable[i].SpeechTime

            if SpeechTime > LastSpeechTime + AreaIgnoreTime * 1000 then
                ShouldSpeechPlay = true
                --save Speech time to that area
                AreasTable[i].SpeechTime = SpeechTime
            else
                ShouldSpeechPlay = false
                break
            end
        end
    end

    --if not from any area, add that area to g_FeedbackSpeech.LastAreas table of the same message category
    if IsFromAreaInAreasTable == false then
        table.insert(AreasTable, {["X"] = EntityInfo.PosX, ["Y"] = EntityInfo.PosY, ["SpeechTime"] = SpeechTime})
    end

    if ShouldSpeechPlay == true then
        GUI_FeedbackSpeech.Add(_SpeechTextKey, _AreaCategory, EntityInfo, _CausingPlayerID, _OptionalScreenCheck, _OptionalGenericAttackedCheck)
    end
end


function GUI_FeedbackSpeech.Add(_SpeechTextKey, _Category, _EntityIDOrInfoTable, _CausingPlayerID, _OptionalScreenCheck, _OptionalGenericAttackedCheck)

    local EntityInfo

    if type(_EntityIDOrInfoTable) == "number" then
        local Type = Logic.GetEntityType(_EntityIDOrInfoTable)
        local PosX, PosY = Logic.GetEntityPosition(_EntityIDOrInfoTable)

        EntityInfo = {["ID"] = _EntityIDOrInfoTable,
            ["Type"] = Type,
            ["PosX"] = PosX,
            ["PosY"] = PosY}
    else
        EntityInfo = _EntityIDOrInfoTable
    end

    local LastCategorySpeechTimesKeyName = GetNameOfKeyInTable(g_FeedbackSpeech.Categories, _Category)
    local LastCategorySpeechTime = g_FeedbackSpeech.LastCategorySpeechTimes[LastCategorySpeechTimesKeyName]
    local IgnoreTime = _Category["IgnoreTime"]
    local SpeechTime = Logic.GetTimeMs()
    local ShouldSpeechPlay = false

    if LastCategorySpeechTime == nil -- area categories, and -1 ignoretimes
    or SpeechTime > LastCategorySpeechTime + IgnoreTime * 1000 then
        --save Speech time for that category
        if LastCategorySpeechTime ~= nil then
            g_FeedbackSpeech.LastCategorySpeechTimes[LastCategorySpeechTimesKeyName] = SpeechTime
        end

        ShouldSpeechPlay = true
    end

    if ShouldSpeechPlay == true
    and _OptionalScreenCheck == true then
        if GUI_FeedbackSpeech.ScreenCheck(EntityInfo.PosX, EntityInfo.PosY) == true then
            ShouldSpeechPlay = false
        end
    end

    if ShouldSpeechPlay == true
    and _OptionalGenericAttackedCheck == true then
        if GUI_FeedbackSpeech.NearbyCheck(EntityInfo) == true then
            _SpeechTextKey = "Minimap_AttackedGenericUnit"
        end
    end

    if ShouldSpeechPlay == true then
        --insert at position according to priority
        local Priority = _Category["Prio"]
        local QueuePosition = #g_FeedbackSpeech.Queue + 1

        if #g_FeedbackSpeech.Queue > 0 then
            for i = 1, #g_FeedbackSpeech.Queue do
                local EntryPriority = g_FeedbackSpeech.Queue[i].Priority

                if EntryPriority <= Priority then
                    QueuePosition = i
                    break
                end
            end
        end

        --Messages of prio 3-5 will be dropped if they are delayed by 3 messages or more.
        if (Priority >= 3
        and QueuePosition <= #g_FeedbackSpeech.Queue - 3 + 1) == false then     --count + 1 because it's not inserted yet

            local SignalType = _Category["SignalType"]

            table.insert(g_FeedbackSpeech.Queue, QueuePosition, {
                ["SpeechTextKey"] = _SpeechTextKey,
                ["SignalType"] = SignalType,
                ["Priority"] = Priority,
                ["EntityInfo"] = EntityInfo,
                ["CausingPlayerID"] = _CausingPlayerID,
                ["Sound"] = _Category["Sound"],
                })
        end
    end
end


function GUI_FeedbackSpeech.ScreenCheck(_PosX, _PosY)
    --don't add speech if entity is visible onscreen

    local PosZ = Display.GetTerrainHeight(_PosX, _PosY)
    local EntityScreenPosX, EntityScreenPosY = Camera.GetScreenCoord(_PosX, _PosY, PosZ)
    local ScreenSizeX, ScreenSizeY = GUI.GetScreenSize()

    if EntityScreenPosX > 0
    and EntityScreenPosY > 0
    and EntityScreenPosX < ScreenSizeX
    and EntityScreenPosY < ScreenSizeY then
        return true
    else
        return false
    end
end


function GUI_FeedbackSpeech.NearbyCheck(_EntityInfo)
    --Attack messages change to the generic Minimap_AttackedGenericUnit "We are under attack!" message when there are multiple own
    -- military units nearby (NearbyRadius).

    --target entities affected by these messages:
    --AttackedKnight, AttackedCart, AttackedMilitary, AttackedThief, AttackedTaxCollector

    local PlayerID = GUI.GetPlayerID()
    local NearbyRange = g_FeedbackSpeech.NearbyRadius
    local KnightType = Logic.GetEntityType(Logic.GetKnightID(PlayerID))

    local NearbyEntityTypes = {
    KnightType,
    Entities.U_MilitaryLeader,
    Entities.U_MilitaryCatapult,
    Entities.U_MilitaryCannon,
    Entities.U_MilitaryBatteringRam,
    Entities.U_MilitarySiegeTower,
    Entities.U_AmmunitionCart,
    Entities.U_BatteringRamCart,
    Entities.U_CatapultCart,
    Entities.U_CannonCart,
    Entities.U_SiegeTowerCart,
    Entities.U_MilitaryBallista,
    Entities.U_GoldCart,
    Entities.U_ResourceMerchant,
    Entities.U_Marketer,
    Entities.U_TaxCollector,
    Entities.U_Thief,
    Entities.U_MilitaryTrebuchet,
    Entities.U_TrebuchetCart
    }

    --don't look for same entitytype as speech entityID
    local SpeechEntityType = _EntityInfo.Type

    if SpeechEntityType == Entities.U_MilitarySword
    or SpeechEntityType == Entities.U_MilitaryBow 
    or SpeechEntityType == Entities.U_MilitaryBow_RedPrince 
    or SpeechEntityType == Entities.U_MilitarySword_RedPrince then
        SpeechEntityType = Entities.U_MilitaryLeader
    end

    for i = 1, #NearbyEntityTypes do
        if NearbyEntityTypes[i] == SpeechEntityType then
            table.remove(NearbyEntityTypes, i)
            break
        end
    end

    local NearbyEntities = 0

    for i = 1, #NearbyEntityTypes do
        local EntityType = NearbyEntityTypes[i]
        local NumResults, EntityIDs = Logic.GetPlayerEntitiesInArea(PlayerID, EntityType, _EntityInfo.PosX, _EntityInfo.PosY, NearbyRange, 1)
        NearbyEntities = NearbyEntities + NumResults

        if NearbyEntities > 0 then
            return true
        end
    end

    return false
end


function GUI_FeedbackSpeech.Update()

    local CurrentTime = Logic.GetTimeMs()
    local RealTime = Framework.GetTimeMs()

    if g_FeedbackSpeech.Queue[#g_FeedbackSpeech.Queue] ~= nil
    and (g_FeedbackSpeech.LastSpeechEndTime == nil
    or RealTime > g_FeedbackSpeech.LastSpeechEndTime) 
    and not g_VoiceMessageIsRunning then    -- Don't say something while a quest message is spoken
        local SpeechTextKey = g_FeedbackSpeech.Queue[#g_FeedbackSpeech.Queue].SpeechTextKey
        local EntityInfo = g_FeedbackSpeech.Queue[#g_FeedbackSpeech.Queue].EntityInfo
        local CausingPlayerID = g_FeedbackSpeech.Queue[#g_FeedbackSpeech.Queue].CausingPlayerID
        local Sound = g_FeedbackSpeech.Queue[#g_FeedbackSpeech.Queue].Sound
        local SignalType = g_FeedbackSpeech.Queue[#g_FeedbackSpeech.Queue].SignalType

        --the actual message; use signal colors for BG behind button
        GUI_FeedbackSpeech.Speak(SpeechTextKey, EntityInfo, CausingPlayerID, Sound, SignalType)

        --GetSpeechLengthInMS(SpeechTextKey) function will go here
        local SpeechLengthInMS = 5000
        g_FeedbackSpeech.LastSpeechEndTime = RealTime + SpeechLengthInMS

        --accompanying minimap signal
        if SignalType ~= nil then
            local Type = SignalType[1]
            local R, G, B = SignalType[2], SignalType[3], SignalType[4]
            GUI_Minimap.ShowSignalAttachedToEntity(EntityInfo.ID, EntityInfo.PosX, EntityInfo.PosY, R, G, B, Type)
        end

        table.remove(g_FeedbackSpeech.Queue, #g_FeedbackSpeech.Queue)
    end

    if g_FeedbackSpeech.LastSpeechEndTime ~= nil
    and RealTime > g_FeedbackSpeech.LastSpeechEndTime then
        g_FeedbackSpeech.LastSpeechEndTime = nil
        XGUIEng.ShowWidget("/InGame/Root/Normal/AlignBottomRight/MapFrame/FeedbackSpeechText", 0)
    end

    --remove button after 16 seconds
    if g_FeedbackSpeech.LastSpeechEndTimeForButton ~= nil
    and RealTime > g_FeedbackSpeech.LastSpeechEndTimeForButton + 16000 then
        XGUIEng.ShowWidget("/InGame/Root/Normal/AlignBottomRight/MapFrame/FeedbackSpeechButton", 0)
        XGUIEng.ShowWidget("/InGame/Root/Normal/AlignBottomRight/MapFrame/FeedbackSpeechButtonBG", 0)
        XGUIEng.ShowWidget("/InGame/Root/Normal/AlignBottomRight/MapFrame/FeedbackSpeechCausingPlayer", 0)
        g_FeedbackSpeech.LastSpeechEndTimeForButton = nil
    end

    --remove areas that had no speech for 80 seconds
    --save performance by doing it only once every 4 seconds
    local TimeInSeconds = math.floor(Logic.GetTime())

    if math.mod(TimeInSeconds, 4) ~= 0 then
        return
    elseif TimeInSeconds == g_FeedbackSpeech.LastAreaTableRemovalTime then
        return
    end

    g_FeedbackSpeech.LastAreaTableRemovalTime = TimeInSeconds

    for k, v in pairs (g_FeedbackSpeech.LastAreas) do
        local AreasTable = v

        if #AreasTable ~= 0 then
            local SpeechTime = AreasTable[#AreasTable].SpeechTime

            if SpeechTime + 80000 < CurrentTime then
                table.remove(AreasTable, #AreasTable)
                return
            end
        end
    end
end


function GUI_FeedbackSpeech.Speak(_SpeechTextKey, _EntityInfo, _CausingPlayerID, _Sound, _SignalType)

    if _SpeechTextKey ~= nil then
        --local SpeechText = XGUIEng.GetStringTableText("Feedback_Knights_speech/" .. _SpeechTextKey)
        --XGUIEng.SetText("/InGame/Root/Normal/AlignBottomRight/MapFrame/FeedbackSpeechText", "Speech:{cr}" .. SpeechText)
        --XGUIEng.ShowWidget("/InGame/Root/Normal/AlignBottomRight/MapFrame/FeedbackSpeechText", 1)
        
        local KnightEntityType
        local KnightString
        
        if _EntityInfo ~= nil and _EntityInfo.Type ~= nil then
            KnightEntityType = _EntityInfo.Type
            KnightString = GetKnightActor(KnightEntityType)
        end
        
        if KnightString == nil then
            local PlayerID = GUI.GetPlayerID()
            KnightEntityType = Logic.GetEntityType(Logic.GetKnightID(PlayerID))
            KnightString = GetKnightActor(KnightEntityType)
        end
        
        if KnightString ~= nil then
            local SoundFile = "Voices/" .. KnightString .. "/Feedback_Knights_speech_" .. _SpeechTextKey .. ".mp3"
            Sound.PlayVoice("MinimapFeedbackSpeech", SoundFile)
        end
    end

    if _Sound ~= nil then
        Sound.FXPlay2DSound(_Sound)
    end

    if _EntityInfo ~= nil
    and _EntityInfo.ID ~= nil then
        g_FeedbackSpeech.HasEvent = true
        g_FeedbackSpeech.ButtonEntityPosX = _EntityInfo.PosX
        g_FeedbackSpeech.ButtonEntityPosY = _EntityInfo.PosY
        local RealTime = Framework.GetTimeMs()
        g_FeedbackSpeech.LastSpeechEndTimeForButton = RealTime

        local Icon = g_TexturePositions.Entities[_EntityInfo.Type]

        if _EntityInfo.Type == 0 then
             if Framework.IsDevM() then GUI.AddNote("DevMachine Debug:GiBo: No Icon for _EntityInfo.Type = " .. _EntityInfo.Type .. " and ID = " .. _EntityInfo.ID) end
            Icon = {16, 16}
        else
            if Icon == nil then
                if _EntityInfo.Type == Entities.U_MilitaryLeader then
                    if Logic.IsEntityDestroyed(_EntityInfo.ID) == false then
                        local SoldierType = Logic.LeaderGetSoldiersType(_EntityInfo.ID)
                        Icon = g_TexturePositions.Entities[SoldierType]
                    end

                    if Icon == nil then
                        Icon = {7, 11}
                    end

                elseif Logic.IsEntityTypeInCategory(_EntityInfo.Type, EntityCategories.Wall) == 1 then
                    Icon = {3, 9}
                elseif Logic.IsEntityTypeInCategory(_EntityInfo.Type, EntityCategories.AttackableBuilding) == 1 then
                    Icon = {8, 1}
                elseif Logic.IsEntityTypeInCategory(_EntityInfo.Type, EntityCategories.Spouse) == 1 then
                    Icon = {5, 15}
                elseif Logic.IsEntityTypeInCategory(_EntityInfo.Type, EntityCategories.Worker) == 1 then
                    Icon = {5, 16}
                elseif Logic.IsEntityTypeInCategory(_EntityInfo.Type, EntityCategories.AttackableSettler) == 1 then
                    Icon = {5, 16}
                else
                    if Framework.IsDevM() then GUI.AddNote("DevMachine Debug:GiBo: No Icon for _EntityInfo.Type = " .. _EntityInfo.Type) end
                    Icon = {16, 16}
                end
            end
        end

        SetIcon("/InGame/Root/Normal/AlignBottomRight/MapFrame/FeedbackSpeechButton", Icon)

        if _SignalType ~= nil then
            local R, G, B = _SignalType[2], _SignalType[3], _SignalType[4]
            XGUIEng.SetMaterialColor("/InGame/Root/Normal/AlignBottomRight/MapFrame/FeedbackSpeechButtonBG", 0, R, G, B, 200)
        else
            XGUIEng.SetMaterialColor("/InGame/Root/Normal/AlignBottomRight/MapFrame/FeedbackSpeechButtonBG", 0, 0, 0, 0, 0)
        end

        XGUIEng.ShowWidget("/InGame/Root/Normal/AlignBottomRight/MapFrame/FeedbackSpeechButton", 1)
        XGUIEng.ShowWidget("/InGame/Root/Normal/AlignBottomRight/MapFrame/FeedbackSpeechButtonBG", 1)

        if _CausingPlayerID ~= nil then
            local IconWidget = "/InGame/Root/Normal/AlignBottomRight/MapFrame/FeedbackSpeechCausingPlayer/CausingPlayerIcon"
            local ColorWidget = "/InGame/Root/Normal/AlignBottomRight/MapFrame/FeedbackSpeechCausingPlayer/CausingPlayerColor"

            SetPlayerIcon(_CausingPlayerID, IconWidget, ColorWidget)

            XGUIEng.ShowWidget("/InGame/Root/Normal/AlignBottomRight/MapFrame/FeedbackSpeechCausingPlayer", 1)
        else
            XGUIEng.ShowWidget("/InGame/Root/Normal/AlignBottomRight/MapFrame/FeedbackSpeechCausingPlayer", 0)
        end
    end
end


function GUI_FeedbackSpeech.ButtonClicked()
    if g_FeedbackSpeech.HasEvent == true then
        Sound.FXPlay2DSound( "ui\\menu_click")

        Camera.RTS_SetLookAtPosition(g_FeedbackSpeech.ButtonEntityPosX, g_FeedbackSpeech.ButtonEntityPosY)
        Camera.SwitchCameraBehaviour(0)

        XGUIEng.ShowWidget("/InGame/Root/Normal/AlignBottomRight/MapFrame/FeedbackSpeechButton", 0)
        XGUIEng.ShowWidget("/InGame/Root/Normal/AlignBottomRight/MapFrame/FeedbackSpeechButtonBG", 0)
        XGUIEng.ShowWidget("/InGame/Root/Normal/AlignBottomRight/MapFrame/FeedbackSpeechCausingPlayer", 0)
    end
end