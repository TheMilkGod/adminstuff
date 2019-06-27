local CATEGORY_NAME = "Admin"

if SERVER then
	hook.Add("PlayerInitialSpawn","RK_libgmodstore_fetchwhenready",function( ply )
		ply:DisallowNoclip( true )
	end )
end
-- Admin Calls a !sit to Teleport to Sit Room.

function ulx.sit( calling_ply, target_ply )
local sspos = file.Read( "ssp.txt", "DATA" )
	print(sspos)
	target_ply.ulx_prevpos = target_ply:GetPos()
	target_ply.ulx_prevang = target_ply:EyeAngles()

	if sspos != nil then -- if its not nil then do what we want    
	calling_ply:SetPos( Vector(sspos) )
	ULib.tsay( calling_ply, "You have been put in the sit room!", true )
	else -- if its nil then tell a nibba
		ULib.tsay( calling_ply, "Set the sit position!", true )
	end
end

local sit = ulx.command( CATEGORY_NAME, "ulx sit", ulx.sit, "!sit" )
sit:addParam{ type=ULib.cmds.PlayerArg, ULib.cmds.optional }
sit:defaultAccess( ULib.ACCESS_ADMIN )
sit:help( "Teleport to Sit Room." )



function ulx.ssp( calling_ply )
local plypos = tostring(calling_ply:GetPos())
 if file.Exists( "ssp", "DATA" ) != true then
		file.Delete( "ssp.txt" )
		file.Write( "ssp.txt", plypos )
		ULib.tsay( calling_ply, "You have set the sit position!", true )
	end
end

local ssp = ulx.command( CATEGORY_NAME, "ulx ssp", ulx.ssp, "!ssp" )
ssp:defaultAccess( ULib.ACCESS_ADMIN )
ssp:help( "Set sit position." )



function ulx.sspdel( calling_ply )
		if file.Exists( "ssp", "DATA" ) != true then
		file.Delete( "ssp.txt" )
		ULib.tsay( calling_ply, "You have deleted the sit position!", true )
		else end
	end

local sspdel = ulx.command( CATEGORY_NAME, "ulx sspdel", ulx.sspdel, "!sspdel" )
sspdel:defaultAccess( ULib.ACCESS_ADMIN )
sspdel:help( "Delete sit position." )


-- Force Dead Players to Respawn from !menu

function ulx.respawn( calling_ply, target_ply )
	if not target_ply:Alive() then
		target_ply:Spawn()
		ulx.fancyLogAdmin( calling_ply, true, "| #A Respawned #T", target_ply )
	end
end

local respawn = ulx.command( CATEGORY_NAME, "ulx respawn", ulx.respawn,
"!respawn", true )
respawn:addParam{ type=ULib.cmds.PlayerArg }
respawn:defaultAccess( ULib.ACCESS_ADMIN )
respawn:help( "Respawn a target player." )


-- Admin Mode (PM, & God Mode)

function ulx.admin( calling_ply, should_revoke )

	if calling_ply:GetNWBool('isAdmin') then 
		if not should_revoke then
			ulx.fancyLogAdmin( calling_ply, false, "| #A has stopped administrating" )
		end
		calling_ply:SetNWBool('isAdmin', false)

			if not should_revoke then
			local jobTable = calling_ply:getJobTable()

		if not jobTable then return self.Sandbox.PlayerSetModel(ply) end

		if jobTable.PlayerSetModel then
			local model = jobTable.PlayerSetModel(ply)
			if model then ply:SetModel(model) return end
		end

		if GAMEMODE.Config.enforceplayermodel then
			if istable(jobTable.model) then
				local ChosenModel = string.lower(calling_ply:getPreferredModel(calling_ply:Team()) or "")

				local found
				for _, Models in pairs(jobTable.model) do
					if ChosenModel == string.lower(Models) then
						EndModel = Models
						found = true
						break
					end
				end

				if not found then
					EndModel = jobTable.model[math.random(#jobTable.model)]
				end
			else
				EndModel = jobTable.model
			end

			calling_ply:SetModel(EndModel)

		else
			local cl_playermodel = ply:GetInfo("cl_playermodel")
			local modelname = player_manager.TranslatePlayerModel(cl_playermodel)
			calling_ply:SetModel(calling_ply:getPreferredModel(calling_ply:Team()) or modelname)
		end

		calling_ply:SetupHands()
		end
	else

		if not should_revoke then
			calling_ply:SetModel( "models/player/combine_super_soldier.mdl" )
		end
		if not should_revoke then
			ulx.fancyLogAdmin( calling_ply, false, "| #A is now administrating" )
		end
		calling_ply:SetNWBool( 'isAdmin', true )
	end

	if calling_ply:GetNWBool( 'isAdmin' ) then
		calling_ply:GodEnable()
		calling_ply:DisallowNoclip( false )
	else
		calling_ply:GodDisable()
		calling_ply:DisallowNoclip( true )
	end
end
local admin = ulx.command( "Admin", "ulx admin", ulx.admin, { "!admin", "!admin"}, true )
admin:addParam{ type=ULib.cmds.BoolArg, invisible = true }
admin:defaultAccess( ULib.ACCESS_SUPERADMIN )
admin:help( "Noclip, & God Mode yourself" )
admin:setOpposite( "ulx unadmin", { _, true }, "!unadmin", true )

--- Teleport To INS REC. ROOM ---
function ulx.ins( calling_ply, target_ply )
local sipos = file.Read( "sip.txt", "DATA" )
	print(sipos)
	target_ply.ulx_prevpos = target_ply:GetPos()
	target_ply.ulx_prevang = target_ply:EyeAngles()

	if sipos != nil then -- if its not nil then do what we want    
	calling_ply:SetPos( Vector(sipos) )
	ULib.tsay( calling_ply, "You have been put in the INS room!", true )
	else -- if its nil then tell a nibba
		ULib.tsay( calling_ply, "Set the INS position!", true )
	end
end

local ins = ulx.command( CATEGORY_NAME, "ulx ins", ulx.ins, "!ins" )
ins:addParam{ type=ULib.cmds.PlayerArg, ULib.cmds.optional }
ins:defaultAccess( ULib.ACCESS_ADMIN )
ins:help( "Teleport to INS Room." )



function ulx.sip( calling_ply )
local plypos = tostring(calling_ply:GetPos())
 if file.Exists( "sip", "DATA" ) != true then
		file.Delete( "sip.txt" )
		file.Write( "sip.txt", plypos )
		ULib.tsay( calling_ply, "You have set the INS position!", true )
	end
end

local sip = ulx.command( CATEGORY_NAME, "ulx sip", ulx.sip, "!sip" )
sip:defaultAccess( ULib.ACCESS_ADMIN )
sip:help( "Set ins position." )



function ulx.sipdel( calling_ply )
		if file.Exists( "sip", "DATA" ) != true then
		file.Delete( "sip.txt" )
		ULib.tsay( calling_ply, "You have deleted the INS position!", true )
		else end
	end

local sipdel = ulx.command( CATEGORY_NAME, "ulx sipdel", ulx.sspdel, "!sipdel" )
sipdel:defaultAccess( ULib.ACCESS_ADMIN )
sipdel:help( "Delete INS position." )

--- Teleport To US REC. Room ---
function ulx.us( calling_ply, target_ply )
local supos = file.Read( "sup.txt", "DATA" )
	print(supos)
	target_ply.ulx_prevpos = target_ply:GetPos()
	target_ply.ulx_prevang = target_ply:EyeAngles()

	if supos != nil then -- if its not nil then do what we want    
	calling_ply:SetPos( Vector(supos) )
	ULib.tsay( calling_ply, "You have been put in the US room!", true )
	else -- if its nil then tell a nibba
		ULib.tsay( calling_ply, "Set the US position!", true )
	end
end

local us = ulx.command( CATEGORY_NAME, "ulx us", ulx.us, "!us" )
us:addParam{ type=ULib.cmds.PlayerArg, ULib.cmds.optional }
us:defaultAccess( ULib.ACCESS_ADMIN )
us:help( "Teleport to US Room." )



function ulx.sup( calling_ply )
local plypos = tostring(calling_ply:GetPos())
 if file.Exists( "sup", "DATA" ) != true then
		file.Delete( "sup.txt" )
		file.Write( "sup.txt", plypos )
		ULib.tsay( calling_ply, "You have set the US position!", true )
	end
end

local sup = ulx.command( CATEGORY_NAME, "ulx sup", ulx.sup, "!sup" )
sup:defaultAccess( ULib.ACCESS_ADMIN )
sup:help( "Set US position." )



function ulx.supdel( calling_ply )
		if file.Exists( "sup", "DATA" ) != true then
		file.Delete( "sup.txt" )
		ULib.tsay( calling_ply, "You have deleted the US position!", true )
		else end
	end

local supdel = ulx.command( CATEGORY_NAME, "ulx supdel", ulx.sspdel, "!supdel" )
supdel:defaultAccess( ULib.ACCESS_ADMIN )
supdel:help( "Delete US position." )

---meeting
function ulx.meeting( calling_ply, target_ply )
local smpos = file.Read( "smp.txt", "DATA" )
	print(smpos)
	target_ply.ulx_prevpos = target_ply:GetPos()
	target_ply.ulx_prevang = target_ply:EyeAngles()

	if smpos != nil then -- if its not nil then do what we want    
	calling_ply:SetPos( Vector(smpos) )
	ULib.tsay( calling_ply, "You have been put in the meeting room!", true )
	else -- if its nil then tell a nibba
		ULib.tsay( calling_ply, "Set the meeting position!", true )
	end
end

local meeting = ulx.command( CATEGORY_NAME, "ulx meeting", ulx.meeting, "!meeting" )
meeting:addParam{ type=ULib.cmds.PlayerArg, ULib.cmds.optional }
meeting:defaultAccess( ULib.ACCESS_ADMIN )
meeting:help( "Teleport to meeting Room." )



function ulx.smp( calling_ply )
local plypos = tostring(calling_ply:GetPos())
 if file.Exists( "smp", "DATA" ) != true then
		file.Delete( "smp.txt" )
		file.Write( "smp.txt", plypos )
		ULib.tsay( calling_ply, "You have set the meeting position!", true )
	end
end

local smp = ulx.command( CATEGORY_NAME, "ulx smp", ulx.smp, "!smp" )
smp:defaultAccess( ULib.ACCESS_ADMIN )
smp:help( "Set meeting position." )



function ulx.smpdel( calling_ply )
		if file.Exists( "smp", "DATA" ) != true then
		file.Delete( "smp.txt" )
		ULib.tsay( calling_ply, "You have deleted the meeting position!", true )
		else end
	end

local smpdel = ulx.command( CATEGORY_NAME, "ulx smpdel", ulx.sspdel, "!smpdel" )
smpdel:defaultAccess( ULib.ACCESS_ADMIN )
smpdel:help( "Delete meeting position." )