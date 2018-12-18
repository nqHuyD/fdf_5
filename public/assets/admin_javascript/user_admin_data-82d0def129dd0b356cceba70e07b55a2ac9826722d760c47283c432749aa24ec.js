$(".role_scroll").click(function(){
  var attr = $(this).attr("id");
  var user_id = attr.slice(14,attr.length);
  var role = attr.slice(12,13);
  $.ajax({
    url: "/update_role",
    type: "POST",
    data:{
      id: user_id,
      role: role
    }
  })
})

$(".admin-delete-users").click(function(){
  var attr = $(this).attr("class")
  var user_id = attr.slice(37,attr.length)
  $.ajax({
    url: `/user/${user_id}`,
    type: "DELETE"
  })
})

$(".alert").fadeOut(3000);
