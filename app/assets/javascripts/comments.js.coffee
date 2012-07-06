# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://jashkenas.github.com/coffee-script/

$ ->
  $('#new_comment').live("ajax:success", (evt, data, status, xhr) ->
    $this = $(this)

    $("#comments").prepend data
    $this.find("#comment_text").val ""
    $this.find(".form-errors").empty
  ).live "ajax:error", (evt, xhr, status, error) ->
    $(this).find(".form-errors").html xhr.responseText