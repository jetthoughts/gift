class Comment
  include Mongoid::Document
  include Mongoid::Timestamps

  field :text, :type => String
  validates :text, presence: true

  ## Relations
  belongs_to :user
  belongs_to :project

  ## Scopes
  scope :ordered_by_date, -> do
    order_by [[:created_at, :desc]]
  end
end
