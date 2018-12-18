$('.value-plus').on('click', function(){
  var divUpd = $(this).parent().find('.value'), newVal = parseInt(divUpd.text(), 10)+1
  divUpd.text(newVal)
  var checkout_id = $(this).parent().find('.value').attr("id")
  checkout_id = checkout_id.slice(12,checkout_id.length)
   $.ajax({
    url: `/cart/${checkout_id}`,
    type: "PATCH",
    data: {newVal: newVal}
  })
});

$('.value-minus').on('click', function(){
  var divUpd = $(this).parent().find('.value'), newVal = parseInt(divUpd.text(), 10)-1
  if(newVal>=1) divUpd.text(newVal)
  var checkout_id = $(this).parent().find('.value').attr("id")
  checkout_id = checkout_id.slice(12,checkout_id.length)
  $.ajax({
    url: `/cart/${checkout_id}`,
    type: "PATCH",
    data: {newVal: newVal}
  })
});

$('.close').on('click', function(){
  var close_id = $(this).attr("id")
  close_id = close_id.slice(6,close_id.length)
  $.ajax({
    url: `/cart/${close_id}`,
    type: "DELETE"
  })
});
