-- // OTHER
-- // For all other settings of accepted values not already manually handled.

Plugin, Library, Widgets, Options, Config, AllRanks, listFrame = nil

return function()
	function Plugin.ArrayToString(array)
		local master = ""

		for _,v in ipairs(array) do
			master = master .. v .. ", "
		end

		return string.sub(master, 1, -3)
	end

	-- Boolean/string/array settings not already manually handled by the plugin
	function Plugin.Other()
		local Other = Widgets.CollapsibleTitledSection.new("suffix", "Other", true, true, true)

		for setting, value in next, Config.Settings do
			if setting ~= "Ranks" and not Options[setting] then
				if type(value) == "string" then
					Options[setting] = Widgets.LabeledTextInput.new(
						"suffix", -- name suffix of gui object
						setting, -- title text of the multi choice
						Config.Settings[setting] -- default value
					)

					Options[setting]:SetMaxGraphemes(50)
					Options[setting]:GetFrame().Parent = Other:GetContentsFrame()
				elseif type(value) == "boolean" then
					Options[setting] = Widgets.LabeledCheckbox.new(
						"suffix", -- name suffix of gui object
						setting, -- text beside the checkbox
						Config.Settings[setting], -- initial value
						false -- initially disabled?
					)

					Options[setting]:GetFrame().Parent = Other:GetContentsFrame()
				elseif type(value) == "table" then
					if setting == "Commands" then
						-- settings.Commands contains functions - something that Adonis Configurator simply can't work with
						-- as such, it will be skipped
						continue
					else
						-- confirm table is an array
						local f = false
						for k,v in next,value do
							if type(k) ~= "number" or k ~= math.floor(k) then
								f = true
							end
						end
						if f then
							continue
						end
					end

					local isBusy = false

					Options[setting] = Widgets.LabeledPrompt.new(
						"suffix",
						setting,
						false,
						false
					)

					Options[setting]:GetClickedSignal():Connect(function()
						if isBusy then
							return
						end

						isBusy = true

						Plugin:Prompt(setting, setting):Connect(function(changed, value)
							Options[setting]:SetValue(Plugin.ArrayToString(value))
							isBusy = false
						end)
					end)

					Options[setting]:SetValue(Plugin.ArrayToString(value))
					Options[setting]:GetFrame().Parent = Other:GetContentsFrame()
				end
			end
		end

		Other:GetSectionFrame().Parent = listFrame:GetFrame()
	end
end