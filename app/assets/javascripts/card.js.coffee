# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://jashkenas.github.com/coffee-script/

$ ->
  $('#search_modal button').click (e) ->
    e.preventDefault()
    console.log 'test'
    $('#search_modal .modal-body p').load window.location.pathname.replace(/\/new/, '/amazon_search'),
      q: $('#search_modal form input').val()
