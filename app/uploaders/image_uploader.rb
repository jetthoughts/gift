# encoding: utf-8

class ImageUploader < CarrierWave::Uploader::Base

  # Include RMagick or MiniMagick support:
  include CarrierWave::RMagick
  #include CarrierWave::MiniMagick

  # Include the Sprockets helpers for Rails 3.1+ asset pipeline compatibility:
  # include Sprockets::Helpers::RailsHelper
  # include Sprockets::Helpers::IsolatedHelper

  # Choose what kind of storage to use for this uploader:
  #storage :file
  # storage :fog

  # Override the directory where uploaded files will be stored.
  # This is a sensible default for uploaders that are meant to be mounted:
  def store_dir
    #return '' if file.nil?
    model.class.to_s.underscore
  end

  process :resize_to_fit => [300, 300]

  version :tiny_thumb do
    process :resize_to_fill => [50, 50]
  end

  version :thumb do
    process :resize_to_fill => [150, 150]
  end

  def default_url
    "fallback/" +  [version_name, "default.jpg"].compact.join('_')
  end

  def url
    _url = super
    (_url && _url.starts_with?("/")) ? APP_CONFIG["host"] + _url : _url
  end

  def extension_white_list
    %w(jpg jpeg gif png)
  end

  def filename
    return nil if file.nil?

    ext = CarrierWave::SanitizedFile.new(file).extension || :jpeg
    "#{model.id}.#{ext}"
  end
end
