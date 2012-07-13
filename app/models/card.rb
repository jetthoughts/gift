class Card
  include Mongoid::Document
  include Mongoid::Timestamps
  include Mongo::Voteable

  #attr_accessible :image, :image_cache
  mount_uploader :image, ImageUploader

  field :description, :type => String
  field :price, :type => Float
  field :web_link, :type => String

  voteable self, :up => +1, :down => -1

  validates_presence_of :image
  validates :web_link, :url => {:allow_blank => true}

  belongs_to :project
  belongs_to :user
end
