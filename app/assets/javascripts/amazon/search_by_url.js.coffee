module 'Amazon'

Amazon.SearchByURL = class extends Amazon.Search

  constructor : (link_input_selector) ->
    @link_input = $(link_input_selector)
    @bind()

  bind : ->
    @link_input.change (e) =>
      @url = @link_input.val()
      if @url.search(/amazon\./i) > -1
        @get_data @fill_form

  get_data : (callback) =>
    $.ajax
      url   :  @location()
      type  : "POST"
      dataType : 'json'
      success : (data) =>
        @data =  data
        @image_selector.add_image_links @data.images
        @image_selector.open()
        @show_other_image_button()
        callback.call(@)
      data :
        q : @asin()

  asin : ->
    @asin_val = @parsed_url().segment(3)

  parsed_url : ->
    @parsed_url_val ||= $.url(@url)

  location : ->
    super '/amazon_lookup'
