module 'Amazon'

Amazon.SearchByURL = class extends Amazon.Search

  constructor : (@url)

  asin : ->
    @asin = parsed_url.segment(3)

  parsed_url : ->
    @parsed_url ||= $.url(@url)
