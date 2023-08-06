AddCSLuaFile( "shared.lua" )
AddCSLuaFile( "cl_init.lua" )
include("shared.lua")

function ENT:OnSpawn( PObj )
	self:AddDriverSeat( Vector(-9.6,11.9,0), Angle(0,-90,8) )
	self:AddPassengerSeat( Vector(5,-11.9,12), Angle(0,-90,28) )

	self:AddEngine( Vector(45,0,20) )

	self:AddDoorHandler( Vector(-13,55,27), "left_door" )
	self:AddDoorHandler( Vector(-13,-55,27), "right_door" )

	local WheelModel = "models/diggercars/porsche_930/wheel.mdl"

	local FrontAxle = self:DefineAxle( {
		Axle = {
			ForwardAngle = Angle(0,0,0),
			SteerType = LVS.WHEEL_STEER_FRONT,
			SteerAngle = 30,
			TorqueFactor = 0,
			BrakeFactor = 1,
		},
		Wheels = {
			self:AddWheel( {
				pos = Vector(47.2,26.5,14),
				mdl = WheelModel,
				mdl_ang = Angle(0,90,0),
			} ),

			self:AddWheel( {
				pos = Vector(47.2,-26.5,14),
				mdl = WheelModel,
				mdl_ang = Angle(0,-90,0),
			} ),
		},
		Suspension = {
			Height = 10,
			MaxTravel = 7,
			ControlArmLength = 25,
			SpringConstant = 20000,
			SpringDamping = 2000,
			SpringRelativeDamping = 2000,
		},
	} )

	local RearAxle = self:DefineAxle( {
		Axle = {
			ForwardAngle = Angle(0,0,0),
			SteerType = LVS.WHEEL_STEER_NONE,
			TorqueFactor = 1,
			BrakeFactor = 1,
			UseHandbrake = true,
		},
		Wheels = {
			self:AddWheel( {
				pos = Vector(-41.2,25.5,15),
				mdl = WheelModel,
				mdl_ang = Angle(0,90,0),
			} ),

			self:AddWheel( {
				pos = Vector(-41.2,-25.5,15),
				mdl = WheelModel,
				mdl_ang = Angle(0,-90,0),
			} ),
		},
		Suspension = {
			Height = 10,
			MaxTravel = 7,
			ControlArmLength = 25,
			SpringConstant = 20000,
			SpringDamping = 2000,
			SpringRelativeDamping = 2000,
		},
	} )
end

function ENT:OnEngineActiveChanged( Active )
	if Active then
		self:EmitSound( "lvs/vehicles/kuebelwagen/engine_start.wav" )
	else
		self:EmitSound( "lvs/vehicles/kuebelwagen/engine_stop.wav" )
	end
end