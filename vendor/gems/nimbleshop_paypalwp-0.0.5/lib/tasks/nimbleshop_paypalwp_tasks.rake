namespace :nimbleshop_paypalwp do

  desc 'load paypal record'
  task :load_record => :environment do
    if NimbleshopPaypalwp::Paypalwp.find_by_permalink('paypalwp')
      puts "Paypal record already exists"
    else
      NimbleshopPaypalwp::Paypalwp.create!(
        {
          name: 'Paypal website payments standard',
          permalink: 'paypalwp',
          merchant_email: 'seller_1323037155_biz@bigbinary.com',
          description: %Q[<p> Paypal website payments standard is a payment solution provided by paypal which allows merchant to accept credit card and paypal payments.  There is no monthly fee and no setup fee by paypal for this account.  </p> <p> <a href='https://merchant.paypal.com/cgi-bin/marketingweb?cmd=_render-content&content_ID=merchant/wp_standard&nav=2.1.0'> more information </a> </p>]
        })
        puts 'Paypalwp record was successfuly created'
    end
  end

  desc 'copies images from engine to main rails application'
  task :copy_images do
    engine_name = 'nimbleshop_paypalwp'
    origin = File.expand_path('../../app/assets/images', File.dirname(__FILE__))
    destination = Rails.root.join('app', 'assets', 'images', 'engines', engine_name)
    FileUtils.mkdir_p(destination) if !File.exist?(destination)
    Dir[File.join(origin, '**/*')].each { |file| FileUtils.cp(file, File.join(destination) ) unless File.directory?(file) }
  end

end
