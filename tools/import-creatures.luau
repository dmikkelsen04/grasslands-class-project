-- One-time asset extraction with Lune 0.10.5; run from the repository root.
-- Usage: lune run tools/import-creatures path/to/owner-provided-snapshot.rbxl
-- Only geometry, rig joints, and numeric Idle/Walk animation data are reused.
local fs = require("@lune/fs")
local R = require("@lune/roblox")
local serde = require("@lune/serde")
local process = require("@lune/process")
local source = R.deserializePlace(fs.readFile(assert(process.args[1], "Supply source snapshot")))
local ids = {
	"Chicken",
	"WaddleDuck",
	"GrumpyBison",
	"MoodyCow",
	"BouncyPig",
	"WoolballSheep",
	"Scarecrow",
	"CornfedColossus",
}
local roster = serde.decode(
	"json",
	source.ReplicatedStorage.Grasslands.CreatureRoster.Source:match("%[==%[(.*)%]==%]")
)
local report = {}
fs.writeDir("assets/creatures")
fs.writeDir("assets/animations")

local function decodeBase64(encoded)
	local alphabet = "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789+/"
	local values = {}
	for i = 1, #alphabet do
		values[alphabet:byte(i)] = i - 1
	end
	local output = {}
	for i = 1, #encoded, 4 do
		local a, b, c, d = encoded:byte(i, i + 3)
		local number = values[a] * 262144
			+ values[b] * 4096
			+ (values[c] or 0) * 64
			+ (values[d] or 0)
		table.insert(output, string.char(math.floor(number / 65536)))
		if c ~= 61 then
			table.insert(output, string.char(math.floor(number / 256) % 256))
		end
		if d ~= 61 then
			table.insert(output, string.char(number % 256))
		end
	end
	return table.concat(output)
end

local function unpackClip(ref)
	local packed =
		source.ReplicatedStorage.CompactAnimations.Data[ref:GetAttribute("PackedAnimationId")]
	local chunks = packed:GetChildren()
	table.sort(chunks, function(a, b)
		return a.Name < b.Name
	end)
	local strings = {}
	for _, chunk in chunks do
		table.insert(strings, chunk.Value)
	end
	local raw =
		decodeBase64(if packed:IsA("StringValue") then packed.Value else table.concat(strings))
	assert(raw:sub(1, 4) == "KFS1", "Unexpected source animation format")
	local at = 5
	local function read(format)
		local values = table.pack(string.unpack("<" .. format, raw, at))
		at = values[values.n]
		return table.unpack(values, 1, values.n - 1)
	end
	local frames = {}
	for _ = 1, read("I4") do
		read("s4") -- Keyframe label; no gameplay markers are imported.
		local time, _, count = read("fBI4")
		local names, poses = {}, {}
		for index = 1, count do
			local kind, parent = read("BI4B")
			local name = read("s4")
			names[index] = name
			if kind == 3 then
				read("d")
			elseif kind == 2 then
				read("s4")
			else
				local weight, style, direction = read("fBB")
				if kind == 0 then
					local components = { read("ffffffffffff") }
					if parent ~= 0 then
						poses[names[parent] .. "/" .. name] =
							{ components, weight, style, direction }
					else
						local frame = R.CFrame.new(table.unpack(components))
						assert(
							frame.Position.Magnitude < 0.001
								and frame.LookVector:Dot(R.Vector3.new(0, 0, -1)) > 0.999,
							"Root motion requires explicit conversion"
						)
					end
				else
					read("f")
				end
			end
		end
		table.insert(frames, { time, poses })
	end
	assert(at == #raw + 1 and #frames > 1, "Invalid animation data")
	return { duration = frames[#frames][1], frames = frames }
end

for _, id in ids do
	local original = source.ServerStorage.CreatureTemplates[id]
	local model = original:Clone()
	local root = assert(model.PrimaryPart, "Missing primary part")
	local origin = root.CFrame:Inverse()
	local descendants = model:GetDescendants()
	for i = #descendants, 1, -1 do
		local d = descendants[i]
		if
			d:IsA("LuaSourceContainer")
			or d:IsA("ProximityPrompt")
			or d:IsA("ClickDetector")
			or d:IsA("Humanoid")
			or d:IsA("AnimationController")
			or d:IsA("Animator")
		then
			d:Destroy()
		elseif d:IsA("BasePart") then
			d.CFrame = origin * d.CFrame
			d.Anchored = d == root
			d.CanCollide = false
			d.CanTouch = false
			d.Massless = d ~= root
		elseif d:IsA("Motor6D") then
			d.Transform = R.CFrame.identity
		end
	end
	model:SetAttribute("SpeciesId", id)
	local jointCount = 0
	for _, d in model:GetDescendants() do
		if d:IsA("Motor6D") then
			jointCount += 1
		end
	end
	model:SetAttribute("RigJointCount", jointCount)
	fs.writeFile("assets/creatures/" .. id .. ".rbxm", R.serializeModel({ model }))
	local animations = R.Instance.new("Folder")
	animations.Name = id
	local clips = {}
	for _, state in { "Idle", "Walk" } do
		local ref = source.ReplicatedStorage.Grasslands.AnimationSets[id][state]
		local clip = unpackClip(ref)
		local value = R.Instance.new("StringValue")
		value.Name = state
		value.Value = serde.encode("json", clip)
		value:SetAttribute("SourceClipId", ref:GetAttribute("PackedAnimationId"))
		value.Parent = animations
		clips[state] = {
			sourceClipId = ref:GetAttribute("PackedAnimationId"),
			frames = #clip.frames,
			duration = clip.duration,
		}
	end
	fs.writeFile("assets/animations/" .. id .. ".rbxm", R.serializeModel({ animations }))
	local config = roster.Species[id]
	table.insert(report, {
		id = id,
		displayName = config.DisplayName,
		rarity = config.Rarity,
		groundOffset = original:GetAttribute("ImportGroundOffset"),
		width = original:GetAttribute("ImportWidth"),
		depth = original:GetAttribute("ImportDepth"),
		height = original:GetAttribute("ImportHeight"),
		clips = clips,
	})
	print("Imported", id, #model:GetDescendants(), "rig instances")
end
fs.writeFile("assets/creature-import.json", serde.encode("json", report, true))
