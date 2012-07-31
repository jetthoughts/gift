class PaidInfo
  include Mongoid::Document
  embedded_in :project
end