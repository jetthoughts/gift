class ActiveAdminComment
  include Mongoid::Document
  include Mongoid::Timestamps

  field :resource_id, :type => String
  field :resource_type, :type => String
  field :namespace, :type => String
  field :body, :type => String
  belongs_to :author, polymorphic: true

end