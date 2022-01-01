local function LiveRequire(moduleScript: ModuleScript)
	local data
	local new = Instance.new("ModuleScript")
	
	new.Source = moduleScript.Source
	task.wait()
	data = require(new)
	new:Destroy()
	
	return data
end

return LiveRequire