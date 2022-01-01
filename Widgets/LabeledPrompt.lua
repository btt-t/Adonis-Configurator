----------------------------------------
--
-- LabeledCheckbox.lua
--
-- Creates a frame containing a label and a checkbox.
--
----------------------------------------
GuiUtilities = require(script.Parent.GuiUtilities)

local kCheckboxWidth = GuiUtilities.kCheckboxWidth
local kCheckboxImageWidth = GuiUtilities.kCheckboxImageWidth

local kMinTextSize = 14
local kMinHeight = 24
local kMinLabelWidth = GuiUtilities.kCheckboxMinLabelWidth
local kMinMargin = GuiUtilities.kCheckboxMinMargin
local kMinButtonWidth = kCheckboxWidth;

local kMinLabelSize = UDim2.new(0, kMinLabelWidth, 0, kMinHeight)
local kMinLabelPos = UDim2.new(0, kMinButtonWidth + kMinMargin, 0, kMinHeight/2)

local kMinButtonSize = UDim2.new(0, kMinButtonWidth, 0, kMinButtonWidth)
local kMinButtonPos = UDim2.new(0, 0, 0, kMinHeight/2)

local kCheckImageWidth = 8
local kMinCheckImageWidth = kCheckImageWidth

local kCheckImageSize = UDim2.new(0, kCheckImageWidth, 0, kCheckImageWidth)
local kMinCheckImageSize = UDim2.new(0, kMinCheckImageWidth, 0, kMinCheckImageWidth)

local kEnabledCheckImage = "rbxasset://textures/GameSettings/CheckedBoxLight.png"
local kDisabledCheckImage = "rbxasset://textures/GameSettings/CheckedBoxDark.png"
local kCheckboxFrameImage = "rbxasset://textures/GameSettings/UncheckedBox.png"
LabeledPrompt = {}
LabeledPrompt.__index = LabeledPrompt

LabeledPrompt.kMinFrameSize = UDim2.new(0, kMinLabelWidth + kMinMargin + kMinButtonWidth, 0, kMinHeight)


function LabeledPrompt.new(nameSuffix, labelText, initValue, initDisabled)
	local self = {}
	setmetatable(self, LabeledPrompt)

	local initValue = not not initValue
	local initDisabled = not not initDisabled

	local frame = GuiUtilities.MakeStandardFixedHeightFrame("CBF" .. nameSuffix)

	local fullBackgroundButton = Instance.new("TextButton")
	fullBackgroundButton.Name = "FullBackground"
	fullBackgroundButton.Parent = frame
	fullBackgroundButton.BackgroundTransparency = 1
	fullBackgroundButton.Size = UDim2.new(1, 0, 1, 0)
	fullBackgroundButton.Position = UDim2.new(0, 0, 0, 0)
	fullBackgroundButton.Text = ""
	
	local divider = Instance.new("Frame")
	divider.AnchorPoint = Vector2.new(0.35, 0)
	divider.Size = UDim2.new(0, 1, 1, 0)
	divider.Position = UDim2.new(0.35, 0, 0, 0)
	divider.BackgroundColor3 = Color3.fromRGB(223, 223, 223)
	divider.BorderSizePixel = 0
	divider.ZIndex = 5
	divider.Parent = fullBackgroundButton
	
	local textLabel = Instance.new("TextLabel")
	textLabel.Name = "TextLabel"
	textLabel.Font = Enum.Font.SourceSans
	textLabel.TextSize = 15
	textLabel.Text = ""
	textLabel.BackgroundTransparency = 1
	textLabel.TextXAlignment = Enum.TextXAlignment.Left
	textLabel.Size = UDim2.new(0.65, -13, 1, GuiUtilities.kTextVerticalFudge)
	textLabel.Position = UDim2.new(0.35, 7, 0, 0)
	textLabel.ClipsDescendants = true
	textLabel.TextWrapped = true
	textLabel.Parent = fullBackgroundButton
	
	GuiUtilities.syncGuiElementFontColor(textLabel)
	GuiUtilities.syncGuiThemeChange(function(Theme)
		if Theme.Name == "Light" then
			divider.BackgroundColor3 = Color3.fromRGB(223, 223, 223)
		else
			divider.BackgroundColor3 = Color3.fromRGB(53, 53, 53)
		end
	end)

	local label = GuiUtilities.MakeStandardPropertyLabel(labelText, true)
	label.Parent = fullBackgroundButton
	
	self._theme = "Light"
	self._frame = frame
	self._click = Instance.new("BindableEvent")
	self._label = label
	self._fullBackgroundButton = fullBackgroundButton
	self._valueLabel = textLabel

	self.ClassName = "LabeledPrompt"

	self:_SetupMouseClickHandling()

	local function updateFontColors()
		self:UpdateFontColors()
	end
	
	settings().Studio.ThemeChanged:Connect(updateFontColors)
	updateFontColors()

	return self
end

function LabeledPrompt:GetClickedSignal()
	return self._click.Event
end

function LabeledPrompt:_MaybeToggleState()
	if not self._disabled then
		self._click:Fire()
	end
end

function LabeledPrompt:_SetupMouseClickHandling()
	self._fullBackgroundButton.MouseButton1Click:connect(function()
		self:_MaybeToggleState()
	end)
end

function LabeledPrompt:SetValue(newValue)
	self._valueLabel.Text = newValue
end

-- Small checkboxes are a different entity.
-- All the bits are smaller.
-- Fixed width instead of flood-fill.
-- Box comes first, then label.
function LabeledPrompt:UseSmallSize()
	self._label.TextSize = kMinTextSize
	self._label.Size = kMinLabelSize
	self._label.Position = kMinLabelPos
	self._label.TextXAlignment = Enum.TextXAlignment.Left

	self._frame.Size = LabeledPrompt.kMinFrameSize
	self._frame.BackgroundTransparency = 1
end

function LabeledPrompt:GetFrame()
	return self._frame
end

function LabeledPrompt:GetValue()
	-- If button is disabled, and we should be using a disabled override, 
	-- use the disabled override.
	if (self._disabled and self._useDisabledOverride) then 
		return self._disabledOverride
	else
		return self._value
	end
end

function LabeledPrompt:GetLabel()
	return self._label
end

function LabeledPrompt:SetValueChangedFunction(vcFunction) 
	self._valueChangedFunction = vcFunction
end

function LabeledPrompt:FireValueChangedFunction(data)
	task.spawn(self._valueChangedFunction(data))
end

function LabeledPrompt:UpdateFontColors()
	if self._disabled then 
		self._label.TextColor3 = (settings().Studio.Theme:: StudioTheme):GetColor(Enum.StudioStyleGuideColor.DimmedText)
	else
		self._label.TextColor3 = (settings().Studio.Theme:: StudioTheme):GetColor(Enum.StudioStyleGuideColor.MainText)
	end
end

return LabeledPrompt