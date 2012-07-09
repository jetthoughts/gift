#require "uploaders/image_uploader"
#require "carrierwave/mongoid"


class Card
  include Mongoid::Document
  include Mongoid::Timestamps

  #attr_accessible :image, :image_cache
  mount_uploader :image, ImageUploader

  field :description, :type => String
  field :price, :type => Float, :default => 0.0
  field :web_link, :type => String

  belongs_to :project
  belongs_to :user
end
