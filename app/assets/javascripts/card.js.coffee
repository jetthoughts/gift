# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://jashkenas.github.com/coffee-script/

$ ->
  search_by_request = new Amazon.SearchByRequest('#search_modal')
  search_by_url     = new Amazon.SearchByURL('#card_web_link')

  form_options = 
    selectors :
      name        : '#card_name'
      price       : '#card_price'
      imageUrl    : '#card_remote_image_url'
      description : '#card_description'
      detailsUrl  : '#card_web_link'

  search_by_request.setup_form '#new_card', form_options
  search_by_url.setup_form '#new_card', form_options
