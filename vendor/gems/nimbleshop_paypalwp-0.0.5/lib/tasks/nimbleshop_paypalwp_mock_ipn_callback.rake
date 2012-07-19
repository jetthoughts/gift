# This is a rake task that simulates what IPN will POST.
# It posts what was posted by IPN for following purchase.
#
#  Colorful shoes - $191.00
#  Quantity - 1
#  Tax - $2.35
# Shipping and handling - $30.00
# Total - $223.35
#

desc 'sends IPN callback'

namespace :nimbleshop_paypalwp do
  task mock_ipn_callback: :environment do

    unless order_number = ENV['order_number']
      puts 'Usage: rake ipn_callcak order_number=xxxxxxx'
      abort
    end

    base_url = 'http://localhost:3000'
    endpoint = base_url + '/nimbleshop_paypalwp/paypalwp/notify'

    amt =  (Order.find_by_number(order_number).total_amount_in_cents.to_i)/100.00
    params = {
       'invoice' => "#{order_number}",
       'mc_gross' => "#{amt}",
       'payment_gross' => "#{amt}",

       'tax' => '2.35',
       'mc_shipping' => '0.00',
       'mc_handling' => '30.00',
       'mc_gross_1' => '191.00',

       'protection_eligibility' => 'Ineligible',
       'item_number1' => '',
       'payer_id' => '2VC8RD6BEMUT8',
       'payment_date' => '20:16:58 May 29, 2012 PDT',
       'payment_status' => 'Completed',
       'charset' => 'windows-1252',
       'first_name' => 'Neeraj',
       'mc_fee' => '6.78',
       'notify_version' => '3.4',
       'custom' => '6',
       'payer_status' => 'verified',
       'business' => 'seller_1323037155_biz@bigbinary.com',
       'num_cart_items' => '1',
       'mc_handling1' => '0.00',
       'verify_sign' => 'AOSCueeqFRzU.Zi4raNmmkcRNb.uAweHlv9hLj786DzApTlAZsEvUzgh',
       'payer_email' => 'mary_1334795925_per@gmail.com',
       'mc_shipping1' => '0.00',
       'tax1' => '0.00',
       'txn_id' => '50L283347C020742B',
       'payment_type' => 'instant',
       'last_name' => 'Singh',
       'item_name1' => 'Colorful shoes',
       'receiver_email' => 'seller_1323037155_biz@bigbinary.com',
       'payment_fee' => '6.78',
       'quantity1' => '1',
       'receiver_id' => 'EULE94DW3YTH4',
       'txn_type' => 'cart',
       'mc_currency' => 'USD',
       'residence_country' => 'US',
       'test_ipn' => '1',
       'transaction_subject' => '6',
       'ipn_track_id' => 'b8b55bb690d65'
      }


      require 'net/http'
      require 'uri'

      uri = URI.parse(endpoint)
      response = Net::HTTP.post_form(uri, params)

  end
end
