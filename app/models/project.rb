class Project
  include Mongoid::Document

  field :name,                              type: String
  field :description,                       type: String
  field :article_link,                      type: String
  field :participants_add_own_suggestions,  type: Boolean
  field :fixed_amount,                      type: Float
  field :opend_end,                         type: Time
  field :paid_type,                         type: String

  ## Relations
  belongs_to :user

  ## Scopes
  scope :ordered_by_date, -> do
    order_by [[:created_at, :desc]]
  end
end
