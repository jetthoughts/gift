# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://jashkenas.github.com/coffee-script/

$ ->
  $('.datetimepicker').datetimepicker
    dateFormat: 'dd/mm/yy'

  $('#close_project_dialog').dialog
    autoOpen  : false
    modal     : true
    resizable : false

    if $('.no_paid_info').length
      buttons:
        "OK" : ->
          $(this).dialog 'close'
          window.location = window.location.href + '/edit'
    else if $('.error').length
      buttons:
        "OK" : ->
          $(this).dialog 'close'
    else
      buttons   :
        "Close"   : ->
          console.log 'Close'
          $(this).dialog 'close'
          $.post("#{window.location.pathname}/close", -> window.location.reload())
        "Cancel"  : ->
          $(this).dialog 'close'

  $('#close_project').click (e)->
    e.preventDefault()
    $('#close_project_dialog').dialog 'open'

  oldId = null
  toggleSpan = (elemClass, isShow = true) ->
    return if elemClass is null
    span = $(".#{elemClass}")
    inputs = span.find('input')
    if isShow
      span.removeClass 'hidden'
      inputs.each -> $(this).prop('disabled', false)
    else
      span.addClass 'hidden'
      inputs.each ->
        console.log this
        $(this).prop('disabled', true)

  checkedElem = $('input:radio[name="project[paid_type]"]:checked')[0]
  if checkedElem
    oldId = $(checkedElem).attr('id')
    toggleSpan(oldId)

  $('input:radio[name="project[paid_type]"]').click ->
    id = $(this).attr('id')
    toggleSpan(oldId, false)
    toggleSpan(id, true)
    oldId = id



