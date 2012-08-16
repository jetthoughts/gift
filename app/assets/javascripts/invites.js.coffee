# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://jashkenas.github.com/coffee-script/

$ ->
  $('.add_participant').click ->
    href = $(this).data('href')
    elem = $(href).find('.participant:first')
    new_elem = elem.clone()
    new_elem.find('input').val('').end().appendTo $(href)
    new_elem.find('.remove_participant').removeClass('hidden')
    return false

  $('.remove_participant').live 'click', ->
    $(this).parent().remove()
    return false

