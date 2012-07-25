# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://jashkenas.github.com/coffee-script/

$ ->
  $('#search_modal form button').click (e) ->
    e.preventDefault()
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
    url = $.url(@)
    load_search_result url.param('q'), url.param('page')


load_search_result = (query, page = 1)->
  $('#search_modal .modal-body p').load window.location.pathname.replace(/\/new/, '/amazon_search'),
    q: query
    page: page
