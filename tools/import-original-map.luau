-- Optional one-time extraction: lune run tools/import-original-map path/to/source.rbxl
local fs = require("@lune/fs")
local R = require("@lune/roblox")
local process = require("@lune/process")
local source =
	R.deserializePlace(fs.readFile(assert(process.args[1], "Supply original place snapshot")))
local map = source.Workspace.Map
local root = R.Instance.new("Model")
root.Name = "OriginalSpawnAndGrasslands"
local function copy(instance, parent)
	local clone = instance:Clone()
	clone.Parent = parent or root
	return clone
end
for _, name in { "MapSpawn1", "SpawnLocation", "Plots", "MunchBallShowcase" } do
	copy(map[name])
end
copy(map.Levels["Level 1 - Grasslands"].PondGroundSurround)
copy(map.BiomeMakeover_v56.GrasslandsFarm)
copy(map.EncounterGrassPatches.Grasslands).Name = "EncounterGrassPatches"
copy(map.CreatureDens.Grasslands).Name = "CreatureDens"
-- Level 1 also contains distant biome decorations. Preserve complete local models.
local function center(instance)
	local low = R.Vector3.new(math.huge, math.huge, math.huge)
	local high = R.Vector3.new(-math.huge, -math.huge, -math.huge)
	local found = false
	local descendants = instance:GetDescendants()
	table.insert(descendants, instance)
	for _, d in descendants do
		if d:IsA("BasePart") then
			found = true
			local p = d.CFrame.Position
			low = R.Vector3.new(math.min(low.X, p.X), math.min(low.Y, p.Y), math.min(low.Z, p.Z))
			high =
				R.Vector3.new(math.max(high.X, p.X), math.max(high.Y, p.Y), math.max(high.Z, p.Z))
		end
	end
	return if found then (low + high) / 2 else nil
end
local function inArea(p)
	if not p or p.Z < -337 or p.Z > 140 then
		return false
	end
	if p.Z < -100 then
		return p.X >= -145 and p.X <= 120
	end
	return p.X >= -215 and p.X <= 185
end
local function decorations(from, into)
	for _, d in from:GetChildren() do
		if d:IsA("Folder") then
			local folder = R.Instance.new("Folder")
			folder.Name = d.Name
			folder.Parent = into
			decorations(d, folder)
		elseif inArea(center(d)) then
			copy(d, into)
		end
	end
end
local decor = R.Instance.new("Folder")
decor.Name = "Decorations"
decor.Parent = root
decorations(map.Levels["Level 1 - Grasslands"].Decorations, decor)
local loose = R.Instance.new("Folder")
loose.Name = "OriginalCliffsAndEntrance"
loose.Parent = root
local wallCount = 0
for _, d in source.Workspace:GetChildren() do
	if d.ClassName == "Part" and inArea(d.CFrame.Position) then
		local c = copy(d, loose)
		wallCount += 1
		c.Name = "OriginalPart_" .. wallCount
		if math.abs(d.CFrame.Position.Z + 81.25) < 0.01 and d.Size.X > 200 then
			c.Name = "SafeZoneStripe"
		end
	end
end
local removedBikes = 0
local descendants = root:GetDescendants()
for i = #descendants, 1, -1 do
	local d = descendants[i]
	if d.Name == "SpeedBicycle" then
		d:Destroy()
		removedBikes += 1
	end
end
descendants = root:GetDescendants()
for i = #descendants, 1, -1 do
	local d = descendants[i]
	if
		d:IsA("LuaSourceContainer")
		or d:IsA("ProximityPrompt")
		or d:IsA("ClickDetector")
		or d:IsA("RemoteEvent")
		or d:IsA("RemoteFunction")
	then
		d:Destroy()
	elseif d:IsA("BasePart") then
		d.Anchored = true
	end
end
root.SpawnLocation.Enabled = true
root.SpawnLocation.Neutral = true
fs.writeFile("assets/environment/OriginalSpawnAndGrasslands.rbxm", R.serializeModel({ root }))
print("Copied original scenery at unchanged transforms; bikes removed:", removedBikes)
