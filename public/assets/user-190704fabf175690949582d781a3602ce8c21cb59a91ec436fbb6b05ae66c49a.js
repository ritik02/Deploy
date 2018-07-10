$(document).ready(function(){
	$('.modal').modal();
	$('.tabs').tabs();
});
var gitlab_trigger_link
function button_click(id, trigger_link){
	console.log(id);
	console.log(trigger_link);
	var a = document.getElementById('agree');
	a.href = "/deployments/" + id + "/trigger_deployment"
	gitlab_trigger_link = trigger_link
	$('.modal').modal('open');
}
function close_click(){
	$('.modal').modal('close');
}
function agree_click(){
	var a = document.getElementById('agree');
	var dropdown = document.getElementById("team_email");
	var channel_name = document.getElementById("slack_channel").value;
	var team_email = dropdown.options[dropdown.selectedIndex].value;
	var new_url = a.href + "?team_email=" + team_email + "&channel_name=" + channel_name;
	a.href = new_url;
	window.open(gitlab_trigger_link,'_blank')
	$('.modal').modal('close');
}
;
