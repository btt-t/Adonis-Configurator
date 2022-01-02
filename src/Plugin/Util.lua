-- // UTIL
-- // Common functions

Plugin, Library, Widgets, Options, Config, AllRanks, listFrame = nil

return function()
	function Plugin:Prompt(DisplayNameForSetting, Setting)
		local bind = Instance.new("BindableEvent")
		local id = game:GetService("HttpService"):GenerateGUID(false)

		if Config.Settings[Setting] then
			if type(Config.Settings[Setting]) == "table" then
				local widget = plugin:CreateDockWidgetPluginGui(id, DockWidgetPluginGuiInfo.new(
					Enum.InitialDockState.Float,
					true,
					true,
					260,
					310,
					260,
					240
					)
				)

				local values = Library.Clone("ArrayPrompt")
				local valueBase = Library.Clone("Value")
				local vValues = values.Values
				
				local function addValue(existing)
					local value = valueBase:Clone()

					value.Delete.MouseButton1Click:Connect(function()
						value:Destroy()
					end)

					value.Focused:Connect(function()
						value.CursorPosition = string.len(value.Text) + 1
						value.SelectionStart = 1
					end)

					if existing then
						value.Text = existing
					end

					value.Parent = vValues
				end

				widget.Name = "ValueEditor-" .. Setting
				widget.Title = string.format('Edit "%s"', DisplayNameForSetting)

				Widgets.GuiUtilities.syncGuiElementBackgroundColor(values)
				Widgets.GuiUtilities.syncGuiThemeChange(function(Theme: StudioTheme)
					local color = Theme:GetColor(Enum.StudioStyleGuideColor.MainBackground)
					local r, g, b

					r = 255 - color.R * 255
					g = 255 - color.G * 255
					b = 255 - color.B * 255

					valueBase.BackgroundColor3 = Color3.fromRGB(r, g, b)
					valueBase.TextColor3 = Color3.fromRGB(r, g, b)

					for _, value in ipairs(vValues:GetChildren()) do
						if value:IsA("GuiObject") then
							value.BackgroundColor3 = Color3.fromRGB(r, g, b)
							value.TextColor3 = Color3.fromRGB(r, g, b)
						end
					end
				end)

				local connection = vValues.Add.MouseButton1Click:Connect(addValue)
				local closingAlready

				local function close(save)
					connection:Disconnect()
					closingAlready:Disconnect()

					local newData = {}

					for _, value in ipairs(values.Values:GetChildren()) do
						if value.Name == "Value" and value:IsA("TextBox") then
							if value.Text ~= "" then
								table.insert(newData, value.Text)
							end
						end
					end

					if save then
						Config.Settings[Setting] = newData
					end

					widget.Enabled = false
					widget:Destroy()

					bind:Fire(save, newData)
					task.wait()
					bind:Destroy()
				end

				for _, v in ipairs(Config.Settings[Setting]) do
					addValue(v)
				end

				closingAlready = widget:GetPropertyChangedSignal("Enabled"):Connect(close)
				values.Button.MouseButton1Click:Connect(function()
					close(true)
				end)

				values.Button.BackgroundColor3 = Color3.fromRGB(21, 162, 255)

				values.Button.MouseEnter:Connect(function()
					values.Button.BackgroundColor3 = Color3.fromRGB(70, 181, 255)
				end)

				values.Button.MouseLeave:Connect(function()
					values.Button.BackgroundColor3 = Color3.fromRGB(21, 162, 255)
				end)

				values.Button.MouseButton1Down:Connect(function()
					values.Button.BackgroundColor3 = Color3.fromRGB(108, 192, 255)
				end)

				values.Button.MouseButton1Up:Connect(function()
					values.Button.BackgroundColor3 = Color3.fromRGB(70, 181, 255)
				end)

				values.Parent = widget
			end
		end

		return bind.Event
	end

	function Plugin.AddSection(SectionName, Settings)
		local Section = Widgets.CollapsibleTitledSection.new("suffix", SectionName, true, true, false)

		for _, settingData in ipairs(Settings) do
			local Creator
			local setting = settingData.Setting

			if settingData.Type == Plugin.Enums.InputType.Checkbox then
				Creator = Widgets.LabeledCheckbox
			elseif settingData.Type == Plugin.Enums.InputType.TextInput then
				Creator = Widgets.LabeledTextInput
			elseif settingData.Type == Plugin.Enums.InputType.ArrayPrompt then
				Creator = Widgets.LabeledPrompt
			end

			if Creator then
				Options[setting] = Creator.new(
					"suffix", -- name suffix of gui object
					settingData.DisplayName or setting, -- text beside the checkbox
					Config.Settings[setting], -- initial value
					false -- initially disabled?
				)

				if Creator == Widgets.LabeledPrompt then
					local isBusy = false

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

					Options[setting]:SetValue(Plugin.ArrayToString(Config.Settings[setting]))
				end

				Options[setting]:GetFrame().Parent = Section:GetContentsFrame()
			end
		end

		Section:GetSectionFrame().Parent = listFrame:GetFrame()
	end
end