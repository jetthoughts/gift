class Project
  PAID_TYPES = [:pay_pal, :money_transfer, :amazon_voucher]
  include Mongoid::Document

  field :name,                              type: String
  field :description,                       type: String
  field :article_link,                      type: String
  field :participants_add_own_suggestions,  type: Boolean
  field :fixed_amount,                      type: Float
  field :open_end,                         type: Time
  field :paid_type,                         type: String


  ## Validators
  validates :fixed_amount, numericality: true, allow_blank: true
  validates :paid_type, presence: true
  validates :name, presence: true


  ## Relations
  belongs_to :user
  has_many :comments


  ## Scopes
  scope :ordered_by_date, -> do
    order_by [[:created_at, :desc]]
  end
end
