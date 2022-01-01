-- Services declaration
local ServerScriptService = game:GetService("ServerScriptService")
local RunService = game:GetService("RunService")

-- Prevent plugin from running outside of Edit Mode
do
	local success, isEdit = pcall(function()
		return RunService:IsEdit()
	end)

	if not success or (success and not isEdit) then
		return
	end
end

-- Core variables
local Plugin = setmetatable({
	Assign = function(t)
		local new = {}

		for k,v in next,t do
			new[k] = v
		end

		return new
	end
}, {}) -- silence linter
local Load = require(script.Parent:WaitForChild("Load"))

local Widgets = Load("Widgets")
local Library = Load("Library")
local Run = Load("Run")
local Options = {}
local AllRanks = {}

local Adonis = ServerScriptService:FindFirstChild("Adonis_Loader", true)
local widgetGui, scrollFrame, listFrame = Run.GUI(Library, Widgets, plugin)

local Updating = false
local OriginalConfig
local SaveButton = Library.SaveButton()
local Config do
	if Adonis then
		xpcall(function()
			Config = Library.LiveRequire(Adonis.Config.Settings)
			OriginalConfig = Plugin.Assign(Config)
		end, warn)
	end
end

-- Plugin components runner
for _, v in ipairs(script.Parent:WaitForChild("Plugin"):GetChildren()) do
	
	local func = require(v)
	local env = getfenv(func)
	
	env.Adonis = Adonis
	env.OriginalConfig = OriginalConfig
	env.Plugin = Plugin
	env.Library = Library
	env.Widgets = Widgets
	env.Run = Run
	env.Options = Options
	env.Config = Config
	env.AllRanks = AllRanks
	env.listFrame = listFrame

	func()
end

Run.ButtonEffects(SaveButton)

SaveButton.MouseButton1Click:Connect(function()
	if Updating then
		return
	end

	Updating = true
	warn("Adonis :: Updating configuration...")
	SaveButton.Text = "Saving..."

	for k, v in next, OriginalConfig.Settings do
		if Options[k] then
			Run.ChangeSetting(Adonis, k, Plugin:GetValue(v))
		end
	end

	if OriginalConfig.Ranks ~= AllRanks then
		Run.ChangeSetting(Adonis, "Ranks", Plugin:GetValue(AllRanks))
	end

	SaveButton.Text = "Save"
	warn("Adonis :: Configuration updated")
	Updating = false
end)

if Adonis then
	Plugin.Init()
else
	local UI = Library.InstallUI(true)
	local Installing = false
	
	Widgets.GuiUtilities.syncGuiElementFontColor(UI.Label)
	SaveButton.Visible = false
	Run.ButtonEffects(UI.Button)
	
	UI.Button.MouseButton1Click:Connect(function()
		if Installing then
			return
		end

		Installing = true
		Adonis = Library.Install()
		Config = Library.LiveRequire(Adonis.Config.Settings)
		OriginalConfig = Plugin.Assign(Config)

		UI:Destroy()
		SaveButton.Visible = true

		Plugin.Init()
	end)
	
	UI.Parent = widgetGui
end