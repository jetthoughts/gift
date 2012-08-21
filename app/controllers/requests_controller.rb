require 'net/http'
class RequestsController < ActionController::Base

  caches_action :fetch, :parse

  before_filter :get_html

  def fetch
    render :text => @html
  end

  def parse
    doc = Nokogiri::HTML(@html)
    meta_title = doc.css("meta[name='og:name']").first
    title = meta_title ? meta_title['content'] : doc.title
    meta_desc = doc.css("meta[name='description']").first
    description = meta_desc ? meta_desc['content'] : ''
    images = doc.css('body img').map { |i| i['src'] }.reject { |src| (src=~/^http.*png|jpg$/).nil? }
    res = { :amount => '',
            :details_url => @url,
            :image_url => images.first,
            :name => title,
           :description => description,
           :images => images }
    render :json => res
  end

  private

  def get_html
    @url = params['url'] || ''
    @html = ''
    begin
      @html = Net::HTTP.get(URI(@url))
    rescue
    end
  end

end
