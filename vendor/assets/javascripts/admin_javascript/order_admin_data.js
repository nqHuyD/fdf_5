$(".status_process_admin").click(function(){
  var attr = $(this).attr("id");
  var order_id = attr.slice(23,attr.length)
  var status = attr.slice(21,22)

  $.ajax({
    url: `/order/${order_id}`,
    type: "PATCH",
    data:{
      status: status
    }
  })
})
