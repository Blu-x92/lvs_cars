
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

		if DriftAngle > self.SteerAssistDeadZoneAngle then
			if not KeyLeft and not KeyRight then
				local Cur = self:GetSteer() / MaxSteer

				local HelpAng = math.min( MaxSteer, self.SteerAssistMaxAngle )

				TargetValue = math.Clamp( -(self:AngleBetweenNormal( Right, VelNormal ) - 90) * self.SteerAssistMultiplier,-HelpAng,HelpAng) / MaxSteer
			end
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

function ENT:StartCommand( ply, cmd )
	if self:GetDriver() ~= ply then return end

	self:CalcSteer( ply, cmd )
	self:CalcThrottle( ply, cmd )
	self:CalcHandbrake( ply, cmd )
	self:CalcBrake( ply, cmd )

	local walk = ply:lvsKeyDown( "CAR_REVERSE" )

	if walk ~= self._oldwalk then
		self._oldwalk = walk

		if walk then
			self:SetReverse( not self:GetReverse() )
		end
	end
end
