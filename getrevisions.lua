require"lfs"
if cgilua.POST.file then
	local revisions = {}
	local fn = cgilua.POST.file
	-- remove up-dir
	fn = fn:gsub('%.%.', '')
	-- remove leading slashes
	while fn:find('/') == 1 do
		fn = fn:sub(2)
	end
	for d in lfs.dir('db/' .. fn) do
		if d:sub(-4) == '.rev' then
			table.insert(revisions, d)
		end
	end
	table.sort(revisions, function(a,b)
		if #a > #b then return true; end
		if #a < #b then return false; end
		return a > b
	end)
	cgilua.put('<li><a href="current" class="revlink">c</a></li>\n') 
	for _, f in ipairs(revisions) do
		cgilua.put('<li><a href="' .. f:sub(1,-5) .. '" class="revlink">' .. f:sub(1,-5) .. '</a></li>\n') 
	end
end
