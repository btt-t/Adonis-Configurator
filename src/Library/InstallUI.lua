local UI = script:WaitForChild("Install")

local function InstallUI(Enabled: boolean): Frame
	UI.Visible = Enabled
	
	return UI
end

return InstallUI