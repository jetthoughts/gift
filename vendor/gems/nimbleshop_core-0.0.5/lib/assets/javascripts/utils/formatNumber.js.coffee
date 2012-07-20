#= require accounting.js

# This utility function formats a value to a meaningful number.
#
# Usage:
# <%= f.text_field :tax_percentage, class: 'span8', 'data-behavior' => 'number-formatted', 'data-behavior-precision' => 2 %>
#
# Value in the tax field |  After tabbing away the value becomes
# 1.2                    | 1.20
# 1                      | 1.00
# 1.2111                 | 1.21
# abcd                   | 0.00
#

$ ->
  $('[data-behavior~=number-formatted]').on 'focus blur paste change', ()->

    precision = $(this).data('behavior-precision')
    if precision is undefined
      precision = accounting.settings.number.precision

    result = accounting.formatNumber($(this).val(), precision)
    $(this).val(result)

  $('[data-behavior~=number-formatted]').trigger('change')
