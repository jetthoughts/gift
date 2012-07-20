namespace :nimbleshop do

  namespace :setup do

    desc "sets up database for nimbleshop application"
    task :db => :environment do

      #raise "this task should not be run in production" if Rails.env.production?

      Rake::Task["db:reset"].invoke if Rails.env.development? || Rails.env.test?

      Rake::Task["db:seed"].invoke

      Sampledata::Data.new.populate

      Rake::Task["nimbleshop_splitable:load_record"].invoke
      Rake::Task["nimbleshop_paypalwp:load_record"].invoke
      Rake::Task["nimbleshop_authorizedotnet:load_record"].invoke
      Rake::Task["nimbleshop_cod:load_record"].invoke

      Rake::Task["nimbleshop_splitable:copy_images"].invoke
      Rake::Task["nimbleshop_paypalwp:copy_images"].invoke
      Rake::Task["nimbleshop_authorizedotnet:copy_images"].invoke
      Rake::Task["nimbleshop_cod:copy_images"].invoke

      puts ""
      puts '**** shop is ready with sample data ****'
    end

   end
 end
