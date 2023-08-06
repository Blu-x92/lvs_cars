
hook.Add( "LVS:Initialize", "[LVS] - Cars - Keys", function()
	local KEYS = {
		{
			name = "CAR_THROTTLE",
			category = "LVS-Car",
			name_menu = "Throttle",
			default = "+forward",
			cmd = "lvs_car_throttle"
		},
		{
			name = "CAR_THROTTLE_MOD",
			category = "LVS-Car",
			name_menu = "Throttle Modifier",
			default = "+speed",
			cmd = "lvs_car_speed"
		},
		{
			name = "CAR_BRAKE",
			category = "LVS-Car",
			name_menu = "Brake",
			default = "+back",
			cmd = "lvs_car_brake"
		},
		{
			name = "CAR_HANDBRAKE",
			category = "LVS-Car",
			name_menu = "Handbrake",
			default = "+jump",
			cmd = "lvs_car_handbrake"
		},
		{
			name = "CAR_REVERSE",
			category = "LVS-Car",
			name_menu = "Toggle Reverse",
			default = "+walk",
			cmd = "lvs_car_reverse"
		},
		{
			name = "CAR_STEER_LEFT",
			category = "LVS-Car",
			name_menu = "Steer Left",
			default = "+moveleft",
			cmd = "lvs_car_turnleft"
		},
		{
			name = "CAR_STEER_RIGHT",
			category = "LVS-Car",
			name_menu = "Steer Right",
			default = "+moveright",
			cmd = "lvs_car_turnright"
		},
	}

	for _, v in pairs( KEYS ) do
		LVS:AddKey( v.name, v.category, v.name_menu, v.cmd, v.default )
	end

	LVS.SOUNDTYPE_NONE = 0
	LVS.SOUNDTYPE_IDLE_ONLY = 1
	LVS.SOUNDTYPE_REV_UP = 2
	LVS.SOUNDTYPE_REV_DOWN = 3
	LVS.SOUNDTYPE_REV_DN = 3
end )

if SERVER then return end

local cvarDev = GetConVar( "developer" )
LVS.CarsDeveloperEnabled = cvarDev and (cvarDev:GetInt() >= 1) or false
cvars.AddChangeCallback( "developer", function( convar, oldValue, newValue )
	LVS.CarsDeveloperEnabled = tonumber( newValue ) >= 1
end)
