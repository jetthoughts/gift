if Nimbleshop.config.use_s3

  unless bucket_name = Nimbleshop.config.s3.bucket_name
    msg = %Q{
      This application's #{Rails.env} environment is configured to use amazon s3.
      However bucket_name to use is not specified at config/nimbleshop.yml .
    }

    raise msg
  end

  CarrierWave.configure do |config|
    config.cache_dir = "#{Rails.root}/tmp/uploads"
    config.storage = :fog
    config.enable_processing = true
    config.fog_directory  = bucket_name
    config.fog_attributes = {'Cache-Control' => 'max-age=315576000'}
    config.fog_public     = true

    config.fog_credentials = {
        provider:               'AWS',
        aws_access_key_id:      Nimbleshop.config.s3.access_key_id,
        aws_secret_access_key:  Nimbleshop.config.s3.secret_access_key,
        region:                 'us-east-1' #TODO make this configurable too
      }
  end

else

  CarrierWave.configure do |config|
    config.storage = :file
    config.enable_processing = true
  end

end
