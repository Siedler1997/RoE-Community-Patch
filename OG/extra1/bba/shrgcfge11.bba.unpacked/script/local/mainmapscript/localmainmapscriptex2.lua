
function SetPreferredPlayerColor()
    local newColor = Profile.GetInteger("Profile", "PreferredPlayerColor", 1)

    GUI.SendScriptCommand("PlayerChangePlayerColor2("..newColor..")")
end

-----------------------------------------------------------------------------------------
-- Overwrites for LocalMainMapScript
-----------------------------------------------------------------------------------------

function InitOverwriteLocalMainMapScriptEx2()

    do 
        local OldGetKnightActor = GetKnightActor
        function GetKnightActor(_KnightEntityType)
            local Actor = nil
    
            if _KnightEntityType == Entities.U_KnightKhana then
                Actor = "H_Knight_Khana"
                return Actor
            elseif _KnightEntityType == Entities.U_KnightPraphat then
                Actor = "H_Knight_Praphat"
                return Actor
            elseif _KnightEntityType == Entities.U_NPC_Castellan_ME then
                Actor = "H_NPC_Castellan_ME"
                return Actor
            elseif _KnightEntityType == Entities.U_NPC_Castellan_NE then
                Actor = "H_NPC_Castellan_NE"
                return Actor
            elseif _KnightEntityType == Entities.U_NPC_Castellan_NA then
                Actor = "H_NPC_Castellan_NA"
                return Actor
            elseif _KnightEntityType == Entities.U_NPC_Castellan_SE then
                Actor = "H_NPC_Castellan_SE"
                return Actor
            elseif _KnightEntityType == Entities.U_NPC_Castellan_AS then
                Actor = "H_NPC_Castellan_AS"
                return Actor
            else
                Actor = OldGetKnightActor(_KnightEntityType)
            end
        
            return Actor
        end
    end  

    do
        local OldLocalSetKnightPicture = LocalSetKnightPicture
        function LocalSetKnightPicture()
            OldLocalSetKnightPicture()

            --Hack to attach the knights icon to the knight statue too
            local KnightID = Logic.GetKnightID(GUI.GetPlayerID())
            if KnightID == nil or KnightID == 0 then
                return
            end
            local KnightEntityType = Logic.GetEntityType(KnightID)
            local KnightStatueWidget = "/InGame/Root/Normal/AlignBottomRight/BuildMenu/SubMenus/SpecialEdition2/ButtonsAddon/B_Beautification_Knight_Generic"
            SetIcon(KnightStatueWidget, g_TexturePositions.Entities[KnightEntityType])
        end
    end  

end