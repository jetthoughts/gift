$ ->
  data = $("#product-group-condition-klass").data()
  $(".condition .field").live "change", (evt) ->
    $target = $(evt.target).siblings("input.value").val("").end()
    $select = $target.siblings("select.operator").html("")
    fieldType = $.grep(data.fields, (element) ->
      ("" + element.id) is $target.val()
    )[0].field_type
    $.each data.operators[fieldType], (i, element) ->
      $select.append $("<option />",
        value: element.value
        text: element.name
      )

    false

  $(".add-condition").live "click", (evt) ->
    index = +$(".condition:last").data().index
    params = $.extend(
      index: index + 1
    , data)
    $(".condition:last").after Mustache.to_html($("#product_template").html(), params)
    false

  $(".remove-condition").live "click", (evt) ->
    $condition = $(evt.target).parents(".condition")
    $.each $condition.find(":input:not(:hidden)"), (i, element) ->
      $(element).remove()

    $condition.find(".remove-condition").remove()
    $condition.find(".destroy-flag").val "1"
    false

