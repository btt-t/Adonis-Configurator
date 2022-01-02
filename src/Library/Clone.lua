-- // CLONE

return function(Name)
	local Assets = script.Parent.Parent.Assets
	
	return Assets[Name]:Clone()
end