source :rubygems

gem 'rails', '~> 3.2'
gem 'unicorn'
gem 'unicorn-rails'

group :assets do
  gem 'sass-rails',   '~> 3.2.3'
  gem 'coffee-rails', '~> 3.2.1'
  gem 'uglifier', '>= 1.0.3'
end

gem 'jquery-rails'
gem 'jquery-ui-rails'

gem "haml"
gem 'bson_ext'

gem "mongoid", "~> 2.4"
gem "devise", ">= 1.3.3"
gem "omniauth-facebook"
gem "koala", ">= 1.2"

gem "cancan"
gem "kaminari"
gem "bootstrap-kaminari-views"
gem "has_scope"
gem "show_for"
gem "simple_form", ">= 2.0.0"
gem "carrierwave"
gem 'carrierwave-mongoid', :require => 'carrierwave/mongoid'
gem 'rmagick'
gem "bootstrap-sass", ">= 2.0.1"

gem 'validate_url'
gem "date_validator"
gem 'voteable_mongo'
gem 'state_machine'
gem 'activeadmin'
gem 'activeadmin-mongoid'
gem 'delayed_job_mongoid'

gem 'asin', git: 'git://github.com/XsErG/asin.git', branch: 'develop'
gem 'confiture', git: 'git://github.com/phoet/confiture.git'

gem 'activemerchant'

gem 'valid_email'
gem 'money'

gem 'nimbleshop_core', '0.0.5', :path => 'vendor/gems/nimbleshop_core-0.0.5'
gem 'nimbleshop_authorizedotnet', '0.0.5', :path => 'vendor/gems/nimbleshop_authorizedotnet-0.0.5'
gem 'airbrake'
gem 'therubyracer'
gem 'newrelic_rpm'
gem 'clickatell'
gem 'nokogiri'

group :development do

  gem "haml-rails", require: false

  gem "guard", ">= 0.6.2", require: false
  gem "guard-bundler", ">= 0.1.3", require: false
  gem "guard-rails", ">= 0.0.3", require: false
  gem "guard-spork", require: false
  gem "guard-rspec", ">= 0.4.3", require: false

  gem 'rb-fsevent', require: false

  gem 'growl', require: false
  gem 'libnotify', require: false
  gem 'rb-inotify', require: false
  gem 'quiet_assets'
end

group :test do
  gem "spork", require: false

  gem "capybara"
  gem "capybara-webkit"
  gem "simplecov", :require => false

  gem "database_cleaner", ">= 0.7.1"
  gem "fabrication"
  gem "ffaker"

  gem "mongoid-rspec"
  gem "email_spec", ">= 1.2.1"
  gem 'vcr'
  gem 'webmock'
end

group :development, :test do
  gem "pry-rails"
  gem "rspec-rails", ">= 2.8.1"
end

group :utils do
  gem 'foreman'
end

group :production do
  gem "heroku"
end
