$(".fa_product_rank").hover(function(){
  attr = $(this).attr("id")
  product_id = attr.slice(2,3)
  star = attr.slice(0,1)

  for (i=1; i<=5; i++){
    if (i<=star) $(`#${i}_${product_id}_star`).addClass("fachecked");
    else $(`#${i}_${product_id}_star`).removeClass("fachecked");
  }

})

$(".fa_product_rank").click(function(){
  attr = $(this).attr("id")
  product_id = attr.slice(2,3)
  star = attr.slice(0,1)
  console.log(star)
  $.ajax({
    url:"rank",
    type: "POST",
    data:{
      product_id: product_id,
      star: star
    }
  })
})

// Reset Rank After Closing Dialog

$(".btn-close-rating").click(function(){
  attr = $(this).attr("class")
  product_id = attr.slice(23,attr.length)
  $.ajax({
    url: "reset_star",
    type: "POST",
    data:{
      product_id: product_id
    }
  })
})
;
