require"aeslua"
if cgilua.POST.file and cgilua.POST.password then
	local f
	local fn = cgilua.POST.file
	-- remove up-dir
	fn = fn:gsub('%.%.', '')
	-- remove leading slashes
	while fn:find('/') == 1 do
		fn = fn:sub(2)
	end
	fn = 'db/' .. fn .. '/'
	if cgilua.POST.rev then
		f = io.open(fn .. cgilua.POST.rev .. '.rev','rb')
	else
		f = io.open(fn .. 'current','rb')
	end
	if f then
		cgilua.put(aeslua.decrypt(cgilua.POST.password or "", f:read('*a'), aeslua.AES256, aeslua.CBCMODE) or 'error')
		f:close()
	end
end
