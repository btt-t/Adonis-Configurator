-- // GUI
-- // All core UI components created here.

return function(Library, Widgets, plugin)
	local toolBar: PluginToolbar = plugin:CreateToolbar("Adonis")
	local toolBarButton: PluginToolbarButton = (toolBar:CreateButton("Adonis", "Adonis Configurator (Beta)", "rbxassetid://8359238805", "Adonis Configurator") :: PluginToolbarButton)
	local widgetGui: PluginGui = plugin:CreateDockWidgetPluginGui("Adonis", DockWidgetPluginGuiInfo.new(
		Enum.InitialDockState.Left,  -- Widget will be initialized in floating panel
		true,   -- Widget will be initially enabled
		false,  -- Don't override the previous enabled state
		595,    -- Default width of the floating window
		600,    -- Default height of the floating window
		595,    -- Minimum width of the floating window (optional)
		330     -- Minimum height of the floating window (optional)
		)
	)
	local background = Instance.new("Frame")
	local scrollFrame = Widgets.VerticalScrollingFrame.new("suffix")
	local listFrame = Widgets.VerticallyScalingListFrame.new("suffix")

	toolBarButton.Click:Connect(function()
		widgetGui.Enabled = not widgetGui.Enabled
	end)

	widgetGui:GetPropertyChangedSignal("Enabled"):Connect(function()
		toolBarButton:SetActive(widgetGui.Enabled)
		plugin:SetSetting("Last_Enabled", widgetGui.Enabled)
	end)

	widgetGui.Enabled = plugin:GetSetting("Last_Enabled") or true
	toolBarButton:SetActive(widgetGui.Enabled)

	widgetGui.Title = "Adonis Configurator (Beta)"
	widgetGui.Name = "Adonis"
	
	background.BorderSizePixel = 0
	background.ZIndex = 0
	background.Size = UDim2.new(1, 0, 1, 0)
	background.Parent = widgetGui

	Widgets.GuiUtilities.syncGuiElementBackgroundColor(background)

	listFrame:GetFrame().Parent = scrollFrame:GetContentsFrame() -- scroll content will be the VerticallyScalingListFrame
	scrollFrame:GetSectionFrame().Parent = widgetGui -- set the section parent
	scrollFrame:GetSectionFrame().Size = UDim2.new(1, 0, 1, -50)
	Library.SaveButton().Parent = widgetGui
	
	return widgetGui, scrollFrame, listFrame
end