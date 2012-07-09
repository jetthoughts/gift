class Card
  include Mongoid::Document
  include Mongoid::Timestamps

  field :image, :type => String
  field :description, :type => String
  field :price, :type => Float
  field :web_link, :type => String

  belongs_to :project
end
