-- // ASSIGN
-- // Equivalent to JavaScript's Object.Assign

return function(t)
	local new = {}

	for k,v in next,t do
		new[k] = v
	end

	return new
end