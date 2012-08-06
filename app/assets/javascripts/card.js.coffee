# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://jashkenas.github.com/coffee-script/

$ ->
  $('#search_modal form button').click (e) ->
    e.preventDefault()
    mask_list()
    load_search_result $('#search_modal form input').val()

  $('#search_modal').modal
    backdrop : true
    keyboard : true
    show     : false
  .css
    'margin-left' : ->
      -($(@).width() / 2)

  $('#search_modal .pagination a').live 'click', (e) ->
    e.preventDefault()
    mask_list()
    url = $.url(@)
    load_search_result url.param('q'), url.param('page')

  $('#search_modal .add-gift').live 'click', (e) ->
    e.preventDefault()
    self = $(@)
    add_amazon_gift self
    disabled_link = $('#search_modal .add-gift.disabled')
    disabled_link.removeClass('disabled btn-danger').addClass('btn-success')
    disabled_link.find('i').removeClass('icon-minus').addClass('icon-plus')
    self.find('i').removeClass('icon-plus').addClass('icon-minus')
    self.removeClass('btn-success').addClass('btn-danger disabled')

  $("#search_modal input").autocomplete
    source : (request, response) ->
      $.ajax
        url      : "http://completion.amazon.com/search/complete",
        type     : "GET"
        cache    : false
        dataType : "jsonp"
        success  : (data) ->
          response(data[1])
        data     :
          method   : 'completion'
          client   : 'amazon-search-ui'
          q        : request.term
          'search-alias': 'aps'
          mkt      : 1
          fb       : 0
          xcat     : 0
          sc       : 1


new_location = (action) ->
  window.location.pathname.replace(/\/new/, action)

load_search_result = (query, page = 1)->
  $('#search_modal .modal-body p').load new_location('/amazon_search'),
    q: query
    page: page
  , ->
    unmask_list()

add_amazon_gift = (link)->
  parent      = link.parent()
  amount      = parent.find('.price').data('amount')
  image_url   = parent.find('img').attr('src')
  details_url = parent.find('h4 a').attr('href')
  name        = parent.find('h4 a').text()
  description = parent.find('.product-group').text()

  $('#card_name').val name
  $('#card_description').val description
  $('#card_price').val amount_to_price(amount)
  $('#card_remote_image_url').val image_url
  $('#card_web_link').val details_url

amount_to_price = (amount) ->
  amount = amount + ''
  [amount.slice(0, -2), '.', amount.slice(-2)].join ''

mask_list = ->
  $('#search_modal .modal-body').mask('Loading...')
  $('#search_modal form button').attr('disabled', true)

unmask_list = ->
  $('#search_modal .modal-body').unmask()
  $('#search_modal form button').attr('disabled', false)
