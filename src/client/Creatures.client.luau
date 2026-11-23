--!strict
local RunService = game:GetService("RunService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Animation = require(script.Parent.CreatureAnimation)
local sources = ReplicatedStorage:WaitForChild("CreatureAnimationData")
local controllers = {}
local failed = {}

-- One connection per client, not one per creature; removal releases joint refs.
RunService.PreSimulation:Connect(function()
	local folder = workspace:FindFirstChild("Creatures")
	for model, controller in controllers do
		if model.Parent ~= folder or not folder then
			controller:Destroy()
			controllers[model] = nil
		end
	end
	for model in failed do
		if model.Parent ~= folder then
			failed[model] = nil
		end
	end
	if not folder then
		return
	end
	local now = workspace:GetServerTimeNow()
	for _, model in folder:GetChildren() do
		if
			model:IsA("Model")
			and model.PrimaryPart
			and not controllers[model]
			and not failed[model]
		then
			local source = sources:FindFirstChild(model:GetAttribute("SpeciesId") or "")
			local count = 0
			for _, d in model:GetDescendants() do
				if d:IsA("Motor6D") and d.Part0 and d.Part1 then
					count += 1
				end
			end
			if
				source
				and count == model:GetAttribute("RigJointCount")
				and source:FindFirstChild("Idle")
				and source:FindFirstChild("Walk")
			then
				local ok, result = pcall(Animation.new, model, source)
				if ok then
					controllers[model] = result
					model:SetAttribute("AnimationReady", true) -- local diagnostic only
				else
					failed[model] = true
					warn("Creature animation failed: " .. model.Name .. ": " .. tostring(result))
				end
			end
		end
		if controllers[model] then
			controllers[model]:Step(now)
		end
	end
end)
