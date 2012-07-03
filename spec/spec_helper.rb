require 'rubygems'
require 'spork'

Spork.prefork do
  ENV["RAILS_ENV"] ||= 'test'

  require 'simplecov'
  SimpleCov.start 'rails'

  require 'rails/application'
  require 'rails/mongoid'
  require 'capybara/rspec'

  Capybara.javascript_driver = :webkit

  Spork.trap_class_method(Rails::Mongoid, :load_models)
  Spork.trap_method(Rails::Application, :reload_routes!)
  Spork.trap_method(Rails::Application::RoutesReloader, :reload!)

  require File.expand_path("../../config/environment", __FILE__)
  require 'rspec/rails'
  require 'rspec/autorun'

  Capybara.default_host = 'http://localhost'
  Capybara.app_host = 'http://localhost'
  Capybara.server_boot_timeout = 50

  require 'cancan/matchers'

  Dir[File.join(File.dirname(__FILE__), 'support', '**', '*.rb')].each { |f| require f }

  RSpec.configure do |config|
    config.include Devise::TestHelpers, :type => :controller
    config.include Mongoid::Matchers

    config.before(:suite) do
      DatabaseCleaner.strategy = :truncation
    end

    config.before(:each) do
      DatabaseCleaner.start
    end

    config.after(:each) do
      DatabaseCleaner.clean
    end

    config.infer_base_class_for_anonymous_controllers = false
  end
end

Spork.each_run do
  Fabrication.clear_definitions
  I18n.backend.reload!
end