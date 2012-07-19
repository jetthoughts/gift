module NimbleshopPaypalwp
  class Engine < ::Rails::Engine
    isolate_namespace NimbleshopPaypalwp

    config.to_prepare do
      ::NimbleshopPaypalwp::Paypalwp
    end

    initializer 'nimbleshop_paypalwp_engine.action_controller' do |app|
      ActiveSupport.on_load :action_controller do
        helper NimbleshopPaypalwp::ExposedHelper
      end
    end

  end
end
