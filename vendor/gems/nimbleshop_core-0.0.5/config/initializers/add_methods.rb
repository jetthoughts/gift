class Fee
  include Mongoid::Document
  field :payment_status, default: 'abandoned'

  has_many    :payment_transactions, dependent:  :destroy
  belongs_to  :payment_method
  validates :payment_method, presence: true

  state_machine :payment_status, initial: :abandoned do

    event(:authorize) { transition abandoned:   :authorized }
    event(:pending)   { transition abandoned:   :pending    }
    event(:kapture )  { transition authorized:  :purchased  }
    event(:refund)    { transition purchased:   :refunded   }

    event(:purchase)  { transition [:abandoned,  :pending] =>  :purchased  }
    event(:void)      { transition [:authorized, :pending] =>  :voided     }

    state all - [ :abandoned ] do

    end

    after_transition any => :purchased do |fee|
      fee.run_purchase_notify if fee.respond_to?(:run_purchase_notify)
    end

  end

  scope :purchased, where(:payment_status => 'purchased')
end