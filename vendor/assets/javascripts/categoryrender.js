var category = null;
var filter = null;
var current_page = null;
var minrange = null;
var maxrange = null;
var rank = null
// Pagination Variable
var touch = 0
var remember = 0

// Filter Category
$(".category_type_choice").click(function(){
  var attr = $(this).attr("class");
  category = attr.slice(21,attr.length)
  $.ajax({
    url: "/product/category",
    type: "POST",
    data: {category: category, filter: filter,
      current_page: 1, minrange: minrange, maxrange: maxrange, rank: rank}
  })
})

// Filter Sorting
$(".select_item").change(function(){
  filter = $(this).children("option:selected").val()
  $.ajax({
    url: "/product/filter",
    type: "POST",
    data: {category: category, filter: filter, current_page: current_page,
      minrange: minrange, maxrange: maxrange, rank: rank}
  })
});

//Filter Range Price
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
      minrange: min , maxrange: max, rank: rank
    }
  })
})

//Filter Ranking
$(".fa_star_filter").hover(function(){
  attr = $(this).attr("id")
  star = attr.slice(0,1)

  for (i=1; i<=5; i++){
    if (i<=star) $(`#${i}_filter_rank`).addClass("fachecked");
    else $(`#${i}_filter_rank`).removeClass("fachecked");
  }

})

$(".fa_star_filter").click(function(){
  attr = $(this).attr("id")
  star = attr.slice(0,1)
  rank = star
  $.ajax({
    url: "/product/rank",
    type: "POST",
    data: {category: category, filter: filter, current_page: current_page,
      minrange: minrange, maxrange: maxrange, rank: rank
    }
  })
})

$(".all_rank_filter").click(function(){
  $(".fa_star_filter").removeClass("fachecked");
  rank = null
  $.ajax({
    url: "/product/rank",
    type: "POST",
    data: {category: category, filter: filter, current_page: current_page,
      minrange: minrange, maxrange: maxrange, rank: null
    }
  })
})
