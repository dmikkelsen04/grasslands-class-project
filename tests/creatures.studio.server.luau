-- Test-only overlay; not mapped into the shipped project.
local Players = game:GetService("Players")
local Test = game:GetService("StudioTestService")
local HttpService = game:GetService("HttpService")
local Service = require(game.ServerScriptService.Server.CreatureService)
local reports = {}
local observations = {}
game.ReplicatedStorage.CreatureTestReport.OnServerEvent:Connect(function(player, report)
	reports[player.UserId] = report
end)

local ok, result = pcall(function()
	local deadline = os.clock() + 40
	while #Players:GetPlayers() < 2 and os.clock() < deadline do
		task.wait(0.25)
	end
	assert(#Players:GetPlayers() == 2, "Two clients did not join")
	assert(#Service:GetCreatures() == 8, "Initial population must be eight, not eight per player")
	Service:Start()
	assert(#Service:GetCreatures() == 8, "Start is not idempotent")
	local space = Service.space
	assert(not space:IsClear(Vector3.new(-76, 1, -193), 3, 5), "Pond accepted")
	assert(not space:IsClear(Vector3.new(-15, 1, -47), 3, 5), "Spawn area accepted")
	assert(not space:IsClear(Vector3.new(74, 1, -204), 3, 5), "Barn accepted")
	assert(
		not space:SegmentClear(Vector3.new(-76, 1, -173), Vector3.new(-76, 1, -213), 3, 5),
		"Path crosses pond"
	)
	local starts, moved, states = {}, {}, {}
	for _, model in Service:GetCreatures() do
		starts[model.Name] = model:GetPivot().Position
		states[model.Name] = {}
	end
	-- Observe at least 30 seconds, allowing up to 60 for randomized idle/routes.
	for sample = 1, 240 do
		assert(#Service:GetCreatures() == 8, "Population changed during roaming")
		for _, model in Service:GetCreatures() do
			local p = model:GetPivot().Position
			assert(p.X > -117.5 and p.X < 87.75 and p.Z > -337 and p.Z < -87, "Escaped grasslands")
			assert(
				math.abs(p.Y - model:GetAttribute("ImportGroundOffset") - 1) < 0.01,
				"Invalid ground elevation"
			)
			moved[model.Name] = math.max(moved[model.Name] or 0, (p - starts[model.Name]).Magnitude)
			states[model.Name][model:GetAttribute("MotionState")] = true
		end
		task.wait(0.25)
		local complete = true
		for id in starts do
			if (moved[id] or 0) <= 1 or not states[id].Idle or not states[id].Walk then
				complete = false
			end
		end
		if sample >= 120 and complete then
			break
		end
	end
	for id, distance in moved do
		observations[id] = { distance = distance, states = states[id] }
	end
	for id, distance in moved do
		assert(
			distance > 1 and states[id].Idle and states[id].Walk,
			"Missing movement/state transition: " .. id
		)
	end
	local removed = Service:GetCreatures()[1]
	local oldId = removed:GetAttribute("CreatureId")
	assert(Service:Despawn(removed), "Despawn rejected owned creature")
	assert(not Service:Despawn(removed), "Removed creature accepted twice")
	task.wait(0.3)
	assert(#Service:GetCreatures() == 7, "Despawn did not reduce population")
	task.wait(6)
	assert(#Service:GetCreatures() == 8, "Replacement did not spawn")
	for _, model in Service:GetCreatures() do
		assert(model:GetAttribute("CreatureId") ~= oldId, "Reused removed creature identity")
	end
	for _, player in Players:GetPlayers() do
		local report = reports[player.UserId]
		assert(
			report and report.ready == 8 and report.changed == 8,
			"Client did not animate all eight: " .. player.Name
		)
		assert(report.removals >= 1, "Client did not observe cleanup")
	end
	Service:Stop()
	assert(
		not workspace:FindFirstChild("Creatures") and Service.connection == nil,
		"Stop leaked state"
	)
	task.wait(0.5)
	Service:Start()
	task.wait(2)
	assert(#Service:GetCreatures() == 8, "Restart failed")
	return {
		players = #Players:GetPlayers(),
		moved = moved,
		clientReports = reports,
		population = #Service:GetCreatures(),
		lifecycle = "despawn, respawn, stop and restart passed",
	}
end)
local report = { ok = ok, result = result, observations = observations, clients = reports }
print("CREATURE_TEST_RESULT " .. HttpService:JSONEncode(report))
Test:EndTest(report)
