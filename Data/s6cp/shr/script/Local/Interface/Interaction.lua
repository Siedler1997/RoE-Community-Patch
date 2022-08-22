--------------------------------------------------------------------------
--        ***************** Interaction *****************
--------------------------------------------------------------------------
-- look into SharedConstants.lua for the consts
-- in case you have too much spare time: Rewrite this file!

GUI_Interaction = {}

g_OverrideTextKeyPattern = "^KEY%(([^%)]+)%)"
function InitInteraction()

    g_VoiceMessagesQueue = {}
    g_Interaction = {}
    g_Interaction.SavedQuestEntityTypes = {}
    
    --show questlog button --should we hide it if no quests at all ? (MP for example)
    XGUIEng.ShowWidget("/InGame/Root/Normal/AlignTopLeft/QuestLogButton",1)
    XGUIEng.ShowWidget(QuestLog.Widget.Button,1)

end


function LocalScriptCallback_OnDiplomacyStateChanged(_ReceivingPlayer, _PlayerWhoChanged, _NewDiplomacyState, _OldDiplomacyState)

    DiplomacyMenu_Update()
    
    --if _ReceivingPlayer == GUI.GetPlayerID() then
    --
    --    local MessageKey
    --    local Rand = false
    --
    --    if _NewDiplomacyState == DiplomacyStates.Enemy then
    --        MessageKey = "DiplomacyChanged_Enemy"
	--    elseif _NewDiplomacyState == DiplomacyStates.Undecided then
	--        MessageKey = "DiplomacyChanged_Undecided"
	--    elseif _NewDiplomacyState == DiplomacyStates.EstablishedContact then
	--        MessageKey = "DiplomacyChanged_Established"
	--    elseif _NewDiplomacyState == DiplomacyStates.TradeContact then
	--        MessageKey = "DiplomacyChanged_TradeContact"
	--    elseif _NewDiplomacyState == DiplomacyStates.Allied then
	--        MessageKey = "DiplomacyChanged_Allied"
    --    end
    --
    --    --LocalScriptCallback_QueueVoiceMessage(_PlayerWhoChanged , MessageKey, Rand)
    --end
end


-- starting messages -->
function LocalScriptCallback_OnQuestStatusChanged(_QuestIndex)

    local Quest = Quests[_QuestIndex]
    
    if g_QuestSysTraceActive then
        local State = "Unknown?!"
        for k, v in pairs( QuestState ) do
            if Quest.State == v then
                State = k
            end
        end
        local Result = "Running"
        for k, v in pairs( QuestResult ) do
            if Quest.Result == v then
                Result = k
            end
        end
        
        local Text = string.format( "SP: %d, RP: %d, Status: %s, Result: %s, Name: %s", Quest.SendingPlayer, Quest.ReceivingPlayer, State, Result, Quest.Identifier )
        GUI.AddNote( Text )
        Framework.WriteToLog( string.format( "QuestTrace: [%6d] %s", Logic.GetTime(), Text ) )
    end
    
    if Quest.ReceivingPlayer == GUI.GetPlayerID() then

        -- save EntityType of target Entity IDs if necessary
        GUI_Interaction.SaveQuestEntityTypes(_QuestIndex)

        local ShowMessage = false

        if Quest.Visible then

            if Quest.State == QuestState.Active then
                GUI_Interaction.CheckIfTimerShouldAppear(_QuestIndex)
                ShowMessage = true
            elseif Quest.State == QuestState.Over then
                GUI_Interaction.CheckIfTimerShouldDisappear(_QuestIndex)
                ShowMessage = Quest.ShowEndMessage
            elseif Quest.State == QuestState.NotTriggered then
                -- Happens when restarting a visible quest while it is active
                GUI_Interaction.CheckIfTimerShouldDisappear(_QuestIndex)
            end

        else
            if Quest.State == QuestState.Over then
                ShowMessage = Quest.ShowEndMessage
                GUI_Interaction.CheckIfTimerShouldDisappear(_QuestIndex)
            end
        end

        if Quest.Result ~= QuestResult.Interrupted and Quest.State ~= QuestState.NotTriggered then
            local SendingPlayer = Quest.SendingPlayer
            local MessageBaseKey = ShowMessage and Quest.MsgKeyOverride or Quest.Identifier
            if ShowMessage and Quest.MsgKeyOverride and Quest.Identifier and Quest.Identifier ~= "" then
                -- Special case, check if there is a map specific key instead of the default key
                local TestMsg = Wrapped_GetStringTableText( _QuestIndex, string.format( "Map_%s_speech/%s%s",
                    Framework.GetCurrentMapName(), Quest.Identifier, ( Quest.Result == QuestResult.Success and "_Success" )
                    or ( Quest.Result == QuestResult.Failure and "_Failure" ) or "" ) )
                if TestMsg and TestMsg ~= "" then
                    MessageBaseKey = Quest.Identifier
                end
            end
            local PlayDirectly = false 
            local Random = false
            
            if ( not MessageBaseKey or ( MessageBaseKey ~= "NO_MESSAGE" and MessageBaseKey ~= "KEY(NO_MESSAGE)" ) ) and ( not GetTextOverride(Quest) or GetTextOverride(Quest) ~= "NO_MESSAGE" ) then
                GUI_Interaction.GenerateVoiceMessage(_QuestIndex, SendingPlayer, MessageBaseKey, PlayDirectly, Random, nil, nil, not ShowMessage)
            end
        end
       
        QuestLog.UpdateQuestLog(_QuestIndex)
        
        -- May need to force a display update in case a subquest of a currently shown quest just completed
        if g_Interaction.CurrentMessageQuestIndex and g_Interaction.CurrentMessageQuestIndex ~= _QuestIndex
            and Quest.State == QuestState.Over and not QuestLog.IsQuestLogShown() then
            
            local CurrentQuest = Quests[g_Interaction.CurrentMessageQuestIndex]
            if CurrentQuest and type(CurrentQuest) == "table" and CurrentQuest.Objectives
                and CurrentQuest.Objectives[1] and CurrentQuest.Objectives[1].Type == Objective.Quest then
                
                -- Check if the just completed quest is a subquest of the currently shown quest, and if it was the active subquest
                local Data = CurrentQuest.Objectives[1].Data
                
                local SubQuestNumber = 1
                repeat
                    SubQuest = Quests[Data[SubQuestNumber]]
                    SubQuestNumber = SubQuestNumber + 1
                until not SubQuest or SubQuest == Quest or SubQuest.State == QuestState.Active
                
                if SubQuest and SubQuest == Quest then
                    -- The just completed quest was the active subquest of the currently visible quest
                    -- Thats the condition to update. BUT: Don't update in case its was the last active subquest
                    repeat
                        SubQuest = Quests[Data[SubQuestNumber]]
                        SubQuestNumber = SubQuestNumber + 1
                    until not SubQuest or SubQuest.State == QuestState.Active
                    
                    if SubQuest then
                        GUI_Interaction.StartMessageAgain(g_Interaction.CurrentMessageQuestIndex, false)
                    end
                end
            end
        end
        
    end
end


--this function can be used by the global script to queue messages
function LocalScriptCallback_QueueVoiceMessage(_PlayerID , _MessageBaseKey, _Random, _ReceivingPlayerID)

    if _ReceivingPlayerID == nil or _ReceivingPlayerID == GUI.GetPlayerID() then

        local QuestIndex = 0
        local PlayDirectly = false
        
        GUI_Interaction.GenerateVoiceMessage(QuestIndex, _PlayerID, _MessageBaseKey, PlayDirectly, _Random )
    end
    
end


--this function can be used by the global script to start messages directly
function LocalScriptCallback_StartVoiceMessage(_PlayerID , _MessageBaseKey, _Random, _ReceivingPlayerID, _NoPriority)

    if _ReceivingPlayerID == nil or _ReceivingPlayerID == GUI.GetPlayerID() then

        local QuestIndex = 0
        local PlayDirectly = true
        if _NoPriority then
            PlayDirectly = false
        end
        
        GUI_Interaction.GenerateVoiceMessage(QuestIndex, _PlayerID, _MessageBaseKey, PlayDirectly, _Random )
    end
    
end


function GUI_Interaction.GenerateVoiceMessage(_QuestIndex, _PlayerID, _MessageKey, _PlayDirectly, _Random, _OptionalPlayVoice, _HidePortrait, _OnlyIfMapSpecificKeyExists)


    if not _MessageKey then
        if Framework.IsDevM() then
            GUI.AddNote( string.format( "DEBUG: Empty message key for player %d, quest %d" ), _PlayerID or -1, _QuestIndex or -1 )
        end
        return false
    end
    
    --insert the message into message table
    local Messages = {}

    --first add pretext
    repeat

        local MessageKey = _MessageKey .. "_Pre" .. #Messages + 1

        local Random = false
        local PreText = true

        local TableAndKey = GetKeyAndTableForSpokenText(_QuestIndex, _PlayerID, MessageKey, Random, PreText)

        if TableAndKey ~= nil and ( not _OnlyIfMapSpecificKeyExists or string.find( TableAndKey, "^Map_" .. Framework.GetCurrentMapName() ) ) then
            table.insert(Messages, TableAndKey)
        end

    until TableAndKey == nil

    --and now the quest text
    local TableAndKey = GetKeyAndTableForSpokenText(_QuestIndex, _PlayerID, _MessageKey, _Random)

    --set key as text, when there is none
    if TableAndKey == nil then
        TableAndKey = _MessageKey
    end

    if not _OnlyIfMapSpecificKeyExists or string.find( TableAndKey, "^Map_" .. Framework.GetCurrentMapName() ) then
        table.insert(Messages, TableAndKey)
    end

    local MessageTextsNumber = #Messages
    
    if MessageTextsNumber == 0 then
        -- Nothing to say?
        return
    end
    
    --get actor
    local Actor = g_PlayerPortrait[_PlayerID]

    --take knight actor if human player
    if Logic.PlayerGetIsHumanFlag(_PlayerID) then
        local KnightID = Logic.GetKnightID(_PlayerID)

        if KnightID ~= 0 then
            local KnightEntityType = Logic.GetEntityType(KnightID)
            Actor = GetKnightActor(KnightEntityType)
        else
            Actor = "H_Knight_RedPrince"
        end
    end

    --get mood register depending on diplomacy state
    local ActorMood
    local PlayerID = GUI.GetPlayerID()
    local DiplomacyState = Diplomacy_GetRelationBetween(_PlayerID, PlayerID)

    if DiplomacyState == DiplomacyStates.Enemy then
        ActorMood = {"Mood_Angry", 0, 2, 0}
    elseif DiplomacyState >= DiplomacyStates.TradeContact then
        ActorMood = {"Mood_Friendly", 0, 2, 0}
    else
        ActorMood = nil
    end
    
    local PlayerName = GetPlayerName(_PlayerID)

    local MessageTable = {}
    MessageTable.QuestIndex     = _QuestIndex 
    MessageTable.PlayerID       = _PlayerID 
    MessageTable.Messages       = Messages     
    MessageTable.Actor          = Actor 
    MessageTable.ActorMood      = ActorMood 
    MessageTable.PlayVoice      = _OptionalPlayVoice 
    MessageTable.HidePortrait   = _HidePortrait 
    MessageTable.PlayerName     = PlayerName 
    MessageTable.InitialNumberOfMessages = MessageTextsNumber 
    
    if _PlayDirectly ~= true then
        --add message to the end of the list
        table.insert(g_VoiceMessagesQueue, MessageTable)
    else
        --push all messages back and set this on place one        
        table.insert(g_VoiceMessagesQueue, 1, MessageTable)
        g_Interaction.PlayMessageDirectly = true
    end
    
    --local Text = "Message GENERATED: " .. MessageTable.Messages[#Messages] 
    --GUI.AddNote(Text)
    
end

function GUI_Interaction.ResetVoiceMessageQueue()
    
    g_VoiceMessageEndTime = nil
    g_FeedbackSpeech.LastSpeechEndTime = nil
    g_VoiceMessagesQueue = {}
    
end

function GUI_Interaction.HideMessageUI()

    XGUIEng.ShowWidget("/InGame/Root/Normal/AlignBottomLeft/Message/MessagePortrait", 0)
    XGUIEng.ShowWidget("/InGame/Root/Normal/AlignBottomLeft/SubTitles", 0)
    XGUIEng.ShowAllSubWidgets("/InGame/Root/Normal/AlignBottomLeft/Message/QuestObjectives", 0)

end

function GUI_Interaction.UpdateVoiceMessage()

    --Get system time in seconds
    local Time = GUI.GetTime()
    
    if g_VoiceMessageEndTime == nil then
        g_VoiceMessageEndTime = 0
    end
    
    --reset stuff, when message is spoken to the end
    if Time >= g_VoiceMessageEndTime then
        g_VoiceMessageIsRunning = false
    end
    
    local CloseMessageAfterSomeTime = false
    
    --Texts will be closed, when not in tutorial
    if g_Interaction.CurrentMessageQuestIndex == 0
    and Tutorial == nil then    
        CloseMessageAfterSomeTime = true
    end
    
    --Quests will be closed when over
    if g_Interaction.CurrentMessageQuestIndex ~= 0 
    and Quests[g_Interaction.CurrentMessageQuestIndex] ~= nil
    and Quests[g_Interaction.CurrentMessageQuestIndex].State == QuestState.Over then
        CloseMessageAfterSomeTime = true
    end
    
    --all others stay until player close them or until a new message comes in
    if CloseMessageAfterSomeTime == true then
        if Time >= g_VoiceMessageEndTime + 5 then
            GUI_Interaction.HideMessageUI()
            g_Interaction.CurrentMessageQuestIndex = nil
            g_Interaction.CurrentMessageContent = nil
            g_Interaction.CurrentMessagePlayerID = nil
        end
    end
    
    --nothing in queue to display
    if #g_VoiceMessagesQueue == 0 then
        return
    end

    --start message when a PlayDirectly message comes or previous one has ended    
    if g_Interaction.PlayMessageDirectly == true
    or ( Time >= g_VoiceMessageEndTime 
    and (not g_FeedbackSpeech.LastSpeechEndTime or Framework.GetTimeMs() > g_FeedbackSpeech.LastSpeechEndTime)) then  -- Don't play while a feedback message plays
        
        local QuestIndex = g_VoiceMessagesQueue[1].QuestIndex
        local PlayerID   = g_VoiceMessagesQueue[1].PlayerID
        local MessageKey = g_VoiceMessagesQueue[1].Messages[1]
        local Actor      = g_VoiceMessagesQueue[1].Actor
        local ActorMood  = g_VoiceMessagesQueue[1].ActorMood
        local PlayVoice  = g_VoiceMessagesQueue[1].PlayVoice
        local HidePortrait = g_VoiceMessagesQueue[1].HidePortrait
        local PlayerName   = g_VoiceMessagesQueue[1].PlayerName

        --mark place on minimap if this quest is shown the first time
        if g_Interaction.CurrentMessageQuestIndex ~= QuestIndex then
            GUI_Interaction.JumpToEntityClicked(true)
        end
        
        local MessageDuration = GUI_Interaction.DisplayVoiceMessage(QuestIndex, PlayerID, MessageKey, Actor, ActorMood, PlayVoice, HidePortrait, PlayerName)
        
        --GUI.AddNote("Message DISPLAYED: " .. MessageKey)
        
        --save time for next message
        g_VoiceMessageEndTime = Time + MessageDuration + 1
        
        --set back global value that lets play the next message directly
        g_Interaction.PlayMessageDirectly = false
        
        --remove all messages         
        if #(g_VoiceMessagesQueue[1].Messages) > 1 then
            --first the sub messages
            table.remove(g_VoiceMessagesQueue[1].Messages, 1)
        else
            --and when all submessages played, delete the table
            table.remove(g_VoiceMessagesQueue, 1)
        end
        
        --save Index, the message and playerID for other widgets
        g_Interaction.CurrentMessageQuestIndex = QuestIndex
        g_Interaction.CurrentMessageContent = MessageKey
        g_Interaction.CurrentMessagePlayerID = PlayerID
        
        if not HidePortrait then
            GUI_Interaction.UpdateButtons()
        end
        
        
    end
       
	if QuestLog.IsQuestLogShown() then
        XGUIEng.ShowWidget("/InGame/Root/Normal/AlignBottomLeft/Message/MessagePortrait", 0)		
	else
		XGUIEng.ShowWidget("/InGame/Root/Normal/AlignBottomLeft/Message/MessagePortrait", 1)
	end

end


function GUI_Interaction.DisplayVoiceMessage(_QuestIndex, _PlayerID, _MessageKey, _Actor, _ActorMood, _OptionalPlayVoice, _HidePortrait, _PlayerName)
    
    if _QuestIndex ~= 0 and Quests[_QuestIndex].State == QuestState.Over and Quests[_QuestIndex].Result == QuestResult.Interrupted then 
        return 0
    end

    local PlayerNameWidget = "/InGame/Root/Normal/AlignBottomLeft/Message/MessagePortrait/PlayerName"
    local PlayerNameWidget2 = "/InGame/Root/Normal/AlignBottomLeft/Message/MessagePortrait/PlayerName2"
    local PortraitWidget = "/InGame/Root/Normal/AlignBottomLeft/Message/MessagePortrait/3DPortraitFaceFX"

    --Set Player Name
    local PlayerName = _PlayerName
    XGUIEng.SetText(PlayerNameWidget, "{center}" .. PlayerName)
    XGUIEng.SetText(PlayerNameWidget2, "{center}" .. PlayerName)

    --set Message
    local MessageText = "Text missing"

    if _MessageKey ~= nil then

        MessageText = Wrapped_GetStringTableText(_QuestIndex, _MessageKey)

        if MessageText == "" then
        
            if _QuestIndex ~= 0 and Quests[_QuestIndex].QuestDescription ~= nil then            
                MessageText = string.match( Quests[_QuestIndex].QuestDescription, "^[^~]+ ~ (.+)$" ) or Quests[_QuestIndex].QuestDescription                
            else            
                MessageText = _MessageKey .."(key?)"                
            end
            
        end
    end

    GUI_Interaction.SubtitlesUpdate(MessageText, _Actor, _HidePortrait)
    XGUIEng.ShowWidget("/InGame/Root/Normal/AlignBottomLeft/SubTitles", 1)

    local Duration = 0
 
 	if _HidePortrait then --no portrait nor voice if the objective is displayed  by the questlog
   	
    		XGUIEng.ShowWidget("/InGame/Root/Normal/AlignBottomLeft/Message/MessagePortrait", 0)
  	else

        -- set actor if not already set
        if _PlayerID ~= g_Interaction.CurrentMessagePlayerID
        or GUI.PortraitWidgetHasActor(PortraitWidget) == false
        then
            SetPortraitWithCameraSettings(PortraitWidget, _Actor)
        end
    
        -- set mood register
        if _ActorMood == nil then
            GUI.PortraitWidgetSetRegister(PortraitWidget, "Mood_Friendly", 1,2,0)
            GUI.PortraitWidgetSetRegister(PortraitWidget, "Mood_Angry", 1,2,0)
        else
            GUI.PortraitWidgetSetRegister(PortraitWidget, _ActorMood[1], _ActorMood[2], _ActorMood[3], _ActorMood[4])
        end
    
        if _OptionalPlayVoice ~= false then
            -- play a sound voice from the category "LypSync"
            local FaceAnimation = string.lower(_MessageKey)        
            FaceAnimation = string.gsub(FaceAnimation, "/", "_")   
    
            Duration = GUI.PortraitWidgetPlayAnimation(PortraitWidget, FaceAnimation, "LipSync")
            g_VoiceMessageIsRunning = true
        else
            g_VoiceMessageIsRunning = false
        end
        
        --min. length, in case there's no voice file
        if Duration < 4 then
            g_VoiceForceSubTitles = true
            local _, WordCount = string.gsub( MessageText, "%w+", {} )
            if WordCount then
                -- Assume an average read speed of about 250 words per minute
                Duration =  math.floor( WordCount / 4 + 0.5 )
                Duration = Duration + 1 -- Add a bonus second. This is quite useful for short sentences
            end
            if Duration < 4 then
                Duration = 4
            end
        else
            g_VoiceForceSubTitles = nil
        end
        
        if g_Victory ~= true then
            XGUIEng.ShowWidget("/InGame/Root/Normal/AlignBottomLeft/Message/MessagePortrait/SpeechStartAgainOrStop", 1)
        end
        
        --just to avoid flickering:
        GUI_Interaction.SpeechStartAgainOrStopUpdate()
        
        ---GUI_Interaction.UpdateButtons()

		local x,y = XGUIEng.GetWidgetLocalPosition( "/InGame/Root/Normal/AlignBottomLeft/Message/QuestObjectives" )
        XGUIEng.SetWidgetLocalPosition( "/InGame/Root/Normal/AlignBottomLeft/Message/QuestObjectives", 0, y )
        XGUIEng.ShowWidget("/InGame/Root/Normal/AlignBottomLeft/Message/QuestObjectives", 1)

        XGUIEng.ShowWidget(QuestLog.Widget.Main,0)
        XGUIEng.HighLightButton(QuestLog.Widget.Button,0)

		XGUIEng.ShowWidget("/InGame/Root/Normal/AlignBottomLeft/Message/MessagePortrait", 1)

    end
  
    
    GUI_Interaction.DisplayQuestObjective(_QuestIndex, _MessageKey)
    
    
    return Duration
end


function GUI_Interaction.SaveQuestEntityTypes(_QuestIndex)
    
    --do it only once for one quest
    if g_Interaction.SavedQuestEntityTypes[_QuestIndex] ~= nil then
        return
    end
    
    local Quest, QuestType = GUI_Interaction.GetPotentialSubQuestAndType(_QuestIndex)
    local EntitiesList
    
    if (QuestType == Objective.Protect
    or QuestType == Objective.Object) then
        EntitiesList = Quest.Objectives[1].Data

    elseif (QuestType == Objective.DestroyEntities
    or QuestType == Objective.Capture) then
        local EntitiesListType = Quest.Objectives[1].Data[1]
        
        if EntitiesListType == 1 then
            EntitiesList = GUI_Interaction.GetEntitiesOrTerritoryListForQuest( Quest, QuestType )
            EntitiesList[0] = #EntitiesList
        end
    
    elseif QuestType == Objective.Steal then
        EntitiesList = Quest.Objectives[1].Data[2]

    end

    if EntitiesList ~= nil then
        g_Interaction.SavedQuestEntityTypes[_QuestIndex] = {}
        
        for i = 1, EntitiesList[0] do
            if Logic.IsEntityAlive( EntitiesList[i] ) then
                local EntityType = Logic.GetEntityType( GetEntityId(EntitiesList[i]))
                table.insert(g_Interaction.SavedQuestEntityTypes[_QuestIndex], i, EntityType)
            end
        end
    end
end


function GUI_Interaction.SubtitlesUpdate(_MessageText, _Actor, _HidePortrait)

    if _MessageText ~= nil then
        XGUIEng.SetText("/InGame/Root/Normal/AlignBottomLeft/SubTitles/VoiceText1", _MessageText)
        
        local Height = XGUIEng.GetTextHeight("/InGame/Root/Normal/AlignBottomLeft/SubTitles/VoiceText1", true)
        local W, H = XGUIEng.GetWidgetSize("/InGame/Root/Normal/AlignBottomLeft/SubTitles/VoiceText1")
        
        XGUIEng.SetWidgetSize("/InGame/Root/Normal/AlignBottomLeft/SubTitles/BG", W + 10, Height + 120)

        local X,Y = XGUIEng.GetWidgetLocalPosition("/InGame/Root/Normal/AlignBottomLeft/SubTitles")
        Y = 675-Height
        XGUIEng.SetWidgetLocalPosition("/InGame/Root/Normal/AlignBottomLeft/SubTitles", X, Y )
    end

    --Subtitles as an Option
    local Subtitles = Options.GetIntValue("Video", "Subtitles")

    if (Subtitles == 1) or (g_VoiceForceSubTitles ~= nil) then
        XGUIEng.ShowWidget("/InGame/Root/Normal/AlignBottomLeft/SubTitles/BG", 1)
        XGUIEng.ShowWidget("/InGame/Root/Normal/AlignBottomLeft/SubTitles/VoiceText1", 1)
    else
        XGUIEng.ShowWidget("/InGame/Root/Normal/AlignBottomLeft/SubTitles/BG", 0)
        XGUIEng.ShowWidget("/InGame/Root/Normal/AlignBottomLeft/SubTitles/VoiceText1", 0)
    end
end



--which containers to use
--Objective.Deliver             Deliver
--Objective.Protect             GroupEntityType
--Objective.DestroyPlayers      DestroyPlayer
--Objective.DestroyEntities     GroupEntityType *
--Objective.Capture             GroupEntityType *
--Objective.Discover            List
--Objective.Create              GroupEntityType **
--Objective.Diplomacy           Diplomacy
--Objective.KnightTitle         KnightTitle
--Objective.Object              List
--Objective.Claim               Claim
--Objective.Steal               Steal
--Objective.SatisfyNeed         Need
--Objective.SettlersNumber      SettlersNumber
--Objective.Distance            Distance
--Objective.Spouses             SettlersNumber
--Objective.Custom              Custom
--Objective.Produce             Deliver

-- * can have PlayerID shown
-- ** can have TerritoryID shown

function GUI_Interaction.DisplayQuestObjective(_QuestIndex, _MessageKey)
    -- Quest index is a string sometimes
    local QuestIndexTemp = tonumber(_QuestIndex)
    if QuestIndexTemp then
        _QuestIndex = QuestIndexTemp
    end
    
    local Quest, QuestType = GUI_Interaction.GetPotentialSubQuestAndType(_QuestIndex)
    
    local QuestObjectivesPath = "/InGame/Root/Normal/AlignBottomLeft/Message/QuestObjectives"
    XGUIEng.ShowAllSubWidgets("/InGame/Root/Normal/AlignBottomLeft/Message/QuestObjectives", 0)
    local QuestObjectiveContainer
    local QuestTypeCaption
    
    local ParentQuest = Quests[_QuestIndex]
    local ParentQuestIdentifier
    
    if ParentQuest ~= nil
    and type(ParentQuest) == "table" then
        ParentQuestIdentifier = ParentQuest.Identifier
    end
    
    local HookTable = {}
    
    --if independent message, display short text if available
    --don't show objectives if it's the end message of a hidden quest, because that would be confusing
    if (_QuestIndex == 0
    or ParentQuest.Visible == false
    or ParentQuestIdentifier == "TravelingSalesman") then
        QuestObjectiveContainer = QuestObjectivesPath .. "/Message"
        
        local MessageKeyNoSpeech = string.gsub(_MessageKey, "_speech", "")
        local MessageText = Wrapped_GetStringTableText(_QuestIndex, MessageKeyNoSpeech)
        
        XGUIEng.SetText(QuestObjectiveContainer .. "/Text", MessageText)
        
        if MessageText == "" then
            XGUIEng.ShowWidget(QuestObjectiveContainer .. "/BGDeco", 1)
        else
            XGUIEng.ShowWidget(QuestObjectiveContainer .. "/BGDeco", 0)
        end
        
    elseif (QuestType == Objective.Deliver 
    or QuestType == Objective.Produce or QuestType == Objective.GoodAmount ) then
        QuestObjectiveContainer = QuestObjectivesPath .. "/Deliver"

        if QuestType == Objective.Deliver then
            QuestTypeCaption = Wrapped_GetStringTableText(_QuestIndex, "UI_Texts/QuestDeliver")
        elseif QuestType == Objective.Produce or QuestType == Objective.GoodAmount then
            QuestTypeCaption = Wrapped_GetStringTableText(_QuestIndex, "UI_Texts/QuestProduce")
        end

        local GoodType = Quest.Objectives[1].Data[1]
        local Icon = g_TexturePositions.Goods[GoodType]
        SetIcon(QuestObjectiveContainer .. "/Icon", Icon)
        
        local GoodAmount = Quest.Objectives[1].Data[2]
        XGUIEng.SetText(QuestObjectiveContainer .. "/Amount", "{center}" .. GoodAmount)
        
    elseif QuestType == Objective.Protect then
        QuestObjectiveContainer = QuestObjectivesPath .. "/GroupEntityType"
        XGUIEng.ShowWidget(QuestObjectiveContainer .. "/AdditionalCaption", 0)
        XGUIEng.ShowWidget(QuestObjectiveContainer .. "/AdditionalCondition", 0)
        
        QuestTypeCaption = Wrapped_GetStringTableText(_QuestIndex, "UI_Texts/QuestProtect")
        
        local EntitiesList = Quest.Objectives[1].Data
        local Icon = GUI_Interaction.GetGroupEntityTypeIcon(EntitiesList)
        
        if Icon == nil then
            Icon = GUI_Interaction.GetGroupEntityTypeIcon(assert(g_Interaction.SavedQuestEntityTypes[_QuestIndex]), true)
        end
        
        SetIcon(QuestObjectiveContainer .. "/Icon", Icon)
        
        local EntitiesNumber = EntitiesList[0]
        XGUIEng.SetText(QuestObjectiveContainer .. "/Number", "{center}" .. EntitiesNumber)
        
    elseif QuestType == Objective.DestroyPlayers or QuestType == Objective.DestroyAllPlayerUnits then
        QuestObjectiveContainer = QuestObjectivesPath .. "/DestroyPlayer"
        
        QuestTypeCaption = Wrapped_GetStringTableText(_QuestIndex, "UI_Texts/QuestDestroyFaction")
        
        local TargetPlayerID = Quest.Objectives[1].Data
        local TargetPlayerName = GetPlayerName(TargetPlayerID)
        XGUIEng.SetText(QuestObjectiveContainer .. "/PlayerName", "{center}" .. TargetPlayerName)
    
    elseif (QuestType == Objective.DestroyEntities
    or QuestType == Objective.Capture) then
        QuestObjectiveContainer = QuestObjectivesPath .. "/GroupEntityType"
        
        if QuestType == Objective.DestroyEntities then
            QuestTypeCaption = Wrapped_GetStringTableText(_QuestIndex, "UI_Texts/QuestDestroy")
        elseif QuestType == Objective.Capture then
            QuestTypeCaption = Wrapped_GetStringTableText(_QuestIndex, "UI_Texts/QuestCapture")
        end
        
        local EntitiesListType = Quest.Objectives[1].Data[1]
        
        local Icon
        local EntitiesNumber
        
        if EntitiesListType == 1 then
            local EntitiesList = GUI_Interaction.GetEntitiesOrTerritoryListForQuest( Quest, QuestType )
            EntitiesList[0] = #EntitiesList
            Icon = GUI_Interaction.GetGroupEntityTypeIcon(EntitiesList)
            
            if Icon == nil then
                Icon = GUI_Interaction.GetGroupEntityTypeIcon(assert(g_Interaction.SavedQuestEntityTypes[_QuestIndex]), true)
            end
            
            EntitiesNumber = EntitiesList[0]
            
            XGUIEng.ShowWidget(QuestObjectiveContainer .. "/AdditionalCaption", 0)
            XGUIEng.ShowWidget(QuestObjectiveContainer .. "/AdditionalCondition", 0)
        
        elseif EntitiesListType == 2 then
            local EntityTypeToDestroy = Quest.Objectives[1].Data[2]
            Icon = g_TexturePositions.Entities[EntityTypeToDestroy]
            
            EntitiesNumber = Quest.Objectives[1].Data[3]
            
            local PlayerIDToDestroyEntitiesFrom = Quest.Objectives[1].Data[4]
            
            if PlayerIDToDestroyEntitiesFrom ~= 0 then
                local AdditionalCaption = Wrapped_GetStringTableText(_QuestIndex, "UI_Texts/QuestCaptionOfThisFaction_colon")
                XGUIEng.SetText(QuestObjectiveContainer .. "/AdditionalCaption", "{center}" .. AdditionalCaption)
                
                local PlayerName = GetPlayerName(PlayerIDToDestroyEntitiesFrom)
                XGUIEng.SetText(QuestObjectiveContainer .. "/AdditionalCondition", "{center}" .. PlayerName)

                XGUIEng.ShowWidget(QuestObjectiveContainer .. "/AdditionalCaption", 1)
                XGUIEng.ShowWidget(QuestObjectiveContainer .. "/AdditionalCondition", 1)
            else
                XGUIEng.ShowWidget(QuestObjectiveContainer .. "/AdditionalCaption", 0)
                XGUIEng.ShowWidget(QuestObjectiveContainer .. "/AdditionalCondition", 0)
            end
        end
        
        SetIcon(QuestObjectiveContainer .. "/Icon", Icon)
        XGUIEng.SetText(QuestObjectiveContainer .. "/Number", "{center}" .. EntitiesNumber)
        
    elseif QuestType == Objective.Discover then
        QuestObjectiveContainer = QuestObjectivesPath .. "/List"
        QuestTypeCaption = Wrapped_GetStringTableText(_QuestIndex, "UI_Texts/QuestDiscover")

        local DiscoverList = {}
        local DiscoverListType = Quest.Objectives[1].Data[1]
        
        if DiscoverListType == 1 then
            for i = 1, Quest.Objectives[1].Data[2][0] do
                local TerritoryID = Quest.Objectives[1].Data[2][i]
                local TerritoryName = GetTerritoryName(TerritoryID)
                
                table.insert(DiscoverList, TerritoryName)
            end
        elseif DiscoverListType == 2 then
            for i = 1, Quest.Objectives[1].Data[2][0] do
                local DiscoverPlayerID = Quest.Objectives[1].Data[2][i]
                local PlayerName = GetPlayerName(DiscoverPlayerID)
                
                table.insert(DiscoverList, PlayerName)
            end
        end
        
        for i = 1, 4 do
            local String = DiscoverList[i]
            
            if String == nil then
                String = ""
            end
            
            XGUIEng.SetText(QuestObjectiveContainer .. "/Entry" .. i, "{center}" .. String)
        end
        
    elseif QuestType == Objective.Create then
        QuestObjectiveContainer = QuestObjectivesPath .. "/GroupEntityType"

        local EntityTypeToCreate = Quest.Objectives[1].Data[1]
        local Icon = g_TexturePositions.Entities[EntityTypeToCreate]
        
        if Logic.IsEntityTypeInCategory(EntityTypeToCreate, EntityCategories.Military) == 1 then
            QuestTypeCaption = Wrapped_GetStringTableText(_QuestIndex, "UI_Texts/QuestRecruit")
            
            if (EntityTypeToCreate == Entities.U_MilitaryCatapult
            or EntityTypeToCreate == Entities.U_MilitarySiegeTower
            or EntityTypeToCreate == Entities.U_MilitaryBatteringRam) then
                QuestTypeCaption = Wrapped_GetStringTableText(_QuestIndex, "UI_Texts/QuestAssemble")
            end
            
            if Icon == nil then
                Icon = g_TexturePositions.QuestTypes["CreateMilitary"]
            end
        elseif EntityTypeToCreate == Entities.A_X_Cow01
            or EntityTypeToCreate == Entities.A_X_Sheep01
            or EntityTypeToCreate == Entities.A_X_Sheep02 then
                QuestTypeCaption = Wrapped_GetStringTableText(_QuestIndex, "UI_Texts/QuestAcquire")
                if Icon == nil then
                    Icon = g_TexturePositions.QuestTypes["CreateOther"]
                end            
        else
            QuestTypeCaption = Wrapped_GetStringTableText(_QuestIndex, "UI_Texts/QuestBuild")
            
            if Icon == nil then
                Icon = g_TexturePositions.QuestTypes["CreateOther"]
            end
        end
        
        SetIcon(QuestObjectiveContainer .. "/Icon", Icon)

        local EntitiesNumber = Quest.Objectives[1].Data[2]
        XGUIEng.SetText(QuestObjectiveContainer .. "/Number", "{center}" .. EntitiesNumber)

        local TerritoryIDToCreateEntitiesOn = Quest.Objectives[1].Data[3]
        
        if (TerritoryIDToCreateEntitiesOn ~= nil
        and TerritoryIDToCreateEntitiesOn ~= 0) then
            local AdditionalCaption = Wrapped_GetStringTableText(_QuestIndex, "UI_Texts/QuestCaptionOnThisTerritory_colon")
            XGUIEng.SetText(QuestObjectiveContainer .. "/AdditionalCaption", "{center}" .. AdditionalCaption)
            
            local TerritoryName = GetTerritoryName(TerritoryIDToCreateEntitiesOn)
            XGUIEng.SetText(QuestObjectiveContainer .. "/AdditionalCondition", "{center}" .. TerritoryName)

            XGUIEng.ShowWidget(QuestObjectiveContainer .. "/AdditionalCaption", 1)
            XGUIEng.ShowWidget(QuestObjectiveContainer .. "/AdditionalCondition", 1)
        else
            XGUIEng.ShowWidget(QuestObjectiveContainer .. "/AdditionalCaption", 0)
            XGUIEng.ShowWidget(QuestObjectiveContainer .. "/AdditionalCondition", 0)
        end

    elseif QuestType == Objective.Diplomacy then
        QuestObjectiveContainer = QuestObjectivesPath .. "/Diplomacy"
        QuestTypeCaption = Wrapped_GetStringTableText(_QuestIndex, "UI_Texts/QuestDiplomacy")
        
        local DiplomacyPlayerID = Quest.Objectives[1].Data[1]
        local DiplomacyState = Quest.Objectives[1].Data[2]
        
        local DiplomacyStateName = GetNameOfDiplomacyState(DiplomacyState)
        XGUIEng.SetText(QuestObjectiveContainer .. "/ConditionDiplomacyState", "{center}" .. DiplomacyStateName)

        local DiplomacyPlayerName = GetPlayerName(DiplomacyPlayerID)
        XGUIEng.SetText(QuestObjectiveContainer .. "/ConditionFaction", "{center}" .. DiplomacyPlayerName)
        
    elseif QuestType == Objective.KnightTitle then
        QuestObjectiveContainer = QuestObjectivesPath .. "/KnightTitle"
        QuestTypeCaption = Wrapped_GetStringTableText(_QuestIndex, "UI_Texts/QuestKnightTitle")
        
        local KnightTitleToGet = Quest.Objectives[1].Data
        local Icon = g_TexturePositions.KnightTitles[KnightTitleToGet]
        SetIcon(QuestObjectiveContainer .. "/Icon", Icon)
        
        local QuestPlayerID = Quest.ReceivingPlayer
        local KnightID = Logic.GetKnightID(QuestPlayerID)
        local KnightType = Logic.GetEntityType(KnightID)
        local TitleName = GUI_Knight.GetTitleNameByTitleID(KnightType, KnightTitleToGet)
        XGUIEng.SetText(QuestObjectiveContainer .. "/KnightTitleName", "{center}" .. TitleName)
    
    elseif QuestType == Objective.Object then
        QuestObjectiveContainer = QuestObjectivesPath .. "/List"
        QuestTypeCaption = Wrapped_GetStringTableText(_QuestIndex, "UI_Texts/QuestInteraction")

        local ObjectList = {}
        
        for i = 1, Quest.Objectives[1].Data[0] do
            local ObjectType
            if Logic.IsEntityDestroyed(Quest.Objectives[1].Data[i]) then
                ObjectType = g_Interaction.SavedQuestEntityTypes[_QuestIndex][i]
            else
                ObjectType = Logic.GetEntityType(GetEntityId(Quest.Objectives[1].Data[i]))
            end

            local ObjectName = ""
            
            if ObjectType ~= 0 then
                local ObjectTypeName = Logic.GetEntityTypeName(ObjectType)
                ObjectName = Wrapped_GetStringTableText(_QuestIndex, "Names/" .. ObjectTypeName)
                
                if ObjectName == "" then
                    ObjectName = Wrapped_GetStringTableText(_QuestIndex, "UI_ObjectNames/" .. ObjectTypeName)
                end
    
                if ObjectName == "" then
                    ObjectName = "Debug: ObjectName missing for " .. ObjectTypeName
                end
            end
            
            table.insert(ObjectList, ObjectName)
        end
        
        for i = 1, 4 do
            local String = ObjectList[i]
            
            if String == nil then
                String = ""
            end
            
            XGUIEng.SetText(QuestObjectiveContainer .. "/Entry" .. i, "{center}" .. String)
        end

    elseif QuestType == Objective.Claim then
        QuestObjectiveContainer = QuestObjectivesPath .. "/Claim"

        local ClaimType = Quest.Objectives[1].Data[1]
        local ClaimCaption
        local TerritoryNameOrNumber
        
        if ClaimType == 1 then
            QuestTypeCaption = Wrapped_GetStringTableText(_QuestIndex, "UI_Texts/QuestClaimTerritory")
            ClaimCaption = Wrapped_GetStringTableText(_QuestIndex, "UI_Texts/QuestCaptionClaimThisTerritory_colon")
            
            local TerritoryID = Quest.Objectives[1].Data[2]
            TerritoryNameOrNumber = GetTerritoryName(TerritoryID)
            
        elseif ClaimType == 2 then
            QuestTypeCaption = Wrapped_GetStringTableText(_QuestIndex, "UI_Texts/QuestClaimTerritories")
            ClaimCaption = Wrapped_GetStringTableText(_QuestIndex, "UI_Texts/QuestCaptionClaimThisNumberOfTerritories_colon")
            
            local TerritoryNumber = Quest.Objectives[1].Data[2]
            TerritoryNameOrNumber = TerritoryNumber .. " " .. Wrapped_GetStringTableText(_QuestIndex, "UI_Texts/QuestCaptionTerritories")
        end
        
        XGUIEng.SetText(QuestObjectiveContainer .. "/CaptionClaim", "{center}" .. ClaimCaption)
        XGUIEng.SetText(QuestObjectiveContainer .. "/TerritoryNameOrNumber", "{center}" .. TerritoryNameOrNumber)

    elseif QuestType == Objective.Steal then
        QuestObjectiveContainer = QuestObjectivesPath .. "/Steal"
        QuestTypeCaption = Wrapped_GetStringTableText(_QuestIndex, "UI_Texts/QuestSteal")
        
        local StealType = Quest.Objectives[1].Data[1]
        
        if StealType == 2 then
            GUI.AddNote("Debug: Objective.Steal - mode 2 unsupported")
        end
        
        local StealList = Quest.Objectives[1].Data[2]

        if StealList[0] > 1 then
            GUI.AddNote("Debug: Objective.Steal - more than 1 Entity in list unsupported")
        end

        local StealEntityID = StealList[1]
        local StealEntityType = Logic.GetEntityType(StealEntityID)

        if Logic.IsEntityDestroyed(StealEntityID) == true then
            StealEntityType = g_Interaction.SavedQuestEntityTypes[_QuestIndex][1]
        end
        
        local Icon = g_TexturePositions.Entities[StealEntityType]
        
        if Icon == nil then
            Icon =  {5,6}
        end
        
        SetIcon(QuestObjectiveContainer .. "/Icon", Icon)
        
        local StealPlayerID = Logic.EntityGetPlayer(StealEntityID)
        local StealPlayerName = GetPlayerName(StealPlayerID)
        XGUIEng.SetText(QuestObjectiveContainer .. "/ConditionFaction", "{center}" .. StealPlayerName)
    
    elseif QuestType == Objective.SatisfyNeed then
        QuestObjectiveContainer = QuestObjectivesPath .. "/Need"
        QuestTypeCaption = Wrapped_GetStringTableText(_QuestIndex, "UI_Texts/QuestSatisfyNeed")
        XGUIEng.SetTextKeyName(QuestObjectiveContainer .. "/AdditionalCaption", "UI_Texts/QuestCaptionThereMustBeNoSettlersStrikingDueToThisNeed_center" )
        
        GUI_Interaction.SetQuestTypeIcon(QuestObjectiveContainer .. "/Icon", _QuestIndex)
        
        --check for unsupported quest
--        local QuestPlayerID = Quest.ReceivingPlayer
--        local NeedPlayerID = Quest.Objectives[1].Data[2]
--        
--        if NeedPlayerID ~= nil
--        and NeedPlayerID ~= 0
--        and NeedPlayerID ~= QuestPlayerID then
--            GUI.AddNote("Debug: Objective.SatisfyNeed - unsupported for other Player than Quest.ReceivingPlayer")
--        end

    elseif (QuestType == Objective.SettlersNumber
    or QuestType == Objective.Spouses) then
        QuestObjectiveContainer = QuestObjectivesPath .. "/SettlersNumber"
        
        local AdditionalCaption
        local Icon
        local Number
        
        if QuestType == Objective.SettlersNumber then
            QuestTypeCaption = Wrapped_GetStringTableText(_QuestIndex, "UI_Texts/QuestSettlersNumber")
            AdditionalCaption = Wrapped_GetStringTableText(_QuestIndex, "UI_Texts/QuestCaptionNumberOfSettlersToReach")
            
            Number = Quest.Objectives[1].Data[2]
            
            --check for unsupported quest
--            local SettlersNumberPlayerID = Quest.Objectives[1].Data[1]
--            local QuestPlayerID = Quest.ReceivingPlayer
--            
--            if SettlersNumberPlayerID ~= nil
--            and SettlersNumberPlayerID ~= 0
--            and SettlersNumberPlayerID ~= QuestPlayerID then
--                GUI.AddNote("Debug: Objective.SettlersNumber - unsupported for other Player than Quest.ReceivingPlayer")
--            end
            
        elseif QuestType == Objective.Spouses then
            QuestTypeCaption = Wrapped_GetStringTableText(_QuestIndex, "UI_Texts/QuestSpousesNumber")
            AdditionalCaption = Wrapped_GetStringTableText(_QuestIndex, "UI_Texts/QuestCaptionNumberOfSpousesToReach")
            Number = Quest.Objectives[1].Data

            local QuestPlayerID = Quest.ReceivingPlayer
        end
        
        XGUIEng.SetText(QuestObjectiveContainer .. "/AdditionalCaption", "{center}" .. AdditionalCaption)
        XGUIEng.SetText(QuestObjectiveContainer .. "/Number", "{center}" .. Number)
        
        GUI_Interaction.SetQuestTypeIcon(QuestObjectiveContainer .. "/Icon", _QuestIndex)

    elseif QuestType == Objective.Distance then
        QuestObjectiveContainer = QuestObjectivesPath .. "/Distance"
        QuestTypeCaption = Wrapped_GetStringTableText(_QuestIndex, "UI_Texts/QuestMoveHere")
        
        local MoverEntityID = GetEntityId(Quest.Objectives[1].Data[1])
        local MoverEntityType = Logic.GetEntityType(MoverEntityID)
        local MoverIcon = g_TexturePositions.Entities[MoverEntityType]
        SetIcon(QuestObjectiveContainer .. "/IconMover", MoverIcon)
        
        local TargetEntityID = GetEntityId(Quest.Objectives[1].Data[2])
        local TargetEntityType = Logic.GetEntityType(TargetEntityID)
        local TargetIcon = g_TexturePositions.Entities[TargetEntityType]
        
        local IconWidget = QuestObjectiveContainer .. "/IconTarget"
        local ColorWidget = QuestObjectiveContainer .. "/TargetPlayerColor"
        
        if TargetIcon ~= nil then
            SetIcon(IconWidget, TargetIcon)
            XGUIEng.SetMaterialColor(ColorWidget, 0, 255, 255, 255, 0)
        else
            local TargetPlayerID = 0
            if TargetEntityID ~= 0 and TargetEntityType ~= 0 then --avoids an assert
                TargetPlayerID = Logic.EntityGetPlayer(TargetEntityID)
            end
            local QuestPlayerID = Quest.ReceivingPlayer
            
            if TargetPlayerID ~= 0
            and TargetPlayerID ~= QuestPlayerID then
                SetPlayerIcon(TargetPlayerID, IconWidget, ColorWidget)
            else
                SetIcon(IconWidget, g_TexturePositions.QuestTypes[Objective.Distance])
                XGUIEng.SetMaterialColor(ColorWidget, 0, 255, 255, 255, 0)
            end
        end

    elseif QuestType == Objective.Custom or QuestType == Objective.Custom2 or QuestType == Objective.NoChange then

        QuestObjectiveContainer = QuestObjectivesPath .. "/Custom"
        
        local CustomQuestText = GetMessageTextForCustomQuest(_QuestIndex)
        XGUIEng.SetText(QuestObjectiveContainer .. "/Text", CustomQuestText)
        
        if CustomQuestText == "" then
            XGUIEng.ShowWidget(QuestObjectiveContainer .. "/BGDeco", 1)
        else
            XGUIEng.ShowWidget(QuestObjectiveContainer .. "/BGDeco", 0)
        end
       
    elseif QuestType == Objective.BuildRoad then
        QuestObjectiveContainer = QuestObjectivesPath .. "/Need"
        local bPavedOnly = Quest.Objectives[1].Data[5]
        local QuestTypeAdditionalCaptionKey, Icon
        if bPavedOnly then
            QuestTypeCaption = XGUIEng.GetStringTableText("UI_Texts/QuestCaptionBuildRoadFromAToB")
            QuestTypeAdditionalCaptionKey = "UI_Texts/QuestBuildRoad"
            Icon = g_TexturePositions.Technologies[Technologies.R_Street]
        else
            QuestTypeCaption = XGUIEng.GetStringTableText("UI_Texts/QuestCaptionBuildPathFromAToB")
            QuestTypeAdditionalCaptionKey = "UI_Texts/QuestBuildPath"
            Icon = g_TexturePositions.Technologies[Technologies.R_Trail]
        end

        XGUIEng.SetText(QuestObjectiveContainer .. "/Caption", QuestTypeCaption )
        XGUIEng.SetTextKeyName(QuestObjectiveContainer .. "/AdditionalCaption", QuestTypeAdditionalCaptionKey )

        SetIcon(QuestObjectiveContainer .. "/Icon", Icon)
        SetIcon(QuestObjectiveContainer .. "/QuestTypeIcon", Icon)
        
    elseif GUI_Interaction.DisplayQuestObjectiveEx1 ~= nil 
    and GUI_Interaction.DisplayQuestObjectiveEx1(Quest, QuestType, HookTable) then
    
        -- copy relevant data back
        QuestObjectiveContainer = HookTable.QuestObjectiveContainer
        QuestTypeCaption        = HookTable.QuestTypeCaption
    
    end
    
    --end if dummy quest
    if QuestObjectiveContainer == nil then
        return
    end
    
    if _QuestIndex ~= 0
    and ParentQuest.Visible ~= false
    and ParentQuestIdentifier ~= "TravelingSalesman" then
        if (QuestType ~= Objective.Custom) and (QuestType ~= Objective.Custom2) and (QuestType ~= Objective.NoChange) then
            XGUIEng.SetText(QuestObjectiveContainer .. "/Caption", "{center}" .. QuestTypeCaption)
        end
        
        GUI_Interaction.SetQuestTypeIcon(QuestObjectiveContainer .. "/QuestTypeIcon", _QuestIndex)
        
        if Quest.State == QuestState.Over then
            if Quest.Result == QuestResult.Success then
                XGUIEng.ShowWidget(QuestObjectivesPath .. "/QuestOverSuccess", 1)
            elseif Quest.Result == QuestResult.Failure then
                XGUIEng.ShowWidget(QuestObjectivesPath .. "/QuestOverFailure", 1)
            end
        end
    end
    
    XGUIEng.ShowWidget(QuestObjectiveContainer, 1)
end


function GUI_Interaction.GetGroupEntityTypeIcon(_EntitiesList, _OptionalTypesListBoolean)
    
    local EntityType
    
    if _OptionalTypesListBoolean ~= true then
        local EntityID = _EntitiesList[1]
        if Logic.IsEntityAlive( EntityID ) then
            EntityType = Logic.GetEntityType(GetEntityId(EntityID))
        else
            EntityType = 0
        end
    else
        EntityType = _EntitiesList[1]
    end
    
    local AreAllEntityTypesTheSame = true
    local Limit
    
    if _OptionalTypesListBoolean ~= true then
        Limit = _EntitiesList[0]
    else
        Limit = #_EntitiesList
    end
    
    for i = 2, Limit do
        local ListEntityType
        
        if _OptionalTypesListBoolean ~= true then
            if Logic.IsEntityAlive( _EntitiesList[i] ) then
                ListEntityType = Logic.GetEntityType(GetEntityId(_EntitiesList[i]))
            else
                ListEntityType = 0
            end
        else
            ListEntityType = _EntitiesList[i]
        end
        
        if ListEntityType ~= EntityType
            and ( Logic.IsEntityTypeInCategory( EntityType, EntityCategories.AttackableAnimal ) == 0          -- HACK for lion packs. Those contain male and female lions.
            or Logic.IsEntityTypeInCategory( ListEntityType, EntityCategories.AttackableAnimal ) == 0 ) then  --  This would lead to a building icon to be displayed
            
            AreAllEntityTypesTheSame = false
            break
        end
    end
    
    local Icon
    
    if AreAllEntityTypesTheSame == true then
        Icon = g_TexturePositions.Entities[EntityType]
    end
    
    if AreAllEntityTypesTheSame ~= true then
        if Logic.IsEntityTypeInCategory(EntityType, EntityCategories.Military) == 1 then
            Icon = {7, 11}
        elseif Logic.IsEntityTypeInCategory(EntityType, EntityCategories.AttackableBuilding) then
            Icon = {8, 1}
        end
    end
    
    return Icon
end


--ToDo when we have voice files
function GUI_Interaction.SpeechStartAgainOrStopClicked()
    
    local QuestIndexOrMessageContent

    if g_Interaction.CurrentMessageQuestIndex ~= 0 then
        QuestIndexOrMessageContent = g_Interaction.CurrentMessageQuestIndex        
    else
        QuestIndexOrMessageContent = g_Interaction.CurrentMessageContent        
    end
    
    GUI_Interaction.StartMessageAgain(QuestIndexOrMessageContent, true)
end


function GUI_Interaction.SpeechStartAgainOrStopUpdate()
    local CurrentWidgetID = "/InGame/Root/Normal/AlignBottomLeft/Message/MessagePortrait/SpeechStartAgainOrStop"
    
    if g_VoiceMessageIsRunning ~= true then
        XGUIEng.DisableButton(CurrentWidgetID, 0)
    else
        XGUIEng.DisableButton(CurrentWidgetID, 1)
    end
end


--function GUI_Interaction.UpdateSpeechButtons()
--    
--end


function GUI_Interaction.GetPotentialSubQuestAndType(_QuestIndex)
    if _QuestIndex== nil or _QuestIndex == 0 then
        return
    end
    
    local Quest = Quests[_QuestIndex]
    local QuestType = Quest.Objectives[1].Type

    if QuestType == Objective.Quest then
        local SubQuestNumber = 1
        local SubQuest
        local NextSubQuest
        
        repeat
            SubQuest = Quests[Quest.Objectives[1].Data[SubQuestNumber]]
            SubQuestNumber = SubQuestNumber + 1
            NextSubQuest = Quests[Quest.Objectives[1].Data[SubQuestNumber]]
        until NextSubQuest == nil
        or SubQuest == nil
        or SubQuest.State == QuestState.Active
        
        Quest = SubQuest
        
        if Quest ~= nil then
            QuestType = Quest.Objectives[1].Type
        end
    end
    
    return Quest, QuestType
end


function GUI_Interaction.GetPotentialSubQuestIndex(_QuestIndex)
    local QuestIndex = _QuestIndex
    local Quest = Quests[_QuestIndex]
    local QuestType = Quest.Objectives[1].Type
    
    if QuestType == Objective.Quest then
        QuestIndex = Quest.Objectives[1].Data[1]
    end
    
    return QuestIndex
end
-- <-- starting messages


-- quest buttons -->
function GUI_Interaction.UpdateTimers()

    if g_Interaction.TimerQuests == nil then
        XGUIEng.ShowWidget(QuestLog.Widget.Button,0)
        return
    end

    if CameraAnimation.IsRunning() then
        for i = 1, 6 do
            XGUIEng.ShowWidget("/InGame/Root/Normal/AlignTopLeft/QuestTimers/" .. i, 0)
        end
        XGUIEng.ShowWidget(QuestLog.Widget.Button,0)
        return
    end

    local TimersPath = "/InGame/Root/Normal/AlignTopLeft/QuestTimers/"
    local TimersNumber = 0

    --show timers for current quests
    for i = 1, #g_Interaction.TimerQuests do
        --not supported to display more than 5 quests
        if i > 6 then
            GUI.AddNote("Debug: trying to display more than 5 quests.")
            return
        end
        
        local QuestIndex = g_Interaction.TimerQuests[i]
        local ParentQuest = Quests[QuestIndex]
        local Quest, QuestType = GUI_Interaction.GetPotentialSubQuestAndType(QuestIndex)

        if QuestIndex ~= nil then
            DoesTimerDisappear = GUI_Interaction.CheckIfTimerShouldDisappear(QuestIndex)
            
            if DoesTimerDisappear == true then
                return
            end
        else
            return
        end

        local TimerPath = TimersPath .. i
        local ReceivePlayer = ParentQuest.ReceivingPlayer

        if ReceivePlayer == GUI.GetPlayerID()
        and QuestType ~= Objective.Dummy and QuestType ~= Objective.DummyFail then
            XGUIEng.ShowWidget(TimerPath, 1)
            TimersNumber = i
        else
            XGUIEng.ShowWidget(TimerPath, 0)
        end

        --fill timer info
        local DebugQuestNameWidget = TimerPath .. "/DebugQuestName"
        local PlayerIconContainer = TimerPath .. "/PlayerIcon"
        local OtherIconContainer = TimerPath .. "/OtherIcon"
        local QuestTypeIconWidget = TimerPath .. "/TimerButton"
        local TimeWidget = TimerPath .. "/Time"
        local TimerButton = TimerPath .. "/TimerButton"
        local VictoryBG = TimerPath .. "/VictoryBG"
        local DefeatBG = TimerPath .. "/DefeatBG"
        local StandardBG = TimerPath .. "/BG"

        --the StartTime must always come from the parent quest, not from a subquest (because the subquest StartTime is nil if it's not yet triggered)
        local StartTime = ParentQuest.StartTime

        local MaxDuration = Quest.Duration

        --highlight timer of current message; necessary when that message wasn't opened by the user
        --(and to prevent a highlight bug, which would keep the button highlighted)
        if QuestLog.IsQuestLogShown() then
            XGUIEng.HighLightButton(TimerButton, 0)
        elseif g_Interaction.CurrentMessageQuestIndex == QuestIndex
        and XGUIEng.IsButtonHighLighted(TimerButton) == 0 then
            XGUIEng.HighLightButton(TimerButton, 1)
        elseif g_Interaction.CurrentMessageQuestIndex ~= QuestIndex
        and XGUIEng.IsButtonHighLighted(TimerButton) == 1 then
            XGUIEng.HighLightButton(TimerButton, 0)
        end

        local CartUnderwayTime

        if QuestType == Objective.Deliver then
            CartUnderwayTime = Quest.Objectives[1].Data[4]
        end

        if CartUnderwayTime == nil then
            CartUnderwayTime = 0
        end

        local Time = ConvertSecondsToString(MaxDuration - math.floor(Logic.GetTime() - StartTime) + CartUnderwayTime)

        if QuestType == Objective.Deliver then
            local MerchantCartID = Quest.Objectives[1].Data[3]

            if MerchantCartID ~= nil then
                Time = XGUIEng.GetStringTableText("UI_Texts/CartsSent")
            end
        end

        --show timer if there is a time limit
        if MaxDuration == 0 then
            XGUIEng.ShowWidget(TimeWidget, 0)
        else
            XGUIEng.ShowWidget(TimeWidget, 1)
        end

        XGUIEng.SetText(TimeWidget, "{center}" .. Time)

        --debug mode info
        local DebugQuestName = Quest.Identifier
        
        if Debug_EnableDebugOutput == true then
            XGUIEng.ShowWidget(DebugQuestNameWidget, 1)
            XGUIEng.SetText(DebugQuestNameWidget, "{center}" .. DebugQuestName)
        else
            XGUIEng.ShowWidget(DebugQuestNameWidget, 0)
        end

        --show victory BG
        local IsRewardVictory = false
        local IsReprisalDefeat = false

        if Quest.Rewards[0] > 0 then
            for i = 1, Quest.Rewards[0] do
                if Quest.Rewards[i].Type == Reward.Victory
                or Quest.Rewards[i].Type == Reward.CampaignMapFinished
                or Quest.Rewards[i].Type == Reward.FakeVictory then
                    IsRewardVictory = true
                end
            end
        end
        
        if Quest.Reprisals[0] > 0 then
            for i = 1, Quest.Reprisals[0] do
                if Quest.Reprisals[i].Type == Reprisal.Defeat
                or Quest.Reprisals[i].Type == Reprisal.FakeDefeat then
                    IsReprisalDefeat = true
                end
            end
        end
        
        if IsRewardVictory == true then
            XGUIEng.ShowWidget(VictoryBG, 1)
            XGUIEng.ShowWidget(StandardBG, 0)
            XGUIEng.ShowWidget(DefeatBG, 0)
        else
            XGUIEng.ShowWidget(VictoryBG, 0)
            XGUIEng.ShowWidget(StandardBG, 1)
            XGUIEng.ShowWidget(DefeatBG, 0)
            
            if IsReprisalDefeat then
                XGUIEng.ShowWidget(DefeatBG, 1)
                XGUIEng.ShowWidget(StandardBG, 0)
            end
        end

        GUI_Interaction.SetQuestTypeIcon(QuestTypeIconWidget, QuestIndex)

        --don't use subquests here
        local SendingPlayer = ParentQuest.SendingPlayer
 
        XGUIEng.ShowWidget(PlayerIconContainer,0)
        XGUIEng.ShowWidget(OtherIconContainer,0)
        
        if SendingPlayer == GUI.GetPlayerID() then
            XGUIEng.ShowWidget(PlayerIconContainer,1)
            GUI_Interaction.SetPlayerIcon(PlayerIconContainer, SendingPlayer)
        else
            XGUIEng.ShowWidget(OtherIconContainer,1)
            GUI_Interaction.SetPlayerIcon(OtherIconContainer, SendingPlayer)
        end
    end

    if  Quests[0] > 0 and (TimersNumber > 0 or QuestLog.HasOneQuestBeenCompleted())  then
        XGUIEng.ShowWidget(QuestLog.Widget.Button,1)
    else
        XGUIEng.ShowWidget(QuestLog.Widget.Button,0)
    end

    --hide unnecessary timers
    for i = TimersNumber + 1, 6 do
        XGUIEng.ShowWidget(TimersPath .. i, 0)
    end


end


function GUI_Interaction.SetQuestTypeIcon(_QuestTypeIconWidget, _QuestIndex)
    local Quest, QuestType = GUI_Interaction.GetPotentialSubQuestAndType(_QuestIndex)

    --Traveling Salesman
    if Quest.Identifier == "TravelingSalesman" then
        SetIcon(_QuestTypeIconWidget, {10, 9})
        return
    end

    local IconCoordinates = g_TexturePositions.QuestTypes[QuestType]

    if QuestType == Objective.KnightTitle then
        local KnightTitleToGet = Quest.Objectives[1].Data
        IconCoordinates = g_TexturePositions.KnightTitles[KnightTitleToGet]
        
    elseif QuestType == Objective.Create then
        local EntityType = Quest.Objectives[1].Data[1]
        local IsMilitary = Logic.IsEntityTypeInCategory(EntityType, EntityCategories.Military)

        if IsMilitary == 1 then
            IconCoordinates = g_TexturePositions.QuestTypes["CreateMilitary"]
        else
            IconCoordinates = g_TexturePositions.QuestTypes["CreateOther"]
        end

    elseif QuestType == Objective.SatisfyNeed then
        local Need = Quest.Objectives[1].Data[1]
        local NeedName = GetNameOfKeyInTable(Needs, Need)
        IconCoordinates = g_TexturePositions.QuestTypes["SatisfyNeed" .. NeedName]

    elseif QuestType == Objective.Produce or QuestType == Objective.GoodAmount then
        local GoodType = Quest.Objectives[1].Data[1]
        IconCoordinates = g_TexturePositions.Goods[GoodType]
    end

    SetIcon(_QuestTypeIconWidget, GetIconOverride(Quest) or IconCoordinates)
end


function GUI_Interaction.SetPlayerIcon(_PlayerIconContainer, _PlayerID)

    local LogoWidget = _PlayerIconContainer .. "/Logo"
    local PatternWidget = _PlayerIconContainer .. "/Pattern"

    if _PlayerID == GUI.GetPlayerID() then

        local CoASet = Profile.IsKeyValid("Profile", "PatternTexture")

        if CoASet then
            XGUIEng.SetMaterialTexture(LogoWidget, 0, "Frames2.png")
            XGUIEng.SetMaterialTexture(PatternWidget, 0, "Frames2.png")
            g_CoatOfArm.UpdateGender(true, nil, LogoWidget)
            g_CoatOfArm.UpdatePattern(true, nil, nil, PatternWidget)
        else
            XGUIEng.SetMaterialColor(LogoWidget,0,255,255,255,0)
            XGUIEng.SetMaterialColor(PatternWidget,0,255,255,255,0)
        end
    else
        local PlayerCategory = GetPlayerCategoryType(_PlayerID)
        local PlayerIcon = g_TexturePositions.PlayerCategories[PlayerCategory]
        
        if Mission_Callback_OverridePlayerIconForQuest then
            local NewPlayerIcon = Mission_Callback_OverridePlayerIconForQuest(_PlayerID)
            if NewPlayerIcon then
                PlayerIcon = NewPlayerIcon
            end
        end
        
        if PlayerIcon then
            SetIcon(LogoWidget, PlayerIcon)
        else
            SetIcon(LogoWidget, {7, 7})--default empty square
        end
        
        SetIcon(PatternWidget, {14, 1})
        local R, G, B = GUI.GetPlayerColor(_PlayerID)
        
        if PlayerCategory == PlayerCategories.Harbour then
            R, G, B = 255, 255, 255
        end
        
        XGUIEng.SetMaterialColor(PatternWidget, 0, R, G, B, 255)
    end
end


function GUI_Interaction.CheckIfTimerShouldAppear(_QuestIndex)
    --if it's a quest started message, save QuestIndex to timers table; only if it doesn't already exist
    local Quest = Quests[_QuestIndex]

    if Quest.State == QuestState.Active then
        if g_Interaction.TimerQuests == nil then
            g_Interaction.TimerQuests = {}
        end

        local IsQuestIndexAlreadyInTable = false

        for k,v in ipairs(g_Interaction.TimerQuests) do
            if v == _QuestIndex then
                IsQuestIndexAlreadyInTable = true
            end
        end

        if IsQuestIndexAlreadyInTable == false then
            --table.insert(g_Interaction.TimerQuests, 1, _QuestIndex)
            table.insert(g_Interaction.TimerQuests, _QuestIndex)
        end
    end
end


function GUI_Interaction.CheckIfTimerShouldDisappear(_QuestIndex)
    --if the quest is over, remove QuestIndex from timers table so the timer disappears
    -- there's no check if there's another message from the same questindex later in the MessagesQueue!

    --don't use subquests here
    local Quest = Quests[_QuestIndex]

    if (Quest.State == QuestState.Over or Quest.State == QuestState.NotTriggered ) and g_Interaction.TimerQuests ~= nil then
        for k,v in ipairs(g_Interaction.TimerQuests) do
            if v == _QuestIndex then
                table.remove(g_Interaction.TimerQuests, k)
                return true
            end
        end
    end
end


function GUI_Interaction.TimerButtonClicked()
    --Sound.FXPlay2DSound("ui\\menu_click")

    local CurrentWidgetID = XGUIEng.GetCurrentWidgetID()
    local MotherContainerName = XGUIEng.GetWidgetNameByID(XGUIEng.GetWidgetsMotherID(CurrentWidgetID))
    local TimerNumber = tonumber(MotherContainerName)
    local QuestIndex = g_Interaction.TimerQuests[TimerNumber]

    if QuestIndex == nil then
        return
    end
   
    ----advance the counter when it's still sitting on a message that started but has multiple texts
    --if g_VoiceMessagesQueue[g_VoiceMessageCounter] ~= nil
    --and g_VoiceMessagesQueue[g_VoiceMessageCounter].InitialNumberOfMessages > #(g_VoiceMessagesQueue[g_VoiceMessageCounter].Messages) then
    --    g_VoiceMessageCounter = g_VoiceMessageCounter + 1
    --end

	local x,y = XGUIEng.GetWidgetLocalPosition( "/InGame/Root/Normal/AlignBottomLeft/Message/QuestObjectives" )
	XGUIEng.SetWidgetLocalPosition( "/InGame/Root/Normal/AlignBottomLeft/Message/QuestObjectives", 0, y )
		
		
    if g_Interaction.CurrentMessageQuestIndex == QuestIndex and not QuestLog.IsQuestLogShown() then
        g_Interaction.CurrentMessageQuestIndex = nil
        g_VoiceMessageIsRunning = false
        g_VoiceMessageEndTime = nil
        XGUIEng.ShowWidget("/InGame/Root/Normal/AlignBottomLeft/Message/MessagePortrait", 0)
        XGUIEng.ShowWidget(QuestLog.Widget.Main, 0)
        XGUIEng.ShowWidget("/InGame/Root/Normal/AlignBottomLeft/SubTitles", 0)
        XGUIEng.ShowAllSubWidgets("/InGame/Root/Normal/AlignBottomLeft/Message/QuestObjectives", 0)
        XGUIEng.HighLightButton(CurrentWidgetID, 0)
        
        Sound.FXPlay2DSound("ui\\menu_close")
    else
        Sound.FXPlay2DSound("ui\\menu_open")
        
        XGUIEng.UnHighLightGroup("/InGame", "QuestButtons")
        XGUIEng.HighLightButton(CurrentWidgetID, 1)

        XGUIEng.ShowWidget("/InGame/Root/Normal/AlignBottomLeft/Message/QuestObjectives", 0)
        XGUIEng.ShowWidget(QuestLog.Widget.Main, 0)
        
        GUI_Interaction.StartMessageAgain(QuestIndex, false)
        
    end
    
    SaveButtonPressed(CurrentWidgetID)
end


function GUI_Interaction.StartMessageAgain(_QuestIndexOrMessageContent, _PlayVoice)
    
    local PlayDirectly = true
    local QuestIndex = 0
    local SendingPlayer = g_Interaction.CurrentMessagePlayerID
    local MessageBaseKey = _QuestIndexOrMessageContent
    
    if type(_QuestIndexOrMessageContent) == "number" then
        
        QuestIndex = _QuestIndexOrMessageContent
        
        --Concerning the voice messages, don't use the subquests of a Objective.Quest quest.
        local Quest = Quests[QuestIndex]
        
        if Quest.State == QuestState.Active then
            SendingPlayer = Quest.SendingPlayer
            MessageBaseKey = Quest.Visible and Quest.MsgKeyOverride or Quest.Identifier
            if Quest.Visible and Quest.MsgKeyOverride and Quest.Identifier and Quest.Identifier ~= "" then
                -- Special case, check if there is a map specific key instead of the default key
                local TestMsg = Wrapped_GetStringTableText( QuestIndex, string.format( "Map_%s_speech/%s",
                    Framework.GetCurrentMapName(), Quest.Identifier ) )
                if TestMsg and TestMsg ~= "" then
                    MessageBaseKey = Quest.Identifier
                end
            end
            
            --if the same quest message is existing in the queue delete that and play it now directly
            for i = 1, #g_VoiceMessagesQueue do
                local QueueQuestIndex = g_VoiceMessagesQueue[i].QuestIndex
                
                if QueueQuestIndex == QuestIndex then
                    table.remove(g_VoiceMessagesQueue, i)
                    break
                end
            end
            
        end
    
    end
    
    g_Interaction.CurrentMessageQuestIndex = nil
    
    GUI_Interaction.GenerateVoiceMessage(QuestIndex, SendingPlayer, MessageBaseKey, PlayDirectly, Random, _PlayVoice)
    
end


function GUI_Interaction.TimerButtonMouseOver()
    local TooltipTextKey

    if XGUIEng.IsButtonHighLighted(XGUIEng.GetCurrentWidgetID()) == 0 then
        TooltipTextKey = "TimerButtonDisplay"
    else
        TooltipTextKey = "TimerButtonMinimize"
    end

    GUI_Tooltip.TooltipNormal(TooltipTextKey)
end
-- <-- quest buttons


-- message frame buttons -->
--which buttons are shown for which Objective Type:
--Objective.Deliver             JumpToEntity    DeliverGoods
--Objective.Protect             JumpToEntity
--Objective.DestroyPlayers      JumpToEntity
--Objective.DestroyEntities     JumpToEntity
--Objective.Capture             JumpToEntity
--Objective.Discover
--Objective.Create
--Objective.Diplomacy
--Objective.KnightTitle
--Objective.Object
--Objective.Claim
--Objective.Steal
--Objective.SatisfyNeed
--Objective.SettlersNumber
--Objective.Distance            JumpToEntity
--Objective.Spouses
--Objective.Custom
--Objective.Produce


--currently unused
--function GUI_Interaction.JumpToSenderClicked()
--
--    Sound.FXPlay2DSound( "ui\\menu_click")
--    local JumpToPlayerID = g_Interaction.CurrentMessagePlayerID
--
--    JumpToPlayer(JumpToPlayerID)
--end


function GUI_Interaction.UpdateButtons()
    local SendGoodsButton = XGUIEng.GetWidgetID("/InGame/Root/Normal/AlignBottomLeft/Message/MessagePortrait/Buttons/SendGoods")
    local JumpToEntityButton = XGUIEng.GetWidgetID("/InGame/Root/Normal/AlignBottomLeft/Message/MessagePortrait/Buttons/JumpToEntity")

    if g_Interaction.CurrentMessageQuestIndex == nil
    or g_Interaction.CurrentMessageQuestIndex == 0 then
        XGUIEng.ShowWidget(SendGoodsButton, 0)
        XGUIEng.ShowWidget(JumpToEntityButton, 0)
        return
    end

    local Quest, QuestType = GUI_Interaction.GetPotentialSubQuestAndType(g_Interaction.CurrentMessageQuestIndex)

    --Traveling Salesman
    if Quest.Identifier == "TravelingSalesman" then
        XGUIEng.ShowWidget(SendGoodsButton, 0)
        XGUIEng.ShowWidget(JumpToEntityButton, 0)
        return
    end

    --display SendGoods button for quest type Deliver; JumpToEntity if Cart is underway
    if QuestType == Objective.Deliver
    and Quest.State == QuestState.Active then
        local Cart = Quest.Objectives[1].Data[3]

        if Cart == nil then
            XGUIEng.ShowWidget(JumpToEntityButton, 1)
            XGUIEng.ShowWidget(SendGoodsButton, 1)
        elseif Cart == 1 then -- this means that the goods are being collected
            XGUIEng.ShowWidget(JumpToEntityButton, 1)
            XGUIEng.DisableButton(JumpToEntityButton, 1)
            XGUIEng.ShowWidget(SendGoodsButton, 0)
        else
            XGUIEng.ShowWidget(JumpToEntityButton, 1)
            XGUIEng.DisableButton(JumpToEntityButton, 0)
            XGUIEng.ShowWidget(SendGoodsButton, 0)
        end

    --display JumpToEntity for quest types Protect, DestroyPlayers, DestroyEntities, Capture, Distance
    elseif (QuestType == Objective.Protect
    or QuestType == Objective.DestroyPlayers
    or QuestType == Objective.DestroyAllPlayerUnits
    or QuestType == Objective.DestroyEntities
    or QuestType == Objective.Capture
    or QuestType == Objective.Object
    or QuestType == Objective.Distance
    or QuestType == Objective.Steal    
    or QuestType == Objective.BuildRoad
    )
    and Quest.State == QuestState.Active then
        XGUIEng.ShowWidget(JumpToEntityButton, 1)
        XGUIEng.ShowWidget(SendGoodsButton, 0)
        
        -- Don't enable the button if there are no entities to jump to
        local Disable = false
        local EntityOrTerritoryList, IsEntity = GUI_Interaction.GetEntitiesOrTerritoryListForQuest( Quest, QuestType )
        if IsEntity then
            Disable = true
            for _, ID in ipairs( EntityOrTerritoryList ) do
                if Logic.IsEntityAlive( ID ) then
                    Disable = false
                    break
                end
            end
        end
        XGUIEng.DisableButton(JumpToEntityButton, Disable and 1 or 0)

        
    --display JumpToEntity for quest types if they have territories: Discover, Create, Claim
    elseif (
    ( QuestType == Objective.Create
    and Quest.Objectives[1].Data[3] ~= nil
    and Quest.Objectives[1].Data[3] ~= 0 )
    
    or ( QuestType == Objective.Discover
    and Quest.Objectives[1].Data[1] == 1 )
    
    or ( QuestType == Objective.Claim
    and Quest.Objectives[1].Data[1] == 1 )
    )
    and Quest.State == QuestState.Active then
        XGUIEng.ShowWidget(JumpToEntityButton, 1)
        XGUIEng.DisableButton(JumpToEntityButton, 0)
        XGUIEng.ShowWidget(SendGoodsButton, 0)

    --display neither for quest types Discover, Create, Diplomacy, KnightTitle, 
    -- Claim, Steal, SatisfyNeed, SettlersNumber, Spouses, Custom, Produce
    else
        XGUIEng.ShowWidget(SendGoodsButton, 0)
        XGUIEng.ShowWidget(JumpToEntityButton, 0)
    end
end

function GUI_Interaction.GetEntitiesOrTerritoryListForQuest( _Quest, _QuestType )

    local EntityOrTerritoryList = {}
    local IsEntity = true

    if _QuestType == Objective.Create then
        local TerritoryID = _Quest.Objectives[1].Data[3]
        table.insert(EntityOrTerritoryList, TerritoryID)
        IsEntity = false
        
    elseif _QuestType == Objective.Steal then
        local Entitiy = _Quest.Objectives[1].Data[2][1]
        table.insert(EntityOrTerritoryList, Entitiy)

    elseif _QuestType == Objective.Discover then
        for i = 1, _Quest.Objectives[1].Data[2][0] do
            local TerritoryID = _Quest.Objectives[1].Data[2][i]
            table.insert(EntityOrTerritoryList, TerritoryID)
        end
        
        IsEntity = false

    elseif _QuestType == Objective.Claim then
        local TerritoryID = _Quest.Objectives[1].Data[2]
        table.insert(EntityOrTerritoryList, TerritoryID)
        IsEntity = false

    elseif _QuestType == Objective.Deliver then
        local Entity = _Quest.Objectives[1].Data[3]
        if Entity == nil then -- no cart sent yet ==> display storehouse/bandit camp

            local StoreHouseID = Logic.GetStoreHouse(_Quest.Objectives[1].Data[6] and _Quest.Objectives[1].Data[6] or _Quest.SendingPlayer)            
            table.insert(EntityOrTerritoryList, StoreHouseID)    
        else
            table.insert(EntityOrTerritoryList, Entity)
        end

    elseif _QuestType == Objective.Protect or _QuestType == Objective.Object then
        
        for i = 1, _Quest.Objectives[1].Data[0] do
            if Logic.IsEntityAlive(_Quest.Objectives[1].Data[i]) then
                local Entity = GetEntityId(_Quest.Objectives[1].Data[i])
                table.insert(EntityOrTerritoryList, Entity)
            end
        end

    elseif _QuestType == Objective.DestroyPlayers then
        local PlayerID = _Quest.Objectives[1].Data
        local Entity = Logic.GetHeadquarters(PlayerID)

        if Entity == nil or Entity == 0 then
            Entity = Logic.GetStoreHouse(PlayerID)
        end

        if Entity == nil or Entity == 0 then
            Entity = Logic.GetKnightID(PlayerID)
        end

        table.insert(EntityOrTerritoryList, Entity)

    elseif _QuestType == Objective.DestroyAllPlayerUnits then
        local PlayerID = _Quest.Objectives[1].Data
        local Entity = Logic.GetHeadquarters(PlayerID)

        if Entity == nil or Entity == 0 then
            Entity = Logic.GetStoreHouse(PlayerID)
        end

        if Entity == nil or Entity == 0 then
            Entity = Logic.GetKnightID(PlayerID)
        end
        
        if Entity == nil or Entity == 0 then
            local _, ID1 = Logic.GetAllPlayerEntities( PlayerID, 1 )
            Entity = ID1
        end

        table.insert(EntityOrTerritoryList, Entity)

    elseif _QuestType == Objective.DestroyEntities
    or _QuestType == Objective.Capture then
        local TypeIndicator = _Quest.Objectives[1].Data[1]

        if TypeIndicator == 1 then
            for i = 1, _Quest.Objectives[1].Data[2][0] do
                if Logic.IsEntityAlive(_Quest.Objectives[1].Data[2][i]) then
                    local Entity = GetEntityId(_Quest.Objectives[1].Data[2][i])
                    if not Logic.EntityIsRespawnResource(Entity) then
                        table.insert(EntityOrTerritoryList, Entity)
                    else
                        for _, ID in ipairs{ Logic.GetSpawnedEntities(Entity) } do
                            table.insert(EntityOrTerritoryList, ID)
                        end
                    end
                end
            end
        elseif TypeIndicator == 2 then
            local EntityType = _Quest.Objectives[1].Data[2]
            local EntityNumber = _Quest.Objectives[1].Data[3]
            local PlayerID = _Quest.Objectives[1].Data[4]
            local AllEntities

            if PlayerID == 0 then
                --limit of 30!
                AllEntities = {Logic.GetEntities(EntityType, 30)}
                if #AllEntities >= 30 then
                    GUI.AddNote("Debug: More than 30 quest entities?")
                end

                for i = 1, AllEntities[1] do
                    table.insert(EntityOrTerritoryList, AllEntities[i+1])
                end
            else
                AllEntities = GetPlayerEntities(PlayerID, EntityType)

                for i = 1, EntityNumber do
                    table.insert(EntityOrTerritoryList, AllEntities[i])
                end
            end
        end
    
    elseif _QuestType == Objective.Distance  then
        local Entity = GetEntityId(_Quest.Objectives[1].Data[2])
        table.insert(EntityOrTerritoryList, Entity)
        
    elseif _QuestType == Objective.BuildRoad then
        table.insert(EntityOrTerritoryList, _Quest.Objectives[1].Data[1])
        table.insert(EntityOrTerritoryList, _Quest.Objectives[1].Data[2])
        
    elseif GUI_Interaction.JumpToEntityClickedEx1 ~= nil 
    and GUI_Interaction.JumpToEntityClickedEx1(_Quest, _QuestType, EntityOrTerritoryList) then
        
        do
        end
        
    end

    return EntityOrTerritoryList, IsEntity
end

function GUI_Interaction.JumpToEntityClicked(_ShowOnlyOnMinimap)

    if XGUIEng.IsWidgetShown("/InGame/Root/Normal/AlignBottomLeft/Message/MessagePortrait/Buttons/JumpToEntity") == 0 then
        return
    end
    
    if _ShowOnlyOnMinimap ~= true then
        Sound.FXPlay2DSound("ui\\menu_click")
    end

    local Quest, QuestType = GUI_Interaction.GetPotentialSubQuestAndType(g_Interaction.CurrentMessageQuestIndex)

    --generate list of entities / territories to jump to
    local EntityOrTerritoryList, IsEntity = GUI_Interaction.GetEntitiesOrTerritoryListForQuest( Quest, QuestType )

    --jump through EntityOrTerritoryList
    if g_Interaction.LastEntityJumpedTo == nil then
        g_Interaction.LastEntityJumpedTo = EntityOrTerritoryList[1]
    else
        local LastEntityDataIndex

        for i = 1, #EntityOrTerritoryList do
            if EntityOrTerritoryList[i] == g_Interaction.LastEntityJumpedTo
            and EntityOrTerritoryList[i+1] ~= nil then
                LastEntityDataIndex = i+1
                break
            else
                LastEntityDataIndex = 1
            end
        end

        g_Interaction.LastEntityJumpedTo = EntityOrTerritoryList[LastEntityDataIndex]
    end

    local Position
    
    if IsEntity then
        Position = GetPosition(g_Interaction.LastEntityJumpedTo)
    else
        Position = g_Interaction.LastEntityJumpedTo
    end
    
    if Position and type(Position) ~= "table" or ( Position.X > 0 and Position.Y > 0 ) then
        JumpToPositionOrCreateMinimapMarker(Position, _ShowOnlyOnMinimap)
    end
end


function GUI_Interaction.JumpToEntityMouseOver()
    local Quest, QuestType = GUI_Interaction.GetPotentialSubQuestAndType(g_Interaction.CurrentMessageQuestIndex)
    local TooltipTextKey

    if Quest.Objectives[1].Type == Objective.Deliver and Quest.Objectives[1].Data[3] ~= nil then -- Data[3] is the cart, when sent
        TooltipTextKey = "JumpToEntitySentCart"
    else
        TooltipTextKey = "JumpToEntityQuestTargets"
    end

    GUI_Tooltip.TooltipNormal(TooltipTextKey)
end


function GUI_Interaction.SendGoodsClicked()
    
    local Quest, QuestType = GUI_Interaction.GetPotentialSubQuestAndType(g_Interaction.CurrentMessageQuestIndex)
    
    if not Quest then
        -- TODO: This shouldn't happen.
        -- Maybe the GUI needs to be updated
        --Message(CanNotBuyString)
        return
    end
    
    local QuestIndex = GUI_Interaction.GetPotentialSubQuestIndex(g_Interaction.CurrentMessageQuestIndex)
    local GoodType = Quest.Objectives[1].Data[1]
    local GoodAmount = Quest.Objectives[1].Data[2]
    local Costs = {GoodType, GoodAmount}
    local CanBuyBoolean, CanNotBuyString = AreCostsAffordable(Costs, true)
    
    local PlayerID = GUI.GetPlayerID()
    local TargetPlayerID = Quest.Objectives[1].Data[6] and Quest.Objectives[1].Data[6] or Quest.SendingPlayer
    
    --check if Cart can reach target
    local PlayerSectorType = PlayerSectorTypes.Thief
    
    local IsReachable = CanEntityReachTarget(TargetPlayerID, Logic.GetStoreHouse(GUI.GetPlayerID()), Logic.GetStoreHouse(TargetPlayerID),
        nil, PlayerSectorType)
    
    if IsReachable == false then
        local MessageText = XGUIEng.GetStringTableText("Feedback_TextLines/TextLine_GenericUnreachable")
        Message(MessageText)
        return
    end

    if CanBuyBoolean == true then
        Sound.FXPlay2DSound( "ui\\menu_click")
        GUI.QuestTemplate_SendGoods(QuestIndex)
        GUI_FeedbackSpeech.Add("SpeechOnly_CartsSent", g_FeedbackSpeech.Categories.CartsUnderway, nil, nil)
    else
        --No "Not enough Wool" etc. messages in XML file. Will say "Not enough Resources/Goods!"
        Message(CanNotBuyString)
    end
end


function GUI_Interaction.SendGoodsMouseOver()
    local Quest, QuestType = GUI_Interaction.GetPotentialSubQuestAndType(g_Interaction.CurrentMessageQuestIndex)
    local GoodType = Quest.Objectives[1].Data[1]
    local GoodAmount = Quest.Objectives[1].Data[2]
    local Costs = {GoodType, GoodAmount}
    GUI_Tooltip.TooltipBuy(Costs, nil, nil, nil, true)
end
-- <-- message frame buttons





-- interactive object functions -->
function ScriptCallback_ObjectInteraction(_PlayerID, _TargetEntityID)
    local PlayerID = GUI.GetPlayerID()

    if PlayerID ~= _PlayerID then
        return
    end

    -- Save interactive object ID
    if g_Interaction.ActiveObjects == nil then
        g_Interaction.ActiveObjects = {}
    end

    if g_Interaction.ActiveObjectsOnScreen == nil then
        g_Interaction.ActiveObjectsOnScreen = {}
    end

    local IsInTable = false

    for i = 1, #g_Interaction.ActiveObjects do
        if g_Interaction.ActiveObjects[i] == _TargetEntityID then
            IsInTable = true
        end
    end

    if IsInTable == false then
        table.insert(g_Interaction.ActiveObjects, _TargetEntityID)
    end
end


function ScriptCallback_CloseObjectInteraction(_PlayerID, _TargetEntityID)
    local PlayerID = GUI.GetPlayerID()

    if PlayerID ~= _PlayerID
    or g_Interaction.ActiveObjects == nil then
        return
    end

    for i = 1, #g_Interaction.ActiveObjects do
        if g_Interaction.ActiveObjects[i] == _TargetEntityID then
            table.remove(g_Interaction.ActiveObjects, i)
        end
    end

    for i = 1, #g_Interaction.ActiveObjectsOnScreen do
        if g_Interaction.ActiveObjectsOnScreen[i] == _TargetEntityID then
            table.remove(g_Interaction.ActiveObjectsOnScreen, i)
        end
    end
end


function GUI_Interaction.InteractiveObjectUpdate()
    local PlayerID = GUI.GetPlayerID()

    if g_Interaction.ActiveObjects == nil then
        return
    end

    for i = 1, #g_Interaction.ActiveObjects do
        local ObjectID = g_Interaction.ActiveObjects[i]
        local X, Y = GUI.GetEntityInfoScreenPosition(ObjectID)
    	local ScreenSizeX, ScreenSizeY = GUI.GetScreenSize()

        if X ~= 0
        and Y ~= 0
        and X > -50 and Y > -50 and X < (ScreenSizeX + 50) and Y < (ScreenSizeY + 50) then
            local IsInTable = false

            for i = 1, #g_Interaction.ActiveObjectsOnScreen do
                if g_Interaction.ActiveObjectsOnScreen[i] == ObjectID then
                    IsInTable = true
                end
            end

            if IsInTable == false then
                table.insert(g_Interaction.ActiveObjectsOnScreen, ObjectID)
            end
        else
            for i = 1, #g_Interaction.ActiveObjectsOnScreen do
                if g_Interaction.ActiveObjectsOnScreen[i] == ObjectID then
                    table.remove(g_Interaction.ActiveObjectsOnScreen, i)
                end
            end
        end
    end

    for i = 1, #g_Interaction.ActiveObjectsOnScreen do
        local Widget = "/InGame/Root/Normal/InteractiveObjects/" .. i

        if XGUIEng.IsWidgetExisting(Widget) == 1 then
            --Update the position
            local ObjectID = g_Interaction.ActiveObjectsOnScreen[i]
            local EntityType = Logic.GetEntityType(ObjectID)
	        
            local X, Y = GUI.GetEntityInfoScreenPosition(ObjectID)
            local WidgetSize = {XGUIEng.GetWidgetScreenSize(Widget)}
	        XGUIEng.SetWidgetScreenPosition(Widget, X - (WidgetSize[1]/2), Y - (WidgetSize[2]/2))
	        
            local BaseCosts = {Logic.InteractiveObjectGetCosts(ObjectID)}
            local EffectiveCosts = {Logic.InteractiveObjectGetEffectiveCosts(ObjectID, PlayerID)}
            local IsAvailable = Logic.InteractiveObjectGetAvailability(ObjectID)
            
            local Disable = false
            
            if BaseCosts[1] ~= nil
            and EffectiveCosts[1] == nil
            and IsAvailable == true then
                Disable = true -- cart is underway
            end
            
            local HasSpace = Logic.InteractiveObjectHasPlayerEnoughSpaceForRewards(ObjectID, PlayerID)
            
            if HasSpace == false then
                Disable = true
            end

            if Disable == true then
                XGUIEng.DisableButton(Widget, 1)
            else
                XGUIEng.DisableButton(Widget, 0)
            end

            -- interaction icon
            if GUI_Interaction.InteractiveObjectUpdateEx1 ~= nil then
                GUI_Interaction.InteractiveObjectUpdateEx1(Widget, EntityType)
            end

	        XGUIEng.ShowWidget(Widget, 1)
        --[[
	    else
	        GUI.AddNote("Debug: There should not be more than 2 interactive objects visible onscreen at the same time.")
        --]]
	    end
	end

	for i = #g_Interaction.ActiveObjectsOnScreen + 1, 2 do
	    local Widget = "/InGame/Root/Normal/InteractiveObjects/" .. i
	    XGUIEng.ShowWidget(Widget, 0)
	end
end


function GUI_Interaction.InteractiveObjectClicked()
    local ButtonNumber = tonumber(XGUIEng.GetWidgetNameByID(XGUIEng.GetCurrentWidgetID()))
    local ObjectID = g_Interaction.ActiveObjectsOnScreen[ButtonNumber]
    
    if ObjectID == nil or not Logic.InteractiveObjectGetAvailability(ObjectID) then
        return
    end
    
    local PlayerID = GUI.GetPlayerID()

    local Costs = {Logic.InteractiveObjectGetEffectiveCosts(ObjectID, PlayerID)}

    if Costs ~= nil
    and Costs[1] ~= nil then
        local CheckSettlement
        -- Only check first good (no support for mixed deliveries)
        if Logic.GetGoodCategoryForGoodType(Costs[1]) ~= GoodCategories.GC_Resource then
            CheckSettlement = true
        end

        local CanBuyBoolean, CanNotBuyString = AreCostsAffordable(Costs,CheckSettlement)

        if CanBuyBoolean == true then
            -- Default button click?
            if  not GUI_Interaction.InteractionClickOverride 
                or 
                not GUI_Interaction.InteractionClickOverride(ObjectID)
            then
                Sound.FXPlay2DSound( "ui\\menu_click")
            end
            
            -- Default speech?
            if  not GUI_Interaction.InteractionSpeechFeedbackOverride 
                or 
                not GUI_Interaction.InteractionSpeechFeedbackOverride(ObjectID)
            then                
                GUI_FeedbackSpeech.Add("SpeechOnly_CartsSent", g_FeedbackSpeech.Categories.CartsUnderway, nil, nil)
            end
            
            if not Mission_Callback_OverrideObjectInteraction or not Mission_Callback_OverrideObjectInteraction( ObjectID, PlayerID, Costs ) then
                GUI.ExecuteObjectInteraction(ObjectID, PlayerID)
            end
            
        else
            Message(CanNotBuyString)
        end
    else
        GUI.ExecuteObjectInteraction(ObjectID, PlayerID)
    end
end

-- Check Ex1 for changes
function GUI_Interaction.InteractiveObjectMouseOver()
    local PlayerID = GUI.GetPlayerID()
    local ButtonNumber = tonumber(XGUIEng.GetWidgetNameByID(XGUIEng.GetCurrentWidgetID()))
    local ObjectID = g_Interaction.ActiveObjectsOnScreen[ButtonNumber]
    local EntityType = Logic.GetEntityType(ObjectID)

    local CurrentWidgetID = XGUIEng.GetCurrentWidgetID()
    local Costs = {Logic.InteractiveObjectGetEffectiveCosts(ObjectID, PlayerID)}
    local IsAvailable = Logic.InteractiveObjectGetAvailability(ObjectID)

    local TooltipTextKey
    local TooltipDisabledTextKey

    if IsAvailable == true then
        TooltipTextKey = "InteractiveObjectAvailable"
    else
        TooltipTextKey = "InteractiveObjectNotAvailable"
    end

    -- interaction tooltip - disabled
    if Logic.InteractiveObjectHasPlayerEnoughSpaceForRewards(ObjectID, PlayerID) == false then
        TooltipDisabledTextKey = "InteractiveObjectAvailableReward"
    end
    
    local CheckSettlement
    -- Only check first good (no support for mixed deliveries)
    if Costs and Costs[1] and Logic.GetGoodCategoryForGoodType(Costs[1]) ~= GoodCategories.GC_Resource then
        CheckSettlement = true
    end
    
    GUI_Tooltip.TooltipBuy(Costs, TooltipTextKey, TooltipDisabledTextKey, nil, CheckSettlement)
end
-- <-- interactive object functions



function GUI_Interaction.TutorialNext()

    Sound.FXPlay2DSound( "ui\\menu_click")

     if Tutorial ~= nil then
        local CurrentWidgetID =  XGUIEng.GetCurrentWidgetID()

        -- tell the tutorial, that this button has been pressed by the player
        SaveButtonPressed(CurrentWidgetID)

    end
end


-- textkey functions -->
function GetMessageTextForCustomQuest(_QuestIndex)

    local Quest = Quests[_QuestIndex]

    local CurrentMapName = Framework.GetCurrentMapName()
    local MessageText = Wrapped_GetStringTableText(_QuestIndex, "Map_" .. CurrentMapName .. "/" .. Quest.Identifier)
    
    if MessageText == "" and Quest.MsgKeyOverride then
        --get custom message text from non-speech map table
        MessageText = Wrapped_GetStringTableText(_QuestIndex, (Quest.MsgTableOverride or ("Map_" .. CurrentMapName)) .. "/" .. Quest.MsgKeyOverride)
    end
    
    --if no key in non-speech map table, check in speech map table
    --if MessageText == "" then
    --    MessageText = "Debug: no short custom text{cr}" .. XGUIEng.GetStringTableText("Map_" .. CurrentMapName .. "_speech/" .. MessageKey)
    --end
    
    return MessageText
end

function IsEntityTypeNoCastellan( _EntityType )
    return _EntityType ~= Entities.U_NPC_Castellan_NA
        and _EntityType ~= Entities.U_NPC_Castellan_ME
        and _EntityType ~= Entities.U_NPC_Castellan_SE
        and _EntityType ~= Entities.U_NPC_Castellan_NE
end

function IsEntityTypeACloister( _EntityType )
    return _EntityType == Entities.B_NPC_Cloister_ME
        or _EntityType == Entities.B_NPC_Cloister_SE
        or _EntityType == Entities.B_NPC_Cloister_NA
        or _EntityType == Entities.B_NPC_Cloister_NE
end

function GetKeyAndTableForSpokenText(_QuestIndex, _PlayerID, _MessageKey, _Random, _Pretext, _IgnoreStateOver)

    local Key = _MessageKey
    local Table = ""

    --for a quest
    local Quest
    if _QuestIndex ~= 0 then

        Quest = Quests[_QuestIndex]

        if Quest.State == QuestState.Over and not _IgnoreStateOver then

            if Quest.Result == QuestResult.Success then

                Key = _MessageKey .. "_Success"

            elseif Quest.Result == QuestResult.Failure then

                Key = _MessageKey .. "_Failure"

            end
        end

    end

    --get Message Text from Map Table or override
    local CurrentMapName = Framework.GetCurrentMapName()
    
    local MessageText, OverrideKeySuccess
    local OverrideKey, OverrideTable = GetTextOverride( Quest )
    Table = ( (not _Pretext) and (OverrideTable or (Quest and Quest.MsgTableOverride)) ) or "Map_" .. CurrentMapName .. "_speech"

    if not _Pretext and OverrideKey then
        MessageText = Wrapped_GetStringTableText(_QuestIndex, Table .."/" .. OverrideKey )
        if MessageText ~= "" then
            OverrideKeySuccess = OverrideKey
        end
    else
        MessageText = Wrapped_GetStringTableText(_QuestIndex, Table .."/" .. Key)
    end

    if _Pretext ~= true then
        --if no key in map, check for generic quest text
        if MessageText == "" then

            Table = "Generic_Quest_OtherFaction_speech"

            if _PlayerID == GUI.GetPlayerID() then
                Table = "Generic_Quest_OwnKnight_speech"
            end

            OverrideKey = GetTextOverride( Quest )
            if OverrideKey then
                MessageText = Wrapped_GetStringTableText(_QuestIndex, Table .."/" .. OverrideKey )
                if MessageText ~= "" then
                    OverrideKeySuccess = OverrideKey
                end
            else
                MessageText = Wrapped_GetStringTableText(_QuestIndex, Table .."/" .. Key)
            end

        end

        --if still not there check in player category table
        if MessageText == "" then

            local PlayerCategory

            local CastleID = Logic.GetHeadquarters(_PlayerID)

            if CastleID ~= 0 then

                local KnightID = Logic.GetKnightID(_PlayerID)

                if KnightID ~= 0 then

                    local KnightType = Logic.GetEntityType(KnightID)

                    if IsEntityTypeNoCastellan(KnightType) then

                        local KnightTypeName = Logic.GetEntityTypeName(KnightType)

                        PlayerCategory = string.gsub(KnightTypeName, "U_", "")

                    else
                        PlayerCategory = "City"
                    end

                else

                    PlayerCategory = "City"

                end

            else
                local StoreHouseID = Logic.GetStoreHouse(_PlayerID)


                if IsEntityTypeACloister( Logic.GetEntityType(StoreHouseID) ) then

                    PlayerCategory = "Cloister"
                    
                elseif Logic.IsEntityInCategory(StoreHouseID, EntityCategories.VillageStorehouse) == 1 then
                    PlayerCategory = "Village"
                    
                else
                    PlayerCategory = "Bandits"
                end
            end

            local IsGenericText = true
            if PlayerCategory ~= nil then

                Table = "Generic_" .. PlayerCategory .. "_speech"

                if _QuestIndex ~= 0 then

                    local Quest = Quests[_QuestIndex]
                    Table = "Generic_Quest_OtherFaction_speech"

                    if _PlayerID == GUI.GetPlayerID() then
                        Table = "Generic_Quest_OwnKnight_speech"
                    end

                    Key = "Quest"

                    if Quest.State == QuestState.Over then

                        if Quest.Result == QuestResult.Success then

                            Key = "Quest_Success"

                        elseif Quest.Result == QuestResult.Failure then

                            Key = "Quest_Failure"

                        end
                    end

                    _Random = true

                end

                if _Random == true then
                    local OriginalKey = Key
                    local Random = 1 + XGUIEng.GetRandom(2)
                    Key = Key .. "_rnd_0" .. Random
                    
                    local CheckIfKeyExists = Wrapped_GetStringTableText(_QuestIndex, Table.."/" .. Key)
                    
                    if CheckIfKeyExists == "" then
                        Random = 1 + XGUIEng.GetRandom(1)
                        Key = OriginalKey .. "_rnd_0" .. Random
                        CheckIfKeyExists = Wrapped_GetStringTableText(_QuestIndex, Table.."/" .. Key)
                        
                        if CheckIfKeyExists == "" then
                            Key = OriginalKey .. "_rnd_0" .. 1
                        end
                    end
                end
                
                OverrideKey = GetTextOverride( Quest )
                if OverrideKey then
                    MessageText = Wrapped_GetStringTableText(_QuestIndex, Table .."/" .. OverrideKey )
                    if MessageText ~= "" then
                        OverrideKeySuccess = OverrideKey
                        IsGenericText = false
                    end
                else
                    MessageText = Wrapped_GetStringTableText(_QuestIndex, Table .."/" .. Key)
                end
            end
            
            OverrideKey = GetTextOverride( Quest )
            if PlayerCategory and OverrideKey and MessageText == "" then
                local TableTest = "Generic_" .. PlayerCategory .. "_speech"
                MessageText = Wrapped_GetStringTableText(_QuestIndex, TableTest .."/" .. OverrideKey )
                if MessageText ~= "" then
                    OverrideKeySuccess = OverrideKey
                    Table = TableTest
                    IsGenericText = false
                end
            end

            -- If there is an invisible quest with a start msg, but no end msg, the "replay" button will replay a generic end msg instead of the start msg by default
            -- So it needs to be checked if this is the case.
            if _QuestIndex ~= 0 then
                local Quest = Quests[_QuestIndex]
                if type(_MessageKey) == "number" and Quest.State == QuestState.Over and not Quest.ShowEndMessage and not _IgnoreStateOver and IsGenericText then
                    -- Numerical messagekey - not of much use. Since there appears to be no override, try to use the identifier
                    -- The messagekey appears to be a number only if "replay" was clicked.
                    -- This needs to be checked for, otherwise the startmessage will be played twice for regular speech quests
                    _MessageKey = Quest.Identifier
                    local NewKey = GetKeyAndTableForSpokenText(_QuestIndex, _PlayerID, _MessageKey, _Random, _Pretext, true)
                    if NewKey then
                        MessageText = Wrapped_GetStringTableText(_QuestIndex, NewKey )
                        if MessageText ~= "" then
                            Table, Key = string.match( NewKey, "^([^/]+)/([^/]+)$" )
                            assert( Table )
                            assert( Key )
                        end
                    end
                end
            end
        end
    end
    
    if Framework.IsDevM() then  -- Some quests may have text that can only be spoken by the knight, and not by an NPC. Users might choose to use them for an NPC though
        assert( not OverrideKey or OverrideKeySuccess or string.find( _MessageKey, "_Pre%d+$" ), OverrideKey )
    end

    if Debug_EnableDebugOutput then
        GUI.AddNote(Table .."/" .. (OverrideKeySuccess or Key))
    end

    if MessageText ~= "" then
        return Table .."/".. (OverrideKeySuccess or Key)
    end

    return nil, _MessageKey
end
-- <-- textkey functions

function Wrapped_GetStringTableText(_QuestIndex, _MessageKey)

    local MessageText = XGUIEng.GetStringTableText(_MessageKey)

    -- check if the key is valud
    if (MessageText ~= "") then
        return MessageText
    end

    if (_QuestIndex == 0) then
        return ""
    end

    local Quest = Quests[_QuestIndex]
    if (Quest == nil) then
        return ""
    end
    
    local SpeechPos = string.find(_MessageKey, "speech")
    
    if (SpeechPos ~= nil) then
          
        -- this is a spoken text from the speech table    
        local MessageKeyPos = string.find(_MessageKey, "/")
        if (MessageKeyPos == nil) then
            return ""
        end
        
        -- get just 
        local MessageKey = string.sub(_MessageKey, MessageKeyPos+1)    
           
        if (Quest.Identifier == MessageKey) and (Quest.QuestStartMsg ~= nil) and not string.find( Quest.QuestStartMsg, g_OverrideTextKeyPattern ) then
            return Quest.QuestStartMsg
        end    
    
        if (Quest.Identifier .. "_Success" == MessageKey) and (Quest.QuestSuccessMsg ~= nil) and not string.find( Quest.QuestSuccessMsg, g_OverrideTextKeyPattern )then
            return Quest.QuestSuccessMsg
        end    
    
        if (Quest.Identifier .. "_Failure" == MessageKey) and (Quest.QuestFailureMsg ~= nil) and not string.find( Quest.QuestFailureMsg, g_OverrideTextKeyPattern )then
            return Quest.QuestFailureMsg
        end    

    else

        -- this is a non-spoken text
        if (Quest.QuestDescription ~= nil) then
            return string.match( Quests[_QuestIndex].QuestDescription, "^[^~]+ ~ (.+)$" ) or Quest.QuestDescription
        end    
        
    end

              
    return ""
    
end

function GetIconOverride( _Quest )
    if _Quest.IconOverride then
        if type( _Quest.IconOverride ) == "table" then
            assert( type( _Quest.IconOverride[1] ) == "number" )
            assert( type( _Quest.IconOverride[2] ) == "number" )
            
        elseif type( _Quest.IconOverride ) == "string" and string.find( _Quest.IconOverride, "^[^%.]+%.[^%.]+$" ) then
            local tabkey, subtabkey = string.match( _Quest.IconOverride, "^([^%.]+)%.([^%.]+)$" )
            local subtab = assert( g_TexturePositions[tabkey], _Quest.IconOverride )
            local index
            if tabkey == "QuestTypes" then
                tabkey = "Objective"        -- Fix for name inconsistency in texturepositions.lua
                if subtab[subtabkey] then   -- Fix for texturepositions.lua non-objective hack
                    index = subtabkey
                end
            end
            
            if not index then
                local globtab = assert( _G[tabkey], _Quest.IconOverride )
                index = assert( globtab[subtabkey], _Quest.IconOverride )
            end
            
            _Quest.IconOverride = assert( subtab[index], _Quest.IconOverride )
            
        else
            assert( false )
        end
        
        return _Quest.IconOverride
    end
end

function GetTextOverride( _Quest )
    if not _Quest then
        return
    end
    
    assert( type( _Quest ) == "table" )
    
    local Result
    if _Quest.State == QuestState.Over then
        if _Quest.Result == QuestResult.Success then
            Result = string.match( _Quest.QuestSuccessMsg or "", g_OverrideTextKeyPattern )

        elseif _Quest.Result == QuestResult.Failure then
            Result = string.match( _Quest.QuestFailureMsg or "", g_OverrideTextKeyPattern )

        end
    else
        Result = string.match( _Quest.QuestStartMsg or "", g_OverrideTextKeyPattern )
    
    end
    
    if Result then
        local OverrideTable, OverrideKey = string.match( Result, "^([^/]+)/([^/]+)$" )
        if OverrideTable and OverrideKey then
            return OverrideKey, OverrideTable
        end
    end
    
    return Result
end
