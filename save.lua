-- Saves text to file. Has up to 4 parameters:
-- file: the name of the files
-- text: the text to be encrypted and saved
-- password: the password used for encryption
-- newrev: optional, content ignored; forces a new revision to be created
require"aeslua"
require"lfs"
if cgilua.POST.file and cgilua.POST.text and cgilua.POST.password then
	local fn = cgilua.POST.file
	-- remove up-dir
	fn = fn:gsub('%.%.', '')
	-- remove leading slashes
	while fn:find('/') == 1 do
		fn = fn:sub(2)
	end
	fn = 'db/' .. fn .. '/'
	-- find all the revision files
	local revisions = {}
	for d in lfs.dir(fn) do
		if d:sub(-4) == '.rev' then
			table.insert(revisions, d)
		end
	end
	-- function to find the oldest revision
	local max_date = function(files)
		local m = 0
		for _, f in ipairs(files) do
			m = math.max(m, lfs.attributes(fn .. f, 'modification'))
		end
		return m
	end
	-- try to open current revision to check if it exists yet
	-- or if it is a new file
	local f = io.open(fn .. 'current')
	if f then
		f:close()
		date_of_last_rev = max_date(revisions)
		date_of_curr_rev = lfs.attributes(fn .. 'current', 'modification')
		size_of_last_rev = lfs.attributes(fn .. 'current', 'size')
		-- if forcing a new revision (sent parameter "newrev"
		-- or last revision is more than an hour older than the current file
		-- or delta is more than 100 characters, make a new revision
		if
			cgilua.POST.newrev or
			os.difftime(date_of_curr_rev, date_of_last_rev) > 3600 or -- last revision older than an hour
			math.abs(size_of_last_rev - #(cgilua.POST.text)) > 100
		then
			cgilua.put('new revision.')
			os.rename(fn .. 'current', fn .. (#revisions+1) .. '.rev')
		end
	end
	-- write text to current, encrypt with AES-256 cipher block chaining
	f = io.open(fn .. 'current', 'wb')
	if f then
		f:write(aeslua.encrypt(cgilua.POST.password, cgilua.POST.text, aeslua.AES256, aeslua.CBCMODE))
		cgilua.put('saved.');
		f:close()
	end
end
