--[[
MovePlease by Rickoff
tes3mp 0.8.1
---------------------------
DESCRIPTION :
I was tired of being stuck in hallways.
activating an actor with the hands to cast a spell makes him move.
---------------------------
INSTALLATION:
Save the file as MovePlease.lua inside your server/scripts/custom folder.
Edits to customScripts.lua
MovePlease = require("custom.MovePlease")
---------------------------
]]
local cfg = {
	OnlyInterior = true
}

local MovePlease = {}

MovePlease.OnActivatedObject = function(eventStatus, pid, cellDescription, objects)

	if cfg.OnlyInterior then
		if tes3mp.IsInExterior(pid) then return end
	end
	
	local ObjectIndex
	local ObjectRefid

	for _, object in pairs(objects) do
		ObjectIndex = object.uniqueIndex
		ObjectRefid = object.refId
	end

	if ObjectIndex and ObjectRefid then
		if tableHelper.containsValue(LoadedCells[cellDescription].data.packets.actorList, ObjectIndex) and tes3mp.GetDrawState(pid) == 2 then
			logicHandler.RunConsoleCommandOnObject(pid, "PlayGroup, hit2, 1", cellDescription, ObjectIndex, false)	
			logicHandler.RunConsoleCommandOnObject(pid, "AIWander, 512, 1, 0", cellDescription, ObjectIndex, false)
			return customEventHooks.makeEventStatus(false,false) 
		end			
	end
end

customEventHooks.registerValidator("OnObjectActivate", MovePlease.OnActivatedObject)

return MovePlease
