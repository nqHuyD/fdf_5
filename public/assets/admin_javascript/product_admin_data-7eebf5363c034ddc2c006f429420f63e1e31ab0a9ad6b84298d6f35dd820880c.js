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
