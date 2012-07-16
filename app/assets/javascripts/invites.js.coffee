# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://jashkenas.github.com/coffee-script/

$ ->
  $('#add_email_participant').click ->
    elem = $('#new_invite .email_participant:first')
    elem.clone().find('input').val('').end().appendTo $('#by_email')
    return false

