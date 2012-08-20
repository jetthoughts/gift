# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://jashkenas.github.com/coffee-script/

$ ->
  is_projects_page = location.pathname.search("cards") < 0
  id_prefix = if is_projects_page then "project_cards_attributes_0" else "card"
  form_id = if is_projects_page then '#new_project' else '#new_card'
  console.log id_prefix

  image_selector    = new Amazon.ImageSelector('#choose_image')
  search_by_request = new Amazon.SearchByRequest('#search_modal')
  search_by_url     = new Amazon.SearchByURL("##{id_prefix}_web_link")

  form_options = 
    name        : "##{id_prefix}_name"
    price       : "##{id_prefix}_price"
    imageUrl    : "##{id_prefix}_remote_image_url"
    description : "##{id_prefix}_description"
    detailsUrl  : "##{id_prefix}_web_link"

  console.log form_options


  search_by_request.setup_form form_id, form_options
  search_by_url.setup_form     form_id, form_options
  image_selector.setup_form    form_id, form_options

  search_by_request.setup_image_selector image_selector
  search_by_url.setup_image_selector     image_selector
