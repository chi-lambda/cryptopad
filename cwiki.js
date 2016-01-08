var saveInterval;
var clearTO;
var saved = true;
var doAutosave = true;
var forceNewRev = false;
var clearFunc;

$(document).ready(function(){
	
	if (location.hash != "") {
		currentFile = location.hash.substring(1);
	} else {
		currentFile = 'test';
		location.hash = currentFile;
	}
	document.title = currentFile;
	
	var clearFunc = function(){
		$('#text').val('');
		$('#password').val('');
		$('#pwrepeat').val('');
		doAutosave = false;
	}
	
	var loadRevisions = function(revs, hilite){
		$('#Revisions').html(revs);
		$('.revlink').css('font-weight', 'normal');
		$('.revlink[href="'+hilite+'"]').css('font-weight', 'bold');
	}
	
	clearTO = window.setTimeout(clearFunc, 300000);
	
	$('.pwfields').keyup(function(){
		if($('#password').val() != $('#pwrepeat').val()) {
			$('#savebtn').attr('disabled', 'disabled');
			$('#newrevbtn').attr('disabled', 'disabled');
			doAutosave = false;
			$('#autosavewarn').show();
		} else {
			$('#savebtn').removeAttr('disabled');
			$('#newrevbtn').removeAttr('disabled');
			doAutosave = true;
			$('#autosavewarn').hide();
		}
	});
	
	$('#text').keyup(function(){
		saved = false;
		$('#saved').hide();
		$('.revlink').css('font-weight', 'normal');
		$('.revlink[href="current"]').css('font-weight', 'bold');
		window.clearTimeout(clearTO);
		clearTO = window.setTimeout(clearFunc, 300000);
	});
	
	$('#loadbtn').click(function(e){
		e.preventDefault();
		$.ajax({
			complete: function(jqXHR, textStatus){
				$('#text').val(jqXHR.responseText);
				$('#pwrepeat').val($('#password').val());
				$('#savebtn').removeAttr('disabled');
				$('#newrevbtn').removeAttr('disabled');
				$('#autosavewarn').hide();
			},
			type : "POST",
			url : "load.lua", data: {
				file: currentFile,
				password:$('#password').val()
			}
		});
		doAutosave = true;
		$('#saved').show();
		$.ajax({
			complete: function(jqXHR, textStatus){
				loadRevisions(jqXHR.responseText,'current');
				$('#pwrepeat').val($('#password').val());
				$('#autosavewarn').hide();
			},
			type : "POST",
			url : "getrevisions.lua", data: {
				file: currentFile,
				password: $('#password').val(),
			}
		});
	})

	$('#savebtn').click(function(e){
		e.preventDefault();
		if (!forceNewRev) {
			$.ajax({
				complete: function(jqXHR, textStatus){
					$.ajax({
						complete: function(jqXHR, textStatus){
							loadRevisions(jqXHR.responseText, 'current');
						},
						type : "POST",
						url : "getrevisions.lua",
						data: {
							file: currentFile
						}
					});
				},
				type : "POST",
				url : "save.lua",
				data: {
					file: currentFile,
					password:$('#password').val(),
					text: $('#text').val()
				}
			});
		} else {
			$.ajax({
				complete: function(jqXHR, textStatus){
					$.ajax({
						complete: function(jqXHR, textStatus){
							loadRevisions(jqXHR.responseText, 'current');
						},
						type : "POST",
						url : "getrevisions.lua",
						data: {
							file: currentFile
						}
					});
				},
				type : "POST",
				url : "save.lua",
				data: {
					file: currentFile,
					password:$('#password').val(),
					text: $('#text').val(),
					newrev: "newrev"
				}
			});
		}
		forceNewRev = false;
		$('#saved').show();
	});
	
	$('#newrevbtn').click(function(e){
		e.preventDefault();
		$.ajax({
			complete: function(jqXHR, textStatus){
				$.ajax({
					complete: function(jqXHR, textStatus){
						loadRevisions(jqXHR.responseText,'current');
					},
					type : "POST",
					url : "getrevisions.lua",
					data: {
						file: currentFile
					}
				});
			},
			type : "POST",
			url : "save.lua", data: {
				file: currentFile,
				password:$('#password').val(),
				text: $('#text').val(),
				newrev: "newrev"
			}
		});
		forceNewRev = false;
		$('#saved').show();
	});
	
	saveInterval = window.setInterval(function(){
		var textval = $('#text').val();
		if (!saved && doAutosave && textval.length > 0) {
			$.ajax({
				complete: function(jqXHR){
					saved = true;
					$('#saved').show();
					$.ajax({
						complete: function(jqXHR, textStatus){
							loadRevisions(jqXHR.responseText,'current');
						},
						type : "POST",
						url : "getrevisions.lua",
						data: {
							file: currentFile
						}
					});
				},
				type : "POST",
				url : "save.lua", data: {
					file: currentFile,
					text: textval,
					password:$('#password').val()
				}
			});
		}
	}, 2000);
	
	$('#Revisions').on('click', '.revlink',  function(e){
		e.preventDefault();
		var rev = $(this).attr('href');
		if (rev == 'current') {
			$.ajax({
				complete: function(jqXHR, textStatus){
					$('#text').val(jqXHR.responseText);
					$('#pwrepeat').val($('#password').val());
					$('#savebtn').removeAttr('disabled');
					$('#newrevtn').removeAttr('disabled');
					$('#autosavewarn').hide();
					$('.revlink').css('font-weight', 'normal');
					$('.revlink[href="'+rev+'"]').css('font-weight', 'bold');
				},
				type : "POST",
				url : "load.lua", data: {
					file: currentFile,
					password: $('#password').val()
				}
			});
			forceNewRev = false;
		} else {
			$.ajax({
				complete: function(jqXHR, textStatus){
					$('#text').val(jqXHR.responseText);
					$('#pwrepeat').val($('#password').val());
					$('#savebtn').removeAttr('disabled');
					$('#newrevbtn').removeAttr('disabled');
					$('#autosavewarn').hide();
					$('.revlink').css('font-weight', 'normal');
					$('.revlink[href="'+rev+'"]').css('font-weight', 'bold');
				},
				type : "POST",
				url : "load.lua",
				data: {
					file: currentFile,
					password: $('#password').val(),
					rev: rev
				}
			});
			forceNewRev = true;
		}
		doAutosave = true;
		$('#saved').show();
		saved = true;
	});
	
	$('#Navigation').on('click', '#newbtn', function(e){
		e.preventDefault();
		$.ajax({
			complete: function(jqXHR){
				$.ajax({
					complete: function(jqXHR, textStatus){
						$('#Navigation').html(jqXHR.responseText);
					},
					url : "getfiles.lua"
				});
			},
			type: 'POST',
			url: 'filesvc.lua',
			data: {
				file: $('#newfile').val(),
				action: 'create'
			}
		});
	});
	
	$('#cleanbtn').click(function(e){
		e.preventDefault();
		$.ajax({
			complete: function(jqXHR){
				$.ajax({
					complete: function(jqXHR, textStatus){
						loadRevisions(jqXHR.responseText,'current');
					},
					type : "POST",
					url : "getrevisions.lua",
					data: {
						file: currentFile
					}
				});
			},
			type: 'POST',
			url: 'filesvc.lua',
			data: {
				file: currentFile,
				action: 'cleanup'
			}
		});
	});
	
	$('#deletebtn').click(function(e){
		e.preventDefault();
		$('#reallydeletebtn').show();
		$('#dontdeletebtn').show();
	});
	
	$('#reallydeletebtn').click(function(e){
		e.preventDefault();
		$.ajax({
			complete: function(jqXHR){
				$.ajax({
					complete: function(jqXHR, textStatus){
						$('#Navigation').html(jqXHR.responseText);
					},
					url : "getfiles.lua"
				});
				$('#Revisions').html('');
			},
			type: 'POST',
			url: 'filesvc.lua',
			data: {
				file: currentFile,
				action: 'delete'
			}
		});
	});
	
	$('#dontdeletebtn').click(function(e){
		e.preventDefault();
		$('#reallydeletebtn').hide();
		$('#dontdeletebtn').hide();
	});
	
	$('#Navigation').on('click', '.filelink', function(e){
		e.preventDefault();
		currentFile = $(this).attr('href');
		document.title = currentFile;
		$('#filename').html(currentFile);
		location.hash = currentFile;
		$('#text').val('');
		$('#password').val('');
		$('#pwrepeat').val('');
		$.ajax({
			complete: function(jqXHR, textStatus){
				$('#Revisions').html(jqXHR.responseText);
				$('.filelink').css('font-weight', 'normal');
				$('.filelink[href="'+currentFile+'"]').css('font-weight', 'bold');
				$('.read').attr('href','read.lp?='+currentFile);
			},
			type : "POST",
			url : "getrevisions.lua", data: {
				file: currentFile
			}
		});
	});
	
	$('.read').click(function(e){
		e.preventDefault();
		if ($(this).attr('target') == '_blank') {
			$('<form method="post" action="read.lp" target="_blank"><input type="hidden" name="password" value="'+$('#password').val()+'" /><input type="hidden" name="file" value="'+currentFile+'" /></form>').submit();
		} else {
			$('<form method="post" action="read.lp"><input type="hidden" name="password" value="'+$('#password').val()+'" /><input type="hidden" name="file" value="'+currentFile+'" /></form>').submit();
		}
	});
	
	$('#privacy').click(function(){
		if (this.checked) {
			$('#text').css('color','#555555');
		} else {
			$('#text').css('color','#FFFFFF');
		}
	});
	
	$('#go_to_edit_page').click(function(e){
		e.preventDefault();
		$('#edit_page').show();
		$('#nav_page').hide();
	});
	
	$('#go_to_nav_page').click(function(e){
		e.preventDefault();
		$('#edit_page').hide();
		$('#nav_page').show();
	});
	
	$.ajax({
		complete: function(jqXHR, textStatus){
			$('#Revisions').html(jqXHR.responseText);
		},
		type : "POST",
		url : "getrevisions.lua", data: {
			file: currentFile
		}
	});
	
	$.ajax({
		complete: function(jqXHR, textStatus){
			$('#Navigation').html(jqXHR.responseText);
			$('.filelink').css('font-weight', 'normal');
			$('.filelink[href="'+currentFile+'"]').css('font-weight', 'bold');
		},
		url : "getfiles.lua", data: {
			file: currentFile
		}
	});
});
