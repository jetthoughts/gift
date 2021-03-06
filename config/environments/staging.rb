Gift::Application.configure do
  # Settings specified here will take precedence over those in config/application.rb

  # Code is not reloaded between requests
  config.cache_classes = true

  # Full error reports are disabled and caching is turned on
  config.consider_all_requests_local = false
  config.action_controller.perform_caching = true

  # Disable Rails's static asset server (Apache or nginx will already do this)
  config.serve_static_assets = false

  # Compress JavaScripts and CSS
  config.assets.compress = true

  # Don't fallback to assets pipeline if a precompiled asset is missed
  config.assets.compile = true

  # Generate digests for assets URLs
  config.assets.digest = true

  FBOOK_APPLICATION_ID = ''
  FBOOK_SECRET_KEY = ''

  # Defaults to Rails.root.join("public/assets")
  # config.assets.manifest = YOUR_PATH

  # Specifies the header that your server uses for sending files
  # config.action_dispatch.x_sendfile_header = "X-Sendfile" # for apache
  # config.action_dispatch.x_sendfile_header = 'X-Accel-Redirect' # for nginx

  # Force all access to the app over SSL, use Strict-Transport-Security, and use secure cookies.
  # config.force_ssl = true

  # See everything in the log (default is :info)
  # config.log_level = :debug

  # Prepend all log lines with the following tags
  # config.log_tags = [ :subdomain, :uuid ]

  # Use a different logger for distributed setups
  # config.logger = ActiveSupport::TaggedLogging.new(SyslogLogger.new)

  # Use a different cache store in production
  # config.cache_store = :mem_cache_store

  # Enable serving of images, stylesheets, and JavaScripts from an asset server
  # config.action_controller.asset_host = "http://assets.example.com"

  # Precompile additional assets (application.js, application.css, and all non-JS/CSS are already added)
  # config.assets.precompile += %w( search.js )

  # Disable delivery errors, bad email addresses will be ignored
  # config.action_mailer.raise_delivery_errors = false

  # Enable threaded mode
  # config.threadsafe!

  # Enable locale fallbacks for I18n (makes lookups for any locale fall back to
  # the I18n.default_locale when a translation can not be found)
  config.i18n.fallbacks = true
  config.assets.precompile += %w[active_admin.css active_admin.js]
  # Send deprecation notices to registered listeners
  config.active_support.deprecation = :notify

  config.action_mailer.default_url_options = {host: 'gift-staging.herokuapp.com'}

  config.action_mailer.delivery_method = :smtp
  config.action_mailer.smtp_settings = {
      :user_name => "giftstaging",
      :password => "a447925824c59c1c",
      :address => "mailtrap.io",
      :port => 2525,
      :authentication => :plain,
  }
  config.after_initialize do
    ActiveMerchant::Billing::Base.gateway_mode = :test
    ActiveMerchant::Billing::PaypalExpressGateway.default_currency = 'EUR'
  end
end

ASIN::Configuration.configure do |config|
  config.secret        = ENV['AWS_SECRET']
  config.key           = ENV['AWS_KEY']
  config.associate_tag = ENV['AWS_ASSOCIATE_TAG']
  config.logger        = nil
end

SMS_CONFIG = %w(3387553)
Clickatell::API.debug_mode = false
