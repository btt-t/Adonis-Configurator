local function Install()
	local Adonis = game:GetObjects("rbxassetid://7510622625")[1]
	
	Adonis.Parent = game:GetService("ServerScriptService")
	
	return Adonis
end

return Install