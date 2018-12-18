var category = null
var type_food = null

$(".product_select_type_food").change(function(){
  type_food = $(this).val()
  $.ajax({
    url: `/admin/category_product_option/${type_food}`,
    type: "GET"
  })
})

$(".ajax_product_select_category").click(function(){
  category_product = $(this).val()
  $.ajax({
    url: `/admin/category_product_append/${category_product}`,
    type: "GET"
  })
})

$(".tooltip_destroy_product").click(function(){
  var attr = $(this).attr("class")
  var product_id = attr.slice(24,attr.length)
  $.ajax({
    url:`/admin/product_destroy/${product_id}`,
    type: "DELETE"
  })
})

$(".alert").fadeOut(3000);

// Filter Product Admin Data

$(".type_food_product_admin_select").click(function(){
  var type = $(this).val();
  type_food = type
  $.ajax({
    url: "/admin/type_product_choice",
    type: "POST",
    data:{
      type_food: type_food,
      category: null
    }
  })
})

$(".type_category_admin_admin_select").click(function(){
  category = $(this).val()
  $.ajax({
    url: "/admin/type_product_choice",
    type: "POST",
    data:{
      type_food: type_food,
      category: category
    }
  })
})

$(".role_scroll_active_products").click(function(){
  var attr = $(this).attr("id");
  var active = $(this).attr("value");
  var products_id = attr.slice(18,attr.length);
  $.ajax({
    url: `/admin/active_update_products/${products_id}`,
    type: "PATCH",
    data:{
      active: active
    }
  })
})
