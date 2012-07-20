$ ->
  $("a.ship-items-link").click ->
    $(this).hide()
    $("#ship_items_action_box").show()
    false


$("#ship_items_cancel").live "click", ->
  $("a.ship-items-link").show()
  $("#ship_items_action_box").hide()
