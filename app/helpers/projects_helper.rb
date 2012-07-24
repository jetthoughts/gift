module ProjectsHelper
  def like_dislike_button card
    if @voted_card == card
      submit_tag t('general.dislike')
    elsif @voted_card.nil?
      submit_tag t('general.like')
    else
      submit_tag t('general.like'), disabled: true
    end
  end

  def format_fee_amount amount
    if amount.blank?
      t('general.fee_blank_amount')
    else
      number_to_currency amount
    end
  end

  def format_total_amount amount
    amount =  @project.donated_amount.blank? ? t('general.no_world') : number_to_currency(amount)
    t('general.total_amount', amount: amount)
  end

  def currency(amount)
    number_to_currency(amount, unit: currency_unit('EUR'))
  end

  def currency_unit(abbr)
    {'EUR' => '&euro;'}[abbr]
  end
end
