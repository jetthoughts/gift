class Comment
  include Mongoid::Document
  field :text, :type => String

  ## Relations
  belongs_to :user
end
