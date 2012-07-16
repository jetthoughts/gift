class Fee
  include Mongoid::Document
  include Mongoid::Timestamps

  belongs_to :user
  belongs_to :project

  validates :project, :user, presence: true


  def complete_paypal(token, payer_id)
    if (@response = paypal.purchase(project.fee_in_cents, {:token => token, :payer_id => payer_id, :description => description})).success?
      save
    else
      errors.add_to_base("PayPal Error: #{@response.message}")
      false
    end
  end


  def start_paypal(return_url, cancel_return_url)
    if (@response = paypal.setup_purchase(project.fee_in_cents,{:return_url => return_url, :cancel_return_url => cancel_return_url, :description => description})).success?
      paypal.redirect_url_for(@response.params['token'])
    else
      errors.add_to_base("PayPal Error: #{@response.message}")
      false
    end
  end

  private

  def paypal
    @paypal ||=  ActiveMerchant::Billing::Base.gateway(:paypal_express).new(config_from_file('paypal.yml'))
  end

  def config_from_file(file)
    YAML.load_file(File.join(Rails.root, 'config', file))[Rails.env].symbolize_keys
  end

  def description
    'Your fee in donation'
  end
end