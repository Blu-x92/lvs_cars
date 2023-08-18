
ENT.Base = "lvs_base_wheeldrive"

ENT.PrintName = "Honda Integra"
ENT.Author = "Digger"
ENT.Information = "Luna's Vehicle Script"
ENT.Category = "[LVS] - Cars"

ENT.Spawnable			= true
ENT.AdminSpawnable		= false

ENT.MDL = "models/DiggerCars/HONDA_INTEGRA_DC2/dc2.mdl"

ENT.MaxVelocity = 2400

ENT.EnginePower = 800
ENT.EngineTorque = 117
ENT.EngineIdleRPM = 1000
ENT.EngineMaxRPM = 8500
ENT.EngineIdleRPM = 600
ENT.EngineMaxRPM = 10000

ENT.TransGears = 5
ENT.TransGearsReverse = 1

ENT.ExhaustPositions = {
	{
		pos = Vector(-87.35,-16.18,12.93),
		ang = Angle(0,180,0),
	}
}

ENT.EngineSounds = {
	{
		sound = "lvs/vehicles/miata/idle.wav",
		Volume = 1,
		Pitch = 85,
		PitchMul = 25,
		SoundLevel = 75,
		SoundType = LVS.SOUNDTYPE_IDLE_ONLY,
	},
	{
		sound = "lvs/vehicles/miata/rev.wav",
		Volume = 1,
		Pitch = 60,
		PitchMul = 90,
		SoundLevel = 75,
		SoundType = LVS.SOUNDTYPE_REV_UP,
		UseDoppler = true,
	},
	{
		sound = "lvs/vehicles/miata/low.wav",
		Volume = 1,
		Pitch = 70,
		PitchMul = 90,
		SoundLevel = 75,
		SoundType = LVS.SOUNDTYPE_REV_DOWN,
		UseDoppler = true,
	},
}
