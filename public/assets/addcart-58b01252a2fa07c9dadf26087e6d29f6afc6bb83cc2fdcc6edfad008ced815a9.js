$(".item_add").click(function(e){
  var product_id = e.target.attributes.id.nodeValue
  $.ajax({
    url: "/cart",
    type: "POST",
    data: {product_id: product_id}
  })
})
;
