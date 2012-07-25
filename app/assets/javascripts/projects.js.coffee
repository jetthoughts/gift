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
        csrf_token = $('meta[name=csrf-token]').attr('content')
        csrf_param = $('meta[name=csrf-param]').attr('content')
        $("<form action='#{window.location.pathname}/close' method='post'>
        <input name='#{csrf_param}' value='#{csrf_token}' type='hidden'/>
        </form>").submit()


      "Cancel"  : ->
        $(this).dialog 'close'

  $('#close_project').click (e)->
    e.preventDefault()
    $('#close_project_dialog').dialog 'open'
