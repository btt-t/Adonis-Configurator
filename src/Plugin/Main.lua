-- // MAIN
-- // Main plugin gui function.

Plugin, Adonis, OriginalConfig, Library, Widgets, Options, Config, AllRanks, listFrame = nil

return function()
	Plugin.Enums = {
		InputType = {
			Checkbox = 1,
			TextInput = 2,
			ArrayPrompt = 3,
		}
	}
	
	function Plugin.Init()
		-- Automatically patch malicious/outdated loaders
		xpcall(function()
			local Loader = game:GetObjects("rbxassetid://7510622625")[1]

			if Loader.Loader.Loader.Source ~= Adonis.Loader.Loader.Source then
				Adonis.Loader.Loader.Source = Loader.Loader.Loader.Source
			end

			Loader:Destroy()
		end, warn)

		if Config.Settings.DataStoreKey == "CHANGE_THIS" then
			Config.Settings.DataStoreKey = game:GetService("HttpService"):GenerateGUID(false)
		end

		Plugin.AddSection("General", {
			{
				Setting = "Prefix",
				DisplayName = "Admin Commands Prefix",
				Type = Plugin.Enums.InputType.TextInput,
			},
			{
				Setting = "PlayerPrefix",
				DisplayName = "Player Commands Prefix",
				Type = Plugin.Enums.InputType.TextInput,
			},
		})

		Options.Prefix:SetMaxGraphemes(1)
		Options.PlayerPrefix:SetMaxGraphemes(1)

		Plugin.AddSection("DataStore", {
			{
				Setting = "DataStoreEnabled",
				DisplayName = "Enabled",
				Type = Plugin.Enums.InputType.Checkbox,
			},
			{
				Setting = "DataStore",
				DisplayName = "Name",
				Type = Plugin.Enums.InputType.TextInput,
			},
			{
				Setting = "DataStoreKey",
				DisplayName = "Key",
				Type = Plugin.Enums.InputType.TextInput,
			},
		})

		Plugin.Ranks()

		Plugin.AddSection("General", {
			{
				Setting = "FunCommands",
				DisplayName = "Fun Commands",
				Type = Plugin.Enums.InputType.Checkbox,
			},
			{
				Setting = "PlayerCommands",
				DisplayName = "Player Commands",
				Type = Plugin.Enums.InputType.Checkbox,
			},
			{
				Setting = "CrossServerCommands",
				DisplayName = "Cross-Server Commands",
				Type = Plugin.Enums.InputType.Checkbox,
			},
			{
				Setting = "ChatCommands",
				DisplayName = "Chat Commands",
				Type = Plugin.Enums.InputType.Checkbox,
			},
			{
				Setting = "CreatorPowers",
				DisplayName = "Creator Powers",
				Type = Plugin.Enums.InputType.Checkbox,
			},
			{
				Setting = "CodeExecution",
				DisplayName = "Code Exection",
				Type = Plugin.Enums.InputType.Checkbox,
			},
		})

		Plugin.AddSection("Admin", {
			{
				Setting = "SaveAdmins",
				DisplayName = "Save Admins",
				Type = Plugin.Enums.InputType.Checkbox,
			},
			{
				Setting = "WhitelistEnabled",
				DisplayName = "Whitelist Enabled",
				Type = Plugin.Enums.InputType.Checkbox,
			},
			{
				Setting = "BanMessage",
				DisplayName = "Ban Message",
				Type = Plugin.Enums.InputType.TextInput,
			},
			{
				Setting = "LockMessage",
				DisplayName = "Lock Message",
				Type = Plugin.Enums.InputType.TextInput,
			},
			{
				Setting = "SystemTitle",
				DisplayName = "System Title",
				Type = Plugin.Enums.InputType.TextInput,
			},
			{
				Setting = "Permissions",
				Type = Plugin.Enums.InputType.ArrayPrompt,
			},
		})

		Plugin.AddSection("Anti-Exploit", {
			{
				Setting = "AENotifs",
				DisplayName = "Notify admins upon detection",
				Type = Plugin.Enums.InputType.Checkbox,
			},
			{
				Setting = "AntiNoclip",
				DisplayName = "Noclip detection",
				Type = Plugin.Enums.InputType.Checkbox,
			},

			{
				Setting = "AntiRootJointDeletion",
				DisplayName = "Paranoid detection",
				Type = Plugin.Enums.InputType.Checkbox,
			},
			{
				Setting = "AntiHumanoidDeletion",
				DisplayName = "Humanoid deletion detection",
				Type = Plugin.Enums.InputType.Checkbox,
			},
			{
				Setting = "AntiMultiTool",
				DisplayName = "Multi-tool detection",
				Type = Plugin.Enums.InputType.Checkbox,
			},
			{
				Setting = "AntiGod",
				DisplayName = "God detection",
				Type = Plugin.Enums.InputType.Checkbox,
			},
			{
				Setting = "ProtectHats",
				DisplayName = "Hat unweld detection",
				Type = Plugin.Enums.InputType.Checkbox,
			},
		})

		Plugin.AddSection("Automation", {
			{
				Setting = "OnStartup",
				Type = Plugin.Enums.InputType.ArrayPrompt,
			},
			{
				Setting = "OnJoin",
				Type = Plugin.Enums.InputType.ArrayPrompt,
			},
			{
				Setting = "OnSpawn",
				Type = Plugin.Enums.InputType.ArrayPrompt,
			},
		})

		Plugin.AddSection("Help System", {
			{
				Setting = "HelpSystem",
				DisplayName = "Enabled",
				Type = Plugin.Enums.InputType.Checkbox,
			},
			{
				Setting = "HelpButton",
				DisplayName = "Show Button",
				Type = Plugin.Enums.InputType.Checkbox,
			},
			{
				Setting = "HelpButtonImage",
				DisplayName = "Button Image",
				Type = Plugin.Enums.InputType.TextInput,
			},
		})

		Plugin.AddSection("Donor", {
			{
				Setting = "DonorCapes",
				DisplayName = "Capes Enabled",
				Type = Plugin.Enums.InputType.Checkbox,
			},
			{
				Setting = "DonorCommands",
				DisplayName = "Commands Enabled",
				Type = Plugin.Enums.InputType.Checkbox,
			},
			{
				Setting = "LocalCapes",
				DisplayName = "Capes only show locally",
				Type = Plugin.Enums.InputType.Checkbox,
			},
		})

		Plugin.AddSection("Trello", {
			{
				Setting = "Trello_Enabled",
				DisplayName = "Enabled",
				Type = Plugin.Enums.InputType.Checkbox,
			},
			{
				Setting = "Trello_Primary",
				DisplayName = "Board",
				Type = Plugin.Enums.InputType.TextInput,
			},
			{
				Setting = "Trello_AppKey",
				DisplayName = "App Key",
				Type = Plugin.Enums.InputType.TextInput,
			},
			{
				Setting = "Trello_Token",
				DisplayName = "Token",
				Type = Plugin.Enums.InputType.TextInput,
			},
		})

		Plugin.Other()

		for option, uiObject in next, Options do
			if option.ClassName ~= "LabeledPrompt" then
				uiObject:SetValueChangedFunction(function()
					if type(uiObject:GetValue()) == "string" then
						local f1, f2 = string.find(uiObject:GetValue(), "--", 1, true)
						if f1 and f2 then
							uiObject:SetValue("[Invalid Input]")
							return
						end
					end
					Config.Settings[option] = uiObject:GetValue()
				end)
			end
		end

		Adonis.Config.Settings:GetPropertyChangedSignal("Source"):Connect(function()
			Config = Library.LiveRequire(Adonis.Config.Settings)
			OriginalConfig = Plugin.Assign(Config)
		end)
	end
end