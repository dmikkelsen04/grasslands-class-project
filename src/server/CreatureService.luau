--!strict
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local ServerStorage = game:GetService("ServerStorage")
local RunService = game:GetService("RunService")
local Catalog = require(ReplicatedStorage.Shared.CreatureCatalog)
local Settings = require(script.Parent.CreatureSettings)
local CreatureSpace = require(script.Parent.CreatureSpace)
local Service = { slots = {}, connection = nil, folder = nil }
local random = Random.new()

local function flatDistance(a, b)
	return Vector3.new(a.X - b.X, 0, a.Z - b.Z).Magnitude
end

function Service:_separated(point, radius, ignore)
	for _, slot in self.slots do
		if slot ~= ignore and slot.model and slot.model.Parent == self.folder then
			if flatDistance(point, slot.position) < radius + slot.radius then
				return false
			end
		end
	end
	return true
end

function Service:_choosePoint(slot, spawning)
	for attempt = 1, if spawning then Settings.SpawnAttempts else Settings.TargetAttempts do
		local angle = random:NextNumber(0, math.pi * 2)
		local distance = if spawning and attempt == 1
			then 0
			else math.sqrt(random:NextNumber()) * Settings.RoamRadius
		local point = slot.entry.Home
			+ Vector3.new(math.cos(angle) * distance, 0, math.sin(angle) * distance)
		if
			self:_separated(point, slot.radius, slot)
			and self.space:IsClear(point, slot.radius, slot.height)
		then
			if
				spawning or self.space:SegmentClear(slot.position, point, slot.radius, slot.height)
			then
				return point
			end
		end
	end
	return nil
end

function Service:_idle(slot, now)
	slot.target = nil
	slot.nextAction = now + random:NextNumber(Settings.IdleMin, Settings.IdleMax)
	slot.model:SetAttribute("MotionState", "Idle")
	slot.model:SetAttribute("StateStartedAt", now)
end

function Service:_spawn(slot, now)
	if #self:GetCreatures() >= Settings.PopulationLimit then
		return
	end
	local point = self:_choosePoint(slot, true)
	if not point then
		slot.nextAction = now + Settings.RespawnSeconds
		return
	end
	local model = slot.template:Clone()
	model.Name = slot.entry.Id
	model:SetAttribute("SpeciesId", slot.entry.Id)
	model:SetAttribute("DisplayName", slot.entry.DisplayName)
	model:SetAttribute("CreatureId", slot.entry.Id .. "-" .. tostring(self.generation))
	self.generation += 1
	model:SetAttribute("WalkSpeed", Settings.WalkSpeed)
	model:SetAttribute("AnimationReady", false)
	model:PivotTo(CFrame.new(point + Vector3.new(0, slot.groundOffset, 0)))
	slot.position = point
	slot.model = model
	self:_idle(slot, now)
	model.Parent = self.folder
end

function Service:_step(dt)
	local now = workspace:GetServerTimeNow()
	for _, slot in self.slots do
		if slot.model and slot.model.Parent ~= self.folder then
			slot.model:Destroy()
			slot.model = nil
			slot.target = nil
			slot.nextAction = now + Settings.RespawnSeconds
		end
		if not slot.model then
			if now >= slot.nextAction then
				self:_spawn(slot, now)
			end
		elseif slot.target then
			local delta = slot.target - slot.position
			if delta.Magnitude < 0.1 then
				self:_idle(slot, now)
			else
				local point = slot.position
					+ delta.Unit * math.min(delta.Magnitude, Settings.WalkSpeed * dt)
				if
					self:_separated(point, slot.radius, slot)
					and self.space:SegmentClear(slot.position, point, slot.radius, slot.height)
				then
					slot.position = point
					local position = point + Vector3.new(0, slot.groundOffset, 0)
					-- Only the anchored rig root is replicated; clients pose the joints.
					slot.model.PrimaryPart.CFrame = CFrame.lookAt(position, position + delta.Unit)
				else
					self:_idle(slot, now)
				end
			end
		elseif now >= slot.nextAction then
			local point = self:_choosePoint(slot, false)
			if point and flatDistance(point, slot.position) >= 2 then
				slot.target = point
				slot.model:SetAttribute("MotionState", "Walk")
				slot.model:SetAttribute("StateStartedAt", now)
			else
				self:_idle(slot, now)
			end
		end
	end
end

function Service:GetCreatures()
	local models = {}
	for _, slot in self.slots do
		if slot.model and slot.model.Parent == self.folder then
			table.insert(models, slot.model)
		end
	end
	return models
end

-- Server-only hook for the later catch feature. No client remote can despawn.
function Service:Despawn(model)
	for _, slot in self.slots do
		if slot.model == model and model.Parent == self.folder then
			model:Destroy()
			return true
		end
	end
	return false
end

function Service:Start()
	if self.connection then
		return
	end
	assert(
		not workspace:FindFirstChild("Creatures"),
		"Creature folder already owned by another service"
	)
	self.folder = Instance.new("Folder")
	self.folder.Name = "Creatures"
	self.folder.Parent = workspace
	self.space = CreatureSpace.new(workspace.Grasslands.GrasslandsMap, Settings)
	self.slots = {}
	self.generation = 1
	for _, entry in Catalog.Species do
		local template = ServerStorage.CreatureAssets:FindFirstChild(entry.Id)
		assert(
			template and template:IsA("Model") and template.PrimaryPart,
			"Missing rig: " .. entry.Id
		)
		table.insert(self.slots, {
			entry = entry,
			template = template,
			model = nil,
			nextAction = 0,
			radius = math.max(
				template:GetAttribute("ImportWidth"),
				template:GetAttribute("ImportDepth")
			) / 2 + Settings.Clearance,
			height = template:GetAttribute("ImportHeight") + Settings.Clearance,
			groundOffset = template:GetAttribute("ImportGroundOffset"),
		})
	end
	self:_step(0)
	local elapsed = 0
	self.connection = RunService.Heartbeat:Connect(function(dt)
		elapsed += dt
		if elapsed >= Settings.StepInterval then
			self:_step(math.min(elapsed, 0.25))
			elapsed = 0
		end
	end)
end

function Service:Stop()
	if self.connection then
		self.connection:Disconnect()
		self.connection = nil
	end
	if self.folder then
		self.folder:Destroy()
		self.folder = nil
	end
	self.slots = {}
end

return Service
