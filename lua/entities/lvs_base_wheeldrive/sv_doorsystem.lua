DEFINE_BASECLASS( "lvs_base" )

function ENT:Use( ply )
	if istable( self._DoorHandlers ) then
		if ply:KeyDown( IN_SPEED ) then
			return
		else
			local Handler = self:GetDoorHandler( ply )

			if IsValid( Handler ) then
				local Pod = Handler:GetLinkedSeat()

				if IsValid( Pod ) then
					if Handler:IsOpen() then
						Handler:Close( ply )
					else
						Handler:OpenAndClose( ply )
					end

					if not ply:KeyDown( IN_WALK ) and not IsValid( Pod:GetDriver() ) then
						ply:EnterVehicle( Pod )

						return
					end
				end
			end
		end
	end

	BaseClass.Use( self, ply )
end

function ENT:AddDoorHandler( pos, ang, mins, maxs, poseparameter )
	if not isvector( pos ) or not isangle( ang ) or not isvector( mins ) or not isvector( maxs ) or not isstring( poseparameter ) then return end

	local Handler = ents.Create( "lvs_wheeldriver_doorhandler" )

	if not IsValid( Handler ) then
		return
	end

	Handler:SetPos( self:LocalToWorld( pos ) )
	Handler:SetAngles( self:LocalToWorldAngles( ang ) )
	Handler:Spawn()
	Handler:Activate()
	Handler:SetParent( self )
	Handler:SetBase( self )
	Handler:SetMins( mins )
	Handler:SetMaxs( maxs )
	Handler:SetPoseName( poseparameter )

	self:DeleteOnRemove( Handler )

	self:TransferCPPI( Handler )

	if not istable( self._DoorHandlers ) then
		self._DoorHandlers = {}
	end

	table.insert( self._DoorHandlers, Handler )

	return Handler
end

function ENT:GetDoorHandler( ply )
	if not IsValid( ply ) or not istable( self._DoorHandlers ) then return NULL end

	local ShootPos = ply:GetShootPos()
	local AimVector = ply:GetAimVector()

	local radius = 99999999999
	local target = NULL

	for _, doorHandler in pairs( self._DoorHandlers ) do
		if not IsValid( doorHandler ) then continue end

		local boxOrigin = doorHandler:GetPos()
		local boxAngles = doorHandler:GetAngles()
		local boxMins = doorHandler:GetMins()
		local boxMaxs = doorHandler:GetMaxs()

		local HitPos, _, _ = util.IntersectRayWithOBB( ShootPos, AimVector * doorHandler.UseRange, boxOrigin, boxAngles, boxMins, boxMaxs )

		local InRange = isvector( HitPos )

		if not InRange then continue end

		local dist = (ShootPos - HitPos):Length()

		if dist < radius then
			target = doorHandler
			radius = dist
		end
	end

	return target
end