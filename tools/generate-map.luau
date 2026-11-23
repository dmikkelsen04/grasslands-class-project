-- Run from the repository root with Lune 0.10.5: lune run tools/generate-map
-- This is an offline authoring tool. No map-generation code runs in the game.
local fs = require("@lune/fs")
local R = require("@lune/roblox")
local V, C, Color, E = R.Vector3, R.CFrame, R.Color3, R.Enum

local root = R.Instance.new("Model")
root.Name = "GrasslandsMap"
root:SetAttribute("Issue", 2)
root:SetAttribute("GrasslandsWidth", 480)
root:SetAttribute("GrasslandsDepth", 500)
local function group(name)
	local model = R.Instance.new("Model")
	model.Name = name
	model.Parent = root
	return model
end
local ground, paths, cliffs = group("Ground"), group("Paths"), group("BoundaryCliffs")
local scenery, plants = group("Scenery"), group("MeadowPlants")
local clearings, barriers = group("CreatureAreas"), group("BoundaryColliders")
local function part(parent, name, size, position, color, material)
	local p = R.Instance.new("Part")
	p.Name = name
	p.Size = V.new(table.unpack(size))
	p.CFrame = C.new(table.unpack(position))
	p.Color = Color.fromRGB(table.unpack(color))
	p.Material = material or E.Material.SmoothPlastic
	p.Anchored = true
	p.TopSurface = E.SurfaceType.Smooth
	p.BottomSurface = E.SurfaceType.Smooth
	p.Parent = parent
	return p
end

-- Continuous collision foundations; reuse the source's checker texture at its original scale.
local meadowFloor = part(
	ground,
	"GrasslandsFoundation",
	{ 480, 6, 500 },
	{ -15, -2, -325 },
	{ 128, 193, 51 }
)
local spawnFloor = part(
	ground,
	"SpawnFoundation",
	{ 480, 6, 210 },
	{ -15, -2, 30 },
	{ 133, 214, 34 }
)
for _, floor in { meadowFloor, spawnFloor } do
	local texture = R.Instance.new("Texture")
	texture.Name = "ReusedCheckerTexture"
	texture.Texture = "rbxassetid://4806196507"
	texture.StudsPerTileU = 10
	texture.StudsPerTileV = 10
	texture.Face = E.NormalId.Top
	texture.Parent = floor
end

local function bounds(m)
	local lo, hi = V.new(math.huge, math.huge, math.huge), V.new(-math.huge, -math.huge, -math.huge)
	for _, d in m:GetDescendants() do
		if d:IsA("BasePart") then
			for _, x in { -1, 1 } do
				for _, y in { -1, 1 } do
					for _, z in { -1, 1 } do
						local p = d.CFrame
							* V.new(d.Size.X * x / 2, d.Size.Y * y / 2, d.Size.Z * z / 2)
						lo = V.new(math.min(lo.X, p.X), math.min(lo.Y, p.Y), math.min(lo.Z, p.Z))
						hi = V.new(math.max(hi.X, p.X), math.max(hi.Y, p.Y), math.max(hi.Z, p.Z))
					end
				end
			end
		end
	end
	return lo, hi
end
local templates = {}
local function asset(name, x, z, scale, angle, baseY)
	if not templates[name] then
		templates[name] =
			R.deserializeModel(fs.readFile("assets/environment/" .. name .. ".rbxmx"))[1]
	end
	local m = templates[name]:Clone()
	local lo, hi = bounds(m)
	local origin = V.new((lo.X + hi.X) / 2, lo.Y, (lo.Z + hi.Z) / 2)
	local rotation = C.Angles(0, math.rad(angle or 0), 0)
	local placement = C.new(x, baseY or 1.08, z) * rotation
	for _, d in m:GetDescendants() do
		if d:IsA("BasePart") then
			local relative = d.CFrame - origin
			d.CFrame = placement * (relative + relative.Position * ((scale or 1) - 1))
			d.Size *= scale or 1
			d.Anchored = true
		elseif
			d:IsA("LuaSourceContainer")
			or d:IsA("ProximityPrompt")
			or d:IsA("ClickDetector")
		then
			error("Executable/interactive content in visual asset " .. name)
		end
	end
	m.Parent = scenery
	return m
end

-- Preserve the player's existing spawn and five plot shells as disclosed reused scenery.
local spawn = R.deserializeModel(fs.readFile("assets/environment/SpawnScenery.rbxmx"))[1]
spawn.Parent = root
local spawnPoint = spawn:FindFirstChild("SpawnLocation")
spawnPoint.CFrame = C.new(-15, 1.5, -35)
spawnPoint.Transparency = 1
spawnPoint.Neutral = true
spawnPoint.Enabled = true
spawnPoint.Duration = 0
for _, d in spawnPoint:GetChildren() do
	d:Destroy()
end

local function trail(name, a, b, width)
	local midpoint = (V.new(a[1], 1.14, a[2]) + V.new(b[1], 1.14, b[2])) / 2
	local endPoint = V.new(b[1], 1.14, b[2])
	local p = part(
		paths,
		name,
		{ width, 0.12, (endPoint - midpoint).Magnitude * 2 + width / 2 },
		{ 0, 0, 0 },
		{ 203, 184, 125 },
		E.Material.Sand
	)
	p.CFrame = C.lookAt(midpoint, endPoint)
	p.CanCollide = false
end
trail("MainTrail", { -15, -65 }, { -15, -525 }, 15)
trail("SouthLoop", { -185, -205 }, { 165, -205 }, 12)
trail("WestLoop", { -185, -205 }, { -185, -480 }, 12)
trail("NorthLoop", { -185, -480 }, { 165, -480 }, 12)
trail("EastLoop", { 165, -205 }, { 165, -480 }, 12)
trail("PondApproach", { -15, -310 }, { -125, -310 }, 10)
trail("BarnApproach", { -15, -405 }, { 135, -405 }, 10)

-- Solid perimeter walls are deliberately taller than the standard character's jump.
local function wall(name, size, position)
	local p = part(barriers, name, size, position, { 100, 85, 68 })
	p.Transparency = 1
	p.CastShadow = false
end
wall("West", { 12, 180, 750 }, { -261, 80, -220 })
wall("East", { 12, 180, 750 }, { 231, 80, -220 })
wall("North", { 516, 180, 12 }, { -15, 80, -581 })
wall("South", { 516, 180, 12 }, { -15, 80, 141 })

local function cliff(x, z, sx, sz, i, small)
	local height = small and (22 + i % 3 * 3) or (43 + i % 5 * 5)
	part(
		cliffs,
		"EarthFace",
		{ sx, height, sz },
		{ x, height / 2 - 5, z },
		{ 143 + i % 3 * 5, 91, 59 },
		E.Material.Slate
	)
	part(cliffs, "EarthBand", { sx + 1, 6, sz + 1 }, { x, height - 13, z }, { 171, 117, 72 })
	local cap = part(
		cliffs,
		"GrassCap",
		{ sx + 3, 3, sz + 3 },
		{ x, height - 3.5, z },
		{ 110, 174, 51 }
	)
	cap.TopSurface = E.SurfaceType.Studs
	if i % 3 == 0 then
		asset("WoodlandOak", x, z, 0.8 + (i % 4) * 0.12, i * 47, height - 2)
	end
end
for i = 0, 23 do
	cliff(-275 - i % 3 * 3, -565 + i * 30, 42, 32, i, i > 17)
	cliff(245 + i % 3 * 3, -565 + i * 30, 42, 32, i + 1, i > 17)
end
for i = 0, 16 do
	cliff(-255 + i * 30, -593 - i % 2 * 4, 32, 40, i + 3, false)
	cliff(-255 + i * 30, 155 + i % 2 * 4, 32, 38, i + 2, true)
end

asset("CloverBarn", 120, -420, 1.25, 180)
asset("LittleCornfield", 165, -370, 1.1, 0)
asset("FarmCrates", 95, -397, 1.4, 20)
asset("FarmCrates", 102, -397, 1.0, -10)

local pond = group("CloverPond")
for _, strip in { { 0, 0, 52, 48 }, { -30, 0, 8, 34 }, { 30, 0, 8, 34 }, { 0, -26, 30, 4 } } do
	local x, z = -132 + strip[1], -290 + strip[2]
	part(
		pond,
		"StoneShore",
		{ strip[3] + 7, 0.22, strip[4] + 7 },
		{ x, 1.11, z },
		{ 172, 174, 135 }
	)
	part(
		pond,
		"ShallowWater",
		{ strip[3], 0.1, strip[4] },
		{ x, 1.29, z },
		{ 76, 186, 203 },
		E.Material.Glass
	).Transparency =
		0.12
end
for i = 0, 9 do
	part(
		pond,
		"BoardwalkPlank",
		{ 2.7, 0.4, 8 },
		{ -156 + i * 2.9, 1.5, -265 },
		{ 156, 111, 65 },
		E.Material.Wood
	)
end
for i = 0, 11 do
	local a = i * math.pi / 6
	local rock = part(
		pond,
		"ShoreStone",
		{ 4 + i % 3, 1.7, 3 },
		{ -132 + math.cos(a) * 38, 1.8, -290 + math.sin(a) * 25 },
		{ 150, 160, 129 },
		E.Material.Rock
	)
	rock.CFrame *= C.Angles(0, a, 0)
end

-- Keep named clearings open for the separate creature-spawning issue.
for _, area in
	{
		{ "SunMeadow", 115, -140, 90, 60 },
		{ "PondMeadow", -100, -370, 90, 65 },
		{ "NorthMeadow", 75, -530, 110, 50 },
	}
do
	local marker = part(
		clearings,
		area[1],
		{ area[4], 0.1, area[5] },
		{ area[2], 1.05, area[3] },
		{ 110, 190, 65 }
	)
	marker.Transparency = 1
	marker.CanCollide = false
	marker.CanTouch = false
	marker.CanQuery = false
	marker:SetAttribute("Purpose", "Future creature spawn area; no spawning implemented")
end

local treePositions = {
	{ -210, -115 },
	{ -172, -152 },
	{ -110, -125 },
	{ -75, -185 },
	{ 190, -113 },
	{ 200, -175 },
	{ 63, -175 },
	{ 208, -245 },
	{ -222, -235 },
	{ -212, -310 },
	{ -220, -385 },
	{ -200, -435 },
	{ -135, -475 },
	{ -105, -510 },
	{ -165, -530 },
	{ -220, -520 },
	{ -60, -450 },
	{ -60, -540 },
	{ 195, -535 },
	{ 210, -465 },
	{ 65, -255 },
	{ 115, -285 },
	{ 205, -305 },
	{ 30, -355 },
}
for i, pos in treePositions do
	asset("WoodlandOak", pos[1], pos[2], 0.85 + (i % 5) * 0.18, i * 59)
end

local function flower(x, z, i)
	local stem = part(plants, "FlowerStem", { 0.35, 1.6, 0.35 }, { x, 1.8, z }, { 55, 119, 50 })
	stem.CanCollide = false
	local colors = { { 248, 218, 104 }, { 245, 241, 211 }, { 190, 153, 229 } }
	local bloom = part(plants, "Wildflower", { 1.8, 0.5, 1.8 }, { x, 2.7, z }, colors[i % 3 + 1])
	bloom.CanCollide = false
end
for i = 1, 170 do
	local x = -230 + ((i * 73) % 445)
	local z = -550 + ((i * 113) % 450)
	-- Leave the center path, loop trails, pond, and farm approaches unobstructed.
	local clear = math.abs(x + 15) > 20 and math.abs(x + 185) > 12 and math.abs(x - 165) > 12
	clear = clear and math.abs(z + 205) > 12 and math.abs(z + 480) > 12
	clear = clear and not (x < -80 and x > -180 and z < -250 and z > -325)
	if clear then
		flower(x, z, i)
		local grass = part(
			plants,
			"GrassTuft",
			{ 0.55, 2.1 + i % 3 * 0.4, 2.5 },
			{ x + 2, 2.1, z + 1 },
			{ 86, 153, 49 }
		)
		grass.CanCollide = false
		grass.CFrame *= C.Angles(0, math.rad(i * 37), math.rad(13))
	end
end

-- Decorative non-colliding grass islands make the meadows readable without blocking future creatures.
for patchIndex, center in
	{
		{ 95, -135 },
		{ -120, -165 },
		{ 90, -290 },
		{ -105, -370 },
		{ 65, -535 },
		{ -150, -520 },
		{ 195, -425 },
	}
do
	for row = 0, 7 do
		for column = 0, 7 do
			local x = center[1] + (column - 3.5) * 3.7 + math.sin(row * 7 + column) * 0.8
			local z = center[2] + (row - 3.5) * 3.7
			if (row - 3.5) ^ 2 + (column - 3.5) ^ 2 < 21 then
				for blade = 0, 1 do
					local p = part(
						plants,
						"MeadowGrass",
						{ 0.28, 2.6 + (row + column) % 3 * 0.3, 1.7 },
						{ x + blade * 0.8, 2.35, z },
						{ 71 + patchIndex * 3, 143 + column * 2, 42 }
					)
					p.CFrame *= C.Angles(
						0,
						math.rad(column * 41 + blade * 90),
						math.rad(blade == 0 and 12 or -12)
					)
					p.CanCollide = false
					p.CanTouch = false
				end
			end
		end
	end
end

-- Low fence flanks the entrance without closing the walking route.
local fence = group("SpawnEntrance")
for _, interval in { { -210, -40 }, { 10, 180 } } do
	for x = interval[1], interval[2], 10 do
		part(fence, "Post", { 1.2, 5, 1.2 }, { x, 3.5, -77 }, { 225, 211, 168 }, E.Material.Wood)
	end
	for _, y in { 2.6, 4.3 } do
		part(
			fence,
			"Rail",
			{ interval[2] - interval[1], 0.6, 0.8 },
			{ (interval[1] + interval[2]) / 2, y, -77 },
			{ 231, 219, 180 },
			E.Material.Wood
		)
	end
end
local sign = part(
	fence,
	"WelcomeSign",
	{ 27, 7, 1.2 },
	{ -56, 7, -69 },
	{ 76, 102, 57 },
	E.Material.Wood
)
local gui = R.Instance.new("SurfaceGui")
gui.Face = E.NormalId.Back
gui.CanvasSize = R.Vector2.new(810, 210)
gui.Parent = sign
local label = R.Instance.new("TextLabel")
label.Size = R.UDim2.fromScale(1, 1)
label.BackgroundTransparency = 1
label.Text = "GRASSLANDS"
label.TextColor3 = Color.fromRGB(255, 245, 200)
label.TextScaled = true
label.Font = E.Font.GothamBold
label.Parent = gui

fs.writeFile("world/grasslands/GrasslandsMap.rbxmx", R.serializeModel({ root }, true))
print("Generated spawn plus 480 x 500 grasslands; instances:", #root:GetDescendants())
