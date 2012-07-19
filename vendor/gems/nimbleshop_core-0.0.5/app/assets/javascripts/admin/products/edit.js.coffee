$ ->

  # work around the nested form ugliness
  $("form input:file").parents('.fields').hide()

  # deleting a picture
  $(".product_pictures .actions .delete").on "click", ->
    $("#delete_picture_" + $(this).attr("data-action-id")).trigger "click"
    $(this).parent().parent().hide "fast"
    false

  # making picutures sortable
  $(".product_pictures").sortable(update: (e, ui) ->
    orders = {}
    $(".product_pictures li").each (index, el) ->
      orders[index] = $(el).attr("data-id")

    $("#product_pictures_order").attr "value", $.toJSON(orders)
  ).disableSelection()
