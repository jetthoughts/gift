module NimbleshopAuthorizedotnet
  class Engine < ::Rails::Engine

    isolate_namespace NimbleshopAuthorizedotnet

    config.to_prepare do
      ::NimbleshopAuthorizedotnet::Authorizedotnet
    end

    initializer 'nimbleshop_authorizedotnet_engine.action_controller' do |app|
      ActiveSupport.on_load :action_controller do
        helper NimbleshopAuthorizedotnet::ExposedHelper
      end
    end

  end
end
