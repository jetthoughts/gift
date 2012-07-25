# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://jashkenas.github.com/coffee-script/

$ ->
  $('#search_modal form button').click (e) ->
    e.preventDefault()
    $('#search_modal .modal-body p').load window.location.pathname.replace(/\/new/, '/amazon_search'),
      q: $('#search_modal form input').val()

  $('#search_modal').modal
    backdrop : true
    keyboard : true
    show     : false
  .css
    'margin-left' : ->
      -($(@).width() / 2)
