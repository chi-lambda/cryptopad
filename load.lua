openssl = require"openssl"
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
		aes = openssl.cipher.get('aes-256-cbc')
		key, iv = aes:BytesToKey(cgilua.POST.password or "")
		plaintext, message = aes:decrypt(f:read('*a'), key, iv)
		cgilua.put(plaintext or message)
		f:close()
	end
end
