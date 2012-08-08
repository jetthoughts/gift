module 'Amazon'

Amazon.SearchByRequest = class extends Amazon.Search

  constructor : (modal_selector) ->
    @modal = $(modal_selector)
    @bind()
    @completion()

  bind : ->
    $('.add-gift', @modal).live 'click', @click_add_gift
    $('form button', @modal).click @click_search_button
    $('.pagination a', @modal).live 'click', @click_pagination_link

    @modal.modal
      backdrop : true
      keyboard : true
      show     : false
    .css
      'margin-left' : ->
        -($(@).width() / 2)
  
  completion : ->
    $("input", @modal).autocomplete
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

  click_pagination_link : (e) =>
    e.preventDefault()
    @mask_list()
    url = $.url(e.target)
    @load_results url.param('q'), url.param('page')

  click_search_button : (e) =>
    e.preventDefault()
    @mask_list()
    @load_results $('form input', @modal).val()

  click_add_gift : (e) =>
    e.preventDefault()
    link = $(e.target)

    @get_data link
    @fill_form()

    @image_selector.add_image_links link.parent().data('image-links')
    @close()
    @image_selector.open()

    @disable_add_links()
    @enable_add_link link

  close : ->
    @modal.modal 'hide'

  get_data : (item) ->
    parent = item.parent()
    @data = 
      amount      : parent.find('.price').data('amount')
      image_url   : parent.find('img').attr('src')
      details_url : parent.find('h4 a').attr('href')
      name        : parent.find('h4 a').text()
      description : parent.find('.product-group').text()

  load_results : (query, page = 1)->
    $('.modal-body p', @modal).load @location(),
      q: query
      page: page
    , =>
      @unmask_list()

  disable_add_links : ->
    disabled_link = $('.add-gift.disabled', @modal)
    disabled_link.removeClass('disabled btn-danger').addClass('btn-success')
    disabled_link.find('i').removeClass('icon-minus').addClass('icon-plus')

  enable_add_link : (link)->
    link
      .removeClass('btn-success')
      .addClass('btn-danger disabled')
      .find('i')
      .removeClass('icon-plus')
      .addClass('icon-minus')

  location : ->
    super '/amazon_search'

  mask_list : ->
    $('.modal-body', @modal).mask('Loading...')
    $('form button', @modal).attr('disabled', true)
  
  unmask_list : ->
    $('.modal-body', @modal).unmask()
    $('form button', @modal).attr('disabled', false)
