
function ENT:OnCreateAI()
end

function ENT:OnRemoveAI()
end

function ENT:RunAI()
	local Target = self:AIGetTarget( 180 )

	local StartPos = self:LocalToWorld( self:OBBCenter() )

	local TargetPos = Target:GetPos()

	self._AIFireInput = false

	if IsValid( self:GetHardLockTarget() ) then
		Target = self:GetHardLockTarget()

		TargetPos = Target:LocalToWorld( Target:OBBCenter() )

		self._AIFireInput = true
	else
		if IsValid( Target ) then
			local PhysObj = Target:GetPhysicsObject()
			if IsValid( PhysObj ) then
				TargetPos = Target:LocalToWorld( PhysObj:GetMassCenter() )
			else
				TargetPos = Target:LocalToWorld( Target:OBBCenter() )
			end

			if self:AIHasWeapon( 1 ) or self:AIHasWeapon( 2 ) then
				self._AIFireInput = true
			end

			local CurHeat = self:GetNWHeat()
			local CurWeapon = self:GetSelectedWeapon()

			if CurWeapon > 2 then
				self:AISelectWeapon( 1 )
			else
				if Target.LVS and CurHeat < 0.9 then
					if CurWeapon == 1 and self:AIHasWeapon( 2 ) then
						self:AISelectWeapon( 2 )

					elseif CurWeapon == 2 then
						self:AISelectWeapon( 1 )
					end
				else
					if CurHeat == 0 and math.cos( CurTime() ) > 0 then
						self:AISelectWeapon( 1 )
					end
				end
			end
		end
	end

	self:SetAIAimVector( (TargetPos - StartPos):GetNormalized() )
end