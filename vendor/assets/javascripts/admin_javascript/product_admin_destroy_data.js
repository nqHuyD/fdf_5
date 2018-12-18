$(".category_product_card_destroy").click(function(){
  var attr = $(this).attr("class")
  var category_id = attr.slice(30,attr.length)
  $.ajax({
    url: `/admin/category_product_destroy/${category_id}`,
    type: "DELETE"
  })
})
