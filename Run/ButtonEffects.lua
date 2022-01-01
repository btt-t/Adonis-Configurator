-- // BUTTONEFFECTS
-- // Common button hover effects for the bright wide blue buttons.

return function(button)
	button.BackgroundColor3 = Color3.fromRGB(21, 162, 255)

	button.MouseEnter:Connect(function()
		button.BackgroundColor3 = Color3.fromRGB(70, 181, 255)
	end)

	button.MouseLeave:Connect(function()
		button.BackgroundColor3 = Color3.fromRGB(21, 162, 255)
	end)

	button.MouseButton1Down:Connect(function()
		button.BackgroundColor3 = Color3.fromRGB(108, 192, 255)
	end)

	button.MouseButton1Up:Connect(function()
		button.BackgroundColor3 = Color3.fromRGB(70, 181, 255)
	end)
end