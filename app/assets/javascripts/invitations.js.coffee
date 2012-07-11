# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://jashkenas.github.com/coffee-script/

$ ->
  $('#add_email_participant').click ->
    elem = $('form.new_user .email_participant:first')
    elem.clone().appendTo $('#by_email')
    return false

