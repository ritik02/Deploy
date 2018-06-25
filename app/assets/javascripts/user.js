$(document).ready(function(){
	$('.modal').modal();
	$('select').formSelect();
	$('.tabs').tabs();
});
function button_click(id){
	console.log(id);
	var a = document.getElementById('agree');
	a.href = "/deployments/" + id + "/trigger_deployment"
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
	$('.modal').modal('close');
}