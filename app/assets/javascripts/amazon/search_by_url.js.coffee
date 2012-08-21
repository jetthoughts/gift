module 'Amazon'

Amazon.SearchByURL = class extends Amazon.Search

  constructor: (link_input_selector) ->
    @link_input = $(link_input_selector)
    @bind()

  bind: ->
    @link_input.change (e) =>
      @url = @link_input.val()
      @link_input.attr "disabled", "disabled"
      if @url.search(/amazon\./i) > -1
        @get_data
      else
        @fetch_rest_link(@url)
    $.ajaxSetup
      complete: =>
        @link_input.removeAttr "disabled"

  get_data: () =>
    $.ajax
      url: @location()
      type: "POST"
      dataType: 'json'
      success: @success_handler
      data:
        q: @asin()

  asin: ->
    @asin_val = @parsed_url().segment(3)

  parsed_url: ->
    @parsed_url_val ||= $.url(@url)

  location: ->
    super '/amazon_lookup'

  fetch_rest_link: (link)->
    url = link

    $.ajax '/parse',
      type: 'GET'
      data:
        url: url
      dataType: 'json',
      error: (jqXHR, textStatus, errorThrown) =>
      success: @success_handler

  success_handler: (data) =>
    @data = data
    @image_selector.add_image_links @data.images
    @image_selector.update_form()
    @fill_form()
