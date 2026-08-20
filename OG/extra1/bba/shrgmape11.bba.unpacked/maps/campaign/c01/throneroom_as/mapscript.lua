
--++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
-- This function is called from main script to initialize the players
-- including resources, rights and initial diplomacy state
-- this is data that could be saved with the editor in an xml file later
function Mission_InitPlayers()

end


--++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
-- This function is called from main script to define the month offset
-- this is data that could be saved with the editor in an xml file later
function Mission_SetStartingMonth()

end

--++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
-- This function is called from main script to define the month offset
-- this is data that could be saved with the editor in an xml file later
function Mission_SetStartingMonth()

    Logic.SetMonthOffset(4)

end

--++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
-- This function is called from main script to add offers to all kind of traders on the map
-- this is data that could be saved with the editor in an xml file later
function Mission_InitMerchants()

end
----------------------------------------------------------------------------------------------------------------------
g_GlobalThroneRoom = {
	Map = {
		x = 1549.6,
		y = 2898.7
	},
	Size = 0,
	Effect = 0,
	Selection = {
		Entries = {id = {},x = {},y = {}},
	}
}
----------------------------------------------------------------------------------------------------------------------
function RemoveTraitorFromThroneRoom()

    

end

function AddMap(_Entity,_Size)

	if _Size ~= nil then

		g_GlobalThroneRoom.Size = _Size
		
	else
	
		g_GlobalThroneRoom.Size = 704
	
	end

	if _Entity == nil then

		Logic.CreateEntity(Entities.MissionMap_C00M01,g_GlobalThroneRoom.Map.x,g_GlobalThroneRoom.Map.y,0, 0)

	else

		local Entity = Logic.GetEntityIDByName("CampaignMapTable")
	
		local mapX,mapY = Logic.GetEntityPosition(Entity)
	
 		Logic.CreateEntity(_Entity,mapX,mapY,0, 0)

 	end

end
----------------------------------------------------------------------------------------------------------------------
function ConvertMapToTable(x,y)

	local alpha = -0.807810678118654752440084436210485
	local sinus = math.sin(alpha)
	local cosinus = math.cos(alpha)
	local magic_value = 700.0

	local size = g_GlobalThroneRoom.Size * 100 /2

	x = (x - size) / magic_value
	y = (y - size) / magic_value

	local resultx = x * cosinus - y * sinus
	local resulty = y * cosinus + x * sinus

	local Entity = Logic.GetEntityIDByName("CampaignMapTable")

	local mapX,mapY = Logic.GetEntityPosition(Entity)

	return (mapX + resultx),(mapY + resulty)

end
----------------------------------------------------------------------------------------------------------------------
function AddBandit(x,y,name)

	local xt,yt = ConvertMapToTable(x,y)

	local entity = Logic.CreateEntity(Entities.D_X_CampaignMap_E_Bandit,xt,yt,0, 0)

	if name ~= nil then

		Logic.SetEntityName(entity,name)

	end

end
----------------------------------------------------------------------------------------------------------------------
function AddCity(x,y,name)

	local xt,yt = ConvertMapToTable(x,y)

	local entity = Logic.CreateEntity(Entities.D_X_CampaignMap_E_City,xt,yt,0, 0)

	if name ~= nil then

		Logic.SetEntityName(entity,name)

	end

end
----------------------------------------------------------------------------------------------------------------------
function AddVillage(x,y,name)

	local xt,yt = ConvertMapToTable(x,y)

	local entity = Logic.CreateEntity(Entities.D_X_CampaignMap_E_Village,xt,yt,0, 0)

	if name ~= nil then

		Logic.SetEntityName(entity,name)

	end

end
----------------------------------------------------------------------------------------------------------------------
function AddCloister(x,y,name)

	local xt,yt = ConvertMapToTable(x,y)

	local entity = Logic.CreateEntity(Entities.D_X_CampaignMap_E_Cloister,xt,yt,0, 0)

	if name ~= nil then

		Logic.SetEntityName(entity,name)

	end

end
----------------------------------------------------------------------------------------------------------------------
function AddMercenary(x,y,name)

	local xt,yt = ConvertMapToTable(x,y)

	local entity = Logic.CreateEntity(Entities.D_X_CampaignMap_E_Mercenary,xt,yt,0, 0)

	if name ~= nil then

		Logic.SetEntityName(entity,name)

	end

end
----------------------------------------------------------------------------------------------------------------------
function AddOutpost(x,y,name)

	local xt,yt = ConvertMapToTable(x,y)

	local entity = Logic.CreateEntity(Entities.D_X_CampaignMap_E_Outpost,xt,yt,0, 0)

	if name ~= nil then

		Logic.SetEntityName(entity,name)

	end

end
----------------------------------------------------------------------------------------------------------------------
function AddPredator(x,y,name)

	local xt,yt = ConvertMapToTable(x,y)

	local entity = Logic.CreateEntity(Entities.D_X_CampaignMap_E_Predator,xt,yt,0, 0)

	if name ~= nil then

		Logic.SetEntityName(entity,name)

	end

end
----------------------------------------------------------------------------------------------------------------------
function AddSoldier(x,y,name)

	local xt,yt = ConvertMapToTable(x,y)

	local entity = Logic.CreateEntity(Entities.D_X_CampaignMap_E_Soldier,xt,yt,0, 0)

	if name ~= nil then

		Logic.SetEntityName(entity,name)

	end

end
----------------------------------------------------------------------------------------------------------------------
function AddSpecial(x,y,name)

	local xt,yt = ConvertMapToTable(x,y)

	local entity = Logic.CreateEntity(Entities.D_X_CampaignMap_E_Special,xt,yt,0, 0)

	if name ~= nil then

		Logic.SetEntityName(entity,name)

	end

end
----------------------------------------------------------------------------------------------------------------------
function AddStartposition(x,y,name)

	local xt,yt = ConvertMapToTable(x,y)

	local entity = Logic.CreateEntity(Entities.D_X_CampaignMap_E_Startposition,xt,yt,0, 0)

	if name ~= nil then

		Logic.SetEntityName(entity,name)

	end

end
----------------------------------------------------------------------------------------------------------------------
function AddMerchantShip(x,y,name)

	local xt,yt = ConvertMapToTable(x,y)

	local entity = Logic.CreateEntity(Entities.D_X_CampaignMap_E_Trader,xt,yt,0, 0)

	if name ~= nil then

		Logic.SetEntityName(entity,name)

	end

end
----------------------------------------------------------------------------------------------------------------------
function AddKnightCursor(knight)

	local mapX,mapY = Logic.GetEntityPosition(knight)
	
	RemoveKnightCursor()

	g_GlobalThroneRoom.Effect = Logic.CreateEffectWithOrientation(EGL_Effects.E_Throneroom_KnightSelection,mapX,mapY,0,0)

end
----------------------------------------------------------------------------------------------------------------------
function RemoveKnightCursor()

	if g_GlobalThroneRoom.Effect ~= 0 then

		Logic.DestroyEffect(g_GlobalThroneRoom.Effect)

		g_GlobalThroneRoom.Effect = 0
		
	end

end
----------------------------------------------------------------------------------------------------------------------
function AddSelection(x,y)

	local xt,yt

	if y == nil then

		local object = Logic.GetEntityIDByName(x)

		xt,yt = Logic.GetEntityPosition(object)

	else

		xt,yt = ConvertMapToTable(x,y)

	end
			
	local entity = Logic.CreateEntity(Entities.D_X_CampaignMap_E_Selection,xt,yt,0, 0)

	table.insert(g_GlobalThroneRoom.Selection.Entries.x,xt)
	table.insert(g_GlobalThroneRoom.Selection.Entries.y,yt)
	table.insert(g_GlobalThroneRoom.Selection.Entries.id,entity)

end
----------------------------------------------------------------------------------------------------------------------
function DestroySelection()

	while #g_GlobalThroneRoom.Selection.Entries.x > 0 do

		local id = g_GlobalThroneRoom.Selection.Entries.id[1]
		local x = g_GlobalThroneRoom.Selection.Entries.x[1]
		local y = g_GlobalThroneRoom.Selection.Entries.y[1]

		Logic.DestroyEntity(g_GlobalThroneRoom.Selection.Entries.id[1])

		table.remove(g_GlobalThroneRoom.Selection.Entries.id,1)
		table.remove(g_GlobalThroneRoom.Selection.Entries.x,1)
		table.remove(g_GlobalThroneRoom.Selection.Entries.y,1)

	end

end
----------------------------------------------------------------------------------------------------------------------
function RemoveSelection(x,y)

	local xs = x
	local ys = y

	if y == nil then

		local object = Logic.GetEntityIDByName(x)

		xs,ys = Logic.GetEntityPosition(object)

--		xs = xs - g_GlobalThroneRoom.Map.x
--		ys = ys - g_GlobalThroneRoom.Map.y

	end

	local numberOfEntries = #g_GlobalThroneRoom.Selection.Entries.x

	for i = 1 , numberOfEntries do

		if math.floor(g_GlobalThroneRoom.Selection.Entries.x[i]) == math.floor(xs) and math.floor(g_GlobalThroneRoom.Selection.Entries.y[i]) == math.floor(ys) then

			Logic.DestroyEntity(g_GlobalThroneRoom.Selection.Entries.id[i])

			table.remove(g_GlobalThroneRoom.Selection.Entries.id,i)
			table.remove(g_GlobalThroneRoom.Selection.Entries.x,i)
			table.remove(g_GlobalThroneRoom.Selection.Entries.y,i)

		end

	end

end
----------------------------------------------------------------------------------------------------------------------
function SetAnimation( _KnightType, _Textkey, _SectionKey)

    local Amount, ID = Logic.GetPlayerEntities(1,_KnightType,1,0)
    local FaceAnimation

    if (_SectionKey == nil) then
    
	    local map = Framework.GetCurrentMapName()
	    local SectionKey = "Map_".. map .."_speech"	
        
        FaceAnimation = SectionKey .. "_" .. _Textkey
    
    else
    
        FaceAnimation = _SectionKey .. "_" .. _Textkey
    
    end
    
    Logic.SetEntityFaceFXAnimation (ID,  FaceAnimation, "LipSync")
    

    local animation = "throneroom\\" .. _Textkey
    Logic.SetEntityAnimation(ID, animation)

--        Logic.ExecuteInLuaLocalState("Display.LoadAllModels()")

end
----------------------------------------------------------------------------------------------------------------------
function StopAllAnimations()

	PlayAnimation(Entities.U_KnightTradingStanding,"Idle01","Idle01_KnightTrading")
	PlayAnimation(Entities.U_KnightWisdomStanding,"Idle01","Idle01_KnightWisdom")
	PlayAnimation(Entities.U_KnightChivalryStanding,"Idle01","Idle01_KnightChivalry")
	PlayAnimation(Entities.U_KnightSarayaStanding,"Idle01","Idle01_KnightHealing")

end
----------------------------------------------------------------------------------------------------------------------
function PlayAnimation(_KnightType,_FaceAnimation,_BodyAnimation)
    local Amount, ID = Logic.GetPlayerEntities(1,_KnightType,1,0)

    if ID ~= 0 then

		local body_animation = string.lower(_BodyAnimation)

    	Logic.SetEntityAnimation(ID,"throneroom\\"..body_animation)

    	Logic.SetEntityFaceFXAnimation (ID,_FaceAnimation,"Idle")

    end

end
----------------------------------------------------------------------------------------------------------------------
function RemoveKnight( _KnightType )

    local Amount, ID = Logic.GetPlayerEntities(1,_KnightType,1,0)

	Logic.DestroyEntity(ID)

end
----------------------------------------------------------------------------------------------------------------------
function LoadThroneRoomScript()

	local campaign = Framework.GetCampaignName()

	local map = Framework.GetCurrentMapName()

	Script.Load("Maps\\Campaign\\"..campaign.."\\"..map.."\\throneroom.lua")

end
----------------------------------------------------------------------------------------------------------------------
function Mission_FirstMapAction()

	DisableFoW()

	LoadThroneRoomScript()

	if RemoveKnightsFromThroneRoom ~= nil then
	    RemoveKnightsFromThroneRoom()
    end


	local mapX,mapY = Logic.GetEntityPosition(Logic.GetEntityIDByName("CampaignMapTable"))

	Logic.CreateEntity(Entities.AS_ThroneRoom_Cube,mapX,mapY,0,0)

end

