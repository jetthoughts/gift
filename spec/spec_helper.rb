require 'rubygems'
require 'spork'

Spork.prefork do
  ENV["RAILS_ENV"] ||= 'test'


  require 'support/confiture'
  require File.expand_path("../../config/environment", __FILE__)
  require 'simplecov'
  require 'rails/application'
  require 'rails/mongoid'
  require 'rspec/rails'
  require 'rspec/autorun'
  require 'capybara/rspec'
  require 'cancan/matchers'
  require "email_spec"
  require 'vcr'
  SimpleCov.start 'rails'

  Capybara.javascript_driver = :webkit
  Capybara.server_boot_timeout = 50


  Spork.trap_class_method(Rails::Mongoid, :load_models)
  Spork.trap_method(Rails::Application, :reload_routes!)
  Spork.trap_method(Rails::Application::RoutesReloader, :reload!)

  Dir[File.join(File.dirname(__FILE__), 'support', '**', '*.rb')].each { |f| require f }

  RSpec.configure do |config|
    config.include Devise::TestHelpers, :type => :controller
    config.include Mongoid::Matchers

    config.before(:suite) do
      DatabaseCleaner[:mongoid].strategy = :truncation
    end

    config.before(:each) do
      DatabaseCleaner.start
      Capybara.reset_sessions!
    end

    config.after(:each) do
      DatabaseCleaner.clean
    end

    config.around(:each) do |example|
      options = example.metadata[:vcr] || nil
      if options
        name = example.metadata[:full_description].downcase.gsub(/\\\\W+/, "_").split("_", 2).join("/")
        VCR.use_cassette(name, match_requests_on: [:host, :path], &example)
      end
    end
    config.infer_base_class_for_anonymous_controllers = false
  end

  VCR.configure do |config|
    config.ignore_localhost = true
    config.cassette_library_dir = 'spec/cassettes'
    config.hook_into :webmock
  end
end

Spork.each_run do
  Fabrication.clear_definitions
  I18n.backend.reload!
end
