#= require accounting.js

# This utility function formats a value to a meaningful price.
#
# Usage:
# <%= f.text_field :price, :'data-behavior' => 'price-formatted' %>
#
# Value in the price field |  After tabbing away the value becomes
# 1.2                      | 1.20
# 1                        | 1.00
# 1.2111                   | 1.21
# abcd                     | 0.00
#

$ ->
  $('[data-behavior~=price-formatted]').on 'focus blur paste change', ()->

    # do not want comma in cases like 1,234.89
    # do not want $ to be appearing like $23.78
    result = accounting.formatMoney($(this).val(), {thousand: '', symbol: ''})

    $(this).val(result)

  $('[data-behavior~=price-formatted]').trigger('change')
