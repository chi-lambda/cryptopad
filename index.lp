<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Strict//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-strict.dtd">
<html>
<%
	local base_path, script_name = cgilua.servervariable("SCRIPT_NAME"):match("(.*/)(.*)")
%>
<head>
	<meta http-equiv="content-type" content="text/html; charset=UTF-8">
	<meta name="viewport" content="width=device-width" />
	<title></title>
	<link href='<%=base_path%>dr-sugiyama.css' rel='stylesheet' type='text/css' />
	<link type="text/css" href="<%=base_path%>index.css" rel="Stylesheet" />
	<script src="<%=base_path%>jquery-2.2.0.min.js" type="text/javascript"></script>
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
	<div id="edit_page" style="display:none">
		<a href="#" id="go_to_nav_page" class="nav_links">Choose file</a>
		<div id="filename"></div>
		<div id="textwrap"><textarea name="text" id="text"></textarea></div>
		<div id="controls">
			<input type="password" value="pass" name="password" id="password" size="16" class="pwfields"/>
			<input type="password" value="" name="pwrepeat" id="pwrepeat" size="16" class="pwfields" />
			<button id="loadbtn" type="button" value="load">l</button>
			<button id="savebtn" type="button" value="save" disabled="disabled">s</button>
			<button id="newrevbtn" type="button" value="new revision" disabled="disabled">nr</button>
			<button id="cleanbtn" type="button" value="clean up">cu</button>
			<button id="deletebtn" type="button" value="delete">d</button>
			<button id="reallydeletebtn" type="button" value="delete" style="display:none">y</button>
			<button id="dontdeletebtn" type="button" value="delete" style="display:none">n</button>
			<label><input type="checkbox" id="privacy" />lc</label>
			<a href="<%=base_path%>help.html" target="_blank"><b>h</b></a>
			<a href="<%=base_path%>read.lp?=" class="read">r</a>
			<a href="<%=base_path%>read.lp?=" class="read" target="_blank">nt</a>
			“” „“ – —
			<span id="autosavewarn" style="display:none">[Autosave disabled]</span>
			<span id="saved" style="display:none">[Saved]</span>
		</div>
	</div>
	<div id="nav_page">
		<p><a href="#" id="go_to_edit_page">Edit</a> <span class="fontsample">Editor Font</span></p>
		<ul id="Navigation">
		</ul>
		<ul id="Revisions">
			<li>Revisions</li>
		</ul>
	</div>
</body>
</html>
