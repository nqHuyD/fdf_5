var type_food = "all"
var status = "all"
$(document).ready(function(){
  setTimeout(function(){
    $('.alert').remove();
  }, 5000);
 })

$(".tooltip_destroy_category").click(function(){
  var attr = $(this).attr("class")
  var category_id = attr.slice(25,attr.length)

  $.ajax({
    url: `/category/${category_id}`,
    type: "DELETE"
  })
})

$(".type_food_admin_select").change(function(){
  type_food = $(this).val()
  sorting_ajax_category()
})

$(".status_food_admin_select").change(function(){
  status = $(this).val()
  sorting_ajax_category()
})

function sorting_ajax_category(){
  $.ajax({
    url: "/admin/sort_category",
    type: "POST",
    data:{
      type_food: type_food,
      status: status
    }
  })
}
;
