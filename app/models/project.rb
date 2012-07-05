class Project
  include Mongoid::Document

  field :name,                              type: String
  field :description,                       type: String
  field :article_link,                      type: String
  field :participants_add_own_suggestions,  type: Boolean
  field :fixed_amount,                      type: Float
  field :opend_end,                         type: Time
  field :paid_type,                         type: String

  belongs_to :user
end
