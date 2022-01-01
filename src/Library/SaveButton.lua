local Save = script:WaitForChild("Button")

local function SaveButton(): TextButton
	Save.Visible = true
	
	return Save
end

return SaveButton