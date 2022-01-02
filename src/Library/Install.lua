-- // INSTALL
-- // This is the function used for installing the latest version of Adonis.

return function Install()
	local Adonis = game:GetObjects("rbxassetid://7510622625")[1]
	
	Adonis.Parent = game:GetService("ServerScriptService")
	
	return Adonis
end