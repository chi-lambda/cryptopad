<?lua
require"cgilua"
require "aeslua"
?>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Strict//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-strict.dtd">
<html>
<head>
	<meta http-equiv="content-type" content="text/html; charset=UTF-8">
	<title>
	<?lua
	if cgilua.POST.rev then
		cgilua.put(cgilua.POST.file .. ' &ndash; revision ' .. cgilua.POST.rev)
	else
		cgilua.put(cgilua.POST.file .. ' &ndash; current revision')
	end
	?>
	</title>
	<link type="text/css" href="read.css" rel="Stylesheet" />
</head>
<body>
<div id="text">
<?lua
if cgilua.POST.file and cgilua.POST.password then
	local f
	if cgilua.POST.rev then
		f = io.open('db/' .. cgilua.POST.file .. '/' .. cgilua.POST.rev .. '.rev', 'rb')
	else
		f = io.open('db/' .. cgilua.POST.file .. '/current', 'rb')
	end
	text = aeslua.decrypt(cgilua.POST.password,f:read('*a'),aeslua.AES256,aeslua.CBCMODE)
	cgilua.put('<p>')
	text = text:gsub('%[i%]','<i>'):gsub('%[/i%]','</i>')
	text = text:gsub('%[b%]','<b>'):gsub('%[/b%]','</b>')
	text = text:gsub('\n%-%-%-%-\n','</p><hr /><p>')
	text = text:gsub('\n\n','</p><p>')
	cgilua.put(text)
	cgilua.put('</p>')
end
?>
</p>
</body>
</html>