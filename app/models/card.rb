class Card
  include Mongoid::Document
  include Mongoid::Timestamps

  field :image_path, :type => String
  field :name, :type => String
  field :price, :type => Float
  field :web_link, :type => String
end
