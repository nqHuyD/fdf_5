var category = null;
var filter = null;
var current_page = null;

// Pagination Variable
var touch = 0
var remember = 0

$(".category-food-ul a").click(function(e){
  remember = 0
  category = e.target.firstChild.data
  $.ajax({
    url: "/product/category",
    type: "POST",
    data: {category: category, filter: filter, current_page: 1}
  })
})

$(".select_item").change(function(){
  filter = $(this).children("option:selected").val()
  $.ajax({
    url: "/product/filter",
    type: "POST",
    data: {category: category, filter: filter, current_page: current_page}
  })
});
