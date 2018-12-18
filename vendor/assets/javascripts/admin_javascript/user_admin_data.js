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

$(".role_scroll_active_users").click(function(){
  var attr = $(this).attr("id");
  var active = $(this).attr("value");
  var users_id = attr.slice(15,attr.length);
  $.ajax({
    url: `/admin/active_update_users/${users_id}`,
    type: "PATCH",
    data:{
      active: active
    }
  })
})
