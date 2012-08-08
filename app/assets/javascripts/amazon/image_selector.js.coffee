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
    @modal.on 'hide', =>
      @update_form()
      
  next_image : ->
    next = @current_image().next()
    console.log next
    if next.length > 0
      @set_current_image next
      @inc_current_counter()

  prev_image : ->
    prev = @current_image().prev()
    console.log prev
    if prev.length > 0
      @set_current_image prev
      @dec_current_counter()

  open : ->
    @modal.modal 'show'

  add_image_links : (links) ->
    $('.modal-body ul', @modal).html ''
    $.each links, (index, link) =>
      $('.modal-body ul', @modal).append "<li><img src='#{link}'/></li>"
    @set_current_image $('.modal-body ul li', @modal).first()
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

  update_form : ->
    link = @current_image().find('img').attr('src')
    console.log  link
    $(@form_options.imageUrl, @form).val link
    $(@form_options.remoteImagePreview, @form).attr('src', link)

  setup_form : (form_selector, options) ->
    @form = $(form_selector)
    @form_options = $.extend
      imageUrl : '#image_url'
      remoteImagePreview : '#remote_image_preview'
    , options
