-----------------------------------------------------------------
-- Overwrites
-----------------------------------------------------------------

do 
    local OldFaceFXCameraSettings = FaceFXCameraSettings
    
    function FaceFXCameraSettings()
        OldFaceFXCameraSettings()
     
     	g_FaceFXCamera.H_Knight_Saraya = {}
        g_FaceFXCamera.H_Knight_Saraya.FOV = 12.5
        g_FaceFXCamera.H_Knight_Saraya.PosX = -155
        g_FaceFXCamera.H_Knight_Saraya.PosY = -190
        g_FaceFXCamera.H_Knight_Saraya.PosZ = 0
        g_FaceFXCamera.H_Knight_Saraya.LookAtX = -68
        g_FaceFXCamera.H_Knight_Saraya.LookAtY = -90
        g_FaceFXCamera.H_Knight_Saraya.LookAtZ = -10
        
        g_FaceFXCamera.H_Knight_Khana = {}
        g_FaceFXCamera.H_Knight_Khana.FOV = 13.1
        g_FaceFXCamera.H_Knight_Khana.PosX = -155
        g_FaceFXCamera.H_Knight_Khana.PosY = -190
        g_FaceFXCamera.H_Knight_Khana.PosZ = 0
        g_FaceFXCamera.H_Knight_Khana.LookAtX = -68
        g_FaceFXCamera.H_Knight_Khana.LookAtY = -90
        g_FaceFXCamera.H_Knight_Khana.LookAtZ = -10

        g_FaceFXCamera.H_Knight_Praphat = {}
        g_FaceFXCamera.H_Knight_Praphat.FOV = 16.5
        g_FaceFXCamera.H_Knight_Praphat.PosX = -155
        g_FaceFXCamera.H_Knight_Praphat.PosY = -190
        g_FaceFXCamera.H_Knight_Praphat.PosZ = 0
        g_FaceFXCamera.H_Knight_Praphat.LookAtX = -68
        g_FaceFXCamera.H_Knight_Praphat.LookAtY = -90
        g_FaceFXCamera.H_Knight_Praphat.LookAtZ = -18
 
        g_FaceFXCamera.H_NPC_Castellan_AS = {}
        g_FaceFXCamera.H_NPC_Castellan_AS.FOV = 14.5
        g_FaceFXCamera.H_NPC_Castellan_AS.PosX = -155
        g_FaceFXCamera.H_NPC_Castellan_AS.PosY = -190
        g_FaceFXCamera.H_NPC_Castellan_AS.PosZ = 0
        g_FaceFXCamera.H_NPC_Castellan_AS.LookAtX = -68
        g_FaceFXCamera.H_NPC_Castellan_AS.LookAtY = -90
        g_FaceFXCamera.H_NPC_Castellan_AS.LookAtZ = -10
        
        -- beard corrupt
        g_FaceFXCamera.H_NPC_Mercenary_AS = {}
        g_FaceFXCamera.H_NPC_Mercenary_AS.FOV = 15.5
        g_FaceFXCamera.H_NPC_Mercenary_AS.PosX = -155
        g_FaceFXCamera.H_NPC_Mercenary_AS.PosY = -190
        g_FaceFXCamera.H_NPC_Mercenary_AS.PosZ = 0
        g_FaceFXCamera.H_NPC_Mercenary_AS.LookAtX = -68
        g_FaceFXCamera.H_NPC_Mercenary_AS.LookAtY = -90
        g_FaceFXCamera.H_NPC_Mercenary_AS.LookAtZ = -13
        
        g_FaceFXCamera.H_NPC_Monk_AS = {}
        g_FaceFXCamera.H_NPC_Monk_AS.FOV = 15.5
        g_FaceFXCamera.H_NPC_Monk_AS.PosX = -155
        g_FaceFXCamera.H_NPC_Monk_AS.PosY = -190
        g_FaceFXCamera.H_NPC_Monk_AS.PosZ = 0
        g_FaceFXCamera.H_NPC_Monk_AS.LookAtX = -68
        g_FaceFXCamera.H_NPC_Monk_AS.LookAtY = -90
        g_FaceFXCamera.H_NPC_Monk_AS.LookAtZ = -10
        
        g_FaceFXCamera.H_NPC_Monk_Khana = {}
        g_FaceFXCamera.H_NPC_Monk_Khana.FOV = 14.5
        g_FaceFXCamera.H_NPC_Monk_Khana.PosX = -155
        g_FaceFXCamera.H_NPC_Monk_Khana.PosY = -190
        g_FaceFXCamera.H_NPC_Monk_Khana.PosZ = 0
        g_FaceFXCamera.H_NPC_Monk_Khana.LookAtX = -68
        g_FaceFXCamera.H_NPC_Monk_Khana.LookAtY = -90
        g_FaceFXCamera.H_NPC_Monk_Khana.LookAtZ = -10
        
        g_FaceFXCamera.H_NPC_Monk_Old_AS = {}
        g_FaceFXCamera.H_NPC_Monk_Old_AS.FOV = 14.5
        g_FaceFXCamera.H_NPC_Monk_Old_AS.PosX = -155
        g_FaceFXCamera.H_NPC_Monk_Old_AS.PosY = -190
        g_FaceFXCamera.H_NPC_Monk_Old_AS.PosZ = 0
        g_FaceFXCamera.H_NPC_Monk_Old_AS.LookAtX = -68
        g_FaceFXCamera.H_NPC_Monk_Old_AS.LookAtY = -90
        g_FaceFXCamera.H_NPC_Monk_Old_AS.LookAtZ = -12
        
        g_FaceFXCamera.H_NPC_Villager_AS = {}
        g_FaceFXCamera.H_NPC_Villager_AS.FOV = 12.5
        g_FaceFXCamera.H_NPC_Villager_AS.PosX = -155
        g_FaceFXCamera.H_NPC_Villager_AS.PosY = -190
        g_FaceFXCamera.H_NPC_Villager_AS.PosZ = 0
        g_FaceFXCamera.H_NPC_Villager_AS.LookAtX = -68
        g_FaceFXCamera.H_NPC_Villager_AS.LookAtY = -90
        g_FaceFXCamera.H_NPC_Villager_AS.LookAtZ = -10
    end      
end




do 
    local OldGetKnightActor = GetKnightActor
    
    function GetKnightActor(_KnightEntityType)
        local Actor = nil
    
        if _KnightEntityType == Entities.U_KnightSaraya then
            Actor = "H_Knight_Saraya"
            
            return Actor
        elseif _KnightEntityType == Entities.U_KnightKhana then
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
        end
        
        return OldGetKnightActor(_KnightEntityType)
    end
end    


function FixCameraPosition(_LookAtX, _LookAtY, _RotationAngle, _ZoomFactor)
    Camera.RTS_SetRotationAngle(_RotationAngle)
    Camera.RTS_SetLookAtPosition(_LookAtX, _LookAtY)
    Camera.RTS_SetZoomFactor(_ZoomFactor)
    
    CameraAnimation.AllowAbort = false    
    CameraAnimation.QueueAnimation( CameraAnimation.Stay ,  9999 )
end


function SetPreferredPlayerColor()
    local newColor = Profile.GetInteger("Profile", "PreferredPlayerColor", 1)

    GUI.SendScriptCommand("PlayerChangePlayerColor2("..newColor..")")
end