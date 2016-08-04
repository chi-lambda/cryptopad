<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Strict//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-strict.dtd">
<html>
<%
	local script_name = cgilua.servervariable("SCRIPT_NAME"):match(".*/(.*)")
	local path_info = cgilua.servervariable("PATH_INFO"):gsub("[^A-Za-z0-9]", "")
	local base_path = ''
	if path_info == '' then
		path_info = 'test'
	else
		base_path = '../'
	end
%>
<head>
	<meta http-equiv="content-type" content="text/html; charset=UTF-8">
	<meta name="viewport" content="width=device-width" />
	<title></title>
	<link href='<%=base_path%>dr-sugiyama.css' rel='stylesheet' type='text/css' />
	<link type="text/css" href="<%=base_path%>jquery.mobile-1.4.5.min.css" rel="Stylesheet" />
	<link type="text/css" href="<%=base_path%>index.css" rel="Stylesheet" />
	<script src="<%=base_path%>jquery-2.2.0.min.js" type="text/javascript"></script>
	<script src="<%=base_path%>jquery.mobile-1.4.5.min.js" type="text/javascript"></script>
	<script type="text/javascript">
		<% local path_info = cgilua.servervariable("PATH_INFO"):gsub("[^A-Za-z0-9]", "")
		   if path_info == '' then path_info = 'test' end
		%>
		var currentFile = '<%=path_info%>';
		var base_path = '<%=base_path%>';
		var script_name = '<%=script_name%>';
	</script>
	<script src="<%=base_path%>cwiki.js" type="text/javascript"></script>
</head>
<body>
	<div data-role="page" id="nav">
	<div data-role="content">
		<p><a href="#edit">Edit</a> <span class="fontsample">Editor Font</span></p>
		<ul id="Navigation">
		</ul>
		<ul id="Revisions">
			<li>Revisions</li>
		</ul>
	</div>
	</div>
	<div data-role="page" id="edit">
	<div data-role="content" style="overflow-x:visible">
		<a href="#nav">Choose file</a>
		<div id="filename"></div>
		<textarea name="text" id="text" style="background-color:black;color:white"></textarea>
		<div id="controls">
			<input type="password" value="pass" name="password" id="password" size="16" class="pwfields"/>
			<input type="password" value="" name="pwrepeat" id="pwrepeat" size="16" class="pwfields" />
			<button id="loadbtn" type="button" value="load">load</button>
			<button id="savebtn" type="button" value="save" disabled="disabled">save</button>
			<button id="newrevbtn" type="button" value="new revision" disabled="disabled">new revision</button>
			<button id="cleanbtn" type="button" value="clean up">clean up</button>
			<button id="deletebtn" type="button" value="delete">delete</button>
			<button id="reallydeletebtn" type="button" value="delete" style="display:none">yes</button>
			<button id="dontdeletebtn" type="button" value="delete" style="display:none">no</button>
			<label><input type="checkbox" id="privacy" />low-contrast</label>
			<a href="<%=base_path%>help.html" target="_blank"><b>help</b></a>
			<a href="<%=base_path%>read.lp?=" class="read">read</a>
			<a href="<%=base_path%>read.lp?=" class="read" target="_blank">read in new tab</a>
			“” „“ – —
			<span id="autosavewarn" style="display:none">[Autosave disabled]</span>
			<span id="saved" style="display:none">[Saved]</span>
		</div>
	</div>
	</div>
</body>
</html>
