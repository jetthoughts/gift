$ ->

  # Handle cancel on payment form
  $(".nimbleshop-payment-method-form .cancel").click ->
    $this = $(this)
    div = $this.closest(".nimbleshop-payment-method-form-well")
    div.hide()  if div.length
    false

  # edit a payment form
  $(".nimbleshop-payment-method-edit").click ->
    $this = $(this)
    well = $this.parent("div").find(".nimbleshop-payment-method-form-well")
    if well.length
      if well.is(":visible")
        well.hide()
      else
        well.show()
    false
