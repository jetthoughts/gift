module 'Amazon'

Amazon.ImageSelector = class
  construct : (modal_selector) ->
    @modal = $(modal_selector)

  bind : ->
    $('#prev_image', @modal).click (e) =>
      @prev_image()
    $('#next_image', @modal).click (e) =>
      @next_image()
      
  next_image : ->
    true

  prev_image : ->
    true

  add_image_links : (links) ->
    console.log links
    $.each links, (index, link) ->
      $('.modal-body ul', @modal).append($("<li><img src='#{link}'/></li>"))

