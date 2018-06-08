var didFunction = false;
var isAnySelected = false;
var last_clicked;
$('.row').on('click', function() {
  isAnySelected = false;
  $('input[type=checkbox]', this).prop('checked', function(i, checked){
    return !checked
  })

  if($('input[type=checkbox]', this).prop('checked'))
    $(this).addClass('selected');
  else
    $(this).removeClass('selected');

  if(last_clicked == null)
    last_clicked = $(this)

  select_all($(this))
});

function checkAllRowsIfAnySelected(){
  $('.row').each(
    function(index){
      if($('input[type=checkbox]', this).prop('checked')){
        isAnySelected = true
        console.log("Here : ")
        return false;
      }
    }
  );

}

function select_all(source) {
  //Diable click on commits above selected commit
  $('.row').each(
    function(index){
      if($(this).children()[0].id != source.children()[0].id){
          $(this).off('click')
        //console.log($(this).children()[0].id);
      }else{
        //console.log("In else")
        return false;
      }
    }
  );
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
  checkAllRowsIfAnySelected()
  console.log("isAnySelected "+ isAnySelected)
  if(isAnySelected == false){
    $('.row').each(
      function(index){
            $(this).on('click', function() {
              isAnySelected = false;
              $('input[type=checkbox]', this).prop('checked', function(i, checked){
                return !checked
              })

              if($('input[type=checkbox]', this).prop('checked')){
                $(this).addClass('selected');
                isAnySelected = true;
              }
              else
                $(this).removeClass('selected');

              select_all($(this))
            });
            console.log("In here with : ")
            //console.log($(this))
      }
    );
  }
}
