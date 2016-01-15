-- lists the files in the database. Ignores all input.
require"cgilua"
require"lfs"
for d in lfs.dir('db/') do
	if lfs.attributes('db/' .. d,'mode') == 'directory' and d ~= '..' and d ~= '.' and d:sub(-8) ~= '.deleted' then
		cgilua.put('<li><a href="' .. d .. '" class="filelink">'.. d ..'</a></li>\n')
	end
end
-- output the input and button to create a new file
cgilua.put('<li><input type="text" id="newfile" size="4" style="border:1px black solid" /><button type="button" id="newbtn">Create</button></li>')
