-- // RANK EDITOR
-- // Rank editing is a whole separate thing requiring a different setup.

Plugin, Run, Library, Widgets, Options, Config, AllRanks, listFrame = nil

return function()
	function Plugin.Ranks()
		local Ranks = Widgets.CollapsibleTitledSection.new("suffix", "Ranks", true, true, true)
		local seven = UDim.new(0, 7)
		local contents = Ranks:GetContentsFrame()
		local create = Library.Clone("Create")

		AllRanks = Config.Settings.Ranks or {}
		Ranks:SetCollapsedState(false)

		contents.UIListLayout.Padding = seven
		contents.UIPadding.PaddingTop = seven
		contents.UIPadding.PaddingLeft = seven
		contents.UIPadding.PaddingBottom = seven
		contents.UIPadding.PaddingRight = seven

		local function onRankAdded(rankName, rankData)
			local rank = Library.Clone("Rank")
			local editing = false

			AllRanks[rankName] = rankData

			local function addBind(bindObject)
				local currentText = bindObject.Text
				local pos = table.find(AllRanks[rankName].Users, currentText)
				local hover, noHover = bindObject.Delete.HoverImage, bindObject.Delete.Image

				if not pos or pos < 0 then
					table.insert(AllRanks[rankName].Users, currentText)
				end

				Widgets.GuiUtilities.syncGuiElementFontColor(bindObject)
				Widgets.GuiUtilities.syncGuiElementBackgroundColor(bindObject)

				bindObject.Delete.HoverImage = ""

				bindObject.FocusLost:Connect(function()
					local pos = table.find(AllRanks[rankName].Users, currentText)

					if pos and pos > -1 then
						AllRanks[rankName].Users[pos] = bindObject.Text
					end

					currentText = bindObject.Text
				end)

				bindObject.Focused:Connect(function()
					bindObject.CursorPosition = string.len(bindObject.Text) + 1
					bindObject.SelectionStart = 1
				end)

				bindObject.Delete.MouseEnter:Connect(function()
					bindObject.Delete.Image = hover
				end)

				bindObject.Delete.MouseLeave:Connect(function()
					bindObject.Delete.Image = noHover
				end)

				bindObject.Delete.MouseButton1Down:Connect(function()
					local pos = table.find(AllRanks[rankName].Users, currentText)

					if pos and pos > -1 then
						table.remove(AllRanks[rankName].Users, pos)
						bindObject:Destroy()
					else
						warn("Unable to delete '".. currentText .."'")
					end
				end)
			end

			local function rankButton(button)
				local noHover = button.Image
				local hover = button.HoverImage

				button.HoverImage = ""

				button.MouseEnter:Connect(function()
					button.Image = hover
				end)

				button.MouseLeave:Connect(function()
					button.Image = noHover
				end)
			end

			if table.find({"Creators", "HeadAdmins", "Admins", "Moderators"}, rankName) then
				rank.RankName.Edit.Visible = false
				rank.RankName.Delete.Visible = false
			end

			rankButton(rank.RankName.Add)
			rankButton(rank.RankName.Edit)
			rankButton(rank.RankName.Delete)

			rank.RankName.Text = rankName
			rank.RankLevel.Text = "Level " .. rankData.Level

			rank.RankName.Edit.MouseButton1Down:Connect(function()
				editing = not editing

				if editing then
					rank.RankName.Change.Visible = true
					rank.RankLevel.Change.Visible = true
				else
					rank.RankName.Change.Visible = false
					rank.RankLevel.Change.Visible = false
				end
			end)

			rank.RankName.Change.Text = rankName
			rank.RankLevel.Change.Text = tostring(rankData.Level)

			rank.RankName.Change.FocusLost:Connect(function()
				local newName = rank.RankName.Change.Text

				if newName ~= rankName then
					if AllRanks[newName] then
						rank.RankName.Change.Text = rankName
						return
					end

					local d = AllRanks[rankName]

					AllRanks[rankName] = nil
					rankName = newName
					AllRanks[rankName] = d

					rank.RankName.Text = rankName
				end
			end)

			rank.RankLevel.Change.FocusLost:Connect(function()
				local new = tonumber(rank.RankLevel.Change.Text)

				if new then
					AllRanks[rankName].Level = new
					rank.RankLevel.Change.Text = tostring(new)
					rank.RankLevel.Text = "Level " .. new
				else
					rank.RankLevel.Change.Text = "Level " .. AllRanks[rankName].Level
				end
			end)

			rank.RankName.Delete.MouseButton1Down:Connect(function()
				rank:Destroy()
				Config.Settings.Ranks[rankName] = nil
				AllRanks[rankName] = nil
			end)

			rank.RankName.Add.MouseButton1Down:Connect(function()
				local bind = Library.Bind()

				addBind(bind)

				bind.Parent = rank.Binds
			end)

			for _, user in ipairs(if #rankData.Users > 0 then rankData.Users else {}) do
				if user == nil or user == "" then
					continue
				end

				local bind = Library.Clone("Bind")

				bind.Text = user
				addBind(bind)
				bind.Parent = rank.Binds
			end

			Widgets.GuiUtilities.syncGuiThemeChange(function(Theme: StudioTheme)
				local c3 = Theme:GetColor(Enum.StudioStyleGuideColor.MainBackground)
				local r, g, b = 255 - c3.R * 255, 255 - c3.G * 255, 255 - c3.B * 255

				rank.BackgroundColor3 = Color3.fromRGB(r, g, b)
			end)

			Widgets.GuiUtilities.syncGuiElementBackgroundColor(rank.RankName.Change)
			Widgets.GuiUtilities.syncGuiElementBackgroundColor(rank.RankLevel.Change)
			Widgets.GuiUtilities.syncGuiElementFontColor(rank.RankName)
			Widgets.GuiUtilities.syncGuiElementFontColor(rank.RankLevel)
			Widgets.GuiUtilities.syncGuiElementFontColor(rank.RankName.Change)
			Widgets.GuiUtilities.syncGuiElementFontColor(rank.RankLevel.Change)

			rank.Parent = Ranks:GetContentsFrame()
		end

		for rankName, rankData in next, AllRanks do
			onRankAdded(rankName, rankData)
		end

		Run.ButtonEffects(create)

		create.MouseButton1Click:Connect(function()
			local highest = 0 do
				for rankName,_ in next, AllRanks do
					local n = tonumber(string.sub(rankName, 9))

					if n then
						if n > highest then
							highest = n
						end
					end
				end
			end

			onRankAdded("New Rank " .. highest + 1 , {
				Level = 0,
				Users = {},
			})
		end)

		create.Parent = Ranks:GetContentsFrame()
		Ranks:GetSectionFrame().Parent = listFrame:GetFrame()
	end
end