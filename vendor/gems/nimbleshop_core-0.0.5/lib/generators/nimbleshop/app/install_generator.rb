require 'pathname'
require 'rails/generators'
require 'rails/generators/migration'
require 'rails/generators/active_record/migration'

module Nimbleshop
  class InstallGenerator < Rails::Generators::Base

    source_root Pathname.new(File.expand_path('../templates', __FILE__))

    def generate
      copy_files!
      migrate_database!
      ensure_no_mass_protection
      mount
      delete_public_index_html
      delete_test_dir
    end

    protected

    def delete_test_dir
      FileUtils.rm_rf destination_path.join('test')
    end

    def delete_public_index_html
      index_file = destination_path.join('public', 'index.html')
      FileUtils.rm(index_file) if File.exists? index_file
    end

    def mount
      if (routes_file = destination_path.join('config', 'routes.rb')).file?
        mount = %Q{
          mount NimbleshopSimply::Engine,          :at => '/'

          mount NimbleshopAuthorizedotnet::Engine, :at => '/nimbleshop_authorizedotnet'
          mount NimbleshopPaypalwp::Engine,        :at => '/nimbleshop_paypalwp'
          mount NimbleshopSplitable::Engine,       :at => '/nimbleshop_splitable'
          mount NimbleshopCod::Engine,             :at => '/nimbleshop_cod'
        }

        inject_into_file 'config/routes.rb', mount, :after => "Application.routes.draw do\n"
      end
    end

    def ensure_no_mass_protection
      f = 'config/application.rb'
      current = 'config.active_record.whitelist_attributes = true'
      new = 'config.active_record.whitelist_attributes = false'
      gsub_file f, current, new, verbose: true
    end

    def migrate_database!
      puts 'coping migration files'
      run 'bundle exec rake railties:install:migrations'
      run 'bundle exec rake db:create db:migrate'
    end

    def bundle!
      run 'bundle install'
    end

    def copy_files!
      handle_localtunnel_callback_file
      handle_nimbleshop_yml_file

      template "config/initializers/cache_images.rb", "#{destination_path}/config/initializers/cache_images.rb"
      template "config/initializers/carrierwave.rb",  "#{destination_path}/config/initializers/carrierwave.rb"
      template "config/initializers/delayed_job.rb",  "#{destination_path}/config/initializers/delayed_job.rb"
      template "config/initializers/setup_email.rb",  "#{destination_path}/config/initializers/setup_email.rb"
    end

    # Helper method to quickly convert destination_root to a Pathname for easy file path manipulation
    def destination_path
      @destination_path ||= Pathname.new(self.destination_root)
    end

    # do not use template method to copy the file. template method actually executes the code
    #  <%= ENV['S3_ACCESS_KEY_ID'] %> inside nimbleshop.yml rather than copying that code
    def handle_nimbleshop_yml_file
      from = File.expand_path('../templates/config/nimbleshop.yml', __FILE__)
      FileUtils.cp from,  "#{destination_path}/config/nimbleshop.yml"
    end

    def handle_localtunnel_callback_file
      template "config/localtunnel_callback", "#{destination_path}/.localtunnel_callback"

      # make the file executable
      FileUtils.chmod 0755, File.expand_path("#{destination_path}/.localtunnel_callback"), :verbose => true
    end

  end
end
