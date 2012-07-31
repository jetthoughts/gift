class AmazonInfo < PaidInfo
  field :name, type: String
  field :destination_name, type: String
  field :destination_address, type: String

  validates_presence_of :name, :destination_name, :destination_address
end
