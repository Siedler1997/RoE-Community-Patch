
-----------------------------------------------------------------------------------------
-- Overwrites for FeedbackSpeech
-----------------------------------------------------------------------------------------

function InitOverwriteFeedbackSpeechEx2()

    do
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
    end

    do
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
    end

end