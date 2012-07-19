module Nimbleshop
  class Engine < ::Rails::Engine

    engine_name 'nimbleshop_core'

    config.autoload_paths += %W(#{config.root}/lib)
    config.autoload_paths += %W(#{config.root}/lib/nimbleshop)
  end
end
