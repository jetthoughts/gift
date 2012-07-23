namespace :paypal do

  desc 'load Authorize.net record'
  task :load_record => :environment do
    mode = PaymentMethod.mode
    if Paypal::Paypalwp.where(:mode => mode, :permalink => 'paypalwp').any?
      puts "Paypal record already exists"
    else
      Paypal::Paypalwp.create!(
          {
              mode: mode, 
              name: 'Paypal website payments standard',
              permalink: 'paypalwp',
              description: %Q[<p> Paypal website payments standard is a payment solution provided by paypal which allows merchant to accept credit card and paypal payments.  There is no monthly fee and no setup fee by paypal for this account.  </p> <p> <a href='https://merchant.paypal.com/cgi-bin/marketingweb?cmd=_render-content&content_ID=merchant/wp_standard&nav=2.1.0'> more information </a> </p>]
          })
      puts 'Paypalwp record was successfuly created'
    end
  end
end
