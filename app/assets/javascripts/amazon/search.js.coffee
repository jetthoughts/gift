module 'Amazon'

Amazon.Search = class
  setup_form : (form_selector, options) ->
    @form = $(form_selector)
    @form_options = $.merge options,
      selectors:
        name         : '#name'
        price        : '#price'
        imageUrl     : '#image_url'
        description  : '#description'
        detailsUrl : '#details_url'

  fill_form : ->
    console.log 2
    console.log @data
    $(@form_options.selectors.name).val @data.name
    $(@form_options.selectors.description).val @data.description
    $(@form_options.selectors.price).val @amount_to_price(@data.amount)
    $(@form_options.selectors.imageUrl).val @data.image_url
    $(@form_options.selectors.detailsUrl).val @data.details_url

  amount_to_price : (amount) ->
    amount = amount + ''
    [amount.slice(0, -2), '.', amount.slice(-2)].join ''

  location : (action) ->
    window.location.pathname.replace /\/new/, action 
