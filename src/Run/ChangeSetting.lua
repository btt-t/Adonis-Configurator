-- // CHANGESETTING
-- // Function for changing settings within the Adonis Settings source.

return function(Adonis, Setting, NewValue)
	local Source = Adonis.Config.Settings.Source
	local Start, End = string.find(Source, "settings." .. Setting .. " = ")

	local HardFind = {"Ranks", "Permissions"}

	if table.find(HardFind, Setting) then
		Start, End = string.find(Source, "\n\tsettings.".. Setting .." = ")
	end

	if Start and End then
		local DashStart, DashEnd = string.find(
			Source, 
			if Setting == "Ranks" then 
				"--// Use the below table to set command permissions; Commented commands are included for example purposes" 
				elseif Setting == "Permissions" then
				'-- Format: {"Command:NewLevel"; "Command:Customrank1,Customrank2,Customrank3";}'
				else 
				"--", 
			End, 
			true
		)

		if DashStart and DashEnd then
			local NewSource = string.sub(Source, 1, End) .. tostring(NewValue) .. "    " .. string.sub(Source, DashStart)

			Adonis.Config.Settings.Source = NewSource

			return
		end
	end

	warn(string.format("An error occurred while trying to set '%s'.", Setting))
end