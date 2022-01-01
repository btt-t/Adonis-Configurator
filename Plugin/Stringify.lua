-- // STRINGIFICATION
-- // Adonis Configurator directly modifies the source of Adonis_Loader > Config > Settings, so 
-- // stringification is necessary to make value saving possible.

Plugin, Library, Widgets, Options, Config, AllRanks, listFrame = nil

return function()
	function Plugin:GetValue(Value)
		local Type = tostring(type(Value))
		if Type == "string" then
			return '"' ..Value.. '"'
		elseif Type == "number" then
			return Value
		elseif Type == "nil" then
			return "nil"
		elseif Type == "float" then
			return tonumber(Value)
		elseif Type == "boolean" then
			return tostring(Value)
		elseif Type == "table" then
			return self:BuildTable(Value)
		end
		Type = tostring(typeof(Value))
		if Type == "Instance" then
			return self:GetInstanceValue(Value)
		elseif Type == "EnumItem" then
			return tostring(Value)
		elseif Type == 'CFrame' then
			local x, y, z, R00, R01, R02, R10, R11, R12, R20, R21, R22 = Value:GetComponents()
			local s = tostring
			return "CFrame.new("..s(x)..",".. s(y)..",".. s(z)..",".. s(R00)..",".. s(R01)..",".. s(R02)..",".. s(R10)..",".. s(R11)..",".. s(R12)..",".. s(R20)..",".. s(R21)..",".. s(R22)..")"
		elseif Type == 'Color3' then
			return "Color3.new("..Value.R..",".. Value.G..",".. Value.B..")"
		elseif Type == 'Vector3' then
			return 'Vector3.new('..Value.X..", "..Value.Y..", "..Value.Z..")"
		elseif Type == 'BrickColor' then
			return 'BrickColor.new("'..Value.Name..'")'
		elseif Type == 'ColorSequence' then
			local arrayString = " {\n"
			for _,v in ipairs(Value.Keypoints) do
				arrayString = arrayString .. '\tColorSequenceKeypoint.new('..Plugin:GetValue(v.Time)..", "..Plugin:GetValue(v.Value)..'),\n'
			end
			arrayString = arrayString.. "}"
			return 'ColorSequence.new'..arrayString
		elseif Type == 'NumberRange' then
			return 'NumberRange.new('..Value.Min..", "..Value.Max..")"
		elseif Type == 'UDim' then 
			return 'UDim.new('..Plugin:GetValue(Value.Scale)..", "..Plugin:GetValue(Value.Offset)..")"
		elseif Type == 'UDim2' then
			return 'UDim2.new('..Plugin:GetValue(Value.X)..", "..Plugin:GetValue(Value.Y)..")"
		elseif Type == 'Rect' then 
			return 'Rect.new('..Plugin:GetValue(Value.Min)..", "..Plugin:GetValue(Value.Max)..")"
		elseif Type == 'NumberSequence' then
			local arrayString = " {\n"
			for _,v in ipairs(Value.Keypoints) do
				arrayString = arrayString .. '\tNumberSequenceKeypoint.new('..Plugin:GetValue(v.Time)..", "..Plugin:GetValue(v.Value)..", "..Plugin:GetValue(v.Envelope)..'),\n'
			end
			arrayString = arrayString.. "}"
			return 'NumberSequence.new'..arrayString
		else
			-- if all else fails...
			local dat = tostring(Value)
			local num = true
			if not dat:find(",") and dat:find(" ") then
				local a = dat:split(" ")
				local s = ""
				for i,val in ipairs(a) do 
					if i > 1 then
						if not tonumber(val) then num = false end
						s = s .. ", ".. val
					else	
						s = s .. val
					end
				end
				dat = s
			end
			if num then
				return Type..".new("..dat..")"
			else
				return Type..".new('"..dat.."')"
			end
		end
	end

	function Plugin:GetInstanceValue(Instance, ServicesGlobalsOnly)
		local Globals = {
			DataModel = "game",
			Workspace = "workspace",
			Terrain = "workspace.Terrain",
			Camera = Instance.Parent == workspace and "workspace.CurrentCamera",
		}
		local Global = Globals[Instance.ClassName]
		if Global then
			return Global
		end
		if game:GetService(Instance.ClassName) then
			return "game:GetService('"..Instance.ClassName.."')"
		end
		if ServicesGlobalsOnly then
			return false
		end
		return "nil"
	end

	function Plugin:BuildTable(tbl)
		local result = "{"
		for k, v in pairs(tbl) do
			-- Check the key type (ignore any numerical keys - assume its an array)
			if type(k) ~= "number" then
				result = result.."["..Plugin:GetValue(k).."]".." = "
			end
			result = result.. Plugin:GetValue(v) .. ", "
		end
		-- Remove leading commas from the result
		if result ~= "" then
			result = result:sub(1, result:len()-2)
		end
		return result.."}"
	end
end