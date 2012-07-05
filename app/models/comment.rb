class Comment
  include Mongoid::Document
  field :text, :type => String
end
