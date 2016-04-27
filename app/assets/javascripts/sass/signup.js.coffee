$ ->
  console.log("signup page loaded");
  $("#signup").click (event)->
    MAGNIFY.openModal("<div style='color: white'>Loading...</div>")
    $("form").submit();
