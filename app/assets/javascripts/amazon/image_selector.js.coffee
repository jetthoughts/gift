module 'Amazon'

Amazon.ImageSelector = class
  images : []
  current_index: 0
  constructor : (modal_selector) ->
    @modal = $(modal_selector)
    @bind()

  bind : ->
    $('#prev_image').click (e) =>
      @prev_image()
      @update_form()
      false
    $('#next_image').click (e) =>
      @next_image()
      @update_form()
      false
    @modal.on 'hide', =>
      @update_form()

  next_image : ->
    @inc_current_counter() if @current_index < @images.length - 1

  prev_image : ->
    @dec_current_counter() if @current_index > 0

  open : ->
    @modal.modal 'show'

  add_image_links : (links) ->
    @images = []
    return unless links
    #$('.modal-body ul', @modal).html ''
    $.each links, (index, link) =>
      #$('.modal-body ul', @modal).append "<li><img src='#{link}'/></li>"
      @push_image(link)
    @set_all_counter links.length
    @set_current_counter(0)

  push_image : (src) =>
    (@images || []).push src
    @set_all_counter(@images.length)
    @set_current_counter(@images.length - 1)
    @images

  toggle_select_buttons : () ->
    if (@images.length > 1)
      $('#select_buttons').removeClass('hidden')
    else
      $('#select_buttons').addClass('hidden')

  #set_current_image : (list_item) ->
  #  $('#image', @modal).attr('src', list_item.find('img').attr('src'))
  #  $('.modal-body ul li').removeClass 'current'
  #  list_item.addClass 'current'

  current_image : ->
    @images[@current_index]

  set_all_counter : (number) ->
    $('.count').text(number)
    @toggle_select_buttons()

  set_current_counter : (val)->
    counter = $('.current_count')
    @current_index = val
    counter.text parseInt(@current_index + 1)

  inc_current_counter : ->
    @set_current_counter(@current_index + 1)

  dec_current_counter : ->
    @set_current_counter(@current_index - 1)

  update_form : ->
    link = @current_image()
    $(@form_options.imageUrl, @form).val link
    $(@form_options.remoteImagePreview, @form).attr('src', link)

  setup_form : (form_selector, options) ->
    @form = $(form_selector)
    @form_options = $.extend
      imageUrl : '#image_url'
      remoteImagePreview : '#avatar_image'
    , options
