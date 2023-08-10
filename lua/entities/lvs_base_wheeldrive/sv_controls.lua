
function ENT:CalcSteer( ply, cmd )
	local KeyLeft = ply:lvsKeyDown( "CAR_STEER_LEFT" )
	local KeyRight = ply:lvsKeyDown( "CAR_STEER_RIGHT" )

	local MaxSteer = self:GetMaxSteerAngle()

	local Vel = self:GetVelocity()

	local TargetValue = (KeyRight and 1 or 0) - (KeyLeft and 1 or 0)

	if Vel:Length() > self.FastSteerActiveVelocity then
		local Forward = self:GetForward()
		local Right = self:GetRight()

		local Axle = self:GetAxleData( 1 )

		if Axle then
			local Ang = self:LocalToWorldAngles( self:GetAxleData( 1 ).ForwardAngle )

			Forward = Ang:Forward()
			Right = Ang:Right()
		end

		local VelNormal = Vel:GetNormalized()

		local DriftAngle = self:AngleBetweenNormal( Forward, VelNormal )

		if DriftAngle < self.FastSteerDeactivationDriftAngle then
			MaxSteer = math.min( MaxSteer, self.FastSteerAngleClamp )
		end

		if not KeyLeft and not KeyRight then
			local Cur = self:GetSteer() / MaxSteer

			local MaxHelpAng = math.min( MaxSteer, self.SteerAssistMaxAngle )

			local Ang = self:AngleBetweenNormal( Right, VelNormal ) - 90
			local HelpAng = ((math.abs( Ang ) / 90) ^ self.SteerAssistExponent) * 90 * self:Sign( Ang )

			TargetValue = math.Clamp( -HelpAng * self.SteerAssistMultiplier,-MaxHelpAng,MaxHelpAng) / MaxSteer
		end
	end

	local Cur = self:GetSteer() / MaxSteer

	local Diff = TargetValue - Cur

	local Returning = (Diff > 0 and Cur < 0) or (Diff < 0 and Cur > 0)

	local Rate = FrameTime() * (Returning and self.SteerReturnSpeed or self.SteerSpeed)

	local New = (Cur + math.Clamp(Diff,-Rate,Rate))

	self:SetSteer( New * MaxSteer )
	self:SetPoseParameter( "vehicle_steer", New  )
end

function ENT:CalcThrottle( ply, cmd )
	if not self:GetEngineActive() then self:SetThrottle( 0 ) return end

	local ThrottleValue = ply:lvsKeyDown( "CAR_THROTTLE_MOD" ) and 1 or 0.5

	local Throttle = ply:lvsKeyDown( "CAR_THROTTLE" ) and ThrottleValue or 0

	local Rate = FrameTime() * 3.5
	local Cur = self:GetThrottle()
	local New = Cur + math.Clamp(Throttle - Cur,-Rate,Rate)

	self:SetThrottle( New )
end

function ENT:CalcHandbrake( ply, cmd )
	if ply:lvsKeyDown( "CAR_HANDBRAKE" ) then
		self:EnableHandbrake()
	else
		self:ReleaseHandbrake()
	end
end

function ENT:CalcBrake( ply, cmd )
	local Brake = ply:lvsKeyDown( "CAR_BRAKE" ) and 1 or 0

	local Rate = FrameTime() * 3.5
	local Cur = self:GetBrake()
	local New = Cur + math.Clamp(Brake - Cur,-Rate,Rate)

	self:SetBrake( New )
end

function ENT:CalcTransmission( ply, cmd )
	local walk = ply:lvsKeyDown( "CAR_REVERSE" )

	if walk ~= self._oldwalk then
		self._oldwalk = walk

		if not walk then return end

		self:SetReverse( not self:GetReverse() )
	end
end

function ENT:CalcLights( ply, cmd )
	local LightsHandler = self:GetLightsHandler()

	if not IsValid( LightsHandler ) then return end

	local lights = ply:lvsKeyDown( "CAR_LIGHTS_TOGGLE" )

	if lights ~= self._oldlights then
		self._oldlights = lights

		if not lights then return end

		self:EmitSound( "buttons/lightswitch2.wav", 75, 80, 0.25)

		LightsHandler:SetActive( not LightsHandler:GetActive() )
	end
end

function ENT:StartCommand( ply, cmd )
	if self:GetDriver() ~= ply then return end

	if ply:lvsKeyDown( "CAR_MENU" ) then return end

	self:CalcSteer( ply, cmd )
	self:CalcThrottle( ply, cmd )
	self:CalcHandbrake( ply, cmd )
	self:CalcBrake( ply, cmd )
	self:CalcTransmission( ply, cmd )
	self:CalcLights( ply, cmd )
end
