var last = $(".pagi-page-last").text()

$(".pagination-link").click(function(e){
  var page = e.target.firstChild.data
  if (page == "Next"){
    if (remember == 0) page = 2
    else if (remember == parseInt(last)) {
      $(".next-pagination").addClass("disabled")
      page = parseInt(last)
    }
    else  page = parseInt(remember)+1
  }
  else if (page == "Previous"){
    if(remember == 1 || remember == 0) page =1
    else page = parseInt(remember)-1
  }
  if(page > 0){
    touch = 1
    if (remember!=0) $(`#pagi-id-${remember}`).removeClass("active");

    if (page > 1) $(".previous-pagination").removeClass("disabled");
    if (page < parseInt(last))  $(".next-pagination").removeClass("disabled")
    if (page == parseInt(last)) $(".next-pagination").addClass("disabled")
    $(`#pagi-id-${page}`).addClass("active");
    remember = page
  }
  if (page == 1 && touch == 1) {
    touch = 0
    $(".previous-pagination").addClass("disabled");
  }
  current_page = page
  $.ajax({
    url: "/product/pagination",
    type: "POST",
    data: {current_page: current_page, category: category, filter: filter,
     minrange: minrange , maxrange: maxrange}
  })
})
