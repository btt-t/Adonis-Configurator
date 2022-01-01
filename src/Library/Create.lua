local UI = script:WaitForChild("Create")

local function Create(Enabled: boolean): Frame
	UI.Visible = Enabled

	return UI
end

return Create