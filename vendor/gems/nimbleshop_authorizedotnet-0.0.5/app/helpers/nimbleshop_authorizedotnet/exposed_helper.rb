module NimbleshopAuthorizedotnet
  module ExposedHelper

    def nimbleshop_authorizedotnet_next_payment_processing_action(order)
      if order.authorized?
        link_to 'Capture payment', capture_payment_admin_order_path(order), method: :put, class: 'btn btn-success'
      end
    end

    def nimbleshop_authorizedotnet_small_image
      image_tag 'engines/nimbleshop_authorizedotnet/authorizedotnet_small.png', alt: 'authorizedotnet icon'
    end

    def nimbleshop_authorizedotnet_big_image
      image_tag 'engines/nimbleshop_authorizedotnet/authorizedotnet_big.png', alt: 'authorizedotnet logo'
    end

    def nimbleshop_authorizedotnet_order_show_extra_info(order)
      return unless NimbleshopAuthorizedotnet::Authorizedotnet.instance
      render partial: '/nimbleshop_authorizedotnet/payments/order_show_extra_info', locals: { transaction: order.payment_transactions.last }
    end

    def nimbleshop_authorizedotnet_available_payment_options_icons
      return unless NimbleshopAuthorizedotnet::Authorizedotnet.instance
      %w(visa mastercard discover american_express).map { |i| image_tag("engines/nimbleshop_authorizedotnet/#{i}.png") }
    end

    def nimbleshop_authorizedotnet_icon_for_order_payment(order)
      if payment_transaction = order.payment_transactions.last
        cardtype = payment_transaction.data[:cardtype]
        image_tag("engines/nimbleshop_authorizedotnet/#{cardtype}.png", height: '10px')
      end
    end

    def nimbleshop_authorizedotnet_payment_info_for_buyer(order)
      render partial: '/nimbleshop_authorizedotnet/payments/payment_info_for_buyer', locals: { order: order }
    end

    def nimbleshop_authorizedotnet_payment_form(order)
      return unless NimbleshopAuthorizedotnet::Authorizedotnet.instance
      render partial: '/nimbleshop_authorizedotnet/payments/new', locals: {order: order}
    end

    def nimbleshop_authorizedotnet_crud_form
      return unless NimbleshopAuthorizedotnet::Authorizedotnet.instance
      render partial: '/nimbleshop_authorizedotnet/authorizedotnets/edit'
    end

  end
end
