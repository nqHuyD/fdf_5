$(".item_add").click(function(e){
  var product_id = e.target.attributes.id.nodeValue
  $.ajax({
    url: "/cart",
    type: "POST",
    data: {product_id: product_id}
  })
})

$(".item_add_with_quantity").click(function(){
  var product_id = $(this).attr("id")
  var quantity = $(".entry_value").text()

  $.ajax({
    url: "/cart",
    type: "POST",
    data: {product_id: product_id, quantity: quantity}
  })
})
