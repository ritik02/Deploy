$(document).ready(function(){
	$('.modal').modal();
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
	var e = document.getElementById("team_email");
	var s = e.options[e.selectedIndex].value;
	var b = a.href + "?team_email=" + s;
	a.href = b;
	$('.modal').modal('close');
}