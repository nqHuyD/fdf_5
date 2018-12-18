$('.value-plus1').on('click', function(){
    var divUpd = $(this).parent().find('.value1'), newVal = parseInt(divUpd.text(), 10)+1;
    divUpd.text(newVal);
  });

  $('.value-minus1').on('click', function(){
    var divUpd = $(this).parent().find('.value1'), newVal = parseInt(divUpd.text(), 10)-1;
    if(newVal>=1) divUpd.text(newVal);
});
