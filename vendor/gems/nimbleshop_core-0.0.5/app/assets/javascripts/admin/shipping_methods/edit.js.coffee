# this fuction handles anytime shipping cost is changed for a state.
# Also when shipment is enabled or disabled for a state.
$ ->
  $(".update-shipping").live "ajax:success", (t, result) ->
    $(t.target).parents("tr").replaceWith result.html

