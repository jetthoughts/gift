# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://jashkenas.github.com/coffee-script/

$ ->
  $('#add_email_participant').click ->
    elem = $('#new_invite .email_participant:first')
    new_elem = elem.clone()
    new_elem.find('input').val('').end().appendTo $('#by_email')
    new_elem.find('.remove_email_participant').removeClass('hidden')
    return false

  $('.remove_email_participant').live 'click', ->
    $(this).parent().remove()
    return false

