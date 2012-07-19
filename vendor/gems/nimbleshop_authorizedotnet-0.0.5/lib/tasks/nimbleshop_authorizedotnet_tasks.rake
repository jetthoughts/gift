
namespace :nimbleshop_authorizedotnet do

  desc 'copies images from engine to main rails application'
  task :copy_images do
    engine_name = 'nimbleshop_authorizedotnet'
    origin = File.expand_path('../../app/assets/images', File.dirname(__FILE__))
    destination = Rails.root.join('app', 'assets', 'images', 'engines', engine_name)
    FileUtils.mkdir_p(destination) if !File.exist?(destination)
    Dir[File.join(origin, '**/*')].each { |file| FileUtils.cp(file, File.join(destination) ) unless File.directory?(file) }
  end

  desc 'load Authorize.net record'
  task :load_record => :environment do

    if NimbleshopAuthorizedotnet::Authorizedotnet.find_by_permalink('authorizedotnet')
      puts "Authorize.net record already exists"
    else
      NimbleshopAuthorizedotnet::Authorizedotnet.create!(
        {
          login_id: Nimbleshop.config.authorizedotnet.login_id,
          transaction_key: Nimbleshop.config.authorizedotnet.transaction_key,
          company_name_on_creditcard_statement: 'Nimbleshop LLC',
          name: 'Authorize.net',
          permalink: 'authorizedotnet',
          description: %Q[<p> Authorize.Net is a payment gateway service provider allowing merchants to accept credit card and electronic checks paymentsn. Authorize.Net claims a user base of over 305,000 merchants, which would make them the Internet's largest payment gateway service provider.  </p> <p> It also provides an instant test account which you can use while your application is being processed.  </p>]
        })
        puts "Authorize.net record was successfuly created"
    end
  end
end
