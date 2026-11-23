-- Test-only overlay; reports from two real simulated clients.
local remote = game.ReplicatedStorage:WaitForChild("CreatureTestReport")
local first, changed, tracked = {}, {}, {}
local removals = 0
while task.wait(0.5) do
	local folder = workspace:FindFirstChild("Creatures")
	for model in tracked do
		if model.Parent ~= folder then
			tracked[model] = nil
			removals += 1
		end
	end
	local ready = 0
	if folder then
		for _, model in folder:GetChildren() do
			tracked[model] = true
			if model:GetAttribute("AnimationReady") then
				ready += 1
			end
			for _, d in model:GetDescendants() do
				if d:IsA("Motor6D") then
					local key = model.Name .. "/" .. d.Name
					if first[key] then
						local relative = first[key]:Inverse() * d.Transform
						local _, angle = relative:ToAxisAngle()
						if relative.Position.Magnitude > 0.001 or math.abs(angle) > 0.001 then
							changed[model.Name] = true
						end
					else
						first[key] = d.Transform
					end
				end
			end
		end
	end
	local count = 0
	for _ in changed do
		count += 1
	end
	remote:FireServer({ ready = ready, changed = count, removals = removals })
end
