class Comment
  include Mongoid::Document
  field :text, :type => String

  validates :text, presence: true

  ## Relations
  belongs_to :user
  belongs_to :project
end
