function setCategory(obj){
	localStorage.setItem("selectedCategory",obj.options[obj.selectedIndex].value);
}
function setOrder(obj){
	localStorage.setItem("selectedOrder",obj.options[obj.selectedIndex].value);
}
document.getElementById("category").value = ""+localStorage.getItem("selectedCategory")+"";
document.getElementById("order").value = ""+localStorage.getItem("selectedOrder")+"";
