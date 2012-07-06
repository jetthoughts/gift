# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://jashkenas.github.com/coffee-script/

$ ->
  $('#new_comment').live("ajax:complete", (evt, data, status) ->
    $this = $(this)
    $("#comments").append data.responseText
    $this.find("#comment_text").val ""
    $this.find(".form-errors").empty()
  ).live "ajax:error", (evt, data, status) ->
    $(this).find(".form-errors").html data.responseText
