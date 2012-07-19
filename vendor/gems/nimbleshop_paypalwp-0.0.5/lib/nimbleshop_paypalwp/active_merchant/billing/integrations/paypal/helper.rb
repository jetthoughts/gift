module ActiveMerchant #:nodoc:
  module Billing #:nodoc:
    module Integrations #:nodoc:
      module Paypal
        class Helper < ActiveMerchant::Billing::Integrations::Helper

          def initialize(order, account, options = {})
            super

            # indicates we are using thirdparty shopping cart
            add_field('cmd', '_cart')
            add_field('upload', '1')

            add_field('no_shipping', '1')
            add_field('no_note', '1')
            add_field('charset', 'utf-8')
            add_field('address_override', '0')
            add_field('bn', application_id.to_s.slice(0,32)) unless application_id.blank?
          end

          # pass the shipping cost for the whole cart
          mapping :shipping,  'handling_cart'
          mapping :tax,       'tax_cart'

          # mapping header image
          mapping :cpp_header_image, 'cpp_header_image'

          # add line item details, note the amount_x
          # should be price instead of line total
          def line_items(line_items = [])
            line_items.to_enum.with_index(1) do | line_item, index |
              add_field("item_name_#{index}", line_item.product_name)
              add_field("quantity_#{index}",  line_item.quantity)
              add_field("amount_#{index}",    line_item.product_price)
            end
          end
        end
      end
    end
  end
end
