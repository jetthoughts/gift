class Project
  PAID_TYPES = [:pay_pal, :money_transfer, :amazon_voucher]
  END_TYPES = [:fixed_amount, :open_end]
  include Mongoid::Document
  include Mongoid::Timestamps

  field :name,                              type: String
  field :description,                       type: String
  field :article_link,                      type: String
  field :participants_add_own_suggestions,  type: Boolean
  field :fixed_amount,                      type: Float
  field :open_end,                          type: DateTime
  field :paid_type,                         type: String
  field :end_type,                          type: String


  ## Validators
  validates :fixed_amount, numericality: true, allow_blank: true
  validates :paid_type, presence: true
  validates :name, presence: true
  validates :fixed_amount, numericality: { if: :fixed_amount? }
  validates :open_end, date: { after: Time.now, if: :open_end? }


  ## Relations
  belongs_to :user


  ## Filters
  before_validation :prepare_end_type


  ## Scopes
  scope :ordered_by_date, -> do
    order_by [[:created_at, :desc]]
  end


  def fixed_amount?
    end_type == 'fixed_amount'
  end

  def open_end?
    end_type == 'open_end'
  end


  private

  def prepare_end_type
    write_attribute(:open_end, nil)     if fixed_amount?
    write_attribute(:fixed_amount, nil) if open_end?
  end
end
