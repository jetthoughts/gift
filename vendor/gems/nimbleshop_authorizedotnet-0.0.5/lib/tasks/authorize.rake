namespace :authorizedotnet do

  desc 'load Authorize.net record'
  task :load_record => :environment do

    mode = PaymentMethod.mode
    if NimbleshopAuthorizedotnet::Authorizedotnet.where(:mode => mode, :permalink => 'authorizedotnet').any?
      puts "Authorize.net record already exists"
    else
      NimbleshopAuthorizedotnet::Authorizedotnet.create!(
          {
              login_id: '9KSyy53Mh',
              transaction_key: '6H87q9m7jm4urVRX',
              company_name_on_creditcard_statement: 'JetThoughts LLC',
              name: 'Authorize.net',
              mode: mode,
              permalink: 'authorizedotnet',
              description: %Q[<p> Authorize.Net is a payment gateway service provider allowing merchants to accept credit card and electronic checks paymentsn. Authorize.Net claims a user base of over 305,000 merchants, which would make them the Internet's largest payment gateway service provider.  </p> <p> It also provides an instant test account which you can use while your application is being processed.  </p>]
          })
    end
  end
end