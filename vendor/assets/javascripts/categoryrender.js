var category = null;
var filter = null;
var current_page = null;
var minrange = null;
var maxrange = null;

// Pagination Variable
var touch = 0
var remember = 0

$(".category-food-ul a").click(function(e){
  remember = 0
  category = e.target.firstChild.data
  $.ajax({
    url: "/product/category",
    type: "POST",
    data: {category: category, filter: filter,
      current_page: 1, minrange: minrange, maxrange: maxrange}
  })
})

$(".select_item").change(function(){
  filter = $(this).children("option:selected").val()
  $.ajax({
    url: "/product/filter",
    type: "POST",
    data: {category: category, filter: filter, current_page: current_page,
      minrange: minrange, maxrange: maxrange}
  })
});

$(".filter_button_submit").click(function(){
  var min = $("#range-slider-1").val();
  var max = $("#range-slider-2").val();

  // Keep Tracking Min and Max Range When Changing Category and Filter
  minrange = min
  maxrange = max
  //

  $.ajax({
    url: "/product/range_price",
    type: "POST",
    data: {category: category, filter: filter, current_page: current_page,
      minrange: min , maxrange: max
    }
  })
})
