$(".notapprove_error_order").click(function(){
  window.location.reload();
})

$(".approve_error_order").click(function(){
  var name =$("#order_name").val()
  var phone = $("#order_phone").val()
  var address = $("#order_address").val()
  var approve = 1

  $.ajax({
    url: "order",
    type: "POST",
    data: {
      order:{
       name: name,
       phone: phone,
       address: address,
       approve: approve
     }
    }
  })
})
;
