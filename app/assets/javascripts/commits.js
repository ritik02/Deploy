
var didFunction = false ;

$('.row').on('click', function() {
  $('input[type=checkbox]', this).prop('checked', function(i, checked){
    return !checked
  })

  if($('input[type=checkbox]', this).prop('checked'))
    $(this).addClass('selected');
  else
    $(this).removeClass('selected');

  select_all($(this))
});

function select_all(source) {

  $('.row').each(function(index){
    if($(this).children()[0].id != source.children()[0].id){
      console.log($(this).children()[0].id);
    }else{
      return;
    }
  });
  checkboxes = document.getElementsByName('checkbox');
  for(var i = 0, n = checkboxes.length ; i < n ; i++) {
    //console.log(checkboxes[i].id)
    if(checkboxes[i].id != source.children()[0].id){
      //console.log("in here : " + i + "  " + source.children()[0].checked);
      checkboxes[i].checked = source.children()[0].checked;
      //console.log("Diasabled: "+checkboxes[i].disabled)
      if(source.children()[0].checked == true){
        checkboxes[i].disabled = true
      }
      else{
        checkboxes[i].disabled = false
      }
    }
    else{
      break;
    }
  }
}
