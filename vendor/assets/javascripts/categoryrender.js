var category = null;
var filter = null;
$(".category-food-ul a").click(function(e){
  category = e.target.firstChild.data
  $.ajax({
    url: "/product/category",
    type: "POST",
    data: {category: category, filter: filter}
  })
})

$(".select_item").change(function(){
var filter = $(this).children("option:selected").val()
  $.ajax({
    url: "/product/filter",
    type: "POST",
    data: {category: category, filter: filter}
  })
});
