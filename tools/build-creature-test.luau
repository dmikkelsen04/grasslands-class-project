-- Optional Studio integration harness. Normal Rojo builds never contain it.
-- First build the normal place, then: lune run tools/build-creature-test
local fs = require("@lune/fs")
local R = require("@lune/roblox")
local place = R.deserializePlace(fs.readFile("build/grasslands.rbxlx"))
local remote = R.Instance.new("RemoteEvent")
remote.Name = "CreatureTestReport"
remote.Parent = place.ReplicatedStorage
for _, side in { "server", "client" } do
	local script = R.Instance.new(if side == "server" then "Script" else "LocalScript")
	script.Name = "CreatureIntegrationTest"
	script.Source = fs.readFile("tests/creatures.studio." .. side .. ".luau")
	script.Parent = if side == "server"
		then place.ServerScriptService
		else place.StarterPlayer.StarterPlayerScripts
end
fs.writeFile("build/grasslands-creature-test.rbxlx", R.serializePlace(place, true))
print("Open build/grasslands-creature-test.rbxlx and run the command from docs/creature-review.md")
