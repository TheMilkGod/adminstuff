timer.Simple(8, function()
	-- This module holds any type of chatting functions
	CATEGORY_NAME = "Chat"
	------------------------------ Gimp ------------------------------
	ulx.gimpSays = ulx.gimpSays or {} -- Holds gimp says
	local gimpSays = ulx.gimpSays -- For XGUI, too lazy to change all refs
	local ID_GIMP = 1
	local ID_MUTE = 2

	function ulx.addGimpSay( say )
		table.insert( gimpSays, say )
	end

	function ulx.clearGimpSays()
		table.Empty( gimpSays )
	end

	function ulx.gimp( calling_ply, target_plys, should_ungimp )
		if (calling_ply:GetNWBool('isAdmin') == nil) or (calling_ply:GetNWBool('isAdmin') == false) then if SERVER then calling_ply:SendLua("chat.AddText(Color(255,0,0), 'Enable admin mode! !admin')") end return end
		for i=1, #target_plys do
			local v = target_plys[ i ]
			if should_ungimp then
				v.gimp = nil
			else
				v.gimp = ID_GIMP
			end
			v:SetNWBool("ulx_gimped", not should_ungimp)
		end

		if not should_ungimp then
			ulx.fancyLogAdmin( calling_ply, "| #A gimped #T", target_plys )
		else
			ulx.fancyLogAdmin( calling_ply, "| #A ungimped #T", target_plys )
		end
	end
	local gimp = ulx.command( CATEGORY_NAME, "ulx gimp", ulx.gimp, "!gimp" )
	gimp:addParam{ type=ULib.cmds.PlayersArg }
	gimp:addParam{ type=ULib.cmds.BoolArg, invisible=true }
	gimp:defaultAccess( ULib.ACCESS_ADMIN )
	gimp:help( "Gimps target(s) so they are unable to chat normally." )
	gimp:setOpposite( "ulx ungimp", {_, _, true}, "!ungimp" )

	------------------------------ Mute ------------------------------
	function ulx.mute( calling_ply, target_plys, should_unmute )
		if (calling_ply:GetNWBool('isAdmin') == nil) or (calling_ply:GetNWBool('isAdmin') == false) then if SERVER then calling_ply:SendLua("chat.AddText(Color(255,0,0), 'Enable admin mode! !admin')") end return end
		for i=1, #target_plys do
			local v = target_plys[ i ]
			if should_unmute then
				v.gimp = nil
			else
				v.gimp = ID_MUTE
			end
			v:SetNWBool("ulx_muted", not should_unmute)
		end

		if not should_unmute then
			ulx.fancyLogAdmin( calling_ply, "| #A muted #T 's chat", target_plys )
		else
			ulx.fancyLogAdmin( calling_ply, "| #A unmuted #T 's chat", target_plys )
		end
	end
	local mute = ulx.command( CATEGORY_NAME, "ulx mute", ulx.mute, "!mute" )
	mute:addParam{ type=ULib.cmds.PlayersArg }
	mute:addParam{ type=ULib.cmds.BoolArg, invisible=true }
	mute:defaultAccess( ULib.ACCESS_ADMIN )
	mute:help( "Mutes target(s) so they are unable to chat." )
	mute:setOpposite( "ulx unmute", {_, _, true}, "!unmute" )

	if SERVER then
		local function gimpCheck( ply, strText )
			if ply.gimp == ID_MUTE then return "" end
			if ply.gimp == ID_GIMP then
				if #gimpSays < 1 then return nil end
				return gimpSays[ math.random( #gimpSays ) ]
			end
		end
		hook.Add( "PlayerSay", "ULXGimpCheck", gimpCheck, HOOK_LOW )
	end

	------------------------------ Gag ------------------------------
	function ulx.gag( calling_ply, target_plys, should_ungag )
		if (calling_ply:GetNWBool('isAdmin') == nil) or (calling_ply:GetNWBool('isAdmin') == false) then if SERVER then calling_ply:SendLua("chat.AddText(Color(255,0,0), 'Enable admin mode! !admin')") end return end
		local players = player.GetAll()
		for i=1, #target_plys do
			local v = target_plys[ i ]
			v.ulx_gagged = not should_ungag
			v:SetNWBool("ulx_gagged", v.ulx_gagged)
		end

		if not should_ungag then
			ulx.fancyLogAdmin( calling_ply, "| #A gagged #T", target_plys )
		else
			ulx.fancyLogAdmin( calling_ply, "| #A ungagged #T", target_plys )
		end
	end
	local gag = ulx.command( CATEGORY_NAME, "ulx gag", ulx.gag, "!gag" )
	gag:addParam{ type=ULib.cmds.PlayersArg }
	gag:addParam{ type=ULib.cmds.BoolArg, invisible=true }
	gag:defaultAccess( ULib.ACCESS_ADMIN )
	gag:help( "Gag target(s), disables microphone." )
	gag:setOpposite( "ulx ungag", {_, _, true}, "!ungag" )

	local function gagHook( listener, talker )
		if talker.ulx_gagged then
			return false
		end
	end
	hook.Add( "PlayerCanHearPlayersVoice", "ULXGag", gagHook )

	-- Anti-spam stuff
	if SERVER then
		local chattime_cvar = ulx.convar( "chattime", "1.5", "<time> - Players can only chat every x seconds (anti-spam). 0 to disable.", ULib.ACCESS_ADMIN )
		local function playerSay( ply )
			if not ply.lastChatTime then ply.lastChatTime = 0 end

			local chattime = chattime_cvar:GetFloat()
			if chattime <= 0 then return end

			if ply.lastChatTime + chattime > CurTime() then
				return ""
			else
				ply.lastChatTime = CurTime()
				return
			end
		end
		hook.Add( "PlayerSay", "ulxPlayerSay", playerSay, HOOK_LOW )

		local function meCheck( ply, strText, bTeam )
			local meChatEnabled = GetConVarNumber( "ulx_meChatEnabled" )

			if ply.gimp or meChatEnabled == 0 or (meChatEnabled ~= 2 and GAMEMODE.Name ~= "Sandbox") then return end -- Don't mess

			if strText:sub( 1, 4 ) == "/me " then
				strText = string.format( "*** %s %s", ply:Nick(), strText:sub( 5 ) )
				if not bTeam then
					ULib.tsay( _, strText )
				else
					strText = "(TEAM) " .. strText
					local teamid = ply:Team()
					local players = team.GetPlayers( teamid )
					for _, ply2 in ipairs( players ) do
						ULib.tsay( ply2, strText )
					end
				end

				if game.IsDedicated() then
					Msg( strText .. "\n" ) -- Log to console
				end
				if ULib.toBool( GetConVarNumber( "ulx_logChat" ) ) then
					ulx.logString( strText )
				end

				return ""
			end

		end
		hook.Add( "PlayerSay", "ULXMeCheck", meCheck, HOOK_LOW ) -- Extremely low priority
	end

	local function showWelcome( ply )
		local message = GetConVarString( "ulx_welcomemessage" )
		if not message or message == "" then return end

		message = string.gsub( message, "%%curmap%%", game.GetMap() )
		message = string.gsub( message, "%%host%%", GetConVarString( "hostname" ) )
		message = string.gsub( message, "%%ulx_version%%", ULib.pluginVersionStr( "ULX" ) )

		ply:ChatPrint( message ) -- We're not using tsay because ULib might not be loaded yet. (client side)
	end
	hook.Add( "PlayerInitialSpawn", "ULXWelcome", showWelcome )
	if SERVER then
		ulx.convar( "meChatEnabled", "1", "Allow players to use '/me' in chat. 0 = Disabled, 1 = Sandbox only (Default), 2 = Enabled", ULib.ACCESS_ADMIN )
		ulx.convar( "welcomemessage", "", "<msg> - This is shown to players on join.", ULib.ACCESS_ADMIN )
	end
end)