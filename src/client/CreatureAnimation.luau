--!strict
-- New playback code for reused numeric pose data; no legacy scripts or uploaded
-- animation permissions are needed. Motor6D.Transform is applied on each client.
local HttpService = game:GetService("HttpService")
local TweenService = game:GetService("TweenService")
local Animation = {}
Animation.__index = Animation
local cache = {}
local styles = {
	[2] = Enum.EasingStyle.Elastic,
	[3] = Enum.EasingStyle.Cubic,
	[4] = Enum.EasingStyle.Bounce,
	[5] = Enum.EasingStyle.Cubic,
}
local directions = {
	[0] = Enum.EasingDirection.In,
	[1] = Enum.EasingDirection.Out,
	[2] = Enum.EasingDirection.InOut,
}

local function loadClip(value)
	if cache[value] then
		return cache[value]
	end
	local data = HttpService:JSONDecode(value.Value)
	assert(data.duration > 0 and #data.frames > 1, "Empty animation: " .. value:GetFullName())
	for _, frame in data.frames do
		for _, pose in frame[2] do
			pose[1] = CFrame.new(table.unpack(pose[1]))
		end
	end
	cache[value] = data
	return data
end

local function framesAt(clip, time)
	time %= clip.duration
	local frames = clip.frames
	local low, high = 1, #frames
	while low < high do
		local middle = math.ceil((low + high) / 2)
		if frames[middle][1] <= time then
			low = middle
		else
			high = middle - 1
		end
	end
	local a, b = frames[low], frames[math.min(low + 1, #frames)]
	local span = b[1] - a[1]
	return a[2], b[2], if span > 0 then (time - a[1]) / span else 0
end

function Animation.new(model, source)
	local self = setmetatable({
		model = model,
		joints = {},
		clips = {},
		state = nil,
		start = nil,
		last = {},
		blend = {},
		blendStart = 0,
	}, Animation)
	for _, d in model:GetDescendants() do
		if d:IsA("Motor6D") and d.Part0 and d.Part1 then
			self.joints[d.Part0.Name .. "/" .. d.Part1.Name] = d
		end
	end
	for _, state in { "Idle", "Walk" } do
		self.clips[state] = loadClip(source[state])
		for name in self.joints do
			assert(self.clips[state].frames[1][2][name], "Missing pose for joint " .. name)
		end
	end
	return self
end

function Animation:Step(now)
	local state = self.model:GetAttribute("MotionState")
	local start = self.model:GetAttribute("StateStartedAt")
	if not self.clips[state] or type(start) ~= "number" then
		return
	end
	if state ~= self.state or start ~= self.start then
		self.blend = table.clone(self.last)
		self.blendStart = now
		self.state, self.start = state, start
	end
	local a, b, alpha = framesAt(self.clips[state], math.max(0, now - start))
	local fade = math.clamp((now - self.blendStart) / 0.18, 0, 1)
	for name, motor in self.joints do
		local first, second = a[name], b[name]
		local eased = alpha
		if first[3] == 1 then
			eased = 0
		elseif styles[first[3]] then
			eased = TweenService:GetValue(alpha, styles[first[3]], directions[first[4]])
		end
		local weight = first[2] + (second[2] - first[2]) * eased
		local pose = CFrame.identity:Lerp(first[1]:Lerp(second[1], eased), weight)
		pose = (self.blend[name] or pose):Lerp(pose, fade)
		motor.Transform = pose
		self.last[name] = pose
	end
end

function Animation:Destroy()
	for _, motor in self.joints do
		if motor.Parent then
			motor.Transform = CFrame.identity
		end
	end
	table.clear(self.joints)
	table.clear(self.last)
	table.clear(self.blend)
end

return Animation
