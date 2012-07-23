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

  def currency(amount)
    number_to_currency(amount, unit: '&euro;')
  end
end
