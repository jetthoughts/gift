Gift::Application.configure do
  silence_warnings do
    begin
      require 'pry'
      IRB = Pry
    rescue LoadError
      puts "PRY is not loaded!"
    end
  end

  FBOOK_APPLICATION_ID = ''
  FBOOK_SECRET_KEY = ''

  # Settings specified here will take precedence over those in config/application.rb

  # In the development environment your application's code is reloaded on
  # every request. This slows down response time but is perfect for development
  # since you don't have to restart the web server when you make code changes.
  config.cache_classes = false

  # Log error messages when you accidentally call methods on nil.
  config.whiny_nils = true

  # Show full error reports and disable caching
  config.consider_all_requests_local = true
  config.action_controller.perform_caching = false

  # Don't care if the mailer can't send
  config.action_mailer.raise_delivery_errors = false

  # Print deprecation notices to the Rails logger
  config.active_support.deprecation = :log

  # Only use best-standards-support built into browsers
  config.action_dispatch.best_standards_support = :builtin


  # Do not compress assets
  config.assets.compress = false

  # Expands the lines which load the assets
  config.assets.debug = false

  config.action_mailer.default_url_options = {:host => 'localhost:3000'}
  config.after_initialize do
    ActiveMerchant::Billing::Base.gateway_mode = :test
    ActiveMerchant::Billing::PaypalExpressGateway.default_currency = 'EUR'
  end
end

ASIN::Configuration.configure do |config|
  config.secret        = ''
  config.key           = ''
  config.associate_tag = ''
end

SMS_CONFIG = %w(test)
Clickatell::API.debug_mode = true
