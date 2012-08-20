class Card
  include Mongoid::Document
  include Mongoid::Timestamps
  include Mongo::Voteable

  #attr_accessible :image, :image_cache
  mount_uploader :image, ImageUploader

  field :description, type: String
  field :price, type: Float
  field :web_link, type: String
  field :name, type: String

  after_create :created_event

  voteable self, up: +1, down: -1
  belongs_to :project
  belongs_to :user

  validates :web_link, url: {allow_blank: true}

  validates :project, :name, presence: true

  scope :ordered_by_date, -> do
    order_by [[:created_at, :desc]]
  end

  private

  def created_event
    UpdateNotification.new_card_created_event self
  end
end
