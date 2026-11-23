--!strict
-- Conservative footprint checks keep the whole creature on supported, open ground.
local CreatureSpace = {}
CreatureSpace.__index = CreatureSpace

function CreatureSpace.new(map, settings)
	local ray = RaycastParams.new()
	ray.FilterType = Enum.RaycastFilterType.Include
	ray.FilterDescendantsInstances = { map }
	ray.RespectCanCollide = true
	local overlap = OverlapParams.new()
	overlap.FilterType = Enum.RaycastFilterType.Include
	overlap.FilterDescendantsInstances = { map }
	overlap.RespectCanCollide = true
	overlap.MaxParts = 1
	return setmetatable(
		{ map = map, settings = settings, ray = ray, overlap = overlap },
		CreatureSpace
	)
end

function CreatureSpace:WithinBounds(point, radius)
	local s = self.settings
	return point.X - radius >= s.MinX
		and point.X + radius <= s.MaxX
		and point.Z - radius >= s.MinZ
		and point.Z + radius <= s.MaxZ
end

function CreatureSpace:IsClear(point, radius, height)
	if not self:WithinBounds(point, radius) then
		return false
	end
	local y = self.settings.GroundY
	-- Only the original grass floor is a spawn/walking surface. Pond, roofs,
	-- tree canopies, spawn area, and decorations are not valid ground.
	for _, offset in
		{
			Vector3.zero,
			Vector3.new(radius, 0, radius),
			Vector3.new(-radius, 0, radius),
			Vector3.new(radius, 0, -radius),
			Vector3.new(-radius, 0, -radius),
		}
	do
		local hit = workspace:Raycast(
			Vector3.new(point.X + offset.X, y + 1, point.Z + offset.Z),
			Vector3.new(0, -3, 0),
			self.ray
		)
		if
			not hit
			or hit.Instance.Parent ~= self.map.PondGroundSurround
			or math.abs(hit.Position.Y - y) > 0.1
		then
			return false
		end
	end
	local box = CFrame.new(point.X, y + 0.15 + height / 2, point.Z)
	return #workspace:GetPartBoundsInBox(
		box,
		Vector3.new(radius * 2, height, radius * 2),
		self.overlap
	) == 0
end

function CreatureSpace:SegmentClear(start, finish, radius, height)
	-- Blockcast does not detect initial overlaps; IsClear covers both endpoints.
	if not self:IsClear(start, radius, height) or not self:IsClear(finish, radius, height) then
		return false
	end
	local delta = finish - start
	if delta.Magnitude < 0.001 then
		return true
	end
	local box = CFrame.new(start.X, self.settings.GroundY + 0.15 + height / 2, start.Z)
	if workspace:Blockcast(box, Vector3.new(radius * 2, height, radius * 2), delta, self.ray) then
		return false
	end
	-- Support must be continuous, including across the recessed pond cutout.
	local steps = math.ceil(delta.Magnitude)
	for i = 1, steps - 1 do
		if not self:IsClear(start:Lerp(finish, i / steps), radius, height) then
			return false
		end
	end
	return true
end

return CreatureSpace
