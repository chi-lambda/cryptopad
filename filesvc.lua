-- Provides file services to the website
-- takes 2 parameters:
-- file: file to be acted on
-- action: one of the following
--         * create: creates a new folder in the database
--         * delete: deletes a folder with content in the database
--         * cleanup: removes all old revisions from a folder
require"cgilua"
require"lfs"
if cgilua.POST.file then
	local fn = cgilua.POST.file
	-- remove up-dir
	fn = fn:gsub('%.%.', '')
	-- remove leading slashes
	while fn:find('/') == 1 do
		fn = fn:sub(2)
	end
	fn = 'db/' .. fn
	local action = cgilua.POST.action
	if action == 'create' then
		local r, e = lfs.mkdir(fn)
	elseif action == 'delete' then
		os.rename(fn, fn .. '.deleted');
	elseif action == 'cleanup' then
		local now = os.time();
		for f in lfs.dir(fn .. '/') do
			if f:sub(-4) == '.rev' then
				os.rename(fn .. '/' .. f, fn .. '/' .. f .. now)
			end
		end
	end
end
