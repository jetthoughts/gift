if Nimbleshop.config.cache_images
  # cache images
  Rails.application.config.static_cache_control = "public, max-age=36000"
end
