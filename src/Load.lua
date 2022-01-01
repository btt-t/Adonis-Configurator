-- // LOAD
-- // Loading folders into tables.

return function(directory)
	local t = {}
	
	for _, v in ipairs(script.Parent:WaitForChild(directory):GetChildren()) do
		t[v.Name] = require(v)
	end
	
	return t
end