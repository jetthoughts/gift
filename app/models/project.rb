class Project
  PAID_TYPES = [:pay_pal, :money_transfer, :amazon_voucher]
  PAID_TYPES_CLASSES = %w(BankInfo AmazonInfo PayPalInfo)
  END_TYPES = [:fixed_amount, :open_end]
  MIN_WITHDRAW = 10

  include Mongoid::Document
  include Mongoid::Timestamps

  field :name, type: String
  field :description, type: String
  field :article_link, type: String
  field :participants_add_own_suggestions, type: Boolean
  field :fixed_amount, type: Float
  field :deadline, type: DateTime
  field :paid_type, type: String
  field :end_type, type: String
  field :currency, type: String, default: 'EUR'
  field :closed, type: Boolean, default: false

  ## Validators
  validates :paid_type, inclusion: {in: Project::PAID_TYPES.map(&:to_s), message: ''}
  validates :end_type, inclusion: Project::END_TYPES.map(&:to_s)
  validates :name, presence: true
  validates :fixed_amount, numericality: {greater_than_or_equal_to: MIN_WITHDRAW, if: :fixed_amount?}
  validates :deadline, date: {after: Time.now}
  validates :article_link, :url => {:allow_blank => true}

  ## Relations
  belongs_to :admin, :class_name => 'User', :inverse_of => :own_project, :foreign_key => "admin_id"
  has_and_belongs_to_many :users
  has_many :comments
  has_many :cards
  has_many :invites, dependent: :destroy
  has_many :fees
  has_many :withdraws
  has_many :update_notifications
  embeds_one :paid_info

  accepts_nested_attributes_for :paid_info, allow_destroy: true, reject_if: proc { |attributes| !PAID_TYPES_CLASSES.include?(attributes[:_type]) or attributes.all? {|k,v| k == '_type' ? true : v.blank?}}

  belongs_to :attachment

  ## Filters
  before_validation :prepare_end_type
  before_update :send_updated_event

  ## Scopes
  scope :ordered_by_date, -> do
    order_by [[:created_at, :desc]]
  end

  def amount_percent
    if fixed_amount.present? and fixed_amount > 0
      donated_amount / fixed_amount
    end
  end

  def fixed_amount?
    end_type == 'fixed_amount'
  end

  def open_end?
    end_type == 'open_end'
  end

  def participant? user
    users.for_ids(user.id).exists?
  end

  # available for withdraw
  def available_amount
    donated_amount - already_withdrawed
  end

  def already_withdrawed
    self.withdraws.sum(:amount).to_f
  end

  # how much was donated
  def donated_amount
    self.fees.purchased.sum(:amount).to_f
  end

  def donated_amount_from(user)
    self.fees.purchased.where(:user_id => user.id).sum(:amount).to_f
  end

  def can_withdraw?
    self.available_amount >= MIN_WITHDRAW
  end

  def visible_fee_amount_from(user)
    self.fees.purchased.where(user_id: user.id, visible: true).sum(:amount)
  end

  def image
    current_attachment.image
  end

  def image_thumb
    image.thumb
  end

  def run_notify_users_about_close
    delay.notify_users_about_close
  end

  def notify_users_about_close
    users.each do |user|
      CloseProjectMailer.notify_user(self, user).deliver if user != admin
    end
  end

  private

  def send_updated_event
    UpdateNotification.project_updated_event self
  end

  def current_attachment
    attachment ? attachment : Attachment.new
  end

  def prepare_end_type
    write_attribute(:open_end, nil) if fixed_amount?
    write_attribute(:fixed_amount, nil) if open_end?
  end
end
