module 'Amazon'

Amazon.Search = class
  setup_form : (form_selector, options) ->
    @form = $(form_selector)
    @form_options = $.extend
      name         : '#name'
      price        : '#price'
      imageUrl     : '#image_url'
      description  : '#description'
      detailsUrl   : '#details_url'
    , options

  setup_image_selector : (@image_selector) ->

  fill_form : ->
    $(@form_options.name, @form).val @data.name
    $(@form_options.description, @form).val @data.description
    $(@form_options.price, @form).val @amount_to_price(@data.amount)
    $(@form_options.imageUrl, @form).val @data.image_url
    $(@form_options.detailsUrl, @form).val @data.details_url

  amount_to_price : (amount) ->
    amount = amount + ''
    [amount.slice(0, -2), '.', amount.slice(-2)].join ''

  location : (action) ->
    window.location.pathname.replace /\/new/, action 
