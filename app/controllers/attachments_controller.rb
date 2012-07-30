class AttachmentsController < ApplicationController

  before_filter :find_attachment

  def update
    data = { :image => params[:userfile] }
    result = if @attachment.present?
      @attachment.update_attributes(data)
    else
      @attachment = Attachment.new(data)
      @attachment.valid? && @attachment.save!
    end

    if result
      render :json => {:url => @attachment.image.url, :attachment_id => @attachment.id,
        :thumb_url => @attachment.image.thumb.url
      }.to_json
    else
      error = 'An error occurred while loading this picture. Please make sure that the picture format is .png, .jpg, or .gif and that the picture size is less than 5 MB.'
      render :json => { :error => error }.to_json, :status => :unprocessable_entity
    end
  end

  def destroy
    @attachment.destroy if @attachment.present?
    render :nothing => true
  end

  private

    def find_attachment
      @attachment = Attachment.where(:_id => params[:attachment_id]).limit(1).first
    end
end
