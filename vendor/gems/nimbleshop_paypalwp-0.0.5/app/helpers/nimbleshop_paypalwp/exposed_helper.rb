require 'active_merchant/billing/integrations/action_view_helper'

module NimbleshopPaypalwp
  module ExposedHelper
    include ActiveMerchant::Billing::Integrations::ActionViewHelper

    def nimbleshop_paypalwp_small_image
      image_tag "engines/nimbleshop_paypalwp/paypal_small.png", alt: 'paypal icon'
    end

    def nimbleshop_paypalwp_big_image
      image_tag "engines/nimbleshop_paypalwp/paypal_big.png", alt: 'paypal logo'
    end

    def nimbleshop_paypalwp_order_show_extra_info(order)
      return unless NimbleshopPaypalwp::Paypalwp.first
      render partial: '/nimbleshop_paypalwp/payments/order_show_extra_info', locals: { transaction: order.payment_transactions.last }
    end

    def nimbleshop_paypalwp_available_payment_options_icons
      return unless NimbleshopPaypalwp::Paypalwp.first
      image_tag "engines/nimbleshop_paypalwp/paypal_small.png", alt: 'paypal icon'
    end

    def nimbleshop_paypalwp_icon_for_order_payment(order)
      image_tag "engines/nimbleshop_paypalwp/paypal_small.png", alt: 'paypal icon', height: '10px'
    end

    def update_service_with_attributes(service, order)
      service.customer email: order.email

      service.billing_address order.final_billing_address.attributes.slice(:city, :address1,:address2, :state, :country,:zip)

      service.invoice      order.number
      service.line_items   order.line_items
      service.shipping     order.shipping_cost.to_f.round(2)
      service.tax          order.tax.to_f.round(2)

      service.notify_url         nimbleshop_paypalwp_notify_url
      service.return_url         nimbleshop_paypalwp_return_url(order)
      service.cancel_return_url  nimbleshop_paypalwp_cancel_url(order)
    end

    def nimbleshop_paypalwp_crud_form
      return unless NimbleshopPaypalwp::Paypalwp.first
      render partial: '/nimbleshop_paypalwp/paypalwps/edit'
    end

    def nimbleshop_paypalwp_payment_form(order)
       ActiveMerchant::Billing::Base.integration_mode = Rails.env.production? ? :production : :test
      return unless NimbleshopPaypalwp::Paypalwp.first
      render partial: '/nimbleshop_paypalwp/payments/new', locals: { order: order }
    end

    def nimbleshop_paypalwp_notify_url
      Util.localhost2public_url( '/nimbleshop_paypalwp/paypalwp/notify', nimbleshop_paypalwp_protocol )
    end

    def nimbleshop_paypalwp_return_url(order)
      Util.localhost2public_url( order_path(id: order.number), nimbleshop_paypalwp_protocol )
    end

    def nimbleshop_paypalwp_cancel_url(order)
      Util.localhost2public_url( new_checkout_payment_path, nimbleshop_paypalwp_protocol )
    end

    def nimbleshop_paypalwp_protocol
      NimbleshopPaypalwp::Paypalwp.first.mode == 'production' ? 'https' : 'http'
    end

  end
end
