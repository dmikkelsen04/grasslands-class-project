--!strict
local creatures = require(script.Parent.CreatureService)
creatures:Start()
game:BindToClose(function()
	creatures:Stop()
end)
print("Grasslands class project: server ready")
