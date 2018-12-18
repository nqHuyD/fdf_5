$(".read-trigger").click(function(){
  var attr = $(this).attr("class")
  id = attr.slice(21,attr.length)
  console.log(id);
  $.ajax({
    url: "update_activites",
    type: "POST",
    data: {
      active_id: id
    }
  })
})
