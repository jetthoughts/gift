module 'Amazon'

Amazon.ImageSelector = class
  constructor : (modal_selector) ->
    @modal = $(modal_selector)
    @bind()

  bind : ->
    $('#prev_image', @modal).click (e) =>
      @prev_image()
    $('#next_image', @modal).click (e) =>
      @next_image()
      
  next_image : ->
    next = @current_image().next()
    if next.length > 0
      @set_current_image next
      @inc_current_counter()

  prev_image : ->
    prev = @current_image().prev()
    if prev.length > 0
      @set_current_image prev
      @dec_current_counter()

  open : ->
    @modal.modal 'show'

  add_image_links : (links) ->
    $.each links, (index, link) =>
      $('.modal-body ul', @modal).append "<li><img src='#{link}'/></li>"
    @set_current_image $('.modal-body ul li').first()
    @set_all_counter links.length
    @set_current_counter 1 if links.length > 0

  set_current_image : (list_item) ->
    $('#image', @modal).attr('src', list_item.find('img').attr('src'))
    $('.modal-body ul li').removeClass 'current'
    list_item.addClass 'current'

  current_image : ->
    $('.modal-body ul li.current', @modal)

  set_current_counter : (number) ->
    $('.current_count', @modal).text(number)

  set_all_counter : (number) ->
    $('.count', @modal).text(number)

  inc_current_counter : ->
    counter = $('.current_count', @modal)
    counter.text parseInt(counter.text()) + 1
  dec_current_counter : ->
    counter = $('.current_count', @modal)
    counter.text parseInt(counter.text()) - 1

