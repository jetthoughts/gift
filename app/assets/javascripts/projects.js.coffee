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
    buttons   :
      "Close"   : ->
        $(this).dialog 'close'
      "Cancel"  : ->
        $(this).dialog 'close'

  $('#close_project').click (e)->
    e.preventDefault()
    $('#close_project_dialog').dialog 'open'
