$(document).ready(function(){
	$('.modal').modal();
});
function button_click(id){
	$('.modal').modal('open');
}
function close_click(){
	$('.modal').modal('close');
}

$(document).ready(function(){
    $('select').formSelect();
});
function setCategory(obj){
	localStorage.setItem("selectedCategory",obj.options[obj.selectedIndex].value);
}
function setOrder(obj){
	localStorage.setItem("selectedOrder",obj.options[obj.selectedIndex].value);
}
document.getElementById("category").value = ""+localStorage.getItem("selectedCategory")+"";
document.getElementById("order").value = ""+localStorage.getItem("selectedOrder")+"";
