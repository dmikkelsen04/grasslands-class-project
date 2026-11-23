-- Optional regeneration: lune run tools/generate-map (Lune 0.10.5).
-- Offline authoring only; all imported scenery keeps its original transforms.
local fs = require("@lune/fs")
local R = require("@lune/roblox")
local root =
	R.deserializeModel(fs.readFile("assets/environment/OriginalSpawnAndGrasslands.rbxm"))[1]
root.Name = "GrasslandsMap"
root:SetAttribute("Issue", 2)
root:SetAttribute("OriginalScale", true)
-- Close the exit to omitted biomes with copies of the original back wall.
-- Its front face is Z=-337, exactly at the original grass floor edge.
local boundary = R.Instance.new("Folder")
boundary.Name = "ClassProjectEndWall"
boundary.Parent = root
for _, d in root.OriginalCliffsAndEntrance:GetChildren() do
	local p = d.CFrame.Position
	if math.abs(p.Z - 116) < 0.01 then
		local wall = d:Clone()
		wall.Name = if p.Y < 20 then "Lower" elseif p.Y < 35 then "Band" else "Cap"
		wall.CFrame = R.CFrame.new(-14.875, p.Y, -347)
		wall.Size = R.Vector3.new(245.25, wall.Size.Y, wall.Size.Z)
		wall.Parent = boundary
	end
end
assert(#boundary:GetChildren() == 3, "Missing original wall templates")
for _, d in root:GetDescendants() do
	assert(not d:IsA("LuaSourceContainer"), "Legacy script in scenery")
	assert(d.Name ~= "SpeedBicycle", "Bike was not removed")
end
fs.writeFile("world/grasslands/GrasslandsMap.rbxm", R.serializeModel({ root }))
print("Original-size spawn and grasslands exported:", #root:GetDescendants(), "instances")
